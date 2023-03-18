Clear[NCSimplifyRationalX1];
Clear[NCSimplifyRationalX1Aux];
Clear[ExpandInside];

NCSimplifyRationalX1[expr_] := NCSimplifyRationalX1[expr,{}];

NCSimplifyRationalX1[expr_,extra_List] := NCSimplifyRationalX1[expr,extra,3];

NCSimplifyRationalX1[expr_,numberSteps_Integer] := NCSimplifyRationalX1[expr,{},3];

NCSimplifyRationalX1[expr_,extra_List,numberSteps_Integer] := 
Module[{ans,oldans,j,saveit,len,newind,bad,expr2,extra2},

   (* Save old order *)
   len = WhatIsMultiplicityOfGrading[];
   Clear[saveit];
   Do[ saveit[j] = WhatIsSetOfIndeterminants[j];
   ,{j,1,len}];

   (* Discover the new order *)
   expr2 = ExpandNonCommutativeMultiply[expr]//.inv->Inv;
   expr2 = expr2/.{Equal->Subtract,Rule->Subtract};
   expr2 = ExpandInside[Inv,expr2];
   extra2 = ExpandNonCommutativeMultiply[extra]//.inv->Inv;
   extra2 = ExpandInside[Inv,extra2];
(*
   insides = Union[Grabs`GrabInsides[Inv,{expr2,extra2}]];
   bad = Select[insides,Not[Length[#]===1]&];
   If[Not[bad==={}] 
       , Print["One of your inverses has a different number of "];
         Print["arguments than one."];
         Print["Here is the list of offending insides:"];
         Print[bad];
         BadCall["NCSimplifyRationalX1",expr]; 
   ];
   insides = ExpandNonCommutativeMultiply[insides];
   newind = Union[Grabs`GrabIndeterminants[insides],
                  Map[Inv,Flatten[insides]]];
   newind = Union[newind,Grabs`GrabIndeterminants[expr2]];

   (* Set new order *)
   ClearMonomialOrderAll[];
   SetMultiplicityOfGrading[1];
   SetMonomialOrder[newind,1];
*)

   (* The work *)
   ans = NCSimplifyRationalX1Aux[expr2,extra2,numberSteps];
   ans = ans//.Inv->inv;

   (* Restore old order *)
   ClearMonomialOrderAll[];
   SetMultiplicityOfGrading[len];
   Do[ SetMonomialOrder[saveit[j],j];
   ,{j,1,len}];
   Clear[saveit];

   Return[ans];
];

NCSimplifyRationalX1[x___] :=  BadCall["NCSimplifyRationalX1",x];

NCSimplifyRationalX1Aux[expr_,extra_List,numberSteps_Integer] := 
Module[{okL,ok2L,ok2,insides,newrel,newexpr,vars,ru},
  insides = Grabs`GrabInsides[Inv,expr];
  insides = Map[First,insides];
  newrel = Map[{(#)**Inv[#]->1,Inv[#]**(#)->1}&,insides];
  newrel = Flatten[ExpandNonCommutativeMultiply[newrel]];
  newrel = Join[newrel,extra];
  vars = Grabs`GrabIndeterminants[newrel];

  ClearMonomialOrderAll[];
  SetMonomialOrder[vars,1];
  okL =  Table[WhatIsSetOfIndeterminants[i]
                ,{i,1,WhatIsMultiplicityOfGrading[]}];
  okL = Flatten[okL];
  ok2L = Select[okL,Not[NonCommutativeMultiply`CommutativeQ[#]]&];
  ok2 = NonCommutativeMultiply`NCMPolynomialStrictQ[newrel,ok2L];
  If[ok2=!=True
    , Print["Sorry, but this generation of NCGB does not handle"
      ," commutative symbols efficiently. You can take the commutative "
      ,"symbol in the expression you just input and replace it with a "
      ,"rational number such as 7 or find an appropriate form of the "
      ,"expression where the commutative symbols becomes noncommutative."
      ,"This will fix the problem."];
      Print["The commutative expression is ",POLYS,"."];
      Print["All of the variables ",okL,"."];
      Print["All of the noncommuting variables ",ok2L,"."];
      Print["The commutative variables are ",Complement[okL,ok2L]];
      newexpr = expr;
    , ru = PolyToRule[NCMakeGB[newrel,numberSteps]];
      newexpr = Reduction[Flatten[{expr}],ru];
  ];
  Return[newexpr];
];

NCSimplifyRationalX1Aux[x___] :=  BadCall["NCSimplifyRationalX1Aux",x];

ExpandInside[head_,expr_] := 
Module[{inside,result},
  If[Length[expr]==0
    , result = expr;
    , inside = Apply[List,expr];
      If[head===Head[expr]
        , result = Map[ExpandNonCommutativeMultiply,inside];
        , result = Map[ExpandInside[head,#]&,inside];
      ];
      result = Apply[Head[expr],result];
  ];
  Return[result];
];

ExpandInside[x___] :=  BadCall["ExpandInside",x];
