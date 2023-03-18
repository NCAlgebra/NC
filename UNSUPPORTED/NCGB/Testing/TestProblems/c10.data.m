SetNonCommutative[A,B,c];
SetKnowns[A];
SetUnknowns[B,c];

rels={
	A**c,
	A**B+B**c,
	A**A+B**B+c**c-1,
	B**A+c**B,
	c**A,

	B**B+2*c**c
     };
