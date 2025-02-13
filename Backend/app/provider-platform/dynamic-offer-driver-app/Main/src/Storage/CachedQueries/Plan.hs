{-# OPTIONS_GHC -Wno-deprecations #-}

module Storage.CachedQueries.Plan where

import qualified Domain.Types.MerchantOperatingCity as DMOC
import Domain.Types.Plan
import qualified Domain.Types.VehicleVariant as Vehicle
import Kernel.Prelude
import qualified Kernel.Storage.Hedis as Hedis
import Kernel.Types.Id
import Kernel.Utils.Common
import qualified Storage.Queries.Plan as Queries

findByIdAndPaymentModeWithServiceName :: (MonadFlow m, CacheFlow m r, EsqDBFlow m r) => Id Plan -> PaymentMode -> ServiceNames -> m (Maybe Plan)
findByIdAndPaymentModeWithServiceName (Id planId) paymentMode serviceName =
  Hedis.withCrossAppRedis (Hedis.safeGet $ makePlanIdAndPaymentModeKey (Id planId) paymentMode serviceName) >>= \case
    Just a -> pure a
    Nothing -> cacheByIdAndPaymentMode (Id planId) paymentMode serviceName /=<< Queries.findByIdAndPaymentModeWithServiceName (Id planId) paymentMode serviceName

cacheByIdAndPaymentMode :: (CacheFlow m r) => Id Plan -> PaymentMode -> ServiceNames -> Maybe Plan -> m ()
cacheByIdAndPaymentMode (Id planId) paymentMode serviceName plan = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.withCrossAppRedis $ Hedis.setExp (makePlanIdAndPaymentModeKey (Id planId) paymentMode serviceName) plan expTime

------------------- -----------------------
findByMerchantOpCityIdWithServiceName :: (CacheFlow m r, MonadFlow m, EsqDBFlow m r) => Id DMOC.MerchantOperatingCity -> ServiceNames -> m [Plan]
findByMerchantOpCityIdWithServiceName (Id merchantOperatingCityId) serviceName =
  Hedis.withCrossAppRedis (Hedis.safeGet $ makeMerchantIdKey (Id merchantOperatingCityId) serviceName) >>= \case
    Just a -> pure a
    Nothing -> cacheByMerchantId (Id merchantOperatingCityId) serviceName /=<< Queries.findByMerchantOpCityIdWithServiceName (Id merchantOperatingCityId) serviceName

cacheByMerchantId :: CacheFlow m r => Id DMOC.MerchantOperatingCity -> ServiceNames -> [Plan] -> m ()
cacheByMerchantId (Id merchantOperatingCityId) serviceName plans = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.withCrossAppRedis $ Hedis.setExp (makeMerchantIdKey (Id merchantOperatingCityId) serviceName) plans expTime

------------------- -----------------------
findByMerchantOpCityIdAndPaymentModeWithServiceName ::
  (CacheFlow m r, MonadFlow m, EsqDBFlow m r) =>
  Id DMOC.MerchantOperatingCity ->
  PaymentMode ->
  ServiceNames ->
  Maybe Bool ->
  m [Plan]
findByMerchantOpCityIdAndPaymentModeWithServiceName (Id merchantOperatingCityId) paymentMode serviceName mbIsDeprecated =
  Hedis.withCrossAppRedis (Hedis.safeGet $ makeMerchantIdAndPaymentModeKey (Id merchantOperatingCityId) paymentMode serviceName mbIsDeprecated) >>= \case
    Just a -> pure a
    Nothing -> cacheByMerchantIdAndPaymentMode (Id merchantOperatingCityId) paymentMode serviceName mbIsDeprecated /=<< Queries.findByMerchantOpCityIdAndPaymentModeWithServiceName (Id merchantOperatingCityId) paymentMode serviceName mbIsDeprecated

cacheByMerchantIdAndPaymentMode ::
  (CacheFlow m r) =>
  Id DMOC.MerchantOperatingCity ->
  PaymentMode ->
  ServiceNames ->
  Maybe Bool ->
  [Plan] ->
  m ()
cacheByMerchantIdAndPaymentMode (Id merchantOperatingCityId) paymentMode serviceName mbIsDeprecated plans = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.withCrossAppRedis $ Hedis.setExp (makeMerchantIdAndPaymentModeKey (Id merchantOperatingCityId) paymentMode serviceName mbIsDeprecated) plans expTime

findByMerchantOpCityIdAndTypeWithServiceName :: (CacheFlow m r, MonadFlow m, EsqDBFlow m r) => Id DMOC.MerchantOperatingCity -> PlanType -> ServiceNames -> m [Plan]
findByMerchantOpCityIdAndTypeWithServiceName (Id merchantOperatingCityId) planType serviceName =
  Hedis.withCrossAppRedis (Hedis.safeGet $ makeMerchantIdAndTypeKey (Id merchantOperatingCityId) planType serviceName) >>= \case
    Just a -> pure a
    Nothing -> cacheByMerchantIdAndType (Id merchantOperatingCityId) planType serviceName /=<< Queries.findByMerchantOpCityIdAndTypeWithServiceName (Id merchantOperatingCityId) planType serviceName

cacheByMerchantIdAndType :: (CacheFlow m r) => Id DMOC.MerchantOperatingCity -> PlanType -> ServiceNames -> [Plan] -> m ()
cacheByMerchantIdAndType (Id merchantOperatingCityId) planType serviceName plans = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.withCrossAppRedis $ Hedis.setExp (makeMerchantIdAndTypeKey (Id merchantOperatingCityId) planType serviceName) plans expTime

findByMerchantOpCityIdAndTypeWithServiceNameAndVariant ::
  (CacheFlow m r, MonadFlow m, EsqDBFlow m r) =>
  Id DMOC.MerchantOperatingCity ->
  PaymentMode ->
  ServiceNames ->
  Maybe Vehicle.VehicleVariant ->
  Maybe Bool ->
  m [Plan]
findByMerchantOpCityIdAndTypeWithServiceNameAndVariant (Id merchantOperatingCityId) paymentMode serviceName mbVehicleVariant mbIsDeprecated =
  Hedis.withCrossAppRedis (Hedis.safeGet $ makeMerchantIdAndPaymentModeAndVariantKey (Id merchantOperatingCityId) paymentMode serviceName mbVehicleVariant mbIsDeprecated) >>= \case
    Just a -> pure a
    Nothing -> cacheByMerchantIdAndTypeAndVariant (Id merchantOperatingCityId) paymentMode serviceName mbVehicleVariant mbIsDeprecated /=<< Queries.findByMerchantOpCityIdAndTypeWithServiceNameAndVariant (Id merchantOperatingCityId) paymentMode serviceName mbVehicleVariant

cacheByMerchantIdAndTypeAndVariant ::
  (CacheFlow m r) =>
  Id DMOC.MerchantOperatingCity ->
  PaymentMode ->
  ServiceNames ->
  Maybe Vehicle.VehicleVariant ->
  Maybe Bool ->
  [Plan] ->
  m ()
cacheByMerchantIdAndTypeAndVariant (Id merchantOperatingCityId) paymentMode serviceName mbVehicleVariant mbIsDeprecated plans = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.withCrossAppRedis $ Hedis.setExp (makeMerchantIdAndPaymentModeAndVariantKey (Id merchantOperatingCityId) paymentMode serviceName mbVehicleVariant mbIsDeprecated) plans expTime

------------------- -----------------------
fetchAllPlan :: (CacheFlow m r, MonadFlow m, EsqDBFlow m r) => m [Plan]
fetchAllPlan =
  Hedis.withCrossAppRedis (Hedis.safeGet makeAllPlanKey) >>= \case
    Just a -> pure a
    Nothing -> cacheAllPlan /=<< Queries.fetchAllPlan

cacheAllPlan :: (CacheFlow m r) => [Plan] -> m ()
cacheAllPlan plans = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.withCrossAppRedis $ Hedis.setExp makeAllPlanKey plans expTime

makeAllPlanKey :: Text
makeAllPlanKey = "driver-offer:CachedQueries:Plan:PlanId-ALL"

makePlanIdAndPaymentModeKey :: Id Plan -> PaymentMode -> ServiceNames -> Text
makePlanIdAndPaymentModeKey id paymentMode serviceName = "driver-offer:CachedQueries:Plan:PlanId-" <> id.getId <> ":PaymentMode-" <> show paymentMode <> ":ServiceName-" <> show serviceName

makeMerchantIdAndPaymentModeKey :: Id DMOC.MerchantOperatingCity -> PaymentMode -> ServiceNames -> Maybe Bool -> Text
makeMerchantIdAndPaymentModeKey merchantOpCityId paymentMode serviceName mbIsDeprecated =
  "driver-offer:CachedQueries:Plan:MerchantOperatingCityId-"
    <> merchantOpCityId.getId
    <> ":PaymentMode-"
    <> show paymentMode
    <> ":ServiceName-"
    <> show serviceName
    <> ":IsDeprecated-"
    <> show mbIsDeprecated

makeMerchantIdAndTypeKey :: Id DMOC.MerchantOperatingCity -> PlanType -> ServiceNames -> Text
makeMerchantIdAndTypeKey merchantOpCityId planType serviceName = "driver-offer:CachedQueries:Plan:MerchantOperatingCityId-" <> merchantOpCityId.getId <> ":PlanType-" <> show planType <> ":ServiceName-" <> show serviceName

makeMerchantIdKey :: Id DMOC.MerchantOperatingCity -> ServiceNames -> Text
makeMerchantIdKey merchantOpCityId serviceName = "driver-offer:CachedQueries:Plan:MerchantOperatingCityId-" <> merchantOpCityId.getId <> ":ServiceName-" <> show serviceName

makeMerchantIdAndPaymentModeAndVariantKey :: Id DMOC.MerchantOperatingCity -> PaymentMode -> ServiceNames -> Maybe Vehicle.VehicleVariant -> Maybe Bool -> Text
makeMerchantIdAndPaymentModeAndVariantKey merchantOpCityId paymentMode serviceName mbVehicleVariant mbIsDeprecated =
  "driver-offer:CachedQueries:Plan:MerchantOperatingCityId-"
    <> merchantOpCityId.getId
    <> ":PaymentMode-"
    <> show paymentMode
    <> ":ServiceName-"
    <> show serviceName
    <> ":VehicleVariant-"
    <> show mbVehicleVariant
    <> ":IsDeprecated-"
    <> show mbIsDeprecated
