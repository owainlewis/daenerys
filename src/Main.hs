module Main ( main ) where

import           Network.Daenerys.Core   (printMaybeByteString, runMaybeRequest)
import           Network.Daenerys.IOUtil (readFrom)
import           System.Environment
import           System.Exit

runProgram :: String -> IO ()
runProgram f = readFrom f >>= runMaybeRequest >>= printMaybeByteString

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Missing filename"
    (x:xs) -> runProgram x
