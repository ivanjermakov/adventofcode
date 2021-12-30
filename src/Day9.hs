module Day9 where

import Control.Monad (liftM2)
import Data.List (nub)
import Data.Maybe (catMaybes, fromJust, isJust)

type Matrix = [[Int]]

type Pos = (Int, Int)

parse :: String -> Matrix
parse = map (map $ read . pure) . lines

getBasin :: Matrix -> Pos -> [Pos]
getBasin = getBasin' []

getBasin' :: [Pos] -> Matrix -> Pos -> [Pos]
getBasin' ps m curr = nub $ ps ++ concatMap (getBasin' newPs m) ns
  where
    newPs = ps ++ ns
    ns = filter (\p -> fromJust (p `at` m) /= 9) . filter (`notElem` ps) . filter (isJust . flip at m) . neighbourPositions $ curr

getLowest :: Matrix -> [Pos]
getLowest matrix = filter (`isLowest` matrix) ps
  where
    m = length matrix
    n = length . head $ matrix
    ps = liftM2 (,) (nat m) (nat n)
    nat a = take a $ iterate (+ 1) 0

isLowest :: Pos -> Matrix -> Bool
isLowest (i, j) m = null neighbours
  where
    (Just e) = at (i, j) m
    neighbours = filter (<= e) . catMaybes $ (`at` m) <$> neighbourPositions (i, j)

neighbourPositions :: Pos -> [Pos]
neighbourPositions (i, j) = [(i - 1, j), (i, j + 1), (i + 1, j), (i, j - 1)]

at :: Pos -> Matrix -> Maybe Int
at (i, j) m = (m !? i) >>= (!? j)

(!?) :: [a] -> Int -> Maybe a
(!?) l i
  | i < 0 = Nothing
  | i < length l = Just $ l !! i
  | otherwise = Nothing
