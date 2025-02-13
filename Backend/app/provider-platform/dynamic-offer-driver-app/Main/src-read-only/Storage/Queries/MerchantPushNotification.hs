{-# OPTIONS_GHC -Wno-dodgy-exports #-}
{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Storage.Queries.MerchantPushNotification where

import qualified Domain.Types.MerchantOperatingCity
import qualified Domain.Types.MerchantPushNotification
import Kernel.Beam.Functions
import Kernel.External.Encryption
import qualified Kernel.External.Types
import Kernel.Prelude
import qualified Kernel.Prelude
import Kernel.Types.Error
import qualified Kernel.Types.Id
import Kernel.Utils.Common (CacheFlow, EsqDBFlow, MonadFlow, fromMaybeM, getCurrentTime)
import qualified Sequelize as Se
import qualified Storage.Beam.MerchantPushNotification as Beam

create :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Domain.Types.MerchantPushNotification.MerchantPushNotification -> m ())
create = createWithKV

createMany :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => ([Domain.Types.MerchantPushNotification.MerchantPushNotification] -> m ())
createMany = traverse_ create

findAllByMerchantOpCityId ::
  (EsqDBFlow m r, MonadFlow m, CacheFlow m r) =>
  (Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity -> m [Domain.Types.MerchantPushNotification.MerchantPushNotification])
findAllByMerchantOpCityId merchantOperatingCityId = do findAllWithKV [Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId)]

findAllByMerchantOpCityIdAndMessageKey ::
  (EsqDBFlow m r, MonadFlow m, CacheFlow m r) =>
  (Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity -> Kernel.Prelude.Text -> m [Domain.Types.MerchantPushNotification.MerchantPushNotification])
findAllByMerchantOpCityIdAndMessageKey merchantOperatingCityId key = do
  findAllWithKV
    [ Se.And
        [ Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId),
          Se.Is Beam.key $ Se.Eq key
        ]
    ]

findByPrimaryKey ::
  (EsqDBFlow m r, MonadFlow m, CacheFlow m r) =>
  (Kernel.Prelude.Text -> Kernel.External.Types.Language -> Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity -> m (Maybe Domain.Types.MerchantPushNotification.MerchantPushNotification))
findByPrimaryKey key language merchantOperatingCityId = do
  findOneWithKV
    [ Se.And
        [ Se.Is Beam.key $ Se.Eq key,
          Se.Is Beam.language $ Se.Eq language,
          Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId)
        ]
    ]

updateByPrimaryKey :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Domain.Types.MerchantPushNotification.MerchantPushNotification -> m ())
updateByPrimaryKey (Domain.Types.MerchantPushNotification.MerchantPushNotification {..}) = do
  _now <- getCurrentTime
  updateWithKV
    [ Se.Set Beam.body body,
      Se.Set Beam.fcmNotificationType fcmNotificationType,
      Se.Set Beam.merchantId (Kernel.Types.Id.getId merchantId),
      Se.Set Beam.title title,
      Se.Set Beam.createdAt createdAt,
      Se.Set Beam.updatedAt _now
    ]
    [ Se.And
        [ Se.Is Beam.key $ Se.Eq key,
          Se.Is Beam.language $ Se.Eq language,
          Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId)
        ]
    ]

instance FromTType' Beam.MerchantPushNotification Domain.Types.MerchantPushNotification.MerchantPushNotification where
  fromTType' (Beam.MerchantPushNotificationT {..}) = do
    pure $
      Just
        Domain.Types.MerchantPushNotification.MerchantPushNotification
          { body = body,
            fcmNotificationType = fcmNotificationType,
            key = key,
            language = language,
            merchantId = Kernel.Types.Id.Id merchantId,
            merchantOperatingCityId = Kernel.Types.Id.Id merchantOperatingCityId,
            title = title,
            createdAt = createdAt,
            updatedAt = updatedAt
          }

instance ToTType' Beam.MerchantPushNotification Domain.Types.MerchantPushNotification.MerchantPushNotification where
  toTType' (Domain.Types.MerchantPushNotification.MerchantPushNotification {..}) = do
    Beam.MerchantPushNotificationT
      { Beam.body = body,
        Beam.fcmNotificationType = fcmNotificationType,
        Beam.key = key,
        Beam.language = language,
        Beam.merchantId = Kernel.Types.Id.getId merchantId,
        Beam.merchantOperatingCityId = Kernel.Types.Id.getId merchantOperatingCityId,
        Beam.title = title,
        Beam.createdAt = createdAt,
        Beam.updatedAt = updatedAt
      }
