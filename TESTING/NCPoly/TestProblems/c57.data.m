SNC[a,b,c,d,x,y,z,w,ia,ib,ic,id,ix,iy,iz,iw];
ClearMonomialOrder[];
SetMonomialOrder[{a,b,c,d,ia,ib,ic,id},1];
SetMonomialOrder[{w},2];
SetMonomialOrder[{x,y,z},3];
Iterations=4;

first ={{a,x},{y,b}};
second={{w,c},{d,z}};

rels=Flatten[{NCDot[first,second] - IdentityMatrix[2],
                 NCDot[second,first] - IdentityMatrix[2]}];
