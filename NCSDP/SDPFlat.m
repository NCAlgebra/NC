(* :Title: 	SDPFlat.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    SDPFlat` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "SDPFlat`",
	      "SDP`",
              "PrimalDual`",
              "MatrixVector`",
	      "NCDebug`"
]

Clear[SDPFlatData,
      SDPFlatDualEval,
      SDPFlatPrimalEval,
      SDPFlatSylvesterEval];

Begin[ "`Private`" ]

  (* SDPEval *)
  (* SDPEval = SDPFlatPrimalEval; *)

  (* SDPEval *)
  (* SDPDualEval = SDPFlatDualEval; *)
  
  SDPFlatData[{AA_,BB_,CC_}] := Module[
    {AFlat, CFlat, dims},
    
    AFlat = Transpose[SparseArray[Apply[Join, Map[Flatten, AA, {2}], 1]]];
    CFlat = Apply[Join, Map[Flatten, CC, {1}]];
    dims = Map[Dimensions, CC, 1];

    Return[{AA, AFlat, CFlat, dims}];
  ]

  (* SDPFunctions *)
  Clear[SDPFunctionsAux];
  SDPFunctionsAux[AA_List, AFlat_SparseArray,
                  CFlat_, dims_List ] :=
  Module[ 
    { FDualEval, FPrimalEval, FSylvesterEval }, 

    FDualEval = {{SDPFlatDualEval[AFlat, {##}]}}&;
    FPrimalEval = SDPFlatPrimalEval[AFlat, dims, ##[[1]]]&;
    FSylvesterEval = SDPFlatSylvesterEval[AA, AFlat, #1, #2]&;

    (* Return *)
    Return[ {FDualEval, FPrimalEval, FSylvesterEval} ];

  ];

  SDPFunctions[{AA_List,BB_List,CC_List},opts:OptionsPattern[{}]] := 
    SDPFunctionsAux @@ SDPFlatData[{AA,BB,CC}];

  (* Flat Evaluations *)

  SDPFlatPrimalEval[AFlat_SparseArray, dims_, y_List] := 
    MatrixVectorReshape[AFlat . y, dims];

  SDPFlatDualEval[AFlat_SparseArray, X_List] := 
    MatrixVectorToVector[X] . AFlat;

  (* Flat Sylvester functions *)

  SDPFlatSylvesterEval[A_List, AFlat_SparseArray, W_List] := 
    SDPFlatSylvesterEval[A, AFlat, W, W];

  SDPFlatSylvesterEval[A_List, AFlat_SparseArray, Wl_List, Wr_List] := 
    SparseArray[Apply[Join, Map[Flatten, SDPScale[A, Wl, Wr], {2}], 1]] . AFlat

End[]

EndPackage[]
