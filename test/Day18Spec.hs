module Day18Spec where

import Control.Arrow ((>>>))
import Data.Tree.Zipper
import Day18
import Test.Hspec

spec :: Spec
spec =
  describe "Day18" $ do
    it "splitPair" $ do
      let f s es = splitPair s `shouldBe` es
      f "[[1,2],3]" ("[1,2]", "3")
      f "[1,2]" ("1", "2")
      f "[[[0,7],4],[15,[0,13]]]" ("[[0,7],4]", "[15,[0,13]]")
      f "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]" ("[[[0,7],4],[[7,8],[0,13]]]", "[1,1]")
      f "[[[0,7],4],[[7,8],[0,13]]]" ("[[0,7],4]", "[[7,8],[0,13]]")
      f "[[0,7],4]" ("[0,7]", "4")
      f "[[7,8],[0,13]]" ("[7,8]", "[0,13]")
    it "parse" $ do
      shouldBe
        (parse "[[1,2],3]")
        (node (node (leaf 1, leaf 2), leaf 3))
    it "toPairRepr" $ do
      shouldBe
        (toPairRepr $ node (node (leaf 1, leaf 2), leaf 3))
        "[[1,2],3]"
      shouldBe
        (toPairRepr $ parse "[[1,2],3]")
        "[[1,2],3]"
      shouldBe
        (toPairRepr . transform leftUnsafe . parse $ "[[1,2],3]")
        "[1,2]"
    it "toPairRepr . parse" $ do
      let f s = (toPairRepr . parse $ s) `shouldBe` s
      f "[[1,2],3]"
      f "[[[1,2],3],4]"
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
      f "[[[[0,7],4],[15,[0,13]]],[1,1]]"
    it "isLeaf" $ do
      let f s df b = shouldBe (isLeaf . df . fromTree . parse $ s) b
      f "[[1,2],3]" (leftUnsafe >>> leftUnsafe) True
      f "[[1,2],3]" (leftUnsafe >>> rightUnsafe) True
      f "[[1,2],3]" rightUnsafe True
      f "[[1,2],3]" id False
      f "[[1,2],3]" leftUnsafe False
    it "side" $ do
      let f s df sd = shouldBe (side . df . fromTree . parse $ s) sd
      f "[[1,2],3]" (leftUnsafe >>> leftUnsafe) LeftSide
      f "[[1,2],3]" (leftUnsafe >>> rightUnsafe) RightSide
      f "[[1,2],3]" rightUnsafe RightSide
      f "[[1,2],3]" id TopSide
    it "nearestLeft" $ do
      let f s df es = shouldBe (fmap (toPairRepr . tree) . nearestLeft . df . fromTree . parse $ s) es
      f "[[1,2],3]" (leftUnsafe >>> leftUnsafe) Nothing
      f "[[1,2],3]" (leftUnsafe >>> rightUnsafe) (Just "1")
      f "[[1,2],3]" rightUnsafe (Just "2")
    it "nearestRight" $ do
      let f s df es = shouldBe (fmap (toPairRepr . tree) . nearestRight . df . fromTree . parse $ s) es
      f "[[1,2],3]" (leftUnsafe >>> leftUnsafe) (Just "2")
      f "[[1,2],3]" (leftUnsafe >>> rightUnsafe) (Just "3")
      f "[[1,2],3]" rightUnsafe Nothing
    it "findExplode" $ do
      let f s es = shouldBe (fmap (toPairRepr . tree) . findExplode . fromTree . parse $ s) es
      f "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]" (Just "[4,3]")
      f "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]" (Just "[8,4]")
      f "[[[[0,7],4],[15,[0,13]]],[1,1]]" Nothing
      f "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]" Nothing
      f "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]" (Just "[6,7]")
    xit "explode" $ do
      let f s es = shouldBe (toPairRepr . tree . snd . explode . fromTree . parse $ s) es
      f "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]" "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]"
      f "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]" "[[[[0,7],4],[15,[0,13]]],[1,1]]"
      f "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]" "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
