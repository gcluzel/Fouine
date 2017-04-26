open Expr
open Interpreteur
open Compilateur

let compile e =
  begin
    affiche_prog e;
    print_newline();
  end

(* stdin désigne l'entrée standard (le clavier) *)
(* lexbuf est un canal ouvert sur stdin *)

let lexbuf c = Lexing.from_channel c

(* on enchaîne les tuyaux: lexbuf est passé à Lexer.token,
   et le résultat est donné à Parser.main *)

let parse c = Parser.main Lexer.token (lexbuf c)

 

(* aide pour l'utilisation du programme *)
let print_help () =
  print_string "./interp [option] fichier \nOptions :\n   -debug : pour afficher le programme en entrée\n   -machine : Compile le programme et l'exécute\n   -interm : affiche le programme compilé sans l'exécuter.\n\n"

let rec write_code code fd =
  begin
    match code with
      [] -> ()
    | (C k)::q -> Printf.fprintf fd "%s\n" ("C "^(string_of_int(k)));
		  write_code q fd;
    | (A)::q -> Printf.fprintf fd "%s\n" "A";
		write_code q fd;
    | (M)::q -> Printf.fprintf fd "%s\n" "M";
		write_code q fd;
    | (S)::q -> Printf.fprintf fd "%s\n" "S";
		write_code q fd;
    | (P)::q -> Printf.fprintf fd "%s\n" "P";
		write_code q fd;
  end
	       

(* Fonction pour l'option debug qui affiche simplement le programme*)
let opt_debug () =
  try
    let c = open_in Sys.argv.(2) in
    let result = parse c in
    affiche_prog result;
    close_in c
  with
  | e -> print_string (Printexc.to_string e)
               

(* Fonction pour lancer l'interpréteur quand il n'y a pas d'options *)
let no_opt () =
  try
    let c = open_in Sys.argv.(1) in
    let result = parse c in
    let deb = ref [] in
    match interp result deb with
        VInt n -> print_int n;
		    print_newline(); flush stdout; close_in c
      | VFun (x,body,l) -> affiche_prog (Function (x,body)); close_in c
      | VFunR (x,body,l) -> affiche_prog (Function (x,body)); close_in c
      | VRef _ -> print_string "A reference cannot be printed";
		  print_newline(); flush stdout; close_in c
      | VErr _ -> close_in c; failwith("How did you manage to get an exception to be returned and not raised ?")

  with | e -> (print_string (Printexc.to_string e))

let opt_machine () =
  try
    let c = open_in Sys.argv.(2) in
    let result = parse c in
    let code = Compilateur.compile result in
    let n = exec code in
    begin
      close_in c;
      print_string (string_of_int n);
      print_newline ();
    end
  with | e -> (print_string (Printexc.to_string e))

let opt_interm () =
  try
    let c = open_in Sys.argv.(3) and cp = open_out Sys.argv.(2) in
    let result = parse c in
    let code = (Compilateur.compile result) in
    begin
      (write_code code cp);
      close_in c;
      close_out cp
    end				      
  with | e -> (print_string (Printexc.to_string e))
    
  (* seule l'option -debug est implémentée à ce stade *)                    
let main () =
  try
    match Sys.argv.(1) with
    | "-debug" -> opt_debug()
    | "-machine" -> opt_machine()
    | "-interm" -> opt_interm()
    | _ -> no_opt ()
  with
  | _ -> print_help ()
    
let _ = main()
