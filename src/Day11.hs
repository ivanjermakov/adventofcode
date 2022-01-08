module Day11 where

import Control.Arrow ((***))
import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.Matrix (Matrix, fromLists, mapPos, prettyMatrix, setElem, toList, (!))

data Octopus = Octopus {energy :: Int, flashed :: Bool, flashCount :: Int, position :: Position}

type Position = (Int, Int)

instance Show Octopus where
  show (Octopus e f c _) = "(" ++ unwords [show e, [head $ show f], show c] ++ ")"

main11 :: IO ()
main11 = do
  content <- readFile "resources/d11.txt"
  let grid = parse content
  let resultGrid = nSteps 100 grid
  putStrLn . prettyMatrix $ resultGrid
  let totalFlashes = sum . map flashCount . toList $ resultGrid
  print totalFlashes
  where
    levels m = fmap energy m

nSteps :: Int -> Matrix Octopus -> Matrix Octopus
nSteps n m = case n of
  0 -> m
  _ -> nSteps (n - 1) (step m)

step :: Matrix Octopus -> Matrix Octopus
step = mResetFlashAll . step' . fmap incEnergy

step' :: Matrix Octopus -> Matrix Octopus
step' m = case exitedOctosPos of
  [] -> m
  _ -> step' next
  where
    next = foldr mFlash m exitedOctosPos
    exitedOctosPos = map position . filter isExited $ toList m
    isExited (Octopus e f _ _) = not f && e > 9

newOctopus :: Int -> Position -> Octopus
newOctopus e = Octopus e False 0

incEnergy :: Octopus -> Octopus
incEnergy o =
  if flashed o
    then o
    else o {energy = energy o + 1}

mResetFlashAll :: Matrix Octopus -> Matrix Octopus
mResetFlashAll = fmap resetFlash
  where
    resetFlash o = o {flashed = False}

mInc :: Position -> Matrix Octopus -> Matrix Octopus
mInc = update incEnergy

mFlash :: Position -> Matrix Octopus -> Matrix Octopus
mFlash pos m = foldr mInc flashedM $ neighbourPositions pos
  where
    flashedM = update flash pos m
    flash o = o {energy = 0, flashed = True, flashCount = flashCount o + 1}

neighbourPositions :: Position -> [Position]
neighbourPositions (i, j) =
  filter (/= (i, j))
    . filter (\(i', j') -> all inBounds [i', j'])
    . map (bimap (+ i) (+ j))
    $ neighbourPositionsOffset

inBounds :: (Ord a, Num a) => a -> Bool
inBounds x = x > 0 && x <= 10

update :: (a -> a) -> Position -> Matrix a -> Matrix a
update f pos m = setElem (f $ (!) m pos) pos m

neighbourPositionsOffset :: [Position]
neighbourPositionsOffset = [(a, b) | a <- [-1, 0, 1], b <- [-1, 0, 1]]

parse :: String -> Matrix Octopus
parse = mapPos (flip newOctopus) . fmap (read . (: [])) . fromLists . lines

mapTuple :: (a -> b) -> (a, a) -> (b, b)
mapTuple = join (***)
