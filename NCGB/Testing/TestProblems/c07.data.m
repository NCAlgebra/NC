SetNonCommutative[A,B,c];
SetKnowns[A];
SetUnknowns[B,c];

rels={
	A**B-c,
	B**c-A,
	c**A-B,
	A**B+B**c+c**A
     };
