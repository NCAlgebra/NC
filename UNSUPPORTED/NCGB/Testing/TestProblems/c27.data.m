SetNoncommutative[a,b,c,d];
SetKnowns[a,b];
SetUnknowns[c,d];

rels={
	a+b+c-d,
	d**a-a**d,
	d**b-b**d,
	d**c-c**d,
	a**a-a,
	b**b-b,
	c**c-c
     };
