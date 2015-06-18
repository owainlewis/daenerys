{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Core where

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
import           Network.Daenerys.IOUtil    (readFrom)
import           Network.Daenerys.Types
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS
import           Network.HTTP.Types.Header  (RequestHeaders)

-- | Transform the request headers from InternalRequest into HTTP Headers
transformHeaders :: InternalRequest -> Maybe RequestHeaders
transformHeaders req =
  let packInsensitive = mk . BS.pack
      requestHeaders  = headers req  in
  (\h -> M.foldlWithKey
    (\ks k v ->
      (packInsensitive k, BS.pack v) : ks) [] h) <$> requestHeaders

-- | Extracts the HTTP request body from an internal request in a form suitable to dispatch
extractBody :: InternalRequest -> RequestBody
extractBody internalRequest = RequestBodyBS $ fromMaybe "" reqBody
    where reqBody = encodeUtf8 `fmap` (body internalRequest)

-- | Helper function to construct the raw HTTP request
buildRequest :: InternalRequest -> IO Request
buildRequest internalRequest = do
    initReq <- parseUrl . unpack $ requestUrl internalRequest
    let req = initReq
              { method = Encoder.encodeUtf8 $ requestMethod internalRequest
              , requestHeaders = fromMaybe [] (transformHeaders internalRequest)
              , requestBody = extractBody internalRequest
              }
    return req

runRequest :: InternalRequest -> IO (Maybe LB.ByteString)
runRequest r = do
    request  <- buildRequest r
    response <- withManager tlsManagerSettings $ httpLbs request
    return $ Just $ responseBody response

validRequestFile :: FilePath -> IO Bool
validRequestFile file = readFrom file >>= (return . isJust)

printMaybeByteString :: Maybe LB.ByteString -> IO ()
printMaybeByteString = print . fromMaybe (LBS.pack "Bad Request")

runMaybeRequest :: Maybe InternalRequest -> IO (Maybe LB.ByteString)
runMaybeRequest (Just r)  = runRequest r
runMaybeRequest (Nothing) = return $ Nothing
