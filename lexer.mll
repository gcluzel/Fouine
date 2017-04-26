{
  open Parser;;        (* le type "token" est d�fini dans parser.mli *)
(* ce n'est pas � vous d'�crire ce fichier, il est engendr� automatiquement *)
exception Eof;;
}

rule token = parse    (* la "fonction" aussi s'appelle token .. *)
  | [' ' '\t' '\n']     { token lexbuf }    (* on saute les blancs et les tabulations *)
 	     	   	           (* token: appel r�cursif *)
                                   (* lexbuf: argument implicite
                                      associ� au tampon o� sont
                                      lus les caract�res *)
  | ";;"            { EOF }
  | '+'             { Plus }
  | '*'             { Times }
  | '-'             { Minus }
  | '('             { L_par }
  | ')'             { R_par }
  | "let" 			{ Let }
  | "in"			{ In }
  | "fun" 			{ Fun }
  | "->"			{ Right_arrow }
  | "if" 			{ If }
  | "then" 			{ Then }
  | "else"			{ Else }
  | "begin"			{ L_par }
  | "end"			{ R_par }
  | "prInt"			{ PrInt }
  | "let rec"		{ Let_rec }
  | '='				{ C_eq }
  | '>' 			{ C_g }
  | ">="			{ C_ge }
  | '<'				{ C_l }
  | "<="			{ C_le }
  | "<>" 			{ C_neq }
  | "true"			{ True }
  | "false"			{ False }
  | ":="			{ Ref_aff }
  | '!'				{ Bang }
  | ';'				{ Pt_virg }
  | "ref"			{ Ref }
  | "raise"			{ Raise }
  | "try"			{ Try }
  | "with"			{ With }
  | 'E'				{ Excep }
  | ['0'-'9']+ as s { Int (int_of_string s) }
  | (['a'-'z']|['A'-'Z']|'_')(['a'-'z']|['A'-'Z']|'_'|['0'-'9'])* as s  { Var s }
  | eof             { EOF } 
