SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**A+B**B+c**c,
	A**B-B**A,
	A**A**A,
	B**B**c-A,
	B**B**B,
	c**B**B-A
     };
