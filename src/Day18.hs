{-# LANGUAGE TupleSections #-}

module Day18 where

import Data.Char (digitToInt)
import Data.List (intercalate)
import Data.Tree

type NTree = Tree (Maybe Int)

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
    f [n] = (Just $ digitToInt n, [])
    f s = (Nothing, [tail l, tail . init $ r])
      where
        (l, r) = splitAt (midAt (0, 0, s)) s

midAt :: (Int, Int, String) -> Int
midAt (i, c, '[' : ss) = midAt (i + 1, c + 1, ss)
midAt (i, c, ']' : ss) = midAt (i + 1, c - 1, ss)
midAt (i, c, ',' : ss) = if c == 1 then i else midAt (i + 1, c, ss)
midAt (i, c, _ : ss) = midAt (i + 1, c, ss)
midAt (i, c, []) = -1

toPairRepr :: NTree -> String
toPairRepr = foldTree f
  where
    f (Just v) _ = show v
    f Nothing xs = "[" ++ intercalate "," xs ++ "]"

pretty :: NTree -> String
pretty = drawTree . fmap show
