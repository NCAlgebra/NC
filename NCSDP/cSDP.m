(* :Title: 	cSDP.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    cSDP` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "cSDP`",
	      "SDP`",
              "PrimalDual`",
              "MatrixVector`",
	      "NCDebug`"
]

Clear[SDPcData];
SDPcData::usage = "";

Clear[SDPcPrimalEval];
SDPcPrimalEval::usage = "";

Clear[SDPcDualEval];
SDPcDualEval::usage = "";

Clear[SDPcSylvesterEval];
SDPcSylvesterEval::usage = "";

Clear[SDPcSylvesterSolve];
SDPcSylvesterSolve::usage = "";

Clear[SDPcSylvesterSolveFactored];
SDPcSylvesterSolveFactored::usage = "";

Begin[ "`Private`" ]

  Install["cSDP"];

  SDPcData[{AA_List,BB_List,CC_List}] := Module[
    {AFlat,ARules,m,n,valA,indA,locA,sizeBlocks},

    (* Check dimensions *)
    SDPCheckDimensions[AA,BB,CC];

    (* Make large sparse mapping *)
    AFlat = SparseArray[Apply[Join, Map[Flatten, AA, {2}], 1]];
    {n,m} = Dimensions[AFlat];

    (* Extract indices *)
    ARules = Drop[ArrayRules[AFlat], -1];
    valA = Part[ARules, All, 2];
    indA = Part[ARules, All, 1, 2];
    locA = Prepend[1 + Accumulate[Map[Length,Split[Part[ARules, All, 1, 1]]]], 1];
    
    (* Extract block sizes *)
    sizeBlocks = Flatten[Map[Dimensions, CC, 1]];

    (* Setup data *)
    cSDPInitialize[m,n,valA,indA,locA,sizeBlocks];

    Return[{AA,n,sizeBlocks}];

  ];

  (* SDPFunctions *)
  
  SDPFunctions[AA_List, n_Integer, sizeBlocks_List] := 
  Module[
    { FPrimalEval, FDualEval, 
      FSylvesterEval, 
      FSylvesterSolve, FSylvesterSolveFactored }, 

    (*
    FPrimalEval = {{SDPPrimalEval[AA, {##}]}}&;
    FDualEval = SDPDualEval[AA, ##[[1]]]&;
    *)

    FPrimalEval = {{SDPcPrimalEval[{##}]}}&;
    FDualEval = SDPcDualEval[sizeBlocks, ##[[1]]]&;

    FSylvesterEval = SDPcSylvesterEval[n, #1, #2]&;

    FSylvesterSolve = SDPcSylvesterSolve;
    FSylvesterSolveFactored = SDPcSylvesterSolveFactored;

    (* Return *)
    Return[ {FPrimalEval, FDualEval, 
             FSylvesterEval, 
	     FSylvesterSolve, FSylvesterSolveFactored} ];

  ];

  SDPFunctions[{AA_List,BB_List,CC_List},opts:OptionsPattern[{}]] := 
    SDPFunctions @@ SDPcData[{AA,BB,CC}];

  (* Evaluation *)

  SDPcDualEval[sizeBlocks_List, y_List] := 
    MatrixVectorReshape[cSDPDualEval[y], 
                        Partition[sizeBlocks, 2]];

  SDPcPrimalEval[X_List] := cSDPPrimalEval[Flatten[X]];

  (* Sylvester *)

  SDPcSylvesterEval[n_Integer, W_List] := 
    SDPcSylvesterEval[n,W, W];

  SDPcSylvesterEval[n_Integer, Wl_List, Wr_List] := 
    Partition[
      cSDPSylvester[Flatten[Wl], Flatten[Wr]],
      n
    ];

  SDPcSylvesterSolve[W_List,B_List] := 
    SDPcSylvesterSolve[W,W,B];

  SDPcSylvesterSolve[Wl_List,Wr_List,B_?MatrixQ] := Module[
    {m,n},
    
    {m,n} = Dimensions[B];
    Return[ 
      Partition[
        cSDPSylvesterSolve[Flatten[Wl], Flatten[Wr], m, Flatten[B]]
        ,n]
    ];
  ];

  SDPcSylvesterSolve[Wl_List,Wr_List,B_List] := 
    cSDPSylvesterSolve[Flatten[Wl], Flatten[Wr], 1, B];

  SDPcSylvesterSolveFactored[B_?MatrixQ] := Module[
    {m,n},
    
    {m,n} = Dimensions[B];
    Return[
      Partition[
        cSDPSylvesterSolveFactored[m, Flatten[B]]
       ,n]
    ];
  ];

  SDPcSylvesterSolveFactored[B_List] := 
    cSDPSylvesterSolveFactored[1, B];

End[]

EndPackage[]
