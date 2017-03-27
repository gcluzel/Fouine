(* type programme pour traiter un programme*)
type fonction =
  | Expr 
type expr =
  | Const of int
  | Add of expr * expr
  | Mul of expr * expr
  | Min of expr * expr
  | Fonction of func
                    
type prog =
  | Var of string 
  | Expr of expr
