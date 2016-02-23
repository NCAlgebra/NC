Clear[SmallBasisRR];

Options[SmallBasisRR] := {Deselect->{}};

SmallBasisRR[{},keep_List,iter_?NumberQ,history_GBMarker,opts___Rule]:= {};

SmallBasisRR[large_List,keep_List,
             (* hist_GBMarker,*)iter_?NumberQ,opts___Rule] :=
Module[{Large,Keep,stuff},
  stuff = Union[large,keep];
  NCMakeGB[stuff,0,ReturnRelations->False];
  Large = Map[NumberOfRelation,large];
Print["Large:",Large];
Input[];
  Keep = Map[NumberOfRelation,keep];
Print["Keep:",Keep];
Input[];
  Return[SmallBasisRR[Large,Keep,iter,opts]];
];

SmallBasisRR[large:{___Integer},keep:{___Integer},
             (* hist_GBMarker,*)iter_?NumberQ,opts___Rule]:=
Module[{shouldLoop,leftoverrels,relations,reduced,basislist,
        basis,item,result,j,k,deselects,totalvars,GrabsLoaded,
        rform,temp,bigset,ans,
        firstnonzero,w,iterCounter,ww,rFormTemp,didAllBefore,
        reallyDone,shouldLoopTwo,RRtoReduce,
        rrNew,rrPosNew,rrPosOld,rest,kk,polynomialsMarker},
(*
Print["MXS: starting smallbasisrr with:",large,
      " and ",keep," with ",iter," iterations ",
      "and options ",{opts}];
*)

  (* Grab the options *)
  deselects=Deselect/.{opts}/.Options[SmallBasis];

  Do[ rform[j] = RuleToPoly[large[[j]]];
      If[Or[MemberQ[Table[rform[k],{k,1,j-1}],rform[j]],
            MemberQ[keep,rform[j]]]
            , rform[j] = 0;
      ];
  ,{j,1,Length[large]}];

  (* have process Table[large[k],{k,1,didallbefore-1}] *)
  didAllBefore = 1;   

  reallyDone = False;

  RFORMS := Table[rform[k],{k,1,Length[large]}];
  PRESENTBASIS := Map[large[[#]]&,basislist];
  REST := Table[rform[k],{k,didAllBefore,Length[large]}];
  ADVANCEDONE := 
   ( While[rform[didAllBefore]===0 && didAllBefore<=Length[large],
         didAllBefore++;
     ];
     reallyDone = didAllBefore>Length[large];
   );
Print["rforms:",RFORMS];
Print["keep:",keep];
  ADVANCEDONE;
  basislist = {}; (* basislist will be a list of numbers *)
  If[Length[keep]===0
    , If[Not[reallyDone]
       , AppendTo[basislist,didAllBefore];
         didAllBefore++;
      ];
  ];

  RRtoReduce = RetrieveMarker[history]; (* Will change for upgrade *)
  rrPosOld = {};

  (* Record reduced forms for future enhancements *)

  While[And[didAllBefore<=Length[large],Not[reallyDone]],
    bigset = Join[PRESENTBASIS,keep];
    If[Length[bigset]>0
      , NCMakeGB[bigset,0,
                 Deselect->deselects,
                 ReturnRelations->False,
                 ReorderInput->True];
Print["bigset:",bigset];
        For[iterCounter=1,
             And[iterCounter<=iter,Not[reallyDone]],
             iterCounter++,
          MoraAlg`NCContinueMakeGB[iterCounter];
Print["PartialGB on step ",iterCounter];
Print[ColumnForm[WhatIsPartialGB[]]];
Print["REST:",REST];
          polynomialsMarker = CreateMarker["polynomials"];
          rest = REST;
          Do[ addToContainer[polynomialsMarker,rest[[kk]]];
          ,{kk,1,Length[rest]}];
          rFormTemp = Reduce`FastReduction[polynomialsMarker];
Print["rFormTemp:",rFormTemp];
          rFormTemp = Global`RetrieveMarker[rFormTemp];
Print["rFormTemp:",rFormTemp];
          rrNew = Reduce`FastReduction[RRtoReduce];
          If[Not[rrNew===RRtoReduce]
             , (* can do something with RR *)
               rrPosNew = Flatten[Position[rrNew,0]];
               temp = Complement[rrPosNew,rrPosOld];
               If[Length[temp]>0
                 , numbers = Join[rrPosNew,REST];
                   ans = internalMarkerRemove[numbers,history[[1]]];
                   (* code here *)
               ];
               rrPosOld = rrPosNew;
               RRtoReduce = rrNew;
          ];
Print["rFormTemp:",rFormTemp];
If[Not[didAllBefore+Length[rFormTemp]-1===Length[large]]
  , Print["Length mismatch"];
    Print["didAllBefore-1:",didAllBefore-1];
    Print["Length[rFormTemp]:",Length[rFormTemp]];
    Print["Length[large]:",Length[large]];
];
          Table[rform[ww+didAllBefore-1]=rFormTemp[[ww]];
            ,{ww,1,Length[rFormTemp]}];
          reallyDone = Union[rFormTemp]==={0};
        ];
      ];
      ADVANCEDONE;
      If[didAllBefore<=Length[large]
        , AppendTo[basislist,didAllBefore];
          didAllBefore++;
          ADVANCEDONE;
      ];
  ];(*While*)
  result = PRESENTBASIS;
  Clear[rform];
  Return[result];
];

SmallBasisRR[x___] := BadCall["SmallBasisRR",x];
