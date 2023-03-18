SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A+B+c-d,
	d**A-A**d,
	d**B-B**d,
	d**c-c**d,
	A**B-c,
	B**c-A,
	c**A-B
     };
