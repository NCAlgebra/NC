Options[SmallBasisByCategory] := 
     {Deselect->{}, 
      DegreeCap->-1, 
      DegreeSumCap->-1,
      NCGBDebug->False,
      Slow->False};

SmallBasisByCategory[rules:(_List|GBMarker[_Integer,"rules"]),
                     iter_?NumberQ,opts___Rule] := 
Module[{dummy,cats,lump,i,j,result,
        FC,INTS,MARK,RULES,DIGESTED,KNOWNPOL,LEFTOVER,
        SINGLEPOLYS,DIGPOL, ACAT,COMP1,COMP2,SINGLERULES,
        degreecap,degreesumcap,slow,
        deselect,knownsiter,userSelects},
  slow = NCGBDebug/.{opts}/.Options[SmallBasisByCategory];
  If[Not[FreeQ[{opts},Slow]]
    , Print["Please use the option NCGBDebug next time."];
      slow = Slow/.{opts}/.Options[SmallBasisByCategory];
  ];
  deselect = Deselect/.{opts}/.Options[SmallBasisByCategory];
  degreecap= DegreeCap/.{opts}/.Options[SmallBasisByCategory];
  degreesumcap= DegreeSumCap/.{opts}/.Options[SmallBasisByCategory];
  If[FreeQ[{opts},KnownsIter]
    , knownsiter = iter+1;
    , knownsiter = KnownsIter/.{opts};
  ];
  If[Head[rules]===List
    , RULES = Map[If[Head[#]===Rule,#,PolyToRule[#]]&,rules];
      RULES = sendMarkerList["rules",RULES];
    , RULES = CopyMarker[rules,"rules"];
  ];
  Clear[dummy];
  NCMakeGB[RULES,0,ReturnRelations->False];
  DestroyMarker[RULES];
  FC = SaveFactControl[];
  INTS = WhatAreGBNumbersMarker[FC];
  MARK = CPPCreateCategories[INTS,FC];
  DestroyMarker[FC];
  DestroyMarker[INTS];
  CreateCategories[MARK,dummy];
  DestroyMarker[MARK];

  cats = dummy["AllCategories"];
  userSelects = dummy["userSelects"];
If[slow
  , Print["userSelects:",userSelects];
];

  RULES = GetCategories["Digested",dummy];
  DIGESTED = CopyMarker[RULES,"polynomials"];
  DestroyMarker[RULES];

  KNOWNPOL = GetCategories[{},dummy];
  LEFTOVER = SmallBasis[KNOWNPOL,{},knownsiter,
                        NCGBDebug->slow,
                        Deselect->deselect,
                        DegreeCap->degreecap,
                        DegreeSumCap->degreesumcap];
  DestroyMarker[KNOWNPOL];
  KNOWNPOL = LEFTOVER;

  SINGLERULES = GetCategories["singleRules",dummy];
  SINGLEPOLYS = ListToMarker[SINGLERULES,"polynomials"];

  DIGPOL = ComplementMarkers[DIGESTED,SINGLEPOLYS];

  DestroyMarker[DIGESTED];
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
  Do[ Print["cats[[",i,"]]=",cats[[i]]];
      ACAT = GetCategories[cats[[i]],dummy];
(*
Print["ACAT gives:"];
Print[ACAT];
PrintMarker[ACAT];
*)
      TEMP = CopyMarker[ACAT,"polynomials"];
      DestoryMarker[ACAT];
      ACAT = TEMP;
(*
Print["ACAT:"];
PrintMarker[ACAT];
Print["DIGPOL:"];
PrintMarker[DIGPOL];
*)
      COMP1 = ComplementMarkers[ACAT,DIGPOL];
(*
Print["COMP1:"];
PrintMarker[COMP1];
*)
      COMP2 = ComplementMarkers[COMP1,SINGLEPOLYS];
(*
Print["COMP2:"];
PrintMarker[COMP2];
*)
      DestoryMarker[COMP1];
     
If[slow
  , Print["MXS:The complement ",RetrieveMarker[COMP2]];
];
(*
Print["number:",Global`numberOfElementsBehindMarker[COMP2]];
*)
      If[Global`numberOfElementsBehindMarker[COMP2]>0
        , 
If[slow
  , Print["ACAT:",RetrieveMarker[ACAT]];
    Print["DIGPOL:",RetrieveMarker[DIGPOL]];
    Print["iter:",iter];
];
          lump[i]=SmallBasis[ACAT,
                             DIGPOL,
(*
                             lump[0],
*)
                             iter
                             ,Deselect->deselect
                             ,NCGBDebug->slow
(*
                             ,ReduceAlsoUsing->digpol
*)
                             ,DegreeCap->degreecap
                             ,DegreeSumCap->degreesumcap
                            ];
        , lump[i] = CreateMarker["polynomials"]; 
      ];
(*
Print["lump[",i,"] is ", RetrieveMarker[lump[i]]];
*)
If[slow
  , Put[RetrieveMarker[lump[i]],"lumpOf"<>ToString[i]];
    PutAppend[RetrieveMarker[ACAT],"lumpOf"<>ToString[i]];
];
      DestroyMarker[COMP2];
      DestroyMarker[ACAT];
  ,{i,Length[cats]}];
  ClearCategoryFactory[dummy]; (* still needs to be written *)
If[True (*slow*)
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
  Return[result];
];

(* in the SmallBasisByCategory routine above,
we shoould remember to return the relations in all categories
whether or not SmallBasis is calculated on each of the categories.
Currently the code is limited to categories with no more than two unknowns
*)
SmallBasisByCategory[x___] := BadCall["SmallBasisByCategory",x];

