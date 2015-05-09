module Network.Daenerys.Core where

import qualified Data.ByteString.Char8   as BS
import qualified Data.ByteString.Lazy    as B
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS

data InternalRequest = InternalRequest {
    requestUrl    :: String
  , requestMethod :: String
} deriving ( Show, Eq )

buildRequest :: InternalRequest -> IO Request
buildRequest internalRequest = do
    initReq <- parseUrl (requestUrl internalRequest)
    let req = initReq
              { method = BS.pack $ requestMethod internalRequest
              }
    return req

runRequest :: InternalRequest -> IO (Response B.ByteString)
runRequest r = do
    request  <- buildRequest r
    response <- withManager tlsManagerSettings $ httpLbs request
    return $ response

-- This is what we map to internally when processing JSON object
dummyRequest :: InternalRequest
dummyRequest = InternalRequest {
    requestUrl = "http://ip.jsontest.com",
    requestMethod = "GET"
}

readFrom file = do
    contents <- readFile file
    return contents
