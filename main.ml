open Expr
open Interpreteur

let compile e =
  begin
    affiche_prog e;
    print_newline();
  end

(* stdin d�signe l'entr�e standard (le clavier) *)
(* lexbuf est un canal ouvert sur stdin *)

let lexbuf c = Lexing.from_channel c

(* on encha�ne les tuyaux: lexbuf est pass� � Lexer.token,
   et le r�sultat est donn� � Parser.main *)

let parse c = Parser.main Lexer.token (lexbuf c)

 

(* aide pour l'utilisation du programme *)
let print_help () =
  print_string "./interp [option] fichier \nOptions :\n   -debug : pour afficher le programme en entr�e\n   -machine : Compile le programme et l'ex�cute\n   -interm : affiche le programme compil� sans l'ex�cuter.\nLes options -machine et -interm ne sont pas impl�ment�es encore pour les interm�diaires\n"


(* Fonction pour l'option debug qui affiche simplement le programme*)
let opt_debug () =
  try
    let c = open_in Sys.argv.(2) in
    let result = parse c in
    affiche_prog result
  with
  | e -> print_string (Printexc.to_string e)
               

(* Fonction pour lancer l'interpr�teur quand il n'y a pas d'options *)
let no_opt () =
  try
    let c = open_in Sys.argv.(1) in
    let result = parse c in
    let deb = ref [] in
    match interp result deb with
        VInt n -> print_int n;
		    print_newline(); flush stdout
      | VFun (x,body) -> affiche_prog (Function (x,body));
      | VFunR (x,body) -> affiche_prog (Function (x,body));
      | VRef _ -> print_string "A reference cannot be printed";
	print_newline(); flush stdout
  with | e -> (print_string (Printexc.to_string e))
                      
  (* seule l'option -debug est impl�ment�e � ce stade *)                    
let main () =
  try
    match Sys.argv.(1) with
    | "-debug" -> opt_debug()
    | _ -> no_opt ()
  with
  | _ -> print_help ()
    
let _ = main()
