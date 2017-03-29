open Expr

let compile e =
  begin
    affiche_prog e;
    print_newline();
  end

(* stdin désigne l'entrée standard (le clavier) *)
(* lexbuf est un canal ouvert sur stdin *)

let lexbuf = Lexing.from_channel stdin

(* on enchaîne les tuyaux: lexbuf est passé à Lexer.token,
   et le résultat est donné à Parser.main *)

let parse () = Parser.main Lexer.token lexbuf

(* la fonction que l'on lance ci-dessous *)
let calc () =
  try
      let result = parse () in
      (* Expr.affiche_expr result; print_newline (); flush stdout *)
	compile result; flush stdout
  with _ -> (print_string "erreur de saisie\n")
;;

(* Fonction lookup pour chercher la valeur d'une variable dans la pile *)
let rec lookup x l =
  match l with
    [] -> failwith(x^" is not defined in the current environment.\n")
  | (s,v)::lp when x=s -> v
  | (s,v)::lp -> lookup x lp
  
(* La fonction pour évaluer une expression arithmétique *)

let rec eval e l=
  match e with
    Const n -> n
  | Variable x -> lookup x l
  | Add (e1,e2) -> (eval e1 l)+(eval e2 l)
  | Mul (e1,e2) -> (eval e1 l)*(eval e2 l)
  | Min (e1,e2) -> (eval e1 l)-(eval e2 l)

(* La fonction la plus importante : l'interpréteur ! *)
  
let rec interp p l =
  match p with
    ExprAr e -> eval e l
  | Letin (x,p1,p2) -> interp p2 ((x, interp p1 l)::l)
  | _ -> failwith("not implemented yet")


(* Fonction main : celle qui est lancée lors de l'exécution *)
		 
let main () =
  try
    let result = parse () in
    begin
      affiche_prog result; print_int (interp result []); flush stdout
    end
  with | e -> (print_string (Printexc.to_string e))
		 
let _ = main()
