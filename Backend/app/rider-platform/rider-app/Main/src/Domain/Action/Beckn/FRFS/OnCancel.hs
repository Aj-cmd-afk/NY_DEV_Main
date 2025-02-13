{-
 Copyright 2022-23, Juspay India Pvt Ltd

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License

 as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program

 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY

 or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details. You should have received a copy of

 the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
-}

module Domain.Action.Beckn.FRFS.OnCancel where

import qualified BecknV2.FRFS.Enums as Spec
import qualified Domain.Types.FRFSTicket as DFRFSTicket
import qualified Domain.Types.FRFSTicketBooking as Booking
import qualified Domain.Types.FRFSTicketBooking as FTBooking
import qualified Domain.Types.FRFSTicketBookingPayment as DTBP
import Domain.Types.Merchant as Merchant
import Environment
import Kernel.Beam.Functions
import Kernel.Prelude
import qualified Kernel.Storage.Hedis as Redis
import Kernel.Types.Error
import Kernel.Types.Id
import Kernel.Utils.Common
import qualified Storage.CachedQueries.Merchant as QMerch
import qualified Storage.CachedQueries.Person as CQP
import qualified Storage.Queries.FRFSRecon as QFRFSRecon
import qualified Storage.Queries.FRFSTicket as QTicket
import qualified Storage.Queries.FRFSTicketBooking as QTBooking
import qualified Storage.Queries.FRFSTicketBookingPayment as QTBP
import qualified Storage.Queries.PersonStats as QPS

data DOnCancel = DOnCancel
  { providerId :: Text,
    totalPrice :: HighPrecMoney,
    bppOrderId :: Text,
    bppItemId :: Text,
    transactionId :: Text,
    messageId :: Text,
    orderStatus :: Spec.OrderStatus,
    refundAmount :: HighPrecMoney,
    baseFare :: HighPrecMoney,
    cancellationCharges :: HighPrecMoney
  }

validateRequest :: DOnCancel -> Flow (Merchant, FTBooking.FRFSTicketBooking)
validateRequest DOnCancel {..} = do
  booking <- runInReplica $ QTBooking.findBySearchId (Id transactionId) >>= fromMaybeM (BookingDoesNotExist messageId)
  let merchantId = booking.merchantId
  merchant <- QMerch.findById merchantId >>= fromMaybeM (MerchantNotFound merchantId.getId)
  when (totalPrice /= baseFare + refundAmount + cancellationCharges) $ throwError (InternalError "Fare Mismatch in onCancel Req")
  return (merchant, booking)

onCancel :: Merchant -> Booking.FRFSTicketBooking -> DOnCancel -> Flow ()
onCancel _ booking' dOnCancel = do
  let booking = booking' {Booking.bppOrderId = Just dOnCancel.bppOrderId}
  case dOnCancel.orderStatus of
    Spec.ON_CANCEL_SOFT_CANCEL -> do
      void $ QTBooking.updateRefundCancellationChargesAndIsCancellableByBookingId (Just dOnCancel.refundAmount) (Just dOnCancel.cancellationCharges) (Just True) booking.id
    Spec.ON_CANCEL_CANCELLED -> do
      val :: Maybe Bool <- Redis.get (makecancelledTtlKey booking.id)
      case val of
        Nothing -> do
          void $ QTBooking.updateStatusById FTBooking.COUNTER_CANCELLED booking.id
          void $ QTicket.updateAllStatusByBookingId DFRFSTicket.COUNTER_CANCELLED booking.id
          void $ QFRFSRecon.updateStatusByTicketBookingId (Just DFRFSTicket.COUNTER_CANCELLED) booking.id
        Just _ -> do
          void $ checkRefundAndCancellationCharges booking.id
          void $ QTBooking.updateStatusById FTBooking.CANCELLED booking.id
          void $ QTicket.updateAllStatusByBookingId DFRFSTicket.CANCELLED booking.id
          void $ QFRFSRecon.updateStatusByTicketBookingId (Just DFRFSTicket.CANCELLED) booking.id
          void $ QTBP.updateStatusByTicketBookingId DTBP.REFUND_PENDING booking.id
          void $ QTBooking.updateIsBookingCancellableByBookingId (Just True) booking.id
          void $ QTBooking.updateCustomerCancelledByBookingId True booking.id
          void $ Redis.del (makecancelledTtlKey booking.id)
      void $ QPS.incrementTicketsBookedInEvent booking.riderId (- (booking.quantity))
      void $ CQP.clearPSCache booking.riderId
    _ -> throwError $ InvalidRequest "Unexpected orderStatus received"
  return ()
  where
    checkRefundAndCancellationCharges bookingId = do
      booking <- runInReplica $ QTBooking.findById bookingId >>= fromMaybeM (BookingDoesNotExist bookingId.getId)
      case booking of
        Booking.FRFSTicketBooking {refundAmount = Just rfAmount, cancellationCharges = Just charges} -> do
          when (rfAmount /= dOnCancel.refundAmount) $
            throwError $ InternalError "Refund Amount mismatch in onCancel Req"
          when (charges /= dOnCancel.cancellationCharges) $
            throwError $ InternalError "Cancellation Charges mismatch in onCancel Req"
        _ -> throwError $ InternalError "Refund Amount or Cancellation Charges not found in booking"

makecancelledTtlKey :: Id FTBooking.FRFSTicketBooking -> Text
makecancelledTtlKey bookingId = "FRFS:OnConfirm:CancelledTTL:bookingId-" <> bookingId.getId
