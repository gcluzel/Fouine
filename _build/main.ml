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
let rec lookup:var->env->valeur= fun x l ->
  match l with
    [] -> failwith(x^" is not defined in the current environment.\n")
  | (s,v)::lp when x=s -> v
  | (s,v)::lp -> lookup x lp


			
(* La fonction la plus importante : l'interpréteur ! *)
  
let rec interp:prog->env->valeur=fun p l ->
  
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
    Const n -> VInt n
  | Variable x -> begin match lookup x l with
			  VInt n -> VInt n
			| _ -> failwith("Trying to use a function as a variable.")
		  end
  | Add (e1,e2) ->begin
		   match ((interp e1 l),(interp e2 l)) with
		     (VInt n1, VInt n2) -> VInt (n1+n2)
		   | (_,_) -> failwith("Trying to add functions.")
		 end
  | Mul (e1,e2) -> begin
		   match ((interp e1 l),(interp e2 l)) with
		     (VInt n1, VInt n2) -> VInt (n1*n2)
		   | (_,_) -> failwith("Trying to multiply functions.")
		 end
  | Min (e1,e2) ->begin
		   match ((interp e1 l),(interp e2 l)) with
		     (VInt n1, VInt n2) -> VInt (n1-n2)
		   | (_,_) -> failwith("Trying to substract functions.")
		 end
  | Letin (f,Function(x,body),p) -> interp p ((f, VFun (x,body))::l)
  | Letin (x,p1,p2) -> interp p2 ((x,(interp p1 l))::l)
  | IfThenElse (b,pif,pelse) -> if (interpbool b l) then interp pif l else interp pelse l
  | Function (x,pfun) -> VFun (x,pfun)
  | ApplyFun (f,p) -> begin
		      match f with
			Variable s -> begin
				     match lookup s l with
				       VInt _ -> failwith("Trying to use a variable as a function.")
				     | VFun (x,body) -> interp body ((x,interp p l)::l)
				   end
		      | ApplyFun(_,_) -> begin
					   match interp f l with
					     VFun (y, body) -> interp body ((y,interp p l)::l)
					   | VInt _ -> failwith("trying to apply something that isn't a function or too much arguments given.")
					 end
		      | _ -> failwith("Not the right number of arguments or not applying a function")
		    end
  | PrInt x -> begin
               let n = interp x l in
               match n with
		 VInt k -> print_int k; n
	       | _ -> failwith("Trying to prInt a function.")
               end   
  | _ -> failwith("not implemented yet")


(* Fonction main : celle qui est lancée lors de l'exécution *)
		 
let main () =
  try
    let result = parse () in
    begin
      affiche_prog result;
      match interp result [] with
	VInt n -> print_int n;
		  print_newline(); flush stdout
      | VFun (x,body) -> affiche_prog (Function (x,body));
      print_newline(); flush stdout
    end
  with | e -> (print_string (Printexc.to_string e))
		 
let _ = main()
