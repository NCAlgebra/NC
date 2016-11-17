SetNonCommutative[TT,S,Invx,Invy,x,y];
ClearMonomialOrder[];
SetMonomialOrder[{x,y,Invx,Invy,S,TT},1];
Iterations=10;

rels={
	S**x - x**TT,
	Invx**S - TT**Invx,
	TT**y - y**TT,
	Invy**TT - TT**Invy,
	S**x**y - x**y**S,
	Invx**x - 1,
	x**Invx - 1,
	y**Invy - 1,
	Invy**y - 1
     };