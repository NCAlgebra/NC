SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B**A-c-d,
	A**A-1,
	c+d-1
     };
