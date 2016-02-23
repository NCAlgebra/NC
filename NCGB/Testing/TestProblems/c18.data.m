SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B**A**B**c**d,
	B**A-B,
	B**B-c,
	A**B-d,
	d**c**d-1
     };
