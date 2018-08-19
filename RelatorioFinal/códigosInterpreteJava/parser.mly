
%{
open Lexing
open Ast
open Sast
%}

%token <int * Lexing.position> LITINT
%token <Lexing.position> INT
%token <float * Lexing.position> LITDOUBLE
%token <Lexing.position> DOUBLE
%token <string * Lexing.position> ID
%token <string * Lexing.position> LITSTRING
%token <Lexing.position> STRING
%token <bool * Lexing.position> LITBOOLEAN
%token <Lexing.position> BOOLEAN
%token <Lexing.position> CLASS
%token <Lexing.position> STATIC
%token <Lexing.position> MAIN NOT
%token <Lexing.position> PUBLIC
%token <Lexing.position> VIRGULA  PONTOEVIRGULA
%token <Lexing.position> APAR FPAR
%token <Lexing.position> IF  ELSE
%token <Lexing.position> WHILE 
%token <Lexing.position> ESCREVA
%token <Lexing.position> LEIA
%token <Lexing.position> FCHAVE
%token <Lexing.position> ACHAVE
%token <Lexing.position> ATRIB
%token <Lexing.position> SOMA
%token <Lexing.position> SUB
%token <Lexing.position> MULT
%token <Lexing.position> DIVISAO
%token <Lexing.position> MENOR
%token <Lexing.position> MENORIGUAL
%token <Lexing.position> IGUAL
%token <Lexing.position> DIFERENTE
%token <Lexing.position> MAIOR
%token <Lexing.position> MAIORIGUAL
%token <Lexing.position> E
%token <Lexing.position> OU
%token <Lexing.position> RETURN
%token <Lexing.position> ACOL FCOL VOID

%token EOF

%left OU
%left E
%left IGUAL DIFERENTE
%left MAIOR MENOR MAIORIGUAL MENORIGUAL
%left SOMA SUB
%left MULT DIVISAO


%start <Sast.expressao Ast.prog> prog

%%

prog: 
	   CLASS ID ACHAVE
            ds = var_decl*
            fs = declaracao_metodo*
            cs = comando_block
          FCHAVE
          EOF { Class (List.flatten ds, fs, cs) }


var_decl :t=tipo ids = separated_nonempty_list(VIRGULA, ID) PONTOEVIRGULA{
                   List.map (fun id -> Var (id,t)) ids
          };

          comando_block :|PUBLIC STATIC VOID  MAIN APAR STRING ACOL FCOL ID FPAR ACHAVE comandos=comando* FCHAVE {comandos};


declaracao_metodo:   STATIC tret = tipo  nome = ID APAR formais = separated_list(VIRGULA, parametro) FPAR 
		   ACHAVE
  			ds = var_decl*
  			cs = comando*
  		FCHAVE {
    			DecFun {
      				fn_nome = nome;
      				fn_tiporet = tret ;
      				fn_formais = formais;
      				fn_locais = List.flatten ds;
      				fn_corpo = cs
    			}
 		}

parametro: t = tipo nome = ID  { (nome, t) }


tipo: t=tipo_simples  { t }

tipo_simples: INT       { TipoInteiro   }
	    | DOUBLE      { TipoDouble }
            | STRING { TipoString }
            | BOOLEAN    { TipoBoolean }

comando: c=comando_atribuicao { c }
       | c=comando_se         { c }
       | c=comando_leia       { c }
       | c=comando_escreva    { c }
       | c=comando_enquanto   { c }
       | c=comando_chamada    { c }
       | c=comando_retorno    { c }


comando_atribuicao: v=expressao ATRIB e=expressao PONTOEVIRGULA {
      CmdAtrib (v,e)
}

comando_se: IF APAR teste=expressao FPAR ACHAVE
               entao=comando*  FCHAVE
               senao=comando_senao?
            { CmdSe (teste, entao, senao) };

comando_senao:
|ELSE ACHAVE comandos=comando* FCHAVE {comandos}

comando_leia: xs=separated_nonempty_list(VIRGULA, expressao)  LEIA APAR   FPAR PONTOEVIRGULA {
                   CmdLeia xs
               }

comando_escreva: ESCREVA APAR xs=separated_nonempty_list(VIRGULA, expressao) FPAR PONTOEVIRGULA {
                 CmdEscreva xs
             }

comando_enquanto: WHILE APAR teste=expressao FPAR ACHAVE
			comandos=comando*
		  FCHAVE { CmdEnquanto (teste,comandos) }


comando_chamada: exp=chamada PONTOEVIRGULA { CmdChamada exp }

comando_retorno: RETURN e=expressao? PONTOEVIRGULA { CmdRetorno e}


expressao:
         | v=variavel     { ExpVar v    }
         | i=LITINT       { ExpInt i    }
	 | f=LITDOUBLE      { ExpDouble f   }
         | s=LITSTRING { ExpString s }
         | b=LITBOOLEAN    { ExpBoolean b }
         | NOT e=LITBOOLEAN {ExpNot e}
	 | e1=expressao op=op e2=expressao { ExpOp (op, e1, e2) }
         | c=chamada      { c }
 	 | APAR e=expressao FPAR { e }

chamada : nome=ID APAR args=separated_list(VIRGULA, expressao) FPAR {
             ExpChamada  (nome, args)}

%inline op:
	| pos = SOMA       { (Soma, pos)       }
        | pos = SUB      { (Sub, pos)      }
        | pos = MULT       { (Mult, pos)       }
        | pos = DIVISAO        { (Divisao, pos)        }
        | pos = MENOR      { (Menor, pos)      }
	| pos = MENORIGUAL { (MenorIgual, pos) }
        | pos = IGUAL      { (Igual, pos)      }
        | pos = DIFERENTE      { (Difer, pos)      }
        | pos = MAIOR      { (Maior, pos)      }
	| pos = MAIORIGUAL { (MaiorIgual, pos) }
        | pos = E          { (AND, pos)        }
        | pos = OU         { (Ou, pos)         }


variavel: x=ID       { VarSimples x }
