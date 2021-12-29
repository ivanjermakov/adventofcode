module Main where

import Day8

main :: IO ()
main = do
  content <- readFile "resources/d8.txt"
  let rs = parse content
  print $ sum . map (foldl1 (\a b -> 10 * a + b) . solve) $ rs
