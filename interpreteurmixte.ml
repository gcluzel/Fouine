open Expr
open Compilateur

(* fonction qui trouve tous les sous-programmes purs *)
let rec purifier p =
  match p with
    Const n -> (true,p)
  | Variable x -> (true,p)
  | Add(p1,p2,_) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
		    if(b1 && b2)
		    then
		      (true, Add(pp1,pp2, true))
		    else
		      (false, Add(pp1,pp2, false))
  | Mul(p1,p2,_) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
		    if(b1&&b2)
		    then
		      (true, Mul(pp1,pp2,true))
		    else
		      (false, Mul(pp1,pp2,false))
  | Min(p1,p2,_) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
		    if(b1&&b2)
		    then
		      (true, Min(pp1,pp2,true))
		    else
		      (false, Min(pp1,pp2,false))
  | Letin(x,p1,p2,_) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
			if(b1&&b2)
			then
			  (true, Letin(x,pp1,pp2,true))
			else
			  (false, Letin(x, pp1, pp2, false))
  | RecFunction(x,p1,p2) ->let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
			   (false, RecFunction(x,pp1,pp2))
  | IfThenElse (b,p1,p2) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
			    (false, IfThenElse(b,pp1,pp2))
  | ApplyFun (p1,p2) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
			(false, ApplyFun(pp1,pp2))
  | Function (x,p1) -> let (b1,pp1)=purifier p1 in
		       (false, Function(x,pp1))
  | PrInt (p1,_) -> let (b1,pp1)=purifier p1 in
		    (b1, PrInt(pp1, b1))
  | LetRef (x,p1,p2) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
			(false, LetRef(x, pp1, pp2))
  | Bang(x) -> (false, Bang(x))
  | RefAff(x,p1,p2) -> let (b1,pp1)=purifier p1 and (b2,pp2)=purifier p2 in
		       (false, RefAff(x,pp1,pp2))
  | TryWith(p1,p2,p3) -> let (b1,pp1)=purifier p1 and (b2,pp2)= purifier p2 and (b3,pp3)=purifier p3 in
			 (false, Trywith(pp1,pp2,pp3))
  | Raise (p1) -> let (b1,pp1)=purifier p1 in
		  (false, Raise(pp1))
  | Excep (p1) -> let (b1,pp1)=purifier p1 in
		  (false, Excep(pp1))


		    
