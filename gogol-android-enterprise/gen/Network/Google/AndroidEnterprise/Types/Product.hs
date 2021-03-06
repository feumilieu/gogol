{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- |
-- Module      : Network.Google.AndroidEnterprise.Types.Product
-- Copyright   : (c) 2015-2016 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
module Network.Google.AndroidEnterprise.Types.Product where

import           Network.Google.AndroidEnterprise.Types.Sum
import           Network.Google.Prelude

-- | A group license object indicates a product that an enterprise admin has
-- approved for use in the enterprise. The product may be free or paid. For
-- free products, a group license object is created in these cases: if the
-- enterprise admin approves a product in Google Play, if the product is
-- added to a collection, or if an entitlement for the product is created
-- for a user via the API. For paid products, a group license object is
-- only created as part of the first bulk purchase of that product in
-- Google Play by the enterprise admin. The API can be used to query group
-- licenses; the available information includes the total number of
-- licenses purchased (for paid products) and the total number of licenses
-- that have been provisioned, that is, the total number of user
-- entitlements in existence for the product. Group license objects are
-- never deleted. If, for example, a free app is added to a collection and
-- then removed, the group license will remain, allowing the enterprise
-- admin to keep track of any remaining entitlements. An enterprise admin
-- may indicate they are no longer interested in the group license by
-- marking it as unapproved in Google Play.
--
-- /See:/ 'groupLicense' smart constructor.
data GroupLicense = GroupLicense'
    { _glKind            :: !Text
    , _glNumProvisioned  :: !(Maybe (Textual Int32))
    , _glNumPurchased    :: !(Maybe (Textual Int32))
    , _glApproval        :: !(Maybe Text)
    , _glProductId       :: !(Maybe Text)
    , _glAcquisitionKind :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'GroupLicense' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'glKind'
--
-- * 'glNumProvisioned'
--
-- * 'glNumPurchased'
--
-- * 'glApproval'
--
-- * 'glProductId'
--
-- * 'glAcquisitionKind'
groupLicense
    :: GroupLicense
groupLicense =
    GroupLicense'
    { _glKind = "androidenterprise#groupLicense"
    , _glNumProvisioned = Nothing
    , _glNumPurchased = Nothing
    , _glApproval = Nothing
    , _glProductId = Nothing
    , _glAcquisitionKind = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#groupLicense\".
glKind :: Lens' GroupLicense Text
glKind = lens _glKind (\ s a -> s{_glKind = a})

-- | The total number of provisioned licenses for this product. Returned by
-- read operations, but ignored in write operations.
glNumProvisioned :: Lens' GroupLicense (Maybe Int32)
glNumProvisioned
  = lens _glNumProvisioned
      (\ s a -> s{_glNumProvisioned = a})
      . mapping _Coerce

-- | The number of purchased licenses (possibly in multiple purchases). If
-- this field is omitted then there is no limit on the number of licenses
-- that can be provisioned (e.g. if the acquisition kind is \"free\").
glNumPurchased :: Lens' GroupLicense (Maybe Int32)
glNumPurchased
  = lens _glNumPurchased
      (\ s a -> s{_glNumPurchased = a})
      . mapping _Coerce

-- | Whether the product to which this group license relates is currently
-- approved by the enterprise, as either \"approved\" or \"unapproved\".
-- Products are approved when a group license is first created, but this
-- approval may be revoked by an enterprise admin via Google Play.
-- Unapproved products will not be visible to end users in collections and
-- new entitlements to them should not normally be created.
glApproval :: Lens' GroupLicense (Maybe Text)
glApproval
  = lens _glApproval (\ s a -> s{_glApproval = a})

-- | The ID of the product that the license is for, e.g.
-- \"app:com.google.android.gm\".
glProductId :: Lens' GroupLicense (Maybe Text)
glProductId
  = lens _glProductId (\ s a -> s{_glProductId = a})

-- | How this group license was acquired. \"bulkPurchase\" means that this
-- group license object was created because the enterprise purchased
-- licenses for this product; this is \"free\" otherwise (for free
-- products).
glAcquisitionKind :: Lens' GroupLicense (Maybe Text)
glAcquisitionKind
  = lens _glAcquisitionKind
      (\ s a -> s{_glAcquisitionKind = a})

instance FromJSON GroupLicense where
        parseJSON
          = withObject "GroupLicense"
              (\ o ->
                 GroupLicense' <$>
                   (o .:? "kind" .!= "androidenterprise#groupLicense")
                     <*> (o .:? "numProvisioned")
                     <*> (o .:? "numPurchased")
                     <*> (o .:? "approval")
                     <*> (o .:? "productId")
                     <*> (o .:? "acquisitionKind"))

instance ToJSON GroupLicense where
        toJSON GroupLicense'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _glKind),
                  ("numProvisioned" .=) <$> _glNumProvisioned,
                  ("numPurchased" .=) <$> _glNumPurchased,
                  ("approval" .=) <$> _glApproval,
                  ("productId" .=) <$> _glProductId,
                  ("acquisitionKind" .=) <$> _glAcquisitionKind])

-- | The store page resources for the enterprise.
--
-- /See:/ 'storeLayoutPagesListResponse' smart constructor.
data StoreLayoutPagesListResponse = StoreLayoutPagesListResponse'
    { _slplrKind :: !Text
    , _slplrPage :: !(Maybe [StorePage])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'StoreLayoutPagesListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'slplrKind'
--
-- * 'slplrPage'
storeLayoutPagesListResponse
    :: StoreLayoutPagesListResponse
storeLayoutPagesListResponse =
    StoreLayoutPagesListResponse'
    { _slplrKind = "androidenterprise#storeLayoutPagesListResponse"
    , _slplrPage = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#storeLayoutPagesListResponse\".
slplrKind :: Lens' StoreLayoutPagesListResponse Text
slplrKind
  = lens _slplrKind (\ s a -> s{_slplrKind = a})

-- | A store page of an enterprise.
slplrPage :: Lens' StoreLayoutPagesListResponse [StorePage]
slplrPage
  = lens _slplrPage (\ s a -> s{_slplrPage = a}) .
      _Default
      . _Coerce

instance FromJSON StoreLayoutPagesListResponse where
        parseJSON
          = withObject "StoreLayoutPagesListResponse"
              (\ o ->
                 StoreLayoutPagesListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#storeLayoutPagesListResponse")
                     <*> (o .:? "page" .!= mempty))

instance ToJSON StoreLayoutPagesListResponse where
        toJSON StoreLayoutPagesListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _slplrKind),
                  ("page" .=) <$> _slplrPage])

-- | A service account that can be used to authenticate as the enterprise to
-- API calls that require such authentication.
--
-- /See:/ 'enterpriseAccount' smart constructor.
data EnterpriseAccount = EnterpriseAccount'
    { _eaKind         :: !Text
    , _eaAccountEmail :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'EnterpriseAccount' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'eaKind'
--
-- * 'eaAccountEmail'
enterpriseAccount
    :: EnterpriseAccount
enterpriseAccount =
    EnterpriseAccount'
    { _eaKind = "androidenterprise#enterpriseAccount"
    , _eaAccountEmail = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#enterpriseAccount\".
eaKind :: Lens' EnterpriseAccount Text
eaKind = lens _eaKind (\ s a -> s{_eaKind = a})

-- | The email address of the service account.
eaAccountEmail :: Lens' EnterpriseAccount (Maybe Text)
eaAccountEmail
  = lens _eaAccountEmail
      (\ s a -> s{_eaAccountEmail = a})

instance FromJSON EnterpriseAccount where
        parseJSON
          = withObject "EnterpriseAccount"
              (\ o ->
                 EnterpriseAccount' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#enterpriseAccount")
                     <*> (o .:? "accountEmail"))

instance ToJSON EnterpriseAccount where
        toJSON EnterpriseAccount'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _eaKind),
                  ("accountEmail" .=) <$> _eaAccountEmail])

-- | The collection resources for the enterprise.
--
-- /See:/ 'collectionsListResponse' smart constructor.
data CollectionsListResponse = CollectionsListResponse'
    { _clrKind       :: !Text
    , _clrCollection :: !(Maybe [Collection])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'CollectionsListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'clrKind'
--
-- * 'clrCollection'
collectionsListResponse
    :: CollectionsListResponse
collectionsListResponse =
    CollectionsListResponse'
    { _clrKind = "androidenterprise#collectionsListResponse"
    , _clrCollection = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#collectionsListResponse\".
clrKind :: Lens' CollectionsListResponse Text
clrKind = lens _clrKind (\ s a -> s{_clrKind = a})

-- | An ordered collection of products which can be made visible on the
-- Google Play Store to a selected group of users.
clrCollection :: Lens' CollectionsListResponse [Collection]
clrCollection
  = lens _clrCollection
      (\ s a -> s{_clrCollection = a})
      . _Default
      . _Coerce

instance FromJSON CollectionsListResponse where
        parseJSON
          = withObject "CollectionsListResponse"
              (\ o ->
                 CollectionsListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#collectionsListResponse")
                     <*> (o .:? "collection" .!= mempty))

instance ToJSON CollectionsListResponse where
        toJSON CollectionsListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _clrKind),
                  ("collection" .=) <$> _clrCollection])

