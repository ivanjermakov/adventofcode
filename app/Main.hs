module Main where

import Day9

main :: IO ()
main = do
  content <- readFile "resources/d9.txt"
  let m = parse content
  let lps = getLowest m
  print $ sum . map (1 +) $ lps
