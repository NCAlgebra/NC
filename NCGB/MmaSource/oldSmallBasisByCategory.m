Clear[SmallBasisByCategory];


VariableClosure[StartSet_List,Additional_List] :=
Module[{add,totalvars,result,remaining,shouldLoop,i,temp},
  totalvars = Grabs`GrabIndeterminants[StartSet];
  result = {};
  remaining = Additional;
  shouldLoop = True;
  While[shouldLoop
    , Clear[temp];
      Do[ temp[i] = Select[remaining,Not[FreeQ[#,totalvars[[i]]]]&];
          If[Not[Length[temp[i]]===0]
             , remaining = Complement[remaining,temp[i]];
               totalvars = Union[totalvars,
                                 Grabs`GrabIndeterminants[temp[i]]];
          ];
      ,{i,1,Length[totalvars]}];
      add = Flatten[Table[temp[i],{i,1,Length[totalvars]}]];
      result = Union[Flatten[{result,add}]];
      shouldLoop = Length[add]>0;
      Clear[temp];
  ];
  Return[result];
];

VariableClosure[x___] := BadCall["VariableClosure",x];

MonomialOptimization[relations_,basislist_,keep_] :=
Module[{result,newrelations,newbasislist,shouldLoop,item,str},
Print["Starting optimization with"];
Print[ColumnForm[relations]];
Print["and"];
Print[ColumnForm[basislist]];
Print["and"];
Print[ColumnForm[keep]];
  newrelations = relations;
  newbasislist = basislist;
  shouldLoop = True;
  While[And[Length[newrelations]>0,shouldLoop],
    item = newrelations[[1]];
    (* see if item is in the monomial ideal under consideration *)
    NCMakeGB[Join[keep,newbasislist],0,
             ReturnRelations->False];
(*
*   str = Global`PolynomialToString[item];
*)
    (* If we can determine that the reduction will not work
       from just using monomials, let's do that *)
(*
*   shouldLoop = Global`inMonomialIdeal[str,WhatAreNumbers[]]==0;
*)
    shouldLoop = Global`InMonomialIdeal[str,WhatAreNumbers[]]==0;
    If[shouldLoop
       , 
Print["MXS:Optimization helped pass by ",item,
      " against ",newbasislist];
         AppendTo[newbasislist,item];
         newrelations = Take[newrelations,{2,-1}];
    ];
  ];
  result = {newrelations,newbasislist};
  Return[result];
];

MonomialOptimization[x___] := BadCall["MonomialOptimization",x];

MonomialOptimizationTwo[relation_,basislist_,keep_] :=
Module[{result,str,nums},
  NCMakeGB[Join[keep,basislist],0,ReturnRelations->False];
  nums = WhatAreGBNumbers[];
(*
* str = PolynomialToString[relation];
* result = WhatIsPartialGB[mightHelp[str,nums]];
*)
  result = WhatIsPartialGB[MightHelp[relation,nums]];
  Return[result];
];

MonomialOptimizationTwo[x___] := BadCall["MonomialOptimizationTwo",x];

SmallBasisOptimization[relations_List,
                       basislist_List,keep_List,
                       totalvars_List] :=
Module[{shouldLoop,item,newvars,newrelations,
        newbasislist,newtotalvars},
   newrelations = relations;
   newbasislist = basislist;
   newtotalvars = totalvars;
   (* Add new element to relations if there are any left *)
   (* Attempt the following optimization only if Grabs is loaded *)
   shouldLoop = True;
   While[And[shouldLoop,Not[newrelations==={}]],
      item = newrelations[[1]];
Print["testing:",item," for optimization against ",Join[keep,basislist]];
      newvars = Grabs`GrabIndeterminants[item];
      (* Are there variables here which we have not seen yet? *)
      shouldLoop = Not[Complement[newvars,newtotalvars]==={}];
      If[shouldLoop
        , (* There is no way to reduce item with basislist *)
          (* Update variable list and update basislist *)
          (* Update list of remaining relations *)
          newtotalvars = Union[newtotalvars,newvars];
Print["MXS::optimization: Clearly,", item," is not a member of",
      Join[keep,newbasislist]];
          AppendTo[newbasislist,item];
          If[Length[newrelations]>=2
           , newrelations = Take[newrelations,{2,-1}];
           , newrelations = {};
          ];
      ];
   ];
   Return[{newrelations,newbasislist,newtotalvars}];
];


