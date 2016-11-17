SetNonCommutative[q2,q1,m,f,a,invm];
vars = {invm,q2,q1,m,f,a};
ClearMonomialOrder[];
SetMonomialOrder[vars,1];

rels={
	invm**m - 1,
	m**invm- 1,
	a**m - m**f - q1**q2
     };

Iterations=5;
