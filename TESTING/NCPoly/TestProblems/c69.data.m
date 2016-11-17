SetNonCommutative[x,y,invx,invy,inv1xy,inv1yx,inv1x];
ClearMonomialOrder[];
SetMonomialOrder[{x,y,invx,invy,inv1x,inv1xy,inv1yx},1];

rels={
	invx ** x -> 1,
	x ** invx -> 1,
	invy ** y -> 1,
	y ** invy -> 1,
	x ** y ** inv1xy -> -(- inv1xy + 1),
	y ** x ** inv1yx -> -(- inv1yx + 1),
	inv1xy ** x ** y -> -(- inv1xy + 1),
	inv1yx ** y ** x -> -(- inv1yx + 1),
	inv1yx ** invx ->-(- y ** inv1xy - invx),
	inv1xy ** invy -> -(- x ** inv1yx - invy),
	invx ** inv1xy -> -(- y ** inv1xy - invx),
	invy ** inv1yx -> -(- x ** inv1yx - invy),
	inv1yx ** y -> -(- y ** inv1xy),
	inv1xy ** x -> -(- x ** inv1yx),
	inv1x - x**inv1x - 1,
	inv1x - inv1x**x - 1
     };

Iterations=5;
Interrupted = True;
