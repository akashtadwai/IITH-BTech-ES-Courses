OBJS = ast.cmo parser.cmo lexer.cmo helper.cmo semantic.cmo compile.cmo main.cmo 

stoichy: $(OBJS)
	ocamlc str.cma -o stoichy $(OBJS)
	javac functions/*.java

lexer.ml:lexer.mll
	ocamllex lexer.mll
parser.ml parser.mli:parser.mly
	ocamlyacc -v $<
%.cmo : %.ml
	ocamlc -c $<
%.cmi : %.mli 
	ocamlc -c $<
# parser.cmo:parser.cmi 
ast.cmo : ast.cmi
ast.cmx : ast.cmi
parser.cmo : ast.cmi parser.cmi
parser.cmx : ast.cmx parser.cmi
lexer.cmo : parser.cmi
lexer.cmx : parser.cmx
semantic.cmo : ast.cmi
semantic.cmx : ast.cmx
ast.cmi :
parser.cmi : ast.cmi
compile.cmo : ast.cmi
compile.cmx : ast.cmx

.PHONY : clean
clean:
	rm -rf stoichy parser.mli lexer.ml parser.ml *.cmi *.cmo *.output functions/*.class demo/*.out test_cases/*.out stoichy *.class  *.java

# ocamlyacc parser.mly  	parser.mli rpcal.ml
# ocamlc -c parser.mli   	parser.cmi
# ocamlc -c parser.ml  		parser.cmo
# ocamllex lexer.mll    	lexer.ml
# ocamlc -c lexer.ml 		lexer.cmi lexer.cmo