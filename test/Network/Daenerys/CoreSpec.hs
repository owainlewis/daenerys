module Network.Daenerys.CoreSpec (main, spec) where

import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Daenerys" $ do
    it "should work" $ do
      1 `shouldBe` (1 :: Int)
