#!/usr/bin/env bash
# Add Ocaml repo
add-apt-repository ppa:avsm/ppa -y
apt-get install opam -y
# environment setup
opam init -y 
eval "$(opam env)"
# install given version of the compiler
opam switch create 4.11.1
# check you got what you want
which ocaml
ocaml -version
apt install ocaml-nox -y 
apt install ocaml -y 
# pip is pre req
apt-get install python3-pip -y 
pip3 install sympy 
