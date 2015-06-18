module Network.Daenerys.Fixtures where

import           Network.Daenerys.Types

getRequest = InternalRequest {
    requestUrl    = "http://requestb.in/1d1a1121"
  , requestMethod = "GET"
  , headers = Nothing
  , body = Nothing
}

postRequest = InternalRequest {
    requestUrl    = "http://requestb.in/1d1a1121"
  , requestMethod = "POST"
  , headers = Just $ fromList [("Content-Type", "application/json")]
  , body = Nothing
}
