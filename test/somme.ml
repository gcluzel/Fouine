let a = ref 0 in
let rec f n m = 
  if n == 0 then
    begin
      if m == 0 then
	!a 
      else
        begin
          a := !a + 1;
          f 0 (m-1)
        end
    end
  else
    begin
      a := !a + 1;
      f (n-1) m
    end in
f 15 36;;
  
	
