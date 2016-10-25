Clear[UniversalBasis];
Clear[NoEquivalent];
Clear[EquivalentQ];
Clear[FitsQ];
Clear[WhereInList];
Clear[ToRuleTuples];

UniversalBasis[F_List]:= UniversalBasis[F,10]; 

UniversalBasis[F_List,iterations_]:= 
Module[{U,newclasses,variables,o,G,g,m},
       U={};
       variables=GrabIndeterminants[F];
       G=F;
       o=AllOrders[G,variables];
       While[Not[o==={}],
             m=Length[o];
             Do[
                SetMonomialOrderOld[o[[j]],1];
Print["Beginning algorithm for order ", o[[j]]];
                g[j]=NCMakeGBOld[G,iterations,
                                 NCSCleanUpRulesOld->False,
                                 PropogateReductionFlag-> True,
                                 LotsOfOutput-> True
                                ];
                ,{j,1,m} 
             ];
             G=Union[Flatten[Table[g[i],{i,1,m}]]];
             U=Union[U,o];
             newclasses=EquivalenceClasses[Map[(ToPolynomial[#[[1]]])&,G],True];
             If[TrueQ[newclasses],
                o={},
                newclasses=Select[newclasses,NoOrderFits[#,U]&];
                 o=SampleOrders[newclasses,variables];
               ];

(*
             o=AllOrders[G,variables];
             o=Select[o,NoEquivalent[#,U,newclasses]&];
*)

       ];
       Return[G]
];

NoOrderFits[class_,orders_List]:=
Apply[And,Map[FitsQ[#,class]&,orders]];

(*
NoEquivalent[item_List,list_List,relation_Or]:=
Apply[And,Map[EquivalentQ[item,#,relation]&,list]];
*)

EquivalentQ[a_List,b_List,R_Or]:=
Map[FitsQ[a,#]&,Apply[List,R]]===
Map[FitsQ[b,#]&,Apply[List,R]];

FitsQ[x_List, class_And]:=Map[FitsQ[x,#]&,class];

FitsQ[x_List, class_Greater]:=Map[WhereInList[#,x]&,class];

WhereInList[item_,list_List]:=
Module[{places},
       places=Table[i,{i,1,Length[list]}];
       places=Select[places,(list[[#]]===item)&];
       If[Length[places]===1,
          Return[places[[1]]],
          Return[places]
         ]
];

ToRuleTuples[polys_List]:=Map[ToRuleTuples,polys];

ToRuleTuples[x_Plus]:=
Module[{p,r},
       p=GrabPowers[x];
       r=ToRuleTuple[x];
       r=RuleTuple[r[[1]][[1]],Map[GreaterEqual[#,1]&,p],p];
       Return[r]
];

