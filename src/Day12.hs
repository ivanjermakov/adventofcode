module Day12 where

import Data.Char (isLower)
import Data.List (intercalate)
import Data.List.Split (splitOn)
import qualified Data.Map as M (Map, empty, fromList, insertWith, lookup, toList, (!))
import Data.Ord (comparing)
import qualified Data.Set as S (Set, singleton, toList)

class Pretty a where
  pretty :: a -> String

-- graph
newtype Graph a = Graph (M.Map a (S.Set a))
  deriving (Show)

instance (Show a) => Pretty (Graph a) where
  pretty (Graph m) = intercalate "\n" . map (\(k, v) -> show k ++ " -> " ++ pretty v) . M.toList $ m

instance (Show a) => Pretty (S.Set a) where
  pretty = show . S.toList

data Edge a = Edge a a
  deriving (Show)

empty :: Graph a
empty = Graph M.empty

addEdge :: (Ord a) => Edge a -> Graph a -> Graph a
addEdge (Edge a b) (Graph m) = Graph . add a b . add b a $ m
  where
    add e1 e2 = M.insertWith mappend e1 (S.singleton e2)

fromEdges :: (Ord a) => [Edge a] -> Graph a
fromEdges = foldr addEdge empty

adjacent :: (Ord a) => a -> Graph a -> [a]
adjacent a (Graph m) = maybeToList . fmap S.toList . M.lookup a $ m

nodes :: Graph a -> [a]
nodes (Graph m) = map fst . M.toList $m

maybeToList :: Maybe [a] -> [a]
maybeToList (Just a) = a
maybeToList Nothing = []

-- solution
data CaveGraph = CaveGraph {graph :: Graph String, caveMap :: M.Map String Cave}

type Route = [Cave]

data CaveType = Start | End | Big | Small
  deriving (Show, Eq, Ord)

data Cave = Cave {name :: String, caveType :: CaveType, visited :: Bool}
  deriving (Show)

instance Eq Cave where
  (==) a b = name a == name b

instance Ord Cave where
  compare = comparing name

fromName :: String -> Cave
fromName s = Cave s (parseCaveType s) False

parseCaveType :: String -> CaveType
parseCaveType "start" = Start
parseCaveType "end" = End
parseCaveType s = if isLower . head $s then Small else Big

canVisit :: Cave -> Bool
canVisit c = not (visited c) || caveType c == Big

visit :: Cave -> CaveGraph -> CaveGraph
visit c (CaveGraph g m) = CaveGraph g $ M.insertWith (\c' _ -> c' {visited = True}) (name c) c m

main12 :: IO ()
main12 = do
  content <- readFile "resources/d12.txt"
  let es = parse content
  let g = fromEdges es
  let cm = M.fromList . map (\k -> (k, fromName k)) . nodes $ g
  let cg = CaveGraph g cm
  let rs = routes cg
  print $ length rs

parse :: String -> [Edge String]
parse = map (listToEdge . splitOn "-") . lines
  where
    listToEdge (a : b : _) = Edge a b
    listToEdge _ = undefined

routes :: CaveGraph -> [Route]
routes = routes' start [start] []
  where
    start = fromName "start"

routes' :: Cave -> Route -> [Route] -> CaveGraph -> [Route]
routes' c r rs cg = case c of
  (Cave _ End _) -> rs ++ [r]
  _ -> concatMap (\c' -> routes' c' (r ++ [c]) rs (visit c cg)) nextCaves
  where
    nextCaves = filter canVisit . map (caveMap cg M.!) . (\e -> adjacent e (graph cg)) . name $ c
