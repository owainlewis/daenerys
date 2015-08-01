module Network.Daenerys.IOSpec where

import qualified Network.Daenerys.IO as IO
import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Daenerys IO Utils" $ do
    it "should read a valid JSON file" $ do
      putStrLn . show $ IO.readRequest "examples/simple-get.json"
