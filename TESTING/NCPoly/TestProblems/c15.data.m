SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B+B**c+c**d,
	A**B-B**A,
	B**c**B-c**B**c,
	c**c,
	A**d-d**A,
	d**d**d,
	B**B
     };

Interrupted = True;