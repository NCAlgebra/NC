SetNonCommutative[A,B,c];
SetKnowns[A];
SetUnknowns[B,c];

rels={
	A**B+c,
	A**c-B,
	c**A-B**c,
	A**A**B,
	B**A**A
     };

