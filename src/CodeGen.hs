{-# LANGUAGE OverloadedStrings #-}

module CodeGen where

import Types
import Data.Text (Text, unpack)
import Data.Aeson (Value(..), Object)
import Data.Aeson.Key (Key, toText)
import qualified Data.Aeson.KeyMap as KM
import Data.List (intercalate)

generateLeanResource :: Resource -> String
generateLeanResource res =
  "def " ++ leanName ++ " : Resource := {\n" ++
  "  address := \"" ++ unpack (address res) ++ "\",\n" ++
  "  type := \"" ++ unpack (type_ res) ++ "\",\n" ++
  "  name := \"" ++ unpack (name res) ++ "\",\n" ++
  "  provider_name := \"" ++ unpack (provider_name res) ++ "\",\n" ++
  "  values := " ++ generateLeanValues (values res) ++ "\n" ++
  "}\n"
  where
    leanName = sanitizeName (address res)

sanitizeName :: Text -> String
sanitizeName = map replaceInvalid . unpack
  where
    replaceInvalid :: Char -> Char
    replaceInvalid c = if c `elem` ['.', '-', '[', ']'] then '_' else c

generateLeanValues :: Maybe Object -> String
generateLeanValues (Just obj) = "{\n" ++ intercalate ",\n" (map generateField (KM.toList obj)) ++ "\n}"
generateLeanValues Nothing = "{}"

generateField :: (Key, Value) -> String
generateField (key, value) = "    " ++ unpack (toText key) ++ " := " ++ generateValue value

generateValue :: Value -> String
generateValue (String txt) = "\"" ++ unpack txt ++ "\""
generateValue (Number num) = show num
generateValue (Bool b)     = if b then "true" else "false"
generateValue Null         = "null"
generateValue (Object _)   = "{ ... }"  -- Simplify nested objects
generateValue (Array _)    = "[ ... ]"  -- Simplify arrays

