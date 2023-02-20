SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B**A**B**c**d+d**c**B**A,
	B**A-A**B,
	B**c-c,
	A**B-d,
	d**c**d-1,
	B**B**B
     };
