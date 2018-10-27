
module Interpreter.A_Annotation where

  -- this module adds the following language construct to the DSL
  --    (EmptyNote)
  --    (Typ t α)
  -------------------------------------------------------

  import Interpreter.Utils
  import Interpreter.Result
  
  import Haskus.Utils.EADT

  -- EmptyNote

  data EmptyNoteF e = EmptyNoteF deriving (Functor)

  pattern EmptyNote :: EmptyNoteF :<: xs => EADT xs
  pattern EmptyNote = VF EmptyNoteF

  -- Type t α

  data TType = TInt | TFloat deriving Show

  data TTypeF e = TTypeF TType e deriving (Functor)

  pattern Typ :: TTypeF :<: xs => TType -> EADT xs -> EADT xs
  pattern Typ t a = VF (TTypeF t a)
  

  -- show
  --------------------------------------------------------
  
  instance ShowAST EmptyNoteF where
    showAST' EmptyNoteF = ""

  instance ShowAST TTypeF where
    showAST' (TTypeF t α) = " :: " <> show t <> α



  -- Get Type
  --------------------------------------------------------
  class GetType (f :: * -> *) where
    getType' :: f TType -> TType    

  instance GetType (VariantF '[]) where
    getType' = error "no implementation of Type Check for this type"

  instance (GetType x, GetType (VariantF xs))  => GetType (VariantF (x ': xs)) where
    getType' v = case popVariantFHead v of
        Right u -> getType' u
        Left  w -> getType' w

  getType :: (GetType (Base t), Recursive t) => t -> TType
  getType = cata getType'
  
  instance GetType HErrorF where
    getType' _ = error "no type in annotation"

  instance GetType EmptyNoteF where
    getType' _ = error "no type in annotation"

  instance GetType TTypeF where
    getType' (TTypeF t _)  = t



  -- Set Type
  --------------------------------------------------------
  class SetType (f :: * -> *) xs where
    setType' :: f (EADT xs) -> EADT xs

  instance SetType (VariantF '[]) xs where
    setType' = error "no implementation of Type Check for this type"

  instance (SetType x ys, SetType (VariantF xs) ys)  => SetType (VariantF (x ': xs)) ys where
    setType' v = case popVariantFHead v of
        Right u -> setType' u
        Left  w -> setType' w
     
  setType :: 
    ( SetType (VariantF xs) xs
    , Functor (VariantF xs)
    , TTypeF :<: xs
    ) => EADT xs -> EADT xs
  setType = cata setType'


  instance (EmptyNoteF :<: xs) => SetType HErrorF xs where
    setType' _ = EmptyNote

  instance (EmptyNoteF :<: xs) => SetType EmptyNoteF xs where
    setType' _ = EmptyNote

  instance (TTypeF :<: xs, EmptyNoteF :<: xs) => SetType TTypeF xs where
    setType' (TTypeF _ α) = α -- erase existing type


        
        
  -- eval
  --------------------------------------------------------

  instance Eval (EmptyNoteF e) where
    eval EmptyNoteF = RError "Can't evaluate annotations"

  instance Eval (TTypeF e) where
    eval (TTypeF _ _) = RError "Can't evaluate annotations"