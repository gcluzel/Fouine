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


                           
%nonassoc Let In PrInt Let_rec
%left Fun Right_arrow
%left Plus Minus  /* associativité gauche: a+b+c, c'est (a+b)+c */
%left Times  /* associativité gauche: a*b*c, c'est (a*b)*c */
                                               
%nonassoc Uminus If Then Else C_g C_ge C_l C_le C_neq False True
             
                        
%type <Expr.prog>      main
%type <Expr.prog>      prog
%type <Expr.exprbool>  exprb
%type <Expr.prog>      fonction                                            
%type <Expr.prog>      fonction2

                         
                         
%start main

%%


  
main:
    | prog EOF                  { $1 } 
;
prog:
  | Int                  	            { Const $1 }
  | Var                                     { Variable $1 }
  | L_par prog R_par                        { $2 }
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
;
  

fonction:
  | prog                          { $1 }
  | Fun Var Right_arrow fonction  { Fun($2, $4) }


fonction2:
  | Var C_eq fonction          { Fun($1, $3) }
  | Var fonction2              { Fun($1, $2) }

        
exprb:
  | False                   { Vrai }
  | True                    { Faux }
  | L_par exprb L_par       { $2 }
  | prog C_eq prog          { Eq($1, $3) }
  | prog C_g prog           { Gt($1, $3) }
  | prog C_ge prog          { Ge($1, $3) }
  | prog C_l prog           { Lt($1, $3) }
  | prog C_le prog          { Le($1, $3) }
  | prog C_neq prog         { Neq($1, $3) }
  ;
           
