let g = fun x -> x + 1 in
let f = 
	try 
		raise (E (g 8))
	with E x -> x + 1
in
f;;