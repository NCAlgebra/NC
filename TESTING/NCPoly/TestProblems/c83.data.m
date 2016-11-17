(* This is a test file created from relations in the p5 problem given to 
us by Ben Keller.
*)

SetMonomialOrder[{j,i,h,g,f,e,d,c,b,a}];

rels=
{ a**c - b**i,
	d**e - c**a,
	f**g - e**d,
	h**j - g**f,
	i**b - j**h,
	a**d**f**h**i**a,
	d**f**h**i**a**d,
	f**h**i**a**d**f,
	h**i**a**d**f**h,
	i**a**d**f**h**i,
	b**j**g**e**c**b,
	j**g**e**c**b**j,
	g**e**c**b**j**g,
	e**c**b**j**g**e,
	c**b**j**g**e**c};
Iterations=6;
