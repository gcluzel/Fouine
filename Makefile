all: 
	ocamlbuild -yaccflag -v -lib unix main.native; ln -fs main.native interp

byte: 
	ocamlbuild -yaccflag -v main.byte

clean: 
	ocamlbuild -clean
