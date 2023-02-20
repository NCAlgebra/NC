SetNonCommutative[T,S,Invx,Invy,x,y];
SetMonomialOrder[{x,y,Invx,Invy,S,T},1];
Iterations=10;

rels={
	S**x - x**T,
	Invx**S - T**Invx,
	T**y - y**T,
	Invy**T - T**Invy,
	S**x**y - x**y**S,
	Invx**x - 1,
	x**Invx - 1,
	y**Invy - 1,
	Invy**y - 1
     };