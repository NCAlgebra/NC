(* This is a test file created from relations in the dcyc problem given to 
us by Ben Keller. 
*)

SetMonomialOrder[{a,d,f},{c,g},{b},{h,i,e}];

rels=
{
	a**b**c + d**i,
	c**a**b + h**g,
	b**c**a + f**e,
	i**d + i**a**f,
	e**f + e**b**h,
	g**h + g**c**d,
	f**i + f**g**c + b**h**i,
	d**g + d**e**b + a**f**g,
	h**e + h**i**a + c**d**e
};
Iterations=6;
