open Ast

type expressao =
  | ExpVar of (expressao variavel)
  | ExpInt of int pos
  | ExpDouble of float pos
  | ExpString of string pos
  | ExpBoolean of bool pos
  | ExpNot of bool pos
  | ExpOp of op pos * expressao * expressao
  | ExpChamada of identificador pos * (expressao expressoes)
