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

module Person where

import           Control.Monad.IO.Class         ( liftIO )
import           Database.Persist
import           Database.Persist.Sqlite
import           Database.Persist.TH


share [mkPersist sqlSettings, mkMigrate "personMigrateAll"] [persistLowerCase|
Person
   name String
   age Int Maybe
   deriving Show
|]
