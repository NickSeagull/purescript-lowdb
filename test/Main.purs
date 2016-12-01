module Test.Main where

import Prelude
import Data.Maybe
import Database.LowDB
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Foldable (traverse_)

main :: forall e. Eff (console :: CONSOLE, lowdb :: LOWDB | e) Unit
main = do
    log "------ Running DB tests ------"
    log "Connecting..."
    conn <- connectTo "test.json" Nothing
    defaults conn ["numbers"]
    log "Inserting..."
    push conn "numbers" 2
    log "Getting..."
    n :: Array Int <- get conn "numbers"
    traverse_ (\x -> log $ show x) n
    log "Cleaning..."
    remove conn "numbers" {}
