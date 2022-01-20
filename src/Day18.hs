{-# LANGUAGE BlockArguments #-}

module Day18 where

import Control.Monad (mfilter)
import Data.Bifunctor (first)
import Data.Char (isNumber)
import Data.List (intercalate)
import Data.Maybe (catMaybes, fromJust, isJust, listToMaybe, mapMaybe)
import Data.Tree
import qualified Data.Tree.Zipper as Z

type NTree = Tree (Maybe Int)

type NTreePos = Z.TreePos Z.Full (Maybe Int)

data Side = LeftSide | RightSide | TopSide
  deriving (Eq, Show)

type Path = [Side]

main18 :: IO ()
main18 = do
  input <- readFile "resources/d18-test.txt"
  let ps = parseInput input
  print $ map show ps

node :: (NTree, NTree) -> NTree
node (a, b) = Node Nothing [a, b]

leaf :: Int -> NTree
leaf v = Node (Just v) []

add :: Tree Int -> Tree Int -> Tree Int
add a b = Node 0 [a, b]

sumTrees :: [Tree Int] -> Tree Int
sumTrees (f: ts) = foldl add f ts
sumTrees [] = error "no trees provided"

parseInput :: String -> [NTree]
parseInput = map parse . lines

parse :: String -> NTree
parse = unfoldTree f
  where
    f :: String -> (Maybe Int, [String])
    f s
      | all isNumber s = (Just $ read s, [])
      | otherwise = (Nothing, [l, r])
      where
        (l, r) = splitPair s

splitPair :: String -> (String, String)
splitPair s = (l, r)
  where
    (l, r) = case splitAt (midAt (0, 0, s)) s of
      (_ : l', _ : r') -> (l', init r')
      _ -> error (show s)

midAt :: (Int, Int, String) -> Int
midAt (i, c, '[' : ss) = midAt (i + 1, c + 1, ss)
midAt (i, c, ']' : ss) = midAt (i + 1, c - 1, ss)
midAt (i, c, ',' : ss) = if c == 1 then i else midAt (i + 1, c, ss)
midAt (i, c, _ : ss) = midAt (i + 1, c, ss)
midAt _ = -1

toPairRepr :: NTree -> String
toPairRepr = foldTree f
  where
    f (Just v) _ = show v
    f Nothing xs = "[" ++ intercalate "," xs ++ "]"

pretty :: NTree -> String
pretty = drawTree . fmap show

reduceFull :: NTreePos -> NTreePos
reduceFull n = case reduce n of
  (True, r) -> reduceFull r
  (False, r) -> r

reduce :: NTreePos -> (Bool, NTreePos)
reduce n = (er || sr, sn)
  where
    (er, en) = explode n
    (sr, sn) = split en

nearestLeft :: NTreePos -> Maybe NTreePos
nearestLeft = find Nothing
  where
    find :: Maybe Side -> NTreePos -> Maybe NTreePos
    find mcf n = case (mcf, Z.isLeaf n, Z.isRoot n) of
      -- not first, leaf, not root
      (Just cf, True, False) -> case cf of
        TopSide -> Just n
      -- not first, leaf, root
      (Just _, True, True) -> Nothing
      -- not first, node, not root
      (Just cf, False, False) -> case cf of
        LeftSide -> up n
        RightSide -> lt n
        TopSide -> rt n
      -- not first, node, root
      (Just cf, False, True) -> case cf of
        LeftSide -> Nothing
        RightSide -> lt n
      -- first, leaf
      (Nothing, True, _) -> up n
      where
        up n' = find (Just $ side n') (parentUnsafe n')
        lt n' = find (Just TopSide) (leftUnsafe n')
        rt n' = find (Just TopSide) (rightUnsafe n')

