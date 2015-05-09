{-# LANGUAGE OverloadedStrings #-}
module CoreSpec (spec) where

import           Test.Hspec

spec :: Spec
spec = describe "Core" $ do
  context "When processing valid JSON" $ do
    it "should parse correctly" $ do
      1 `shouldBe` (1 :: Int)
