module Main where

import Day6

main :: IO ()
main = do
  content <- readFile "resources/d6.txt"
  let ns = parse content
  print $ sum $ simulate 256 ns
