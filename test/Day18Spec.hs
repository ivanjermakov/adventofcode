module Day18Spec where

import Day18
import Test.Hspec

spec :: Spec
spec =
  describe "Day18" $ do
    it "parse" $ do
      shouldBe
        (parse "[[1,2],3]")
        (node (node (leaf 1, leaf 2), leaf 3))
    it "toPairRepr" $ do
      shouldBe
        (toPairRepr $ node (node (leaf 1, leaf 2), leaf 3))
        "[[1,2],3]"
    it "toPairRepr . parse" $ do
      let f s = (toPairRepr . parse $ s) `shouldBe` s
      f "[[1,2],3]"
      f "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]"
      f "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]"
      f "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]"
      f "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]"
      f "[7,[5,[[3,8],[1,4]]]]"
      f "[[2,[2,2]],[8,[8,1]]]"
      f "[2,9]"
      f "[1,[[[9,3],9],[[9,0],[0,7]]]]"
      f "[[[5,[7,4]],7],1]"
      f "[[[[4,2],2],6],[8,7]]"
