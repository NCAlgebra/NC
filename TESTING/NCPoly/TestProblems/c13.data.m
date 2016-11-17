SetNonCommutative[A,B,c,d];
SetKnowns[A,B];
SetUnknowns[c,d];

rels={
	A**B**A+B**c**B,
	c**d**c+d**A**d,
	c**c**c,
	d**d**A,
	A**d**A
     };

Interrupted = True;
