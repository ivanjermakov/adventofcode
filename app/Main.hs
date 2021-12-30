module Main where

import Day9
import Data.List (sort)

main :: IO ()
main = do
  content <- readFile "resources/d9-test.txt"
  let m = parse content
  let lps = getLowest m
  let bs = product . take 3 . reverse . sort . map (length . getBasin m) $ lps
  print bs
