-- | This module specifies any utilities used by this package. At this time,
-- consider everything in this module to be private to the curl-runnings package
module Testing.CurlRunnings.Internal
  ( makeRed
  , makeGreen
  , tracer
  , mapRight
  , arrayGet
  , LogLevel(..)
  , CurlRunningsLogger
  , CurlRunningsPureLogger
  , makeLogger
  ) where

import Debug.Trace
import qualified Data.Text as T

makeGreen :: String -> String
makeGreen s = "\x1B[32m" ++ s ++ "\x1B[0m"

makeRed :: String -> String
makeRed s = "\x1B[31m" ++ s ++ "\x1B[0m"

tracer :: Show a => String -> a -> a
tracer a b = trace (a ++ ": " ++ show b) b

mapRight :: (b -> c) -> Either a b -> Either a c
mapRight f (Right v) = Right $ f v
mapRight _ (Left v)  = Left v

-- | Array indexing with negative values allowed
arrayGet :: [a] -> Int -> a
arrayGet a i
  | i >= 0 = a !! i
  | otherwise = reverse a !! (-i)

data LogLevel = ERROR | INFO | DEBUG deriving (Show, Eq, Ord, Enum)

type CurlRunningsLogger = (LogLevel -> String -> IO ())
type CurlRunningsPureLogger a = (LogLevel -> String -> a)

makeLogger :: LogLevel -> CurlRunningsLogger
makeLogger threshold = \level text ->
  if level <= threshold then
    putStrLn text
  else
    return ()



