SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A+B+c+d,
	A**A,
	A**B-c,
	A**c,
	A**d-d
     };
