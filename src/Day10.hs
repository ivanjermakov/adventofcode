module Day10 where

import Data.Maybe (mapMaybe)

main10 :: IO ()
main10 = do
  content <- readFile "resources/d10.txt"
  let ls = lines content
  let res = sum . map score . mapMaybe (fst . parse) $ ls
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

-- First arg (opening) match second one (closing)
isMatching :: Char -> Char -> Bool
isMatching o c = case o of
  '(' -> c == ')'
  '[' -> c == ']'
  '{' -> c == '}'
  '<' -> c == '>'
  _ -> False

score :: Char -> Int
score c = case c of
  '(' -> 3
  ')' -> 3
  '[' -> 57
  ']' -> 57
  '{' -> 1197
  '}' -> 1197
  '<' -> 25137
  '>' -> 25137
  _ -> 0

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (a : _) = Just a
