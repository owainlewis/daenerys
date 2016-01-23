{-# LANGUAGE OverloadedStrings #-}
module Network.Daenerys.Util
  ( simpleGet
  ) where

import           Data.Map               (fromList)
import           Data.Text              (Text)
import           Network.Daenerys.Types

simpleGet :: Text -> InternalRequest
simpleGet url = InternalRequest url "GET" Nothing Nothing

exampleGETRequest :: InternalRequest
exampleGETRequest = InternalRequest {
    requestUrl    = "http://requestb.in/1d1a1121"
  , requestMethod = "GET"
  , headers = Just $ fromList [("Content-Type", "application/json")]
  , body = Just "HELLO WORLD"
}
