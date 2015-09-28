{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures             #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE ViewPatterns               #-}

-- Module      : Gen.Solve
-- Copyright   : (c) 2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : provisional
-- Portability : non-portable (GHC extensions)

module Gen.Solve where

import           Control.Applicative
import           Control.Error
import           Control.Lens               hiding (enum)
import           Control.Monad.Except
import           Control.Monad.State.Strict
import           Data.CaseInsensitive       (CI)
import qualified Data.CaseInsensitive       as CI
import           Data.Hashable
import qualified Data.HashMap.Strict        as Map
import qualified Data.HashSet               as Set
import           Data.List                  (intersect)
import           Data.Maybe
import           Data.Semigroup             ((<>))
import           Data.Text                  (Text)
import qualified Data.Text                  as Text
import           Data.Text.Manipulate
import           Debug.Trace
import           Gen.Formatting
import           Gen.Text
import           Gen.Types
import           Prelude                    hiding (sum)

type Seen = Map (CI Text) (Set (CI Text))

data Memo = Memo
    { _typed    :: Map Id TType
    , _derived  :: Map Id [Derive]
    , _prefixed :: Map Id Pre
    , _branches :: Seen
    , _fields   :: Seen
    , _schemas  :: Map Id (Schema Id)
    }

initial :: Memo
initial = Memo mempty mempty mempty mempty mempty mempty

makeLenses ''Memo

type AST = ExceptT Error (State Memo)

reserve :: Flattened -> AST ()
reserve svc = do
    let bs = Set.fromList $ map (CI.mk . idToText) (_svcSchemas svc)
    branches %= Map.insert mempty bs

schema :: Id -> AST (Schema Id)
schema k = do
    m <- uses schemas (Map.lookup k)
    case m of
        Nothing -> failure ("Missing Schema: " % fid) k
        Just v  -> pure v

memo :: Lens' Memo (Map Id v) -> Id -> (Schema Id -> AST v) -> AST v
memo l k f = do
    m <- uses l (Map.lookup k)
    case m of
        Just x  -> return x
        Nothing -> do
            x <- f =<< schema k
            l %= Map.insert k x
            return x

solve :: Id -> AST Solved
solve k = loc "solve" k $ Solved k <$> prefix k <*> schema k <*> typeOf k <*> derive k

typeOf :: Id -> AST TType
typeOf k = loc "typeof" k $ memo typed k go
  where
    go s = fmap may $ case s of
        Obj  {} -> pure (TType k)
        Arr _ r -> TList <$> typeOf r
        Enum {} -> pure (TType k)
        Ref _ r -> typeOf (Free r)
        Any  {} -> pure (TEither (TLit Text) (TLit Int64))
        Lit _ l -> pure (TLit l)
      where
        may | s ^. required           = id
            | isJust (s ^. defaulted) = id
            | otherwise               = TMaybe

derive :: Id -> AST [Derive]
derive k = loc "derive" k $ memo derived k go
  where
    go = \case
        Obj  _ rs -> foldM props dbase (Map.elems rs)
        Arr  _ r  -> mappend dmonoid . intersect dbase <$> derive r
        Enum {}   -> pure denum
        Ref  _ r  -> pure dbase
        Any  _    -> pure dbase
        Lit  _ l  -> pure $
            case l of
                Text -> dbase <> [DOrd, DIsString]
                Bool -> denum
                Time -> dbase
                Date -> dbase
                Nat  -> dbase
                _    -> [DNum, DIntegral, DReal] <> denum

    props ds x = intersect ds <$> derive x

dmonoid = [DMonoid]
denum   = [DOrd, DEnum] <> dbase
dbase   = [DEq, DRead, DShow, DData, DTypeable, DGeneric]

prefix :: Id -> AST Pre
prefix n = loc "prefix" n $ memo prefixed n typ
  where
    typ = \case
        Obj  _ rs   -> field  rs
        Enum _ vs _ -> branch vs
        _           -> pure mempty

    branch vs = do
        p <- uniq branches ("" : acronymPrefixes n) $
            Set.fromList (map CI.mk vs)
        pure (Pre p)

    field rs = do
        let ls = Map.keys rs
            ks = Set.fromList (map (CI.mk . local) ls)
        p <- uniq fields (acronymPrefixes n) ks
        pure (Pre p)

    uniq :: Lens' Memo Seen
         -> [CI Text]
         -> Set (CI Text)
         -> AST Text
    uniq seen [] ks = do
        s <- use seen
        let hs  = acronymPrefixes n
            f x = sformat ("\n" % stext % " => " % shown)
                          (CI.foldedCase x) (Map.lookup x s)
        throwError $
            format ("Error prefixing: " % fid   %
                    "\n  Fields: "      % shown %
                    "\n  Matches: "     % stext)
                   n (Set.toList ks) (foldMap f hs)

    uniq seen (x:xs) ks = do
        m <- uses seen (Map.lookup x)
        case m of
            Just ys | overlap ys ks
                -> uniq seen xs ks
            _   -> do
                seen %= Map.insertWith (<>) x ks
                return (CI.foldedCase x)

overlap :: (Eq a, Hashable a) => Set a -> Set a -> Bool
overlap xs ys = not . Set.null $ Set.intersection xs ys

acronymPrefixes :: Id -> [CI Text]
acronymPrefixes (idToText -> n) = map CI.mk (xs ++ map suffix ys ++ zs)
  where
    -- Take the next char
    suffix x = Text.snoc x c
      where
        c | Text.length x >= 2 = Text.head (Text.drop 1 x)
          | otherwise          = Text.head x

    zs = zipWith (\n x -> Text.snoc x (head (show n))) ([1..] :: [Int]) xs

    xs = catMaybes [r1, r2, r3, r4, r5, r6]
    ys = catMaybes [r1, r2, r3, r4, r6]

    a  = camelAcronym n
    a' = upperAcronym n

    limit = 3

    -- Full name if leq limit
    r1 | Text.length n <= limit = Just n
       | otherwise              = Nothing

    -- VpcPeeringInfo -> VPI
    r2 = toAcronym a

    -- VpcPeeringInfo -> VPCPI
    r3 | x /= r2   = x
       | otherwise = Nothing
      where
        x = toAcronym a'

    -- SomeTestTType -> S
    r4 = Text.toUpper <$> safeHead n

    -- SomeTypes -> STS (retain pural)
    r5 | Text.isSuffixOf "s" n = flip Text.snoc 's' <$> (r2 <|> r3)
       | otherwise             = Nothing

    -- SomeTestTType -> Som
    r6 = Text.take limit <$> listToMaybe (splitWords a)

loc :: String -> Id -> a -> a
loc n r = id --trace (n ++ ": " ++ Text.unpack (idToText r))
