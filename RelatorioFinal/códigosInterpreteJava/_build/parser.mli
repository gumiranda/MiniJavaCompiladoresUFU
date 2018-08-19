
(* The type of tokens. *)

type token = 
  | WHILE of (Lexing.position)
  | VOID of (Lexing.position)
  | VIRGULA of (Lexing.position)
  | SUB of (Lexing.position)
  | STRING of (Lexing.position)
  | STATIC of (Lexing.position)
  | SOMA of (Lexing.position)
  | RETURN of (Lexing.position)
  | PUBLIC of (Lexing.position)
  | PONTOEVIRGULA of (Lexing.position)
  | OU of (Lexing.position)
  | NOT of (Lexing.position)
  | MULT of (Lexing.position)
  | MENORIGUAL of (Lexing.position)
  | MENOR of (Lexing.position)
  | MAIORIGUAL of (Lexing.position)
  | MAIOR of (Lexing.position)
  | MAIN of (Lexing.position)
  | LITSTRING of (string * Lexing.position)
  | LITINT of (int * Lexing.position)
  | LITDOUBLE of (float * Lexing.position)
  | LITBOOLEAN of (bool * Lexing.position)
  | LEIA of (Lexing.position)
  | INT of (Lexing.position)
  | IGUAL of (Lexing.position)
  | IF of (Lexing.position)
  | ID of (string * Lexing.position)
  | FPAR of (Lexing.position)
  | FCOL of (Lexing.position)
  | FCHAVE of (Lexing.position)
  | ESCREVA of (Lexing.position)
  | EOF
  | ELSE of (Lexing.position)
  | E of (Lexing.position)
  | DOUBLE of (Lexing.position)
  | DIVISAO of (Lexing.position)
  | DIFERENTE of (Lexing.position)
  | CLASS of (Lexing.position)
  | BOOLEAN of (Lexing.position)
  | ATRIB of (Lexing.position)
  | APAR of (Lexing.position)
  | ACOL of (Lexing.position)
  | ACHAVE of (Lexing.position)

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Sast.expressao Ast.prog)

module MenhirInterpreter : sig
  
  (* The incremental API. *)
  
  include MenhirLib.IncrementalEngine.INCREMENTAL_ENGINE
    with type token = token
  
end

(* The entry point(s) to the incremental API. *)

module Incremental : sig
  
  val prog: Lexing.position -> (Sast.expressao Ast.prog) MenhirInterpreter.checkpoint
  
end
