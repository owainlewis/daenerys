{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Core where

import           Control.Applicative        ((<$>))
import qualified Data.ByteString.Lazy       as B
import qualified Data.ByteString.Lazy.Char8 as BS
import qualified Data.Map                   as M
import           Data.Maybe                 (fromMaybe, isJust)
import           Data.Text
import qualified Data.Text.Encoding         as Encoder
import           Network.Daenerys.IOUtil    (readFrom)
import           Network.Daenerys.Types
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS

-- | Transform the request headers from InternalRequest into HTTP Headers
--   suitable for dispatching
transformHeaders
  :: InternalRequest -> Maybe [(BS.ByteString, BS.ByteString)]
transformHeaders req =
  (\h -> M.foldlWithKey (\ks k v -> (BS.pack k, BS.pack v):ks) [] h) <$> (headers req)

buildRequest :: InternalRequest -> IO Request
buildRequest internalRequest = do
    initReq <- parseUrl . unpack $ requestUrl internalRequest
    let req = initReq
              { method = Encoder.encodeUtf8 $ requestMethod internalRequest,
                requestHeaders = fromMaybe [] Nothing
              }
    return req

-- runRequest :: InternalRequest -> IO (Response B.ByteString)
runRequest :: InternalRequest -> IO (Maybe B.ByteString)
runRequest r = do
    request  <- buildRequest r
    response <- withManager tlsManagerSettings $ httpLbs request
    return $ Just $ responseBody response

validRequestFile :: FilePath -> IO Bool
validRequestFile file = readFrom file >>= (return . isJust)

printMaybeByteString :: Maybe B.ByteString -> IO ()
printMaybeByteString = print . fromMaybe (BS.pack "Bad Request")

-- TODO how to re-phrase this ? fmap ??
runMaybeRequest :: Maybe InternalRequest -> IO (Maybe B.ByteString)
runMaybeRequest (Just r)  = runRequest r
runMaybeRequest (Nothing) = return $ Nothing
