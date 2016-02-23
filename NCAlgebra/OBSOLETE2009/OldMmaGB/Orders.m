(* :Title:      Orders.m // Mathematica 2.0 *)

(* :Author:     Pablo Herrero (pherrero). *)

(* :Context:    Orders` *)

(* :Summary: *)

(* :Warnings: *)

(* :History: 
   :8/16/94: Wrote package.
*)

BeginPackage["Orders`","Inequalities`","NCMakeGreater`","NCMtools`",
             "NCGBMax`","Grabs`","Errors`"]; 

Clear[AllOrders];

AllOrders::usage = 
     "AllOrders[aListOfPolynomials, aListOfIndeterminants] returns a \
      list of orders of the given indeterminants. Each order is a \
      member of an equivalence class of orders that produce the \
      same leading terms in each of the polynomials in the list." 

Clear[EquivalenceClasses];

EquivalenceClasses::usage =
     "EquivalenceClasses[aListOfPolynomials, (optional Simpler)] \
      returns a logical expression that represents the \
      equivalence classes of orders that produce the same \
      leading terms in each of the polynomials in the list. \
      If Simpler is True, the expression will be simplified as \
      much as possible. "

Begin["`Private`"]; 

Clear[ClassOrder];
Clear[LeadingTerms];
Clear[TermOrder];
Clear[MonomialOrders];
Clear[NCDegree];

EquivalenceClassUsage[True];

EquivalenceClasses[relations_List, simpler_] := 
    If[TrueQ[simpler],
       RemoveExponents[
          ConditionSimplify[
             ClassSimplify[
                EquivalenceClasses[relations]
                          ]
                           ] ,GrabIndeterminants[relations]
                      ],
       EquivalenceClasses[relations]
      ];

EquivalenceClasses[relations_List] := 
    LogicalExpand[Apply[And, Map[ClassOrder, relations]]];

ClassOrder[expr_Plus] := MonomialOrders[LeadingTerms[expr]];

MonomialOrders[termlist_List] :=
Module[{i,listterms,result},
    listterms = Map[NCMToList, termlist];
    result = Table[TermOrder[listterms[[i]], Delete[listterms, i]]
                 ,{i, 1, Length[listterms]}];
    result = Apply[Or,result];
    Return[result];
];

TermOrder[monomial_List, terms_List] :=
Module[{aList,result},
    aList = Map[MakeGreater[monomial, #]&, terms];
    aList = aList/.NCMakeGreater`Private`thePosition[x_] ->x;
    result = Apply[And,aList];
    Return[result];
];


LeadingTerms[expr_Plus] := 
Module[{termlist,degree,leading},
   termlist = Apply[List, expr];
   pairs = Map[{{NCDegree[#]},#}&,termlist];
   pairs = ComplicatedMax[pairs];
   leading = Map[#[[2]]&,pairs];
   Return[leading];
];

NCDegree[x_Times] := Map[NCDegree, Apply[Plus, x]];

NCDegree[x_NonCommutativeMultiply] := 
Module[{asaList,temp,result},
    asaList = NCMToList[x];
    temp = Map[NCDegree,asaList];
    result = Apply[Plus,temp];
    Return[result];
];

NCDegree[x_^n_] := n;

NCDegree[x_Integer] := 0;

NCDegree[x_Real] := 0;

NCDegree[x_] := 1;

Clear[RemoveInvalid];
Clear[Contradictory];
Clear[SampleOrders];
Clear[FindOrder];
Clear[AllHigher];
Clear[Bigger];
Clear[SimpleAnd];

RemoveInvalid[classes_Or, variables_List] := 
    Complement[
        Map[RemoveInvalid[#,variables]&,Apply[List,classes]]
       , {"Contradictory"}
             ];

RemoveInvalid[classes_?SimpleAnd, variables_List] := 
   If[ Not[Contradictory[BooleanToList[classes],variables]]
               , classes
               , "Contradictory"
   ];

Contradictory[class_List, vars_List] := 
   Apply[Or, Map[MemberQ[AllHigher[#,class,0], #]&, vars]];

SampleOrders[True, variables_List]:={variables};

SampleOrders[classes_, variables_List] := 
   Map[FindOrder[#, variables]& , RemoveInvalid[classes, variables]];

FindOrder[class_?SimpleAnd, {}] := {};

FindOrder[class_?SimpleAnd, variables_List] := 
Module[{after, before, higher, v},
    v = variables[[1]];
    higher = AllHigher[v, BooleanToList[class], 0];
    after = Intersection[variables, higher];
    before = Complement[variables, {v}, after];
    Return[
          Join[FindOrder[class, before], {v}, FindOrder[class, after]]
          ]
];

AllHigher[x_, class_List, n_Integer] :=
Module[{highlist,newlist},
    highlist = Map[Bigger, Select[class, (#[[2]] == x)&]];
    If[n <= Length[class] && Not[highlist === {}],
       newlist = Apply[Union, Map[AllHigher[#, class, n+1]&, highlist]],
       newlist = {}
      ];
    Return[Union[highlist, newlist]]
];

Bigger[x_Greater] := x[[1]];

    (* If[FreeQ[higher, v], *)
(*
SimpleAnd[And[___?And[FreeQ[#,And],FreeQ[#,Or]]&]] := True;
*)
SimpleAnd[And[___?NoAndOr]] := True;

SimpleAnd[True] := True;
SimpleAnd[False] := True;
SimpleAnd[x_GreaterEqual] := True;
SimpleAnd[x_Greater] := True;
SimpleAnd[x_LessEqual] := True;
SimpleAnd[x_Less] := True;
SimpleAnd[x_Equal] := True;
SimpleAnd[x_] := False;
SimpleAnd[x___] := BadCall["SimpleAnd",x];

NoAndOr[x_?Not[FreeQ[#,And]]&] := False;
NoAndOr[x_?Not[FreeQ[#,Or]]&] := False;
NoAndOr[x_] := True;

BooleanToList[x_And] := Apply[List,x];
BooleanToList[x_] := {x};
BooleanToList[x___] := BadCall["BooleanToList",x];

Clear[ClassSimplify];

Clear[ConditionSimplify];

Clear[PartCondition];
Clear[RemoveExponents];

ClassSimplify[True]:=True;
ClassSimplify[False]:=False;
ClassSimplify[class_And]:=Map[ClassSimplify, class];

ClassSimplify[class_Or]:=Map[ClassSimplify, class];

ClassSimplify[x_Greater]:=InequalityToStandardForm[x];
ClassSimplify[x_GreaterEqual]:=InequalityToStandardForm[x];
ClassSimplify[x_Less]:=InequalityToStandardForm[x];
ClassSimplify[x_LessEqual]:=InequalityToStandardForm[x];
ClassSimplify[x_Equal]:=InequalityToStandardForm[x];

ConditionSimplify[c_And]:=
LogicalExpand[Apply[And,Map[Apply[ConditionSimplify,#]&,PartCondition[c]]]];

PartCondition[c_And]:=
Union[Table[Select[Apply[List,c],#[[1]]==c[[i]][[1]]&],{i,1,Length[c]}]];

ConditionSimplify[c_Or]:=Map[ConditionSimplify,c];

ConditionSimplify[a_,b_,c___]:=
ConditionSimplify[ConditionSimplify[a,b],ConditionSimplify[c]];

ConditionSimplify[a_,b_And]:=
Module[{biglist,minlen},
       biglist:=Map[ConditionSimplify[a,#]&,Apply[List,b]];
       minlen:=Min[Map[Length,biglist]];
       shortlist:=Select[biglist,(Length[#]==minlen)&];
       Return[LogicalExpand[Apply[And,shortlist]]];
];

ConditionSimplify[a_And,b]:=ConditionSimplify[b,a];

ConditionSimplify[a_Greater,b_Greater]:=
If[a[[2]]>b[[2]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_GreaterEqual,b_Greater]:=
If[a[[2]]>b[[2]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_Greater,b_GreaterEqual]:=
If[a[[2]]>=b[[2]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_GreaterEqual,b_GreaterEqual]:=
If[a[[2]]>=b[[2]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_Less,b_Greater]:=
If[a[[2]]<=b[[2]],
   False, 
   And[a,b],
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_Greater]:=
If[a[[2]]<=b[[2]],
   False, 
   And[a,b],
   And[a,b]
  ];

ConditionSimplify[a_Less,b_GreaterEqual]:=
If[a[[2]]<=b[[2]],
   False, 
   And[a,b],
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_GreaterEqual]:=
If[a[[2]]<b[[2]],
   False, 
   If[a[[2]]==b[[2]],
      Equal[a[[1]],a[[2]]],
      And[a,b]
   ],
   And[a,b]
];

ConditionSimplify[a_Greater,b_Less]:=ConditionSimplify[b,a];
ConditionSimplify[a_GreaterEqual,b_Less]:=ConditionSimplify[b,a];
ConditionSimplify[a_Greater,b_LessEqual]:=ConditionSimplify[b,a];
ConditionSimplify[a_GreaterEqual,b_LessEqual]:=ConditionSimplify[b,a];

ConditionSimplify[a_Less,b_Less]:=
If[a[[2]]<b[[2]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_Less]:=
If[a[[2]]<b[[2]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_Less,b_LessEqual]:=
If[a[[2]]<=b[[2]],
   a,
   b, 
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_LessEqual]:=
If[a[[2]]<=b[[2]],
   a,
   b, 
   And[a,b]
  ];

ConditionSimplify[a_Equal,b_]:=If[Head[b][a[[2]],b[[2]]],
                                  a,
                                  False, 
                                  And[a,b]];

ConditionSimplify[a_,b_Equal]:=ConditionSimplify[b,a];

ConditionSimplify[a_,b_]:=And[a,b];

ConditionSimplify[False,a_]:=False;
ConditionSimplify[a_,False]:=False;

ConditionSimplify[True,a_]:=a;
ConditionSimplify[a_,True]:=a;

ConditionSimplify[x_]:=x;

ConditionSimplify[]:=True;

RemoveExponents[x_Or,vars_List]:=
Apply[Or,Select[Map[RemoveExponents[#,vars]&,Apply[List,x]],Not[TrueQ[#]]&]];

RemoveExponents[x_And,vars_List]:=
Select[x,Or[MemberQ[vars,#[[1]]],MemberQ[vars,#[[2]]]]&];

RemoveExponents[True,_] := True;
RemoveExponents[False,_] := False;

RemoveExponents[x_,vars_List] := 
     If[Or[MemberQ[vars,x[[1]]],
           MemberQ[vars,x[[2]]]] , x
                                 , True 
     ];


RemoveExponents[x___] := BadCall["RemoveExponents",x];

AllOrders[polys_List, vars_List]:=
Module[{result},
  EquivalenceClassUsage[True];  
  result = SampleOrders[
             RemoveExponents[
               ConditionSimplify[
                 ClassSimplify[ 
                   EquivalenceClasses[polys] 
                              ] 
                                ] ,vars
                            ] ,vars
                       ];
  EquivalenceClassUsage[False];  
  Return[result];
];

End[]; 

EndPackage[] 

