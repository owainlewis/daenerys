module Main
  ( main
  , runProgram
  ) where

import           Control.Applicative   (pure)
import           Network.Daenerys.Core (printMaybeByteString, runRequest)
import           Network.Daenerys.IO   (readRequest, readRequests)
import           System.Environment
import           System.Exit

-- | Given a filename: run the program and pretty print the response
--
runProgram :: String -> IO ()
runProgram f = do
  request <- readRequest f
  case request of
    Just r  -> print =<< runRequest r
    Nothing -> return ()

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Missing filename"
    (x:xs) -> runProgram x
