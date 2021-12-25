module Day3 where

import Data.Function
import Data.List

findOgRating :: [[Int]] -> Int
findOgRating matrix =
  let og = findOgRating' 0 findMostCommon matrix
      co = findOgRating' 0 findLeastCommon matrix
   in og * co

findOgRating' :: Int -> ([Int] -> Int) -> [[Int]] -> Int
findOgRating' bit extractor matrix =
  let mostCommon = extractor (transpose matrix !! bit)
      bitEq b n ds = ds !! b == n
      found = filter (bitEq bit mostCommon) matrix
   in case found of
        [a] -> binToDec $ concatAny a
        l -> findOgRating' (bit + 1) extractor l

findMostCommon :: (Ord a) => [a] -> a
findMostCommon = head . maximumBy (compare `on` length) . group . sort

findLeastCommon :: (Ord a) => [a] -> a
findLeastCommon = head . minimumBy (compare `on` length) . group . sort

binToDec :: Integral i => i -> i
binToDec 0 = 0
binToDec i = 2 * binToDec (div i 10) + mod i 10

concatAny :: (Show a, Read a) => [a] -> a
concatAny = read . concatMap show
