{-# LANGUAGE TupleSections #-}

module Day5 where

import Data.List
import Data.List.Split

type Line = (Point, Point)

type Point = (Int, Int)

data Axis = Vertical | Horizontal | Diagonal
  deriving (Show, Enum)

parse :: String -> [Line]
parse content = map parseLine $ lines content

parseLine :: String -> Line
parseLine content = (a, b)
  where
    [a, b] = map parsePoint $ splitOn "->" content

parsePoint :: String -> Point
parsePoint content = toTuple . map read $ splitOn "," content
  where
    toTuple [a, b] = (a, b)
    
getCount :: [Line] -> Int
getCount lines' = length $ getPoints lines'

getPoints :: [Line] -> [Point]
getPoints lines' = nub . concatMap getPoints' $ pairs lines'

pairs :: Eq a => [a] -> [(a, a)]
pairs xs = [(x1, x2) | x1 <- xs, x2 <- xs, x1 /= x2]

getPoints' :: (Line, Line) -> [Point]
getPoints' (l1, l2) = case (axis l1, axis l2) of
  (Vertical, Horizontal) -> getIntersectPoints' l1 l2
  (Horizontal, Vertical) -> getIntersectPoints' l2 l1
  (Diagonal, _) -> []
  (_, Diagonal) -> []
  (a, _) -> getCoincidentPoints a l1 l2

--first line is vertical
getIntersectPoints' :: Line -> Line -> [Point]
getIntersectPoints' l1 l2 =
  let (((x1, _), (y1min, y1max)), ((x2min, x2max), (y2, _))) = (getRanges l1, getRanges l2)
   in if x1 `inRange` (x2min, x2max) && y2 `inRange` (y1min, y1max) then [(x1, y2)] else []

getCoincidentPoints :: Axis -> Line -> Line -> [Point]
getCoincidentPoints a l1 l2 = case a of
  Vertical -> case (fst (fst l1) == fst (fst l2), getIntersectingRange l1ys l2ys) of
    (True, Just vr) -> map (fst l1xs,) $ rangeToList vr
    _ -> []
  Horizontal -> case (snd (fst l1) == snd (fst l2), getIntersectingRange l1xs l2xs) of
    (True, Just hr) -> map (,fst l1ys) $ rangeToList hr
    _ -> []
  Diagonal -> []
  where
    (l1xs, l1ys) = getRanges l1
    (l2xs, l2ys) = getRanges l2

axis :: Line -> Axis
axis ((x1, y1), (x2, y2))
  | x1 == x2 = Vertical
  | y1 == y2 = Horizontal
  | otherwise = Diagonal

orthogonal :: Line -> Line -> Bool
orthogonal a b = (1 ==) $ sum . map (fromEnum . axis) $ [a, b]

getRanges :: Line -> Line
getRanges ((x1, y1), (x2, y2)) = ((minimum xs, maximum xs), (minimum ys, maximum ys))
  where
    xs = [x1, x2]
    ys = [y1, y2]

inRange :: Ord a => a -> (a, a) -> Bool
inRange x (a, b) = x >= a && x <= b

getIntersectingRange :: (Num a, Ord a) => (a, a) -> (a, a) -> Maybe (a, a)
getIntersectingRange (a1, a2) (b1, b2) = if b - a + 1 > 0 then Just (a, b) else Nothing
  where
    (a, b) = (maximum [a1, b1], minimum [a2, b2])

rangeToList :: (Int, Int) -> [Int]
rangeToList (a, b) = take (b - a + 1) $ iterate (+ 1) a
