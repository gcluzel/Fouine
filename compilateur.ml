open Expr

type instr =
    C of int
  | P
  | A
  | M
  | S
       
let rec compile:prog->instr list = fun p ->
  match p with
    Const n -> [C n]
  | PrInt p -> (compile p)@[P]
  | Add (p1, p2) -> (compile p2)@(compile p1)@[A]
  | Mul(p1,p2) -> (compile p2)@(compile p1)@[M]
  | Min(p1,p2) -> (compile p2)@(compile p1)@[S]
  | _ -> failwith("Not yet implemented.")
		  

let rec exec pile = 
	let rec aux p1 p2 =
		match p1 with
		| [] -> begin 
		          match p2 with
			      | [x] -> x
			      | _ -> failwith("impossible")
			    end
		| (C n)::q -> aux q (n::p2)
		| M::q -> begin
		            match p2 with
		            | n1::n2::q2 -> aux q ((n1 * n2)::q2)
		            | _ -> failwith("Erreur")
		          end
		| A::q -> begin
			        match p2 with
			        | n1::n2::q2 -> aux q ((n1 + n2)::q2)
		            | _ -> failwith("Erreur")
		          end
		| S::q -> begin
			        match p2 with
			        | n1::n2::q2 -> aux q ((n1 - n2)::q2)
		            | _ -> failwith("Erreur")
		          end
	in
	aux pile [];;
