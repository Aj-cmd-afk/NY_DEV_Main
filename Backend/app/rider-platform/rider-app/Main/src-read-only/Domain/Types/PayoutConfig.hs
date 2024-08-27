{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Domain.Types.PayoutConfig where

import Data.Aeson
import qualified Domain.Types.Merchant
import qualified Domain.Types.MerchantOperatingCity
import Kernel.Prelude
import qualified Kernel.Types.Common
import qualified Kernel.Types.Id
import qualified Tools.Beam.UtilsTH

data PayoutConfig = PayoutConfig
  { batchLimit :: Kernel.Prelude.Int,
    isPayoutEnabled :: Kernel.Prelude.Bool,
    maxRetryCount :: Kernel.Prelude.Int,
    merchantId :: Kernel.Types.Id.Id Domain.Types.Merchant.Merchant,
    merchantOperatingCityId :: Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity,
    orderType :: Kernel.Prelude.Text,
    payoutEntity :: Domain.Types.PayoutConfig.PayoutEntity,
    payoutRegistrationCgst :: Kernel.Types.Common.HighPrecMoney,
    payoutRegistrationFee :: Kernel.Types.Common.HighPrecMoney,
    payoutRegistrationSgst :: Kernel.Types.Common.HighPrecMoney,
    remark :: Kernel.Prelude.Text,
    thresholdPayoutAmountPerOrder :: Kernel.Types.Common.HighPrecMoney,
    timeDiff :: Kernel.Prelude.NominalDiffTime,
    createdAt :: Kernel.Prelude.UTCTime,
    updatedAt :: Kernel.Prelude.UTCTime
  }
  deriving (Generic, Show, ToJSON, FromJSON)

data PayoutEntity = METRO_TICKET_CASHBACK deriving (Eq, Ord, Show, Read, Generic, ToJSON, FromJSON, ToSchema)

$(Tools.Beam.UtilsTH.mkBeamInstancesForEnumAndList (''PayoutEntity))
