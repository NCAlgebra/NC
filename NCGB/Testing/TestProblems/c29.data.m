SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B**c**d-1,
	A**B-B**A,
	A**B**c-c**B**A,
	c**B**A-1
     };
