module API.Internal
  ( API,
    handler,
  )
where

import qualified API.Internal.Cac as Cac
import qualified API.Internal.FRFS as FRFS
import qualified API.Internal.Rating as Rating
import Environment
import Servant
import Tools.Auth ()

type API =
  "internal"
    :> ( Rating.API
           :<|> FRFS.API
           :<|> Cac.API
       )

handler :: FlowServer API
handler =
  Rating.handler
    :<|> FRFS.handler
    :<|> Cac.handler
