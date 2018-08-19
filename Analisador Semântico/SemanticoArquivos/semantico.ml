module Amb = Ambiente
module A = Ast
module S = Sast
module T = Tast


let rec posicao exp = let open S in
  match exp with
  | ExpVar v -> (match v with
      | A.Var (_,pos) -> pos
      | A.VarElement (_,exp2) -> posicao exp2
    )
  (*| ExpNot (_, pos) -> pos *)
  | ExpInt (_,pos) -> pos
  | ExpFloat (_,pos) -> pos
  | ExpChar (_,pos) -> pos
  | ExpString  (_,pos) -> pos
  | ExpBool (_,pos) -> pos
  | ExpOp ((_,pos),_,_)  -> pos
  | ExpMetodoCall ((_,pos), _) -> pos


type classe_op = Aritmetico | Relacional | Logico  

let classifica op =
  let open A in
  match op with
    OuLogico
  | ELogico
  | Menor
  | MenorIgual
  | Maior
  | MaiorIgual
  | Igual
  | Diferente -> Relacional
  | Soma
  | Subtracao
  | Multiplicacao
  | Divisao 
  | Potencia 
  | Modulo -> Aritmetico

let msg_erro_pos pos msg =
  let open Lexing in
  let lin = pos.pos_lnum
  and col = pos.pos_cnum - pos.pos_bol - 1 in
  Printf.sprintf "Semantico -> linha %d, coluna %d: %s" lin col msg

let msg_erro nome msg =
  let pos = snd nome in
  msg_erro_pos pos msg

let nome_tipo t =
  let open A in
    match t with
      TipoInteiro -> "inteiro"
    | TipoCaractere -> "string"
    | TipoBooleano -> "logico"
    | TipoDouble -> "double"
    | TipoVoid -> "vazio"


let mesmo_tipo pos msg tinf tdec =
  if tinf <> tdec
  then
    let msg = Printf.sprintf msg (nome_tipo tinf) (nome_tipo tdec) in
    failwith (msg_erro_pos pos msg)

