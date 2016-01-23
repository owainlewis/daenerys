{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Core 
    ( transformHeaders
    , extractBody
    , buildRequest
    , runRequest
    , validRequestFile
    , printMaybeByteString
    ) where

import           Control.Applicative        ((<$>))
import           Control.Monad.IO.Class     (liftIO)
import qualified Data.ByteString            as B
import qualified Data.ByteString.Char8      as BS
import qualified Data.ByteString.Lazy       as LB
import qualified Data.ByteString.Lazy.Char8 as LBS
import           Data.CaseInsensitive       (mk)
import qualified Data.Map                   as M
import           Data.Maybe                 (fromMaybe, isJust)
import           Data.Text
import           Data.Text.Encoding         (encodeUtf8)
import qualified Data.Text.Encoding         as Encoder
import           Network.Daenerys.IO        (readRequest, readRequests)
import           Network.Daenerys.Types
import           Network.Daenerys.Util      as U
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS
import           Network.HTTP.Types.Header  (RequestHeaders)
import           Network.HTTP.Types.Status  (statusCode)

transformHeaders :: InternalRequest -> Maybe RequestHeaders
transformHeaders req =
  let packInsensitive = mk . BS.pack
      requestHeaders  = headers req  in
  (\h -> M.foldlWithKey
    (\ks k v ->
      (packInsensitive k, BS.pack v) : ks) [] h) <$> requestHeaders

extractBody :: InternalRequest -> RequestBody
extractBody internalRequest = RequestBodyBS $ fromMaybe "" reqBody
    where reqBody = encodeUtf8 `fmap` (body internalRequest)

buildRequest :: InternalRequest -> IO Request
buildRequest internalRequest = do
    initReq <- parseUrl . unpack $ requestUrl internalRequest
    let req = initReq
              { method         = Encoder.encodeUtf8 $ requestMethod internalRequest
              , requestHeaders = fromMaybe [] (transformHeaders internalRequest)
              , requestBody    = extractBody internalRequest
              }
    return req

runRequest :: InternalRequest -> IO InternalResponse
runRequest r = do
    request  <- buildRequest r
    response <- withManager tlsManagerSettings $ httpLbs request
    let body   = responseBody response
        status = responseStatus $ response
    return $ InternalResponse (statusCode status) body

validRequestFile :: FilePath -> IO Bool
validRequestFile file = readRequest file >>= (return . isJust)

printMaybeByteString :: Maybe LB.ByteString -> IO ()
printMaybeByteString = print . fromMaybe (LBS.pack "Bad Request")
