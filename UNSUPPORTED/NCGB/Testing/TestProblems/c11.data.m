SetNonCommutative[A,B,c];
SetKnowns[A];
SetUnknowns[B,c];

rels={
	A**B+c,
	A**c-B,
	A**A**B
     };