let rec infere_exp amb exp =
  match exp with
    S.ExpInt n    -> (T.ExpInt (fst n, A.TipoInteiro),       A.TipoInteiro)
  | S.ExpString s -> (T.ExpString (fst s, A.TipoCaractere), A.TipoCaractere)
  | S.ExpBool b   -> (T.ExpBool (fst b, A.TipoBooleano),     A.TipoBooleano)
  | S.ExpFloat f  -> (T.ExpFloat (fst f, A.TipoDouble), A.TipoDouble)
  | S.ExpChar c   -> (T.ExpChar (fst c, A.TipoCaractere), A.TipoCaractere)
  | S.ExpVar v ->
    (match v with
       A.Var nome ->
       (* Tenta encontrar a definição da variável no escopo local, se não      *)
       (* encontar tenta novamente no escopo que engloba o atual. Prossegue-se *)
       (* assim até encontrar a definição em algum escopo englobante ou até    *)
       (* encontrar o escopo global. Se em algum lugar for encontrado,         *)
       (* devolve-se a definição. Em caso contrário, devolve uma exceção       *)
       let id = fst nome in
         (try (match (Amb.busca amb id) with
               | Amb.EntVar tipo -> (T.ExpVar (A.Var nome, tipo), tipo)
               | Amb.EntMetodo _ ->
                 let msg = "nome de funcao usado como nome de variavel: " ^ id in
                  failwith (msg_erro nome msg)
             )
          with Not_found ->
                 let msg = "A variavel " ^ id ^ " nao foi declarada" in
                 failwith (msg_erro nome msg)
         )
     | _ -> failwith "infere_exp: não implementado"
    )

  | S.ExpOp (op, esq, dir) ->
    let (esq, tesq) = infere_exp amb esq
    and (dir, tdir) = infere_exp amb dir in

    let verifica_aritmetico () =
      (match tesq with
         A.TipoInteiro 
        |A.TipoDouble ->
         let _ = mesmo_tipo (snd op)
                      "O operando esquerdo eh do tipo %s mas o direito eh do tipo %s"
                      tesq tdir
         in tesq (* O tipo da expressão aritmética como um todo *)

       | t -> let msg = "um operador aritmetico nao pode ser usado com o tipo " ^
                        (nome_tipo t)
         in failwith (msg_erro_pos (snd op) msg)
      )

    and verifica_relacional () =
      (match tesq with
         A.TipoInteiro
       | A.TipoDouble
       | A.TipoCaractere ->
         let _ = mesmo_tipo (snd op)
                   "O operando esquerdo eh do tipo %s mas o direito eh do tipo %s"
                   tesq tdir
         in A.TipoBooleano (* O tipo da expressão relacional é sempre booleano *)

       | t -> let msg = "um operador relacional nao pode ser usado com o tipo " ^
                        (nome_tipo t)
         in failwith (msg_erro_pos (snd op) msg)
      )

    and verifica_logico () =
      (match tesq with
         A.TipoBooleano ->
         let _ = mesmo_tipo (snd op)
                   "O operando esquerdo eh do tipo %s mas o direito eh do tipo %s"
                   tesq tdir
         in A.TipoBooleano (* O tipo da expressão lógica é sempre booleano *)

       | t -> let msg = "um operador logico nao pode ser usado com o tipo " ^
                        (nome_tipo t)
              in failwith (msg_erro_pos (snd op) msg)
      )
  (*  and verifica_cadeia () =
      (match tesq with
         A.TipoCaractere ->
         let _ = mesmo_tipo (snd op)
                   "O operando esquerdo eh do tipo %s mas o direito eh do tipo %s"
                   tesq tdir
         in A.TipoCaractere (* O tipo da expressão relacional é sempre string *)

       | t -> let msg = "um operador relacional nao pode ser usado com o tipo " ^
                        (nome_tipo t)
              in failwith (msg_erro_pos (snd op) msg)
      )
  *)
    in
    let op = fst op in
    let tinf = (match (classifica op) with
          Aritmetico -> verifica_aritmetico ()
        | Relacional -> verifica_relacional ()
        | Logico -> verifica_logico ()
      )
    in
      (T.ExpOp ((op,tinf), (esq, tesq), (dir, tdir)), tinf)

  | S.ExpMetodoCall (nome, args) ->
     let rec verifica_parametros ags ps fs =
        match (ags, ps, fs) with
         (a::ags), (p::ps), (f::fs) ->
            let _ = mesmo_tipo (posicao a)
                     "O parametro eh do tipo %s mas deveria ser do tipo %s" p f
            in verifica_parametros ags ps fs
       | [], [], [] -> ()
       | _ -> failwith (msg_erro nome "Numero incorreto de parametros")
     in
     let id = fst nome in
     try
       begin
         let open Amb in

         match (Amb.busca amb id) with
         (* verifica se 'nome' está associada a uma função *)
           Amb.EntMetodo {tipo_fn; formais} ->
           (* Infere o tipo de cada um dos argumentos *)
           let argst = List.map (infere_exp amb) args
           (* Obtem o tipo de cada parâmetro formal *)
           and tipos_formais = List.map snd formais in
           (* Verifica se o tipo de cada argumento confere com o tipo declarado *)
           (* do parâmetro formal correspondente.                               *)
           let _ = verifica_parametros args (List.map snd argst) tipos_formais
            in (T.ExpMetodoCall (id, (List.map fst argst), tipo_fn), tipo_fn)
         | Amb.EntVar _ -> (* Se estiver associada a uma variável, falhe *)
           let msg = id ^ " eh uma variavel e nao uma funcao" in
           failwith (msg_erro nome msg)
       end
     with Not_found ->
       let msg = "Nao existe a funcao de nome " ^ id in
       failwith (msg_erro nome msg)

