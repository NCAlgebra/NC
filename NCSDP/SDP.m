(* :Title: 	SDP.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    SDP` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "SDP`",
              "PrimalDual`",
              "MatrixVector`",
	      "NCDebug`"
]

Clear[SDPEval,
      SDPDualEval,
      SDPMatrices,
      SDPSolve,
      SDPPrimalEval,
      SDPScale,
      SDPSylvesterEval,
      SDPInner,
      SDPFunctions,
      SDPCheckDimensions];

Get["SDP.usage"];
Get["SDP.private.usage"];

SDP::ErrorInDimensions = "Dimension error: `1`";
SDP::notLinear = "Expression is not linear.";

Begin[ "`Private`" ]

  (* Evaluation and scaling *)

  SDPPrimalEval[A_List, y_List] := 
    Plus @@ (A * y);

  SDPDualEval[A_List, X_List] := 
    Map[(Total[# * X, 3])&, A];

  SDPEval[A_List, {{y_List}}] := SDPPrimalEval[A, y];

  SDPScale[A_List, W_List] := SDPScale[A, W, W];
  SDPScale[A_List, Wl_List, Wr_List] :=  
    Map[(MapThread[(Dot[#1,#2,#3])&,{Wl,#,Wr}])&, A];

  SDPInner[x_, y_] := Total[MapThread[Total[Flatten[#1*#2]]&, {x, y}]];

  (* Sylvester functions *)

  SDPSylvesterEval[A_List, W_List] := SDPSylvesterEval[A, W, W];
  SDPSylvesterEval[A_List, Wl_List, Wr_List] := 
    Map[(SDPDualEval[A,#])&, SDPScale[A, Wl, Wr]];

  (*
  SDPSylvesterDiagonalEval[A_List, W_List] := 
    SDPSylvesterDiagonalEval[A, W, W];
  SDPSylvesterDiagonalEval[A_List, Wl_List, Wr_List] := 
    MapThread[Total[#1 * #2, 3]&, {A, SDPScale[A, Wl, Wr]}];
  *)

  (* Dimension checking *)
  SDPCheckDimensions[A_List,B_List,C_List] := Module[ 
    {},

    (* Check dimensions *)
    If[ Depth[A] != 5,
        Message[SDP::ErrorInDimensions, "Depth of A must be 5"];
    ];

    If[ Depth[B] != 4,
        Message[SDP::ErrorInDimensions, "Depth of B must be 4"];
    ];

    If[ Depth[C] != 4,
        Message[SDP::ErrorInDimensions, "Depth of C must be 4"];
    ];

    If[ Part[Dimensions[A], 1] != Part[Dimensions[B] , 3],
        Message[SDP::ErrorInDimensions, "Number of columns of A must match dimensions of B"];
    ];

    If[ Part[Dimensions[A], 2] != Part[Dimensions[C] , 1],
        Message[SDP::ErrorInDimensions, "Number of blocks of A must match number of blocks of C"];
    ];

    If[ Map[Dimensions, A[[1]]] != Map[Dimensions, C],
        Message[SDP::ErrorInDimensions, "Dimensions of blocks of A must match dimensions of blocks of C"];
    ];

  ];


  (* Coefficients *)

  Clear[SDPCoefficients];
  SDPCoefficients[exp_, var_] := Module[
    {tmp},

    Quiet[
      Check[  tmp = CoefficientArrays[exp, var];
          ,
            tmp = If[MatrixQ[exp], {{},{}}, {0,{}}];
            Message[SDP::notLinear];
          ,
            CoefficientArrays::poly
      ];
    ,
      CoefficientArrays::poly
    ];
    If[ Length[tmp] > 2,
       Message[SDP::notLinear];
    ];
    Return[{tmp[[1]], tmp[[2]]}];
  ];

  Clear[SDPLinearCoefficientArrays];
  SDPLinearCoefficientArrays[exp_?MatrixQ, var_List] := Module[
    {lin, coeffs, m = Dimensions[exp][[2]]},
    {lin, coeffs} = SDPCoefficients[Flatten[exp], var];
    { List[Partition[lin, m]], 
      Map[List, Map[Partition[#, m]&, Transpose[coeffs]]] }
  ]

  SDPLinearCoefficientArrays[exp_List, var_List] := \
    SDPJoinCoefficientArrays @@ \
      Map[SDPLinearCoefficientArrays[#, var]&, exp];

  SDPLinearCoefficientArrays[exp_, var_List] := Module[
    {coeffs, lin},
    {lin, coeffs} = SDPCoefficients[exp, var];
    Return[{{SparseArray[{{lin}}]}, Map[{SparseArray[{{#}}]}&, coeffs]}];
  ]

  Clear[SDPJoinCoefficientArrays];
  SDPJoinCoefficientArrays[sdp1_, sdp2_, sdp3__] := \
    SDPJoinCoefficientArrays[SDPJoinCoefficientArrays[sdp1, sdp2], sdp3];

  SDPJoinCoefficientArrays[sdp1_, sdp2_] := \
    {Join[sdp1[[1]], sdp2[[1]]], Join[sdp1[[2]], sdp2[[2]], 2]};

  SDPJoinCoefficientArrays[sdp1_] := sdp1;

  (* SDPMatrices *)
  
  SDPMatrices[a_, vars_] := Module[
    {AA, CC}, 

    (* Extract constraints *)
    {CC, AA} = SDPLinearCoefficientArrays[a, vars];

    (* Format data as: max <b, x> s.t. a(x) <= c *)
    AA = - AA;

    Return[{AA, {{0 vars}}, CC}];

  ];

  SDPMatrices[f_, a_, vars_] := Module[
    {AA, BB, CC, dummy}, 

    (* Problem format is: min f s.t. a >= 0 *)

    (* Extract constraints *)
    {AA,dummy,CC} = SDPMatrices[a, vars];

    (* Extract objective *)
    {dummy, BB} = SDPLinearCoefficientArrays[f, vars];

    (* Format data as: max <b, x> s.t. a(x) <= c *)
    BB = - {{Flatten[BB]}};

    Return[{AA,BB,CC}];

  ];

  (* SDPFunctions *)

  SDPFunctions[{AA_List,BB_List,CC_List},opts:OptionsPattern[{}]] := Module[ 
    { FDualEval, FPrimalEval, FSylvesterEval }, 

    (* Check dimensions *)
    SDPCheckDimensions[AA,BB,CC];

    FDualEval = {{SDPDualEval[AA, {##}]}}&;
    FPrimalEval = SDPPrimalEval[AA, ##[[1]]]&;
    FSylvesterEval = SDPSylvesterEval[AA, #1, #2]&;

    (* Return *)
    Return[ {FDualEval, FPrimalEval, FSylvesterEval} ];

  ];

  (* SDPSolve *)

  SDPSolve[{AA_,BB_,CC_},opts:OptionsPattern[{}]] := Module[
    {FDualEval, FPrimalEval, FSylvesterEval,
     options, retValue},

    (* Generate functions *)
    { FDualEval, FPrimalEval, FSylvesterEval } 
      = SDPFunctions[{AA,BB,CC},opts];

    (* Solve problem *)
    retValue = 
      PrimalDual[ FDualEval, FPrimalEval, FSylvesterEval,
		  BB, CC, opts ];

    Return[retValue];

  ];

End[]

EndPackage[]
