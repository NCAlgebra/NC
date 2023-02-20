Clear[SmallBasis];
Clear[SmallMakeBasis];
Clear[SmallBasisByCategory];
Clear[SmallBasisOnEliminationIdeal];
Clear[SmallBasisOnMultElimIdeals];
Clear[VariableClosure];
Clear[MonomialOptimization];
Clear[MonomialOptimizationTwo];

fastSmallBasis = False;


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

Options[SmallBasis] := {Deselect->{},
                        ReduceAlsoUsing->{},
                        DegreeCap->-1,
			DegreeSumCap->-1};

SmallBasis[{},keep_List,iter_?NumberQ,opts___Rule]:= {};

SmallBasis[large_List, keep_List,iter_?NumberQ,opts___Rule]:=
Module[{shouldLoop,leftoverrels,relations,reduced,basislist,
        basis,item,result,j,deselects,totalvars,GrabsLoaded,
        degreecap,degreesumcap,shouldLoop2,kk,changed,
        rform,reducealsousing,temp,bigset},
(*
Print["MXS: starting smallbasis with:",large,
      " and ",keep," with ",iter," iterations ",
      "and options ",{opts}];
*)

   (* Grab the options *)
   deselects=Deselect/.{opts}/.Options[SmallBasis];
   reducealsousing = ReduceAlsoUsing/.{opts}/.Options[SmallBasis];
   degreecap= DegreeCap/.{opts}/.Options[SmallBasis];
   degreesumcap= DegreeSumCap/.{opts}/.Options[SmallBasis];

   (* Cleanse the input data *)
   temp = MoraAlg`RuleToPoly[large]; 
   relations = {};
   Do[ If[And[Not[MemberQ[relations,temp[[j]]]],
              Not[MemberQ[keep,temp[[j]]]]]
               , AppendTo[relations,temp[[j]]];
       ];
   ,{j,1,Length[temp]}];
Print["relations:",relations];
Print["keep:",keep];
   basislist = {};
   totalvars = Grabs`GrabIndeterminants[keep];
   GrabsLoaded = Not[Head[totalvars]===Grabs`GrabIndeterminants];
If[fastSmallBasis
  ,
   {relations,basislist} = 
       MonomialOptimization[relations,basislist,keep];
];
(*
   If[GrabsLoaded, 
      {relations,basislist,totalvars} = SmallBasisOptimization[
           relations,basislist,keep,totalvars]
   ];
*)
   If[And[Length[keep]===0,Length[relations]>0]
      , AppendTo[basislist,relations[[1]]];
        relations = Take[relations,{2,-1}];
   ];

   (* Record reduced forms for future enhancements *)
(*
   Do[ rform[relations[[j]]] = relations[[j]];
   ,{j,1,Length[relations]}];
*)

   While[Not[relations==={}],
        (* Make a big set to use for reducing *)
        bigset = VariableClosure[{relations[[1]]},Join[keep,basislist]];
Print["Considering:",relations[[1]]];
Print["Biggest set to compare against:",Join[keep,basislist]];
Print["Actually comparing against:",bigset];
(*
        bigset = Join[keep,basislist];
*)
        changed = False;
        If[Length[bigset]>0
          , NCMakeGB[bigset,0,
                     Deselect->deselects,
                     ReturnRelations->False,
                     ReorderInput->True,
		     DegreeCap->degreecap,
		     DegreeSumCap->degreesumcap];
            shouldLoop2 = True;
            For[kk=1,kk<=iter&&shouldLoop2,++kk,
                MoraAlg`NCContinueMakeGB[kk];
               (* reduce by above partial gb *)
               reduced = Reduce`FastReduction[relations];
Print["MXS:SmallBasis:test:",reduced[[1]]];
               shouldLoop2=Not[reduced[[1]]===0];
            ];
            changed = Not[shouldLoop2];
            leftoverrels = {};
            Do[ If[ Not[reduced[[j]] === 0]
                   , leftoverrels = Append[ leftoverrels,relations[[j]] ];
                     Print[relations[[j]],
                  " is apparently not a member of the ideal generated by ",
                       Join[keep,basislist]]; 
                   , Print[relations[[j]],
                       " is apparently a member of the ideal generated by ",
                       Join[keep,basislist]];
                ];
            ,{j,1,Length[reduced]}];
Print["Started with:",relations];
If[Length[leftoverrels]===Length[relations]
     , Print["Ending with the same"];
     , Print["Have eliminated:",Complement[relations,leftoverrels]];
];

            relations = leftoverrels;
        ];
        (* Add new element to relations if there are any left *)
        shouldLoop = True;
        While[And[Not[changed],shouldLoop,Not[relations==={}]],
           shouldLoop = False;
           item = relations[[1]];
           (* Update list of remaining relations *)
           relations = Take[relations,{2,-1}];
If[fastSmallBasis
     ,
           {relations,basislist} = 
                 MonomialOptimization[relations,basislist,keep];
];
(*
           (* Attempt the following optimization only if Grabs is loaded *)
           shouldLoop = GrabsLoaded;
           If[shouldLoop
              , newvars = Grabs`GrabIndeterminants[item];
                (* Are there variables here which we have not seen yet? *)
                shouldLoop = Not[Complement[newvars,totalvars]==={}];
                If[shouldLoop 
                   , (* There is no way to reduce item with basislist *)
                     (* Update variable list *)
                     totalvars = Union[totalvars,newvars];
Print["MXS::optimization: Clearly,", item," is not a member of",basislist];
                ];
           ];
*)
           (* Update basislist *)
           AppendTo[basislist,item];
        ]; (*Inner while *)
   ];(*While*)
   result = basislist;
