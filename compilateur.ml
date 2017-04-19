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
