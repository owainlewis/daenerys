{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Core where

import           Control.Applicative
import           Control.Monad
import           Data.Aeson
import qualified Data.ByteString.Char8     as BS
import qualified Data.ByteString.Lazy      as B
import           Data.Map
import           Data.Text
import qualified Data.Text.Encoding        as Encoder
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS

import           Control.Monad.IO.Class
import           Control.Monad.Trans.Maybe

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

runRequest :: InternalRequest -> IO (Response B.ByteString)
runRequest r = do
    request  <- buildRequest r
    response <- withManager tlsManagerSettings $ httpLbs request
    return response

readFrom :: FilePath -> IO (Maybe InternalRequest)
readFrom file = do
    contents <- B.readFile file
    return $ decode contents

fakeRequest = InternalRequest {
    requestUrl = "http://requestb.in/rckujwrc",
    requestMethod = "GET",
    headers = Nothing
}

example = do
    maybeRequest <- readFrom "test/examples/simple-get.json"
    maybeResponse <- liftIO $ fmap runRequest maybeRequest
    return maybeResponse
