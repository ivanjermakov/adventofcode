module Day10 where

import Data.List (sort)
import Data.Maybe (isNothing)

main10 :: IO ()
main10 = do
  content <- readFile "resources/d10.txt"
  let ls = lines content
  let res = (\l -> l !! (length l `div` 2)) . reverse . sort . map completionScore . filter (not . null) . map (map toClosing . snd) . filter (isNothing . fst) . map parse $ ls
  print res

-- Parse line and return first illegal char and stack at that moment
parse :: String -> (Maybe Char, [Char])
parse = parse' []

parse' :: [Char] -> String -> (Maybe Char, [Char])
parse' s l = case l of
  [] -> (Nothing, s)
  c : _ -> case updateStack (c, s) of
    (Just i, newS) -> (Just i, newS)
    (_, newS) -> parse' newS $ tail l

updateStack :: (Char, [Char]) -> (Maybe Char, [Char])
updateStack (c, s) =
  if isOpening c
    then (Nothing, c : s)
    else case safeHead s of
      Nothing -> (Just c, s)
      Just h -> if isMatching h c then (Nothing, tail s) else (Just c, s)

isOpening :: Char -> Bool
isOpening = flip elem "([{<"

toClosing :: Char -> Char
toClosing c = case c of
  '(' -> ')'
  '[' -> ']'
  '{' -> '}'
  '<' -> '>'
  _ -> undefined

-- First arg (opening) match second one (closing)
isMatching :: Char -> Char -> Bool
isMatching o c = case o of
  '(' -> c == ')'
  '[' -> c == ']'
  '{' -> c == '}'
  '<' -> c == '>'
  _ -> False

completionScore :: [Char] -> Int
completionScore = foldl f 0
  where
    f v e = (v * 5) + score e

score :: Char -> Int
score c = case c of
  '(' -> 1
  ')' -> 1
  '[' -> 2
  ']' -> 2
  '{' -> 3
  '}' -> 3
  '<' -> 4
  '>' -> 4
  _ -> 0

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (a : _) = Just a
