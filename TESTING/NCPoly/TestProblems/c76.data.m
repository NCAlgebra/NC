SetNonCommutative[x,y,invx,invy,inv1xy,inv1yx,inv1x];
ClearMonomialOrder[];
SetMonomialOrder[{x,y,invx,invy,inv1x,inv1xy,inv1yx},1];
Iterations=5;

rels={
	invx ** x -> 1,
	x ** invx -> 1,
	inv1x - x**inv1x - 1,
	inv1x - inv1x**x - 1
     };
