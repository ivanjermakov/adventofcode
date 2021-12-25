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
findWinnerScore ns bs = case findWinner ns bs of
  Just (ns', b) -> last ns' * sum (nonCommon ns' $ concat b)
  Nothing -> undefined

-- ([Int], Board) is a tuple of set of drawn number until win and the win board
findWinner :: [Int] -> [Board] -> Maybe ([Int], Board)
findWinner = findWinner' 0

-- First argument is an index
findWinner' :: Int -> [Int] -> [Board] -> Maybe ([Int], Board)
findWinner' i ns bs
  | i > length ns = Nothing
  | otherwise =
    let drawn = take i ns
        winners = filter (isWinner drawn) bs
     in case winners of
          [winner] -> Just (drawn, winner)
          [] -> findWinner' (i + 1) ns bs
          _ -> undefined

isWinner :: [Int] -> Board -> Bool
isWinner ns b = any (any (included ns)) [b, transpose b]

lengthEq :: (Foldable t1, Foldable t2) => t1 a1 -> t2 a2 -> Bool
lengthEq a b = length a == length b

included :: Eq a => [a] -> [a] -> Bool
included ls subLs = commonCount == length subLs
  where
    commonCount = foldr (\e acc -> acc + if e `elem` ls then 1 else 0) 0 subLs

-- What elements of sub list are not contained in the list
nonCommon ls subLs = foldr (\e acc -> if e `elem` ls then acc else acc ++ [e]) [] subLs
