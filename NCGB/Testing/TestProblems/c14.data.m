SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B+A**c+A**d,
	A**A-A,
	c**c,
	B**c-c**B,
	B**B-A
     };

