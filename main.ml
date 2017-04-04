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
let rec lookup:var->env->memory= fun x l ->
  match l with
    [] -> failwith(x^" is not defined in the current environment.\n")
  | (s,v)::lp when x=s -> v
  | (s,v)::lp -> lookup x lp


			
(* La fonction la plus importante : l'interpréteur ! *)
  
let rec interp:prog->env->int=fun p l ->
  
  (* fonction d'interprétation d'une expression booléenne *)
  let interpbool b l =
    match b with
      Eq (p1,p2) -> (interp p1 l) = (interp p2 l)
    | Neq (p1,p2) -> (interp p1 l) != (interp p2 l)
    | Gt (p1,p2) -> (interp p1 l) > (interp p2 l)
    | Ge (p1,p2) -> (interp p1 l) >= (interp p2 l)
    | Lt (p1,p2) -> (interp p1 l) < (interp p2 l)
    | Le (p1,p2) -> (interp p1 l) <= (interp p2 l)
    | Vrai -> true
    | Faux -> false
  in
  match p with
    Const n -> n
  | Variable x -> begin match lookup x l with
			  Value n -> n
			| _ -> failwith("Trying to use a function as a variable.")
		  end
  | Add (e1,e2) -> (interp e1 l)+(interp e2 l)
  | Mul (e1,e2) -> (interp e1 l)*(interp e2 l)
  | Min (e1,e2) -> (interp e1 l)-(interp e2 l)
  | Letin (x,p1,p2) -> interp p2 ((x,Value (interp p1 l))::l)
  | IfThenElse (b,pif,pelse) -> if (interpbool b l) then interp pif l else interp pelse l
  (* | Function (f,x,pfun,psuite) -> interp p ((f,Fun (x,pfun))::l)*)
 (* | ApplyFun (f,p) -> begin
		      match lookup f l with
		      | Value _ -> failwith("Trying to apply something to something that isn't a function.")
		      | Fun (x,body)-> interp body ((x,Value (interp p l))::l)
		    end*)
  | PrInt x -> begin
               let valeur = interp x l in
               print_int valeur;
               valeur
               end   
  | _ -> failwith("not implemented yet")


(* Fonction main : celle qui est lancée lors de l'exécution *)
		 
let main () =
  try
    let result = parse () in
    begin
      affiche_prog result; (*print_int (interp result []);*)
      print_newline(); flush stdout
    end
  with | e -> (print_string (Printexc.to_string e))
		 
let _ = main()
