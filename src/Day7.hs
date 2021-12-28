module Day7 where

import Data.List (minimumBy)
import Data.List.Split (splitOn)
import Data.Ord (comparing)

parse :: String -> [Int]
parse = map read . splitOn ","

getDistance :: [Int] -> Int
getDistance ls = snd . minimumBy (comparing snd) . map (\e -> (e, calculateTotalFuel e ls)) $ [minimum ls .. maximum ls]

calculateTotalFuel :: Int -> [Int] -> Int
calculateTotalFuel n = sum . map (calculateFuel n)

calculateFuel :: Int -> Int -> Int
calculateFuel a b = abs $ a - b
