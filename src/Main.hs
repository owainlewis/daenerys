module Main 
  ( main 
  ) 
  where

import           Network.Daenerys.Core   (printMaybeByteString, runMaybeRequest)
import           Network.Daenerys.IOUtil (readRequest, readRequests)
import           System.Environment
import           System.Exit

-- | Given a filename: run the program and pretty print the response
--
runProgram :: String -> IO ()
runProgram f = readRequest f >>= runMaybeRequest >>= printMaybeByteString

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Missing filename"
    (x:xs) -> runProgram x
