%{
(* --- préambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lexèmes, ceux-ci sont décrits (par vous) dans lexer.mll */

%token <int> Int       /* le lexème INT a un attribut entier */
%token Plus Times Minus
%token L_par R_par
%token EOL             /* retour à la ligne */

%left Plus Minus  /* associativité gauche: a+b+c, c'est (a+b)+c */
%left Times  /* associativité gauche: a*b*c, c'est (a*b)*c */
%nonassoc Uminus  /* un "faux token", correspondant au "-" unaire */

%start main             /* "start" signale le point d'entrée: */
                        /* c'est ici main, qui est défini plus bas */
%type <Expr.expr> main     /* on _doit_ donner le type associé au point d'entrée */


main:                       /* <- le point d'entrée (cf. + haut, "start") */
    expr EOL                { $1 }  /* on veut reconnaître un "expr" */
;
expr:			    /* règles de grammaire pour les expressions */
  | INT                     { Const $1 }
  | L_par expr RPAREN      { $2 } /* on récupère le deuxième élément */
  | expr PLUS expr          { Add($1,$3) }
  | expr TIMES expr         { Mul($1,$3) }
  | expr MINUS expr         { Min($1,$3) }
  | MINUS expr %prec UMINUS { Min(Const 0, $2) }
;

