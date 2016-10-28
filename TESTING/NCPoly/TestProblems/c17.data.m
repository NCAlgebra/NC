SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B**A**B-c-d,
	A**A-1,
	c**c,
	c**d-d**c,
	B**B-c
     };
