let fact n =
  let rec aux n i =
    if n = 0 then
      i
    else
      aux (n - 1) (n * i)
  in
  aux n 1
    in
    fact 7;;

  (* Implémentation de la factiorelle avec une fonction auxilière *)
