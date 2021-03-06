module Main
  ( main
  , runProgram
  ) where

import           Control.Applicative    (pure)
import           Network.Daenerys.Core  (printMaybeByteString, runRequest)
import           Network.Daenerys.IO    (readRequest, readRequests)
import           Network.Daenerys.Types (InternalResponse (..))
import           System.Environment
import           System.Exit

runProgram :: String -> IO ()
runProgram f = do
  request <- readRequest f
  case request of
    Just r  -> print . rCode =<< runRequest r
    Nothing -> pure ()

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Missing filename"
    (x:xs) -> runProgram x
