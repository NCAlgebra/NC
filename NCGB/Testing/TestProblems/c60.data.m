SNC[a,b,c,d,x,y,z,w,ia,ib,ic,id,ix,iy,iz,iw];
SetMonomialOrder[{a,b,c,d,ia,ib,ic,id},1];
SetMonomialOrder[{x},2];
SetMonomialOrder[{y,w,z},3];
Iterations=4;

first ={{a,x},{y,b}};
second={{w,c},{d,z}};

rels=Flatten[{MatMult[first,second] - IdentityMatrix[2],
                 MatMult[second,first] - IdentityMatrix[2]}];
