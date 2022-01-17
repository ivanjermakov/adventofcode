module Day15 where

import Data.Bifunctor (second)
import Data.Char (digitToInt)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Matrix (Matrix)
import qualified Data.Matrix as MT
import Data.Maybe (fromJust, isJust)
import Data.PQueue.Min (MinQueue)
import qualified Data.PQueue.Min as Q

type Grid = Matrix Int

type Pos = (Int, Int)

type Queue = MinQueue (Int, Pos)

type VisitedMap = Map Pos Bool

main15 :: IO ()
main15 = do
  content <- readFile "resources/d15.txt"
  let pg = parse content
  let g = expand (5, 5) pg
  let q = Q.fromList [(0, (1, 1))]
  let m = M.fromList . MT.toList . MT.mapPos (\p _ -> (p, False)) $ g
  let dist = distance (g, q, m)
  print dist

expand :: (Int, Int) -> Grid -> Grid
expand (i, j) g = expand' (MT.<->) firstRow (steps j)
  where
    firstRow = expand' (MT.<|>) g $ steps i
    expand' f g' = foldl f g' . tail . scanl (\acc _ -> inc acc) g'
    steps n = [1 .. n - 1]
    inc = MT.mapPos (\_ v -> (v `mod` 9) + 1)

parse :: String -> Grid
parse = MT.fromLists . map (map digitToInt) . lines

distance :: (Grid, Queue, VisitedMap) -> Int
distance (g, q, m) =
  if p == lastPos
    then t
    else distance (g, q'', vm)
  where
    lastPos = (MT.nrows g, MT.ncols g)
    (q', (t, p)) = popNotVisited m q
    adj = filter (not . (M.!) vm . fst) . adjacent p $ g
    q'' = foldl (\acc (ap, at) -> Q.insert (t + at, ap) acc) q' adj
    vm = M.adjust (const True) p m

popNotVisited :: VisitedMap -> Queue -> (Queue, (Int, Pos))
popNotVisited m q =
  if m M.! p
    then popNotVisited m q'
    else (q', (t, p))
  where
    ((t, p), q') = Q.deleteFindMin q

adjacent :: Pos -> Grid -> [(Pos, Int)]
adjacent p g =
  map (second fromJust)
    . filter (\(_, m) -> isJust m)
    . map ((\(i, j) -> ((i, j), MT.safeGet i j g)) . tmap (+) p)
    $ [(-1, 0), (0, 1), (1, 0), (0, -1)]

tmap :: (a -> b -> c) -> (a, a) -> (b, b) -> (c, c)
tmap f (a, b) (c, d) = (f a c, f b d)
