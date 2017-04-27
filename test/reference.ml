let a = ref 2 in
    if !a < 1 then
      (a := 4;
       prInt !a)
    else
      (a := !a + 25;
       4 - prInt !a)
;;
  (* Exemple d'utilisation de la fonction PrInt *)
