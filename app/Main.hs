module Main where

import Day3

main :: IO ()
main = do
  content <- readFile "resources/d3.txt"
  let matrix = map (map (\e -> read [e] :: Int)) (lines content)
  let res = calculatePower matrix
  print res
