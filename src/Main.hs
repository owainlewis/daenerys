module Main ( main ) where

import           Network.Daenerys.Core

main :: IO ()
main = readFrom "examples/simple-get.json" >>= runMaybeRequest >>= showMaybeByteString
