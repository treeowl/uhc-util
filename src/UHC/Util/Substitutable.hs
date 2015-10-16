{-# LANGUAGE MultiParamTypeClasses, FunctionalDependencies #-}

module UHC.Util.Substitutable
  (
    VarUpdatable(..)
  , VarExtractable(..)
  
  , VarUpdKey
  , VarUpdVal
  )
  where

import qualified Data.Set as Set
import           UHC.Util.VarMp

-------------------------------------------------------------------------------------------
--- Substitutable classes
-------------------------------------------------------------------------------------------

infixr 6 `varUpd`
infixr 6 `varUpdCyc`

type family VarUpdKey subst :: *
type family VarUpdVal subst :: *

class VarUpdatable vv subst where -- skey sval | subst -> skey sval where
  -- type VarUpdKey subst :: *
  -- type VarUpdVal subst :: *
  varUpd            ::  subst -> vv -> vv
  varUpdCyc         ::  subst -> vv -> (vv, VarMp' (VarUpdKey subst) (VarUpdVal subst))
  s `varUpdCyc` x = (s `varUpd` x,emptyVarMp)

class Ord k => VarExtractable vv k | vv -> k where
  varFree           ::  vv -> [k]
  varFreeSet        ::  vv -> Set.Set k
  
  -- default
  varFree           =   Set.toList . varFreeSet
  varFreeSet        =   Set.fromList . varFree