(* the following line just saves the user selects *)
   Clear[rform];
   Return[result];
];

SmallBasis[x___] := BadCall["SmallBasis",x];

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
        degreecap,degreesumcap,
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
(*
Print["userSelects:",userSelects];
*)


  digested=RuleToPoly[GetCategories["Digested",dummy]];
  singleRules = RuleToPoly[GetCategories["singleRules",dummy]];
  knownpol = dummy[{}];
  knownpol = SmallBasis[knownpol,{},knownsiter,
                        Deselect->deselect,
                        DegreeCap->degreecap,
                        DegreeSumCap->degreesumcap];
  digpol=Complement[digested,singleRules];
(*
Put[digpol,ToString[Unique["digpol"]]];
*)

  Clear[lump];
  lump[0] = Union[SmallBasis[digpol,{},knownsiter],knownpol];
Print["Done with the digested"];
Print["Started with:",digpol];
Print["Ended with:",lump[0]];
(*
Put[lump[0],"lumpOf"<>ToString[0]];
*)
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
(*
Put[lump[i],"lumpOf"<>ToString[i]];
PutAppend[aCat,"lumpOf"<>ToString[i]];
*)
  ,{i,Length[cats]}];
  Clear[dummy];
(*
Do[Print["lump[",i,"] is ",lump[i]];
,{i,0,Length[cats]}];
*)
  result = Table[lump[i],{i,0,Length[cats]}];
  result = Union[Flatten[result]];
  result = Join[result,singleRules];
(*
Put[result,"resultFromSmallBasisByCategory"];
*)
  Clear[lump];
  Return[result];
];

(* in the SmallBasisByCategory routine above,
we shoould remember to return the relations in all categories
whether or not SmallBasis is calculated on each of the categories.
Currently the code is limited to categories with no more than two unknowns
*)
SmallBasisByCategory[x___] := BadCall["SmallBasisByCategory",x];

SmallBasisOnEliminationIdeal[x___] := SmallBasisOnEliminationIdeal[x];

SmallBasisOnEliminationIdeal[ProcessedBasis_List,
                                 topelimlevel_?NumberQ,
                                 iter_?NumberQ]:=
