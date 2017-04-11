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

open Parsing;;
let _ = parse_error;;
# 2 "parser.mly"
(* --- pr�ambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

# 41 "parser.ml"
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
  281 (* Ref *);
  282 (* Ref_aff *);
  283 (* Bang *);
  284 (* Pt_virg *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* Int *);
  258 (* Var *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\006\000\006\000\
\006\000\007\000\007\000\007\000\007\000\004\000\004\000\005\000\
\005\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\000\000"

let yylen = "\002\000\
\002\000\003\000\003\000\002\000\003\000\006\000\002\000\006\000\
\005\000\006\000\005\000\007\000\005\000\001\000\007\000\002\000\
\001\000\003\000\001\000\001\000\002\000\001\000\004\000\003\000\
\002\000\001\000\001\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\019\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\035\000\000\000\000\000\017\000\000\000\
\000\000\000\000\000\000\027\000\026\000\000\000\000\000\000\000\
\004\000\000\000\000\000\021\000\000\000\000\000\000\000\001\000\
\020\000\000\000\016\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\018\000\000\000\005\000\000\000\000\000\
\000\000\025\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\024\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\006\000\000\000\023\000\000\000\015\000"

let yydgoto = "\002\000\
\012\000\061\000\024\000\062\000\039\000\014\000\015\000"

let yysindex = "\013\000\
\185\255\000\000\000\000\013\255\025\255\185\255\048\255\093\255\
\185\255\148\255\050\255\000\000\016\000\011\255\000\000\185\255\
\001\255\075\255\009\255\000\000\000\000\065\255\210\255\044\255\
\000\000\056\255\114\255\000\000\185\255\185\255\185\255\000\000\
\000\000\185\255\000\000\091\255\015\255\121\255\057\255\167\255\
\059\255\199\255\053\255\185\255\185\255\185\255\185\255\185\255\
\185\255\185\255\076\255\000\000\072\255\000\000\072\255\185\255\
\167\255\000\000\095\255\185\255\075\255\089\255\185\255\104\255\
\185\255\000\000\075\255\075\255\075\255\075\255\075\255\075\255\
\126\255\167\255\075\255\000\000\103\255\021\255\185\255\075\255\
\185\255\075\255\185\255\087\255\167\255\185\255\075\255\075\255\
\000\000\011\255\000\000\075\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\022\000\000\000\000\000\
\000\000\079\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\041\000\000\000\060\000\000\000\
\000\000\000\000\000\000\000\000\000\255\000\000\000\000\000\000\
\000\000\000\000\007\255\030\255\041\255\045\255\060\255\088\255\
\000\000\000\000\098\000\000\000\000\000\000\000\000\000\117\000\
\000\000\136\000\000\000\000\000\000\000\000\000\155\000\174\000\
\000\000\000\000\000\000\193\000\000\000"

let yygindex = "\000\000\
\000\000\255\255\091\000\222\255\239\255\000\000\252\255"

let yytablesize = 477
let yytable = "\013\000\
\020\000\041\000\037\000\022\000\018\000\064\000\023\000\025\000\
\027\000\035\000\037\000\003\000\033\000\001\000\036\000\032\000\
\037\000\038\000\029\000\058\000\042\000\014\000\076\000\022\000\
\086\000\040\000\017\000\053\000\054\000\055\000\029\000\057\000\
\027\000\034\000\029\000\030\000\031\000\011\000\016\000\084\000\
\002\000\031\000\067\000\068\000\069\000\070\000\071\000\072\000\
\073\000\019\000\091\000\028\000\034\000\031\000\075\000\050\000\
\030\000\051\000\078\000\003\000\063\000\080\000\065\000\082\000\
\034\000\003\000\004\000\005\000\030\000\026\000\006\000\032\000\
\020\000\021\000\007\000\008\000\066\000\087\000\007\000\088\000\
\009\000\089\000\074\000\032\000\092\000\093\000\030\000\022\000\
\029\000\030\000\031\000\011\000\079\000\003\000\004\000\005\000\
\077\000\013\000\006\000\033\000\020\000\021\000\007\000\008\000\
\029\000\030\000\031\000\081\000\009\000\085\000\090\000\033\000\
\043\000\000\000\000\000\022\000\009\000\000\000\056\000\011\000\
\000\000\003\000\004\000\005\000\000\000\059\000\006\000\029\000\
\030\000\031\000\007\000\008\000\000\000\000\000\000\000\011\000\
\009\000\052\000\083\000\029\000\030\000\031\000\000\000\010\000\
\000\000\060\000\000\000\011\000\003\000\004\000\005\000\000\000\
\026\000\006\000\008\000\000\000\000\000\007\000\008\000\000\000\
\000\000\000\000\000\000\009\000\000\000\000\000\000\000\003\000\
\004\000\005\000\010\000\059\000\006\000\010\000\011\000\000\000\
\007\000\008\000\000\000\000\000\000\000\000\000\009\000\000\000\
\000\000\003\000\004\000\005\000\000\000\010\000\006\000\000\000\
\012\000\011\000\007\000\008\000\000\000\000\000\000\000\000\000\
\009\000\000\000\000\000\000\000\000\000\000\000\000\000\010\000\
\000\000\000\000\000\000\011\000\029\000\030\000\031\000\044\000\
\045\000\046\000\047\000\048\000\049\000\000\000\052\000\029\000\
\030\000\031\000\044\000\045\000\046\000\047\000\048\000\049\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\020\000\020\000\000\000\020\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\020\000\020\000\020\000\020\000\
\020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
\020\000\014\000\000\000\020\000\020\000\029\000\030\000\031\000\
\000\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
\014\000\014\000\014\000\014\000\002\000\014\000\000\000\000\000\
\000\000\014\000\000\000\000\000\002\000\002\000\002\000\000\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\003\000\
\002\000\000\000\000\000\000\000\002\000\000\000\000\000\003\000\
\003\000\003\000\000\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\007\000\003\000\000\000\000\000\000\000\003\000\
\000\000\000\000\007\000\007\000\000\000\000\000\000\000\007\000\
\007\000\007\000\007\000\007\000\007\000\013\000\007\000\000\000\
\000\000\000\000\007\000\000\000\000\000\013\000\013\000\000\000\
\000\000\000\000\013\000\013\000\013\000\013\000\013\000\013\000\
\009\000\013\000\000\000\000\000\000\000\013\000\000\000\000\000\
\009\000\009\000\000\000\000\000\000\000\009\000\009\000\009\000\
\009\000\009\000\009\000\011\000\009\000\000\000\000\000\000\000\
\009\000\000\000\000\000\011\000\011\000\000\000\000\000\000\000\
\011\000\011\000\011\000\011\000\011\000\011\000\008\000\011\000\
\000\000\000\000\000\000\011\000\000\000\000\000\008\000\008\000\
\000\000\000\000\000\000\008\000\008\000\008\000\008\000\008\000\
\008\000\010\000\008\000\000\000\000\000\000\000\008\000\000\000\
\000\000\010\000\010\000\000\000\000\000\000\000\010\000\010\000\
\010\000\010\000\010\000\010\000\012\000\010\000\000\000\000\000\
\000\000\010\000\000\000\000\000\012\000\012\000\000\000\000\000\
\000\000\012\000\012\000\012\000\012\000\012\000\012\000\000\000\
\012\000\000\000\000\000\000\000\012\000"

let yycheck = "\001\000\
\000\000\019\000\002\001\004\001\006\000\040\000\008\000\009\000\
\010\000\014\000\002\001\001\001\002\001\001\000\016\000\000\000\
\002\001\017\001\012\001\037\000\022\000\000\000\057\000\024\001\
\004\001\017\001\002\001\029\000\030\000\031\000\024\001\017\001\
\034\000\023\001\014\001\015\001\016\001\027\001\026\001\074\000\
\000\000\012\001\044\000\045\000\046\000\047\000\048\000\049\000\
\050\000\002\001\085\000\002\001\012\001\024\001\056\000\012\001\
\012\001\002\001\060\000\000\000\004\001\063\000\004\001\065\000\
\024\001\001\001\002\001\003\001\024\001\005\001\006\001\012\001\
\008\001\009\001\010\001\011\001\024\001\079\000\000\000\081\000\
\016\001\083\000\007\001\024\001\086\000\090\000\015\001\023\001\
\014\001\015\001\016\001\027\001\004\001\001\001\002\001\003\001\
\002\001\000\000\006\001\012\001\008\001\009\001\010\001\011\001\
\014\001\015\001\016\001\004\001\016\001\007\001\024\001\024\001\
\022\000\255\255\255\255\023\001\000\000\255\255\028\001\027\001\
\255\255\001\001\002\001\003\001\255\255\005\001\006\001\014\001\
\015\001\016\001\010\001\011\001\255\255\255\255\255\255\000\000\
\016\001\024\001\013\001\014\001\015\001\016\001\255\255\023\001\
\255\255\025\001\255\255\027\001\001\001\002\001\003\001\255\255\
\005\001\006\001\000\000\255\255\255\255\010\001\011\001\255\255\
\255\255\255\255\255\255\016\001\255\255\255\255\255\255\001\001\
\002\001\003\001\023\001\005\001\006\001\000\000\027\001\255\255\
\010\001\011\001\255\255\255\255\255\255\255\255\016\001\255\255\
\255\255\001\001\002\001\003\001\255\255\023\001\006\001\255\255\
\000\000\027\001\010\001\011\001\255\255\255\255\255\255\255\255\
\016\001\255\255\255\255\255\255\255\255\255\255\255\255\023\001\
\255\255\255\255\255\255\027\001\014\001\015\001\016\001\017\001\
\018\001\019\001\020\001\021\001\022\001\255\255\024\001\014\001\
\015\001\016\001\017\001\018\001\019\001\020\001\021\001\022\001\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\001\001\002\001\255\255\004\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\012\001\013\001\014\001\015\001\
\016\001\017\001\018\001\019\001\020\001\021\001\022\001\023\001\
\024\001\004\001\255\255\027\001\028\001\014\001\015\001\016\001\
\255\255\012\001\013\001\014\001\015\001\016\001\017\001\018\001\
\019\001\020\001\021\001\022\001\004\001\024\001\255\255\255\255\
\255\255\028\001\255\255\255\255\012\001\013\001\014\001\255\255\
\016\001\017\001\018\001\019\001\020\001\021\001\022\001\004\001\
\024\001\255\255\255\255\255\255\028\001\255\255\255\255\012\001\
\013\001\014\001\255\255\016\001\017\001\018\001\019\001\020\001\
\021\001\022\001\004\001\024\001\255\255\255\255\255\255\028\001\
\255\255\255\255\012\001\013\001\255\255\255\255\255\255\017\001\
\018\001\019\001\020\001\021\001\022\001\004\001\024\001\255\255\
\255\255\255\255\028\001\255\255\255\255\012\001\013\001\255\255\
\255\255\255\255\017\001\018\001\019\001\020\001\021\001\022\001\
\004\001\024\001\255\255\255\255\255\255\028\001\255\255\255\255\
\012\001\013\001\255\255\255\255\255\255\017\001\018\001\019\001\
\020\001\021\001\022\001\004\001\024\001\255\255\255\255\255\255\
\028\001\255\255\255\255\012\001\013\001\255\255\255\255\255\255\
\017\001\018\001\019\001\020\001\021\001\022\001\004\001\024\001\
\255\255\255\255\255\255\028\001\255\255\255\255\012\001\013\001\
\255\255\255\255\255\255\017\001\018\001\019\001\020\001\021\001\
\022\001\004\001\024\001\255\255\255\255\255\255\028\001\255\255\
\255\255\012\001\013\001\255\255\255\255\255\255\017\001\018\001\
\019\001\020\001\021\001\022\001\004\001\024\001\255\255\255\255\
\255\255\028\001\255\255\255\255\012\001\013\001\255\255\255\255\
\255\255\017\001\018\001\019\001\020\001\021\001\022\001\255\255\
\024\001\255\255\255\255\255\255\028\001"

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
  Ref\000\
  Ref_aff\000\
  Bang\000\
  Pt_virg\000\
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
# 52 "parser.mly"
                             ( _1 )
# 306 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 57 "parser.mly"
                                             ( Add(_1, _3) )
# 314 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 58 "parser.mly"
                                            ( Min(_1, _3) )
# 322 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 59 "parser.mly"
                                            ( Min(Const 0, _2) )
# 329 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 60 "parser.mly"
                                            ( Mul(_1, _3) )
# 337 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : Expr.exprbool) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 61 "parser.mly"
                                                ( IfThenElse(_2,_4,_6) )
# 346 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 62 "parser.mly"
                                                ( PrInt _2 )
# 353 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 63 "parser.mly"
                                                ( Letin (_2, _4, _6) )
# 362 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 64 "parser.mly"
                                                ( Letin (_2, _3, _5) )
# 371 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 65 "parser.mly"
                                                ( RecFunction (_2, _4, _6) )
# 380 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 66 "parser.mly"
                                                ( RecFunction (_2, _3, _5) )
# 389 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 67 "parser.mly"
                                                ( LetRef(_2, _5, _7) )
# 398 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 68 "parser.mly"
                                                ( RefAff(_1, _3, _5) )
# 407 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 69 "parser.mly"
                                                ( _1 )
# 414 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 74 "parser.mly"
                            ( ApplyFun(Function(_3, _5), _7) )
# 423 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Expr.prog) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 75 "parser.mly"
                            ( ApplyFun(_1, _2) )
# 431 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 76 "parser.mly"
                            ( _1 )
# 438 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Expr.prog) in
    Obj.repr(
# 79 "parser.mly"
                              ( _2 )
# 445 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 80 "parser.mly"
                              ( Const _1 )
# 452 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 81 "parser.mly"
                              ( Variable _1 )
# 459 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 82 "parser.mly"
                              ( Bang(_2) )
# 466 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 86 "parser.mly"
                                  ( _1 )
# 473 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 87 "parser.mly"
                                  ( Function(_2, _4) )
# 481 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 91 "parser.mly"
                               ( Function(_1, _3) )
# 489 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 92 "parser.mly"
                               ( Function(_1, _2) )
# 497 "parser.ml"
               : Expr.prog))
; (fun __caml_parser_env ->
    Obj.repr(
# 96 "parser.mly"
                            ( Vrai )
# 503 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    Obj.repr(
# 97 "parser.mly"
                            ( Faux )
# 509 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Expr.exprbool) in
    Obj.repr(
# 98 "parser.mly"
                            ( _2 )
# 516 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 99 "parser.mly"
                            ( Eq(_1, _3) )
# 524 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 100 "parser.mly"
                            ( Gt(_1, _3) )
# 532 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 101 "parser.mly"
                            ( Ge(_1, _3) )
# 540 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 102 "parser.mly"
                            ( Lt(_1, _3) )
# 548 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 103 "parser.mly"
                            ( Le(_1, _3) )
# 556 "parser.ml"
               : Expr.exprbool))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Expr.prog) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Expr.prog) in
    Obj.repr(
# 104 "parser.mly"
                            ( Neq(_1, _3) )
# 564 "parser.ml"
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