-- | A typed value for the restriction.
--
-- /See:/ 'appRestrictionsSchemaRestrictionRestrictionValue' smart constructor.
data AppRestrictionsSchemaRestrictionRestrictionValue = AppRestrictionsSchemaRestrictionRestrictionValue'
    { _arsrrvValueMultiselect :: !(Maybe [Text])
    , _arsrrvValueBool        :: !(Maybe Bool)
    , _arsrrvValueInteger     :: !(Maybe (Textual Int32))
    , _arsrrvType             :: !(Maybe Text)
    , _arsrrvValueString      :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'AppRestrictionsSchemaRestrictionRestrictionValue' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'arsrrvValueMultiselect'
--
-- * 'arsrrvValueBool'
--
-- * 'arsrrvValueInteger'
--
-- * 'arsrrvType'
--
-- * 'arsrrvValueString'
appRestrictionsSchemaRestrictionRestrictionValue
    :: AppRestrictionsSchemaRestrictionRestrictionValue
appRestrictionsSchemaRestrictionRestrictionValue =
    AppRestrictionsSchemaRestrictionRestrictionValue'
    { _arsrrvValueMultiselect = Nothing
    , _arsrrvValueBool = Nothing
    , _arsrrvValueInteger = Nothing
    , _arsrrvType = Nothing
    , _arsrrvValueString = Nothing
    }

-- | The list of string values - this will only be present if type is
-- multiselect.
arsrrvValueMultiselect :: Lens' AppRestrictionsSchemaRestrictionRestrictionValue [Text]
arsrrvValueMultiselect
  = lens _arsrrvValueMultiselect
      (\ s a -> s{_arsrrvValueMultiselect = a})
      . _Default
      . _Coerce

-- | The boolean value - this will only be present if type is bool.
arsrrvValueBool :: Lens' AppRestrictionsSchemaRestrictionRestrictionValue (Maybe Bool)
arsrrvValueBool
  = lens _arsrrvValueBool
      (\ s a -> s{_arsrrvValueBool = a})

-- | The integer value - this will only be present if type is integer.
arsrrvValueInteger :: Lens' AppRestrictionsSchemaRestrictionRestrictionValue (Maybe Int32)
arsrrvValueInteger
  = lens _arsrrvValueInteger
      (\ s a -> s{_arsrrvValueInteger = a})
      . mapping _Coerce

-- | The type of the value being provided.
arsrrvType :: Lens' AppRestrictionsSchemaRestrictionRestrictionValue (Maybe Text)
arsrrvType
  = lens _arsrrvType (\ s a -> s{_arsrrvType = a})

-- | The string value - this will be present for types string, choice and
-- hidden.
arsrrvValueString :: Lens' AppRestrictionsSchemaRestrictionRestrictionValue (Maybe Text)
arsrrvValueString
  = lens _arsrrvValueString
      (\ s a -> s{_arsrrvValueString = a})

instance FromJSON
         AppRestrictionsSchemaRestrictionRestrictionValue
         where
        parseJSON
          = withObject
              "AppRestrictionsSchemaRestrictionRestrictionValue"
              (\ o ->
                 AppRestrictionsSchemaRestrictionRestrictionValue' <$>
                   (o .:? "valueMultiselect" .!= mempty) <*>
                     (o .:? "valueBool")
                     <*> (o .:? "valueInteger")
                     <*> (o .:? "type")
                     <*> (o .:? "valueString"))

instance ToJSON
         AppRestrictionsSchemaRestrictionRestrictionValue
         where
        toJSON
          AppRestrictionsSchemaRestrictionRestrictionValue'{..}
          = object
              (catMaybes
                 [("valueMultiselect" .=) <$> _arsrrvValueMultiselect,
                  ("valueBool" .=) <$> _arsrrvValueBool,
                  ("valueInteger" .=) <$> _arsrrvValueInteger,
                  ("type" .=) <$> _arsrrvType,
                  ("valueString" .=) <$> _arsrrvValueString])

-- | The state of a user\'s device, as accessed by the getState and setState
-- methods on device resources.
--
-- /See:/ 'deviceState' smart constructor.
data DeviceState = DeviceState'
    { _dsKind         :: !Text
    , _dsAccountState :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'DeviceState' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'dsKind'
--
-- * 'dsAccountState'
deviceState
    :: DeviceState
deviceState =
    DeviceState'
    { _dsKind = "androidenterprise#deviceState"
    , _dsAccountState = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#deviceState\".
dsKind :: Lens' DeviceState Text
dsKind = lens _dsKind (\ s a -> s{_dsKind = a})

-- | The state of the Google account on the device. \"enabled\" indicates
-- that the Google account on the device can be used to access Google
-- services (including Google Play), while \"disabled\" means that it
-- cannot. A new device is initially in the \"disabled\" state.
dsAccountState :: Lens' DeviceState (Maybe Text)
dsAccountState
  = lens _dsAccountState
      (\ s a -> s{_dsAccountState = a})

instance FromJSON DeviceState where
        parseJSON
          = withObject "DeviceState"
              (\ o ->
                 DeviceState' <$>
                   (o .:? "kind" .!= "androidenterprise#deviceState")
                     <*> (o .:? "accountState"))

instance ToJSON DeviceState where
        toJSON DeviceState'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _dsKind),
                  ("accountState" .=) <$> _dsAccountState])

-- | The user resources for the group license.
--
-- /See:/ 'groupLicenseUsersListResponse' smart constructor.
data GroupLicenseUsersListResponse = GroupLicenseUsersListResponse'
    { _glulrKind :: !Text
    , _glulrUser :: !(Maybe [User])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'GroupLicenseUsersListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'glulrKind'
--
-- * 'glulrUser'
groupLicenseUsersListResponse
    :: GroupLicenseUsersListResponse
groupLicenseUsersListResponse =
    GroupLicenseUsersListResponse'
    { _glulrKind = "androidenterprise#groupLicenseUsersListResponse"
    , _glulrUser = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#groupLicenseUsersListResponse\".
glulrKind :: Lens' GroupLicenseUsersListResponse Text
glulrKind
  = lens _glulrKind (\ s a -> s{_glulrKind = a})

-- | A user of an enterprise.
glulrUser :: Lens' GroupLicenseUsersListResponse [User]
glulrUser
  = lens _glulrUser (\ s a -> s{_glulrUser = a}) .
      _Default
      . _Coerce

instance FromJSON GroupLicenseUsersListResponse where
        parseJSON
          = withObject "GroupLicenseUsersListResponse"
              (\ o ->
                 GroupLicenseUsersListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#groupLicenseUsersListResponse")
                     <*> (o .:? "user" .!= mempty))

instance ToJSON GroupLicenseUsersListResponse where
        toJSON GroupLicenseUsersListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _glulrKind),
                  ("user" .=) <$> _glulrUser])

