BackSolveAux[eqns_,eqn_,var_] :=
Module[{ru,ans},
   ru = NCSolveLinear1[eqn==0,var];
   ru = ru /. inv->Inv;
   ans = Transform[eqns,ru];
   Return[ans];
];

BackSolveAux[x___] := BadCall["BackSolveAux",x];

BackSolve[eqns_List,simple_List,{}] := eqns;

BackSolve[eqns_List,simple_List,var_List] := 
Module[{first,ans1,eq},
   first = var[[1]];
   eq = Select[simple,Not[FreeQ[#,first]]&];
   eq = Flatten[eq];
   If[Not[Length[eq]===1], BadCall["BackSolve",eqns,simple,var]];
   ans1 = BackSolveAux[eqns,eq[[1]],first];
   Return[BackSolve[ans1,Complement[simple,eq],Take[var,{2,-1}]]];
];

BackSolve[eqns_List,simple_,var_] :=  BackSolve[eqns,{simple},{var}];

BackSolve[x___] := BadCall["BackSolve",x];
