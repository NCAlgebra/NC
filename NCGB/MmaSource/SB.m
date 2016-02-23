Clear[SmallBasis];

Options[SmallBasis] := {Deselect->{},
                        Slow->False,
                        NCGBDebug->False,
                        ReduceAlsoUsing->{},
                        Symmetric->False,
                        DegreeCap->-1,
			DegreeSumCap->-1};

SBOptions[aList_List,symbol_Symbol] :=
Module[{},
  symbol["symmetric"] = Symmetric/.{opts}/.Options[SmallBasis];
  symbol["deselects"] = Deselect/.{opts}/.Options[SmallBasis];
  symbol["reducealsousing"] = ReduceAlsoUsing/.{opts}/.Options[SmallBasis];
  symbol["degreecap"] = DegreeCap/.{opts}/.Options[SmallBasis];
  symbol["degreesumcap"] = DegreeSumCap/.{opts}/.Options[SmallBasis];
 
  symbol["slow"]  = NCGBDebug/.{opts}/.Options[SmallBasis];
  If[Not[FreeQ[{opts},Slow]]
    , Print["Please use the option NCGBDebug next time."];
      symbol["slow"] = Slow/.{opts}/.Options[SmallBasis];
  ];
];

SBGrabFirst[x_GBMarker,num_] :=
Module[{FIRST,REST},
  FIRST = MarkerTake[x,{1}];
  REST = MarkerTake[x,Range[2,num]];
  Return[{FIRST,REST}];
];

SBGrabFirst[x___] := BadCall["SBGrabFirst",x];



SmallBasis[{},keep_List,iter_?NumberQ,opts___Rule]:= {};

SmallBasis[large:(_List |
                  GBMarker[_Integer,"polynomials"] |
                  GBMarker[_Integer,"rules"]),
            keep:(_List |
                 GBMarker[_Integer,"polynomials"] |
                 GBMarker[_Integer,"rules"]),
          iter_?NumberQ,opts___Rule]:=
Module[{options,LARGE,KEEP,BASIS,trashAtEnd,FORSYMMETRIC,
        numKEEP,numLARGE,FIRST,
result,deselects,reducealsousing,degreecap,degreesumcap,
 ,trashAtEndOfWhile,changed,shouldloop2,slow,
 kk,zeroPlaces,shouldloop,,LEFTOVER,BIG,REDUCED,
 NEW,DEBUGFirst,DEBUG,newRange,symmetric,FORSYMMETRIC,NEW1,NEW2,NEW21},
(*{result,shouldLoop,leftoverrels,relations,reduced,basislist,
        basis,item,j,deselects,totalvars,GrabsLoaded,
        degreecap,degreesumcap,shouldLoop2,kk,changed,
        rform,reducealsousing,temp,bigset},
*)

  SBOptions[{opts},options];
  
  trashAtEnd = {};

  LARGE = ListToMarker[large,"polynomials"];
  KEEP = ListToMarker[keep,"polynomials"];
  trashAtEnd = {trashAtEnd,LARGE,KEEP];
  BASIS = Global`CreateMarker["polynomials"];
  If[symmetric
    , FORSYMMETRIC = Global`CreateMarker["polynomials"];
  ];
  numKEEP = Global`numberOfElementsBehindMarker[KEEP];
  numLARGE = Global`numberOfElementsBehindMarker[LARGE];
  If[And[numKEEP===0,numLARGE>0]
    , PAIR = SBGrabFirst[LARGE,numLARGE];
      AppendMarker[BASIS,PAIR[[1]]];
      DestroyMarker[{PAIR[[1]],LARGE}];
      LARGE = PAIR[[2]];
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
     If[symmetric
       , AppendMarker[BIG,FORSYMMETRIC];
     ];
     If[Not[Global`numberOfElementsBehindMarker[LARGE]===numLARGE]
       , Print["numLARGE is ",numLARGE];
         Print["numLARGE should be ",
               Global`numberOfElementsBehindMarker[LARGE]];
         BadCall["SmallBasis place 1",large,keep,iter,opts];
     ];
     If[numLARGE==0
       , BadCall["SmallBasis place 2",large,keep,iter,opts];
     ];
     If[options["slow"]
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
       , NCMakeGB[BIG,0,
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
            If[options["slow"]
              , DEBUGFirst = MarkerTake[REDUCED,{1}];
                Print["MXS:SmallBasis:test:",RetrieveMarker[DEBUGFirst]];
                Global`DestroyMarker[DEBUGFirst];
            ];
            shouldLoop2=Not[MemberQ[zeroPlaces,0]];
         ];
         changed = Not[shouldLoop2];
         zeroPlaces = informZeros[REDUCED];
         Print["zeroPlaces:",zeroPlaces];
         If[options["slow"]
           , Print["Started with:",RetrieveMarker[LARGE]];
         ];
      , (* Do Nothing *)
      , Abort[];
    ];
    newRange = Range[2,numLARGE];
    If[Length[zeroPlaces]>0
      , If[symmetric
          , NEW1 = MarkerTake[LARGE,zeroPlaces];
            NEW2 = MarkerAdjoint[NEW1];
            AppendMarker[FORSYMMETRIC,NEW2];
            DestroyMarker[{NEW1,NEW2}];
        ];
        newRange = Complement[newRange,zeroPlaces];
    ];
    If[Not[MemberQ[zeroPlaces,1]]
      , FIRST = MarkerTake[LARGE,{1}];
        If[symmetric
          , NEW = MarkerAdjoint[FIRST];
            AppendMarker[BASIS,NEW]; 
            DestroyMarker[NEW];
        ];
        AppendMarker[BASIS,FIRST];
        DestroyMarker[FIRST];
    ];
    If[options["slow"]
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
