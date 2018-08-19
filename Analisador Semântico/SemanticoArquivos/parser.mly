
%{
  open Lexing
  open Ast
  open Sast
%}

%token <int * Lexing.position> INT
%token <float * Lexing.position> FLOAT
%token <string * Lexing.position> ID
%token <string * Lexing.position> LITSTRING
%token <char * Lexing.position> LITCHAR  
%token <Lexing.position> CLASS
%token <Lexing.position> SOMA SUB MULT DIVISAO MOD
%token <Lexing.position> POTENCIA
%token <Lexing.position> APAR
%token <Lexing.position> ACHAVE
%token <Lexing.position> FCHAVE
%token <Lexing.position> FPAR
%token <Lexing.position> ACOL
%token <Lexing.position> FCOL
%token <Lexing.position> IGUAL
%token <Lexing.position> DIFERENTE
%token <Lexing.position> MAIOR
%token <Lexing.position> MAIORIGUAL
%token <Lexing.position> MENOR
%token <Lexing.position> MENORIGUAL
%token <Lexing.position> E OU 
%token <Lexing.position> ATRIB
%token <Lexing.position> PONTOEVIRGULA
%token <Lexing.position> PUBLIC
%token <Lexing.position> STATIC
%token <Lexing.position> MAIN
%token <Lexing.position> INTEIRO
%token <Lexing.position> LOGICO
%token <Lexing.position> DOUBLE
%token <Lexing.position> ATE 
%token <Lexing.position> CARACTER
%token <Lexing.position> CASO
%token <Lexing.position> DE
%token <Lexing.position> VIRGULA
%token <Lexing.position> SE
%token <Lexing.position> SENAO
%token <Lexing.position> ENQUANTO
%token <Lexing.position> ESCREVA
%token <Lexing.position> ESCREVAL
%token <Lexing.position> LEIA
%token <Lexing.position> PARA 
%token <Lexing.position> PASSO 
%token <Lexing.position> RETORNE
%token <Lexing.position> VERDADEIRO
%token <Lexing.position> VOID
%token <Lexing.position> FALSO
%token EOF


%left OU 
%left E
%left IGUAL DIFERENTE
%left MAIOR MAIORIGUAL MENOR MENORIGUAL
%left SOMA SUB
%left MULT DIVISAO MOD
%right POTENCIA

/*%nonassoc NAO*/


%start <Sast.expressao Ast.prog> prog

%%
   
prog:
    | da=declaracao_algoritmo  vdb=var_decl* fd=func_decl* comandob=comando_block  EOF { Prog (List.flatten vdb,fd,comandob) }
    ;

declaracao_algoritmo:
    | PUBLIC CLASS ID ACHAVE { DeclAlg }
    ;

var_decl:
    | t=tp_primitivo ids = separated_nonempty_list(VIRGULA, ID)  PONTOEVIRGULA {  List.map (fun id -> DecVar(id,t)) ids }
    ;


tp_primitivo:
    | INTEIRO { TipoInteiro }
    | DOUBLE { TipoDouble }
    | CARACTER { TipoCaractere }
    | LOGICO { TipoBooleano }
    | VOID { TipoVoid }
    ;

comando_block:
    | PUBLIC STATIC VOID MAIN APAR CARACTER ACOL FCOL ID FPAR ACHAVE comandos=comando_list* FCHAVE{ (comandos)}
    ;

comando_list:
    | comando=comando_attr {comando}
    | comando=comando_fcall {comando}
    | comando=comando_ret {comando}
    | comando=comando_se {comando}
    | comando=comando_enquanto {comando}
    | comando=comando_para {comando}
    | comando=comando_leia {comando}
    | comando=comando_escreva {comando}
    | comando=comando_escreval {comando}
    ;

comando_fcall:
    | exp=fcall PONTOEVIRGULA {Chamada exp}
    ;

comando_ret:
    | RETORNE expr=expr? PONTOEVIRGULA { Retorne(expr)}
    ;

