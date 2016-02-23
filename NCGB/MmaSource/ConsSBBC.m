Clear[SmallBasisByCategory];

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
$NC$NCGBMmaDiagnosticPrint["userSelects:",userSelects];


  digested=RuleToPoly[GetCategories["Digested",dummy]];
  singleRules = RuleToPoly[GetCategories["singleRules",dummy]];
  knownpol = dummy[{}];
  knownpol = SmallBasis[knownpol,{},knownsiter,
           (*              Deselect->deselect,   
     9/19/99 Dell removed since Mark disabled deselects *) 
                        DegreeCap->degreecap,
                        DegreeSumCap->degreesumcap];
  digpol=Complement[digested,singleRules];
(*
Put[digpol,ToString[Unique["digpol"]]];
*)
  Clear[lump];
  lump[0] = Union[SmallBasis[digpol,{},knownsiter],knownpol];
(*
Print["Done with the digested"];
Print["Started with:",digpol];
Print["Ended with:",lump[0]];
*)
(*
Put[lump[0],"lumpOf"<>ToString[0]];
*)
  deselect = Union[deselect,digpol];
  Do[ $NC$NCGBMmaDiagnosticPrint["cats[[",i,"]]=",cats[[i]]];
      aCat = RuleToPol[dummy[cats[[i]]]];
      $NC$NCGBMmaDiagnosticPrint["MXS:The complement ",Complement[aCat,Join[digpol,singleRules]]];
      If[Not[Complement[aCat,Join[digpol,singleRules]]==={}]
        , 
          $NC$NCGBMmaDiagnosticPrint["aCat:",aCat];
          $NC$NCGBMmaDiagnosticPrint["digpol:",digpol];
          $NC$NCGBMmaDiagnosticPrint["iter:",iter];
          lump[i]=SmallBasis[aCat,
                             digpol,
(*
                             lump[0],
*)
                             iter
(* 9/19/99 Dell took out
since Mark disabled deselects
                             ,Deselect->deselect

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
