module Day6 where

import Data.List (group, sort)
import Data.List.Split (splitOn)

parse :: String -> [Int]
parse = map read . splitOn ","

simulate :: Int -> [Int] -> [Int]
simulate n l = foldr f (toHist l) (reverse [0 .. n -1])
  where
    f _ a = next a

toHist :: [Int] -> [Int]
toHist = map ((\e -> e - 1) . length) . group . sort . (++) [0 .. 8]

next :: [Int] -> [Int]
next ls = take 6 shifted ++ [shifted !! 6 + shifted !! 8] ++ drop 7 shifted
  where
    shifted = shift 1 ls
    shift n l = drop n l ++ take n l
