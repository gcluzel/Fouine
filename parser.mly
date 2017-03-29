%{
(* --- préambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lexèmes, ceux-ci sont décrits (par vous) dans lexer.mll */

%token <int> Int       /* le lexème INT a un attribut entier */
%token <string> Var
%token Let In
%token If Then Else
%token Plus Times Minus
%token C_eq C_ge C_neq C_g C_l C_le
%token L_par R_par
%token EOF            /* fin du fichier */

%left Plus Minus  /* associativité gauche: a+b+c, c'est (a+b)+c */
%left Times  /* associativité gauche: a*b*c, c'est (a*b)*c */

%nonassoc Uminus Let In If Then Else Fun Right_arrow Let_rec C_g C_ge C_l C_le C_neq

             
                        
%type <Expr.prog>      main
%type <Expr.prog>      prog
%type <Expr.exprbool>  exprb
%type <Expr.expr>      expr

%start main

%%
       
main:
    | prog EOF                { $1 } 
;
prog:
  | expr                        { ExprAr $1 }
  | L_par prog R_par            { $2 }
  | Let Var C_eq expr In prog   { Let(Id $2, $4, $6) }
  | If exprb Then prog Else prog
                                { IfThenElse($2,$4,$6) }
  ;

exprb:
  | expr C_eq expr          { Eq($1, $3) }
  | expr C_g expr           { Gt($1, $3) }
  | expr C_ge expr          { Ge($1, $3) }
  | expr C_l expr           { Lt($1, $3) }
  | expr C_le expr          { Le($1, $3) }
  | expr C_neq expr         { Neq($1, $3) }
  ;
    
expr:
  | Int                     { Const $1 }
  | L_par expr R_par        { $2 }
  | expr Plus expr          { Add($1, $3) }    
  | expr Minus expr         { Min($1, $3) }
  | Minus expr %prec Uminus { Min(Const 0, $2) }
  | expr Times expr         { Mul($1, $3) }
  ; /* il faudrait rajouter l'évaluation de fonction */         
