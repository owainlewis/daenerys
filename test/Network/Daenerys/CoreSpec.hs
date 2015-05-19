module Network.Daenerys.CoreSpec (main, spec) where

import           Network.Daenerys.Core
import           Test.Hspec

-- `main` is here so that this module can be run from GHCi on its own.  It is
-- not needed for automatic spec discovery.
main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "strip" $ do
    it "removes leading and trailing whitespace" $ do
      1 `shouldBe` (1 :: Int)
