{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Types where

import           Control.Applicative ((<$>), (<*>))
import           Control.Monad       (mzero)
import           Data.Aeson
import qualified Data.ByteString     as B
import           Data.Map            (Map (..), fromList)
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

type InternalRequests = [ InternalRequest ]

exampleGETRequest = InternalRequest {
    requestUrl    = "http://requestb.in/1d1a1121"
  , requestMethod = "GET"
  , headers = Just $ fromList [("Content-Type", "application/json")]
  , body = Just "HELLO WORLD"
}