nearestRight :: NTreePos -> Maybe NTreePos
nearestRight = find Nothing
  where
    find :: Maybe Side -> NTreePos -> Maybe NTreePos
    find mcf n = case (mcf, Z.isLeaf n, Z.isRoot n) of
      -- not first, leaf, not root
      (Just cf, True, False) -> case cf of
        TopSide -> Just n
      -- not first, leaf, root
      (Just _, True, True) -> Nothing
      -- not first, node, not root
      (Just cf, False, False) -> case cf of
        LeftSide -> rt n
        RightSide -> up n
        TopSide -> lt n
      -- not first, node, root
      (Just cf, False, True) -> case cf of
        LeftSide -> rt n
        RightSide -> Nothing
      -- first, leaf
      (Nothing, True, _) -> up n
      where
        up n' = find (Just $ side n') (parentUnsafe n')
        lt n' = find (Just TopSide) (leftUnsafe n')
        rt n' = find (Just TopSide) (rightUnsafe n')

explode :: NTreePos -> (Bool, NTreePos)
explode n = case findExplode n of
  Nothing -> (False, n)
  (Just en) -> (True, appendRight . appendLeft . doExplode $ en)
    where
      enLoc = locate en
      ll = labelUnsafe . leftUnsafe $ en
      rl = labelUnsafe . rightUnsafe $ en
      doExplode = Z.root . Z.setTree (leaf 0)
      appendLeft = incNode nearestLeft ll
      appendRight = incNode nearestRight rl
      incNode f v n' = maybe n' (Z.root . Z.modifyLabel (fmap (+ v))) (f . findNode enLoc $ n')

findExplode :: NTreePos -> Maybe NTreePos
findExplode = findNodeBy isExplode
  where
    isExplode n = ((> 3) . depth $ n) && pairNode n

split :: NTreePos -> (Bool, NTreePos)
split n = case findSplit n of
  Nothing -> (False, n)
  (Just sn) -> (True, sn')
    where
      snl = labelUnsafe sn
      sn' = Z.root . Z.setTree (node (leaf l, leaf r)) $ sn
      (l, r) = div2Rounds snl
      div2Rounds :: Int -> (Int, Int)
      div2Rounds a
        | even a = (d, d)
        | otherwise = (d, d + 1)
        where
          d = a `div` 2

findSplit :: NTreePos -> Maybe NTreePos
findSplit = findNodeBy isSplit
  where
    isSplit :: NTreePos -> Bool
    isSplit n = Z.isLeaf n && (isJust . mfilter (> 9) $ Z.label n)

findNodeBy :: (NTreePos -> Bool) -> NTreePos -> Maybe NTreePos
findNodeBy pr n = case (pr n, Z.isLeaf n) of
  (True, _) -> Just n
  (False, True) -> Nothing
  (False, False) -> listToMaybe . mapMaybe (findNodeBy pr) . catMaybes $ [Z.firstChild n, Z.lastChild n]

pairNode :: NTreePos -> Bool
pairNode n = maybe False Z.isLeaf (Z.firstChild n) && maybe False Z.isLeaf (Z.lastChild n)

depth :: NTreePos -> Int
depth = depth' 0
  where
    depth' d n = if Z.isRoot n then d else depth' (d + 1) (parentUnsafe n)

parentUnsafe :: NTreePos -> NTreePos
parentUnsafe = fromJust . Z.parent

leftUnsafe :: NTreePos -> NTreePos
leftUnsafe = fromJust . Z.firstChild

rightUnsafe :: NTreePos -> NTreePos
rightUnsafe = fromJust . Z.lastChild

labelUnsafe :: NTreePos -> Int
labelUnsafe = fromJust . Z.label

side :: NTreePos -> Side
side n
  | Z.isRoot n = TopSide
  | Z.isFirst n = LeftSide
  | Z.isLast n = RightSide
  | otherwise = error "side is unknown"

locate :: NTreePos -> Path
locate = locate' []
  where
    locate' p n = case side n of
      TopSide -> p
      s -> locate' (s : p) (parentUnsafe n)

findNode :: Path -> NTreePos -> NTreePos
findNode (s : ss) n = case s of
  LeftSide -> findNode ss (leftUnsafe n)
  RightSide -> findNode ss (rightUnsafe n)
findNode [] n = n

transform :: (NTreePos -> NTreePos) -> NTree -> NTree
transform f = Z.tree . f . Z.fromTree
