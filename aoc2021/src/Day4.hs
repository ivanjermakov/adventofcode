module Day4 where

import Data.List
import Data.List.Split

type Board = [[Int]]

parse :: String -> ([Int], [Board])
parse content = case splitOn "\n\n" content of
  ns : bs ->
    ( map (\e -> read e :: Int) $ splitOn "," ns,
      map (map (map (\e -> read e :: Int) . words) . lines) bs
    )
  _ -> undefined

findWinnerScore :: [Int] -> [Board] -> Int
findWinnerScore ns bs = case findLastWinner ns bs of
  Just (ns', b) -> last ns' * sum (nonCommon ns' $ concat b)
  Nothing -> undefined

-- ([Int], Board) is a tuple of set of drawn number until win and the win board
findLastWinner :: [Int] -> [Board] -> Maybe ([Int], Board)
findLastWinner = findLastWinner' (0, []) 0

-- First argument is an index
findLastWinner' :: (Int, Board) -> Int -> [Int] -> [Board] -> Maybe ([Int], Board)
findLastWinner' (li, lb) i ns bs
  | i > length ns = Just (take li ns, lb)
  | otherwise =
    let drawn = take i ns
        winners = filter (isWinner drawn) bs
     in case winners of
          winner : _ -> findLastWinner' (i, winner) (i + 1) ns (nonCommon winners bs)
          _ -> findLastWinner' (li, lb) (i + 1) ns bs

isWinner :: [Int] -> Board -> Bool
isWinner ns b = any (any (included ns)) [b, transpose b]

lengthEq :: (Foldable t1, Foldable t2) => t1 a1 -> t2 a2 -> Bool
lengthEq a b = length a == length b

included :: Eq a => [a] -> [a] -> Bool
included ls subLs = commonCount == length subLs
  where
    commonCount = foldr (\e acc -> acc + if e `elem` ls then 1 else 0) 0 subLs

-- What elements of sub list are not contained in the list
nonCommon :: (Eq a) => [a] -> [a] -> [a]
nonCommon ls = foldr (\e acc -> if e `elem` ls then acc else acc ++ [e]) []
