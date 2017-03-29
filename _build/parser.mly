%{
(* --- préambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lexèmes, ceux-ci sont décrits (par vous) dans lexer.mll */

%token <int> Int       /* le lexème INT a un attribut entier */
%token Let In
%token If Then Else
%token Plus Times Minus
%token L_par R_par
%token EOL             /* retour à la ligne */

%left Plus Minus  /* associativité gauche: a+b+c, c'est (a+b)+c */
%left Times  /* associativité gauche: a*b*c, c'est (a*b)*c */

%nonassoc Uminus Let In If Then Else Fun Right_arrow Let_rec C_g C_ge C_l C_le C_neq

%start main             /* "start" signale le point d'entrée: */
                        /* c'est ici main, qui est défini plus bas */
%type <Expr.prog> main     /* on _doit_ donner le type associé au point d'entrée */
%type <Expr.expr>
%type <Expr.exprbool>                                                



main:                       /* <- le point d'entrée (cf. + haut, "start") */
    prog EOL                { $1 } 
;
prog:			    /* règles de grammaire pour les expressions */
  | expr                    { $1 }
  | L_par prog RPAREN       { $2 } /* on récupère le deuxième élément */
  | Minus expr %prec Uminus { Min(Const 0, $2) }
  | Let var expr In prop    { Let(Id $2, $3, $5) }
  | If exprb Then prog Else Prog
                            { IfThenElse($2,$4,$6) }
  ;

exprb:
  | expr C_eq expr          { Eq($1, $3) }
  | expr C_g expr           { Gt($1, $3) }
  | expr C_ge expr          { Ge($1, $3) }
  | expr C_l expr           { Lt($1, $3) }
  | expr C_lt expr          { Le($1, $3) }
  | expr C_neq expr         { Neq($1, $3) }
  ;
    
expr:
  | Int                     { Const $1 }
  | expr Plus expr          { Add($1, $3) }    
  | expr Minus expr         { Min($1, $3) }
  | Minus expr %prec Uminus { Min(Const 0, $2) }
  | expr Times expr         { Mul($1, $3) }
         
