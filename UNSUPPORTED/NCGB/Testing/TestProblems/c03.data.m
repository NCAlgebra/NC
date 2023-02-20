SetNonCommutative[a,b,c];
SetKnowns[a];
SetUnknowns[b,c];

rels={
	a**b-b**c,
	b**a-a**c,
	a**a+b**b+a**c+b**c,
        c**c**c
     };
