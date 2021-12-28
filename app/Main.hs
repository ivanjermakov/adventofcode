module Main where

import Day7

main :: IO ()
main = do
  content <- readFile "resources/d7.txt"
  let ns = parse content
  print $ getDistance ns
