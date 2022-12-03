module Day2 where

import Data.Char
import Data.Maybe

data Direction = Forward | Up | Down
  deriving (Show, Read)

data Step = Step Direction Int
  deriving (Show)

data Position = Position Horiz Depth Aim
  deriving (Show)

type Horiz = Int

type Depth = Int

type Aim = Int

type RawPlan = [String]

type Plan = [Step]

calculateFinalPosition :: RawPlan -> Position
calculateFinalPosition plan = foldToFinal $ fromMaybe [] (parsePlan plan)

foldToFinal :: Plan -> Position
foldToFinal = foldl (flip nextPosition) (Position 0 0 0)

nextPosition :: Step -> Position -> Position
nextPosition step (Position h d a) = case step of
  Step Forward v -> Position (h + v) (d + a * v) a
  Step Up v -> Position h d (a - v)
  Step Down v -> Position h d (a + v)

parsePlan :: RawPlan -> Maybe Plan
parsePlan plan =
  let comp = sequence . filter isJust . map parseStep
   in comp plan

parseStep :: String -> Maybe Step
parseStep step = case Prelude.words step of
  [direction, value] -> case parseDirection direction of
    Just d -> Just $ Step d (read value :: Int)
    Nothing -> Nothing
  _ -> Nothing

parseDirection :: String -> Maybe Direction
parseDirection ws = case map toLower ws of
  "forward" -> Just Forward
  "up" -> Just Up
  "down" -> Just Down
  _ -> Nothing
