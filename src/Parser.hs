{-# LANGUAGE OverloadedStrings #-}

module Parser where

import Types
import Data.Aeson (eitherDecodeFileStrict)
import System.IO (hPutStrLn, stderr)

parsePlan :: FilePath -> IO (Either String [Resource])
parsePlan filePath = do
  result <- eitherDecodeFileStrict filePath :: IO (Either String Plan)
  case result of
    Left err -> return $ Left err
    Right plan -> do
      let resList = resources (root_module (planned_values plan))
      return $ Right resList

