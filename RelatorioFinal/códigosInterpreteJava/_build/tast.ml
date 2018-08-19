open Ast

type expressao = ExpVar of (expressao variavel) * tipo
              | ExpInt of int * tipo
	      | ExpDouble of float * tipo
              | ExpString of string * tipo
  	      | ExpVoid
              | ExpBoolean of bool * tipo
              | ExpNot of  bool * tipo
              | ExpOp of (op * tipo) * (expressao * tipo) * (expressao * tipo)
              | ExpChamada of identificador * (expressao expressoes) * tipo