--
-- /See:/ 'tokenPagination' smart constructor.
data TokenPagination = TokenPagination'
    { _tpNextPageToken     :: !(Maybe Text)
    , _tpPreviousPageToken :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'TokenPagination' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'tpNextPageToken'
--
-- * 'tpPreviousPageToken'
tokenPagination
    :: TokenPagination
tokenPagination =
    TokenPagination'
    { _tpNextPageToken = Nothing
    , _tpPreviousPageToken = Nothing
    }

tpNextPageToken :: Lens' TokenPagination (Maybe Text)
tpNextPageToken
  = lens _tpNextPageToken
      (\ s a -> s{_tpNextPageToken = a})

tpPreviousPageToken :: Lens' TokenPagination (Maybe Text)
tpPreviousPageToken
  = lens _tpPreviousPageToken
      (\ s a -> s{_tpPreviousPageToken = a})

instance FromJSON TokenPagination where
        parseJSON
          = withObject "TokenPagination"
              (\ o ->
                 TokenPagination' <$>
                   (o .:? "nextPageToken") <*>
                     (o .:? "previousPageToken"))

instance ToJSON TokenPagination where
        toJSON TokenPagination'{..}
          = object
              (catMaybes
                 [("nextPageToken" .=) <$> _tpNextPageToken,
                  ("previousPageToken" .=) <$> _tpPreviousPageToken])

-- | Information on an approval URL.
--
-- /See:/ 'approvalURLInfo' smart constructor.
data ApprovalURLInfo = ApprovalURLInfo'
    { _auiApprovalURL :: !(Maybe Text)
    , _auiKind        :: !Text
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ApprovalURLInfo' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'auiApprovalURL'
--
-- * 'auiKind'
approvalURLInfo
    :: ApprovalURLInfo
approvalURLInfo =
    ApprovalURLInfo'
    { _auiApprovalURL = Nothing
    , _auiKind = "androidenterprise#approvalUrlInfo"
    }

-- | A URL that displays a product\'s permissions and that can also be used
-- to approve the product with the Products.approve call.
auiApprovalURL :: Lens' ApprovalURLInfo (Maybe Text)
auiApprovalURL
  = lens _auiApprovalURL
      (\ s a -> s{_auiApprovalURL = a})

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#approvalUrlInfo\".
auiKind :: Lens' ApprovalURLInfo Text
auiKind = lens _auiKind (\ s a -> s{_auiKind = a})

instance FromJSON ApprovalURLInfo where
        parseJSON
          = withObject "ApprovalURLInfo"
              (\ o ->
                 ApprovalURLInfo' <$>
                   (o .:? "approvalUrl") <*>
                     (o .:? "kind" .!=
                        "androidenterprise#approvalUrlInfo"))

instance ToJSON ApprovalURLInfo where
        toJSON ApprovalURLInfo'{..}
          = object
              (catMaybes
                 [("approvalUrl" .=) <$> _auiApprovalURL,
                  Just ("kind" .= _auiKind)])

-- | The store page resources for the enterprise.
--
-- /See:/ 'storeLayoutClustersListResponse' smart constructor.
data StoreLayoutClustersListResponse = StoreLayoutClustersListResponse'
    { _slclrCluster :: !(Maybe [StoreCluster])
    , _slclrKind    :: !Text
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'StoreLayoutClustersListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'slclrCluster'
--
-- * 'slclrKind'
storeLayoutClustersListResponse
    :: StoreLayoutClustersListResponse
storeLayoutClustersListResponse =
    StoreLayoutClustersListResponse'
    { _slclrCluster = Nothing
    , _slclrKind = "androidenterprise#storeLayoutClustersListResponse"
    }

-- | A store cluster of an enterprise.
slclrCluster :: Lens' StoreLayoutClustersListResponse [StoreCluster]
slclrCluster
  = lens _slclrCluster (\ s a -> s{_slclrCluster = a})
      . _Default
      . _Coerce

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#storeLayoutClustersListResponse\".
slclrKind :: Lens' StoreLayoutClustersListResponse Text
slclrKind
  = lens _slclrKind (\ s a -> s{_slclrKind = a})

instance FromJSON StoreLayoutClustersListResponse
         where
        parseJSON
          = withObject "StoreLayoutClustersListResponse"
              (\ o ->
                 StoreLayoutClustersListResponse' <$>
                   (o .:? "cluster" .!= mempty) <*>
                     (o .:? "kind" .!=
                        "androidenterprise#storeLayoutClustersListResponse"))

instance ToJSON StoreLayoutClustersListResponse where
        toJSON StoreLayoutClustersListResponse'{..}
          = object
              (catMaybes
                 [("cluster" .=) <$> _slclrCluster,
                  Just ("kind" .= _slclrKind)])

-- | Definition of a Google Play for Work store cluster, a list of products
-- displayed as part of a store page.
--
-- /See:/ 'storeCluster' smart constructor.
data StoreCluster = StoreCluster'
    { _scKind        :: !Text
    , _scName        :: !(Maybe [LocalizedText])
    , _scOrderInPage :: !(Maybe Text)
    , _scId          :: !(Maybe Text)
    , _scProductId   :: !(Maybe [Text])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'StoreCluster' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'scKind'
--
-- * 'scName'
--
-- * 'scOrderInPage'
--
-- * 'scId'
--
-- * 'scProductId'
storeCluster
    :: StoreCluster
storeCluster =
    StoreCluster'
    { _scKind = "androidenterprise#storeCluster"
    , _scName = Nothing
    , _scOrderInPage = Nothing
    , _scId = Nothing
    , _scProductId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#storeCluster\".
scKind :: Lens' StoreCluster Text
scKind = lens _scKind (\ s a -> s{_scKind = a})

-- | Ordered list of localized strings giving the name of this page. The text
-- displayed is the one that best matches the user locale, or the first
-- entry if there is no good match. There needs to be at least one entry.
scName :: Lens' StoreCluster [LocalizedText]
scName
  = lens _scName (\ s a -> s{_scName = a}) . _Default .
      _Coerce

-- | String (US-ASCII only) used to determine order of this cluster within
-- the parent page\'s elements. Page elements are sorted in lexicographic
-- order of this field. Duplicated values are allowed, but ordering between
-- elements with duplicate order is undefined. The value of this field is
-- never visible to a user, it is used solely for the purpose of defining
-- an ordering. Maximum length is 256 characters.
scOrderInPage :: Lens' StoreCluster (Maybe Text)
scOrderInPage
  = lens _scOrderInPage
      (\ s a -> s{_scOrderInPage = a})

-- | Unique ID of this cluster. Assigned by the server. Immutable once
-- assigned.
scId :: Lens' StoreCluster (Maybe Text)
scId = lens _scId (\ s a -> s{_scId = a})

-- | List of products in the order they are displayed in the cluster. There
-- should not be duplicates within a cluster.
scProductId :: Lens' StoreCluster [Text]
scProductId
  = lens _scProductId (\ s a -> s{_scProductId = a}) .
      _Default
      . _Coerce

instance FromJSON StoreCluster where
        parseJSON
          = withObject "StoreCluster"
              (\ o ->
                 StoreCluster' <$>
                   (o .:? "kind" .!= "androidenterprise#storeCluster")
                     <*> (o .:? "name" .!= mempty)
                     <*> (o .:? "orderInPage")
                     <*> (o .:? "id")
                     <*> (o .:? "productId" .!= mempty))

instance ToJSON StoreCluster where
        toJSON StoreCluster'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _scKind), ("name" .=) <$> _scName,
                  ("orderInPage" .=) <$> _scOrderInPage,
                  ("id" .=) <$> _scId,
                  ("productId" .=) <$> _scProductId])

--
-- /See:/ 'pageInfo' smart constructor.
data PageInfo = PageInfo'
    { _piResultPerPage :: !(Maybe (Textual Int32))
    , _piTotalResults  :: !(Maybe (Textual Int32))
    , _piStartIndex    :: !(Maybe (Textual Int32))
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'PageInfo' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'piResultPerPage'
--
-- * 'piTotalResults'
--
-- * 'piStartIndex'
pageInfo
    :: PageInfo
pageInfo =
    PageInfo'
    { _piResultPerPage = Nothing
    , _piTotalResults = Nothing
    , _piStartIndex = Nothing
    }

piResultPerPage :: Lens' PageInfo (Maybe Int32)
piResultPerPage
  = lens _piResultPerPage
      (\ s a -> s{_piResultPerPage = a})
      . mapping _Coerce

piTotalResults :: Lens' PageInfo (Maybe Int32)
piTotalResults
  = lens _piTotalResults
      (\ s a -> s{_piTotalResults = a})
      . mapping _Coerce

piStartIndex :: Lens' PageInfo (Maybe Int32)
piStartIndex
  = lens _piStartIndex (\ s a -> s{_piStartIndex = a})
      . mapping _Coerce

instance FromJSON PageInfo where
        parseJSON
          = withObject "PageInfo"
              (\ o ->
                 PageInfo' <$>
                   (o .:? "resultPerPage") <*> (o .:? "totalResults")
                     <*> (o .:? "startIndex"))

instance ToJSON PageInfo where
        toJSON PageInfo'{..}
          = object
              (catMaybes
                 [("resultPerPage" .=) <$> _piResultPerPage,
                  ("totalResults" .=) <$> _piTotalResults,
                  ("startIndex" .=) <$> _piStartIndex])

-- | A product permissions resource represents the set of permissions
-- required by a specific app and whether or not they have been accepted by
-- an enterprise admin. The API can be used to read the set of permissions,
-- and also to update the set to indicate that permissions have been
-- accepted.
--
-- /See:/ 'productPermission' smart constructor.
data ProductPermission = ProductPermission'
    { _ppState        :: !(Maybe Text)
    , _ppPermissionId :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ProductPermission' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'ppState'
--
-- * 'ppPermissionId'
productPermission
    :: ProductPermission
productPermission =
    ProductPermission'
    { _ppState = Nothing
    , _ppPermissionId = Nothing
    }

-- | Whether the permission has been accepted or not.
ppState :: Lens' ProductPermission (Maybe Text)
ppState = lens _ppState (\ s a -> s{_ppState = a})

-- | An opaque string uniquely identifying the permission.
ppPermissionId :: Lens' ProductPermission (Maybe Text)
ppPermissionId
  = lens _ppPermissionId
      (\ s a -> s{_ppPermissionId = a})

instance FromJSON ProductPermission where
        parseJSON
          = withObject "ProductPermission"
              (\ o ->
                 ProductPermission' <$>
                   (o .:? "state") <*> (o .:? "permissionId"))

instance ToJSON ProductPermission where
        toJSON ProductPermission'{..}
          = object
              (catMaybes
                 [("state" .=) <$> _ppState,
                  ("permissionId" .=) <$> _ppPermissionId])

-- | A device resource represents a mobile device managed by the EMM and
-- belonging to a specific enterprise user. This collection cannot be
-- modified via the API; it is automatically populated as devices are set
-- up to be managed.
--
-- /See:/ 'device' smart constructor.
data Device = Device'
    { _dKind           :: !Text
    , _dManagementType :: !(Maybe Text)
    , _dAndroidId      :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Device' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'dKind'
--
-- * 'dManagementType'
--
-- * 'dAndroidId'
device
    :: Device
device =
    Device'
    { _dKind = "androidenterprise#device"
    , _dManagementType = Nothing
    , _dAndroidId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#device\".
dKind :: Lens' Device Text
dKind = lens _dKind (\ s a -> s{_dKind = a})

-- | The mechanism by which this device is managed by the EMM.
-- \"managedDevice\" means that the EMM\'s app is a device owner.
-- \"managedProfile\" means that the EMM\'s app is the profile owner (and
-- there is a separate personal profile which is not managed).
-- \"containerApp\" means that the EMM\'s app is managing the Android for
-- Work container app on the device. ?unmanagedProfile? means that the
-- EMM?s app is managing a managed user on an unmanaged device
dManagementType :: Lens' Device (Maybe Text)
dManagementType
  = lens _dManagementType
      (\ s a -> s{_dManagementType = a})

-- | The Google Play Services Android ID for the device encoded as a
-- lowercase hex string, e.g. \"123456789abcdef0\".
dAndroidId :: Lens' Device (Maybe Text)
dAndroidId
  = lens _dAndroidId (\ s a -> s{_dAndroidId = a})

instance FromJSON Device where
        parseJSON
          = withObject "Device"
              (\ o ->
                 Device' <$>
                   (o .:? "kind" .!= "androidenterprise#device") <*>
                     (o .:? "managementType")
                     <*> (o .:? "androidId"))

instance ToJSON Device where
        toJSON Device'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _dKind),
                  ("managementType" .=) <$> _dManagementType,
                  ("androidId" .=) <$> _dAndroidId])

-- | The install resources for the device.
--
-- /See:/ 'installsListResponse' smart constructor.
data InstallsListResponse = InstallsListResponse'
    { _ilrKind    :: !Text
    , _ilrInstall :: !(Maybe [Install])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'InstallsListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'ilrKind'
--
-- * 'ilrInstall'
installsListResponse
    :: InstallsListResponse
installsListResponse =
    InstallsListResponse'
    { _ilrKind = "androidenterprise#installsListResponse"
    , _ilrInstall = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#installsListResponse\".
ilrKind :: Lens' InstallsListResponse Text
ilrKind = lens _ilrKind (\ s a -> s{_ilrKind = a})

-- | An installation of an app for a user on a specific device. The existence
-- of an install implies that the user must have an entitlement to the app.
ilrInstall :: Lens' InstallsListResponse [Install]
ilrInstall
  = lens _ilrInstall (\ s a -> s{_ilrInstall = a}) .
      _Default
      . _Coerce

instance FromJSON InstallsListResponse where
        parseJSON
          = withObject "InstallsListResponse"
              (\ o ->
                 InstallsListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#installsListResponse")
                     <*> (o .:? "install" .!= mempty))

instance ToJSON InstallsListResponse where
        toJSON InstallsListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _ilrKind),
                  ("install" .=) <$> _ilrInstall])

-- | A restriction in the App Restriction Schema represents a piece of
-- configuration that may be pre-applied.
--
-- /See:/ 'appRestrictionsSchemaRestriction' smart constructor.
data AppRestrictionsSchemaRestriction = AppRestrictionsSchemaRestriction'
    { _arsrRestrictionType :: !(Maybe Text)
    , _arsrEntry           :: !(Maybe [Text])
    , _arsrKey             :: !(Maybe Text)
    , _arsrEntryValue      :: !(Maybe [Text])
    , _arsrDefaultValue    :: !(Maybe AppRestrictionsSchemaRestrictionRestrictionValue)
    , _arsrTitle           :: !(Maybe Text)
    , _arsrDescription     :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'AppRestrictionsSchemaRestriction' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'arsrRestrictionType'
--
-- * 'arsrEntry'
--
-- * 'arsrKey'
--
-- * 'arsrEntryValue'
--
-- * 'arsrDefaultValue'
--
-- * 'arsrTitle'
--
-- * 'arsrDescription'
appRestrictionsSchemaRestriction
    :: AppRestrictionsSchemaRestriction
appRestrictionsSchemaRestriction =
    AppRestrictionsSchemaRestriction'
    { _arsrRestrictionType = Nothing
    , _arsrEntry = Nothing
    , _arsrKey = Nothing
    , _arsrEntryValue = Nothing
    , _arsrDefaultValue = Nothing
    , _arsrTitle = Nothing
    , _arsrDescription = Nothing
    }

-- | The type of the restriction.
arsrRestrictionType :: Lens' AppRestrictionsSchemaRestriction (Maybe Text)
arsrRestrictionType
  = lens _arsrRestrictionType
      (\ s a -> s{_arsrRestrictionType = a})

-- | For choice or multiselect restrictions, the list of possible entries\'
-- human-readable names.
arsrEntry :: Lens' AppRestrictionsSchemaRestriction [Text]
arsrEntry
  = lens _arsrEntry (\ s a -> s{_arsrEntry = a}) .
      _Default
      . _Coerce

-- | The unique key that the product uses to identify the restriction, e.g.
-- \"com.google.android.gm.fieldname\".
arsrKey :: Lens' AppRestrictionsSchemaRestriction (Maybe Text)
arsrKey = lens _arsrKey (\ s a -> s{_arsrKey = a})

-- | For choice or multiselect restrictions, the list of possible entries\'
-- machine-readable values.
arsrEntryValue :: Lens' AppRestrictionsSchemaRestriction [Text]
arsrEntryValue
  = lens _arsrEntryValue
      (\ s a -> s{_arsrEntryValue = a})
      . _Default
      . _Coerce

-- | The default value of the restriction.
arsrDefaultValue :: Lens' AppRestrictionsSchemaRestriction (Maybe AppRestrictionsSchemaRestrictionRestrictionValue)
arsrDefaultValue
  = lens _arsrDefaultValue
      (\ s a -> s{_arsrDefaultValue = a})

-- | The name of the restriction.
arsrTitle :: Lens' AppRestrictionsSchemaRestriction (Maybe Text)
arsrTitle
  = lens _arsrTitle (\ s a -> s{_arsrTitle = a})

-- | A longer description of the restriction, giving more detail of what it
-- affects.
arsrDescription :: Lens' AppRestrictionsSchemaRestriction (Maybe Text)
arsrDescription
  = lens _arsrDescription
      (\ s a -> s{_arsrDescription = a})

instance FromJSON AppRestrictionsSchemaRestriction
         where
        parseJSON
          = withObject "AppRestrictionsSchemaRestriction"
              (\ o ->
                 AppRestrictionsSchemaRestriction' <$>
                   (o .:? "restrictionType") <*>
                     (o .:? "entry" .!= mempty)
                     <*> (o .:? "key")
                     <*> (o .:? "entryValue" .!= mempty)
                     <*> (o .:? "defaultValue")
                     <*> (o .:? "title")
                     <*> (o .:? "description"))

instance ToJSON AppRestrictionsSchemaRestriction
         where
        toJSON AppRestrictionsSchemaRestriction'{..}
          = object
              (catMaybes
                 [("restrictionType" .=) <$> _arsrRestrictionType,
                  ("entry" .=) <$> _arsrEntry, ("key" .=) <$> _arsrKey,
                  ("entryValue" .=) <$> _arsrEntryValue,
                  ("defaultValue" .=) <$> _arsrDefaultValue,
                  ("title" .=) <$> _arsrTitle,
                  ("description" .=) <$> _arsrDescription])

-- | The matching user resources.
--
-- /See:/ 'usersListResponse' smart constructor.
data UsersListResponse = UsersListResponse'
    { _ulrKind :: !Text
    , _ulrUser :: !(Maybe [User])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'UsersListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'ulrKind'
--
-- * 'ulrUser'
usersListResponse
    :: UsersListResponse
usersListResponse =
    UsersListResponse'
    { _ulrKind = "androidenterprise#usersListResponse"
    , _ulrUser = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#usersListResponse\".
ulrKind :: Lens' UsersListResponse Text
ulrKind = lens _ulrKind (\ s a -> s{_ulrKind = a})

-- | A user of an enterprise.
ulrUser :: Lens' UsersListResponse [User]
ulrUser
  = lens _ulrUser (\ s a -> s{_ulrUser = a}) . _Default
      . _Coerce

instance FromJSON UsersListResponse where
        parseJSON
          = withObject "UsersListResponse"
              (\ o ->
                 UsersListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#usersListResponse")
                     <*> (o .:? "user" .!= mempty))

instance ToJSON UsersListResponse where
        toJSON UsersListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _ulrKind),
                  ("user" .=) <$> _ulrUser])

-- | This represents a single version of the app.
--
-- /See:/ 'appVersion' smart constructor.
data AppVersion = AppVersion'
    { _avVersionCode   :: !(Maybe (Textual Int32))
    , _avVersionString :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'AppVersion' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'avVersionCode'
--
-- * 'avVersionString'
appVersion
    :: AppVersion
appVersion =
    AppVersion'
    { _avVersionCode = Nothing
    , _avVersionString = Nothing
    }

-- | Unique increasing identifier for the app version.
avVersionCode :: Lens' AppVersion (Maybe Int32)
avVersionCode
  = lens _avVersionCode
      (\ s a -> s{_avVersionCode = a})
      . mapping _Coerce

-- | The string used in the Play Store by the app developer to identify the
-- version. The string is not necessarily unique or localized (for example,
-- the string could be \"1.4\").
avVersionString :: Lens' AppVersion (Maybe Text)
avVersionString
  = lens _avVersionString
      (\ s a -> s{_avVersionString = a})

instance FromJSON AppVersion where
        parseJSON
          = withObject "AppVersion"
              (\ o ->
                 AppVersion' <$>
                   (o .:? "versionCode") <*> (o .:? "versionString"))

instance ToJSON AppVersion where
        toJSON AppVersion'{..}
          = object
              (catMaybes
                 [("versionCode" .=) <$> _avVersionCode,
                  ("versionString" .=) <$> _avVersionString])

-- | The grouplicense resources for the enterprise.
--
-- /See:/ 'groupLicensesListResponse' smart constructor.
data GroupLicensesListResponse = GroupLicensesListResponse'
    { _gllrGroupLicense :: !(Maybe [GroupLicense])
    , _gllrKind         :: !Text
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'GroupLicensesListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'gllrGroupLicense'
--
-- * 'gllrKind'
groupLicensesListResponse
    :: GroupLicensesListResponse
groupLicensesListResponse =
    GroupLicensesListResponse'
    { _gllrGroupLicense = Nothing
    , _gllrKind = "androidenterprise#groupLicensesListResponse"
    }

-- | A group license for a product approved for use in the enterprise.
gllrGroupLicense :: Lens' GroupLicensesListResponse [GroupLicense]
gllrGroupLicense
  = lens _gllrGroupLicense
      (\ s a -> s{_gllrGroupLicense = a})
      . _Default
      . _Coerce

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#groupLicensesListResponse\".
gllrKind :: Lens' GroupLicensesListResponse Text
gllrKind = lens _gllrKind (\ s a -> s{_gllrKind = a})

instance FromJSON GroupLicensesListResponse where
        parseJSON
          = withObject "GroupLicensesListResponse"
              (\ o ->
                 GroupLicensesListResponse' <$>
                   (o .:? "groupLicense" .!= mempty) <*>
                     (o .:? "kind" .!=
                        "androidenterprise#groupLicensesListResponse"))

instance ToJSON GroupLicensesListResponse where
        toJSON GroupLicensesListResponse'{..}
          = object
              (catMaybes
                 [("groupLicense" .=) <$> _gllrGroupLicense,
                  Just ("kind" .= _gllrKind)])

-- | A collection resource defines a named set of apps that is visible to a
-- set of users in the Google Play Store app running on those users\'
-- managed devices. Those users can then install any of those apps if they
-- wish (which will trigger creation of install and entitlement resources).
-- A user cannot install an app on a managed device unless the app is
-- listed in at least one collection that is visible to that user. Note
-- that the API can be used to directly install an app regardless of
-- whether it is in any collection - so an enterprise has a choice of
-- either directly pushing apps to users, or allowing users to install apps
-- if they want. Which is appropriate will depend on the enterprise\'s
-- policies and the purpose of the apps concerned.
--
-- /See:/ 'collection' smart constructor.
data Collection = Collection'
    { _colKind         :: !Text
    , _colCollectionId :: !(Maybe Text)
    , _colVisibility   :: !(Maybe Text)
    , _colName         :: !(Maybe Text)
    , _colProductId    :: !(Maybe [Text])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Collection' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'colKind'
--
-- * 'colCollectionId'
--
-- * 'colVisibility'
--
-- * 'colName'
--
-- * 'colProductId'
collection
    :: Collection
collection =
    Collection'
    { _colKind = "androidenterprise#collection"
    , _colCollectionId = Nothing
    , _colVisibility = Nothing
    , _colName = Nothing
    , _colProductId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#collection\".
colKind :: Lens' Collection Text
colKind = lens _colKind (\ s a -> s{_colKind = a})

-- | Arbitrary unique ID, allocated by the API on creation.
colCollectionId :: Lens' Collection (Maybe Text)
colCollectionId
  = lens _colCollectionId
      (\ s a -> s{_colCollectionId = a})

-- | Whether this collection is visible to all users, or only to the users
-- that have been granted access through the \"Collectionviewers\" API.
-- With the launch of the \"setAvailableProductSet\" API, this property
-- should always be set to \"viewersOnly\", as the \"allUsers\" option will
-- bypass the \"availableProductSet\" for all users within a domain. The
-- \"allUsers\" setting is deprecated, and will be removed.
colVisibility :: Lens' Collection (Maybe Text)
colVisibility
  = lens _colVisibility
      (\ s a -> s{_colVisibility = a})

-- | A user-friendly name for the collection (should be unique), e.g.
-- \"Accounting apps\".
colName :: Lens' Collection (Maybe Text)
colName = lens _colName (\ s a -> s{_colName = a})

-- | The IDs of the products in the collection, in the order in which they
-- should be displayed.
colProductId :: Lens' Collection [Text]
colProductId
  = lens _colProductId (\ s a -> s{_colProductId = a})
      . _Default
      . _Coerce

instance FromJSON Collection where
        parseJSON
          = withObject "Collection"
              (\ o ->
                 Collection' <$>
                   (o .:? "kind" .!= "androidenterprise#collection") <*>
                     (o .:? "collectionId")
                     <*> (o .:? "visibility")
                     <*> (o .:? "name")
                     <*> (o .:? "productId" .!= mempty))

instance ToJSON Collection where
        toJSON Collection'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _colKind),
                  ("collectionId" .=) <$> _colCollectionId,
                  ("visibility" .=) <$> _colVisibility,
                  ("name" .=) <$> _colName,
                  ("productId" .=) <$> _colProductId])

-- | A set of products.
--
-- /See:/ 'productSet' smart constructor.
data ProductSet = ProductSet'
    { _psKind      :: !Text
    , _psProductId :: !(Maybe [Text])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ProductSet' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'psKind'
--
-- * 'psProductId'
productSet
    :: ProductSet
productSet =
    ProductSet'
    { _psKind = "androidenterprise#productSet"
    , _psProductId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#productSet\".
psKind :: Lens' ProductSet Text
psKind = lens _psKind (\ s a -> s{_psKind = a})

-- | The list of product IDs making up the set of products.
psProductId :: Lens' ProductSet [Text]
psProductId
  = lens _psProductId (\ s a -> s{_psProductId = a}) .
      _Default
      . _Coerce

instance FromJSON ProductSet where
        parseJSON
          = withObject "ProductSet"
              (\ o ->
                 ProductSet' <$>
                   (o .:? "kind" .!= "androidenterprise#productSet") <*>
                     (o .:? "productId" .!= mempty))

instance ToJSON ProductSet where
        toJSON ProductSet'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _psKind),
                  ("productId" .=) <$> _psProductId])

-- | The existence of an install resource indicates that an app is installed
-- on a particular device (or that an install is pending). The API can be
-- used to create an install resource using the update method. This
-- triggers the actual install of the app on the device. If the user does
-- not already have an entitlement for the app then an attempt is made to
-- create one. If this fails (e.g. because the app is not free and there is
-- no available license) then the creation of the install fails. The API
-- can also be used to update an installed app. If the update method is
-- used on an existing install then the app will be updated to the latest
-- available version. Note that it is not possible to force the
-- installation of a specific version of an app; the version code is
-- read-only. If a user installs an app themselves (as permitted by the
-- enterprise), then again an install resource and possibly an entitlement
-- resource are automatically created. The API can also be used to delete
-- an install resource, which triggers the removal of the app from the
-- device. Note that deleting an install does not automatically remove the
-- corresponding entitlement, even if there are no remaining installs. The
-- install resource will also be deleted if the user uninstalls the app
-- themselves.
--
-- /See:/ 'install' smart constructor.
data Install = Install'
    { _iVersionCode  :: !(Maybe (Textual Int32))
    , _iKind         :: !Text
    , _iInstallState :: !(Maybe Text)
    , _iProductId    :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Install' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'iVersionCode'
--
-- * 'iKind'
--
-- * 'iInstallState'
--
-- * 'iProductId'
install
    :: Install
install =
    Install'
    { _iVersionCode = Nothing
    , _iKind = "androidenterprise#install"
    , _iInstallState = Nothing
    , _iProductId = Nothing
    }

-- | The version of the installed product. Guaranteed to be set only if the
-- install state is \"installed\".
iVersionCode :: Lens' Install (Maybe Int32)
iVersionCode
  = lens _iVersionCode (\ s a -> s{_iVersionCode = a})
      . mapping _Coerce

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#install\".
iKind :: Lens' Install Text
iKind = lens _iKind (\ s a -> s{_iKind = a})

-- | Install state. The state \"installPending\" means that an install
-- request has recently been made and download to the device is in
-- progress. The state \"installed\" means that the app has been installed.
-- This field is read-only.
iInstallState :: Lens' Install (Maybe Text)
iInstallState
  = lens _iInstallState
      (\ s a -> s{_iInstallState = a})

-- | The ID of the product that the install is for, e.g.
-- \"app:com.google.android.gm\".
iProductId :: Lens' Install (Maybe Text)
iProductId
  = lens _iProductId (\ s a -> s{_iProductId = a})

instance FromJSON Install where
        parseJSON
          = withObject "Install"
              (\ o ->
                 Install' <$>
                   (o .:? "versionCode") <*>
                     (o .:? "kind" .!= "androidenterprise#install")
                     <*> (o .:? "installState")
                     <*> (o .:? "productId"))

instance ToJSON Install where
        toJSON Install'{..}
          = object
              (catMaybes
                 [("versionCode" .=) <$> _iVersionCode,
                  Just ("kind" .= _iKind),
                  ("installState" .=) <$> _iInstallState,
                  ("productId" .=) <$> _iProductId])

-- | A user resource represents an individual user within the enterprise\'s
-- domain. Note that each user is associated with a Google account based on
-- the user\'s corporate email address (which must be in one of the
-- enterprise\'s domains). As part of installing the EMM\'s DPC app to
-- manage a device the Google account must be provisioned to the device,
-- and so the user resource must be created before that. This can be done
-- using the Google Admin SDK Directory API. The ID for a user is an opaque
-- string. It can be retrieved using the list method queried by the user\'s
-- primary email address.
--
-- /See:/ 'user' smart constructor.
data User = User'
    { _uKind         :: !Text
    , _uId           :: !(Maybe Text)
    , _uPrimaryEmail :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'User' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'uKind'
--
-- * 'uId'
--
-- * 'uPrimaryEmail'
user
    :: User
user =
    User'
    { _uKind = "androidenterprise#user"
    , _uId = Nothing
    , _uPrimaryEmail = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#user\".
uKind :: Lens' User Text
uKind = lens _uKind (\ s a -> s{_uKind = a})

-- | The unique ID for the user.
uId :: Lens' User (Maybe Text)
uId = lens _uId (\ s a -> s{_uId = a})

-- | The user\'s primary email, e.g. \"jsmith\'example.com\".
uPrimaryEmail :: Lens' User (Maybe Text)
uPrimaryEmail
  = lens _uPrimaryEmail
      (\ s a -> s{_uPrimaryEmail = a})

instance FromJSON User where
        parseJSON
          = withObject "User"
              (\ o ->
                 User' <$>
                   (o .:? "kind" .!= "androidenterprise#user") <*>
                     (o .:? "id")
                     <*> (o .:? "primaryEmail"))

instance ToJSON User where
        toJSON User'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _uKind), ("id" .=) <$> _uId,
                  ("primaryEmail" .=) <$> _uPrimaryEmail])

--
-- /See:/ 'productsGenerateApprovalURLResponse' smart constructor.
newtype ProductsGenerateApprovalURLResponse = ProductsGenerateApprovalURLResponse'
    { _pgaurURL :: Maybe Text
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ProductsGenerateApprovalURLResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'pgaurURL'
productsGenerateApprovalURLResponse
    :: ProductsGenerateApprovalURLResponse
productsGenerateApprovalURLResponse =
    ProductsGenerateApprovalURLResponse'
    { _pgaurURL = Nothing
    }

-- | A URL that can be rendered in an iframe to display the permissions (if
-- any) of a product. This URL can be used to approve the product only once
-- and only within 24 hours of being generated, using the Products.approve
-- call. If the product is currently unapproved and has no permissions,
-- this URL will point to an empty page. If the product is currently
-- approved, a URL will only be generated if that product has added
-- permissions since it was last approved, and the URL will only display
-- those new permissions that have not yet been accepted.
pgaurURL :: Lens' ProductsGenerateApprovalURLResponse (Maybe Text)
pgaurURL = lens _pgaurURL (\ s a -> s{_pgaurURL = a})

instance FromJSON ProductsGenerateApprovalURLResponse
         where
        parseJSON
          = withObject "ProductsGenerateApprovalURLResponse"
              (\ o ->
                 ProductsGenerateApprovalURLResponse' <$>
                   (o .:? "url"))

instance ToJSON ProductsGenerateApprovalURLResponse
         where
        toJSON ProductsGenerateApprovalURLResponse'{..}
          = object (catMaybes [("url" .=) <$> _pgaurURL])

-- | Definition of a Google Play for Work store page, made of a localized
-- name and links to other pages. A page also contains clusters defined as
-- a subcollection.
--
-- /See:/ 'storePage' smart constructor.
data StorePage = StorePage'
    { _spKind :: !Text
    , _spLink :: !(Maybe [Text])
    , _spName :: !(Maybe [LocalizedText])
    , _spId   :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'StorePage' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'spKind'
--
-- * 'spLink'
--
-- * 'spName'
--
-- * 'spId'
storePage
    :: StorePage
storePage =
    StorePage'
    { _spKind = "androidenterprise#storePage"
    , _spLink = Nothing
    , _spName = Nothing
    , _spId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#storePage\".
spKind :: Lens' StorePage Text
spKind = lens _spKind (\ s a -> s{_spKind = a})

-- | Ordered list of pages a user should be able to reach from this page. The
-- pages must exist, must not be this page, and once a link is created the
-- page linked to cannot be deleted until all links to it are removed. It
-- is recommended that the basic pages are created first, before adding the
-- links between pages. No attempt is made to verify that all pages are
-- reachable from the homepage.
spLink :: Lens' StorePage [Text]
spLink
  = lens _spLink (\ s a -> s{_spLink = a}) . _Default .
      _Coerce

-- | Ordered list of localized strings giving the name of this page. The text
-- displayed is the one that best matches the user locale, or the first
-- entry if there is no good match. There needs to be at least one entry.
spName :: Lens' StorePage [LocalizedText]
spName
  = lens _spName (\ s a -> s{_spName = a}) . _Default .
      _Coerce

-- | Unique ID of this page. Assigned by the server. Immutable once assigned.
spId :: Lens' StorePage (Maybe Text)
spId = lens _spId (\ s a -> s{_spId = a})

instance FromJSON StorePage where
        parseJSON
          = withObject "StorePage"
              (\ o ->
                 StorePage' <$>
                   (o .:? "kind" .!= "androidenterprise#storePage") <*>
                     (o .:? "link" .!= mempty)
                     <*> (o .:? "name" .!= mempty)
                     <*> (o .:? "id"))

instance ToJSON StorePage where
        toJSON StorePage'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _spKind), ("link" .=) <$> _spLink,
                  ("name" .=) <$> _spName, ("id" .=) <$> _spId])

--
-- /See:/ 'enterprisesSendTestPushNotificationResponse' smart constructor.
data EnterprisesSendTestPushNotificationResponse = EnterprisesSendTestPushNotificationResponse'
    { _estpnrTopicName :: !(Maybe Text)
    , _estpnrMessageId :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'EnterprisesSendTestPushNotificationResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'estpnrTopicName'
--
-- * 'estpnrMessageId'
enterprisesSendTestPushNotificationResponse
    :: EnterprisesSendTestPushNotificationResponse
enterprisesSendTestPushNotificationResponse =
    EnterprisesSendTestPushNotificationResponse'
    { _estpnrTopicName = Nothing
    , _estpnrMessageId = Nothing
    }

-- | The name of the Cloud Pub\/Sub topic to which notifications for this
-- enterprise\'s enrolled account will be sent.
estpnrTopicName :: Lens' EnterprisesSendTestPushNotificationResponse (Maybe Text)
estpnrTopicName
  = lens _estpnrTopicName
      (\ s a -> s{_estpnrTopicName = a})

-- | The message ID of the test push notification that was sent.
estpnrMessageId :: Lens' EnterprisesSendTestPushNotificationResponse (Maybe Text)
estpnrMessageId
  = lens _estpnrMessageId
      (\ s a -> s{_estpnrMessageId = a})

instance FromJSON
         EnterprisesSendTestPushNotificationResponse where
        parseJSON
          = withObject
              "EnterprisesSendTestPushNotificationResponse"
              (\ o ->
                 EnterprisesSendTestPushNotificationResponse' <$>
                   (o .:? "topicName") <*> (o .:? "messageId"))

instance ToJSON
         EnterprisesSendTestPushNotificationResponse where
        toJSON
          EnterprisesSendTestPushNotificationResponse'{..}
          = object
              (catMaybes
                 [("topicName" .=) <$> _estpnrTopicName,
                  ("messageId" .=) <$> _estpnrMessageId])

-- | The matching enterprise resources.
--
-- /See:/ 'enterprisesListResponse' smart constructor.
data EnterprisesListResponse = EnterprisesListResponse'
    { _elrKind       :: !Text
    , _elrEnterprise :: !(Maybe [Enterprise])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'EnterprisesListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'elrKind'
--
-- * 'elrEnterprise'
enterprisesListResponse
    :: EnterprisesListResponse
enterprisesListResponse =
    EnterprisesListResponse'
    { _elrKind = "androidenterprise#enterprisesListResponse"
    , _elrEnterprise = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#enterprisesListResponse\".
elrKind :: Lens' EnterprisesListResponse Text
elrKind = lens _elrKind (\ s a -> s{_elrKind = a})

-- | An enterprise.
elrEnterprise :: Lens' EnterprisesListResponse [Enterprise]
elrEnterprise
  = lens _elrEnterprise
      (\ s a -> s{_elrEnterprise = a})
      . _Default
      . _Coerce

instance FromJSON EnterprisesListResponse where
        parseJSON
          = withObject "EnterprisesListResponse"
              (\ o ->
                 EnterprisesListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#enterprisesListResponse")
                     <*> (o .:? "enterprise" .!= mempty))

instance ToJSON EnterprisesListResponse where
        toJSON EnterprisesListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _elrKind),
                  ("enterprise" .=) <$> _elrEnterprise])

-- | Represents the list of app restrictions available to be pre-configured
-- for the product.
--
-- /See:/ 'appRestrictionsSchema' smart constructor.
data AppRestrictionsSchema = AppRestrictionsSchema'
    { _arsKind         :: !Text
    , _arsRestrictions :: !(Maybe [AppRestrictionsSchemaRestriction])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'AppRestrictionsSchema' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'arsKind'
--
-- * 'arsRestrictions'
appRestrictionsSchema
    :: AppRestrictionsSchema
appRestrictionsSchema =
    AppRestrictionsSchema'
    { _arsKind = "androidenterprise#appRestrictionsSchema"
    , _arsRestrictions = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#appRestrictionsSchema\".
arsKind :: Lens' AppRestrictionsSchema Text
arsKind = lens _arsKind (\ s a -> s{_arsKind = a})

-- | The set of restrictions that make up this schema.
arsRestrictions :: Lens' AppRestrictionsSchema [AppRestrictionsSchemaRestriction]
arsRestrictions
  = lens _arsRestrictions
      (\ s a -> s{_arsRestrictions = a})
      . _Default
      . _Coerce

instance FromJSON AppRestrictionsSchema where
        parseJSON
          = withObject "AppRestrictionsSchema"
              (\ o ->
                 AppRestrictionsSchema' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#appRestrictionsSchema")
                     <*> (o .:? "restrictions" .!= mempty))

instance ToJSON AppRestrictionsSchema where
        toJSON AppRestrictionsSchema'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _arsKind),
                  ("restrictions" .=) <$> _arsRestrictions])

-- | A localized string with its locale.
--
-- /See:/ 'localizedText' smart constructor.
data LocalizedText = LocalizedText'
    { _ltText   :: !(Maybe Text)
    , _ltLocale :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'LocalizedText' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'ltText'
--
-- * 'ltLocale'
localizedText
    :: LocalizedText
localizedText =
    LocalizedText'
    { _ltText = Nothing
    , _ltLocale = Nothing
    }

-- | The text localized in the associated locale.
ltText :: Lens' LocalizedText (Maybe Text)
ltText = lens _ltText (\ s a -> s{_ltText = a})

-- | The BCP47 tag for a locale. (e.g. \"en-US\", \"de\").
ltLocale :: Lens' LocalizedText (Maybe Text)
ltLocale = lens _ltLocale (\ s a -> s{_ltLocale = a})

instance FromJSON LocalizedText where
        parseJSON
          = withObject "LocalizedText"
              (\ o ->
                 LocalizedText' <$>
                   (o .:? "text") <*> (o .:? "locale"))

instance ToJSON LocalizedText where
        toJSON LocalizedText'{..}
          = object
              (catMaybes
                 [("text" .=) <$> _ltText,
                  ("locale" .=) <$> _ltLocale])

-- | A UserToken is used by a user when setting up a managed device or
-- profile with their work account on a device. When the user enters their
-- email address and token (activation code) the appropriate EMM app can be
-- automatically downloaded.
--
-- /See:/ 'userToken' smart constructor.
data UserToken = UserToken'
    { _utKind   :: !Text
    , _utToken  :: !(Maybe Text)
    , _utUserId :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'UserToken' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'utKind'
--
-- * 'utToken'
--
-- * 'utUserId'
userToken
    :: UserToken
userToken =
    UserToken'
    { _utKind = "androidenterprise#userToken"
    , _utToken = Nothing
    , _utUserId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#userToken\".
utKind :: Lens' UserToken Text
utKind = lens _utKind (\ s a -> s{_utKind = a})

-- | The token (activation code) to be entered by the user. This consists of
-- a sequence of decimal digits. Note that the leading digit may be 0.
utToken :: Lens' UserToken (Maybe Text)
utToken = lens _utToken (\ s a -> s{_utToken = a})

-- | The unique ID for the user.
utUserId :: Lens' UserToken (Maybe Text)
utUserId = lens _utUserId (\ s a -> s{_utUserId = a})

instance FromJSON UserToken where
        parseJSON
          = withObject "UserToken"
              (\ o ->
                 UserToken' <$>
                   (o .:? "kind" .!= "androidenterprise#userToken") <*>
                     (o .:? "token")
                     <*> (o .:? "userId"))

instance ToJSON UserToken where
        toJSON UserToken'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _utKind), ("token" .=) <$> _utToken,
                  ("userId" .=) <$> _utUserId])

-- | The device resources for the user.
--
-- /See:/ 'devicesListResponse' smart constructor.
data DevicesListResponse = DevicesListResponse'
    { _dlrKind   :: !Text
    , _dlrDevice :: !(Maybe [Device])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'DevicesListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'dlrKind'
--
-- * 'dlrDevice'
devicesListResponse
    :: DevicesListResponse
devicesListResponse =
    DevicesListResponse'
    { _dlrKind = "androidenterprise#devicesListResponse"
    , _dlrDevice = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#devicesListResponse\".
dlrKind :: Lens' DevicesListResponse Text
dlrKind = lens _dlrKind (\ s a -> s{_dlrKind = a})

-- | A managed device.
dlrDevice :: Lens' DevicesListResponse [Device]
dlrDevice
  = lens _dlrDevice (\ s a -> s{_dlrDevice = a}) .
      _Default
      . _Coerce

instance FromJSON DevicesListResponse where
        parseJSON
          = withObject "DevicesListResponse"
              (\ o ->
                 DevicesListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#devicesListResponse")
                     <*> (o .:? "device" .!= mempty))

instance ToJSON DevicesListResponse where
        toJSON DevicesListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _dlrKind),
                  ("device" .=) <$> _dlrDevice])

-- | An enterprise resource represents a binding between an organization and
-- their EMM. To create an enterprise, an admin of the enterprise must
-- first go through a Play for Work sign-up flow. At the end of this the
-- admin will be presented with a token (a short opaque alphanumeric
-- string). They must then present this to the EMM, who then supplies it to
-- the enroll method. Until this is done the EMM will not have any access
-- to the enterprise. After calling enroll the EMM should call setAccount
-- to specify the service account that will be allowed to act on behalf of
-- the enterprise, which will be required for access to the enterprise\'s
-- data through this API. Only one call of setAccount is allowed for a
-- given enterprise; the only way to change the account later is to
-- unenroll the enterprise and enroll it again (obtaining a new token). The
-- EMM can unenroll an enterprise in order to sever the binding between
-- them. Re-enrolling an enterprise is possible, but requires a new token
-- to be retrieved. Enterprises.unenroll requires the EMM\'s credentials
-- (as enroll does), not the enterprise\'s. Enterprises.unenroll can only
-- be used for enterprises that were previously enrolled with the enroll
-- call. Any enterprises that were enrolled using the (deprecated)
-- Enterprises.insert call must be unenrolled with Enterprises.delete and
-- can then be re-enrolled using the Enterprises.enroll call. The ID for an
-- enterprise is an opaque string. It is returned by insert and enroll and
-- can also be retrieved if the enterprise\'s primary domain is known using
-- the list method.
--
-- /See:/ 'enterprise' smart constructor.
data Enterprise = Enterprise'
    { _eKind          :: !Text
    , _ePrimaryDomain :: !(Maybe Text)
    , _eName          :: !(Maybe Text)
    , _eId            :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Enterprise' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'eKind'
--
-- * 'ePrimaryDomain'
--
-- * 'eName'
--
-- * 'eId'
enterprise
    :: Enterprise
enterprise =
    Enterprise'
    { _eKind = "androidenterprise#enterprise"
    , _ePrimaryDomain = Nothing
    , _eName = Nothing
    , _eId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#enterprise\".
eKind :: Lens' Enterprise Text
eKind = lens _eKind (\ s a -> s{_eKind = a})

-- | The enterprise\'s primary domain, e.g. \"example.com\".
ePrimaryDomain :: Lens' Enterprise (Maybe Text)
ePrimaryDomain
  = lens _ePrimaryDomain
      (\ s a -> s{_ePrimaryDomain = a})

-- | The name of the enterprise, e.g. \"Example Inc\".
eName :: Lens' Enterprise (Maybe Text)
eName = lens _eName (\ s a -> s{_eName = a})

-- | The unique ID for the enterprise.
eId :: Lens' Enterprise (Maybe Text)
eId = lens _eId (\ s a -> s{_eId = a})

instance FromJSON Enterprise where
        parseJSON
          = withObject "Enterprise"
              (\ o ->
                 Enterprise' <$>
                   (o .:? "kind" .!= "androidenterprise#enterprise") <*>
                     (o .:? "primaryDomain")
                     <*> (o .:? "name")
                     <*> (o .:? "id"))

instance ToJSON Enterprise where
        toJSON Enterprise'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _eKind),
                  ("primaryDomain" .=) <$> _ePrimaryDomain,
                  ("name" .=) <$> _eName, ("id" .=) <$> _eId])

-- | General setting for the Google Play for Work store layout, currently
-- only specifying the page to display the first time the store is opened.
--
-- /See:/ 'storeLayout' smart constructor.
data StoreLayout = StoreLayout'
    { _slKind       :: !Text
    , _slHomepageId :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'StoreLayout' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'slKind'
--
-- * 'slHomepageId'
storeLayout
    :: StoreLayout
storeLayout =
    StoreLayout'
    { _slKind = "androidenterprise#storeLayout"
    , _slHomepageId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#storeLayout\".
slKind :: Lens' StoreLayout Text
slKind = lens _slKind (\ s a -> s{_slKind = a})

-- | The ID of the store page to be used as the homepage. The homepage will
-- be used as the first page shown in the Google Play for Work store. If
-- there is no homepage set, an empty store is shown. The homepage can be
-- unset (by not specifying it) to empty the store. If there exists at
-- least one page, this field must be set to the ID of a valid page.
slHomepageId :: Lens' StoreLayout (Maybe Text)
slHomepageId
  = lens _slHomepageId (\ s a -> s{_slHomepageId = a})

instance FromJSON StoreLayout where
        parseJSON
          = withObject "StoreLayout"
              (\ o ->
                 StoreLayout' <$>
                   (o .:? "kind" .!= "androidenterprise#storeLayout")
                     <*> (o .:? "homepageId"))

instance ToJSON StoreLayout where
        toJSON StoreLayout'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _slKind),
                  ("homepageId" .=) <$> _slHomepageId])

-- | A product represents an app in the Google Play Store that is available
-- to at least some users in the enterprise. (Some apps are restricted to a
-- single enterprise, and no information about them is made available
-- outside that enterprise.) The information provided for each product
-- (localized name, icon, link to the full Google Play details page) is
-- intended to allow a basic representation of the product within an EMM
-- user interface.
--
-- /See:/ 'product' smart constructor.
data Product = Product'
    { _pSmallIconURL         :: !(Maybe Text)
    , _pAuthorName           :: !(Maybe Text)
    , _pKind                 :: !Text
    , _pWorkDetailsURL       :: !(Maybe Text)
    , _pRequiresContainerApp :: !(Maybe Bool)
    , _pAppVersion           :: !(Maybe [AppVersion])
    , _pProductPricing       :: !(Maybe Text)
    , _pDistributionChannel  :: !(Maybe Text)
    , _pIconURL              :: !(Maybe Text)
    , _pTitle                :: !(Maybe Text)
    , _pProductId            :: !(Maybe Text)
    , _pDetailsURL           :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Product' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'pSmallIconURL'
--
-- * 'pAuthorName'
--
-- * 'pKind'
--
-- * 'pWorkDetailsURL'
--
-- * 'pRequiresContainerApp'
--
-- * 'pAppVersion'
--
-- * 'pProductPricing'
--
-- * 'pDistributionChannel'
--
-- * 'pIconURL'
--
-- * 'pTitle'
--
-- * 'pProductId'
--
-- * 'pDetailsURL'
product
    :: Product
product =
    Product'
    { _pSmallIconURL = Nothing
    , _pAuthorName = Nothing
    , _pKind = "androidenterprise#product"
    , _pWorkDetailsURL = Nothing
    , _pRequiresContainerApp = Nothing
    , _pAppVersion = Nothing
    , _pProductPricing = Nothing
    , _pDistributionChannel = Nothing
    , _pIconURL = Nothing
    , _pTitle = Nothing
    , _pProductId = Nothing
    , _pDetailsURL = Nothing
    }

-- | A link to a smaller image that can be used as an icon for the product.
-- This image is suitable for use at up to 128px x 128px.
pSmallIconURL :: Lens' Product (Maybe Text)
pSmallIconURL
  = lens _pSmallIconURL
      (\ s a -> s{_pSmallIconURL = a})

-- | The name of the author of the product (e.g. the app developer).
pAuthorName :: Lens' Product (Maybe Text)
pAuthorName
  = lens _pAuthorName (\ s a -> s{_pAuthorName = a})

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#product\".
pKind :: Lens' Product Text
pKind = lens _pKind (\ s a -> s{_pKind = a})

-- | A link to the Google Play for Work details page for the product, for use
-- by an Enterprise administrator.
pWorkDetailsURL :: Lens' Product (Maybe Text)
pWorkDetailsURL
  = lens _pWorkDetailsURL
      (\ s a -> s{_pWorkDetailsURL = a})

-- | Whether this app can only be installed on devices using the Android for
-- Work container app.
pRequiresContainerApp :: Lens' Product (Maybe Bool)
pRequiresContainerApp
  = lens _pRequiresContainerApp
      (\ s a -> s{_pRequiresContainerApp = a})

-- | App versions currently available for this product. The returned list
-- contains only public versions. Alpha and beta versions are not included.
pAppVersion :: Lens' Product [AppVersion]
pAppVersion
  = lens _pAppVersion (\ s a -> s{_pAppVersion = a}) .
      _Default
      . _Coerce

-- | Whether this product is free, free with in-app purchases, or paid.
pProductPricing :: Lens' Product (Maybe Text)
pProductPricing
  = lens _pProductPricing
      (\ s a -> s{_pProductPricing = a})

-- | How and to whom the package is made available. The value
-- publicGoogleHosted means that the package is available through the Play
-- Store and not restricted to a specific enterprise. The value
-- privateGoogleHosted means that the package is a private app (restricted
-- to an enterprise) but hosted by Google. The value privateSelfHosted
-- means that the package is a private app (restricted to an enterprise)
-- and is privately hosted.
pDistributionChannel :: Lens' Product (Maybe Text)
pDistributionChannel
  = lens _pDistributionChannel
      (\ s a -> s{_pDistributionChannel = a})

-- | A link to an image that can be used as an icon for the product. This
-- image is suitable for use at up to 512px x 512px.
pIconURL :: Lens' Product (Maybe Text)
pIconURL = lens _pIconURL (\ s a -> s{_pIconURL = a})

-- | The name of the product.
pTitle :: Lens' Product (Maybe Text)
pTitle = lens _pTitle (\ s a -> s{_pTitle = a})

-- | A string of the form app:. For example, app:com.google.android.gm
-- represents the Gmail app.
pProductId :: Lens' Product (Maybe Text)
pProductId
  = lens _pProductId (\ s a -> s{_pProductId = a})

-- | A link to the (consumer) Google Play details page for the product.
pDetailsURL :: Lens' Product (Maybe Text)
pDetailsURL
  = lens _pDetailsURL (\ s a -> s{_pDetailsURL = a})

instance FromJSON Product where
        parseJSON
          = withObject "Product"
              (\ o ->
                 Product' <$>
                   (o .:? "smallIconUrl") <*> (o .:? "authorName") <*>
                     (o .:? "kind" .!= "androidenterprise#product")
                     <*> (o .:? "workDetailsUrl")
                     <*> (o .:? "requiresContainerApp")
                     <*> (o .:? "appVersion" .!= mempty)
                     <*> (o .:? "productPricing")
                     <*> (o .:? "distributionChannel")
                     <*> (o .:? "iconUrl")
                     <*> (o .:? "title")
                     <*> (o .:? "productId")
                     <*> (o .:? "detailsUrl"))

instance ToJSON Product where
        toJSON Product'{..}
          = object
              (catMaybes
                 [("smallIconUrl" .=) <$> _pSmallIconURL,
                  ("authorName" .=) <$> _pAuthorName,
                  Just ("kind" .= _pKind),
                  ("workDetailsUrl" .=) <$> _pWorkDetailsURL,
                  ("requiresContainerApp" .=) <$>
                    _pRequiresContainerApp,
                  ("appVersion" .=) <$> _pAppVersion,
                  ("productPricing" .=) <$> _pProductPricing,
                  ("distributionChannel" .=) <$> _pDistributionChannel,
                  ("iconUrl" .=) <$> _pIconURL,
                  ("title" .=) <$> _pTitle,
                  ("productId" .=) <$> _pProductId,
                  ("detailsUrl" .=) <$> _pDetailsURL])

-- | The entitlement resources for the user.
--
-- /See:/ 'entitlementsListResponse' smart constructor.
data EntitlementsListResponse = EntitlementsListResponse'
    { _entKind        :: !Text
    , _entEntitlement :: !(Maybe [Entitlement])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'EntitlementsListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'entKind'
--
-- * 'entEntitlement'
entitlementsListResponse
    :: EntitlementsListResponse
entitlementsListResponse =
    EntitlementsListResponse'
    { _entKind = "androidenterprise#entitlementsListResponse"
    , _entEntitlement = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#entitlementsListResponse\".
entKind :: Lens' EntitlementsListResponse Text
entKind = lens _entKind (\ s a -> s{_entKind = a})

-- | An entitlement of a user to a product (e.g. an app). For example, a free
-- app that they have installed, or a paid app that they have been
-- allocated a license to.
entEntitlement :: Lens' EntitlementsListResponse [Entitlement]
entEntitlement
  = lens _entEntitlement
      (\ s a -> s{_entEntitlement = a})
      . _Default
      . _Coerce

instance FromJSON EntitlementsListResponse where
        parseJSON
          = withObject "EntitlementsListResponse"
              (\ o ->
                 EntitlementsListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#entitlementsListResponse")
                     <*> (o .:? "entitlement" .!= mempty))

instance ToJSON EntitlementsListResponse where
        toJSON EntitlementsListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _entKind),
                  ("entitlement" .=) <$> _entEntitlement])

-- | Information about the permissions required by a specific app and whether
-- they have been accepted by the enterprise.
--
-- /See:/ 'productPermissions' smart constructor.
data ProductPermissions = ProductPermissions'
    { _ppKind       :: !Text
    , _ppPermission :: !(Maybe [ProductPermission])
    , _ppProductId  :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ProductPermissions' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'ppKind'
--
-- * 'ppPermission'
--
-- * 'ppProductId'
productPermissions
    :: ProductPermissions
productPermissions =
    ProductPermissions'
    { _ppKind = "androidenterprise#productPermissions"
    , _ppPermission = Nothing
    , _ppProductId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#productPermissions\".
ppKind :: Lens' ProductPermissions Text
ppKind = lens _ppKind (\ s a -> s{_ppKind = a})

-- | The permissions required by the app.
ppPermission :: Lens' ProductPermissions [ProductPermission]
ppPermission
  = lens _ppPermission (\ s a -> s{_ppPermission = a})
      . _Default
      . _Coerce

-- | The ID of the app that the permissions relate to, e.g.
-- \"app:com.google.android.gm\".
ppProductId :: Lens' ProductPermissions (Maybe Text)
ppProductId
  = lens _ppProductId (\ s a -> s{_ppProductId = a})

instance FromJSON ProductPermissions where
        parseJSON
          = withObject "ProductPermissions"
              (\ o ->
                 ProductPermissions' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#productPermissions")
                     <*> (o .:? "permission" .!= mempty)
                     <*> (o .:? "productId"))

instance ToJSON ProductPermissions where
        toJSON ProductPermissions'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _ppKind),
                  ("permission" .=) <$> _ppPermission,
                  ("productId" .=) <$> _ppProductId])

-- | A permission represents some extra capability, to be granted to an
-- Android app, which requires explicit consent. An enterprise admin must
-- consent to these permissions on behalf of their users before an
-- entitlement for the app can be created. The permissions collection is
-- read-only. The information provided for each permission (localized name
-- and description) is intended to be used in the EMM user interface when
-- obtaining consent from the enterprise.
--
-- /See:/ 'permission' smart constructor.
data Permission = Permission'
    { _perKind         :: !Text
    , _perName         :: !(Maybe Text)
    , _perDescription  :: !(Maybe Text)
    , _perPermissionId :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Permission' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'perKind'
--
-- * 'perName'
--
-- * 'perDescription'
--
-- * 'perPermissionId'
permission
    :: Permission
permission =
    Permission'
    { _perKind = "androidenterprise#permission"
    , _perName = Nothing
    , _perDescription = Nothing
    , _perPermissionId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#permission\".
perKind :: Lens' Permission Text
perKind = lens _perKind (\ s a -> s{_perKind = a})

-- | The name of the permission.
perName :: Lens' Permission (Maybe Text)
perName = lens _perName (\ s a -> s{_perName = a})

-- | A longer description of the permissions giving more details of what it
-- affects.
perDescription :: Lens' Permission (Maybe Text)
perDescription
  = lens _perDescription
      (\ s a -> s{_perDescription = a})

-- | An opaque string uniquely identifying the permission.
perPermissionId :: Lens' Permission (Maybe Text)
perPermissionId
  = lens _perPermissionId
      (\ s a -> s{_perPermissionId = a})

instance FromJSON Permission where
        parseJSON
          = withObject "Permission"
              (\ o ->
                 Permission' <$>
                   (o .:? "kind" .!= "androidenterprise#permission") <*>
                     (o .:? "name")
                     <*> (o .:? "description")
                     <*> (o .:? "permissionId"))

instance ToJSON Permission where
        toJSON Permission'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _perKind), ("name" .=) <$> _perName,
                  ("description" .=) <$> _perDescription,
                  ("permissionId" .=) <$> _perPermissionId])

--
-- /See:/ 'productsApproveRequest' smart constructor.
newtype ProductsApproveRequest = ProductsApproveRequest'
    { _parApprovalURLInfo :: Maybe ApprovalURLInfo
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ProductsApproveRequest' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'parApprovalURLInfo'
productsApproveRequest
    :: ProductsApproveRequest
productsApproveRequest =
    ProductsApproveRequest'
    { _parApprovalURLInfo = Nothing
    }

-- | The approval URL that was shown to the user. Only the permissions shown
-- to the user with that URL will be accepted, which may not be the
-- product\'s entire set of permissions. For example, the URL may only
-- display new permissions from an update after the product was approved,
-- or not include new permissions if the product was updated since the URL
-- was generated.
parApprovalURLInfo :: Lens' ProductsApproveRequest (Maybe ApprovalURLInfo)
parApprovalURLInfo
  = lens _parApprovalURLInfo
      (\ s a -> s{_parApprovalURLInfo = a})

instance FromJSON ProductsApproveRequest where
        parseJSON
          = withObject "ProductsApproveRequest"
              (\ o ->
                 ProductsApproveRequest' <$>
                   (o .:? "approvalUrlInfo"))

instance ToJSON ProductsApproveRequest where
        toJSON ProductsApproveRequest'{..}
          = object
              (catMaybes
                 [("approvalUrlInfo" .=) <$> _parApprovalURLInfo])

-- | The user resources for the collection.
--
-- /See:/ 'collectionViewersListResponse' smart constructor.
data CollectionViewersListResponse = CollectionViewersListResponse'
    { _cvlrKind :: !Text
    , _cvlrUser :: !(Maybe [User])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'CollectionViewersListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'cvlrKind'
--
-- * 'cvlrUser'
collectionViewersListResponse
    :: CollectionViewersListResponse
collectionViewersListResponse =
    CollectionViewersListResponse'
    { _cvlrKind = "androidenterprise#collectionViewersListResponse"
    , _cvlrUser = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#collectionViewersListResponse\".
cvlrKind :: Lens' CollectionViewersListResponse Text
cvlrKind = lens _cvlrKind (\ s a -> s{_cvlrKind = a})

-- | A user of an enterprise.
cvlrUser :: Lens' CollectionViewersListResponse [User]
cvlrUser
  = lens _cvlrUser (\ s a -> s{_cvlrUser = a}) .
      _Default
      . _Coerce

instance FromJSON CollectionViewersListResponse where
        parseJSON
          = withObject "CollectionViewersListResponse"
              (\ o ->
                 CollectionViewersListResponse' <$>
                   (o .:? "kind" .!=
                      "androidenterprise#collectionViewersListResponse")
                     <*> (o .:? "user" .!= mempty))

instance ToJSON CollectionViewersListResponse where
        toJSON CollectionViewersListResponse'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _cvlrKind),
                  ("user" .=) <$> _cvlrUser])

-- | The existence of an entitlement resource means that a user has the right
-- to use a particular app on any of their devices. This might be because
-- the app is free or because they have been allocated a license to the app
-- from a group license purchased by the enterprise. It should always be
-- true that a user has an app installed on one of their devices only if
-- they have an entitlement to it. So if an entitlement is deleted, the app
-- will be uninstalled from all devices. Similarly if the user installs an
-- app (and is permitted to do so), or the EMM triggers an install of the
-- app, an entitlement to that app is automatically created. If this is
-- impossible - e.g. the enterprise has not purchased sufficient licenses -
-- then installation fails. Note that entitlements are always user
-- specific, not device specific; a user may have an entitlement even
-- though they have not installed the app anywhere. Once they have an
-- entitlement they can install the app on multiple devices. The API can be
-- used to create an entitlement. If the app is a free app, a group license
-- for that app is created. If it\'s a paid app, creating the entitlement
-- consumes one license; it remains consumed until the entitlement is
-- removed. Optionally an installation of the app on all the user\'s
-- managed devices can be triggered at the time the entitlement is created.
-- An entitlement cannot be created for an app if the app requires
-- permissions that the enterprise has not yet accepted. Entitlements for
-- paid apps that are due to purchases by the user on a non-managed profile
-- will have \"userPurchase\" as entitlement reason; those entitlements
-- cannot be removed via the API.
--
-- /See:/ 'entitlement' smart constructor.
data Entitlement = Entitlement'
    { _eeKind      :: !Text
    , _eeReason    :: !(Maybe Text)
    , _eeProductId :: !(Maybe Text)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'Entitlement' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'eeKind'
--
-- * 'eeReason'
--
-- * 'eeProductId'
entitlement
    :: Entitlement
entitlement =
    Entitlement'
    { _eeKind = "androidenterprise#entitlement"
    , _eeReason = Nothing
    , _eeProductId = Nothing
    }

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#entitlement\".
eeKind :: Lens' Entitlement Text
eeKind = lens _eeKind (\ s a -> s{_eeKind = a})

-- | The reason for the entitlement, e.g. \"free\" for free apps. This is
-- temporary, it will be replaced by the acquisition kind field of group
-- licenses.
eeReason :: Lens' Entitlement (Maybe Text)
eeReason = lens _eeReason (\ s a -> s{_eeReason = a})

-- | The ID of the product that the entitlement is for, e.g.
-- \"app:com.google.android.gm\".
eeProductId :: Lens' Entitlement (Maybe Text)
eeProductId
  = lens _eeProductId (\ s a -> s{_eeProductId = a})

instance FromJSON Entitlement where
        parseJSON
          = withObject "Entitlement"
              (\ o ->
                 Entitlement' <$>
                   (o .:? "kind" .!= "androidenterprise#entitlement")
                     <*> (o .:? "reason")
                     <*> (o .:? "productId"))

instance ToJSON Entitlement where
        toJSON Entitlement'{..}
          = object
              (catMaybes
                 [Just ("kind" .= _eeKind),
                  ("reason" .=) <$> _eeReason,
                  ("productId" .=) <$> _eeProductId])

-- | The matching products.
--
-- /See:/ 'productsListResponse' smart constructor.
data ProductsListResponse = ProductsListResponse'
    { _plrTokenPagination :: !(Maybe TokenPagination)
    , _plrPageInfo        :: !(Maybe PageInfo)
    , _plrKind            :: !Text
    , _plrProduct         :: !(Maybe [Product])
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'ProductsListResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'plrTokenPagination'
--
-- * 'plrPageInfo'
--
-- * 'plrKind'
--
-- * 'plrProduct'
productsListResponse
    :: ProductsListResponse
productsListResponse =
    ProductsListResponse'
    { _plrTokenPagination = Nothing
    , _plrPageInfo = Nothing
    , _plrKind = "androidenterprise#productsListResponse"
    , _plrProduct = Nothing
    }

-- | Pagination information for token pagination.
plrTokenPagination :: Lens' ProductsListResponse (Maybe TokenPagination)
plrTokenPagination
  = lens _plrTokenPagination
      (\ s a -> s{_plrTokenPagination = a})

-- | General pagination information.
plrPageInfo :: Lens' ProductsListResponse (Maybe PageInfo)
plrPageInfo
  = lens _plrPageInfo (\ s a -> s{_plrPageInfo = a})

-- | Identifies what kind of resource this is. Value: the fixed string
-- \"androidenterprise#productsListResponse\".
plrKind :: Lens' ProductsListResponse Text
plrKind = lens _plrKind (\ s a -> s{_plrKind = a})

-- | Information about a product (e.g. an app) in the Google Play Store, for
-- display to an enterprise admin.
plrProduct :: Lens' ProductsListResponse [Product]
plrProduct
  = lens _plrProduct (\ s a -> s{_plrProduct = a}) .
      _Default
      . _Coerce

instance FromJSON ProductsListResponse where
        parseJSON
          = withObject "ProductsListResponse"
              (\ o ->
                 ProductsListResponse' <$>
                   (o .:? "tokenPagination") <*> (o .:? "pageInfo") <*>
                     (o .:? "kind" .!=
                        "androidenterprise#productsListResponse")
                     <*> (o .:? "product" .!= mempty))

instance ToJSON ProductsListResponse where
        toJSON ProductsListResponse'{..}
          = object
              (catMaybes
                 [("tokenPagination" .=) <$> _plrTokenPagination,
                  ("pageInfo" .=) <$> _plrPageInfo,
                  Just ("kind" .= _plrKind),
                  ("product" .=) <$> _plrProduct])
