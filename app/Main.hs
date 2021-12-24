module Main where
import Day1

main :: IO ()
main = do
   content <- readFile "resources/d1.txt"
   let depths = map (\w -> read w :: Int) (words content)
   let res = getDepthIncreaseCountWindow depths
   print res
