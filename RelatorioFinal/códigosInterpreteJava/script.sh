#!/bin/bash
   menhir -v --list-errors parser.mly > parser.msg
     menhir -v --list-errors parser.mly --compile-errors parser.msg > erroSint.ml
ocamlbuild -use-ocamlfind -use-menhir -menhir "menhir --table" -package menhirLib sintaticoTest.byte

# pra dar permissao pro script rodar digita no terminal chmod 777 exemplo1.sh
