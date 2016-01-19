{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Types where

import           Control.Applicative  ((<$>), (<*>))
import           Control.Monad        (mzero)
import           Data.Aeson
import qualified Data.ByteString.Lazy as LB
import           Data.Map             (Map)
import           Data.Text            (Text)

data InternalRequest = InternalRequest {
    requestUrl    :: Text
  , requestMethod :: Text
  , headers       :: Maybe ( Map String String )
  , body          :: Maybe Text
} deriving ( Show )

data HTTPMethod =
    GET
  | POST
  | PUT
  | PATCH
  | DELETE
  deriving ( Eq, Ord, Show )

instance FromJSON InternalRequest where
   parseJSON (Object v) =
        InternalRequest <$> v .:  "url"
                        <*> v .:  "method"
                        <*> v .:? "headers"
                        <*> v .:? "body"
   parseJSON _ = mzero

type InternalRequests = [ InternalRequest ]

data InternalResponse = InternalResponse {
    rCode :: Int
  , rBody :: LB.ByteString
} deriving ( Show )
