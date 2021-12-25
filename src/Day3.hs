module Day3 where

import Data.Function
import Data.List

calculatePower :: [[Int]] -> Int
calculatePower matrix = foldr (*) 1 (map (binToDec . concatAny) [gammaL, epsilonL])
  where
    gammaL = map findMostCommon (transpose matrix)
    epsilonL = map (\d -> if d == 0 then 1 else 0) gammaL

findMostCommon :: (Ord a) => [a] -> a
findMostCommon = head . maximumBy (compare `on` length) . group . sort

binToDec :: Integral i => i -> i
binToDec 0 = 0
binToDec i = 2 * binToDec (div i 10) + mod i 10

concatAny :: (Show a, Read a) => [a] -> a
concatAny = read . concatMap show
