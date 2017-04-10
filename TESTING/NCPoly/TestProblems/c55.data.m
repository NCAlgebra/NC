SNC[a,b,c,d,x,y,z,w,ia,ib,ic,id];
ClearMonomialOrder[];
SetMonomialOrder[{a,b,c,d,ia,ib,ic,id},1];
SetMonomialOrder[{z},2];
SetMonomialOrder[{x,y,w},3];
Iterations=4;

rels={
	d ** x -> 1 - z ** b,
	z ** y -> -d ** a,
	x ** z -> -a ** c,
	z ** b ** z -> z + d ** a ** c,
	y ** c -> 1 - b ** z
     };

invrel={};

rels=Join[rels,invrel] /. Rule -> Subtract;
