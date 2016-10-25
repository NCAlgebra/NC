(*  SYSTEST *)
(*
	    User must load

        <<SYStems.m 

           before loading

        <<SYSTEST.m
            in order to run this file.

*)


Block[ {i},	

(* list of names used
DGY, GEz, IAX, IAXtest, IAYI, IAYItest, XX, YY, YYI, bterm, btermtest,
c, i, k, q, qpart, ruXXYYI, rua, ruc, rue, ruhomog, rulinearall, sHWo,
sHWoSub, temp1, temp2, temp3, temp4, x, z
*)

Print["------ Doing IAX derivation "];

sHWoSub = Substitute[sHWo,rue];
ruCritU = CriticalPoint[sHWoSub,c[z]];
temp1 = Substitute[ExpandNonCommutativeMultiply[Substitute[sHWoSub,ruCritU]],rue];
temp2 = Substitute[temp1,x->z];
temp3 = Substitute[temp2,ruXXYYI];
IAXtest = NCCollectSymmetric[temp3,XX[z]];
test[SYSTEST,1] = ExpandNonCommutativeMultiply[IAXtest - IAX[z]]==0;

Print[" "];
Print["----- Doing IAYI derivation "];
temp1 = sHWo//.z->0;
temp2 = Substitute[temp1,ruhomog];
temp1 = SubstituteSymmetric[temp2,ruXXYYI];
temp2 = SubstituteSymmetric[temp1,tp[GEz[x,0]]**b[0]->q[x,0]];
temp1 = Substitute[temp2,rue];
temp2 = CriticalPoint[temp1,tp[q[x,0]]];
temp3 = ExpandNonCommutativeMultiply[SubstituteSymmetric[temp1,temp2]];
IAYItest = NCCollectSymmetric[temp3,YYI[x]];
test[SYSTEST,2] = ExpandNonCommutativeMultiply[IAYItest - IAYI[x]]==0;

Print[" "];
Print["----- Doing q,k, and bterm derivation "];
temp1 = SubstituteSymmetric[sHWo,ruc];
temp2 = ExpandNonCommutativeMultiply[SubstituteSymmetric[temp1,rua]];
temp1 = SubstituteSymmetric[temp2,tp[GEz[x,z]]**b[z]->q[x,z]];
temp4 = SubstituteSymmetric[temp1,rue];
temp1 = CriticalPoint[temp4,tp[q[x,z]]];
K = ExpandNonCommutativeMultiply[SubstituteSymmetric[temp4,temp1]];
(*K = NCC[NCC[temp3,inv[e2[x]]],inv[e1[z]]];*)
test[SYSTEST,3] = ExpandNonCommutativeMultiply[K - k[x,z]]==0;

qpart = ExpandNonCommutativeMultiply[temp4 - (temp4//.q[x,z]->0)];
temp1 = qpart//.tp[q[x,z]]->0;
L = temp1//.q[x,z]->1;
Q = e2[x]/4;
btermtest = q[x,z]+tp[L]**inv[Q];
test[SYSTEST,4] = ExpandNonCommutativeMultiply[Substitute[bterm-btermtest/2,q[x,z]->tp[GEz[x,z]]**b[z]]]==0;

temp1 = Substitute[ExpandNonCommutativeMultiply[temp4-bterm**e2[x]**tp[bterm]-K],rue];
test[SYSTEST,5] = Substitute[temp1,q[x,z]->tp[GEz[x,z]]**b[z]]==0;

Print[" "];
Print["----- Verifying linear formulas"];
temp1 = ExpandNonCommutativeMultiply[SubstituteSymmetric[IAX[x],rulinearall]];
temp2 = Substitute[temp1,x->1];
test[SYSTEST,6] = ExpandNonCommutativeMultiply[temp2-DGX]==0;

temp1 = ExpandNonCommutativeMultiply[SubstituteSymmetric[IAYI[x],rulinearall]];
temp2 = Substitute[temp1,{x->1,ruinvYY}];
test[SYSTEST,7] = ExpandNonCommutativeMultiply[YY**temp2**YY - DGYY]==0;

(*------------------------------------------------*)

Print["Results from the file SYSTEST"];

For[ i=1, i<=7, i++,
   Print["Test #",i," was ",test[SYSTEST,i]];
];
]

