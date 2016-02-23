Options[SmallBasisByCategory] := 
     {Deselect->{}, 
      DegreeCap->-1, 
      DegreeSumCap->-1,
      NCGBDebug->False,
      Slow->False};

SmallBasisByCategoryOptions[aList_List,symbol_Symbol] := 
Module[{},  
  symbol["slow"] = NCGBDebug/.aList/.Options[SmallBasisByCategory];
  If[Not[FreeQ[aList,Slow]]
    , Print["Please use the option NCGBDebug next time."];
      symbol["slow"] = Slow/.aList/.Options[SmallBasisByCategory];
  ];
  symbol["deselect"] = Deselect/.aList/.Options[SmallBasisByCategory];
  degreecap= DegreeCap/.aList/.Options[SmallBasisByCategory];
  degreesumcap= DegreeSumCap/.aList/.Options[SmallBasisByCategory];
  If[FreeQ[aList,KnownsIter]
    , symbol["knownsiter"] = iter+1;
    , symbol["knownsiter"] = KnownsIter/.{opts};
  ];
];

SmallBasisByCategoryOptions[x___] := BadCall["SmallBasisByCategoryOptions",x];

DOSBBC[reducedDigested_GBMarker,allDigested_GBMarker,
       theCategory_GBMarker,options_Symbol] :=
Module[{THECAT,REMAINING,answer},
  THECAT = CopyMarker[theCategory,"polynomials"];
  REMAINING = ComplementMarkers[THECAT,allDigested];
  If[options["slow"]
    , Print["MXS:The complement ",RetrieveMarker[REMAINING]];
  ];
  If[Global`numberOfElementsBehindMarker[REMAINING]>0
    , If[options["slow"]
        , Print["THECAT:",RetrieveMarker[THECAT]];
      ];
      answer = SmallBasis[THECAT,
                 allDigested, (* could have used reducedDigested *)
                 options["iter"]
                 ,Deselect->option["deselect"]
                 ,NCGBDebug->options["slow"]
(*
                 ,ReduceAlsoUsing->digpol
*)
                 ,DegreeCap->options["degreecap"]
                 ,DegreeSumCap->options["degreesumcap"]
               ];
    , answer = CreateMarker["polynomials"]; 
  ];
  DestroyMarker[REMAINING];
  DestroyMarker[THECAT];
  Return[answer];
];


SmallBasisByCategory[rules:(_List|GBMarker[_Integer,"rules"]),
                     iter_?NumberQ,opts___Rule] := 
Module[{options,ALLRULES,FC,dummy,trash,userSelects,
        allCategories,
,cats,lump,i,j,result,
        FC,INTS,MARK,RULES,DIGESTED,KNOWNPOL,LEFTOVER,
        SINGLEPOLYS,DIGPOL, ACAT,COMP1,COMP2,SINGLERULES,
        },
  options["iter"] = iter;
  SmallBasisByCategoryOptions[{opts},options];
  trash = {};
  If[Head[rules]===List
    , ALLRULES = Map[If[Head[#]===Rule,#,PolyToRule[#]]&,rules];
      ALLRULES = sendMarkerList["rules",RULES];
    , ALLRULES = CopyMarker[rules,"rules"];
  ];
  trash = {trash,ALLRULES};
  CreateFactControl[ALLRULES];

  CreateCategories[dummy];
  allCategories = GetCategory["AllCategories",dummy];
  userSelects = GetCategory["userSelects",dummy];
  
  If[slow
    , Print["userSelects:",userSelects];
  ];

  (* put the digested rules in DIGESTED  as polynomials *)

  RULES = GetCategories["Digested",dummy];
  DIGESTED = CopyMarker[RULES,"polynomials"];
  trash = {trash,RULES};

  KNOWNPOL = GetCategories[{},dummy];
  LEFTOVER = SmallBasis[KNOWNPOL,{},options["knownsiter"],
                        NCGBDebug->options["slow"],
                        Deselect->options["deselect"],
                        DegreeCap->options["degreecap"],
                        DegreeSumCap->options["degreesumcap"]];
  trash = {trash,KNOWNPOL};
  KNOWNPOL = LEFTOVER;

  SINGLERULES = GetCategories["singleRules",dummy];
  SINGLERULES = sendMarkerList[SINGLERULES,"rules"];
  SINGLEPOLYS = CopyMarker[SINGLERULES,"polynomials"];
  trash = {trash,SINGLERULES};

  DIGPOL = ComplementMarkers[DIGESTED,SINGLEPOLYS];

  trash = {trash,DIGESTED};
If[slow
  , Put[RetrieveMarker[DIGPOL],ToString[Unique["digpol"]]];
];

  Clear[lump];
  SB = SmallBasis[DIGPOL,{},knownsiter,NCGBDebug->slow];
  lump[0] = UnionMarkers[SB,KNOWNPOL];
  DestroyMarker[SB];
(*
Print["Done with the digested"];
Print["Started with:",RetrieveMarker[DIGPOL]];
Print["Ended with:",RetrieveMarker[lump[0]]];
Put[lump[0],"lumpOf"<>ToString[0]];
*)
  deselect = Union[deselect,RetrieveMarker[DIGPOL]];
  Do[ category = GetCategories[allCategories[[i]],dummy]; 
     lump[i] = DOSBBC[lump[0],DIGPOL,category,options];
     If[slow
       , Put[RetrieveMarker[lump[i]],"lumpOf"<>ToString[i]];
         PutAppend[RetrieveMarker[ACAT],"lumpOf"<>ToString[i]];
     ];
  ,{i,Length[allCategories]}];
  ClearCategoryFactory[dummy]; (* still needs to be written *)
  If[options["slow"],
    , Do[Print["lump[",i,"] is ",RetrieveMarker[lump[i]]];
      ,{i,0,Length[cats]}];
  ];
  If[Head[rules]===List
    , result = Table[RetrieveMarker[lump[i]],{i,0,Length[cats]}];
      result = Union[Flatten[result]];
      result = Join[result,RetrieveMarker[SINGLEPOLYS]];
      If[slow
        , Put[result,"resultFromSmallBasisByCategory"];
      ];
    , result = CopyMarker[SINGLEPOLYS,"polynomials"];
      Do[ AppendMarker[result,lump[i]];
      ,{i,0,Length[cats]}];
      AppendMarker[result,SINGLEPOLYS];
  ];
  Do[ DestroyMarker[lump[i]];
  ,{i,0,Length[cats]}];
  Clear[lump];
  DestroyMarker[SINGLEPOLYS];
  DestroyMarker[SINGLERULES];
  Clear[options];
  Return[result];
];

(* in the SmallBasisByCategory routine above,
we shoould remember to return the relations in all categories
whether or not SmallBasis is calculated on each of the categories.
Currently the code is limited to categories with no more than two unknowns
*)
SmallBasisByCategory[x___] := BadCall["SmallBasisByCategory",x];
