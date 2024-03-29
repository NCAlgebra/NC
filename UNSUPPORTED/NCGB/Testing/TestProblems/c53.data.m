SetNonCommutative[a,b,c,d,x,y,z,w,ia,ib,ic,id];
SetMonomialOrder[{a,b,c,d,ia,ib,ic,id},1];
SetMonomialOrder[{z},2];
SetMonomialOrder[{x},3];
SetMonomialOrder[{y},4];
SetMonomialOrder[{w},5];
Iterations=4;

rels={
	z ** b ** z -> z + d ** a ** c,
	d ** x -> 1 - z ** b,
	y ** c -> 1 - b ** z,
	z ** y -> -d ** a,
	x ** z -> -a ** c
     };

invrel={
	a**ia ->1,
	ia**a ->1,
	b**ib ->1,
	ib**b ->1,
	c**ic ->1,
	ic**c ->1,
	d**id ->1,
	id**d ->1
       };

rels=Join[rels,invrel];
