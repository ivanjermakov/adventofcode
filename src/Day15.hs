module Day15 where

import Data.Bifunctor (second)
import Data.Char (digitToInt)
import Data.List (sortOn)
import qualified Data.Map as M
import Data.Matrix (Matrix, fromLists, mapPos, ncols, nrows, safeGet, toList, (!))
import Data.Maybe (fromJust, isJust)

type Grid = Matrix Int

type Pos = (Int, Int)

data Node = Node {risk :: Int, tentative :: Int, visited :: Bool, prev :: Maybe Pos}
  deriving (Show)

type NodeMap = M.Map Pos Node

main15 :: IO ()
main15 = do
  content <- readFile "resources/d15.txt"
  let g = parse content
  let m = nodeMap g
  let resM = traverseMap g m
  let lastPos = (nrows g, ncols g)
  print $ tentative $ resM M.! lastPos

traverseMap :: Grid -> NodeMap -> NodeMap
traverseMap g m = traverseMap' startPos g newM
  where
    startPos = (1, 1)
    newM = M.adjust (\n -> n {tentative = 0}) startPos m

traverseMap' :: Pos -> Grid -> NodeMap -> NodeMap
traverseMap' p g m = case next of
  (nPos, _) : _ -> traverseMap' nPos g newM
  [] -> m
  where
    c = newM M.! p
    adj = adjacent p g
    newM = foldl (\accM (p', w') -> examineAdjacent p' (tentative c + w') p accM) (visitNode p m) adj
    next = sortOn (tentative . snd) . filter (\(_, v) -> not . visited $ v) . M.toList $ newM

examineAdjacent :: Pos -> Int -> Pos -> NodeMap -> NodeMap
examineAdjacent p w prevP = M.adjust upd p
  where
    shouldUpdate v = not (visited v) && w < tentative v
    upd v =
      if shouldUpdate v
        then v {tentative = w, prev = Just prevP}
        else v

visitNode :: Pos -> NodeMap -> NodeMap
visitNode = M.adjust upd
  where
    upd v = v {visited = True}

parse :: String -> Grid
parse = fromLists . map (map digitToInt) . lines

pretty :: (Show k, Show v) => M.Map k v -> String
pretty = unlines . map (\(k, v) -> show k ++ " -> " ++ show v) . M.toList

nodeMap :: Grid -> NodeMap
nodeMap = M.fromList . map (\(p, r) -> (p, Node r infinity False Nothing)) . toList . mapPos (,)

adjacent :: Pos -> Grid -> [(Pos, Int)]
adjacent p g =
  map (second fromJust)
    . filter (\(_, m) -> isJust m)
    . map ((\(i, j) -> ((i, j), safeGet i j g)) . tmap (+) p)
    $ [(-1, 0), (0, 1), (1, 0), (0, -1)]

tmap :: (a -> b -> c) -> (a, a) -> (b, b) -> (c, c)
tmap f (a, b) (c, d) = (f a c, f b d)

infinity :: Int
infinity = maxBound
