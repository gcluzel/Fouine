open Expr

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

(* retire une valeur de la m�moire*)
let rec pop:var->env->unit = fun x l ->
  match !l with
    [] -> failwith("Suppressing a variable that wasn't in the environment.")
  | (s,v)::lp when x=s -> l:=lp
  | (s,v)::lp -> l:=lp;
		 pop x l;
		 l:=(s,v)::lp
 

let rec update (x : var) (l : env) (n : int) = 
  match !l with
  | [] -> failwith("The reference " ^ x ^ "is not in the current environment")
  | (s,VRef v)::lp when s = x -> v:=n
  | (s,v)::lp -> l := lp;
                 update x l n;
                 l := (s,v)::lp

(* La fonction la plus importante : l'interpr�teur ! *)

let rec interp:prog->env->valeur=fun p l ->
  
  (* fonction d'interpr�tation d'une expression bool�enne *)
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
    (* Si c'est une constante : rien � faire *)
    Const n -> VInt n
		    
  (* Si un nom de variable appara�t, on va chercher dans l'environnement � quoi elle correspond *)
  | Variable x -> begin match lookup x l with
			  VInt n -> VInt n
			| _ -> failwith("Trying to use a function as a variable.")
		  end

  (* Les fonctions arithm�tiques, qui ne peuvent additioner que des entiers *)
  | Add (e1,e2) ->begin
		   match ((interp e1 l),(interp e2 l)) with
		     (VInt n1, VInt n2) -> VInt (n1+n2)
		   | (_,_) -> failwith("Trying to add functions or references.")
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

  (* LetIn peut soir correspondre � la d�finition d'une fonction, soit � la d�finition d'un entier, �a d�pend de si interp p1 l renvoie une VFun ou un VInt *)
  | Letin (x,p1,p2) -> let new_val = interp p1 l in
		       begin
			 l:=((x,new_val)::(!l));
			 let res = interp p2 l in
			 begin
			   pop x l;
			   res
			 end
		       end

  (* D�finition de type let rec d'une fonction r�cursive *)
  | RecFunction (f,p1,p2) -> let val_fun = interp p1 l in
			     begin
			       match val_fun with
				 VFun (x, body) -> l:=((f,VFunR (x,body))::(!l));
						   let res = interp p2 l in
						   begin
						     pop f l;
						     res
						   end
			       | _ -> failwith("Defining something that isn't a recursive function.")
			     end

  (* Ici c'est un if then else, donc on fait un if then else *)
  | IfThenElse (b,pif,pelse) -> if (interpbool b l) then interp pif l else interp pelse l

  (* L� c'est une fonction anonyme : donc un argument et le corps de la fonction *)
  | Function (x,pfun) -> VFun (x,pfun)

  (* Ici on souhaite appliquer une fonction *)
  | ApplyFun (f,p) -> begin
		      match f with
			(* On a tous les arguments : alors on peut appliquer la fonction *)
			Variable s -> begin
				     match lookup s l with
				       VInt _ -> failwith("Trying to use a variable as a function.")
				     | VFun (x,body) -> let fenv = (x, interp p l)::(!l) and lanc = !l in
							begin
							  l:= fenv;
							  pop s l;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VFunR (y, bodyp) -> VFunR (y, bodyp)
							  | VInt n -> l:= lanc;
								      VInt n
							  | VRef r -> l:= lanc;
								      VRef r
							end
				     (* On cr�e en fait un nouvel environnement d'ex�cution car on fait un appel fonction *)
				     | VFunR (x, body) -> let fenv = (x, interp p l)::(!l) and lanc = !l in
							begin
							  l:= fenv;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VFunR (y,bodyp) -> VFunR (y,bodyp)
							  | VInt n -> l:= lanc;
								      VInt n
							  | VRef r -> l:= lanc;
								      VRef r
							end
     				     | VRef _ -> failwith("Trying to use a reference as a fonction.")
				   end
					
		      (* Cas o� il manque encore des arguments : on cherche alors les autres*)
		      | ApplyFun(_,_) -> begin
					 let lanc = !l in
					   match interp f l with
					     VFun (y, body) -> begin
							      l:=((y, interp p (ref lanc))::(!l));
							      match interp body l with
								VFun (z, bodyp) -> VFun (z, bodyp)
							      | VFunR (z,bodyp) -> VFunR (z, bodyp)
							      | VInt n -> l:=lanc;
									  VInt n
							      |VRef r -> l:=lanc;
									 VRef r
							    end
					   | _ -> failwith("trying to apply something that isn't a function or too much arguments given.")
				       end
		      (* Cas o� on d�finit une fonction anonyme puis qu'on l'applique jsute apr�s *)
		      | Function(x,body) -> let fenv = [(x, interp p l)] and lanc = !l in
							begin
							  l:= fenv;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VFunR (y, bodyp) -> VFunR (y, bodyp)
							  | VInt n -> l:= lanc;
								      VInt n
							  | VRef r -> l:= lanc;
								      VRef r
							end
				     (* On cr�e en fait un nouvel environnement d'ex�cution car on fait un appel fonction *)
		      | _ -> failwith("Not the right number of arguments or not applying a function")
		    end

  (* Si on fait un prInt, alors on print et on renvoie la valeur *)
  | PrInt x -> begin
               let n = interp x l in
               match n with
		           VInt k -> print_int k; print_newline (); n
	             | _ -> failwith("Trying to prInt a function or a reference.")
             end

  (* LetIn mais pour une r�f�rence cette fois-ci. Alors on cr�e une r�f�rence dans notre environnement *)
  | LetRef (x, p1, p2) -> let new_val = interp p1 l in
                          begin
                            match new_val with
                            | VInt n -> begin
                                        l := (x, VRef (ref n)) :: !l;
     	                                interp p2 l
     	                                end
                            | _ -> failwith("Impossible to assign a ref from a function or a ref")
                          end

  (* On a un bang : on r�cup�re la valeur et on la renvoie *)
  | Bang x -> begin
               match lookup x l with
               | VRef n -> VInt (!n)
               | _ -> failwith("Trying to deference a non-reference object.")
            end

  (* On veut changer la valeur, on fait appel � la fonction update *)
  | RefAff (x, p1, p2) -> begin
                           begin match interp p1 l with
                             | VInt n -> update x l n
                             | _ -> failwith("Affectation error : the right member is not an interger")
                             end;
                           interp p2 l
                           end


 

(* aide pour l'utilisation du programme *)
let print_help () =
  print_string "./interp [option] fichier \nOptions :\n   -debug : pour afficher le programme en entr�e\n   -machine : Compile le programme et l'ex�cute\n   -interm : affiche le programme compil� sans l'ex�cuter.\n"


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
                      
                      
let main () =
  try
    match Sys.argv.(1) with
    | "-debug" -> opt_debug()
    | _ -> no_opt ()
  with
  | _ -> print_help ()
    
let _ = main()
