{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE FlexibleInstances  #-}
{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}
{-# LANGUAGE TypeOperators      #-}

{-# OPTIONS_GHC -fno-warn-duplicate-exports #-}
{-# OPTIONS_GHC -fno-warn-unused-binds      #-}
{-# OPTIONS_GHC -fno-warn-unused-imports    #-}

-- |
-- Module      : Network.Google.Resource.DFAReporting.DirectorySiteContacts.Get
-- Copyright   : (c) 2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Gets one directory site contact by ID.
--
-- /See:/ <https://developers.google.com/doubleclick-advertisers/reporting/ DCM/DFA Reporting And Trafficking API Reference> for @dfareporting.directorySiteContacts.get@.
module Network.Google.Resource.DFAReporting.DirectorySiteContacts.Get
    (
    -- * REST Resource
      DirectorySiteContactsGetResource

    -- * Creating a Request
    , directorySiteContactsGet
    , DirectorySiteContactsGet

    -- * Request Lenses
    , dscgProFileId
    , dscgId
    ) where

import           Network.Google.DFAReporting.Types
import           Network.Google.Prelude

-- | A resource alias for @dfareporting.directorySiteContacts.get@ method which the
-- 'DirectorySiteContactsGet' request conforms to.
type DirectorySiteContactsGetResource =
     "dfareporting" :>
       "v2.2" :>
         "userprofiles" :>
           Capture "profileId" (JSONText Int64) :>
             "directorySiteContacts" :>
               Capture "id" (JSONText Int64) :>
                 QueryParam "alt" AltJSON :>
                   Get '[JSON] DirectorySiteContact

-- | Gets one directory site contact by ID.
--
-- /See:/ 'directorySiteContactsGet' smart constructor.
data DirectorySiteContactsGet = DirectorySiteContactsGet
    { _dscgProFileId :: !(JSONText Int64)
    , _dscgId        :: !(JSONText Int64)
    } deriving (Eq,Show,Data,Typeable,Generic)

-- | Creates a value of 'DirectorySiteContactsGet' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'dscgProFileId'
--
-- * 'dscgId'
directorySiteContactsGet
    :: Int64 -- ^ 'dscgProFileId'
    -> Int64 -- ^ 'dscgId'
    -> DirectorySiteContactsGet
directorySiteContactsGet pDscgProFileId_ pDscgId_ =
    DirectorySiteContactsGet
    { _dscgProFileId = pDscgProFileId_
    , _dscgId = pDscgId_
    }

-- | User profile ID associated with this request.
dscgProFileId :: Lens' DirectorySiteContactsGet Int64
dscgProFileId
  = lens _dscgProFileId
      (\ s a -> s{_dscgProFileId = a})
      . _Coerce

-- | Directory site contact ID.
dscgId :: Lens' DirectorySiteContactsGet Int64
dscgId
  = lens _dscgId (\ s a -> s{_dscgId = a}) . _Coerce

instance GoogleRequest DirectorySiteContactsGet where
        type Rs DirectorySiteContactsGet =
             DirectorySiteContact
        requestClient DirectorySiteContactsGet{..}
          = go _dscgProFileId _dscgId (Just AltJSON)
              dFAReportingService
          where go
                  = buildClient
                      (Proxy :: Proxy DirectorySiteContactsGetResource)
                      mempty
