SetNonCommutative[a,b,c,d,e,f];
ClearMonomialOrder[];
SetMonomialOrder[{a,b,c,d,e,f},1];
Iterations=5;

rels={
	a**b**c**d-e,
	b**c-f
     };
