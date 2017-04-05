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
  | EOF

open Parsing;;
let _ = parse_error;;
# 2 "parser.mly"
(* --- préambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

# 37 "parser.ml"
let yytransl_const = [|
  259 (* Let *);
  260 (* In *);
  261 (* Fun *);
  262 (* PrInt *);
  263 (* Right_arrow *);
  264 (* False *);
  265 (* True *);
  266 (* Let_rec *);
  267 (* If *);
  268 (* Then *);
  269 (* Else *);
  270 (* Plus *);
  271 (* Times *);
  272 (* Minus *);
  273 (* C_eq *);
  274 (* C_ge *);
  275 (* C_neq *);
  276 (* C_g *);
  277 (* C_l *);
  278 (* C_le *);
  279 (* L_par *);
  280 (* R_par *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* Int *);
  258 (* Var *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\006\000\
\006\000\007\000\004\000\004\000\005\000\005\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\000\000"

let yylen = "\002\000\
\002\000\001\000\001\000\001\000\003\000\003\000\003\000\002\000\
\003\000\006\000\002\000\006\000\005\000\006\000\005\000\001\000\
\002\000\003\000\001\000\004\000\003\000\002\000\001\000\001\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\003\000\004\000\000\000\000\000\000\000\000\000\
\000\000\000\000\032\000\000\000\000\000\016\000\000\000\000\000\
\000\000\023\000\024\000\000\000\000\000\000\000\008\000\000\000\
\000\000\000\000\000\000\001\000\000\000\017\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\005\000\000\000\009\000\000\000\
\000\000\000\000\022\000\000\000\000\000\000\000\000\000\000\000\
\000\000\025\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\018\000\021\000\000\000\000\000\013\000\000\000\015\000\
\000\000\000\000\012\000\014\000\010\000\020\000"

let yydgoto = "\002\000\
\011\000\053\000\022\000\054\000\033\000\013\000\014\000"

let yysindex = "\003\000\
\108\255\000\000\000\000\000\000\003\255\108\255\006\255\081\255\
\108\255\108\255\000\000\012\000\244\254\000\000\254\254\079\255\
\004\255\000\000\000\000\081\255\123\255\011\255\000\000\101\255\
\108\255\108\255\108\255\000\000\108\255\000\000\005\255\097\255\
\022\255\097\255\026\255\052\255\009\255\108\255\108\255\108\255\
\108\255\108\255\108\255\108\255\000\000\024\255\000\000\024\255\
\112\255\097\255\000\000\051\255\079\255\041\255\108\255\050\255\
\108\255\000\000\079\255\079\255\079\255\079\255\079\255\079\255\
\043\255\000\000\000\000\053\255\108\255\000\000\108\255\000\000\
\108\255\097\255\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\001\000\000\000\000\000\062\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\020\000\000\000\041\000\
\000\000\000\000\000\000\000\000\057\255\000\000\000\000\000\000\
\000\000\000\000\246\254\013\255\015\255\017\255\019\255\032\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\008\000\044\000\225\255\249\255\000\000\065\000"

let yytablesize = 342
let yytable = "\031\000\
\002\000\026\000\056\000\001\000\015\000\031\000\031\000\017\000\
\012\000\035\000\029\000\028\000\026\000\016\000\032\000\021\000\
\023\000\024\000\067\000\006\000\034\000\050\000\044\000\051\000\
\028\000\055\000\031\000\036\000\027\000\057\000\029\000\058\000\
\046\000\047\000\048\000\028\000\049\000\031\000\026\000\027\000\
\007\000\029\000\078\000\030\000\069\000\059\000\060\000\061\000\
\062\000\063\000\064\000\065\000\068\000\071\000\030\000\073\000\
\025\000\026\000\027\000\074\000\019\000\011\000\070\000\037\000\
\072\000\025\000\026\000\027\000\038\000\039\000\040\000\041\000\
\042\000\043\000\000\000\045\000\075\000\030\000\076\000\000\000\
\077\000\003\000\004\000\005\000\000\000\000\000\006\000\000\000\
\018\000\019\000\007\000\008\000\025\000\026\000\027\000\000\000\
\009\000\003\000\004\000\005\000\000\000\052\000\006\000\020\000\
\000\000\000\000\007\000\008\000\003\000\004\000\005\000\000\000\
\009\000\006\000\025\000\026\000\027\000\007\000\008\000\010\000\
\000\000\000\000\000\000\009\000\045\000\025\000\026\000\027\000\
\000\000\000\000\010\000\000\000\000\000\000\000\000\000\066\000\
\025\000\026\000\027\000\038\000\039\000\040\000\041\000\042\000\
\043\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\002\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\006\000\
\002\000\025\000\026\000\027\000\000\000\000\000\000\000\006\000\
\006\000\006\000\000\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\007\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\007\000\007\000\007\000\000\000\
\007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
\007\000\011\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\011\000\011\000\000\000\000\000\000\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000"

let yycheck = "\002\001\
\000\000\012\001\034\000\001\000\002\001\002\001\002\001\002\001\
\001\000\017\000\023\001\000\000\023\001\006\000\017\001\008\000\
\009\000\010\000\050\000\000\000\017\001\017\001\012\001\031\000\
\012\001\004\001\012\001\020\000\012\001\004\001\012\001\023\001\
\025\000\026\000\027\000\023\001\029\000\023\001\015\001\023\001\
\000\000\023\001\074\000\012\001\004\001\038\000\039\000\040\000\
\041\000\042\000\043\000\044\000\002\001\004\001\023\001\013\001\
\014\001\015\001\016\001\007\001\004\001\000\000\055\000\020\000\
\057\000\014\001\015\001\016\001\017\001\018\001\019\001\020\001\
\021\001\022\001\255\255\024\001\069\000\013\000\071\000\255\255\
\073\000\001\001\002\001\003\001\255\255\255\255\006\001\255\255\
\008\001\009\001\010\001\011\001\014\001\015\001\016\001\255\255\
\016\001\001\001\002\001\003\001\255\255\005\001\006\001\023\001\
\255\255\255\255\010\001\011\001\001\001\002\001\003\001\255\255\
\016\001\006\001\014\001\015\001\016\001\010\001\011\001\023\001\
\255\255\255\255\255\255\016\001\024\001\014\001\015\001\016\001\
\255\255\255\255\023\001\255\255\255\255\255\255\255\255\024\001\
\014\001\015\001\016\001\017\001\018\001\019\001\020\001\021\001\
\022\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\004\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\012\001\013\001\014\001\015\001\
\016\001\017\001\018\001\019\001\020\001\021\001\022\001\004\001\
\024\001\014\001\015\001\016\001\255\255\255\255\255\255\012\001\
\013\001\014\001\255\255\016\001\017\001\018\001\019\001\020\001\
\021\001\022\001\023\001\024\001\004\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\012\001\013\001\014\001\255\255\
\016\001\017\001\018\001\019\001\020\001\021\001\022\001\023\001\
\024\001\004\001\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\012\001\013\001\255\255\255\255\255\255\017\001\018\001\
\019\001\020\001\021\001\022\001\023\001\024\001"

let yynames_const = "\
  Let\000\
  In\000\
  Fun\000\
  PrInt\000\
  Right_arrow\000\
  False\000\
  True\000\
  Let_rec\000\
  If\000\
  Then\000\
  Else\000\
  Plus\000\
  Times\000\
  Minus\000\
  C_eq\000\
  C_ge\000\
  C_neq\000\
  C_g\000\
  C_l\000\
  C_le\000\
  L_par\000\
  R_par\000\
  EOF\000\
  "

let yynames_block = "\
  Int\000\
  Var\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Expr.prog) in
    Obj.repr(
# 45 "parser.mly"
                             ( _1 )
# 252 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'apply) in
    Obj.repr(
# 50 "parser.mly"
                                            ( _1 )
# 259 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 51 "parser.mly"
                                      ( Const _1 )
# 266 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 52 "parser.mly"
                                            ( Variable _1 )
# 273 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Expr.prog) in
    Obj.repr(
# 53 "parser.mly"
                                            ( _2 )
# 280 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 54 "parser.mly"
                                         ( Add(_1, _3) )
# 288 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 55 "parser.mly"
                                        ( Min(_1, _3) )
# 296 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 56 "parser.mly"
                                        ( Min(Const 0, _2) )
# 303 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 57 "parser.mly"
                                        ( Mul(_1, _3) )
# 311 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Expr.exprbool) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 58 "parser.mly"
                                            ( IfThenElse(_2,_4,_6) )
# 320 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 59 "parser.mly"
                                            ( PrInt _2 )
# 327 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 60 "parser.mly"
                                            ( Letin (_2, _4, _6) )
# 336 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 61 "parser.mly"
                                            ( Letin (_2, _3, _5) )
# 345 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 62 "parser.mly"
                                            ( RecFunction (_2, _4, _6) )
# 354 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 63 "parser.mly"
                                            ( RecFunction (_2, _3, _5) )
# 363 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'apply2) in
    Obj.repr(
# 67 "parser.mly"
                         ( _1 )
# 370 "parser.ml"
               : 'apply))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'apply) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'apply2) in
    Obj.repr(
# 68 "parser.mly"
                         ( ApplyFun (_1, _2) )
# 378 "parser.ml"
               : 'apply))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Expr.prog) in
    Obj.repr(
# 71 "parser.mly"
                                           ( _2 )
# 385 "parser.ml"
               : 'apply2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 75 "parser.mly"
                                  ( _1 )
# 392 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 76 "parser.mly"
                                  ( Fun(_2, _4) )
# 400 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 80 "parser.mly"
                               ( Fun(_1, _3) )
# 408 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 81 "parser.mly"
                               ( Fun(_1, _2) )
# 416 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    Obj.repr(
# 85 "parser.mly"
                            ( Vrai )
# 422 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "parser.mly"
                            ( Faux )
# 428 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Expr.exprbool) in
    Obj.repr(
# 87 "parser.mly"
                            ( _2 )
# 435 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 88 "parser.mly"
                            ( Eq(_1, _3) )
# 443 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 89 "parser.mly"
                            ( Gt(_1, _3) )
# 451 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 90 "parser.mly"
                            ( Ge(_1, _3) )
# 459 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 91 "parser.mly"
                            ( Lt(_1, _3) )
# 467 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 92 "parser.mly"
                            ( Le(_1, _3) )
# 475 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 93 "parser.mly"
                            ( Neq(_1, _3) )
# 483 "parser.ml"
               : Expr.exprbool))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Expr.prog)
