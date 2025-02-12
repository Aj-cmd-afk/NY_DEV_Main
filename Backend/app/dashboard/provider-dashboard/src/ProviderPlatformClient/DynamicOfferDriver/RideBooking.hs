{-
 Copyright 2022-23, Juspay India Pvt Ltd

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License

 as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program

 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY

 or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details. You should have received a copy of

 the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
-}
{-# LANGUAGE AllowAmbiguousTypes #-}

module ProviderPlatformClient.DynamicOfferDriver.RideBooking
  ( callDriverOfferBPP,
  )
where

import "dynamic-offer-driver-app" API.Dashboard.RideBooking as BPP
import qualified API.Types.ProviderPlatform.RideBooking.Driver as DriverDSL
import qualified Dashboard.ProviderPlatform.Management.DriverRegistration as Registration
import qualified Dashboard.ProviderPlatform.Management.Ride as Ride
import qualified Dashboard.ProviderPlatform.Volunteer as Volunteer
import qualified "dynamic-offer-driver-app" Domain.Action.UI.Maps as DMaps
import qualified "lib-dashboard" Domain.Types.Merchant as DM
import qualified "dynamic-offer-driver-app" Domain.Types.Person as DP
import Domain.Types.ServerName
import qualified EulerHS.Types as Euler
import Kernel.Prelude
import Kernel.Types.APISuccess (APISuccess)
import qualified Kernel.Types.Beckn.City as City
import Kernel.Types.Id
import Kernel.Utils.Common
import Servant
import Tools.Auth.Merchant (CheckedShortId)
import Tools.Client
import "lib-dashboard" Tools.Metrics

data DriverRideBookingAPIs = DriverRideBookingAPIs
  { driverRegistration :: DriverRegistrationAPIs,
    rides :: RidesAPIs,
    volunteer :: VolunteerAPIs,
    maps :: MapsAPIs,
    driverDSL :: DriverDSL.DriverAPIs
  }

data RidesAPIs = RidesAPIs
  { rideStart :: Id Ride.Ride -> Ride.StartRideReq -> Euler.EulerClient APISuccess,
    rideEnd :: Id Ride.Ride -> Ride.EndRideReq -> Euler.EulerClient APISuccess,
    currentActiveRide :: Text -> Euler.EulerClient (Id Ride.Ride),
    rideCancel :: Id Ride.Ride -> Ride.CancelRideReq -> Euler.EulerClient APISuccess,
    bookingWithVehicleNumberAndPhone :: Ride.BookingWithVehicleAndPhoneReq -> Euler.EulerClient Ride.BookingWithVehicleAndPhoneRes,
    fareBreakUp :: Id Ride.Ride -> Euler.EulerClient Ride.FareBreakUpRes
  }

data DriverRegistrationAPIs = DriverRegistrationAPIs
  { auth :: Registration.AuthReq -> Euler.EulerClient Registration.AuthRes,
    verify :: Text -> Bool -> Text -> Registration.AuthVerifyReq -> Euler.EulerClient APISuccess
  }

data VolunteerAPIs = VolunteerAPIs
  { bookingInfo :: Text -> Euler.EulerClient Volunteer.BookingInfoResponse,
    assignCreateAndStartOtpRide :: Volunteer.AssignCreateAndStartOtpRideAPIReq -> Euler.EulerClient APISuccess
  }

data MapsAPIs = MapsAPIs
  { autoComplete :: Id DP.Person -> DMaps.AutoCompleteReq -> Euler.EulerClient DMaps.AutoCompleteResp,
    getPlaceName :: Id DP.Person -> DMaps.GetPlaceNameReq -> Euler.EulerClient DMaps.GetPlaceNameResp
  }

mkDriverRideBookingAPIs :: CheckedShortId DM.Merchant -> City.City -> Text -> DriverRideBookingAPIs
mkDriverRideBookingAPIs merchantId city token = do
  let rides = RidesAPIs {..}
  let driverRegistration = DriverRegistrationAPIs {..}
  let volunteer = VolunteerAPIs {..}
  let maps = MapsAPIs {..}

  let driverDSL = DriverDSL.mkDriverAPIs driverClientDSL
  DriverRideBookingAPIs {..}
  where
    driverRegistrationClient
      :<|> ridesClient
      :<|> volunteerClient
      :<|> mapsClient
      :<|> driverClientDSL = clientWithMerchantAndCity (Proxy :: Proxy BPP.API) merchantId city token

    rideStart
      :<|> rideEnd
      :<|> currentActiveRide
      :<|> rideCancel
      :<|> bookingWithVehicleNumberAndPhone
      :<|> fareBreakUp = ridesClient

    auth
      :<|> verify = driverRegistrationClient

    bookingInfo
      :<|> assignCreateAndStartOtpRide = volunteerClient

    autoComplete
      :<|> getPlaceName = mapsClient

callDriverOfferBPP ::
  forall m r b c.
  ( CoreMetrics m,
    HasFlowEnv m r '["dataServers" ::: [DataServer]],
    CallServerAPI DriverRideBookingAPIs m r b c
  ) =>
  CheckedShortId DM.Merchant ->
  City.City ->
  (DriverRideBookingAPIs -> b) ->
  c
callDriverOfferBPP merchantId city = callServerAPI @_ @m @r DRIVER_OFFER_BPP (mkDriverRideBookingAPIs merchantId city) "callDriverOfferBPP"
