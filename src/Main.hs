module Main ( main ) where

import           Network.Daenerys.Core
import           System.Environment
import           System.Exit

runProgram :: String -> IO ()
runProgram f = readFrom f >>= runMaybeRequest >>= showMaybeByteString

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Missing filename"
    (x:xs) -> runProgram x
