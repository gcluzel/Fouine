open Expr

type instr =
    C of int  (* Entier *)
  | P         (* Instruction d'affichage *)
  | A         (* Addition *)
  | M         (* Multiplication *)
  | S         (* Soustraction *)

(* Compilation d'un programme vers une pile pour la machine à pile *)     
let rec compile:prog->instr list = fun p ->
  match p with
    Const n -> [C n]
  | PrInt p -> (compile p)@[P]
  | Add (p1, p2) -> (compile p2)@(compile p1)@[A]
  | Mul(p1,p2) -> (compile p2)@(compile p1)@[M]
  | Min(p1,p2) -> (compile p2)@(compile p1)@[S]
  | _ -> failwith("Not yet implemented.")
		  

(* Execution de la machine à pile*)
let rec exec pile = 
	let rec aux p1 p2 =
		match p1 with
		| [] -> begin 
		          match p2 with
			      | [x] -> x
			      | _ -> failwith("impossible")
			    end
			    
	    (* Pour un nombre, on l'ajoute sur la deuxième pile *)
		| (C n)::q -> aux q (n::p2)
		
		(* Multiplication : On dépile deux variables pour les multiplier avant de rempiler le résultat *)
		| M::q -> begin
		            match p2 with
		            | n1::n2::q2 -> aux q ((n1 * n2)::q2)
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
		          
		(* Addition *)
		| A::q -> begin
			        match p2 with
			        | n1::n2::q2 -> aux q ((n1 + n2)::q2)
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
		          
		(* Soustraction *)
		| S::q -> begin
			        match p2 with
			        | n1::n2::q2 -> aux q ((n1 - n2)::q2)
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
		          
		(* On affiche le résultat sur le haut de la pile que l'on laisse pour poursuivre les calculs *)
		| P::q -> begin
		            match p2 with
		            | n1::_ -> (print_int n1; print_newline (); aux q p2)
		            | _ -> failwith("Erreur sur la machine à pile")
		          end
	in
	aux pile [];;
