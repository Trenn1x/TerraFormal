{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Types where

import GHC.Generics (Generic)
import Data.Aeson
import Data.Aeson.Types (Object)
import Data.Text (Text)

-- Top-level plan
data Plan = Plan
  { planned_values :: PlannedValues
  } deriving (Show, Generic)

instance FromJSON Plan

-- Planned values
data PlannedValues = PlannedValues
  { root_module :: RootModule
  } deriving (Show, Generic)

instance FromJSON PlannedValues

-- Root module
data RootModule = RootModule
  { resources :: [Resource]
  } deriving (Show, Generic)

instance FromJSON RootModule

-- Resource
data Resource = Resource
  { address       :: Text
  , type_         :: Text  -- 'type' is a reserved word in Haskell
  , name          :: Text
  , provider_name :: Text
  , values        :: Maybe Object
  } deriving (Show, Generic)

instance FromJSON Resource where
  parseJSON = withObject "Resource" $ \v -> Resource
    <$> v .:  "address"
    <*> v .:  "type"
    <*> v .:  "name"
    <*> v .:  "provider_name"
    <*> v .:? "values"
