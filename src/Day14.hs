module Day14 where

import Data.List (group, sort)
import Data.List.Split (splitOn)
import qualified Data.Map as M

type Polymer = String

main14 :: IO ()
main14 = do
  content <- readFile "resources/d14.txt"
  let p = parse content
  let polymer = nSteps 10 p
  print $ stats polymer

nSteps :: Int -> (Polymer, M.Map String String) -> Polymer
nSteps 0 (p, _) = p
nSteps n (p, m) = nSteps (n -1) (polyStep (p, m), m)

stats :: Polymer -> Int
stats p = head countList - last countList
  where
    countList = reverse . sort . map length . group . sort $ p

polyStep :: (Polymer, M.Map String String) -> Polymer
polyStep (p, rs) = (++ [last p]) . concatMap (\(a, b) -> a : subst [a, b]) . pairwise $ p
  where
    subst t = rs M.! t

parse :: String -> (Polymer, M.Map String String)
parse c = (a, parseRules)
  where
    a : b : _ = splitOn "\n\n" c
    parseRules = M.fromList . map ((\(p : i : _) -> (p, i)) . splitOn " -> ") . lines $ b

pairwise :: [a] -> [(a, a)]
pairwise a = zip a $ tail a
