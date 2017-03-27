{
  open Parser;;        (* le type "token" est d�fini dans parser.mli *)
(* ce n'est pas � vous d'�crire ce fichier, il est engendr� automatiquement *)
exception Eof;;
}

rule token = parse    (* la "fonction" aussi s'appelle token .. *)
  | [' ' '\t']     { token lexbuf }    (* on saute les blancs et les tabulations *)
 	     	   	           (* token: appel r�cursif *)
                                   (* lexbuf: argument implicite
                                      associ� au tampon o� sont
                                      lus les caract�res *)
  | '\n'            { EOL }
  | '+'             { Plus }
  | '*'             { Times }
  | '-'             { Minus }
  | '('             { L_par }
  | ')'             { R_par }
  | "let" 			{ Let }
  | "in"			{ IN }
  | ";;"			{ Enf_of_function }
  | "fun" 			{ Fun }
  | "->"			{ Right_arrow }
  | "if" 			{ If }
  | "then" 			{ Then }
  | "else"			{ Else }
  | "begin"			{ L_par }
  | "end"			{ R_par }
  | "let rec" 		{ Let_rec }
  | (['a'-'z']|['A'-'Z']|'_')(['a'-'z']|['A'-'Z']|'_'|['0'-'9'])*
  					{ Var s }
  | '>' 			{ C_g }
  | ">="			{ C_ge }
  | '<'				{ C_l }
  | "<="			{ C_le }
  | "<>" 			{ C_neq }
  | ['0'-'9']+ as s { Int (int_of_string s) }
  | eof             { raise Eof } 