lvalue: 
    | id=ID { Var(id) }
    | lv=lvalue ACOL e=expr FCOL {VarElement(lv,e)}
    ;



comando_se:
    | SE APAR e=expr FPAR ACHAVE comandos=comando_list* senao=comando_senao? FCHAVE { Se(e,comandos,senao)}
    ;

comando_senao:
    | SENAO comando=comando_list* { comando }
    ;

comando_enquanto:
    | ENQUANTO APAR e=expr FPAR ACHAVE comando=comando_list* FCHAVE { Enquanto (e,comando) }
    ;

comando_para:
    | PARA APAR lv=expr DE e1=expr ATE e2=expr p=passo FPAR ACHAVE comando=comando_list* FCHAVE {For (lv,e1,e2,p,comando) }
    ;

comando_attr:
    | v=expr ATRIB e=expr PONTOEVIRGULA { Attrib(v,e) }
    ;

comando_leia:
    | v=expr ATRIB LEIA APAR FPAR PONTOEVIRGULA { Attrib(v,v) }
    ;

comando_escreva:
    | ESCREVA APAR comando=separated_nonempty_list(VIRGULA, expr) FPAR PONTOEVIRGULA {Escreva comando}
    ;

comando_escreval:
    | ESCREVAL APAR comando=separated_nonempty_list(VIRGULA, expr) FPAR PONTOEVIRGULA {Escreval comando }
    ;


expr:  
   | e1=expr o=op e2=expr { ExpOp(o,e1,e2) }
   | f=fcall { f }
   | s=LITSTRING { ExpString s}
   | i=INT { ExpInt i}
   | f=FLOAT { ExpFloat f}
   | c=LITCHAR { ExpChar c}
   | l=logico_value { ExpBool l}
   | lv=lvalue { ExpVar lv } 
   /*| pos=NAO e=expr { ExpNot (e, pos)}*/
   | APAR e=expr FPAR { e }
   ;

%inline op:
  | pos = SOMA { (Soma, pos) }
  | pos = SUB  { (Subtracao, pos) }
  | pos = MULT { (Multiplicacao, pos) }
  | pos = DIVISAO { (Divisao, pos) }
  | pos = POTENCIA { (Potencia, pos) }
  | pos = MOD { (Modulo, pos) }
  | pos = IGUAL { (Igual, pos) }
  | pos = DIFERENTE { (Diferente, pos) }
  | pos = MENOR { (Menor, pos) }
  | pos = MENORIGUAL { (MenorIgual, pos) }
  | pos = MAIOR { (Maior, pos) }
  | pos = MAIORIGUAL { (MaiorIgual, pos) }
  | pos = E { (ELogico, pos) }
  | pos = OU { (OuLogico, pos) }

  ;


logico_value:
  | pos=VERDADEIRO { (true,pos) }
  | pos=FALSO  { (false,pos) }
  ;

fcall:
    | id=ID APAR args=fargs? FPAR { ExpMetodoCall(id,(match args with
                                                  | None -> []
                                                  | Some fargs -> fargs )) }
    ;

fargs:
    | exprs=separated_nonempty_list(VIRGULA, expr) {  List.map (fun expr -> expr) exprs}
    ;

/*Declaração de funções*/
func_decl:
    | STATIC fy=func_type id=ID APAR fp=fparams? FPAR   fb=func_bloc  fv=var_decl* FCHAVE { MetodocDecl {
                                                                                             fn_id = id; 
                                                                                             fn_params = (match fp with
                                                                                                  | None -> []
                                                                                                  | Some args -> args); 
                                                                                             fn_tiporet = fy;
                                                                                             fn_locais = List.flatten fv;
                                                                                             fn_corpo = fb }
                                                                                           }
	  ;

func_type:
    |  t=tp_primitivo { (t) }
    ;
/* */

func_bloc:
    | ACHAVE comando=comando_list*  {(comando)}
    ;


fparams:
    | fparam=separated_nonempty_list(VIRGULA,fparam){ fparam }
    ;

fparam:
    |   t=tp_primitivo id=ID {(id,t)}
    ;
