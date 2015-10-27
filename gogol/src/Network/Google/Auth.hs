{-# LANGUAGE BangPatterns               #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}

-- |
-- Module      : Network.Google.Auth
-- Copyright   : (c) 2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : provisional
-- Portability : non-portable (GHC extensions)
--
-- Explicitly specify your Google credentials, or retrieve them
-- from the underlying OS.
module Network.Google.Auth
   (
   -- * Credentials
   -- ** Discovery
   , discover
   , fromFile
   , fromFilePath
   , fromJSONCredentials

   , Credentials    (..)
   , Auth           (..)

   -- ** Thread-safe Storage
   , Store
   , emptyStore

   -- ** Authorizing Requests
   , authorize

   -- ** Constructing Callback URLs
   , formURL
   , redirectURI
   , accountsURL

   -- ** Default Constants
   -- *** Google Compute Engine
   , checkGCEVar

   -- *** Cloud SDK
   , cloudSDKConfigDir
   , cloudSDKConfigPath

   -- *** Application Default Credentials
   , defaultCredentialsFile
   , defaultCredentialsPath

   -- ** Handling Errors
   , AsAuthError    (..)
   , AuthError      (..)

   -- * Credential Types
   , ServiceAccount (..)
   , AuthorizedUser (..)

   -- * OAuth Types
   , OAuthClient    (..)
   , OAuthCode      (..)
   , OAuthScope     (..)
   , OAuthToken     (..)

   -- * Re-exported Types
   , ServiceId      (..)
   , ClientId       (..)
   , AccessToken    (..)
   , RefreshToken   (..)
   , Secret         (..)

   -- * Exchange and Refresh Internals
   , getToken
   , validateToken

   , exchange
   , exchangeCode

   , refresh
   , refreshMetadata
   , refreshToken
   , refreshAssertion
   ) where

import           Control.Applicative
import           Control.Concurrent
import           Control.Exception.Lens
import           Control.Lens                    hiding (coerce, (.=))
import           Control.Monad
import           Control.Monad.Catch
import           Control.Monad.IO.Class
import           Crypto.Hash.Algorithms          (SHA256 (..))
import           Crypto.PubKey.RSA.PKCS15        (signSafer)
import           Crypto.PubKey.RSA.Types         (PrivateKey)
import           Data.Aeson
import           Data.Aeson.Types
import           Data.ByteArray
import           Data.ByteArray.Encoding
import           Data.ByteString                 (ByteString)
import           Data.ByteString.Builder         (Builder)
import qualified Data.ByteString.Builder         as Build
import qualified Data.ByteString.Char8           as BS8
import qualified Data.ByteString.Lazy            as LBS
import           Data.Coerce
import           Data.Default.Class              (def)
import           Data.List                       (intersperse)
import           Data.String
import qualified Data.Text                       as Text
import qualified Data.Text.Encoding              as Text
import qualified Data.Text.Lazy                  as LText
import qualified Data.Text.Lazy.Builder          as TBuild
import qualified Data.Text.Lazy.Encoding         as LText
import           Data.Time
import           Data.Time.Clock.POSIX
import           Data.Typeable
import           Data.X509
import           Data.X509.Memory
import           Network.Google.Compute.Metadata
import           Network.Google.Internal.Logger
import           Network.Google.Prelude          hiding (buildText)
import           Network.HTTP.Conduit            hiding (Request)
import qualified Network.HTTP.Conduit            as Client
import           Network.HTTP.Types
import           System.Directory                (doesFileExist,
                                                  getHomeDirectory)
import           System.Environment              (lookupEnv)
import           System.FilePath                 ((</>))
import           System.Info                     (os)

-- | 1 hour in seconds.
maxTokenLifetimeSeconds :: Int
maxTokenLifetimeSeconds = 3600

-- | The environment variable name which is used to specify the directory
-- containing the @application_default_credentials.json@ generated by @gcloud init@.
--
-- /Default:/ @~\/.config\/gcloud\/application_default_credentials.json@.
cloudSDKConfigDir :: String
cloudSDKConfigDir = "CLOUDSDK_CONFIG"

-- | The environment variable pointing the file with local
-- Application Default Credentials.
defaultCredentialsFile :: String
defaultCredentialsFile = "GOOGLE_APPLICATION_CREDENTIALS"

-- | An error thrown when attempting to read AuthN/AuthZ information.
data AuthError
    = RetrievalError    HttpException
    | MissingFileError  FilePath
    | InvalidFileError  FilePath Text
    | TokenRefreshError Status Text (Maybe Text)
      deriving (Show, Typeable)

instance Exception AuthError

class AsAuthError a where
    -- | A general authentication error.
    _AuthError        :: Prism' a AuthError
    {-# MINIMAL _AuthError #-}

    -- | An error occured while communicating over HTTP with either then
    -- local metadata or remote accounts.google.com endpoints.
    _RetrievalError   :: Prism' a HttpException

    -- | The specified default credentials file could not be found.
    _MissingFileError :: Prism' a FilePath

    -- | An error occured parsing the default credentials file.
    _InvalidFileError :: Prism' a (FilePath, Text)

    -- | An error occured when attempting to refresh a token.
    _TokenRefreshError :: Prism' a (Status, Text, Maybe Text)

    _RetrievalError    = _AuthError . _RetrievalError
    _MissingFileError  = _AuthError . _MissingFileError
    _InvalidFileError  = _AuthError . _InvalidFileError
    _TokenRefreshError = _AuthError . _TokenRefreshError

instance AsAuthError SomeException where
    _AuthError = exception

instance AsAuthError AuthError where
    _AuthError = id

    _RetrievalError = prism RetrievalError $ \case
        RetrievalError   e -> Right e
        x                  -> Left  x

    _MissingFileError = prism MissingFileError $ \case
        MissingFileError f -> Right f
        x                  -> Left  x

    _InvalidFileError = prism
        (uncurry InvalidFileError)
        (\case
            InvalidFileError f e -> Right (f, e)
            x                    -> Left  x)

    _TokenRefreshError = prism
        (\(s, e, d) -> TokenRefreshError s e d)
        (\case
            TokenRefreshError s e d -> Right (s, e, d)
            x                       -> Left  x)

-- | Lookup the @GOOGLE_APPLICATION_CREDENTIALS@ environment variable for the
-- default application credentials filepath.
defaultCredentialsPath :: MonadIO m => m (Maybe FilePath)
defaultCredentialsPath = liftIO (lookupEnv defaultCredentialsFile)

-- | Return the filepath to the Cloud SDK well known file location such as
-- @~\/.config\/gcloud\/application_default_credentials.json@.
cloudSDKConfigPath :: MonadIO m => m FilePath
cloudSDKConfigPath = do
    m <- liftIO (lookupEnv cloudSDKConfigDir)
    case m of
        Just d  -> pure $! d </> "application_default_credentials.json"
        Nothing -> do
            d <- getConfigDirectory
            pure $! d </> "gcloud/application_default_credentials.json"

getConfigDirectory :: MonadIO m => m FilePath
getConfigDirectory = do
    h <- liftIO getHomeDirectory
    if os == "windows"
        then pure h
        else pure $! h </> ".config"

-- | Given a client identifier, client secret, and a list of scopes to authorize,
-- construct a URL that can be used to obtain the 'OAuthCode' required to
-- instantiate 'FromClient'-style credentials.
formURL :: OAuthClient -> [OAuthScope] -> Text
formURL OAuthClient{..} ss =
    LText.toStrict . LText.decodeUtf8 . Build.toLazyByteString $
           buildText accountsURL
        <> "?response_type=code"
        <> "&client_id="    <> buildText _clientId
        <> "&redirect_uri=" <> buildText redirectURI
        <> "&scope="        <> queryEncodeScopes ss

-- | @urn:ietf:wg:oauth:2.0:oob@.
redirectURI :: Text
redirectURI = "urn:ietf:wg:oauth:2.0:oob"

{-| Service Account credentials which are typically generated/download
from the Google Developer console of the following form:

@
{
  "type": "service_account",
  "private_key_id": "303ad77e5efdf2ce952DFa",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n",
  "client_email": "email@serviceaccount.com",
  "client_id": "035-2-310.useraccount.com"
}
@

The private key is used to sign a JSON Web Token (JWT) of the
grant_type @urn:ietf:params:oauth:grant-type:jwt-bearer@, which is sent to
'accountsURL' to obtain a valid 'OAuthToken'. This process requires explicitly
specifying which 'Scope's the resulting 'OAuthToken' is authorized to access.

A 'ServiceAccount' is typically generated through the
Google Developer Console.
-}
data ServiceAccount = ServiceAccount
    { _serviceId         :: !ClientId
    , _serviceEmail      :: !Text
    , _serviceKeyId      :: !Text
    , _servicePrivateKey :: !PrivateKey
    } deriving (Eq, Show)

instance FromJSON ServiceAccount where
    parseJSON = withObject "service_account" $ \o -> do
        bs <- Text.encodeUtf8 <$> o .: "private_key"
        k  <- case listToMaybe (readKeyFileFromMemory bs) of
            Just (PrivKeyRSA k) -> pure k
            _                   ->
                fail "Unable to parse key contents from \"private_key\""
        ServiceAccount
            <$> o .: "client_id"
            <*> o .: "client_email"
            <*> o .: "private_key_id"
            <*> pure k

{-| Authorized User credentials which are typically generated by the Cloud SDK
tools such as @gcloud init@, of the following form:

{
  "type": "authorized_user",
  "client_id": "32555940559.apps.googleusercontent.com",
  "client_secret": "Zms2qjJy2998hD4CTg2ejr2",
  "refresh_token": "1/B3gM1x35v.VtqffS1n5w-rSJ"
}

The secret and refresh token are used to obtain a valid 'OAuthToken' from
'accountsURL' using grant_type @refresh_token@.

An 'AuthorizedUser' is typically generated by the @gcloud init@ command
of the Google CloudSDK Tools.
-}
data AuthorizedUser = AuthorizedUser
    { _userId      :: !ClientId
    , _userRefresh :: !RefreshToken
    , _userSecret  :: !Secret
    } deriving (Eq, Show)

instance FromJSON AuthorizedUser where
    parseJSON = withObject "authorized_user" $ \o -> AuthorizedUser
        <$> o .: "client_id"
        <*> o .: "refresh_token"
        <*> o .: "client_secret"

-- | A client identifier and accompanying secret used to obtain/refresh a token.
data OAuthClient = OAuthClient
    { _clientId     :: !ClientId
    , _clientSecret :: !Secret
    } deriving (Eq, Show)

{-| An OAuth bearer type token of the following form:

@
{
  "token_type": "Bearer",
  "access_token": "eyJhbGci...",
  "refresh_token": "1/B3gq9K...",
  "expires_in": 3600,
  ...
}
@

The '_tokenAccess' field will be inserted verbatim into the
@Authorization: Bearer ...@ header for all HTTP requests.
-}
data OAuthToken = OAuthToken
    { _tokenAccess  :: !AccessToken
    , _tokenRefresh :: !(Maybe RefreshToken)
    , _tokenExpiry  :: !UTCTime
    } deriving (Eq, Show)

instance FromJSON (UTCTime -> OAuthToken) where
    parseJSON = withObject "bearer" $ \o -> do
        t <- o .:  "access_token"
        r <- o .:? "refresh_token"
        e <- o .:  "expires_in" <&> fromInteger
        pure (OAuthToken t r . addUTCTime e)

newtype OAuthCode = OAuthCode { codeToText :: Text }
    deriving (Eq, Ord, Show, Read, IsString, Generic, Typeable, ToText, FromJSON, ToJSON)

-- | The supported credential mechanisms.
data Credentials
    = FromMetadata !ServiceId
      -- ^ Obtain and refresh access tokens from the underlying GCE host metadata
      -- at @http:\/\/169.254.169.254@.

    | FromClient !OAuthClient !OAuthCode
      -- ^ Obtain and refresh access tokens using the specified client secret
      -- and authorization code obtained from.
      --
      -- See the <https://developers.google.com/accounts/docs/OAuth2InstalledApp OAuth2 Installed Application>
      -- documentation for more information.

    | FromAccount  !ServiceAccount ![OAuthScope]
      -- ^ Use the specified @service_account@ and scopes to sign and request
      -- an access token. The 'ServiceAccount' will also be used for subsequent
      -- token refreshes.
      --
      -- A 'ServiceAccount' is typically generated through the
      -- Google Developer Console.

    | FromUser !AuthorizedUser
      -- ^ Use the specified @authorized_user@ to obtain and refresh access tokens.
      --
      -- An 'AuthorizedUser' is typically created by the @gcloud init@ command
      -- of the Google CloudSDK Tools.

-- | A credentials value in one of two possible states, pre-exchange and
-- containing a valid, but possibly expired access token.
data Auth
    = Exchange !Credentials
      -- ^ Signifies that the initial token refresh has not occured, and the
      -- 'Credentials' need to be signed and exchanged for a valid 'OAuthToken'.

    | Refresh  !Credentials !OAuthToken
      -- ^ An 'OAuthToken' that can potentially be expired, with the original
      -- credentials that can be used to perform a refresh.

type Store = MVar Auth

-- | Construct storage containing the credentials which have not yet been
-- exchanged or refreshed.
emptyStore :: MonadIO m => Credentials -> m Store
emptyStore !c = liftIO . newMVar $ Exchange c

-- | Attempt credentials discovery via the following steps:
--
-- * Read the default credentials from a file specified by
-- the environment variable @GOOGLE_APPLICATION_CREDENTIALS@ if it exists.
--
-- * Read the platform equivalent of @~\/.config\/gcloud\/application_default_credentials.json@ if it exists.
-- The @~/.config@ component of the path can be overriden by the environment
-- variable @CLOUDSDK_CONFIG@ if it exists.
--
-- * Retrieve the default service account application credentials if
-- running on GCE.
--
-- The specified 'Scope's are used to authorize any @service_account@ that is
-- found with the appropriate scopes, otherwise they are not used. See the
-- top-level module of each individual @gogol-*@ library for a list of available
-- scopes, such as @Network.Google.Compute.computeScope@.
discover :: (MonadIO m, MonadCatch m)
         => [OAuthScope]
         -> Manager
         -> m Credentials
discover ss m =
    catching _MissingFileError (fromFile ss) $ \f -> do
        p <- isGCE m
        unless p $
            throwingM _MissingFileError f
        pure $! FromMetadata "default"

-- | Attempt to load either a @service_account@ or @authorized_user@ formatted
-- file to obtain the credentials neccessary to perform a token refresh.
--
-- The specified 'Scope's are used to authorize any @service_account@ that is
-- found with the appropriate scopes, otherwise they are not used. See the
-- top-level module of each individual @gogol-*@ library for a list of available
-- scopes, such as @Network.Google.Compute.computeScope@.
--
-- /See:/ 'cloudSDKConfigPath', 'defaultCredentialsPath'.
fromFile :: (MonadIO m, MonadCatch m) => [OAuthScope] -> m Credentials
fromFile ss = do
    f <- defaultCredentialsPath
    case f of
        Just x  -> fromFilePath ss x
        Nothing -> do
            x <- cloudSDKConfigPath
            fromFilePath ss x

-- | Attempt to load either a @service_account@ or @authorized_user@ formatted
-- file to obtain the credentials neccessary to perform a token refresh from
-- the specified file.
--
-- The specified 'Scope's are used to authorize any @service_account@ that is
-- found with the appropriate scopes, otherwise they are not used. See the
-- top-level module of each individual @gogol-*@ library for a list of available
-- scopes, such as @Network.Google.Compute.computeScope@.
fromFilePath :: (MonadIO m, MonadCatch m)
             => [OAuthScope]
             -> FilePath
             -> m Credentials
fromFilePath ss f = do
    p  <- liftIO (doesFileExist f)
    unless p $
        throwM (MissingFileError f)
    bs <- liftIO (LBS.readFile f)
    either (throwM . InvalidFileError f . Text.pack) pure
           (fromJSONCredentials ss bs)

fromJSONCredentials :: [OAuthScope]
                    -> LBS.ByteString
                    -> Either String Credentials
fromJSONCredentials ss bs = do
    v <- eitherDecode' bs
    let x = (`FromAccount` ss) <$> parseEither parseJSON v
        y = FromUser           <$> parseEither parseJSON v
    case (x, y) of
        (Left xe, Left ye) -> Left $
              "Failed parsing service_account: " ++ xe ++
            ", Failed parsing authorized_user: " ++ ye
        _                  -> x <|> y

authorize :: (MonadIO m, MonadCatch m)
          => Client.Request
          -> Store
          -> Logger
          -> Manager
          -> m Client.Request
authorize rq s l m = bearer <$> getToken s l m
  where
    bearer t = rq
        { Client.requestHeaders =
            ( hAuthorization
            , "Bearer " <> Text.encodeUtf8 (accessToText (_tokenAccess t))
            ) : Client.requestHeaders rq
        }

getToken :: (MonadIO m, MonadCatch m)
         => Store
         -> Logger
         -> Manager
         -> m OAuthToken
getToken s l m = do
    x  <- liftIO (readMVar s)
    mx <- validateToken x
    case mx of
        Just t  -> pure t
        Nothing -> liftIO . modifyMVar s $ \y -> do
            my <- validateToken y
            case my of
                Just t  -> pure (y, t)
                Nothing ->
                    case y of
                        Exchange c -> do
                            t <- exchange c   l m
                            pure (Refresh c t, t)
                        Refresh c t -> do
                            t' <- refresh c t l m
                            pure (Refresh c t', t')

validateToken :: MonadIO m => Auth -> m (Maybe OAuthToken)
validateToken Exchange {}   = pure Nothing
validateToken (Refresh _ t) = do
    ts <- liftIO getCurrentTime
    if ts < _tokenExpiry t
        then pure (Just t)
        else pure Nothing

exchange :: (MonadIO m, MonadCatch m)
         => Credentials
         -> Logger
         -> Manager
         -> m OAuthToken
exchange c l m =
    case c of
        FromMetadata s                  -> refreshMetadata  s    l m
        FromAccount  a  ss              -> refreshAssertion a ss l m
        FromClient   c' n               -> exchangeCode     c' n l m
        FromUser     AuthorizedUser{..} ->
            refreshToken _userId _userSecret (Just _userRefresh) l m

exchangeCode :: (MonadIO m, MonadCatch m)
             => OAuthClient
             -> OAuthCode
             -> Logger
             -> Manager
             -> m OAuthToken
exchangeCode OAuthClient{..} n = refreshRequest $
    accountsRequest
        { Client.requestBody = buildBody $
               "grant_type=authorization_code"
            <> "&client_id="     <> buildText _clientId
            <> "&client_secret=" <> buildText _clientSecret
            <> "&code="          <> buildText n
            <> "&redirect_uri="  <> buildText redirectURI
        }

refresh :: (MonadIO m, MonadCatch m)
        => Credentials
        -> OAuthToken
        -> Logger
        -> Manager
        -> m OAuthToken
refresh c OAuthToken{..} l m =
    case c of
        FromMetadata s                  -> refreshMetadata  s    l m
        FromAccount  a ss               -> refreshAssertion a ss l m
        FromClient   OAuthClient{..} _  ->
            refreshToken _clientId _clientSecret _tokenRefresh   l m
        FromUser     AuthorizedUser{..} ->
            refreshToken _userId _userSecret
                (_tokenRefresh <|> Just _userRefresh)            l m

refreshMetadata :: (MonadIO m, MonadCatch m)
                => ServiceId
                -> Logger
                -> Manager
                -> m OAuthToken
refreshMetadata s = refreshRequest $
    metadataRequest
        { Client.path = "instance/service-accounts/"
            <> Text.encodeUtf8 (serviceIdToText s)
            <> "/token"
        }

refreshToken :: (MonadIO m, MonadCatch m)
             => ClientId
             -> Secret
             -> Maybe RefreshToken
             -> Logger
             -> Manager
             -> m OAuthToken
refreshToken c s r = refreshRequest $
    accountsRequest
        { Client.requestBody = buildBody $
               "grant_type=refresh_token"
            <> "&client_id="     <> buildText c
            <> "&client_secret=" <> buildText s
            <> maybe mempty ("&refresh_token=" <>) (buildText <$> r)
        }

refreshAssertion :: (MonadIO m, MonadCatch m)
                 => ServiceAccount
                 -> [OAuthScope]
                 -> Logger
                 -> Manager
                 -> m OAuthToken
refreshAssertion s ss l m = do
    b <- encodeJWTBearer s ss
    let rq = accountsRequest
           { Client.requestBody = buildBody $
                  "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer"
               <> "&assertion="
               <> Build.byteString b
           }
    refreshRequest rq l m

encodeJWTBearer :: (MonadIO m, MonadThrow m)
                => ServiceAccount
                -> [OAuthScope]
                -> m ByteString
encodeJWTBearer s ss = liftIO $ do
    i <- input . truncate <$> getPOSIXTime
    r <- signSafer (Just SHA256) (_servicePrivateKey s) i
    either failure (pure . concat' i) r
  where
    concat' i x = i <> "." <> signature (base64 x)

    failure e = throwM $
        TokenRefreshError (toEnum 400) (Text.pack (show e)) Nothing

    signature bs =
        case BS8.unsnoc bs of
            Nothing         -> mempty
            Just (bs', x)
                | x == '='  -> bs'
                | otherwise -> bs

    input n = header <> "." <> payload
      where
        header = base64Encode
            [ "alg" .= ("RS256" :: Text)
            , "typ" .= ("JWT"   :: Text)
            , "kid" .= _serviceKeyId s
            ]

        payload = base64Encode
            [ "aud"   .= accountsURL
            , "scope" .= concatScopes ss
            , "iat"   .= n
            , "exp"   .= (n + maxTokenLifetimeSeconds)
            , "iss"   .= _serviceEmail s
            ]

accountsURL :: Text
accountsURL = "https://accounts.google.com/o/oauth2/token"

accountsRequest :: Client.Request
accountsRequest = def
    { Client.host           = "accounts.google.com"
    , Client.port           = 443
    , Client.secure         = True
    , Client.checkStatus    = \_ _ _ -> Nothing
    , Client.method         = "POST"
    , Client.path           = "/o/oauth2/token"
    , Client.requestHeaders =
        [ (hContentType, "application/x-www-form-urlencoded")
        ]
    }

refreshRequest :: (MonadIO m, MonadCatch m)
               => Client.Request
               -> Logger
               -> Manager
               -> m OAuthToken
refreshRequest rq l m = do
    logDebug l rq                          -- debug:ClientRequest

    rs <- liftIO (httpLbs rq m) `catch` (throwM . RetrievalError)

    let bs = responseBody   rs
        s  = responseStatus rs

    logDebug l rs                          -- debug:ClientResponse
    logTrace l $ "[Response Body]\n" <> bs -- trace:ResponseBody

    if fromEnum s == 200
        then success s bs
        else failure s bs
  where
    success s bs = do
        f  <- parseErr s bs
        ts <- liftIO getCurrentTime
        pure (f ts)

    failure s bs = do
        let e = "Failure refreshing token from " <> host <> path
        logError l $ "[Refresh Error] " <> build e
        case parseLBS bs of
            Right x -> refreshErr s (_error x) (_description x)
            Left  _ -> refreshErr s e Nothing

    parseErr s bs =
        case parseLBS bs of
            Right !x -> pure x
            Left   e -> do
                logError l $
                    "[Parse Error] Failure parsing token refresh " <> build e
                refreshErr s e Nothing

    refreshErr :: MonadThrow m => Status -> Text -> Maybe Text -> m a
    refreshErr s e = throwM . TokenRefreshError s e

    host = Text.decodeUtf8 (Client.host rq)
    path = Text.decodeUtf8 (Client.path rq)

parseLBS :: FromJSON a => LBS.ByteString -> Either Text a
parseLBS = either (Left . Text.pack) Right . eitherDecode'

base64Encode :: [Pair] -> ByteString
base64Encode = base64 . LBS.toStrict . encode . object

base64 :: ByteArray a => a -> ByteString
base64 = convertToBase Base64URLUnpadded

buildBody :: Builder -> RequestBody
buildBody = RequestBodyLBS . Build.toLazyByteString

buildText :: ToText a => a -> Builder
buildText = build . toText

queryEncodeScopes :: [OAuthScope] -> Build.Builder
queryEncodeScopes =
      mconcat
    . intersperse "+"
    . map (urlEncodeBuilder True . Text.encodeUtf8)
    . coerce

concatScopes :: [OAuthScope] -> LText.Text
concatScopes =
      TBuild.toLazyText
    . mconcat
    . intersperse " "
    . map TBuild.fromText
    . coerce

data RefreshError = RefreshError
    { _error       :: !Text
    , _description :: !(Maybe Text)
    }

instance FromJSON RefreshError where
    parseJSON = withObject "refresh_error" $ \o -> RefreshError
        <$> o .:  "error"
        <*> o .:? "error_description"
