SetNonCommutative[t,s,x,y];
ClearMonomialOrder[];
SetMonomialOrder[{x,y,inv[x],inv[y],s,t},1];
Iterations=10;

rels={
	s**x - x**t,
	inv[x]**s - t**inv[x],
	t**y - y**t,
	inv[y]**t - t**inv[y],
	s**x**y - x**y**s
     };