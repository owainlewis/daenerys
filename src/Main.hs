module Main
  ( main
  )
  where

import           Control.Applicative   (pure)
import           Network.Daenerys.Core (printMaybeByteString, runRequest)
import           Network.Daenerys.IO   (readRequest, readRequests)
import           System.Environment
import           System.Exit

-- | Given a filename: run the program and pretty print the response
--
runProgram :: String -> IO ()
runProgram f = pure ()

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Missing filename"
    (x:xs) -> runProgram x
