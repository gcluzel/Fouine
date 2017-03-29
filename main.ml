open Expr

let compile e =
  begin
    affiche_prog e;
    print_newline();
  end

(* stdin d�signe l'entr�e standard (le clavier) *)
(* lexbuf est un canal ouvert sur stdin *)

let lexbuf = Lexing.from_channel stdin

(* on encha�ne les tuyaux: lexbuf est pass� � Lexer.token,
   et le r�sultat est donn� � Parser.main *)

let parse () = Parser.main Lexer.token lexbuf

(* la fonction que l'on lance ci-dessous *)
let calc () =
  try
      let result = parse () in
      (* Expr.affiche_expr result; print_newline (); flush stdout *)
	compile result; flush stdout
  with _ -> (print_string "erreur de saisie\n")
;;

(* La fonction pour �valuer une expression arithm�tique *)


let rec interp p =
  match p with
    ExprAr e -> eval e
  | _ -> failwith("not implemented yet")


(* Fonction main : celle qui est lanc�e lors de l'ex�cution *)
		 
let main () =
  try
    let result = parse () in
    interp result; flush stdout
  with | e -> (print_string (Printexc.to_string e))
		 
let _ = calc()
