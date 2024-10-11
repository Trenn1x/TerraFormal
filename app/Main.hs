module Main where

import Parser
import CodeGen
import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [jsonFile, leanFile] -> do
      parseResult <- parsePlan jsonFile
      case parseResult of
        Left err -> hPutStrLn stderr $ "Error parsing plan: " ++ err
        Right resources -> do
          let leanCode = unlines $ map generateLeanResource resources
          writeFile leanFile leanCode
          putStrLn $ "Lean code generated in " ++ leanFile
    _ -> hPutStrLn stderr "Usage: stack run <plan.json> <output.lean>"

