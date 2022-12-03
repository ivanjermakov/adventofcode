module Day1 where

getDepthIncreaseCount :: (Ord a, Num b) => [a] -> b
getDepthIncreaseCount n = foldr (\(a, b) acc -> acc + if a < b then 1 else 0) 0 (listPairs n)

getDepthIncreaseCountWindow :: (Ord a, Num a, Num b) => [a] -> b
getDepthIncreaseCountWindow n =
  let sums = map (\(a, b, c) -> sum [a, b, c]) (listZip3 n)
   in getDepthIncreaseCount sums

listPairs :: [a] -> [(a, a)]
listPairs n = n `zip` tail n

listZip3 :: [a] -> [(a, a, a)]
listZip3 n = zip3 n (tail n) (drop 2 n)
