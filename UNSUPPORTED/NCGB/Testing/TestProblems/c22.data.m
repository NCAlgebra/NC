SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**A+B**B+c**c,
	A**A-B**B,
	A**A-A,
	B**B-B-d,
	c**c-c**d,
	c**d-d
     };
