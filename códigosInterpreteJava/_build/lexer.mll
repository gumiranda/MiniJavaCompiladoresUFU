{
  open Lexing
  open Printf
  open Parser

  exception Erro of string

  let incr_num_linha lexbuf = 
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_lnum = pos.pos_lnum + 1;
                 pos_bol = pos.pos_cnum
      }

    let pos_atual lexbuf = lexbuf.lex_start_p

}

let digito = ['0' - '9']
let inteiro = digito+
let double = digito+'.'digito+
let boolean = ("true"|"false")

let letra = ['a' - 'z' 'A' - 'Z']
let identificador = letra ( letra | digito | '_')*

let brancos = [' ' '\t']+
let novalinha = '\r' | '\n' | "\r\n"

let comentario = "--" [^ '\r' '\n' ]*

rule token = parse
  brancos    { token lexbuf }
| novalinha  { incr_num_linha lexbuf; token lexbuf }
| comentario { token lexbuf }
| "/*"       { comentario_bloco 0 lexbuf }
| '('        { APAR (pos_atual lexbuf) }
| '{'        { ACHAVE (pos_atual lexbuf) }
| '}'        { FCHAVE (pos_atual lexbuf) }
| ','	     { VIRGULA (pos_atual lexbuf) }
| ';'        { PONTOEVIRGULA (pos_atual lexbuf) }
| "="	     { ATRIB (pos_atual lexbuf) }
| '+'        { SOMA (pos_atual lexbuf) }
| '-'	     { SUB (pos_atual lexbuf) }
| '*'	     { MULT (pos_atual lexbuf) }
| '['	     { ACOL (pos_atual lexbuf) }
| ']'	     { FCOL (pos_atual lexbuf) }
| '/'	     { DIVISAO (pos_atual lexbuf) }
| ')'        { FPAR (pos_atual lexbuf) }
| '!'        { NOT (pos_atual lexbuf) }
| '>'	     { MAIOR (pos_atual lexbuf) }
| '<'	     { MENOR (pos_atual lexbuf) }
| "=="     { IGUAL (pos_atual lexbuf) }
| "static"  { STATIC (pos_atual lexbuf) }
| "main"  { MAIN (pos_atual lexbuf) }
| ">="	     { MAIORIGUAL (pos_atual lexbuf) }
| "<="	     { MENORIGUAL (pos_atual lexbuf) }
| "!="	     { DIFERENTE (pos_atual lexbuf) }
|"void" { VOID (pos_atual lexbuf) }
| "int"  { INT (pos_atual lexbuf) }
| inteiro as num { let numero = int_of_string num in 
                    LITINT (numero, pos_atual lexbuf)  } 
| "double"     { DOUBLE (pos_atual lexbuf) }
| double as num { let numero = float_of_string num in
		  LITDOUBLE (numero, pos_atual lexbuf) }
| "String" { STRING (pos_atual lexbuf) }
| "boolean"   { BOOLEAN (pos_atual lexbuf) }
| boolean as l { let booleano = bool_of_string l in
		  LITBOOLEAN (booleano, pos_atual lexbuf) }
| "class" { CLASS (pos_atual lexbuf) }
| "public"	     { PUBLIC (pos_atual lexbuf) }
| "System.out.println" { ESCREVA (pos_atual lexbuf) }
| "= s.next"     { LEIA (pos_atual lexbuf) }
| "if"       { IF (pos_atual lexbuf) }
| "&&"	     { E (pos_atual lexbuf) }
| "||"	     { OU (pos_atual lexbuf) }
| "else"    { ELSE (pos_atual lexbuf) }
| "while"    { WHILE (pos_atual lexbuf) }
| "return"   { RETURN (pos_atual lexbuf) }
| identificador as id { ID (id, pos_atual lexbuf) }
| '"'   { let buffer = Buffer.create 1 in
            let str = leia_string buffer lexbuf in
               LITSTRING (str, pos_atual lexbuf) }
| _ { raise (Erro ("Caracter desconhecido: " ^ Lexing.lexeme lexbuf)) }
| eof        { EOF }

and comentario_bloco n = parse
   "*/"      { if n=0 then token lexbuf 
               else comentario_bloco (n-1) lexbuf }
| "/*"       { comentario_bloco (n+1) lexbuf }
| novalinha  { incr_num_linha lexbuf; comentario_bloco n lexbuf }
| _          { comentario_bloco n lexbuf }
| eof        { raise (Erro "Comentário não terminado") }

and leia_string buffer = parse
   '"'      { Buffer.contents buffer}
| "\\t"     { Buffer.add_char buffer '\t'; leia_string buffer lexbuf }
| "\\n"     { Buffer.add_char buffer '\n'; leia_string buffer lexbuf }
| '\\' '"'  { Buffer.add_char buffer '"'; leia_string buffer lexbuf }
| '\\' '\\' { Buffer.add_char buffer '\\'; leia_string buffer lexbuf }
| _ as c    { Buffer.add_char buffer c; leia_string buffer lexbuf }
| eof       { raise (Erro "A string não foi terminada") }