(* La fonction la plus importante : l'interpréteur ! *)

let rec interpmixte:prog->env->valeur=fun p l ->
  
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
  | Add (e1,e2,b) ->begin
		     if b
		     then begin
			 let code = Compilateur.compile p in
			 VInt (exec code)
		       end
		     else
		       match ((interpmixte e1 l),(interpmixte e2 l)) with
			 (VInt n1, VInt n2) -> VInt (n1+n2)
		       | (_,_) -> failwith("Trying to add functions or references.")
		   end
  | Mul (e1,e2,b) -> begin
		     if b
		     then begin
			 let code = Compilateur.compile p in
			 VInt (exec code)
		       end
		     else
		       match ((interpmixte e1 l),(interpmixte e2 l)) with
			 (VInt n1, VInt n2) -> VInt (n1*n2)
		       | (_,_) -> failwith("Trying to multiply functions.")
		   end
  | Min (e1,e2,_) ->begin
		     if b
		     then begin
			 let code = Compilateur.compile p in
			 VInt(exec code)
		       end
		     else
		       match ((interpmixte e1 l),(interpmixte e2 l)) with
			 (VInt n1, VInt n2) -> VInt (n1-n2)
		       | (_,_) -> failwith("Trying to substract functions.")
		   end

  (* LetIn peut soir correspondre à la définition d'une fonction, soit à la définition d'un entier, ça dépend de si interp p1 l renvoie une VFun ou un VInt *)
  | Letin (x,p1,p2,_) -> let new_val = interpmixte p1 l in
			 if b
			 then begin
			     let code = Compilateur.compile p in
			     VInt(exec code)
			   end
			 else
		       begin
			 l:=((x,new_val)::(!l));
			 let res = interpmixte p2 l in
			 begin
			   pop x l;
			   res
			 end
		       end

  (* Définition de type let rec d'une fonction récursive *)
  | RecFunction (f,p1,p2) -> let val_fun = interpmixte p1 l in
			     begin
			       match val_fun with
				 VFun (x, body, clo) -> l:=((f,VFunR (x,body, clo))::(!l));
						   let res = interpmixte p2 l in
						   begin
						     pop f l;
						     res
						   end
			       | _ -> failwith("Defining something that isn't a recursive function.")
			     end

  (* Ici c'est un if then else, donc on fait un if then else *)
  | IfThenElse (b,pif,pelse) -> if (interpbool b l) then interp pif l else interp pelse l

  (* Là c'est une fonction anonyme : donc un argument et le corps de la fonction *)
  | Function (x,pfun) -> VFun (x,pfun,ref !l)

  (* Ici on souhaite appliquer une fonction *)
  | ApplyFun (f,p) -> begin
		      match f with
			(* On a tous les arguments : alors on peut appliquer la fonction *)
			Variable s -> begin
				     match lookup s l with
				       VFun (x,body,clo) -> let fenv = (x, interp p l)::(!clo) and cloanc = !clo in
							begin
							  clo:= fenv;
							  match interp body clo with
							    VFun (y,bodyp,clop) -> VFun (y,bodyp,clop)
							  | VFunR (y, bodyp,clop) -> VFunR (y, bodyp,clop)
							  | n -> clo:= cloanc;
								 n
							end
				     (* On utilise la cloture associée à la fonction *)
				     | VFunR (x, body, clo) -> let fenv = (s, VFunR (x, body, clo))::(x, interp p l)::(!clo) and cloanc = !clo in
							begin
							  clo:= fenv;
							  match interp body clo with
							    VFun (y,bodyp,clop) -> VFun (y,bodyp,clop)
							  | VFunR (y,bodyp,clop) -> VFunR (y,bodyp,clop)
							  | n -> clo:= cloanc;
								 n
							end
     				     | _ -> failwith("Trying to use something that isn't a function as a fonction.")
				   end
					
		      (* Cas où il manque encore des arguments : on cherche alors les autres*)
		      | ApplyFun(_,_) -> begin
					 let lanc = !l in
					   match interp f l with
					     VFun (y, body, clo) -> begin
							      l:=((y, interp p (ref lanc))::(!clo));
							      match interp body l with
								VFun (z,bodyp,clop) -> VFun (z,bodyp,clop)
							      | VFunR (z,bodyp,clop) -> VFunR (z,bodyp,clop)
							      | n -> l:=lanc;
								     n
							    end
					   | _ -> failwith("trying to apply something that isn't a function or too much arguments given.")
				       end
		      (* Cas où on définit une fonction anonyme puis qu'on l'applique juste après *)
		      | Function(x,body) -> let fenv = (x, interp p l)::(!l) and lanc = !l in
							begin
							  l:= fenv;
							  match interp body l with
							    VFun (y,bodyp,clop) -> VFun (y,bodyp,clop)
							  | VFunR (y,boyp,clop) -> VFunR (y,body,clop)
							  | n -> l:= lanc;
								 n
							end
				     (* On crée en fait un nouvel environnement d'exécution car on fait un appel fonction *)
		      | _ -> failwith("Not the right number of arguments or not applying a function")
		    end

  (* Si on fait un prInt, alors on print et on renvoie la valeur *)
  | PrInt (x,b) -> begin
		   if b
		   then
		     let code = Compilateur.compile p in
		     VInt (exec code)
		   else
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
			 match e with
			   (* On vérifie que e est bien un code d'erreur *)
			   Excep (p) -> begin
				       match p with
					 (* Son argument doit soit être une variable... *)
					 Variable x -> begin
							   try interp p1 l
							   with (E y) -> begin
									l:= (x, VInt y)::(!l);
									let res = interp p2 l in
									begin
									pop x l;
									res
									end
								      end
							 end
				       | _  -> begin
					       match interp p l with
						 (* ...Soit un programme qui renvoie un int *)
						 VInt n -> begin
							  try interp p1 l
							(* On catch l'erreur et on vérifie que c'est la bonne, sinon on fait remonter l'erreur *)
							  with (E k) -> if n=k then interp p2 l
									else raise (E k)
							end
					       | _ -> failwith("Wrong type of exception in try with.")
					     end
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
