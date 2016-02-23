Clear[Look];
Clear[unknownblocks];
Clear[unkblocks];
Clear[KnownQ];

Look[aList_List] := 
Module[{result},
   result = Map[Look,aList];
   result = Complement[Union[result],{}]; 
   Return[result];
];


Look[aRule_Rule] :=
Module[{LHS,RHS,asaList,ans,lengths,theMin,
        smallProducts,temp,item,len,j,result,shouldLoop},
   $GroebnerKnowns := MoraAlg`WhatIsSetOfIndeterminants[1];
   LHS = aRule[[1]];
   RHS = aRule[[2]];
   If[Head[RHS]===Plus, asaList = Apply[List,RHS];
                      , asaList = {RHS};
   ];
   PrependTo[asaList,LHS];

(* Now we have a list of monomials written as lists of their factors *)
   asaList = Map[NCMToList,asaList];
   lengths = {};
   theMin = Infinity;
Print["asaList",asaList];
   ans = Map[unknownblocks,asaList];
   ans = Union[Flatten[ans]];    
Print["ans1:",ans];
   If[ans==={}, Return[{}];];         
   lengths = Sort[Map[Length[NCMToList[#]]&,ans]];
   lengths = Complement[lengths,{0}];
   If[Not[lengths===Union[lengths]], Return[{}];];
   theMin = Apply[Min,lengths];
   smallProducts = Select[ans,(Length[NCMToList[#]]===theMin)&];
   smallProducts = smallProducts[[1]];
   temp = Union[Map[Head,lengths/theMin]];
   If[Not[temp==={Integer}], Return[{}];];
   shouldLoop = True;
   result = {aRule,smallProducts};
   For[j=1,And[j<=Length[ans],shouldLoop],j++,
       (* is ans[[j]] have the form of a product of things of min length ? *)
       item = ans[[j]];
       len = Length[NCMToList[item]]/theMin;
       temp = Table[smallProducts,{k,1,len}];
       temp = Apply[NonCommutativeMultiply,temp];
       If[Not[temp===item], shouldLoop = False;
                            result = {};
       ];
   ];
   Return[result];
];

Look[x___] := BadCall["Look",x];

KnownQ[x_] := MemberQ[$GroebnerKnowns,x];

KnownQ[x___] := BadCall["KnownQ",x];
   
unknownblocks[{var_,rest___}] := 
Module[{result},
  If[KnownQ[var], result = unknownblocks[{rest}]
                , result = unkblocks[var,{rest}]
                , BadCall["unknownblocks",{KnownQ[var],var,rest}];
  ];
  Return[result];
];

unknownblocks[{}] := {};

unknownblocks[x___] := BadCall["unknownblocks",x];

unkblocks[var_,aList_] := 
Module[{total,item,index,j,len},
   total = var;
   index = 0;
   len = Length[aList];
   loop = True;
   For[j=1,And[loop,j<=len],j++,
       item = aList[[j]];
       If[UnknownQ[item], total = total**item;
                          index = j;
                        , loop = False;
       ];
    ];
Print["1",{total}];
Print["2",unknownblocks[Take[aList,{index+1,-1}]]];
    Return[Join[{total},unknownblocks[Take[aList,{index+1,-1}]]]];
];
     
unkblocks[x___] := BadCall["unkblocks",x];

