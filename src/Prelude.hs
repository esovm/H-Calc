
module Prelude
       ( module Relude
       , trace
       , traceM
       , traceId
       , traceShow
       , traceShowId
       , traceShowM
       ) where

import Relude  hiding
    ( -- * Tracing
        trace
        , traceM
        , traceId
        , traceShow
        , traceShowId
        , traceShowM
     )

import qualified Debug.Trace as Debug

----------------------------------------------------------------------------
-- trace
----------------------------------------------------------------------------

-- | Version of 'Debug.Trace.trace' that leaves warning.
trace :: String -> a -> a
trace = Debug.trace
--{-# WARNING trace "'trace' remains in code" #-}

-- | Version of 'Debug.Trace.traceShow' that leaves warning.
traceShow :: Show a => a -> b -> b
traceShow = Debug.traceShow
--{-# WARNING traceShow "'traceShow' remains in code" #-}

-- | Version of 'Debug.Trace.traceShowId' that leaves warning.
traceShowId :: Show a => a -> a
traceShowId = Debug.traceShowId
--{-# WARNING traceShowId "'traceShowId' remains in code" #-}

-- | Version of 'Debug.Trace.traceShowM' that leaves warning.
traceShowM :: (Show a, Applicative f) => a -> f ()
traceShowM = Debug.traceShowM
--{-# WARNING traceShowM "'traceShowM' remains in code" #-}

-- | Version of 'Debug.Trace.traceM' that leaves warning.
traceM :: (Applicative f) => String -> f ()
traceM = Debug.traceM
--{-# WARNING traceM "'traceM' remains in code" #-}

-- | Version of 'Debug.Trace.traceId' that leaves warning.
traceId :: String -> String
traceId = Debug.traceId
--{-# WARNING traceId "'traceId' remains in my code" #-}
