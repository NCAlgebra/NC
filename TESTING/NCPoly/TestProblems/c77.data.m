SetNonCommutative[x,y,invx,invy,inv1x,inv1y,inv1xy,inv1yx];
ClearMonomialOrder[];
SetMonomialOrder[{x,y,invx,invy,inv1x,inv1y,inv1xy,inv1yx},1];
Iterations=5;

rels={
	x**invx - 1,
	invx**x - 1,
	inv1x - x**inv1x - 1,
	inv1x - inv1x**x - 1,
	x**x - x
     };
