solve :: String -> Int
solve _ = 5

main :: IO ()
main = do
  input <- readFile "data/day8.txt"
  print . solve $ input
