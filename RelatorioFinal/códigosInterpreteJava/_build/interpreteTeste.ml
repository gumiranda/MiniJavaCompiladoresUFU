open Printf
open Lexing

open Ast
exception Erro_Sintatico of string

module S = MenhirLib.General (* Streams *)
module I = Parser.MenhirInterpreter

open Semantico

let message =
  fun s ->
    match s with
    | 1 ->
        "Erro Sintático - erro após class, nome da classe esperado \n"
    | 2 ->
        "Erro Sintático  - erro após identificador da classe, abre chave esperado \n"
    | 3 ->
        "Erro Sintático - erro após abre chave da classe \n"
    | 10 ->
        "Erro Sintático - erro após declaração de tipo da variavel \n"
    | 11 ->
        "Erro Sintático - ponto e virgula ou virgula esperado \n"
    | 12 ->
        "Erro Sintático - erro após a virgula \n"
    | 8 ->
        "Erro Sintático - erro na declaração de variavel \n"
    | 17 ->
        "Erro Sintático - erro no inicio da classe, espera-se declaracao de metodos após variaveis \n"
    | 18 ->
        "Erro Sintático - erro após static, tipo esperado \n"
    | 19 ->
        "Erro Sintático - erro após identificador, tipo esperado \n"
    | 20 ->
        "Erro Sintático - erro após identificador, abre parenteses esperado \n"
    | 21 ->
        "Erro Sintático - parametros válidos esperados \n"
    | 22 ->
        "Erro Sintático - identificador esperado após o tipo \n"
    | 25 ->
        "Erro Sintático - fecha parenteses ou virgula esperado no parametro \n"
    | 26 ->
        "Erro Sintático - erro nos parametros, após a virgula \n"
    | 29 ->
        "Erro Sintático -erro após fecha parenteses do metodo \n"
    | 32 ->
        "Erro Sintático - erro depois do while e antes do parenteses \n"
    | 33 ->
        "Erro Sintático - erro na expressão do while  \n"
    | 77 ->
        "Erro Sintático - erro na expressão do while  \n"
    | 78 ->
        "Erro Sintático - erro antes abre chave do while  \n"
    | 79 ->
        "Erro Sintático - erro após abre chave do while  \n"
    | 30 ->
        "Erro Sintático - erro após abre chave do método \n"
    | 31 ->
        "Erro Sintático - erro no método entre os comandos e as declarações de variaveis  \n"
    | 80 ->
        "Erro Sintático - expressão esperada no return \n"
    | 116 ->
        "Erro Sintático - erro apos comando \n"
    | 83 ->
        "Erro Sintático - operador aritmético esperado após a expressão   \n"
    | 34 ->
        "Erro Sintático - booleano esperado após o not \n"
    | 105 ->
        "Erro Sintático - operador aritmético esperado após a expressão  \n"
    | 75 ->
        "Erro Sintático - erro na expressão do comando de leitura \n"
    | 74 ->
        "Erro Sintático - operador aritmético esperado após a expressão   \n"
    | 94 ->
        "Erro Sintático - erro no comando de leitura, = esperado \n"
    | 45 ->
        "Erro Sintático - expressao esperada após o operador SUB \n"
    | 46 ->
        "Erro Sintático - operador aritmético esperado após a expressão  \n"
    | 52 ->
        "Erro Sintático - expressao esperada após o operador SOMA \n"
    | 53 ->
        "Erro Sintático - operador aritmético esperado após a expressão\n"
    | 54 ->
        "Erro Sintático - expressao esperada após o operador OU \n"
    | 55 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 47 ->
        "Erro Sintático - expressao esperada após o operador MULT \n"
    | 56 ->
        "Erro Sintático - expressao esperada após o operador MENORIGUAL \n"
    | 57 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 58 ->
        "Erro Sintático - expressao esperada após o operador MENOR \n"
    | 59 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 60 ->
        "Erro Sintático - expressao esperada após o operador MAIORIGUAL \n"
    | 61 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 62 ->
        "Erro Sintático - expressao esperada após o operador MAIOR \n"
    | 63 ->
        "Erro Sintático - operador aritmético esperado após a expressão  \n"
    | 95 ->
        "Erro Sintático - erro após comando de leitura s.next, abre parênteses esperado \n"
    | 96 ->
        "Erro Sintático - erro após comando de leitura s.next,fecha parenteses esperado \n"
    | 97 ->
        "Erro Sintático - ponto e virgula esperado\n"
    | 64 ->
        "Erro Sintático - expressao esperada após o operador IGUAL \n"
    | 65 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 66 ->
        "Erro Sintático - expressao esperada após o operador E \n"
    | 67 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 50 ->
        "Erro Sintático - expressão esperada apos divisão \n"
    | 68 ->
        "Erro Sintático - expressão esperada \n"
    | 69 ->
        "Erro Sintático - operador aritmético esperado após a expressão \n"
    | 106 ->
        "Erro Sintático -erro depois de atribuir expressão \n"
    | 107 ->
        "Erro Sintático - erro na expressão depois de atribuida \n"
    | 84 ->
        "Erro Sintático - abre parênteses esperado após o if \n"
    | 85 ->
        "Erro Sintático - expressão esperada após abre parenteses do if\n"
    | 86 ->
        "Erro Sintático - erro na expressão do if, fecha parenteses esperado \n"
    | 87 ->
        "Erro Sintático - erro após fechar parênteses da expressão do if. Abre chave esperado \n"
    | 88 ->
        "Erro Sintático - erro após abre chave do if \n"
    | 100 ->
        "Erro Sintático - erro após fechar chave do if \n"
    | 101 ->
        "Erro Sintático - erro entre o else e o abre chave\n"
    | 102 ->
        "Erro Sintático - erro após abre chave do else\n"
    | 40 ->
        "Erro Sintático -erro após identificador \n"
    | 41 ->
        "Erro Sintático - erro dentro da expressão entre parênteses \n"
    | 72 ->
        "Erro Sintático - fecha parenteses esperado \n"
    | 118 ->
        "Erro Sintático - erro na chamada de função \n"
    | 143 ->
        "Erro Sintático - erro no método \n"
    | 89 ->
        "Erro Sintático - erro antes abre parenteses do println \n"
    | 90 ->
        "Erro Sintático - erro após abre parenteses do println \n"
    | 91 ->
        "Erro Sintático - fecha parênteses  esperado após o println  \n"
    | 92 ->
        "Erro Sintático - ponto e vírgula esperado após o println \n"
    | 42 ->
        "Erro Sintático - erro na expressão entre parênteses \n"
    | 44 ->
        "Erro Sintático - erro entre a expressão e o operador \n"
    | 127 ->
        "Erro Sintático -static esperado no método main após public \n"
    | 128 ->
        "Erro Sintático -void esperado no método main \n"
    | 129 ->
        "Erro Sintático - main esperado no método main\n"
    | 130 ->
        "Erro Sintático - abre parenteses esperado no método main \n"
    | 131 ->
        "Erro Sintático - palavra String esperada \n"
    | 132 ->
        "Erro Sintático - abre colchete esperado no método main\n"
    | 133 ->
        "Erro Sintático - fecha colchete esperado no método main\n"
    | 134 ->
        "identificador esperado no método main"
    | 135 ->
        "fecha parenteses esperado no método main"
    | 136 ->
        "Erro Sintático - abre chave esperado \n"
    | 137 ->
        "comando esperado"
    | 140 ->
        "Erro no fim do corpo da classe\n"
    | 141 ->
        "Erro depois da classe\n"
    | _ ->
        raise Not_found
