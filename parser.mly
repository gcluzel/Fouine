%{
(* --- préambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lexèmes, ceux-ci sont décrits (par vous) dans lexer.mll */

%token <int> Int       /* le lexème INT a un attribut entier */
                          %token <string> Var
%token Let In Fun PrInt Right_arrow False True Let_rec
%token If Then Else
%token Plus Times Minus
%token C_eq C_ge C_neq C_g C_l C_le
%token L_par R_par
%token EOF            /* fin du fichier */



%nonassoc PrInt Let Let_rec Fun
%right Right_arrow
%right In
%left Plus Minus          /* associativité gauche: a+b+c, c'est (a+b)+c */
%left Times               /* associativité gauche: a*b*c, c'est (a*b)*c */

                                       
                                                            
%nonassoc If Then Else
%nonassoc Int        
%nonassoc R_par L_par C_g C_ge C_l C_le C_neq False True
%nonassoc Var
%nonassoc Uminus
                        
%type <Expr.prog>      main
%type <Expr.prog>      prog
%type <Expr.exprbool>  exprb
%type <Expr.prog>      fonction                                            
%type <Expr.prog>      fonction2
%type <Expr.prog>      apply
%type <Expr.prog>      apply2
                         
                         
%start main

%%


  
main:
 | prog EOF                  { $1 } 
;


prog:
  | prog Plus prog          	            { Add($1, $3) }
  | prog Minus prog        	            { Min($1, $3) }
  | Minus prog %prec Uminus	            { Min(Const 0, $2) }
  | prog Times prog        	            { Mul($1, $3) }
  | If exprb Then prog Else prog            { IfThenElse($2,$4,$6) }
  | PrInt prog                              { PrInt $2 } 
  | Let Var C_eq fonction In prog           { Letin ($2, $4, $6) }
  | Let Var fonction2 In prog               { Letin ($2, $3, $5) }
  | Let_rec Var C_eq fonction In prog       { RecFunction ($2, $4, $6) }
  | Let_rec Var fonction2 In prog           { RecFunction ($2, $3, $5) }
  | apply                                   { $1 } 
;

apply:
  | apply apply2              { ApplyFun ($1, $2) }
  | apply2                    { $1 }
;
  
apply2:
  | L_par prog R_par          { $2 }
  | Int                       { Const $1 }
  | Var                       { Variable $1 }
;
  
fonction:
  | prog                          { $1 }
  | Fun Var Right_arrow fonction  { Function($2, $4) }
;

fonction2:
  | Var C_eq fonction          { Function($1, $3) }
  | Var fonction2              { Function($1, $2) }
;
        
exprb:
  | False                   { Vrai }
  | True                    { Faux }
  | L_par exprb R_par       { $2 }
  | prog C_eq prog          { Eq($1, $3) }
  | prog C_g prog           { Gt($1, $3) }
  | prog C_ge prog          { Ge($1, $3) }
  | prog C_l prog           { Lt($1, $3) }
  | prog C_le prog          { Le($1, $3) }
  | prog C_neq prog         { Neq($1, $3) }
  ;
           
