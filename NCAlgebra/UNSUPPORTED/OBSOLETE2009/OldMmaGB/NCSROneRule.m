Clear[NCSROneRule];
Clear[NCSROneRuleAux];
Clear[NCSROneRuleExpandInside];

NCSROneRule[expr_] := 
Module[{ans,oldans,j,saveitx,len,newind,bad,expr2},

(* Save old order *)
   len = WhatIsMultiplicityOfGradingOld[];
   Clear[saveitx];
   Do[ saveitx[j] = WhatIsSetOfIndeterminantsOld[j];
   ,{j,1,len}];

(* Discover the new order *)
   expr2 = ExpandNonCommutativeMultiply[expr]//.inv->Inv;
   expr2 = NCSROneRuleExpandInside[Inv,expr2];
   insides = Union[Grabs`GrabInsides[Inv,expr2]];
   bad = Select[insides,Not[Length[#]===1]&];
   If[Not[bad==={}] 
       , Print["One of your inverses has a different number of "];
         Print["arguments than one."];
         Print["Here is the list of offending insides:"];
         Print[bad];
         BadCall["NCSROneRule",expr]; 
   ];
   insides = ExpandNonCommutativeMultiply[insides];
   newind = Union[Grabs`GrabIndeterminants[insides],
                  Map[Inv,Flatten[insides]]];
   newind = Union[newind,Grabs`GrabIndeterminants[expr2]];
   
(* Set new order *)
   SetMultiplicityOfGrading[1];
   SetMonomialOrderOld[newind,1];

(* The work *)
   ans = expr2;
   While[Not[ans===oldans]
          , oldans = ans;
            ans = NCSROneRuleAux[ans];
            ans = ExpandNonCommutativeMultiply[ans];
   ];
   ans = ans//.Inv->inv;

(* Restore old order *)
   SetMultiplicityOfGrading[len];
   Do[ SetMonomialOrderOld[saveitx[j],j];
   ,{j,1,len}];
   Clear[saveitx];

   Return[ans];
];

NCSROneRule[x___] :=  BadCall["NCSROneRule",x];

NCSROneRuleAux[expr_] := 
Module[{insides,newrel,newexpr},
  insides = Grabs`GrabInsides[Inv,expr];
  insides = Map[First,insides];
  newrel = Map[{(#)**Inv[#]->1,Inv[#]**(#)->1}&,insides];
  newrel = Flatten[ExpandNonCommutativeMultiply[newrel]];
  newrel = Flatten[NCGBConvert[newrel]];
  newexpr = Transform[expr,newrel];
  Return[newexpr];
];

NCSROneRuleAux[x___] :=  BadCall["NCSROneRuleAux",x];

NCSROneRuleExpandInside[head_,expr_] := 
Module[{inside,result},
  If[Length[expr]==0
    , result = expr;
    , inside = Apply[List,expr];
      If[head===Head[expr]
        , result = Map[ExpandNonCommutativeMultiply,inside];
        , result = Map[NCSROneRuleExpandInside[head,#]&,inside];
      ];
      result = Apply[Head[expr],result];
  ];
  Return[result];
];

NCSROneRuleExpandInside[x___] :=  BadCall["NCSROneRuleExpandInside",x];