(* 

The following routine requires Categories.m
It applies CreateCategories and SmallBasis on a
basis.

*)

Options[SmallBasisByCategory] := 
     {Deselect->{}, DegreeCap->-1, DegreeSumCap->-1};

SmallBasisByCategory[rules_List,iter_?NumberQ,opts___Rule] := 
Module[{dummy,cats,digested,lump,i,j,result,
        degreecap,degreesumcap,slow,
        deselect,singleRules,knownpol,knownsiter,userSelects},
  deselect = Deselect/.{opts}/.Options[SmallBasisByCategory];
  degreecap= DegreeCap/.{opts}/.Options[SmallBasis];
  degreesumcap= DegreeSumCap/.{opts}/.Options[SmallBasis];
  If[FreeQ[{opts},KnownsIter]
    , knownsiter = iter+1;
    , knownsiter = KnownsIter/.{opts};
  ];
  Clear[dummy];
  CreateCategories[RuleToPol[rules],dummy];

  cats = dummy["AllCategories"];
  userSelects = dummy["userSelects"];
If[slow
  , Print["userSelects:",userSelects];
];


  digested=RuleToPoly[GetCategories["Digested",dummy]];
  singleRules = RuleToPoly[GetCategories["singleRules",dummy]];
  knownpol = dummy[{}];
  knownpol = SmallBasis[knownpol,{},knownsiter,
                        Deselect->deselect,
                        DegreeCap->degreecap,
                        DegreeSumCap->degreesumcap];
  digpol=Complement[digested,singleRules];
If[slow
  ,  Put[digpol,ToString[Unique["digpol"]]];
];
  Clear[lump];
  lump[0] = Union[SmallBasis[digpol,{},knownsiter],knownpol];
If[slow
  , Print["Done with the digested"];
    Print["Started with:",digpol];
    Print["Ended with:",lump[0]];
    Put[lump[0],"lumpOf"<>ToString[0]];
];
  deselect = Union[deselect,digpol];
  Do[ Print["cats[[",i,"]]=",cats[[i]]];
      aCat = RuleToPol[dummy[cats[[i]]]];
      Print["MXS:The complement ",Complement[aCat,Join[digpol,singleRules]]];
      If[Not[Complement[aCat,Join[digpol,singleRules]]==={}]
        , 
          Print["aCat:",aCat];
          Print["digpol:",digpol];
          Print["iter:",iter];
          lump[i]=SmallBasis[aCat,
                             digpol,
(*
                             lump[0],
*)
                             iter
                             ,Deselect->deselect
(*
                             ,ReduceAlsoUsing->digpol
*)
                             ,DegreeCap->degreecap
                             ,DegreeSumCap->degreesumcap
                            ];
        , lump[i] = {}; 
      ];
If[slow
  , Put["1st argument","lumpOf"<>ToString[i]];
    PutAppend[aCat,"lumpOf"<>ToString[i]];
    PutAppend["2nd argument","lumpOf"<>ToString[i]];
    PutAppend[digpol,"lumpOf"<>ToString[i]];
    PutAppend["result","lumpOf"<>ToString[i]];
    PutAppend[lump[i],"lumpOf"<>ToString[i]];
];
  ,{i,Length[cats]}];
  Clear[dummy];
If[slow
  ,
    Do[Print["lump[",i,"] is ",lump[i]];
    ,{i,0,Length[cats]}];
];
  result = Table[lump[i],{i,0,Length[cats]}];
  result = Union[Flatten[result]];
  result = Join[result,singleRules];
If[slow
  ,  Put[result,"resultFromSmallBasisByCategory"];
];
  Clear[lump];
  Return[result];
];

(* in the SmallBasisByCategory routine above,
we shoould remember to return the relations in all categories
whether or not SmallBasis is calculated on each of the categories.
Currently the code is limited to categories with no more than two unknowns
*)
SmallBasisByCategory[x___] := BadCall["SmallBasisByCategory",x];
