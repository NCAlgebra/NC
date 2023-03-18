SetNonCommutative[A,B,c,d];
SetKnowns[A];
SetUnknowns[B,c,d];

rels={
	A**B-c,
	B**c-d,
	c**d-A,
	d**A-B,
	A**B+B**c+c**d+d**A
     };
