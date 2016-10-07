(* :Title: 	NCSystem.m *)

(* :Author: 	Mauricio C. de Oliveira. *)

(* :Context: 	NCSystem` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :06/20/2001: First version (mauricio)
*)


BeginPackage[ "NCSystem`",
	      "NCMatMult`",
	      "NCMatrixDecompositions`",
	      "MatrixDecompositions`",
	      "NCUtil`",
	      "NonCommutativeMultiply`"
	];

Clear[NCSystem,
      System, 
      NCSystemQ,
      NCSInverse,
      NCSConnectParallel,
      NCSConnectSeries,
      NCSConnectPlus,
      NCSConnectFeeback,
      NCSystemToTransferFunction,
      NCSControllabilityMatrix,
      NCSObservabilityMatrix,
      NCSControllableRealization,
      NCSControllableSubspace,
      NCSObservableRealization,
      NCSObservableSubspace,
      NCSMinimalRealization
     ];

NCSystem::WrongDimensions = "Matrices `1` and `2` must have same `3` size.";

Begin["`Private`"];

  (* System definition *)

  System[a_?MatrixQ, b_?MatrixQ, c_?MatrixQ, d_?MatrixQ] :=
    Return[
      Check[
        If[ Dimensions[a][[1]] != Dimensions[b][[1]],
            Message[NCSystem::WrongDimensions, "a", "b", "row"];
        ];
        If[ Dimensions[c][[1]] != Dimensions[d][[1]],
            Message[NCSystem::WrongDimensions, "c", "d", "row"];
        ];
        If[ Dimensions[a][[2]] != Dimensions[c][[2]],
            Message[NCSystem::WrongDimensions, "a", "c", "column"];
        ];
        If[ Dimensions[b][[2]] != Dimensions[d][[2]],
            Message[NCSystem::WrongDimensions, "b", "d", "column"];
        ];
        NCSystem[a,b,c,d]
       ,
        $Failed
       ,
        NCSystem::WrongDimensions
      ]
    ];

  System[s_?MatrixQ, n_Integer] := Module[
      {m, p},
      {m, p} = Dimensions[s];
      Return[NCSystem[s[[1;;n,1;;n]], 
                      s[[1;;n,n+1;;p]], 
                      s[[n+1;;m,1;;n]], 
                      s[[n+1;;m,n+1;;p]]]];
  ];

  System[s___] := $Failed;

  (* NCSystemQ *)
  
  NCSystemQ[x_NCSystem] = True;
  NCSystemQ[x_] = False;

  (* Transpose System *)

  tp[s_NCSystem] := System @@ Map[tpMat, s][[{1,3,2,4}]];

  (* TransferFunction *)
  NCSystemToTransferFunction[s_NCSystem, var_Symbol:S] :=
   MatMult[s[[3]], 
           NCInverse[var IdentityMatrix[Dimensions[s][[3]]] - s[[1]]], 
           s[[2]]] + s[[4]];
  
  (* System dimensions *)

  Unprotect[Dimensions];
  Dimensions[s_NCSystem] := {
      Dimensions[s[[2]]][[2]], 
      Dimensions[s[[3]]][[1]],
      Dimensions[s[[1]]][[1]]
  };
  Protect[Dimensions];

  (* System Connections *)

  NCSConnectParallel[s1_NCSystem, s2_NCSystem] := Module[
    {n1,m1,p1,
     n2,m2,p2},

    {m1,p1,n1} = Dimensions[s1];
    {m2,p2,n2} = Dimensions[s2];

    Return[
      System[
        ArrayFlatten[{{s1[[1]],0},{0,s2[[1]]}}],
        ArrayFlatten[{{s1[[2]],0},{0,s2[[2]]}}],
        ArrayFlatten[{{s1[[3]],0},{0,s2[[3]]}}],
        ArrayFlatten[{{s1[[4]],0},{0,s2[[4]]}}]
      ]];
  ];    

  NCSConnectPlus[s1_NCSystem, s2_NCSystem] := Module[
    {n1,m1,p1,
     n2,m2,p2},

    {m1,p1,n1} = Dimensions[s1];
    {m2,p2,n2} = Dimensions[s2];

    Return[
      System[
        ArrayFlatten[{{s1[[1]],0},{0,s2[[1]]}}],
        ArrayFlatten[{{s1[[2]]},{s2[[2]]}}],
        ArrayFlatten[{{s1[[3]],s2[[3]]}}],
        s1[[4]]+s2[[4]]
      ]];
  ];    

  NCSConnectSeries[s1_NCSystem, s2_NCSystem] := Module[
    {n1,m1,p1,
     n2,m2,p2},

    {m1,p1,n1} = Dimensions[s1];
    {m2,p2,n2} = Dimensions[s2];

    Return[
      System[
        ArrayFlatten[{{s1[[1]],0},{MatMult[s2[[2]],s1[[3]]],s2[[1]]}}],
        ArrayFlatten[{{s1[[2]]},{MatMult[s2[[2]],s1[[4]]]}}],
        ArrayFlatten[{{MatMult[s2[[4]],s1[[3]]],s2[[3]]}}],
        MatMult[s2[[4]],s1[[4]]]
      ]];
  ];

  NCSInverse[s_NCSystem] := Module[
    {Di},

    Check[
      Di = NCInverse[s[[4]]];
     ,
      Return[$Failed];
     ,
      {MatrixDecompositions::Singular,MatrixDecompositions::Square}
    ];

    Return[
      System[
          s[[1]] - MatMult[s[[2]], Di, s[[3]]],
          MatMult[s[[2]], Di],
          -MatMult[Di, s[[3]]],
          Di
      ]];
  ];

  (* Controllability & Observability *)

  NCSControllabilityMatrix[sys_NCSystem, opts___] := 
      NCSControllabilityMatrix[sys[[1]], sys[[2]], opts];

  NCSObservabilityMatrix[sys_NCSystem, opts___] := 
      NCSObservabilityMatrix[sys[[1]], sys[[3]], opts];
      
  NCSControllabilityMatrix[a_?MatrixQ, b_?MatrixQ] := 
      NCSControllabilityMatrix[a, b, Length[a]];

  NCSControllabilityMatrix[a_?MatrixQ, b_?MatrixQ, q_Integer] := Module[
      {i, n = Length[a], m = Dimensions[b][[2]], mat},
      
      mat = ConstantArray[0, {n, q*m}];
      mat[[All,1;;m]] = b;
      For[ i = 1, i < q, i++,
           mat[[All,m*i+1;;m*(i+1)]] = MatMult[a, mat[[All,m*(i-1)+1;;m*i]]];
      ];
      Return[mat];
      
  ];

  NCSObservabilityMatrix[a_?MatrixQ, c_?MatrixQ, opts___] := 
    tpMat[NCSControllabilityMatrix[tpMat[a], tpMat[c], opts]];

  (* Controllable realization *)
  NCSControllableRealization[sys_NCSystem] := Module[
      {L, rank, R},
      
      (* Calculate controllable subspace *)
      {L, rank} = NCSControllableSubspace[sys[[1]],sys[[2]]];

      (* Calculate projection *)
      R = NCInverse[L][[All,1;;rank]];
      L = L[[1;;rank]];
      
      Return[
          NCSystem[MatMult[L, sys[[1]], R],
                   MatMult[L, sys[[2]]],
                   MatMult[sys[[3]], R],
                   sys[[4]]]
      ];
  ];

  NCSControllableSubspace[a_?MatrixQ, b_?MatrixQ, opts___] := Module[
      {ctrb = NCSControllabilityMatrix[a,b,opts], L},
      
      (* Determine Rank *)
      {lu,p,q,rank} = NCLUDecompositionWithCompletePivoting[ctrb];
      {l,u} = GetLUMatrices[lu];

      (* P ctrb Q = L U *)
      (* R ctrb = U Q^T, L = L \ P *)
      L = NCLowerTriangularSolve[l, IdentityMatrix[Length[ctrb]][[p]]];

      (*
      Print["ctrb = ", ctrb];
      Print["l = ", Normal[l]];
      Print["u = ", Normal[u]];
      Print["rank = ", rank];
      Print["L = ", L];
      Print["L ctrb = ", MatMult[L, ctrb]];
      *)
      
      Return[{L, rank}];
      
  ];

  (* Observable realization *)
  
  NCSObservableSubspace[a_?MatrixQ, c_?MatrixQ, opts___] := Module[
      {L, rank},
      {L, rank} = NCSControllableSubspace[tpMat[a], tpMat[c], opts];
      Return[{tpMat[L], rank}];
  ];

  NCSObservableRealization[sys_NCSystem] := Module[
      {L, rank, R},
      
      (* Calculate observable subspace *)
      {R, rank} = NCSObservableSubspace[sys[[1]],sys[[3]]];

      (* Calculate projection *)
      L = NCInverse[R][[1;;rank]];
      R = R[[All,1;;rank]];
      
      Return[
          NCSystem[MatMult[L, sys[[1]], R],
                   MatMult[L, sys[[2]]],
                   MatMult[sys[[3]], R],
                   sys[[4]]]
      ];
  ];

  NCSMinimalRealization[sys_NCSystem] :=
      NCSObservableRealization[NCSControllableRealization[sys]];
  
End[];

EndPackage[];