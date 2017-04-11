let a = 5 in
	let b = ref 8 in
		let f x = fun y -> y + x + a - -!b in
		f 4 (f 3 2);;
		
(* Un programme inutile juste pour tester, on doit obtenir 35 *)