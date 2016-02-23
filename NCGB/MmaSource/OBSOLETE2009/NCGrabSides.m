
NCGrabSides[x_] := NCGrabSides[x,WhatIsSetOfIndeterminants[1]];

NCGrabSides[x_,variables_List] := 
Module[{frags,result,equ},
  equ = NCCollectOnVariables[x,variables];
  frags = NCCollectOnVariablesAux[{equ},variables];
  result = Map[NCBothAux[equ,#]&,frags];
  result = Flatten[result];
  Return[result];
];

NCGrabSides[x___] := BadCall["NCGrabSides",x];

NCBothAux[aList_List,divisor_] := 
  Map[NCBothAux[#,divisor]&,aList];

NCBothAux[aRule_Rule,divisor_] := 
     NCBothAux[aRule[[1]]-aRule[[2]],divisor];

NCBothAux[aPolynomial_,divisor_] := 
Module[{asaList,result},
   If[Head[aPolynomial]===Plus
      , asaList = Apply[List,aPolynomial];
      , If[aPolynomial===0
          , asaList = {};
          , asaList = {aPolynomial};
        ];
   ];
   asaList = Map[NCMToList,asaList];
   divList = NCMToList[divisor];
   result = Map[bothsides[#,divList]&,asaList];
   result = Flatten[result];
   Return[result];
];

NCBothAux[x___] := BadCall["NCBothAux",x];

bothsides[factorList_List,divisorList_List] := 
Module[{start,vars,div,fLen,dLen,i,j,result},
  vars = Map[(#/LeadingCoefficient[#])&,factorList];
  div = Map[(#/LeadingCoefficient[#])&,divisorList];
  result = {};
  start = div[[1]];
  fLen = Length[factorList];
  dLen = Length[divisorList];
  Do[ If[vars[[i]]===start
        , If[Take[vars,{i,i+dLen-1}]===div
            , AppendTo[result,{
         Apply[NonCommutativeMultiply,Take[factorList,{1,i-1}]],
         Apply[NonCommutativeMultiply,Take[factorList,{i+dLen,-1}]]}
              ];
          ];
      ];
  ,{i,1,fLen-dLen+1}];
(*
If[Length[result]>0
   ,Print["Processing:",{factorList,divisorList}," gives ",result];
];
*)
  Return[result];
];

bothsides[x___] := BadCall["bothsides",x];
