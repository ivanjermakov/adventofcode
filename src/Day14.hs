{-# LANGUAGE TupleSections #-}

module Day14 where

import qualified Data.List as L
import Data.List.Split (splitOn)
import qualified Data.Map as M
import Data.Ord (comparing)

type Polymer = String

type Pair = (Char, Char)

type RuleMap = M.Map Pair Char

type PairMap = M.Map Pair Int

type Rule = (Pair, Char)

type Dict = M.Map Char Int

main14 :: IO ()
main14 = do
  content <- readFile "resources/d14.txt"
  let (p, rm) = parse content
  print (p, rm)
  let m = nSteps 40 rm (initMap p rm)
  let d = toDict p m
  print d
  print $ stats d

pretty :: M.Map (Char, Char) Int -> String
pretty = unlines . map (\((a, b), v) -> show [a, b] ++ " -> " ++ show v) . M.toList

parse :: String -> (Polymer, RuleMap)
parse c = (a, parseRules)
  where
    a : b : _ = splitOn "\n\n" c
    parseRules =
      M.fromList
        . map ((\((f : s : _) : (i : _) : _) -> ((f, s), i)) . splitOn " -> ")
        . lines
        $ b

initMap :: Polymer -> RuleMap -> PairMap
initMap p m = M.union polymerMap allPairMap
  where
    polymerMap = foldl (\m' p' -> M.insertWith (+) p' 1 m') M.empty . pairwise $ p
    allPairMap = M.fromList . map (,0) . pairPermutations . alphabet $ m

nSteps :: Int -> RuleMap -> PairMap -> PairMap
nSteps 0 _ m = m
nSteps n rm m = nSteps (n - 1) rm (step rm m)

step :: RuleMap -> PairMap -> PairMap
step rm m =
  M.unionsWith (+)
    . (m :)
    . map (`insertMapChange` m)
    . M.toList
    $ rm

stats :: Dict -> Int
stats d = head ls - last ls
  where
    ls = reverse . L.sort . map snd . M.toList $ d

insertMapChange :: Rule -> PairMap -> PairMap
insertMapChange ((l, r), i) m = M.fromListWith (+) [(right, c), (left, c), ((l, r), - c)]
  where
    c = m M.! (l, r)
    (left, right) = ((l, i), (i, r))

alphabet :: RuleMap -> [Char]
alphabet = L.nub . concatMap ((\(a, b) -> [a, b]) . fst) . M.toList

toDict :: Polymer -> PairMap -> Dict
toDict p m =
  M.adjust (+ 1) (last p)
    . M.fromList
    . map (foldl (\(_, c) (v, nc) -> (v, c + nc)) (undefined, 0))
    . L.groupBy byFst
    . L.sortBy (comparing fst)
    . map (\((f, _), c) -> (f, c))
    $ M.toList m
  where
    byFst a b = fst a == fst b

pairwise :: [a] -> [(a, a)]
pairwise a = zip a $ tail a

pairPermutations :: [a] -> [(a, a)]
pairPermutations ls = [(a, b) | a <- ls, b <- ls]
