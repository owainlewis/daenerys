{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Core where

import           Control.Applicative
import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Maybe
import           Data.Aeson
import qualified Data.ByteString.Char8     as BS
import qualified Data.ByteString.Lazy      as B
import           Data.Map
import           Data.Maybe                (fromMaybe)
import           Data.Text
import qualified Data.Text.Encoding        as Encoder
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS

data InternalRequest = InternalRequest {
    requestUrl    :: Text
  , requestMethod :: Text
  , headers       :: Maybe ( Map String String )
} deriving ( Show, Eq )

instance FromJSON InternalRequest where
   parseJSON (Object v) =
        InternalRequest <$> v .: "url"
                        <*> v .: "method"
                        <*> v .: "headers"
   parseJSON _ = mzero

buildRequest :: InternalRequest -> IO Request
buildRequest internalRequest = do
    initReq <- parseUrl . unpack $ requestUrl internalRequest
    let req = initReq
              { method = Encoder.encodeUtf8 $ requestMethod internalRequest
              }
    return req

-- runRequest :: InternalRequest -> IO (Response B.ByteString)
runRequest :: InternalRequest -> IO (Maybe B.ByteString)
runRequest r = do
    request  <- buildRequest r
    response <- withManager tlsManagerSettings $ httpLbs request
    return $ Just $ responseBody response

readFrom :: FilePath -> IO (Maybe InternalRequest)
readFrom file = do
    contents <- B.readFile file
    return $ decode contents

fakeRequest = InternalRequest {
    requestUrl = "http://httpbin/get",
    requestMethod = "GET",
    headers = Nothing
}

-- TODO some dumb shit here

showMaybeByteString :: Show a => Maybe a -> IO ()
showMaybeByteString (Just x) = print x
showMaybeByteString Nothing = print "Bad Request"

runMaybeRequest :: Maybe InternalRequest -> IO (Maybe B.ByteString)
runMaybeRequest (Just r)  = runRequest r
runMaybeRequest (Nothing) = return $ Nothing
