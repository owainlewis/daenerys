module Network.Daenerys.IOSpec where

import           Data.Maybe             (fromMaybe)
import           Data.Text              (pack)
import qualified Network.Daenerys.IO    as IO
import qualified Network.Daenerys.Types as Types
import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Daenerys IO Utils" $ do
    it "should read a valid JSON file" $ do
      response <- IO.readRequest "examples/simple-get.json"
      (Types.requestMethod `fmap` response) `shouldBe` Just (pack "GET")
      (Types.requestUrl `fmap` response) `shouldBe` Just (pack "http://requestb.in/p3lsnxp3")
