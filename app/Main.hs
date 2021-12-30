module Main where

import Data.List (sort)
import Data.Matrix (prettyMatrix, (!))
import Day9

main :: IO ()
main = do
  content <- readFile "resources/d9.txt"
  let m = parse content
  let lps = getLowest m
  let bs = product . take 3 . reverse . sort . map (length . basin m) $ lps
  print bs
