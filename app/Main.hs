module Main where

import Day5

main :: IO ()
main = do
  content <- readFile "resources/d5.txt"
  let lines' = parse content
--print lines'
  print $ getCount lines'
