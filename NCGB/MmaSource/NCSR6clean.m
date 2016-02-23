Clear[NCSR6];
Clear[NCSR6Aux];
Clear[ExpandInside];

NCSR6[expr_] := NCSR6[expr,{}];

NCSR6[expr_,extra_List] := NCSR6[expr,extra,3];

NCSR6[expr_,numberSteps_Integer] := NCSR6[expr,{},3];

NCSR6[expr_,extra_List,numberSteps_Integer] := 
Module[{insides,ans,oldans,j,saveit,len,newind,bad,expr2,extra2},

(* Save old order *)
   len = WhatIsMultiplicityOfGrading[];
   Clear[saveit];
   Do[ saveit[j] = WhatIsSetOfIndeterminants[j];
   ,{j,1,len}];

(* Discover the new order *)
   expr2 = ExpandNonCommutativeMultiply[expr]//.inv->Inv;
   expr2 = ExpandInside[Inv,expr2];
   extra2 = ExpandNonCommutativeMultiply[extra]//.inv->Inv;
   extra2 = ExpandInside[Inv,extra2];
   insides = Union[Grabs`GrabInsides[Inv,{expr2,extra2}]];
   bad = Select[insides,Not[Length[#]===1]&];
   If[Not[bad==={}] 
       , Print["One of your inverses has a different number of "];
         Print["arguments than one."];
         Print["Here is the list of offending insides:"];
         Print[bad];
         BadCall["NCSR6",expr]; 
   ];
   insides = ExpandNonCommutativeMultiply[insides];
   newind = Union[Grabs`GrabIndeterminants[insides],
                  Map[Inv,Flatten[insides]]];
   newind = Union[newind,Grabs`GrabIndeterminants[expr2]];
   
(* Set new order *)
   SetMultiplicityOfGrading[1];
   SetMonomialOrder[newind,1];

(* The work *)
   ans = NCSR6Aux[expr2,extra,numberSteps];
   ans = ans//.Inv->inv;

(* Restore old order *)
   SetMultiplicityOfGrading[len];
   Do[ SetMonomialOrder[saveit[j],j];
   ,{j,1,len}];
   Clear[saveit];

   Return[ans];
];

NCSR6[x___] :=  BadCall["NCSR6",x];

NCSR6Aux[expr_,extra_List,numberSteps_Integer] := 
Module[{insides,newrel,newexpr,vars,ru},
  insides = Grabs`GrabInsides[Inv,expr];
  insides = Map[First,insides];
  newrel = Map[{(#)**Inv[#]->1,Inv[#]**(#)->1}&,insides];
  newrel = Flatten[ExpandNonCommutativeMultiply[newrel]];
  newrel = Join[newrel,extra];

  vars = Grabs`GrabIndeterminants[newrel];
  SetMonomialOrder[vars,1];
  ru = ToGBRule[NCMakeRules[newrel,numberSteps]];
  newexpr = Reduction[Flatten[{expr}],ru];
  Return[newexpr];
];

NCSR6Aux[x___] :=  BadCall["NCSR6Aux",x];

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
