(* 

  Same Frequency Response Function for systems
  mat1 and mat2 via a similarity on the state space.

             M mat1 == mat2 M
*)
Clear[SameFRF];
Clear[SameFRFRelations];

SameFRF[mat1:{{_,_},{_,_}},mat2:{{_,_},{_,_}},similarityOnState_] :=
Module[{similarity,nrows1,dims,zero,result},
   nrows1 = Dimensions[mat1[[2,1]]][[1]];
   dims = Dimensions[mat1[[1,1]]];
   Which[dims==={}, nrows2 = 1;
        , Length[dims]==2, newrows2 = dims[[1]];
        , True, Print[dims];BadCall["SameFRF",mat1,mat2,similarityOnState];
   ];
   similarity = {{similarityOnState,},{,1}};
   zero = Table[0,{j,1,nrows1}];
   similarity[[1,2]] = Table[zero,{j,1,nrows2}];
   similarity[[2,1]] = Transpose[similarity[[1,2]]];
   result = DeepMatMult[similarity,mat1] - 
            DeepMatMult[mat2,similarity]; 
   Return[result];
];

SameFRF[x___] := BadCall["SameFRF",x];

SameFRFRelations[mat1:{{_,_},{_,_}},mat2:{{_,_},{_,_}},
                 similarityOnState_] :=
           Flatten[SameFRF[mat1,mat2,similarityOnState]];

SameFRFRelations[x___] := BadCall["SameFRFRelations",x];
