module Main where

import Day2

main :: IO ()
main = do
  content <- readFile "resources/d2.txt"
  let plan = lines content
  let res = calculateFinalPosition plan
  print res
