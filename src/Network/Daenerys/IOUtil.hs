{-# LANGUAGE ScopedTypeVariables #-}
module Network.Daenerys.IOUtil
  ( readFrom
    -- Read a single request from file
  , readRequest
    -- Read a list of requests from file
  , readRequests
  ) where

import           Control.Exception
import           Control.Monad          (guard)
import           Data.Aeson             (FromJSON, decode)
import qualified Data.ByteString.Lazy   as B
import           Network.Daenerys.Types (InternalRequest)
import           System.IO.Error        (isDoesNotExistError)

-- | Try reading a file and returning the contents or return a default string
tryFileOr :: FilePath -> String -> IO String
tryFileOr f or = readFile f `catch` (\(e :: IOException) -> return or)

-- | Try opening a file and decoding the JSON.
--   If the file does not exist return Nothing else Just (contents)
readFrom :: FromJSON a => FilePath -> IO (Maybe a)
readFrom file = do
    e <- tryJust (guard . isDoesNotExistError) (B.readFile file)
    case e of
      Left _ -> return Nothing
      Right contents -> return $ decode contents

-- Type aliases
--
readRequest :: FilePath -> IO (Maybe InternalRequest)
readRequest = readFrom

readRequests :: FilePath -> IO (Maybe [InternalRequest])
readRequests = readFrom
