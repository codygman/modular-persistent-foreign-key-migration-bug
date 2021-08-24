{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE  OverloadedStrings #-}

module Main where

import           Control.Monad.IO.Class         ( liftIO )
import           Database.Persist
import           Database.Persist.Sqlite
import           Database.Persist.Quasi
import           Database.Persist.TH
import           Person
import           System.Directory
import           Data.List                      ( isSuffixOf )

mkMigrate "migrateAll" $(do
    files <- liftIO $ do
        dirContents <- getDirectoryContents "config/models/"
        pure $ map ("config/models/" <>) $ filter (".persistentmodels" `isSuffixOf`) dirContents
    persistManyFileWith lowerCaseSettings files
    )

share [mkPersistWith sqlSettings $(discoverEntities)] $(persistFileWith lowerCaseSettings "config/models/blogPost.persistentmodel")

main :: IO ()
main = runSqlite ":memory:" $ do
  runMigration migrateAll

  johnId <- insert $ Person "John Doe" $ Just 35
  janeId <- insert $ Person "Jane Doe" Nothing

  insert $ BlogPost "My fr1st p0st" johnId
  insert $ BlogPost "One more for good measure" johnId

  oneJohnPost <- selectList [BlogPostAuthorId ==. johnId] [LimitTo 1]
  liftIO $ print (oneJohnPost :: [Entity BlogPost])

  john <- get johnId
  liftIO $ print (john :: Maybe Person)

  delete janeId
  deleteWhere [BlogPostAuthorId ==. johnId]
