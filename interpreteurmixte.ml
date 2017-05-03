open Expr


let rec purifier p =
  match p with
    Const n -> true
  | Variable x -> true
  | Add
