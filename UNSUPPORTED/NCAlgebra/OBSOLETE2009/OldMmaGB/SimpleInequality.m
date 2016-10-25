<<PabloInequalities.m

Clear[AddFacts];

Clear[AllVar];

Clear[AllFacts];

Clear[InequalitySolve];

Clear[ClassSimplify];

ClassSimplify::usage=
     "ClassSimplify[LogicalExpressionofInequalities] changes each \
      inequality to standard form with InequalitytoStandardForm."

Clear[ConditionSimplify];

ConditionSimplify::usage=
     "ConditionSimplify[ExpressionofEqualitiesinStandardForm] attempts \
      to simplify the expression and remove contradictions. It only \
      works with expressions involving one variable."

Clear[PartCondition];

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

PartCondition[x_]:={{x}};

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
If[MyInequalityFactQ[a[[2]]>b[[2]]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_GreaterEqual,b_Greater]:=
If[MyInequalityFactQ[a[[2]]>b[[2]]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_Greater,b_GreaterEqual]:=
If[MyInequalityFactQ[a[[2]]>=b[[2]]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_GreaterEqual,b_GreaterEqual]:=
If[MyInequalityFactQ[a[[2]]>=b[[2]]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_Less,b_Greater]:=
If[MyInequalityFactQ[a[[2]]<=b[[2]]],
   False, 
   And[a,b],
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_Greater]:=
If[MyInequalityFactQ[a[[2]]<=b[[2]]],
   False, 
   And[a,b],
   And[a,b]
  ];

ConditionSimplify[a_Less,b_GreaterEqual]:=
If[MyInequalityFactQ[a[[2]]<=b[[2]]],
   False, 
   And[a,b],
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_GreaterEqual]:=
If[MyInequalityFactQ[a[[2]]<b[[2]]],
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
If[MyInequalityFactQ[a[[2]]<b[[2]]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_Less]:=
If[MyInequalityFactQ[a[[2]]<b[[2]]],
   a,
   b,
   And[a,b]
  ];

ConditionSimplify[a_Less,b_LessEqual]:=
If[MyInequalityFactQ[a[[2]]<=b[[2]]],
   a,
   b, 
   And[a,b]
  ];

ConditionSimplify[a_LessEqual,b_LessEqual]:=
If[MyInequalityFactQ[a[[2]]<=b[[2]]],
   a,
   b, 
   And[a,b]
  ];

ConditionSimplify[a_Equal,b_]:=If[MyInequalityFactQ[Head[b][a[[2]],b[[2]]]],
                                  a,
                                  False, 
                                  And[a,b]];

ConditionSimplify[a_,b_Equal]:=ConditionSimplify[b,a];

ConditionSimplify[a_,b_]:=And[a,b];

ConditionSimplify[False,a_]:=False;
ConditionSimplify[a_,False]:=False;

ConditionSimplify[True,a_]:=a;
ConditionSimplify[a_,True]:=a;

ConditionSimplify[x_GreaterEqual]:=
If[MyInequalityFactQ[x[[1]]==x[[2]]],True,x,x];

ConditionSimplify[x_LessEqual]:=
If[MyInequalityFactQ[x[[1]]==x[[2]]],True,x,x];

ConditionSimplify[GreaterEqual[a_,-Infinity]]:=True;

ConditionSimplify[LessEqual[a_,Infinity]]:=True;

ConditionSimplify[x_Greater]:=
If[MyInequalityFactQ[x[[1]]==x[[2]]],False,x,x];

ConditionSimplify[x_Less]:=
If[MyInequalityFactQ[x[[1]]==x[[2]]],False,x,x];

ConditionSimplify[Greater[a_,Infinity]]:=False;

ConditionSimplify[Less[a_,-Infinity]]:=False;

ConditionSimplify[x_]:=x;

ConditionSimplify[]:=True;

SimplestInequality[expr_Or]:=Map[SimplestInequality,expr];

SimplestInequality[expr_And]:=
Module[{simp,simplist,boundlist,equals},
       simp=ClassSimplify[expr];
       If[Head[simp]===And,
          simplist:=Apply[List,simp],
          simplist:={simp}];
       equals=Select[simplist,(Head[#]===Equal)&];
       If[equals!={},
          simp=RemoveEqual[simp,equals],
          ];
       simp=And[simp,AddFacts[simp]];
       simp = ClassSimplify[simp && Apply[And,equals]];
       simplist=PartCondition[simp];

(*
       If[Head[simp]==And,
          SetMyInequalityFactBase[Apply[List,simp]],
          SetMyInequalityFactBase[{simp}]];
Print["FactBase has been Set"];
       boundlist=Map[AddBounds[#[[1]][[1]]]&,simplist];
Print["boundlist = ",boundlist]; 
       simplist=Table[Union[simplist[[i]],boundlist[[i]]],
                      {i,1,Length[simplist]}];
Print["simplist = ",simplist];
*)

       simp=Apply[And,Map[Apply[ConditionSimplify,#]&,simplist]];
       Return[LogicalExpand[simp]]
];

SimplestInequality[expr_]:= expr;

SimplestInequality[x___]:= BadCall["SimplestInequality"];

AddBounds[var_]:=
Module[{low,high,bounds},
       low=LowerBound[var];
       high=UpperBound[var];
       bounds={};
       If[low===-Infinity,
          (* nothing *),
          bounds=Append[bounds,var>=low]];
       If[high===Infinity,
          (* nothing *),
          bounds=Append[bounds,var<=high]];
       Return[bounds]
];

(* from Mark Stankus *)

RemoveEqual[start_,aListOfEquals:{__Equal}] := 
Module[{aList,item,result},
   aList = aListOfEquals;
   result = start; 
   Do[ item = aList[[i]];
       If[Head[item]===Equal,
          item = Global`linearConvert[item];
          result = result//.item;
          aList = aList//.item;
         ];
   ,{i,1,Length[aListOfEquals]}]; 
   Return[result];
];

RemoveEqual[x___] := BadCall["RemoveEqual"];

(* Imported from Inequalities.m *)

Alternate[GreaterEqual] := LessEqual;
Alternate[LessEqual] := GreaterEqual;
Alternate[Less] := Greater;
Alternate[Greater] := Less;
Alternate[Equal] := Equal

Others[Greater] := {Greater,GreaterEqual,Equal};P
Others[Less] := {Less,LessEqual,Equal};
(* Imported from ClassFinder (original) *)

CartesianProduct[]:={};

CartesianProduct[x_List] := x;

CartesianProduct[{}, x_List] := x;

CartesianProduct[x_List, {}] := x;

CartesianProduct[x_List, y_List] :=
Module[{i, j},
    Flatten[Table[{x[[i]], y[[j]]}, {i, Length[x]}, {j,
Length[y]}],1]
    ];
 
CartesianProduct[x_List, y__List] :=
    Map[Flatten[#,1]&,CartesianProduct[x,CartesianProduct[y]]];

(*--------------------------------------*)

AllVar[x_?NumberQ]:={};

AllVar[x_]:=
If[MemberQ[{Greater,Equal,Less,GreaterEqual,LessEqual,Or,And,Plus,Times},Head[x]],
   Apply[Union,Map[AllVar,Apply[List,x]]],
   {x}];

InequalitySolve[expr_, x_]:=
Module[{co,final},
       co=Coefficient[expr[[1]]-expr[[2]],x];
       final=expr[[2]]-expr[[1]]+co x;
       final=If[co<0,
                Alternate[Head[expr]][x,(1/co)final],
                Head[expr][x,(1/co)final],
                Head[expr][x,(1/co)final]];
      Return[final]
];

AllFacts[expr_And]:=
Apply[Union,Map[AllFacts,expr]];

AllFacts[inequality_?InequalityQ]:=
Module[{vars,factlist},
       vars=AllVar[inequality];
       factlist=Table[InequalitySolve[inequality,vars[[i]]],
                      {i,1,Length[vars]}];
       Return[factlist]
];

InequalityQ[x_]:=
MemberQ[{Greater,GreaterEqual,Equal,LessEqual,Less},Head[x]];

AllFacts[x___]:=BadCall["AllFacts",{x}];

(* AllHigher[x_, class_List, n_Integer] := *)

AddFacts[expr_And]:=
Module[{facts,otherfacts,n},
       facts=AllFacts[expr];
       SetMyInequalityFactBase[facts];
       n=Length[facts];
       otherfacts=Apply[And,Flatten[Map[AllRelated[#,n]&,AllVar[expr]]]];
       Return[otherfacts]
];

AllRelated[x_,n_Integer]:=
Module[{related},
       related= Map[({#,NonNumericalLeafs[x,{#},n]})&,
                    {Greater,GreaterEqual,Less,LessEqual}];
       related=Map[AddHead[x,#]&,related];
       Return[related]
];

AddHead[x_,{aHead_,fit_List}]:=
Map[aHead[x,#]&,fit];

