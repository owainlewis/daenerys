module Network.Daenerys.IOSpec where

import           Data.Map               (fromList)
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
      let hdr = Just $ fromList [("Content-Type","application/json")]
          expected = Types.InternalRequest (pack "http://requestb.in/p3lsnxp3") (pack "GET") hdr Nothing
      response `shouldBe` Just expected
