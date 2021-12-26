{-# LANGUAGE TupleSections #-}

module Day5 where

import Data.List.Split
import Data.Map (fromListWith, toList)
import Data.Tuple (swap)

type Line = (Point, Point)

type Point = (Int, Int)

data Axis = N | NE | E | SE
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
getCount line = length $ getIntersectPoints line

getIntersectPoints :: [Line] -> [Point]
getIntersectPoints = map fst . filter ((> 1) . snd) . dict . concatMap getAllPoints

getAllPoints :: Line -> [Point]
getAllPoints line = case axis line of
  N -> getNPoints line
  E -> getEPoints line
  NE -> getNePoints line
  SE -> getSePoints line

getNPoints :: Line -> [Point]
getNPoints ((x, y1), (_, y2)) = map (x,) $ rangeToList (y1, y2)

getEPoints :: Line -> [Point]
getEPoints ((x1, y), (x2, _)) = map (,y) $ rangeToList (x1, x2)

getNePoints :: Line -> [Point]
getNePoints line = ps
  where
    ((x1, y1), (x2, y2)) = normalize line
    ps = zip (rangeToList (x1, x2)) (reverse $ rangeToList (y1, y2))

getSePoints :: Line -> [Point]
getSePoints line = ps
  where
    ((x1, y1), (x2, y2)) = normalize line
    ps = zip (rangeToList (x1, x2)) (rangeToList (y1, y2))

normalize :: Line -> Line
normalize line = if x1 < x2 then swap line else line
  where
    ((x1, _), (x2, _)) = line

axis :: Line -> Axis
axis ((x1, y1), (x2, y2))
  | x1 == x2 = N
  | y1 == y2 = E
  | (x1 < x2 && y1 > y2) || (x1 > x2 && y1 < y2) = NE
  | otherwise = SE

dict :: (Ord a) => [a] -> [(a, Integer)]
dict = toList . fromListWith (+) . map (,1)

rangeToList :: (Int, Int) -> [Int]
rangeToList r = take (b - a + 1) $ iterate (+ 1) a
  where
    l = [fst r, snd r]
    (a, b) = (minimum l, maximum l)
