let a = ref 2 in
    if !a < 1 then
      (a := 4;
       PrInt !a)
    else
      (a := !a + 25;
       4 - PrInt !a)
;;
  (* Exemple d'utilisation de la fonction PrInt *)
