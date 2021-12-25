module Main where

import Day4

main :: IO ()
main = do
  content <- readFile "resources/d4.txt"
  let (ns, bs) = parse content
  print $ findLastWinner ns bs
  print $ findWinnerScore ns bs
