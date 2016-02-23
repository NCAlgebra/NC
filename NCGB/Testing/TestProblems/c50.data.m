SNC[a,b,c,d,x,y,z,w,ia,ib,ic,id];
SetMonomialOrder[{a,b,c,d,ia,ib,ic,id},1];
SetMonomialOrder[{z},2];
SetMonomialOrder[{x,y,w},3];
Iterations=4;
 
rels = {
	a**ia ->1,
	ia**a ->1,
	b**ib ->1,
	ib**b ->1,
	c**ic ->1,
	ic**c ->1,
	d**id ->1,
	id**d ->1
       };
