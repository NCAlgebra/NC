SaveVars[aList_,vars_] :=
Module[{len,j,save,temp,keep},
   len = Length[vars];
   save = {};
   Do[ var = vars[[j]];
       temp = Select[aList,Not[FreeQ[#,var]]&];
       If[Length[temp]===1
               , temp = temp[[1]];
                 If[temp[[1]]===var, AppendTo[save,temp]];
       ];
   ,{j,1,len}];
   keep = Complement[aList,save];
   Return[{keep,save}];
];
