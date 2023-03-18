SNC[a,b,c,d,x,y,z,w,ia,ib,ic,id,ix,iy,iz,iw];
SetMonomialOrder[{x,y,z,w},1];
SetMonomialOrder[{d},2];
SetMonomialOrder[{a,b,c},3];
Iterations=4;

first ={{a,x},{y,b}};
second={{w,c},{d,z}};

rels=Flatten[{MatMult[first,second] - IdentityMatrix[2],
                 MatMult[second,first] - IdentityMatrix[2]}];
