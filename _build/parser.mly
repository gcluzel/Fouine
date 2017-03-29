%{
(* --- pr�ambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lex�mes, ceux-ci sont d�crits (par vous) dans lexer.mll */

%token <int> Int       /* le lex�me INT a un attribut entier */
%token Let In
%token If Then Else
%token Plus Times Minus
%token L_par R_par
%token EOL             /* retour � la ligne */

%left Plus Minus  /* associativit� gauche: a+b+c, c'est (a+b)+c */
%left Times  /* associativit� gauche: a*b*c, c'est (a*b)*c */

%nonassoc Uminus Let In If Then Else Fun Right_arrow Let_rec C_g C_ge C_l C_le C_neq

%start main             /* "start" signale le point d'entr�e: */
                        /* c'est ici main, qui est d�fini plus bas */
%type <Expr.prog> main     /* on _doit_ donner le type associ� au point d'entr�e */
%type <Expr.expr>
%type <Expr.exprbool>                                                



main:                       /* <- le point d'entr�e (cf. + haut, "start") */
    prog EOL                { $1 } 
;
prog:			    /* r�gles de grammaire pour les expressions */
  | expr                    { $1 }
  | L_par prog RPAREN       { $2 } /* on r�cup�re le deuxi�me �l�ment */
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
         