let rec verifica_cmd amb tiporet cmd =
  let open A in
  match cmd with
    Retorne exp ->
    (match exp with
     (* Se a função não retornar nada, verifica se ela foi declarada como void *)
       None ->
       let _ = mesmo_tipo (Lexing.dummy_pos)
                   "O tipo retornado eh %s mas foi declarado como %s"
                   TipoVoid tiporet
       in Retorne None
     | Some e ->
       (* Verifica se o tipo inferido para a expressão de retorno confere com o *)
       (* tipo declarado para a função.                                         *)
           let (e1,tinf) = infere_exp amb e in
           let _ = mesmo_tipo (posicao e)
                              "O tipo retornado eh %s mas foi declarado como %s"
                              tinf tiporet
           in Retorne (Some e1)
      )
  | Se (teste, entao, senao) ->
    let (teste1,tinf) = infere_exp amb teste in
    (* O tipo inferido para a expressão 'teste' do condicional deve ser booleano *)
    let _ = mesmo_tipo (posicao teste)
             "O teste do if deveria ser do tipo %s e nao %s"
             TipoBooleano tinf in
    (* Verifica a validade de cada comando do bloco 'então' *)
    let entao1 = List.map (verifica_cmd amb tiporet) entao in
    (* Verifica a validade de cada comando do bloco 'senão', se houver *)
    let senao1 =
        match senao with
          None -> None
        | Some bloco -> Some (List.map (verifica_cmd amb tiporet) bloco)
     in
     Se (teste1, entao1, senao1)

  | Attrib (elem, exp) ->
    (* Infere o tipo da expressão no lado direito da atribuição *)
    let (exp,  tdir) = infere_exp amb exp
    (* Faz o mesmo para o lado esquerdo *)
    and (elem1, tesq) = infere_exp amb elem in
    (* Os dois tipos devem ser iguais *)
    let _ = mesmo_tipo (posicao elem)
                       "Atribuicao com tipos diferentes: %s = %s" tesq tdir
    in Attrib (elem1, exp)

  | Enquanto (teste, corpo) ->
    let (teste_tipo,tinf) = infere_exp amb teste in
    let _ = mesmo_tipo (posicao teste) 
                      "O teste do enquanto deveria ser do tipo %s e nao %s"
                        TipoBooleano tinf in
    let corpo_tipo = List.map (verifica_cmd amb tiporet) corpo in
    Enquanto (teste_tipo, corpo_tipo)
  
 
   


  | Chamada exp ->
    (* Verifica o tipo de cada argumento da função 'entrada' *)
    let (exp,tinf) = infere_exp amb exp in
    Chamada exp

  | Escreva exps ->
    (* Verifica o tipo de cada argumento da função 'saida' *)
    let exps = List.map (infere_exp amb) exps in
    Escreva (List.map fst exps)

  | Escreval exps ->
    (* Verifica o tipo de cada argumento da função 'saida' *)
    let exps = List.map (infere_exp amb) exps in
    Escreval (List.map fst exps)

(*and operador_do_for ini =
  let open A in
    let zero = ExpInt( 0 ) in
      if (ini >= zero) then MenorIgual
      else MaiorIgual *)
and verifica_fun amb ast =
  let open A in
  match ast with
    A.MetodocDecl {fn_id; fn_params; fn_tiporet; fn_locais; fn_corpo} ->
    (* Estende o ambiente global, adicionando um ambiente local *)
    let ambfn = Amb.novo_escopo amb in
    (* Insere os parâmetros no novo ambiente *)
    let insere_parametro (v,t) = Amb.insere_param ambfn (fst v) t in
    let _ = List.iter insere_parametro fn_params in
    (* Insere as variáveis locais no novo ambiente *)
    let insere_local = function
        (DecVar(v,t)) -> Amb.insere_local ambfn (fst v)  t in
    let _ = List.iter insere_local fn_locais in
    (* Verifica cada comando presente no corpo da função usando o novo ambiente *)
    let corpo_tipado = List.map (verifica_cmd ambfn fn_tiporet) fn_corpo in
      A.MetodocDecl {fn_id; fn_params; fn_tiporet; fn_locais; fn_corpo = corpo_tipado}


