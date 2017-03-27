(* Un type pour les noms de variable *)
type var =
    Nom of string

(* un type pour des expressions arithmétiques simples *)
type expr =
    Const of int
  | Variable of var
  | Add of expr*expr
  | Mul of expr*expr
  | Min of expr*expr

(* un type pour les expressions booléennes *)
type exprbool =
    Eq of expr*expr
  | Gt of expr*expr
  | Ge of expr*expr
  | Lt of expr*expr
  | Le of expr*expr
		    
(* Le type pour les programmes fouine *)
type prog =
    ExprAr of expr
  | Function of var*prog
  | Letin of (* que mettre là ? *)*prog
  | RecFunction of var*prog
  | IfThenElse of exprbool*prog*prog


(* fonction d'affichage *)
let rec affiche_expr e =
  let aff_aux s a b = 
      begin
	print_string s;
	affiche_expr a;
	print_string ", ";
	affiche_expr b;
	print_string ")"
      end
  in
  match e with
  | Const k -> print_int k
  | Add(e1,e2) -> aff_aux "Add(" e1 e2
  | Mul(e1,e2) -> aff_aux "Mul(" e1 e2
  | Min(e1,e2) -> aff_aux "Min(" e1 e2

(* sémantique opérationnelle à grands pas *)
let rec eval = function
  | Const k -> k
  | Add(e1,e2) -> (eval e1) + (eval e2)
  | Mul(e1,e2) -> (eval e1) * (eval e2)
  | Min(e1,e2) -> (eval e1) - (eval e2)

  
