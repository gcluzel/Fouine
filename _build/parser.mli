type token =
  | Int of (int)
  | Var of (string)
  | Let
  | In
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
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.prog
