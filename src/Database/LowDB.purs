module Database.LowDB where

import Prelude
import Data.Maybe
import Control.Monad.Eff
import Data.Array (singleton)

type LowDBEff a = ∀ a e . Eff ( lowdb :: LOWDB | e ) a

type DatabaseFileName = String
type Options =
    { writeOnChange :: Boolean
    }
type Connection = String
type Query = String
type CollectionName = String


connectTo :: ∀ e . DatabaseFileName -> Maybe Options -> Eff ( lowdb :: LOWDB | e ) Connection
connectTo db options = do
    let opts = maybe [] singleton options
    connString <- connectToImpl db opts
    pure connString

get :: ∀ a . Connection -> Query -> LowDBEff (Array a)
get c q = getImpl c q

defaults :: Connection -> Array CollectionName -> LowDBEff Unit
defaults c names = defaultsImpl c names

push :: ∀ a . Connection -> CollectionName -> a -> LowDBEff Unit
push c coll obj = pushImpl c coll obj

remove :: ∀ a . Connection -> CollectionName -> a -> LowDBEff Unit
remove c coll obj = removeImpl c coll obj

{---------------------------------
        Foreign Stuff
---------------------------------}

foreign import data LOWDB :: !

foreign import connectToImpl :: DatabaseFileName -> Array Options -> LowDBEff String
foreign import getImpl :: ∀ a . Connection -> Query -> LowDBEff (Array a)
foreign import defaultsImpl :: Connection -> Array CollectionName -> LowDBEff Unit
foreign import pushImpl :: ∀ a . Connection -> CollectionName -> a -> LowDBEff Unit
foreign import removeImpl :: ∀ a . Connection -> CollectionName -> a -> LowDBEff Unit
