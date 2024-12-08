import Data.Function (on)
import Data.List (groupBy, nub, sortBy)
import Data.Ord (comparing)

type Pos = (Int, Int)

solve :: String -> Int
solve input = length . nub . antins $ groups
  where
    g = grid input
    locations = locate g
    srt (a, _) (b, _) = compare a b
    groups = map (map snd) . groupBy (on (==) fst) . sortBy (comparing fst) $ locations
    n = length g
    inBounds (i, j) = i >= 0 && i < n && j >= 0 && j < n
    antins = concatMap (concatMap (filter inBounds . \[a, b] -> antinodes a b) . choose 2)

grid :: String -> [[Char]]
grid = filter (not . null) . lines

locate :: [[Char]] -> [(Char, Pos)]
locate g =
  concatMap
    (filter ((/= '.') . fst) . (\i -> map (\j -> (charAt i j g, (i, j))) r))
    r
  where
    n = length g
    r = [0 .. n - 1]
    charAt i j = (!! j) . (!! i)

antinodes :: Pos -> Pos -> [Pos]
antinodes (ia, ja) (ib, jb) = [(ia - id, ja - jd), (ib + id, jb + jd)]
  where
    (id, jd) = (ib - ia, jb - ja)

choose :: Int -> [a] -> [[a]]
choose n xs
  | n == 0 = [[]]
  | null xs = []
  | n < 0 = []
  | otherwise = map (head xs :) (choose (n - 1) (tail xs)) ++ choose n (tail xs)

main :: IO ()
main = do
  input <- readFile "data/day8.txt"
  print . solve $ input