let rec verifica_dup xs =
  match xs with
    [] -> []
  | (nome,t)::xs ->
    let id = fst nome in
    if (List.for_all (fun (n,t) -> (fst n) <> id) xs)
    then (id, t) :: verifica_dup xs
    else let msg = "Formetro duplicado " ^ id in
      failwith (msg_erro nome msg)

let insere_declaracao_var amb dec =
  let open A in
    match dec with
      DecVar(nome, tipo) ->  Amb.insere_local amb (fst nome) tipo

let insere_declaracao_fun amb dec =
  let open A in
    match dec with
      MetodocDecl {fn_id; fn_params; fn_tiporet;  fn_corpo} ->
        (* Verifica se não há parâmetros duplicados *)
        let formais = verifica_dup fn_params in
        let nome = fst fn_id in
        Amb.insere_fun amb nome formais fn_tiporet

(*let analisa_dec amb dec = 
  let open A in
    match dec with
      DecVar(nome, tipo) ->  Amb.insere_local amb (fst nome) tipo
      |MetodocDecl {fn_id; fn_params; fn_tiporet;  fn_corpo} ->
        (* Verifica se não há parâmetros duplicados *)
        let _ = verifica_dup fn_params in
        Amb.insere_fun amb fn_id fn_params fn_tiporet

let verifica_dec amb dec = 
    let open A in
    match amb with
    A.DecVar {nome; tipo}  ->
        A.DecVar {nome; tipo}
   | A.MetodocDecl {fn_id; fn_params; fn_tiporet; fn_locais; fn_corpo} ->
    (* Estende o ambiente global, adicionando um ambiente local *)
    let ambfn = Amb.novo_escopo amb in
    (* Insere os parâmetros no novo ambiente *)
    let insere_parametro (v,t) = Amb.insere_param ambfn (fst v) t in
    let _ = List.iter insere_parametro fn_params in
    (* Insere as variáveis locais no novo ambiente *)
    let insere_local = function
        (DecVar(v,t)) -> Amb.insere_local ambfn (fst v)  t in
    let _ = List.iter insere_local fn_locais in
    (* Verifica cada comando presente no corpo da função usando o novo ambiente *)
    let corpo_tipado = List.map (verifica_cmd ambfn fn_tiporet) fn_corpo in
      A.MetodocDecl {fn_id; fn_params; fn_tiporet; fn_locais; fn_corpo = corpo_tipado}
*)

(* Lista de cabeçalhos das funções pré definidas *)
let fn_predefs = let open A in [
   ("escreva", [("x", TipoCaractere); ("y", TipoInteiro)], TipoVoid);
   ("leia",   [("x", TipoDouble); ("y", TipoInteiro)], TipoVoid)
]

(* insere as funções pré definidas no ambiente global *)
let declara_predefinidas amb =
  List.iter (fun (n,ps,tr) -> Amb.insere_fun amb n ps tr) fn_predefs

let semantico ast =
  (* cria ambiente global inicialmente vazio *)
  let amb_global = Amb.novo_amb [] in
  let _ = declara_predefinidas amb_global in
  let (A.Prog (decs_globais, decs_funs, corpo)) = ast in
  let _ = List.iter (insere_declaracao_var amb_global) decs_globais in
  let _ = List.iter (insere_declaracao_fun amb_global) decs_funs in
  (* Verificação de tipos nas funções *)
  let decs_funs = List.map (verifica_fun amb_global) decs_funs in
  (* Verificação de tipos na função principal *)
  let corpo = List.map (verifica_cmd amb_global A.TipoVoid) corpo in
     (A.Prog (decs_globais, decs_funs, corpo),  amb_global)
