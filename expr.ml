(* Un type pour les noms de variable *)
type var = string

  (* un type pour des expressions arithmétiques simples *)


(* un type pour les expressions booléennes *)
and exprbool =
    Eq of prog*prog
  | Gt of prog*prog
  | Ge of prog*prog
  | Lt of prog*prog
  | Le of prog*prog
  | Neq of prog*prog
  | Vrai
  | Faux

(* Le type pour les programmes fouine  et les expressions arithmétiques*)

type prog =
    Const of int
  | Variable of var
  | Add of prog*prog
  | Mul of prog*prog
  | Min of prog*prog    (* Les expressions arithmétiques jusque là *)
  | Function of var*var*prog (* nom de la fonction, nom de la variable puis la fonction proprement dite *)
  | Letin of var*prog*prog (* une affection puis un programme *)
  | RecFunction of var*var*prog (* nom de la fonction, nom de la variable, puis la fonction proprement dite *)
  | IfThenElse of exprbool*prog*prog (* la condition, puis le programme du if puis le programme du else *)

				   			  
(* fonction d'affichage d'un programme fouine *)
let rec affiche_prog_aux p =

  (* Affichage d'une expression booléenne *)
  let affiche_bool s e1 e2 pif pelse =
  begin
    affiche_prog_aux e1;
    print_string s;
    affiche_prog_aux e2;
    print_string ")\nthen\n";
    affiche_prog_aux pif;
    print_string "\nelse\n";
    affiche_prog_aux pelse;
  end
    and
(* affichage d'une expression arithmétique *)
let aff_aux s a b = 
  begin
    print_string "(";
    affiche_prog_aux a;
    print_string s;
    affiche_prog_aux b;
    print_string ")"
  end
  in
  match p with
    Variable s -> print_string s
  | Const k -> print_int k
  | Add(e1,e2) -> aff_aux "+" e1 e2
  | Mul(e1,e2) -> aff_aux "*" e1 e2
  | Min(e1,e2) -> aff_aux "-" e1 e2
  | Function (nom,variable,pp) -> begin
				  print_string "let ";
				  print_string nom;
				  print_string " = fun ";
				  print_string variable;
				  print_string " ->";
				  print_newline();
				  affiche_prog_aux pp;
				end
  | Letin (a,p1,p2) -> begin
		    print_string "let ";
		    print_string a;
		    print_string "=";
		    affiche_prog_aux p1;
		    print_string " in\n";
		    affiche_prog_aux p2;
		  end
  | RecFunction (nom,variable, pp) -> begin
				      print_string "let rec ";
				      print_string nom;
				      print_string " = fun ";
				      print_string variable;
				      print_string " ->";
				      print_newline();
				      affiche_prog_aux pp;
				    end
  | IfThenElse (cond,pif,pelse) -> begin
				   print_string "if (";
				   match cond with
				     Eq (e1,e2) -> affiche_bool "=" e1 e2 pif pelse;
				   | Neq (e1,e2) -> affiche_bool "!=" e1 e2 pif pelse;
				   | Gt(e1,e2) -> affiche_bool ">" e1 e2 pif pelse;
				   | Ge(e1,e2) -> affiche_bool ">=" e1 e2 pif pelse;
				   | Lt(e1,e2) -> affiche_bool "<" e1 e2 pif pelse;
				   | Le(e1,e2) -> affiche_bool "<=" e1 e2 pif pelse;
				   | Vrai -> print_string "true)\nthen\n";
					     affiche_prog_aux pif;
					     print_string "\nelse\n";
					     affiche_prog_aux pelse
				   | Faux -> print_string "false)\nthen\n";
					     affiche_prog pif;
					     print_string "\nelse\n";
					     affiche_prog_aux pelse
				 end

let affiche_prog p =
  begin
    affiche_prog_aux p;
    print_string ";;\n";
  end
