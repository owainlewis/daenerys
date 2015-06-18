module Network.Daenerys.IOUtilSpec where

import qualified Network.Daenerys.IOUtil as U
import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Daenerys IO Utils" $ do
    it "should read a valid JSON file" $ do
      putStrLn . show $ U.readRequest "examples/simple-get.json"
