#!/bin/bash
#rm -rf  _build sintaticoTest.byte semanticoTest.byte
rm -rf  _build  semanticoTest.byte
 #menhir -v --list-errors parser.mly > parser.msg
# menhir -v parser.mly --compile-errors parser.msg > erroSint.ml
# ocamlbuild -use-ocamlfind -use-menhir -menhir "menhir --table" -package menhirLib sintaticoTest.byte
 ocamlbuild -use-ocamlfind -use-menhir -menhir "menhir --table" -package menhirLib semanticoTest.byte
rlwrap ocaml
# pra dar permissao pro script rodar digita no terminal chmod 777 exemplo1.sh
