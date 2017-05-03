(* Un type pour les noms de variable *)
type var = string

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

and prog =
    Const of int
  | Variable of var
  | Add of prog*prog*bool
  | Mul of prog*prog*bool
  | Min of prog*prog*bool    (* Les expressions arithmétiques jusque là *)
  | Letin of var*prog*prog*bool (* une affection puis un programme *)
  | RecFunction of var*prog*prog (* nom de la fonction, nom de la variable, puis la fonction proprement dite *)
  | IfThenElse of exprbool*prog*prog (* la condition, puis le programme du if puis le programme du else *)
  | ApplyFun of prog*prog (* Quand on souhaite appliquer une fonction *)
  | Function of var*prog    (* La variable de la fonction et son programme (qui peut être une autre fun d'ailleurs si il y a plusieurs arguments) *)
  | PrInt of prog*bool    (* Pour l'affichage d'un entier *)
  | LetRef of var*prog*prog (* Pour les références *)
  | Bang of var    (* Pour déréférencer *)
  | RefAff of var*prog*prog (* On affecte un programme à une variable puis un programme suit *)
  | TryWith of prog*prog*prog (* Try prog with prog *)
  | Raise of prog (* On va récupérer l'erreur *)
  | Excep of prog (* Il faut calculer le numéro d'erreur *)
		      
(* un type pour ce que contient l'envrionnement, et un type pour l'envrironnement lui-même *)
type valeur =
    VInt of int
  | VFun of var*prog*env (* Un nom d'argument, du code et la cloture *)
  | VFunR of var*prog*env (* type pour les fonctions récursives *)
  | VRef of (int ref)
  | VErr of exn
	      
and env = (var*valeur) list ref
		       
exception E of int
				   			  
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
    
(* affichage d'une expression arithmétique *)
and aff_aux s a b = 
  begin
    print_string "(";
    affiche_prog_aux a;
    print_string " ";
    print_string s;
    print_string " ";
    affiche_prog_aux b;
    print_string ")"
  end
  in
  match p with
    Variable s -> print_string s
  | Const k -> print_int k
  | Add(e1,e2,_) -> aff_aux "+" e1 e2
  | Mul(e1,e2,_) -> aff_aux "*" e1 e2
  | Min(e1,e2,_) -> aff_aux "-" e1 e2
  | Function(var, pp) -> begin
                      print_string "fun ";
                      print_string var;
                      print_string " -> ";
                      affiche_prog_aux pp
                       end
  | Letin (a, Function(x, body), p,_) -> begin
				       print_string ("let "^a^"= fun "^x^"->\n");
				       affiche_prog_aux body;
				       print_string "\nin\n";
				       affiche_prog_aux p
				       end
  | Letin (a,p1,p2,_) -> begin
		    print_string "let ";
		    print_string a;
		    print_string " = ";
		    affiche_prog_aux p1;
		    print_string " in\n";
		    affiche_prog_aux p2;
		  end
  | RecFunction (nom, pp, psuite) -> begin
				      print_string "let rec ";
				      print_string nom;
				      print_string " = ";
				      affiche_prog_aux pp;
				      print_string " in\n";
				      affiche_prog_aux psuite
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
					     affiche_prog_aux pif;
					     print_string "\nelse\n";
					     affiche_prog_aux pelse
				 end
  | ApplyFun (f,x) -> begin
		      print_string "((";
                      affiche_prog_aux f;
		      print_string ") (";
		      affiche_prog_aux x;
		      print_string "))"
		    end
  | PrInt (x,_) -> begin
               print_string "PrInt(";
               affiche_prog_aux x;
               print_string ")\n"
               end
  | LetRef (x, p1, p2) -> begin
                          print_string "Let ";
                          print_string x;
                          print_string " = ref ";
                          affiche_prog_aux p1;
                          print_string " in\n";
                          affiche_prog_aux  p2
                          end
  | Bang(x) -> begin
               print_string "!";
               print_string x
               end
  | RefAff(x, p1, p2) -> begin
                         print_string x;
                         print_string " := ";
                         affiche_prog_aux p1;
                         print_string ";\n";
                         affiche_prog_aux p2;
                         end
  | TryWith (p1,e,p2) -> begin
			 print_string "try ";
			 affiche_prog_aux p1;
			 print_string "\nwith ";
			 affiche_prog_aux e;
			 print_string " -> ";
			 affiche_prog_aux p2;
		       end
  | Raise (p) -> begin
		 print_string "raise (";
		 affiche_prog_aux p;
		 print_string ")";
	       end
  | Excep (p) -> begin
		 print_string "E (";
		 affiche_prog_aux p;
		 print_string ")";
		 end
			   
                        
let affiche_prog p =
  begin
    affiche_prog_aux p;
    print_string ";;\n";
  end


(* Fonction lookup pour chercher la valeur d'une variable dans la pile *)
let rec lookup:var->env->valeur= fun x l ->
  match !l with
    [] -> failwith(x^" is not defined in the current environment.")
  | (s, v)::lp when x=s -> v
  (*| (s, VFun (x,body))::lp when x=s -> VFun (x,body)*)
  | (s,v)::lp -> l:=lp;
		 let res = lookup x l in
		 begin
		   l:=((s,v)::lp);
		   res
		 end

(* retire une valeur de la mémoire*)
let rec pop:var->env->unit = fun x l ->
  match !l with
    [] -> failwith("Suppressing a variable that wasn't in the environment.")
  | (s,v)::lp when x=s -> l:=lp
  | (s,v)::lp -> l:=lp;
		 pop x l;
		 l:=(s,v)::lp
 
(* Met à jour la valeur d'une référence dans la mémoire *)
let rec update (x : var) (l : env) (n : int) = 
  match !l with
  | [] -> failwith("The reference " ^ x ^ "is not in the current environment")
  | (s,VRef v)::lp when s = x -> v:=n
  | (s,v)::lp -> l := lp;
                 update x l n;
                 l := (s,v)::lp

let rec pop_last = fun l ->
  match !l with
    [] -> failwith("Empty environment, can't pop the last element.")
  | (x, v)::[] -> l:=[]
  | (x, v)::lp -> l:=lp;
		  pop_last l;
		  l:=(x,v)::(!l)
