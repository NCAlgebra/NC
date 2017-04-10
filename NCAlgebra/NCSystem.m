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
	      "NCDot`",
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
   NCDot[s[[3]], 
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
        ArrayFlatten[{{s1[[1]],0},{NCDot[s2[[2]],s1[[3]]],s2[[1]]}}],
        ArrayFlatten[{{s1[[2]]},{NCDot[s2[[2]],s1[[4]]]}}],
        ArrayFlatten[{{NCDot[s2[[4]],s1[[3]]],s2[[3]]}}],
        NCDot[s2[[4]],s1[[4]]]
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
          s[[1]] - NCDot[s[[2]], Di, s[[3]]],
          NCDot[s[[2]], Di],
          -NCDot[Di, s[[3]]],
          Di
      ]];
  ];

  (* Controllability & Observability *)

  NCSControllabilityMatrix[sys_NCSystem, opts___] := 
      NCSControllabilityMatrix[sys[[1]], sys[[2]], opts];

  NCSObservabilityMatrix[sys_NCSystem, opts___] := 
      NCSObservabilityMatrix[sys[[1]], sys[[3]], opts];
      
  NCSControllabilityMatrix[a_?MatrixQ, b_?MatrixQ, 
                           qq_Integer:-1, 
                           opts:OptionsPattern[{
                               Dot -> NCDot
                           }]] := Module[
      {i, q = If[qq == -1, Length[a], qq], n = Length[a], 
       m = Dimensions[b][[2]], 
       mat, 
       dot = OptionValue[Dot]},
      
      mat = ConstantArray[0, {n, q*m}];
      mat[[All,1;;m]] = b;
      For[ i = 1, i < q, i++,
           mat[[All,m*i+1;;m*(i+1)]] = dot[a, mat[[All,m*(i-1)+1;;m*i]]];
      ];
      Return[mat];
      
  ];

  NCSObservabilityMatrix[a_?MatrixQ, c_?MatrixQ, opts___] := 
    tpMat[NCSControllabilityMatrix[tpMat[a], tpMat[c], opts]];

  (* Controllable realization *)
  NCSControllableRealization[sys_NCSystem,
                             opts:OptionsPattern[{
                               Dot -> NCDot,
                               Inverse -> NCInverse
                             }]] := Module[
      {ctrb, L, rank, R,
       dot = OptionValue[Dot],
       inverse = OptionValue[Inverse]},

      (* Calculate controllability matrix *)
      ctrb = NCSControllabilityMatrix[sys[[1]], sys[[2]], opts];

      (* Calculate controllable subspace *)
      {L, rank} = NCSControllableSubspace[ctrb, opts];

      (* Calculate projection *)
      R = inverse[L][[All,1;;rank]];
      L = L[[1;;rank]];
      
      Return[
          NCSystem[dot[L, sys[[1]], R],
                   dot[L, sys[[2]]],
                   dot[sys[[3]], R],
                   sys[[4]]]
      ];
  ];

  NCSControllableSubspace[ctrb_?MatrixQ,
                          opts:OptionsPattern[{
                            LUDecomposition -> NCLUDecompositionWithCompletePivoting,
                            Solve -> NCLowerTriangularSolve
                          }]] := Module[
      {L,
       decomposition = OptionValue[LUDecomposition],
       solve = OptionValue[Solve]},
      
      (* Determine Rank *)
      {lu,p,q,rank} = decomposition[ctrb];
      {l,u} = GetLUMatrices[lu];

      (* P ctrb Q = L U *)
      (* R ctrb = U Q^T, L = L \ P *)
      L = solve[l, IdentityMatrix[Length[ctrb]][[p]]];

      (*
      Print["ctrb = ", ctrb];
      Print["l = ", Normal[l]];
      Print["u = ", Normal[u]];
      Print["rank = ", rank];
      Print["L = ", L];
      Print["L ctrb = ", NCDot[L, ctrb]];
      *)
      
      Return[{L, rank}];
      
  ];

  (* Observable realization *)
  
  NCSObservableSubspace[obsv_?MatrixQ, opts___] := Module[
      {L, rank},
      {L, rank} = NCSControllableSubspace[Transpose[obsv], opts];
      Return[{tpMat[L], rank}];
  ];

  NCSObservableRealization[sys_NCSystem,
                           opts:OptionsPattern[{
                             Dot -> NCDot,
                             Inverse -> NCInverse
                           }]] := Module[
      {obsv, L, rank, R,
       dot = OptionValue[Dot],
       inverse = OptionValue[Inverse]},
      
      (* Calculate observability matrix *)
      obsv = NCSObservabilityMatrix[sys[[1]], sys[[3]], opts];

      (* Calculate observable subspace *)
      {R, rank} = NCSObservableSubspace[obsv,opts];

      (* Calculate projection *)
      L = inverse[R][[1;;rank]];
      R = R[[All,1;;rank]];
      
      Return[
          NCSystem[dot[L, sys[[1]], R],
                   dot[L, sys[[2]]],
                   dot[sys[[3]], R],
                   sys[[4]]]
      ];
  ];

  NCSMinimalRealization[sys_NCSystem, opts___] :=
      NCSObservableRealization[
          NCSControllableRealization[sys, opts], opts];
  
End[];

EndPackage[];