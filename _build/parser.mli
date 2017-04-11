type token =
  | Int of (int)
  | Var of (string)
  | Let
  | In
  | Fun
  | PrInt
  | Right_arrow
  | False
  | True
  | Let_rec
  | If
  | Then
  | Else
  | Plus
  | Times
  | Minus
  | C_eq
  | C_ge
  | C_neq
  | C_g
  | C_l
  | C_le
  | L_par
  | R_par
  | Ref
  | Ref_aff
  | Bang
  | Pt_virg
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.prog
