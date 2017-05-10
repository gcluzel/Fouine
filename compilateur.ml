open Expr

type instr =
    C of int      (* Entier *)
  | P             (* Instruction d'affichage *)
  | A             (* Addition *)
  | M             (* Multiplication *)
  | S             (* Soustraction *)
  | LET of var    (* Let In *)
  | ENDLET        (* Fin du let *)
  | ACCESS of var (* Accès à une variable *)
      
(* Compilation d'un programme vers une pile pour la machine à pile *)     
let rec compile:prog->instr list = fun p ->
  match p with
    Const n -> [C n]
  | Variable x -> [ACCESS x]
  | PrInt (p,_) -> (compile p)@[P]
  | Add (p1, p2,_) -> (compile p2)@(compile p1)@[A]
  | Mul(p1,p2,_) -> (compile p2)@(compile p1)@[M]
  | Min(p1,p2,_) -> (compile p2)@(compile p1)@[S]
  | Letin(x, p1, p2,_) -> (compile p1)@[LET x]@(compile p2)@[ENDLET]
  | _ -> failwith("Not yet implemented.")
		  

(* Execution de la machine à pile*)
let rec exec code e = 
	let rec aux code pile l =
		match code with
		| [] -> begin 
		          match pile with
			      | [x] -> x
			      | _ -> failwith("impossible")
			    end
			    
	    (* Pour un nombre, on l'ajoute sur la pile *)
		| (C n)::q -> aux q (n::pile) l

		| (ACCESS x)::q -> begin
				   match lookup x l with
				   | VInt n -> aux q (n::pile) l
				   | _ -> failwith("La machine à pile a trouvé une variable qui n'est pas un entier.")
				 end
		(* Multiplication : On dépile deux variables pour les multiplier avant de rempiler le résultat *)
		| M::q -> begin
		            match pile with
		            | n1::n2::q2 -> aux q ((n1 * n2)::q2) l
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
		          
		(* Addition *)
		| A::q -> begin
			        match pile with
			        | n1::n2::q2 -> aux q ((n1 + n2)::q2) l
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
		          
		(* Soustraction *)
		| S::q -> begin
			        match pile with
			        | n1::n2::q2 -> aux q ((n1 - n2)::q2) l
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
		          
		(* On affiche le résultat sur le haut de la pile que l'on laisse pour poursuivre les calculs *)
		| P::q -> begin
		            match pile with
		            | n1::_ -> (print_int n1; print_newline (); aux q pile l)
		            | _ -> failwith("Erreur sur la machine à pile")
		        end
		(* Dans le cas d'un let, on dépile une valeur qu'on lie à x dans l'environnement *)
		| (LET x)::q -> begin
			     match pile with
			     | n::q2 -> l:=(x,VInt n)::(!l);
					aux q q2 l
			     | _ -> failwith("Erreur sur la machine à pile")
			      end
		| ENDLET::q -> pop_last l;
			       aux q pile l
	in
	aux code [] e;;
