%{
(* --- pr�ambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lex�mes, ceux-ci sont d�crits (par vous) dans lexer.mll */

%token <int> Int       /* le lex�me INT a un attribut entier */
%token Plus Times Minus
%token L_par R_par
%token EOL             /* retour � la ligne */

%left Plus Minus  /* associativit� gauche: a+b+c, c'est (a+b)+c */
%left Times  /* associativit� gauche: a*b*c, c'est (a*b)*c */
%nonassoc Uminus  /* un "faux token", correspondant au "-" unaire */

%start main             /* "start" signale le point d'entr�e: */
                        /* c'est ici main, qui est d�fini plus bas */
%type <Expr.expr> main     /* on _doit_ donner le type associ� au point d'entr�e */


main:                       /* <- le point d'entr�e (cf. + haut, "start") */
    expr EOL                { $1 }  /* on veut reconna�tre un "expr" */
;
expr:			    /* r�gles de grammaire pour les expressions */
  | INT                     { Const $1 }
  | L_par expr RPAREN      { $2 } /* on r�cup�re le deuxi�me �l�ment */
  | expr PLUS expr          { Add($1,$3) }
  | expr TIMES expr         { Mul($1,$3) }
  | expr MINUS expr         { Min($1,$3) }
  | MINUS expr %prec UMINUS { Min(Const 0, $2) }
;

