module Day9 where

import Control.Monad (liftM2)
import Data.Maybe (catMaybes, mapMaybe)

type Matrix = [[Int]]

type Pos = (Int, Int)

parse :: String -> Matrix
parse = map (map $ read . pure) . lines

getLowest :: Matrix -> [Int]
getLowest matrix = mapMaybe (`at` matrix) . filter (`isLowest` matrix) $ ps
  where
    m = length matrix
    n = length . head $ matrix
    ps = liftM2 (,) (nat m) (nat n)
    nat a = take a $ iterate (+ 1) 0

isLowest :: Pos -> Matrix -> Bool
isLowest (i, j) m = null neighbours
  where
    (Just e) = at (i, j) m
    neighbours = filter (<= e) . catMaybes $ (`at` m) <$> neighbourPos
    neighbourPos = [(i - 1, j), (i, j + 1), (i + 1, j), (i, j - 1)]

at :: Pos -> Matrix -> Maybe Int
at (i, j) m = (m !? i) >>= (!? j)

(!?) :: [a] -> Int -> Maybe a
(!?) l i
  | i < 0 = Nothing
  | i < length l = Just $ l !! i
  | otherwise = Nothing
