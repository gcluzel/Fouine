(* Un type pour les noms de variable *)
type var = string

  (* un type pour des expressions arithmétiques simples *)
and expr =
    Const of int
  | Variable of var
  | Add of expr*expr
  | Mul of expr*expr
  | Min of expr*expr

(* un type pour les expressions booléennes *)
and exprbool =
    Eq of expr*expr
  | Gt of expr*expr
  | Ge of expr*expr
  | Lt of expr*expr
  | Le of expr*expr
  | Neq of expr*expr

(* Le type pour les programmes fouine *)

type prog =
    ExprAr of expr (* une expression arithmétique *)
  | Function of var*var*prog (* nom de la fonction, nom de la variable puis la fonction proprement dite *)
  | Letin of var*prog*prog (* une affection puis un programme *)
  | RecFunction of var*var*prog (* nom de la fonction, nom de la variable, puis la fonction proprement dite *)
  | IfThenElse of exprbool*prog*prog (* la condition, puis le programme du if puis le programme du else *)

				   
(* fonction d'affichage d'une expression arithmétique *)
let rec affiche_expr e =
  let aff_aux s a b = 
      begin
	print_string "(";
	affiche_expr a;
	print_string s;
	affiche_expr b;
	print_string ")"
      end
  in
  match e with
    Variable s -> print_string s
  | Const k -> print_int k
  | Add(e1,e2) -> aff_aux "+" e1 e2
  | Mul(e1,e2) -> aff_aux "*" e1 e2
  | Min(e1,e2) -> aff_aux "-" e1 e2

(* fonction d'affichage d'un programme fouine *)
let rec affiche_prog_aux p =
  match p with
  | ExprAr e -> affiche_expr e
  | Function (nom,variable,pp) -> begin
				  print_string "let ";
				  print_stirng nom;
				  print_string " = fun ";
				  print_string variable;
				  print_string " ->";
				  print_newline();
				  affiche_prog_aux pp;
				end
  | Letin (a,p1,p2) -> begin
		    print_string "let ";
		  (* affichage du a ??? *)
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
				     Eq (e1,e2) -> begin
						  affiche_expr e1;
						  print_string "=";
						  affiche_expr e2;
						end
				   |  Gt (e1,e2) -> begin
						    affiche_expr e1;
						    print_string ">";
						    affiche_expr e2;
						  end
				   | Ge (e1,e2) -> begin
						   affiche_expr e1;
						   print_string ">=";
						   affiche_expr e2;
						 end
				   | Lt (e1,e2) -> begin
						   affiche_expr e1;
						   print_string "<";
						   affiche_expr e2;
						 end
				   | Eq (e1,e2) -> begin
						   affiche_expr e1;
						   print_string "<=";
						   affiche_expr e2;
						 end
				   print_string ")\nthen\n";
				   affiche_prog pif;
				   print_string "\nelse\n";
				   affiche_prog pelse;
				 end

let affiche_prog p =
  begin
    affiche_prog_aux p;
    print_string ";;";
  end
