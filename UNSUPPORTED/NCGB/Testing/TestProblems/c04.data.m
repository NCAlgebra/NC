SetNonCommutative[A,B,c];
SetKnowns[A];
SetUnknowns[B,c];

rels={
	A**B-c,
	B**A-c,
	c**A**c+c**B**c,
	c**c
     };
