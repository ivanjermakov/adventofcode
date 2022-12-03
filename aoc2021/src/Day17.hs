module Day17 where

type Pos = (Int, Int)

type Range = (Int, Int)

type Velocity = (Int, Int)

type Area = (Range, Range)

-- .....|....
-- .T.aaa....
-- ...aIa..F.
-- ___aaa....
-- .S......B.
data Result = In | Short | Far | Both | Through | Tbd
  deriving (Eq, Show)

targetArea :: Area
--test
--targetArea = ((20, 30), (-10, -5))
targetArea = ((241, 275), (-75, -49))

main17 :: IO ()
main17 = do
  let vs = findVelocities ((0, 1000), (-200, 400)) targetArea
  print $ bounds vs
  print $ length vs

bounds :: [Range] -> Area
bounds =
  foldl
    ( \((minX, maxX), (minY, maxY)) (x, y) ->
        ((min minX x, max maxX x), (min minY y, max maxY y))
    )
    ((maxBound, minBound), (maxBound, minBound))

findVelocities :: Area -> Area -> [Velocity]
findVelocities ((xMinV, xMaxV), (yMinV, yMaxV)) a =
  map fst
    . filter ((== In) . snd . snd)
    . map (\v -> (v, simulate v a))
    $ [(x, y) | x <- [xMinV .. xMaxV], y <- [yMinV .. yMaxV]]

simulate :: Velocity -> Area -> ([Pos], Result)
simulate v = simulate' (startPos, v, [startPos])
  where
    startPos = (0, 0)
    simulate' :: (Pos, Velocity, [Pos]) -> Area -> ([Pos], Result)
    simulate' (p, (vx, vy), ps) a = case result p' a of
      Tbd -> simulate' (p', v', ps') a
      r -> (ps', r)
      where
        ps' = ps ++ [p']
        v' = (decrease vx, vy - 1)
        p' = applyVelocity (vx, vy) p
        applyVelocity (vx', vy') (x, y) = (x + vx', y + vy')

result :: Pos -> Area -> Result
result (x, y) (xr, yr)
  | xInR && yInR = In
  | x > snd xr && y < fst yr = Both
  | xInR && y < fst yr = Through
  | y < fst yr = Short
  | x > snd xr = Far
  | otherwise = Tbd
  where
    xInR = x `inRange` xr
    yInR = y `inRange` yr

inRange :: Int -> Range -> Bool
inRange a (b, c) = b <= a && a <= c

decrease :: (Num a, Ord a) => a -> a
decrease 0 = 0
decrease a = if a > 0 then a - 1 else a + 1

maxPossibleX :: Int -> Int
maxPossibleX = maxPossibleX' 0
  where
    maxPossibleX' n maxN
      | res > maxN = n
      | otherwise = maxPossibleX' (n + 1) maxN
      where
        res = convergeTo (n + 1) 0
        convergeTo 0 x = x
        convergeTo v x = convergeTo (v - 1) (x + (v - 1))
