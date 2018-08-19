(* The type of the abstract syntax tree (AST). *)
open Lexing

type identificador = string
type 'a pos =  'a * Lexing.position (* tipo e posição no arquivo fonte *)

type 'expr prog = Class of declaracoes * ('expr funcoes) * ('expr comandos)
and declaracoes = var_decl list
and 'expr funcoes = ('expr metodo) list
and 'expr comandos = ('expr comando) list

and var_decl = Var of (identificador pos) * tipo

and 'expr metodo = DecFun of ('expr decfn)

and 'expr decfn = {
  fn_nome:    identificador pos;
  fn_tiporet: tipo;
  fn_formais: (identificador pos * tipo) list;
  fn_locais:  declaracoes;
  fn_corpo:   'expr comandos
}
                                     
and tipo = TipoInteiro
	 | TipoDouble
         | TipoString
         | TipoBoolean
	 | TipoVoid

and 'expr comando =
	    | CmdAtrib of 'expr * 'expr
            | CmdSe of 'expr * ('expr comandos) * ('expr comandos option)
            | CmdLeia of ('expr expressoes)
            | CmdEscreva of ('expr expressoes)
	    | CmdEnquanto of 'expr * ('expr comandos)
  	    | CmdRetorno of 'expr option
  	    | CmdChamada of 'expr


and 'expr variaveis = ('expr variavel) list
and 'expr variavel = VarSimples of identificador pos

and 'expr expressoes = 'expr list             

and op = Soma
         | Sub
         | Mult
         | Divisao
         | Menor
	 | MenorIgual
         | Igual
         | Difer
         | Maior
	 | MaiorIgual
         | AND
         | Ou
