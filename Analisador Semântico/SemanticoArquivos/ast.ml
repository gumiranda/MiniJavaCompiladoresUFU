open Lexing

type identificador = string
type 'a pos =  'a * Lexing.position (* tipo e posição no arquivo fonte *)

type 'expr prog = Prog of var_decl * ('expr func_decl_list) * ('expr statements)
and declaracao_algoritmo = DeclAlg
and var_decl = vars list
and vars = DecVar of (identificador pos) * tipo
and 'expr func_decl_list = ('expr func_decl) list
and 'expr func_decl = MetodocDecl of ('expr decfun)
and fparams = fparam list
and fparam =  identificador * tipo
and functype = tipo
and 'expr funcbloc = ('expr comando_list) list
and 'expr statements = ('expr comando_list) list

and 'expr decfun = {
	fn_id: identificador pos;
	fn_params: (identificador pos * tipo) list;
	fn_tiporet: functype;
	fn_locais: var_decl;
	fn_corpo: 'expr funcbloc;

}

and tipo = TipoInteiro
		  |TipoDouble
		  |TipoBooleano
		  |TipoVoid
		  |TipoCaractere

and 'expr comando_list  = Attrib of 'expr * 'expr
		  	   |Chamada of 'expr
		  	   |Retorne of 'expr option
		  	   |Se of 'expr * 'expr comando_list list * ('expr senao) option
		  	   |For of ('expr) * 'expr * 'expr * ('expr )  * 'expr statements 
		  	   |Escreva of 'expr list
		  	   |Escreval of 'expr list
		  	   |Enquanto of 'expr * 'expr comando_list list


and 'expr senao = 'expr comando_list list

and 'expr case = CaseInt of int pos * 'expr comando_list list
		  |CaseChar of char pos * 'expr comando_list list

and 'expr lvalue = Var of identificador pos
			|VarElement of ('expr lvalue) * 'expr

and op = Soma
		|Subtracao
		|Multiplicacao
		|Divisao
		|Potencia
		|Modulo
		|Igual
		|Diferente
		|Menor
		|MenorIgual
		|Maior
		|MaiorIgual
		|ELogico
		|OuLogico


(*let arguments:
  match args with
    None -> []
    Some xs -> xs*)
and 'expr fargs = 'expr list

and logico_value = Verdadeiro of bool
				  |Falso of bool
			
