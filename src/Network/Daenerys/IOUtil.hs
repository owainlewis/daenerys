{-# LANGUAGE ScopedTypeVariables #-}
module Network.Daenerys.IOUtil
  ( readFrom
  ) where

import           Control.Exception
import           Control.Monad          (guard)
import           Data.Aeson             (decode)
import qualified Data.ByteString.Lazy   as B
import           Network.Daenerys.Types (InternalRequest)
import           System.IO.Error        (isDoesNotExistError)

-- | Try reading a file and returning the contents or return a default string
tryFileOr :: FilePath -> String -> IO String
tryFileOr f or = readFile f `catch` (\(e :: IOException) -> return or)

-- | Try opening a file and decoding the JSON.
--   If the file does not exist return Nothing else Just (contents)
readFrom :: FilePath -> IO (Maybe InternalRequest)
readFrom file = do
    e <- tryJust (guard . isDoesNotExistError) (B.readFile file)
    case e of
      Left _ -> return Nothing
      Right contents -> return $ decode contents
