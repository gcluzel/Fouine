open Expr

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

(* retire une valeur de la mémoire*)
let rec pop:var->env->unit = fun x l ->
  match !l with
    [] -> failwith("Suppressing a variable that wasn't in the environment.")
  | (s,v)::lp when x=s -> l:=lp
  | (s,v)::lp -> l:=lp;
		 pop x l;
		 l:=(s,v)::lp
 
(* Met à jour la valeur d'une référence dans la mémoire *)
let rec update (x : var) (l : env) (n : int) = 
  match !l with
  | [] -> failwith("The reference " ^ x ^ "is not in the current environment")
  | (s,VRef v)::lp when s = x -> v:=n
  | (s,v)::lp -> l := lp;
                 update x l n;
                 l := (s,v)::lp

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
    (* Si c'est une constante : rien à faire *)
    Const n -> VInt n
		    
  (* Si un nom de variable apparaît, on va chercher dans l'environnement à quoi elle correspond *)
  | Variable x -> begin match lookup x l with
			  VInt n -> VInt n
			| _ -> failwith("Trying to use a function as a variable.")
		  end

  (* Les fonctions arithmétiques, qui ne peuvent additioner que des entiers *)
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

  (* LetIn peut soir correspondre à la définition d'une fonction, soit à la définition d'un entier, ça dépend de si interp p1 l renvoie une VFun ou un VInt *)
  | Letin (x,p1,p2) -> let new_val = interp p1 l in
		       begin
			 l:=((x,new_val)::(!l));
			 let res = interp p2 l in
			 begin
			   pop x l;
			   res
			 end
		       end

  (* Définition de type let rec d'une fonction récursive *)
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

  (* Là c'est une fonction anonyme : donc un argument et le corps de la fonction *)
  | Function (x,pfun) -> VFun (x,pfun)

  (* Ici on souhaite appliquer une fonction *)
  | ApplyFun (f,p) -> begin
		      match f with
			(* On a tous les arguments : alors on peut appliquer la fonction *)
			Variable s -> begin
				     match lookup s l with
				       VFun (x,body) -> let fenv = (x, interp p l)::(!l) and lanc = !l in
							begin
							  l:= fenv;
							  pop s l;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VFunR (y, bodyp) -> VFunR (y, bodyp)
							  | n -> l:= lanc;
								 n
							end
				     (* On crée en fait un nouvel environnement d'exécution car on fait un appel fonction *)
				     | VFunR (x, body) -> let fenv = (x, interp p l)::(!l) and lanc = !l in
							begin
							  l:= fenv;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VFunR (y,bodyp) -> VFunR (y,bodyp)
							  | n -> l:= lanc;
								 n
							end
     				     | _ -> failwith("Trying to use something that isn't a function as a fonction.")
				   end
					
		      (* Cas où il manque encore des arguments : on cherche alors les autres*)
		      | ApplyFun(_,_) -> begin
					 let lanc = !l in
					   match interp f l with
					     VFun (y, body) -> begin
							      l:=((y, interp p (ref lanc))::(!l));
							      match interp body l with
								VFun (z, bodyp) -> VFun (z, bodyp)
							      | VFunR (z,bodyp) -> VFunR (z, bodyp)
							      | n -> l:=lanc;
								     n
							    end
					   | _ -> failwith("trying to apply something that isn't a function or too much arguments given.")
				       end
		      (* Cas où on définit une fonction anonyme puis qu'on l'applique jsute après *)
		      | Function(x,body) -> let fenv = [(x, interp p l)] and lanc = !l in
							begin
							  l:= fenv;
							  match interp body l with
							    VFun (y,bodyp) -> VFun (y,bodyp)
							  | VFunR (y, bodyp) -> VFunR (y, bodyp)
							  | n -> l:= lanc;
								 n
							end
				     (* On crée en fait un nouvel environnement d'exécution car on fait un appel fonction *)
		      | _ -> failwith("Not the right number of arguments or not applying a function")
		    end

  (* Si on fait un prInt, alors on print et on renvoie la valeur *)
  | PrInt x -> begin
               let n = interp x l in
               match n with
		           VInt k -> print_int k; print_newline (); n
	             | _ -> failwith("Trying to prInt a function or a reference.")
             end

  (* LetIn mais pour une référence cette fois-ci. Alors on crée une référence dans notre environnement *)
  | LetRef (x, p1, p2) -> let new_val = interp p1 l in
                          begin
                            match new_val with
                            | VInt n -> begin
                                        l := (x, VRef (ref n)) :: !l;
     	                                interp p2 l
     	                                end
                            | _ -> failwith("Impossible to assign a ref from a function or a ref")
                          end

  (* On a un bang : on récupère la valeur et on la renvoie *)
  | Bang x -> begin
               match lookup x l with
               | VRef n -> VInt (!n)
               | _ -> failwith("Trying to deference a non-reference object.")
            end

  (* On veut changer la valeur, on fait appel à la fonction update *)
  | RefAff (x, p1, p2) -> begin
                           begin match interp p1 l with
                             | VInt n -> update x l n
                             | _ -> failwith("Affectation error : the right member is not an interger")
                             end;
                           interp p2 l
                        end
  | TryWith (p1,e,p2) ->begin
			 match interp e l with
			   VErr r -> begin
				    try interp p1 l
				    with r -> interp p2 l
				  end
			 | _ -> failwith("Catching something that isn't an error")
		       end
  | Raise (p) -> begin
		 match interp p l with
		   VErr e -> raise e
		 | _ -> failwith("Not raising an error")
	       end
  | Excep (p) -> begin
		 match interp p l with
		   VInt n -> VErr (E n)
		 | _ -> failwith("Giving an argument that isn't an int to the exception.")
	       end
