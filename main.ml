open Expr

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

(* Fonction lookup pour chercher la valeur d'une variable dans la pile *)
let rec lookup:var->env->valeur= fun x l ->
  match !l with
    [] -> failwith(x^" is not defined in the current environment.")
  | (s, v)::lp when x=s -> v
  (*| (s, VFun (x,body))::lp when x=s -> VFun (x,body)*)
  | (s,v)::lp -> l:=lp;
		 let res = lookup x l in
		 begin
		   l:=((s,v)::lp);
		   res
		 end

let rec pop:var->env->unit = fun x l ->
  match !l with
    [] -> failwith("Suppressing a variable that wasn't in the environment.")
  | (s,v)::lp when x=s -> l:=lp
  | (s,v)::lp -> l:=lp;
		 pop x l;
		 l:=(s,v)::lp


let rec update (x : var) (l : env) (v : valeur) = 
  match !l with
  | [] -> failwith("The reference " ^ x ^ "is not in the current environment")
  | (s,VRef vv)::lp when s = x -> l := (s, v) :: lp
  | (s,vv)::lp -> l := lp;
                 update x l v;
                 l := (s,vv)::lp

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
  | Letin (x,p1,p2) -> let new_val = interp p1 l in
		       begin
			 l:=((x,new_val)::(!l));
			 interp p2 l
		       end
  | IfThenElse (b,pif,pelse) -> if (interpbool b l) then interp pif l else interp pelse l
  | Function (x,pfun) -> VFun (x,pfun)
  | ApplyFun (f,p) -> begin
		      match f with
			Variable s -> begin
				     match lookup s l with
				       VInt _ -> failwith("Trying to use a variable as a function.")
				     | VFun (x,body) -> let fenv = [(x, interp p l)] and lanc = !l in
							begin
							  l:= fenv;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VInt n -> l:= lanc;
								      VInt n
							  | VRef r -> l:= lanc;
								      VRef r
							end
				     (* On crée en fait un nouvel environnement d'exécution car on fait un appel fonction *)
     				     | VRef _ -> failwith("Trying to use a reference as a fonction.")
				   end
		      | ApplyFun(_,_) -> begin
					 let lanc = !l in
					   match interp f l with
					     VFun (y, body) -> begin
							      l:=((y, interp p l)::(!l));
							      match interp body l with
								VFun (z, bodyp) -> VFun (y, bodyp)
							      | VInt n -> l:=lanc;
									  VInt n
							      |VRef r -> l:=lanc;
									 VRef r
							    end
					   | _ -> failwith("trying to apply something that isn't a function or too much arguments given.")
					 end
		      | _ -> failwith("Not the right number of arguments or not applying a function")
		    end
  | PrInt x -> begin
               let n = interp x l in
               match n with
		           VInt k -> print_int k; print_newline (); n
	             | _ -> failwith("Trying to prInt a function or a reference.")
               end
  | LetRef (x, p1, p2) -> let new_val = interp p1 l in
                          begin
                            match new_val with
                            | VInt n -> begin
                                        l := (x, VRef n) :: !l;
     	                                interp p2 l
     	                                end
                            | _ -> failwith("Impossible to assign a ref from a function or a ref")
                          end
  | Bang x -> begin
               match lookup x l with
               | VRef n -> VInt n
               | _ -> failwith("Trying to deference a non-reference object.")
               end
  | RefAff (x, p1, p2) -> begin
                           begin match interp p1 l with
                             | VInt n -> update x l (VRef n)
                             | _ -> failwith("Affectation error : the right member is not an interger")
                             end;
                           interp p2 l
                           end
  | _ -> failwith("not implemented yet")


(* Fonction main : celle qui est lancée lors de l'exécution *)
		 
(*let main () =
  try
    let result = parse () in
    begin
      affiche_prog result;
      let deb = ref [] in
	match interp result deb with
	  VInt n -> print_int n;
		    print_newline(); flush stdout
	| VFun (x,body) -> affiche_prog (Function (x,body))
	| VRef _ -> print_string "A reference cannot be printed";
	print_newline(); flush stdout
    end
  with | e -> (print_string (Printexc.to_string e))*)
 

(* aide pour l'utilisation du programme *)
let print_help () =
  print_string "./interp [option] fichier \nOptions :\n   -debug : pour afficher le programme en entrée\n   -machine : Compile le programme et l'exécute\n   -interm : affiche le programme compilé sans l'exécuter.\n"


(* Fonction pour l'option debug qui affiche simplement le programme*)
let opt_debug () =
  try
    let c = open_in Sys.argv.(2) in
    let result = parse c in
    affiche_prog result
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
		    print_newline(); flush stdout
	  | VFun (x,body) -> affiche_prog (Function (x,body));
	  | VRef _ -> print_string "A reference cannot be printed";
	print_newline(); flush stdout
  with | e -> (print_string (Printexc.to_string e))
                      
                      
let main () =
  try
    match Sys.argv.(1) with
    | "-debug" -> opt_debug()
    | _ -> no_opt ()
  with
  | _ -> print_help ()
    
let _ = main()
