module Day9 where

import Control.Monad (liftM2)
import Data.List (nub)
import Data.Matrix (Matrix, fromLists, ncols, nrows, safeGet, (!))
import Data.Maybe (catMaybes)

type Pos = (Int, Int)

parse :: String -> Matrix Int
parse = fromLists . ls
  where
    ls = map (map $ (\e -> read e :: Int) . pure) . lines

basin :: Matrix Int -> Pos -> [Pos]
basin = basin' []

basin' :: [Pos] -> Matrix Int -> Pos -> [Pos]
basin' visited m curr = nub $ curr : nsPos
  where
    nsPos = foldr (\n acc -> acc ++ basin' acc m n) newPs ns
    ns = unvisitedNeighbours visited m curr
    newPs = curr : visited

unvisitedNeighbours :: [Pos] -> Matrix Int -> Pos -> [Pos]
unvisitedNeighbours visited m curr =
  filter (\p -> p `inBounds` shape m && p `notElem` (curr : visited) && (m ! p) /= 9)
    . neighbourPositions
    $ curr

inBounds :: Pos -> (Int, Int) -> Bool
inBounds (i, j) (m, n) = i > 0 && i <= m && j > 0 && j <= n

shape :: Matrix a -> (Int, Int)
shape m = (nrows m, ncols m)

getLowest :: Matrix Int -> [Pos]
getLowest matrix = filter (`isLowest` matrix) ps
  where
    (m, n) = shape matrix
    ps = liftM2 (,) (nat m) (nat n)
    nat a = take a $ iterate (+ 1) 1

isLowest :: Pos -> Matrix Int -> Bool
isLowest (i, j) m = null neighbours
  where
    e = m ! (i, j)
    neighbours = filter (<= e) . catMaybes $ (\(i', j') -> safeGet i' j' m) <$> neighbourPositions (i, j)

neighbourPositions :: Pos -> [Pos]
neighbourPositions (i, j) = [(i - 1, j), (i, j + 1), (i + 1, j), (i, j - 1)]
