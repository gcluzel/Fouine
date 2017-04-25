open Expr

type instr =
    C of int
  | A
  | M
  | S
       
let rec compile:prog->instr list = fun p ->
  match p with
    Const n -> [C n]
  | Add (p1, p2) -> (compile p2)@(compile p1)@[A]
  | Mul(p1,p2) -> (compile p2)@(compile p1)@[M]
  | Min(p1,p2) -> (compile p2)@(compile p1)@[S]
  | _ -> failwith("Not yet implemented.")


let rec exec pile = 
	match pile with
	| [C n] -> n
	| (C n1)::(C n2)::A::q -> exec ((C (n1 + n2))::q)
	| (C n1)::(C n2)::M::q -> exec ((C (n1 * n2))::q)
	| (C n1)::(C n2)::S::q -> exec ((C (n1 - n2))::q)
	| _ -> failwith("Not a possible case")