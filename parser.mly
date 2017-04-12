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
%token Plus Minus Times
%token C_eq C_ge C_neq C_g C_l C_le
%token L_par R_par
%token Ref Ref_aff Bang Pt_virg
%token Raise Excep Try With
%token EOF            /* fin du fichier */



%nonassoc PrInt
%nonassoc Fun Let Let_rec
%nonassoc In Right_arrow
%left Plus Minus          /* associativité gauche: a+b+c, c'est (a+b)+c */
%left Times               /* associativité gauche: a*b*c, c'est (a*b)*c */

%left Pt_virg                                                           
%nonassoc Ref Ref_aff Bang                
%nonassoc If Then Else      
%nonassoc R_par L_par C_g C_ge C_l C_le C_neq False True
%nonassoc Var
%nonassoc Uminus
                        
%type <Expr.prog>      main
%type <Expr.prog>      prog
%type <Expr.exprbool>  exprb
%type <Expr.prog>      fonction                                            
%type <Expr.prog>      fonction2
%type <Expr.prog>      apply1
%type <Expr.prog>      apply2
                         
                         
%start main

%%


 /* Point d'entrée du parser */  
main:
 | prog EOF                  { $1 } 
;

 /* Structure générale d'un programme */
prog:
  | prog Plus prog          	                { Add($1, $3) }
  | prog Minus prog        	                { Min($1, $3) }
  | Minus prog %prec Uminus	                { Min(Const 0, $2) }
  | prog Times prog        	                { Mul($1, $3) }
  | If exprb Then prog Else prog                { IfThenElse($2,$4,$6) }
  | PrInt prog                                  { PrInt $2 } 
  | Let Var C_eq fonction In prog               { Letin ($2, $4, $6) }
  | Let Var fonction2 In prog                   { Letin ($2, $3, $5) }
  | Let_rec Var C_eq fonction In prog           { RecFunction ($2, $4, $6) }
  | Let_rec Var fonction2 In prog               { RecFunction ($2, $3, $5) }
  | Let Var C_eq Ref prog In prog               { LetRef($2, $5, $7) }
  | Var Ref_aff prog Pt_virg prog               { RefAff($1, $3, $5) }
  | apply1                                      { $1 }
  | Raise L_par Excep prog R_par				{ Raise( Excep $4 ) }
  | Try prog With excep Right_arrow prog        { TryWith($2, $4, $6) }
;

excep:
  | Excep prog 					{ Excep $1 }

 /* pour l'application de fonctoins */
apply1:
  | L_par Fun Var Right_arrow fonction R_par apply2
                            { ApplyFun(Function($3, $5), $7) }
  | apply1 apply2           { ApplyFun($1, $2) }
  | apply2                  { $1 }

 /* suite des arguments dans l'évaluation de fonctions */
apply2:
  | L_par prog R_par          { $2 }
  | Int                       { Const $1 }
  | Var                       { Variable $1 }
  | Bang Var                  { Bang($2) }
;
 
 /* Déclaration d'une fonction à un ou plusieurs arguments */
fonction:
  | prog                          { $1 }
  | Fun Var Right_arrow fonction  { Function($2, $4) }
;

 /* Autres arguemnts dans la déclaration d'une fonction */
fonction2:
  | Var C_eq fonction          { Function($1, $3) }
  | Var fonction2              { Function($1, $2) }
;
 
 /* Règles pour les expressions booléennes */
exprb:
  | True                    { Vrai }
  | False                   { Faux }
  | L_par exprb R_par       { $2 }
  | prog C_eq prog          { Eq($1, $3) }
  | prog C_g prog           { Gt($1, $3) }
  | prog C_ge prog          { Ge($1, $3) }
  | prog C_l prog           { Lt($1, $3) }
  | prog C_le prog          { Le($1, $3) }
  | prog C_neq prog         { Neq($1, $3) }
  ;
           
