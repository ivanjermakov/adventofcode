module Day18 where

import Data.Char (digitToInt, isNumber)
import Data.List (intercalate)
import Data.Maybe (catMaybes, fromJust, listToMaybe, mapMaybe)
import Data.Tree
import qualified Data.Tree.Zipper as Z

type NTree = Tree (Maybe Int)

type NTreePos = Z.TreePos Z.Full (Maybe Int)

data Side = LeftSide | RightSide | TopSide
  deriving (Eq, Show)

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

{-
findExplodeNode :: Node -> Maybe Node
findExplodeNode (Node (l, r) _) = head . filter isJust . map findExplodeNode $ [l, r]
findExplodeNode (Leaf _ Nothing) = Nothing
findExplodeNode (Leaf _ (Just p)) = if isExplode p then Just p else Nothing
  where
    isExplode n = ((> 3) . depth $ n) && pairNode n

explode :: Node -> (Node, Bool)
explode n = case mEn of
  Nothing -> (n, True)
  Just en -> (nr, False)
    where
      (Node (Leaf lv _, Leaf rv _) _) = en
      n' = maybe n (updateNode (Leaf 0)) (Just en)
      nl = maybe n' (updateLeaf (+ lv)) (nearestLeft n')
      nr = maybe nl (updateLeaf (+ rv)) (nearestRight nl)
  where
    mEn = findExplodeNode n
-}

explode :: NTreePos -> (Bool, NTreePos)
explode n = undefined

findExplode :: NTreePos -> Maybe NTreePos
findExplode n = case Z.isLeaf n of
  False -> listToMaybe . mapMaybe findExplode . catMaybes $ [Z.firstChild n, Z.lastChild n]
  True -> if isExplode p then Just p else Nothing
    where
      p = parentUnsafe n
      isExplode n' = ((> 3) . depth $ n') && pairNode n'

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

side :: NTreePos -> Side
side n
  | Z.isRoot n = TopSide
  | Z.isFirst n = LeftSide
  | Z.isLast n = RightSide
  | otherwise = error "side is unknown"

transform :: (NTreePos -> NTreePos) -> NTree -> NTree
transform f = Z.tree . f . Z.fromTree
