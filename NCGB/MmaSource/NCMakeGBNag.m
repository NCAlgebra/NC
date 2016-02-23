(* WHATS THIS DO ?? BILL jan97*)

NCMakeGBNag[data_,it_Integer,s_String,options___Rule] :=
Module[{i,junk,ans,flag},
  flag = True;
  NCMakeGB[data,0,ReturnRelations->False,options];
  For[i=0,i<=it && flag, ++i,
    If[Not[i===0],MoraAlg`NCContinueMakeGB[i];];
       ans = WhatIsPartialGB[];
       CreateCategories[ans,junk];
       RegularOutput[junk,s<>"-"<>ToString[i]];
       ClearCategoryFactory[junk];
       (*flag = FinishedComputingBasisQ[];*)
  ];
  If[Head[data]===GBMarker
   , ans = ListToMarker[ans,"rules"];
  ];
  Return[ans];
];

NCMakeGBNag[x___] := BadCall["NCMakeGBNag",x];
