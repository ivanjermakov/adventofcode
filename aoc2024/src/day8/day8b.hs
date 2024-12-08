import Data.Function (on)
import Data.List (groupBy, nub, sortBy)
import Data.Ord (comparing)

type Pos = (Int, Int)

solve :: String -> Int
solve input = length . nub . antins . groups . locate $ g
  where
    g = grid input
    grid = filter (not . null) . lines
    groups = map (map snd) . groupBy (on (==) fst) . sortBy (comparing fst)
    antins = concat . concatMap (map groupAntinodes . choose 2)
    groupAntinodes = filter inBounds . \[a, b] -> antinodes (n `div` 2) a b
    inBounds (i, j) = i >= 0 && i < n && j >= 0 && j < n
    n = length g

locate :: [[Char]] -> [(Char, Pos)]
locate g =
  concatMap
    (filter ((/= '.') . fst) . (\i -> map (\j -> (charAt i j g, (i, j))) r))
    r
  where
    n = length g
    r = [0 .. n - 1]
    charAt i j = (!! j) . (!! i)

antinodes :: Int -> Pos -> Pos -> [Pos]
antinodes count (ia, ja) (ib, jb) =
  concatMap
    (\c -> [(ia - c * id, ja - c * jd), (ib + c * id, jb + c * jd)])
    [0 .. count - 1]
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