let posicao lexbuf =
    let pos = lexbuf.lex_curr_p in
    let lin = pos.pos_lnum
    and col = pos.pos_cnum - pos.pos_bol - 1 in
    sprintf "linha %d, coluna %d" lin col

(* [pilha checkpoint] extrai a pilha do autômato LR(1) contida em checkpoint *)

let pilha checkpoint =
  match checkpoint with
  | I.HandlingError amb -> I.stack amb
  | _ -> assert false (* Isso não pode acontecer *)

let estado checkpoint : int =
  match Lazy.force (pilha checkpoint) with
  | S.Nil -> (* O parser está no estado inicial *)
     0
  | S.Cons (I.Element (s, _, _, _), _) ->
     I.number s

let sucesso v = Some v

let falha lexbuf (checkpoint : (Sast.expressao Ast.prog) I.checkpoint) =
  let estado_atual = estado checkpoint in
  let msg = message estado_atual in
  raise (Erro_Sintatico (Printf.sprintf "%d - %s.\n"
                                      (Lexing.lexeme_start lexbuf) msg))

let loop lexbuf resultado =
  let fornecedor = I.lexer_lexbuf_to_supplier Lexer.token lexbuf in
  I.loop_handle sucesso (falha lexbuf) fornecedor resultado


let parse_com_erro lexbuf =
  try
    Some (loop lexbuf (Parser.Incremental.prog lexbuf.lex_curr_p))
  with
  | Lexer.Erro msg ->
     printf "Erro lexico na %s:\n\t%s\n" (posicao lexbuf) msg;
     None
  | Erro_Sintatico msg ->
     printf "Erro sintático na %s %s\n" (posicao lexbuf) msg;
     None

let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = parse_com_erro lexbuf in
  ast

let parse_arq nome =
  let ic = open_in nome in
  let lexbuf = Lexing.from_channel ic in
  let ast = parse_com_erro lexbuf in
  let _ = close_in ic in
  ast

let verifica_tipos nome =
  let ast = parse_arq nome in
  match ast with
    Some (Some ast) -> semantico ast
  | _ -> failwith "Nada a fazer!\n"

let interprete nome =
  let tast,amb = verifica_tipos nome in
  Interprete.interprete tast
