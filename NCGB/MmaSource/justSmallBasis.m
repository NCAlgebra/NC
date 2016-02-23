Clear[SmallBasis];

Options[SmallBasis] := {Deselect->{},
                        Slow->False,
                        NCGBDebug->False,
                        ReduceAlsoUsing->{},
                        DegreeCap->-1,
			DegreeSumCap->-1};

SmallBasis[{},keep_List,iter_?NumberQ,opts___Rule]:= {};

SmallBasis[large:(_List |
                  GBMarker[_Integer,"polynomials"] |
                  GBMarker[_Integer,"rules"]),
            keep:(_List |
                 GBMarker[_Integer,"polynomials"] |
                 GBMarker[_Integer,"rules"]),
          iter_?NumberQ,opts___Rule]:=
Module[{result,deselects,reducealsousing,degreecap,degreesumcap,
 trashAtEnd,numKEEP,numLARGE,trashAtEndOfWhile,changed,shouldloop2,slow,
 kk,zeroPlaces,shouldloop,LARGE,KEEP,BASIS,FIRST,LEFTOVER,BIG,REDUCED,
 DEBUGFirst,DEBUG,newRange},
(*{result,shouldLoop,leftoverrels,relations,reduced,basislist,
        basis,item,j,deselects,totalvars,GrabsLoaded,
        degreecap,degreesumcap,shouldLoop2,kk,changed,
        rform,reducealsousing,temp,bigset},
*)

  (* Grab the options *)
  deselects=Deselect/.{opts}/.Options[SmallBasis];
  reducealsousing = ReduceAlsoUsing/.{opts}/.Options[SmallBasis];
  degreecap= DegreeCap/.{opts}/.Options[SmallBasis];
  degreesumcap= DegreeSumCap/.{opts}/.Options[SmallBasis];

  slow = NCGBDebug/.{opts}/.Options[SmallBasis];
  If[Not[FreeQ[{opts},Slow]]
    , Print["Please use the option NCGBDebug next time."];
      slow = Slow/.{opts}/.Options[SmallBasis];
  ];
  
  trashAtEnd = {};

  If[Head[large]===List
     , LARGE = RuleToPol[large];
       LARGE = sendMarkerList["polynomials",LARGE];
     , LARGE = CopyMarker[large,"polynomials"];
  ];
  If[Head[keep]===List
    , KEEP = RuleToPol[keep];
      KEEP = sendMarkerList["polynomials",KEEP];
    , KEEP = CopyMarker[keep,"polynomials"];
  ];
  AppendTo[trashAtEnd,KEEP];
  BASIS = Global`CreateMarker["polynomials"];
  numKEEP = Global`numberOfElementsBehindMarker[KEEP];
  numLARGE = Global`numberOfElementsBehindMarker[LARGE];
  If[And[numKEEP===0,numLARGE>0]
    , FIRST = MarkerTake[LARGE,{1}];
      AppendMarker[BASIS,FIRST];
      LEFTOVER = MarkerTake[LARGE,Range[2,numLARGE]];
      DestroyMarker[{FIRST,LARGE}];
      LARGE = LEFTOVER;
      numLARGE = numLARGE - 1;
  ];

  (* Record reduced forms for future enhancements *)

  While[Not[numLARGE===0],
Print["Number of equations left:",numLARGE];
    trashAtEndOfWhile = {};
    (* Make a big set to use for reducing *)
    BIG = CopyMarker[KEEP,"polynomials"];
    AppendTo[trashAtEndOfWhile,BIG];
    AppendMarker[BIG,BASIS];
    If[Not[Global`numberOfElementsBehindMarker[LARGE]
           ===numLARGE]
         , 
           Print["numLARGE is ",numLARGE];
           Print["numLARGE should be ",
                 Global`numberOfElementsBehindMarker[LARGE]];
           BadCall["SmallBasis place 1",large,keep,iter,opts];
    ];
    If[numLARGE==0
       , BadCall["SmallBasis place 2",large,keep,iter,opts];
    ];
    If[slow
      , Print["Considering:"];
        FIRST = MarkerTake[LARGE,{1}];
        PrintMarker[FIRST];
        Print["Biggest set to compare against:"];
        PrintMarker[BIG];
        Print["Actually comparing against:"];
        PrintMarker[BIG];
        DestroyMarker[FIRST];
    ];
    changed = False;
    zeroPlace = {};
    If[Global`numberOfElementsBehindMarker[BIG]>0
      , 
        NCMakeGB[BIG,0,
                 SupressAllCOutput->True,
                 Deselect->deselects,
                 ReturnRelations->False,
                 ReorderInput->True,
                 DegreeCap->degreecap,
                 DegreeSumCap->degreesumcap];
        AppendTo[trashAtEndOfWhile,BIG];
        shouldLoop2 = True;
        For[kk=1,kk<=iter&&shouldLoop2,++kk,
          MoraAlg`NCContinueMakeGB[kk];
          (* reduce by above partial gb *)
          REDUCED = Reduce`FastReduction[LARGE];
          zeroPlaces = informZeros[REDUCED];
          If[slow
            , DEBUGFirst = MarkerTake[REDUCED,{1}];
              Print["MXS:SmallBasis:test:",RetrieveMarker[DEBUGFirst]];
              Global`DestroyMarker[DEBUGFirst];
          ];
          shouldLoop2=Not[MemberQ[zeroPlaces,0]];
        ];
        changed = Not[shouldLoop2];
        zeroPlaces = informZeros[REDUCED];
Print["zeroPlaces:",zeroPlaces];
        If[slow
           , Print["Started with:",RetrieveMarker[LARGE]];
        ];
      , (* Do Nothing *)
      , Abort[];
    ];
    newRange = Range[2,numLARGE];
    If[Length[zeroPlaces]>0
      , newRange = Complement[newRange,zeroPlaces];
    ];
    If[Not[MemberQ[zeroPlaces,1]]
      , FIRST = MarkerTake[LARGE,{1}];
        AppendMarker[BASIS,FIRST];
        DestroyMarker[FIRST];
    ];
    If[slow
      , DEBUG = MarkerTake[LARGE,zeroPlaces];
        Print["Have eliminated:",Global`RetrieveMarker[DEBUG]];
        DestroyMarker[DEBUG];
    ];
    LEFTOVER = MarkerTake[LARGE,newRange];
    DestroyMarker[LARGE];
    LARGE = LEFTOVER; (* Marker assignment, not copy *)
    numLARGE = Global`numberOfElementsBehindMarker[LARGE];
(* COMMENTED OUT TEMPORARILY MXS
    NCGBEmpty[trashAtEndOfWhile];
*)
  ];(*While*)
  NCGBEmpty[trashAtEnd];
  If[Head[large]===List
    , result = Global`RetrieveMarker[BASIS];
      DestroyMarker[BASIS];
    , result = BASIS;
  ];
  Return[result];
];

SmallBasis[x___] := BadCall["SmallBasis",x];
