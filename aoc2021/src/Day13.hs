module Day13 where

import Data.Bifunctor (second)
import Data.List (intercalate, nub, partition)
import Data.List.Split (splitOn)

type Coordinate = (Int, Int)

data Direction = X | Y
  deriving (Show)

data Fold = Fold Direction Int
  deriving (Show)

type Shape = (Int, Int)

main13 :: IO ()
main13 = do
  content <- readFile "resources/d13.txt"
  let (cs, fs) = parse content
  print cs
  let res = foldl foldPaper cs fs
  print res
  putStrLn . pretty $ res

parse :: String -> ([Coordinate], [Fold])
parse c = (parseC cc, parseFs fc)
  where
    (cc, fc) = listToTuple . splitOn "\n\n" $ c
    parseC = map (listToTuple . map read . splitOn ",") . lines
    parseFs = map (parseF . last . words) . lines
    parseF = tupleToFold . second read . listToTuple . splitOn "="
    tupleToFold (d, v) = Fold (parseDirection d) v
    listToTuple (a : b : _) = (a, b)
    listToTuple _ = undefined

parseDirection :: String -> Direction
parseDirection d = case d of
  "x" -> X
  "y" -> Y
  _ -> undefined

pretty :: [Coordinate] -> String
pretty cs =
  intercalate "\n"
    . map
      ( prettyIdx (fst $ shape cs)
          . map fst
          . \i -> filter (\e -> i == snd e) cs
      )
    $ take maxY (iterate (+ 1) 0)
  where
    (_, maxY) = shape cs

prettyIdx :: Int -> [Int] -> String
prettyIdx s l =
  foldl
    (\acc i -> acc ++ if i `elem` l then "#" else ".")
    ""
    (take s $ iterate (+ 1) 0)

shape :: [Coordinate] -> Shape
shape cs = ((+ 1) . maximum . map fst $ cs, (+ 1) . maximum . map snd $ cs)

foldPaper :: [Coordinate] -> Fold -> [Coordinate]
foldPaper cs (Fold d v) = case d of
  X -> nub $ a ++ map move b
    where
      move (x, y) = (x - ((x - v) * 2), y)
      (a, b) = partition (\e -> fst e < v) cs
  Y -> nub $ a ++ map move b
    where
      move (x, y) = (x, y - ((y - v) * 2))
      (a, b) = partition (\e -> snd e < v) cs
