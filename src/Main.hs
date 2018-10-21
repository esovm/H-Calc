-- from http://hsyl20.fr/home/posts/2018-05-22-extensible-adt.html

module Main where

import A_Add
import B_Mul
import Utils

import Haskus.Utils.EADT
import Data.Functor.Foldable

addVal = Add (Val 10) (Val 5) :: AddValADT
mulAddVal = Mul (Val 3) (Add (Val 10) (Val 3)) :: MulAddValADT

-- Add Float
--------------------------------------------------------

data FloatValF e = FloatValF Float deriving (Functor)

pattern FloatVal :: FloatValF :<: xs => Float -> EADT xs
pattern FloatVal a = VF (FloatValF a)

instance ShowEADT FloatValF where
    showEADT' (FloatValF i) = show i

-- Type checker
--------------------------------------------------------
instance TypeCheck ValF ys where
  typeCheck' _ = T "Int"

instance TypeCheck FloatValF ys where
  typeCheck' _ = T "Float"

instance (AddF :<: ys, ShowEADT (VariantF ys), Functor (VariantF ys)) => TypeCheck AddF ys where
  typeCheck' (AddF (u,t1) (v,t2))
    | t1 == t2       = t1
    | TError _ <- t1 = t1 -- propagate errors
    | TError _ <- t2 = t2
    | otherwise = TError $ "can't add `" <> showEADT u <> "` whose type is " <> show t1 <>
                          " with `" <> showEADT v <> "` whose type is " <> show t2


-- Main
--------------------------------------------------------
main :: IO ()
main = do
  putTextLn "hello world"
  putTextLn $ showEADT addVal
  putTextLn $ showEADT mulAddVal
  putTextLn $ show $ evalEADT mulAddVal
  putTextLn $ showEADT (distr mulAddVal)
  putTextLn $ showEADT (demultiply $ distr mulAddVal)
  --putTextLn $ showEADT (cata simplify (mulAddVal) :: AddValADT)
  putTextLn $ showEADT (Add (Val 10) (FloatVal 5) :: EADT '[ValF,FloatValF,AddF])
  putTextLn $ show $ para typeCheck' (Add (Val 10) (FloatVal 5) :: EADT '[ValF,FloatValF,AddF])

