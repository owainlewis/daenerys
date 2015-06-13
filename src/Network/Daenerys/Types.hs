{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Types where

import           Control.Applicative ((<$>), (<*>))
import           Control.Monad       (mzero)
import           Data.Aeson
import qualified Data.ByteString     as B
import           Data.Map            (Map (..))
import           Data.Text

data InternalRequest = InternalRequest {
    requestUrl    :: Text
  , requestMethod :: Text
  , headers       :: Maybe ( Map String String )
  , body          :: Maybe Text
} deriving ( Eq, Ord, Show )

data HTTPMethod = GET | POST | PUT | PATCH | DELETE deriving ( Eq, Ord, Show )

instance FromJSON InternalRequest where
   parseJSON (Object v) =
        InternalRequest <$> v .:  "url"
-- A HTTP method
                        <*> v .:  "method"
-- Optional HTTP request headers
                        <*> v .:? "headers"
-- Optional RAW JSON body
                        <*> v .:? "body"
   parseJSON _ = mzero

exampleGETRequest = InternalRequest {
    requestUrl    = "http://httpbin/get"
  , requestMethod = "GET"
  , headers = Nothing
  , body = Nothing
}
