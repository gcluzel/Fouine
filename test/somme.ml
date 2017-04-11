let s = ref 0 in
let rec somme n m =
  if n = 0 then
    begin
      if m = 0 then
	!s 
      else
        begin
          s := (!s + 1);
          somme 0 (m-1)
        end
    end
  else
    begin
      s := (!s + 1);
      somme (n-1) m
    end in
somme 15 36;;
  
  (*Somme de deux entiers. C'est nul de faire comme ça, mais c'est juste pour tester que ça marche bien*) 
