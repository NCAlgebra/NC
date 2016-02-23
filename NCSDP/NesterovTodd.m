(* :Title: 	NesterovTodd.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    NesterovTodd` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NesterovTodd`",
	      "NCDebug`"
]

Clear[NesterovToddScaling];
NesterovToddScaling::usage = "";

Clear[NesterovToddCorrector];
NesterovToddCorrector::usage = "";

Begin[ "`Private`" ]

  NesterovToddScaling[ R_, L_ ] := Module[
    {UDVt, Lt, V, d, W, G},

    (* X = L^T L, S = R^T R *) 

    Lt = Map[Transpose, L];

    NCDebug[3, Lt];

    (* U D V^T = R L^T *)

    UDVt = Map[ SingularValueDecomposition, 
                MapThread[ Dot, {R, Lt}] ];

    d = Map[ Tr[#, List]&, Part[ UDVt, All, 2 ] ];
    V = Part[ UDVt, All, 3 ];

    NCDebug[3, UDVt, V, D, d];

    (* G = L^T V D^{-1/2} *)
 
    G = MapThread[ Dot, {Lt, V, Map[DiagonalMatrix[1/Sqrt[#]]&, d]} ];

    (* W = G G^T *)
    W = MapThread[ Dot, {G, Map[Transpose, G]} ];

    NCDebug[3, G, W, d];

    Return[{W, G, d}];

  ];

  NesterovToddCorrector[dX_, dS_, G_, d_] := Module[
    { K, de },

    (* Ktilde = He{G^{-1} dX dS G} ./ (d e^T + e d^T) *)

    K = MapThread[ Dot, {dX, dS, G} ];
    K = MapThread[ LinearSolve, {G, K} ];
    K = K + Map[ Transpose, K ];

    NCDebug[3, K];

    (* de = d e^T *)
    de = Map[ Outer[Times, #, ConstantArray[1, Length[#]]]&, d ];
    de = de + Map[ Transpose, de ];

    NCDebug[3, de];

    K = MapThread[ Divide, {K, de} ];

    NCDebug[3, K];

    (* K = G Ktilde G^T *)
   
    K = MapThread[ Dot, {G, K, Map[Transpose, G]} ];
    K = ( K + Map[ Transpose, K ] ) / 2;

    NCDebug[3, K];

    Return[K];

  ];

End[]

EndPackage[]
