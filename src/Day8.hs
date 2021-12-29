module Day8 where

import Data.Char (toUpper)
import Data.List (group, sort, (\\))
import Data.List.Split (splitOn)
import Data.Map (Map, elems, empty, fromList, insert, toList, (!))
import Data.Tuple (swap)

data Record = Record [Digit] [Digit]
  deriving (Show)

type Digit = [Segment]

data Segment = A | B | C | D | E | F | G
  deriving (Enum, Eq, Ord, Show, Read)

type SegmentMap = Map Segment Segment

maze :: Record -> [Digit]
maze (Record m _) = m

target :: Record -> [Digit]
target (Record _ t) = t

parse :: String -> [Record]
parse = map parseRecord . lines

parseRecord :: String -> Record
parseRecord s = case map (map parseDigit . words) $ splitOn "|" s of
  [left, right] -> Record left right
  _ -> undefined

parseDigit :: String -> Digit
parseDigit = sort . map parseSegment

parseSegment :: Char -> Segment
parseSegment c = read [toUpper c]

solve :: Record -> [Int]
solve r = ds
  where
    m = findMap $ maze r
    (Just ds) = mapM (toDigit . mapDigit m) $ target r

mapDigit :: SegmentMap -> Digit -> Digit
mapDigit m = map (invertMap m !)

toDigit :: Digit -> Maybe Int
toDigit d = case sort d of
  [A, B, C, E, F, G] -> Just 0
  [C, F] -> Just 1
  [A, C, D, E, G] -> Just 2
  [A, C, D, F, G] -> Just 3
  [B, C, D, F] -> Just 4
  [A, B, D, F, G] -> Just 5
  [A, B, D, E, F, G] -> Just 6
  [A, C, F] -> Just 7
  [A, B, C, D, E, F, G] -> Just 8
  [A, B, C, D, F, G] -> Just 9
  _ -> Nothing

findMap :: [Digit] -> SegmentMap
findMap ds = foldl (\m f -> f ds m) empty ls
  where
    ls = [findA, findC, findE, findF, findB, findD, findG]

-- Difference between s2 and s3 digits
findA :: [Digit] -> SegmentMap -> SegmentMap
findA ds = insert A (head $ inOne [s2 ds, s3 ds])

-- 8 occurrences in 10 digits except A
-- A must be known
findC :: [Digit] -> SegmentMap -> SegmentMap
findC ds m = insert C c m
  where
    c = head $ o8 \\ [m ! A]
    o8 = map fst . filter (\(_, o) -> o == 8) . toList . occurrenceMap $ ds

-- Difference between s6 not present in s4
findE :: [Digit] -> SegmentMap -> SegmentMap
findE ds = insert E e
  where
    s6 = findWithLength 6 ds
    s6Diff = inSome s6
    e = head $ s6Diff \\ s4 ds

-- Not C in s2
-- C must be known
findF :: [Digit] -> SegmentMap -> SegmentMap
findF ds m = insert F f m
  where
    f = head $ head (findWithLength 2 ds) \\ [m ! C]

-- 6 occurrences in 10 digits
findB :: [Digit] -> SegmentMap -> SegmentMap
findB ds = insert B b
  where
    b = fst . head . filter (\(_, o) -> o == 6) . toList . occurrenceMap $ ds

-- Only left not known in s4
-- All except G and D must be known
findD :: [Digit] -> SegmentMap -> SegmentMap
findD ds m = insert D d m
  where
    d = head $ s4 ds \\ elems m

-- Only left not known
-- All except G must be known
findG :: [Digit] -> SegmentMap -> SegmentMap
findG ds m = insert G g m
  where
    g = head $ enumFrom A \\ elems m

s2 :: [Digit] -> Digit
s2 = head . findWithLength 2

s3 :: [Digit] -> Digit
s3 = head . findWithLength 3

s4 :: [Digit] -> Digit
s4 = head . findWithLength 4

findWithLength :: Int -> [Digit] -> [Digit]
findWithLength l = filter (\e -> length e == l)

inOne :: (Ord a) => [[a]] -> [a]
inOne = map head . filter (\l -> length l == 1) . group . sort . concat

inSome :: (Ord a) => [[a]] -> [a]
inSome ls = map head . filter (\l -> length l < length ls) . group . sort . concat $ ls

occurrenceMap :: (Ord k) => [[k]] -> Map k Int
occurrenceMap = fromList . map (\l -> (head l, length l)) . group . sort . concat

invertMap :: (Ord v) => Map k v -> Map v k
invertMap = fromList . map swap . toList
