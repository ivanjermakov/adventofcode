module Day16 where

import Data.Char (digitToInt)
import Data.List (intercalate)
import Data.Maybe (fromJust, listToMaybe, mapMaybe)
import Numeric (readHex, readInt)
import Text.Printf (printf)

type HexString = String

type BitSequence = String

type Version = Int

data PacketType
  = Sum -- 0
  | Product -- 1
  | Minimum -- 2
  | Maximum -- 3
  | Literal -- 4
  | GreaterThan -- 5
  | LessThan -- 6
  | EqualTo -- 7
  deriving (Enum, Eq, Show, Read)

type LengthTypeId = Int

type PacketLength = Int

data Header = Header {version :: Version, packetType :: PacketType}
  deriving (Show, Read)

data Packet
  = LiteralPacket Header Int
  | OperatorPacket Header [Packet]
  deriving (Show, Read)

header :: Packet -> Header
header (LiteralPacket h _) = h
header (OperatorPacket h _) = h

main16 :: IO ()
main16 = do
  inputHex <- readFile "resources/d16.txt"
  let p = fst . parse . hexStrToBin $ inputHex
  putStrLn $ pretty p
  print . eval $ p

eval :: Packet -> Int
eval p = case (packetType . header $ p, p) of
  (Sum, OperatorPacket _ ps) -> sum . evalPs $ ps
  (Literal, LiteralPacket _ v) -> v
  (Product, OperatorPacket _ ps) -> product . evalPs $ ps
  (Minimum, OperatorPacket _ ps) -> minimum . evalPs $ ps
  (Maximum, OperatorPacket _ ps) -> maximum . evalPs $ ps
  (GreaterThan, OperatorPacket _ ps) -> comparePs (>) ps
  (LessThan, OperatorPacket _ ps) -> comparePs (<) ps
  (EqualTo, OperatorPacket _ ps) -> comparePs (==) ps
  where
    evalPs = map eval
    comparePs f = (\(a : b : _) -> fromEnum $ f a b) . evalPs

pretty :: Packet -> String
pretty = pretty' 0
  where
    tab = flip replicate '\t'
    pretty' :: Int -> Packet -> String
    pretty' dep (OperatorPacket h sps) =
      tab dep
        ++ "OperatorPacket "
        ++ show h
        ++ "\n"
        ++ (intercalate "\n" . map (pretty' (dep + 1)) $ sps)
    pretty' dep literalPacket = tab dep ++ show literalPacket

parse :: BitSequence -> (Packet, BitSequence)
parse s =
  if packetType h == Literal
    then useParser parseLiteralPacket
    else useParser parseOperatorPacket
  where
    (h, s') = parseHeader s
    useParser pf = pf h s'

parseMany :: ([Packet] -> BitSequence -> Bool) -> BitSequence -> ([Packet], BitSequence)
parseMany stopPredicate bitS = parseMany' ([], bitS)
  where
    parseMany' :: ([Packet], BitSequence) -> ([Packet], BitSequence)
    parseMany' (ps, s) =
      if stopPredicate ps s
        then (ps, s)
        else parseMany' (ps ++ [p], left)
      where
        (p, left) = parse s

parseHeader :: BitSequence -> (Header, BitSequence)
parseHeader s = (Header parseVersion parseTypeId, s')
  where
    (hs, s') = splitAt 6 s
    (vs, ts) = splitAt 3 hs
    parseVersion = fromBin vs
    parseTypeId = toEnum . fromBin $ ts

parseLiteralPacket :: Header -> BitSequence -> (Packet, BitSequence)
parseLiteralPacket h s = (LiteralPacket h n, s')
  where
    (_, ns, s') = parseNibbles (False, "", s)
    n = fromBin ns

parseNibbles :: (Bool, BitSequence, BitSequence) -> (Bool, BitSequence, BitSequence)
parseNibbles (skip, s, s')
  | skip = (skip, s, s')
  | i == '0' = parseNibbles (True, s ++ next, s'')
  | otherwise = parseNibbles (skip, s ++ next, s'')
  where
    (i : next, s'') = splitAt 5 s'

parseOperatorPacket :: Header -> BitSequence -> (Packet, BitSequence)
parseOperatorPacket h s = (OperatorPacket h sps, s'')
  where
    (sps, s'') =
      if lenTypeId == 15
        then parseSubPackets15 size s'
        else parseSubPackets11 size s'
    (lenTypeId, size, s') = parsePacketLengthType s

parseSubPackets15 :: Int -> BitSequence -> ([Packet], BitSequence)
parseSubPackets15 spBitLen s = (sps, s')
  where
    (spBits, s') = splitAt spBitLen s
    (sps, _) = parseMany (\_ _s -> null _s) spBits

parseSubPackets11 :: Int -> BitSequence -> ([Packet], BitSequence)
parseSubPackets11 spCount s = (sps, s')
  where
    (sps, s') = parseMany (\ps _ -> length ps == spCount) s

parsePacketLengthType :: BitSequence -> (LengthTypeId, Int, BitSequence)
parsePacketLengthType (controlBit : s) = (c, fromBin lenBits, s')
  where
    c = if controlBit == '0' then 15 else 11
    (lenBits, s') = splitAt c s

hexStrToBin :: HexString -> BitSequence
hexStrToBin = concat . mapMaybe hexToBin

hexToBin :: Char -> Maybe String
hexToBin c =
  case readHex [c] of
    (x, _) : _ -> Just $ printf "%04b" (x :: Int)
    _ -> Nothing

fromBin :: BitSequence -> Int
fromBin = fromJust . readBin
  where
    readBin :: Integral a => String -> Maybe a
    readBin = fmap fst . listToMaybe . readInt 2 (`elem` "01") digitToInt