Module[{categoryArray,categories,NotInElimIdeal,
        ElimIdeal,VarsInIdeal,j,result},
   CreateCategories[ProcessedBasis,categoryArray];
   categories = categoryArray["AllCategories"];
   ElimIdeal = {};
   VarsInIdeal = {};
   Do[VarsInIdeal = Union[VarsInIdeal,WhatIsSetOfIndeterminants[j]];
   ,{j,1,topelimlevel}];
   VarsInIdeal = Flatten[VarsInIdeal];
   NotInElimIdeal = {};
   Do[ If[Complement[categories[[j]],VarsInIdeal] === {}
         ,ElimIdeal = Flatten[Join[ElimIdeal,
                                   categoryArray[categories[[j]]]
                                  ]
                             ];(*Flatten*)
         ,NotInElimIdeal = Flatten[Join[NotInElimIdeal,
                                        categoryArray[categories[[j]]]
                                       ]
                                   ];(*Flatten*)
       ];
   ,{j,1,Length[categories]}];
   ElimIdeal = Union[ElimIdeal,ElimIdeal];
(*
   ElimIdeal = Map[ToGBRule,ElimIdeal];
   ElimIdeal = SortRelations[ElimIdeal];
*)
   result = SmallBasis[ElimIdeal,categoryArray[{}],iter];
   Return[Join[result,NotInElimIdeal]];
]; (*SmallBasisOnEliminationIdeal*)

SmallBasisOnMultElimIdeals[ProcessedBasis_List,
                               topelimlevel_?NumberQ,
                               iter_?NumberQ]:=
Module[{categoryArray,big,result,j,k,categories,knowns,ElimIdeal,
        VarsInIdeal,temp,rest},
   big = ProcessedBasis//.Rule ->Subtract;
   CreateCategories[big,categoryArray];
   categories = categoryArray["AllCategories"];
   ElimIdeal = {};
   knowns = categoryArray[{}]//.Rule->Subtract;
   VarsInIdeal = {};
Print["big :",big];
Print["categories :",categories];
Print["knowns :",knowns];
Print["VarsInIdeal :",VarsInIdeal];

(*j is outer, k is inner *)
   Do[
Print["In Loop"];
      temp = categories;
      VarsInIdeal = Union[VarsInIdeal,WhatIsSetOfIndeterminants[j]];
      Do[ If[Complement[categories[[k]],VarsInIdeal] === {}
             ,ElimIdeal = Flatten[Join[ElimIdeal,
                                       categoryArray[categories[[k]]]
                                      ]
                                 ];(*Flatten*)
              temp = Complement[temp,{categories[[k]]}];
Print["temp :",temp];
          ];(*If*)
      ,{k,1,Length[categories]}];
      categories = temp;
Print["categories :",categories];
Print["ElimIdeal :",ElimIdeal];
      ElimIdeal = SmallBasis[ElimIdeal,knowns,iter];
   ,{j,2,topelimlevel}];
Print["out of Loop"];
   rest = {};
   Do[rest = Union[rest,categoryArray[categories[[k]]]];
   ,{k,1,Length[categories]}];
Print["rest :",rest];
   result = Union[ElimIdeal,knowns,rest];
   Return[result];
]; (*Module*)
 
MonomialsOf[x_Plus] := Flatten[Map[MonomialsOf,Apply[List,x]]];
MonomialsOf[c_?NumberQ x_] := x;
MonomialsOf[x_] := x;
MonomialsOf[x___] := BadCall["MonomialsOf",x];

InMonomialIdeal[aPolynomial_,aListOfMonomials_List] :=
  Reduce`Reduction[{aPolynomial},Map[(#->0)&,aListOfMonomials]] === {0};

InMonomialsIdeal[x___] := BadCall["InMonomialsIdeal",x];

ShareMonomials[aPolynomial_,aListOfMonomials_List] :=
  Not[Reduce`Reduction[{aPolynomial},Map[(#->0)&,aListOfMonomials]]
      ==={aPolynomial}];

ShareMonomials[x___] := BadCall["ShareMonomials",x];

