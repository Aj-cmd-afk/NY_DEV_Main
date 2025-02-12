{-# OPTIONS_GHC -Wno-dodgy-exports #-}
{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Storage.Queries.SearchRequest (module Storage.Queries.SearchRequest, module ReExport) where

import qualified Domain.Types.Merchant
import qualified Domain.Types.SearchRequest
import qualified Domain.Types.Trip
import Kernel.Beam.Functions
import Kernel.External.Encryption
import Kernel.Prelude
import qualified Kernel.Prelude
import Kernel.Types.Error
import qualified Kernel.Types.Id
import Kernel.Utils.Common (CacheFlow, EsqDBFlow, MonadFlow, fromMaybeM, getCurrentTime)
import qualified Sequelize as Se
import qualified Storage.Beam.SearchRequest as Beam
import Storage.Queries.SearchRequestExtra as ReExport

findById :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Kernel.Types.Id.Id Domain.Types.SearchRequest.SearchRequest -> m (Maybe Domain.Types.SearchRequest.SearchRequest))
findById id = do findOneWithKV [Se.Is Beam.id $ Se.Eq (Kernel.Types.Id.getId id)]

findByTransactionIdAndMerchantId ::
  (EsqDBFlow m r, MonadFlow m, CacheFlow m r) =>
  (Kernel.Prelude.Text -> Kernel.Types.Id.Id Domain.Types.Merchant.Merchant -> m (Maybe Domain.Types.SearchRequest.SearchRequest))
findByTransactionIdAndMerchantId transactionId providerId = do findOneWithKV [Se.And [Se.Is Beam.transactionId $ Se.Eq transactionId, Se.Is Beam.providerId $ Se.Eq (Kernel.Types.Id.getId providerId)]]

updateIsAdvancedBookingEnabled :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Kernel.Prelude.Bool -> Kernel.Types.Id.Id Domain.Types.SearchRequest.SearchRequest -> m ())
updateIsAdvancedBookingEnabled isAdvanceBookingEnabled id = do updateWithKV [Se.Set Beam.isAdvanceBookingEnabled (Just isAdvanceBookingEnabled)] [Se.Is Beam.id $ Se.Eq (Kernel.Types.Id.getId id)]

updateIsReallocationEnabled :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Kernel.Prelude.Maybe Kernel.Prelude.Bool -> Kernel.Types.Id.Id Domain.Types.SearchRequest.SearchRequest -> m ())
updateIsReallocationEnabled isReallocationEnabled id = do updateWithKV [Se.Set Beam.isReallocationEnabled isReallocationEnabled] [Se.Is Beam.id $ Se.Eq (Kernel.Types.Id.getId id)]

updateSearchTags :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Kernel.Prelude.Maybe [Kernel.Prelude.Text] -> Kernel.Types.Id.Id Domain.Types.SearchRequest.SearchRequest -> m ())
updateSearchTags searchTags id = do updateWithKV [Se.Set Beam.searchTags searchTags] [Se.Is Beam.id $ Se.Eq (Kernel.Types.Id.getId id)]

updateTripCategory :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Kernel.Prelude.Maybe Domain.Types.Trip.TripCategory -> Kernel.Types.Id.Id Domain.Types.SearchRequest.SearchRequest -> m ())
updateTripCategory tripCategory id = do updateWithKV [Se.Set Beam.tripCategory tripCategory] [Se.Is Beam.id $ Se.Eq (Kernel.Types.Id.getId id)]
