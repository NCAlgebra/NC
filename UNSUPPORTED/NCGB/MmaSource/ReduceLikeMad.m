<<OrderMaker.m	
<<OrderMaker2.m	
<<ClassFinder.m
<<ClassFinder2.m

Clear[ReduceLikeMad];

ReduceLikeMad[aList_List,variables_List] :=
Module[{allorders,j,result,shouldLoop,order,newresult},
  result = aList;
  shouldLoop = True;
  While[shouldLoop,
    allorders = AllOrders[result,variables];
    len = Length[allorders];
junk = allorders;
    shouldLoop = False;
    Do[order = allorders[[j]]; 
Print[j," th iteration:", order," out of ",len, " iterations." ];
Print["Starting with ", Length[result]," relations."];
       SetMultiplicityOfGrading[1];
       SetMonomialOrder[order,1];
       result= Flatten[Map[AddToDataBase,result]];
       newresult = CleanUpBasis[result];
       If[Length[newresult] < Length[result]
           , Print["Now have ", Length[newresult]," relations."];
             shouldLoop = True;
       ];
       result = WhatIsDataBase[newresult];
    ,{j,1,Length[allorders]}];
  ];
  Return[result];
];

ReduceLikeMad[x___] := BadCall["ReduceLikeMad",x];
