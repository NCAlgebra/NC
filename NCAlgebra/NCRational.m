(* :Title: 	NCRational.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCRational` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCRational`",
              "NCPolynomial`",
	      "MatrixDecompositions`",
	      "NCMatMult`",
              "NCUtil`",
	      "NCOptions`",
	      "NonCommutativeMultiply`" ];

Clear[NCToNCRational,
      NCRationalToNC,
      NCRationalToCanonical,
      CanonicalToNCRational,
      NCROrder,
      NCRLinearQ,
      NCRPlus,
      NCRTimes,
      NCRInverse,
      NCRTranspose,
      NCRStrictlyProperQ,
      NCRControllableSubspace,
      NCRControllableRealization,
      NCRObservableRealization,
      NCRMinimalRealization];

(*
Get["NCRational.usage"];
*)

NCRational::NotRational = "Expression is not an nc rational.";
NCRational::VarNotSymbol = "All variables must be Symbols.";
NCRational::NotSimple = "Expression is not a simple nc rational. Results cannot be trusted.";

NCRControllableRealization::Reduction = "Representation has been reduced from order `1` to order `2`.";

Options[NCRational] = {
  Linear -> False
};

NCToNCRational::Failed = "Cannot convert to NCRational.";

Begin[ "`Private`" ]

  (* NCROrder *)
  
  NCROrder[rat_NCRational] := Dimensions[rat[[3]]][[2]];

  (* NCRStrictlyProperQ *)
  
  NCRStrictlyProperQ[rat_NCRational] := 
    PossibleZeroQ[Total[Abs[rat[[4]]],2]];
  
  (* NCRLinearQ *)
  NCRLinearQ[rat_NCRational] :=
    Linear /. rat[[6]] /. Options[NCRational];

  (* NCToNCRational *)

  (* commutative scalars *)
  
  NCToNCRational[expr_?CommutativeQ, vars_List] := Module[
    {n = 0, m = Length[vars]},
    Return[
      NCRational[SparseArray[{},{m+1,n,n}],
                 SparseArray[{},{n,1}],
                 SparseArray[{},{1,n}],
                 SparseArray[{{expr}}],
                 vars,
                 {Linear -> True}]
    ];
  ];

  (* commutative scalars products *)
  
  NCToNCRational[B_?CommutativeQ bb_, vars_List] := Module[
    {b},

    b = NCToNCRational[bb, vars];
    If[ B =!= 1,

        (* Multiply B and D by scalar *)
        b[[2]] *= B;
        b[[4]] *= B;
        
    ];

    Return[b];
  ];

  (* symbols *)
  
  NCToNCRational[expr_Symbol, vars_List] := Module[
    {n = 2, m = Length[vars], 
     r = Flatten[Position[vars,expr]][[1]]},
      
    (* TODO: WARN ABOUT NOT SIMPLE *)
      
    Return[
      NCRational[SparseArray[{{r+1,1,2}->-1,{1,i_,i_}->1},{m+1,n,n}],
                 SparseArray[{n,1}->1,{n,1}],
                 SparseArray[{1,1}->1,{1,n}], 
                 SparseArray[{},{1,1}],
                 vars,
                 {Linear -> True}]
    ];
  ];

  (* sums *)
  
  NCToNCRational[expr_Plus, vars_List] := 
    NCRPlus @@ Map[NCToNCRational[#, vars]&, List @@ expr];

  (* products *)
  
  NCToNCRational[expr_NonCommutativeMultiply, vars_List] := 
    NCRTimes @@ Map[NCToNCRational[#, vars]&, List @@ expr];

  (* inverses *)
  
  NCToNCRational[inv[expr_], vars_List] := Module[
    {b,coeffs},
      
    (* convert expr *)
    b = NCToNCRational[expr, vars];
    
    (* simplify if linear *)
    If[ NCRLinearQ[b],
      
        coeffs = Flatten[CoefficientArrays[expr, vars]];
        
        Return[
          NCRational[
            SparseArray[Map[{{#}}&,coeffs]],
            SparseArray[{{1}}],
            SparseArray[{{1}}],
            SparseArray[{{0}}],
            vars, {}
          ]
        ];
       , 
        Return[NCRInverse[b]];
    ];
      
  ];
    
  (* NCRational to NC *)

  NCRationalToNC[rat_NCRational] := Module[
    {A,B,C,D},

    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];

    Return[
      If[ NCROrder[rat] > 0,
          MatMult[C, 
                  NCInverse[First[A] + Plus @@ (Rest[A] * rat[[5]])],
                  B] + D
         ,
          D
      ]
    ];
      
  ];

  NCRationalToCanonical[rat_NCRational] := Module[
    {A,B,C,D},

    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];

    Return[{{C, First[A] + Plus @@ (Rest[A] * rat[[5]]), B, D}, rat[[5]]}];
  ];

  CanonicalToNCRational[{C_,G_,B_,D_}, vars_] := Module[
    {},

    (* Form list of pencil coefficients *) 
    {A0,A1} = CoefficientArrays[G, vars];
    A1 = Transpose[A1,{3,2,1}];
      
    Return[NCRational[Prepend[A1,A0], B, C, D, vars, {}]];
  ];

  Normal[rat_NCRational] ^:= (List @@ rat)[[1;;4]];
  
  (* NCRational Inverse *)
  NCRInverse[rrat_NCRational] := Module[
    {rat = rrat, n, m, d},

    If[ NCRStrictlyProperQ[rat],

        (* strictly proper inverse embedding *)
        n = NCROrder[rat];
        m = Length[rat[[5]]] + 1;
        (* grow all coefficients *)
        rat[[1]] = PadLeft[rat[[1]], {m,n+1,n+1}];
        (* add c and b to the first coefficient *)
        rat[[1,1,{1},2;;]] = -rat[[3]]; (* c *)
        rat[[1,1,2;;,{1}]] = rat[[2]]; (* b *)

        rat[[2]] = SparseArray[{1,1}->1,{n+1,1}];
        rat[[3]] = SparseArray[{1,1}->1,{1,n+1}]; 

       ,

        (* proper inverse embedding (scalar) *)
        d = rat[[4,1,1]];
        rat[[1,1]] +=  rat[[2]] . rat[[3]] / d;
        rat[[2]] = -rat[[2]] / d;
        rat[[3]] = rat[[3]] / d;
        rat[[4]] = SparseArray[{{1/d}}];

    ];
      
    Return[rat];
      
  ];
  
  (* NCRational Times *)
  
  NCRTimes[term_NCRational] := Return[term];

  NCRTimes[a_NCRational, b_NCRational] := Module[
    {n,m,vars,tmp,coeffs,degree,
     orderA,orderB,
     terms,A,B,C,D},

    (* Evaluate a ** b *)
      
    (* Print["> NCRTimes"]; *)

    If[ NCRLinearQ[b] && NCRStrictlyProperQ[a], 
        
        (* Multiplication on the right by a linear term *)
       
        vars = b[[5]];
        tmp = NCRationalToNC[b][[1,1]];
        coeffs = Flatten[CoefficientArrays[tmp, vars]];
        degree = Length[coeffs] - 1;
        
        (*
        Print["tmp = ", tmp];
        Print["coeffs = ", Normal[coeffs]];
        Print["degree = ", degree];
        *)
        
        n = NCROrder[a];
        m = Length[a[[5]]] + 1;
 
        A = PadRight[a[[1]], {m,n+1,n+1}];
        A[[All,1;;n,{n+1}]] = Outer[Times, -coeffs, a[[2]]];
        A[[1,n+1,n+1]] = 1;
        B = SparseArray[{n+1,1}->1,{n+1,1}];
        C = PadRight[a[[3]], {1,n+1}, 0];
        D = a[[4]];
       
        (*
        Print["A = ", Map[Normal, A]];
        Print["B = ", Map[Normal, B]];
        Print["C = ", Map[Normal, C]];
        Print["D = ", Map[Normal, D]];
        *)
        
        Return[NCRational[A, B, C, D, a[[5]], {}]];
        
    ];

    If[ NCRLinearQ[a] && NCRStrictlyProperQ[b], 
        
        (* Multiplication on the left by a linear term *)
       
        vars = a[[5]];
        tmp = NCRationalToNC[a][[1,1]];
        coeffs = Flatten[CoefficientArrays[tmp, vars]];
        degree = Length[coeffs] - 1;
          
        (*
        Print["tmp = ", tmp];
        Print["coeffs = ", Normal[coeffs]];
        Print["degree = ", degree];
        *)
        
        n = NCROrder[b];
        m = Length[b[[5]]] + 1;
 
        A = PadRight[b[[1]], {m,n+1,n+1}];
        A[[All,{n+1},1;;n]] = Outer[Times, -coeffs, b[[3]]];
        A[[1,n+1,n+1]] = 1;
        B = PadRight[b[[2]], {n+1,1}, 0];
        C = SparseArray[{1,n+1}->1,{1,n+1}];
        D = b[[4]];
       
        (*
        Print["A = ", Map[Normal, A]];
        Print["B = ", Map[Normal, B]];
        Print["C = ", Map[Normal, C]];
        Print["D = ", Map[Normal, D]];
        *)
        
        Return[NCRational[A, B, C, D, b[[5]], {}]];
        
    ];
      
    orderA = NCROrder[a];
    orderB = NCROrder[b];
      
    If[ orderA == 0,
        Return[NCRational[b[[1]],a[[4,1,1]]*b[[2]],
                          b[[3]],a[[4,1,1]]*b[[4]],b[[5]]],b[[6]]];
    ];

    If[ orderB == 0,
        Return[NCRational[a[[1]],b[[4,1,1]]*a[[2]],
                          a[[3]],b[[4,1,1]]*a[[4]],a[[5]]],a[[6]]];
    ];

    (* Number of variables + 1 *)
    m = Length[a[[5]]] + 1;

    terms = {b,a};
    A = SparseArray[
          Apply[
            SparseArray[Band[{1, 1}] -> {##}]&,
                        Map[terms[[All,1,#1]]&, Range[m]],
            {1}
          ]
        ];
    A[[1,orderB+1;;orderA+orderB,1;;orderB]] = - a[[2]] . b[[3]];
      
    Return[
      NCRational[A, Join[b[[2]], a[[2]] . b[[4]]],
                 Join[a[[4]] . b[[3]], a[[3]], 2], a[[4]] . b[[4]],
                 a[[5]],{}
      ]
    ];
      
  ];

  NCRTimes[a_NCRational, terms__NCRational] := 
    NCRTimes[a, NCRTimes[terms]];
        
  (* NCRational Plus *)
  
  NCRPlus[term_NCRational] := Return[term];
  
  NCRPlus[tterms__NCRational] := Module[
      {terms,m,vars,
       linear,tmp,coeffs,degree,
       nonlinear,nonzero},
      terms = {tterms};
      
      (* Number of variables + 1 *)
      vars = terms[[1,5]];
      m = Length[vars] + 1;

      (* linear and nonlinear *)
      tmp = Map[NCRLinearQ, terms];
      linear = Flatten[Position[tmp, True]];
      nonlinear = Flatten[Position[tmp, False]];
      
      (*
      Print["linear = ", linear];
      Print["nonlinear = ", nonlinear];
      *)
      
      (* add linear terms *)
      If[ Length[linear] > 0,
          tmp = (Plus @@ Map[NCRationalToNC, terms[[linear]]])[[1,1]];
          coeffs = Flatten[CoefficientArrays[tmp, vars]];
          degree = Length[coeffs] - 1;
          
          (*
          Print["linear terms = ", Map[Normal,terms[[linear]],{2}]];
          Print["tmp = ", tmp];
          Print["coeffs = ", Normal[coeffs]];
          Print["degree = ", degree];
          *)

          tmp = If[ degree > 0,
                    (* linear *)
                    NCRational[
                      SparseArray[
                        Append[
                          MapIndexed[({#2[[1]],1,2}->-#1)&,coeffs],
                          {1,i_,i_}->1
                        ],{m,2,2}
                      ],
                      SparseArray[{2,1}->1,{2,1}],
                      SparseArray[{1,1}->1,{1,2}], 
                      SparseArray[{},{1,1}], 
                      vars, {Linear -> True}]
                   ,
                    (* constant *)
                    NCToNCRational[coeffs[[1]], vars]
                ];

          (*
          Print["tmp = ", Map[Normal,tmp]];
          *)

          If[ Length[nonlinear] == 0,
              Return[tmp];
          ];
         
          (* select linear and nonlinear terms *)
          terms = Append[terms[[nonlinear]], tmp];
          nonzero = Range[Length[terms]-1];
          
         ,
          
          (* select nonlinear terms *)
          terms = terms[[nonlinear]];
          nonzero = All;
      ];
          
      (* add linear and nonlinear terms *)
      
      Return[
        NCRational[ 
          SparseArray[
            Apply[
              SparseArray[Band[{1, 1}] -> {##}]&,
                          Map[terms[[nonzero,1,#1]]&, Range[m]],
              {1}
            ]
          ],
          Join @@ terms[[nonzero,2]], 
          Join[##,2]& @@ terms[[nonzero,3]],
          Plus @@ terms[[All,4]],
          terms[[1,5]],{}]
     ];
      
  ];

  (* NCRControllableSubspace *)

  NCRControllableSubspace[A_, B_, opts:OptionsPattern[{}]] := Module[
    {letters = Range[Length[A]],
     wordLength = 0,
     words = {{}},
     controllabilityMatrix,
     newColumns,
     AB,
     p,q,rank,newRank,newQ,
     candidateWords,
     candidateColumns},

    (* Store products for faster evaluation *)
    AB[{}] = B;
    AB[word_List] := (AB[word] = A[[First[word]]] . AB[Rest[word]]);

    (* words = {{}}; *)
    (* wordLength = 0 *)
    {controllabilityMatrix,p,q,rank} = LURowReduce[Transpose[B]];

    (*
    Print["Transpose[B] = ", Transpose[B]];
    Print["controllabilityMatrix = ", Normal[controllabilityMatrix]];
    Print["p = ", p];
    Print["q = ", q];
    Print["rank = ", rank];
    *)

    While[True,

       wordLength = wordLength + 1;

       (* assemble candidate words *)
       candidateWords = 
          Flatten[Outer[Prepend[#2, #1]&, 
                        letters, 
                        words, 1], 1];

       (* assemble candidate columns *)
       candidateColumns = ArrayFlatten[{Map[AB, candidateWords]}][[q]];

       (* row reduce to find range *)
       {u,p,newQ,newRank} = LURowReduceIncremental[
                              controllabilityMatrix,
                              Transpose[candidateColumns]
                         ];
       controllabilityMatrix = Take[u,newRank];

       (* adjust permutations *)
       q = q[[newQ]];

       (*   
       Print["wordLength = ", wordLength];
       Print["candidateColumns = ", Transpose[candidateColumns];
       Print["candidateWords = ", candidateWords];
       Print["u = ", Normal[u]];
       Print["controllabilityMatrix = ", Normal[controllabilityMatrix]];
       Print["p = ", p];
       Print["newQ = ", newQ];
       Print["q = ", q];
       Print["newRank = ", newRank];
       *)

       If[ newRank === rank
          ,
           (* there are no more linearly independent columns *)
           Break[];
       ];

       words = candidateWords[[p[[rank+1;;newRank]]-rank]];
       rank = newRank;

       (*
       Print["words = ", words];
       *)

    ];

    (* rearrange controllability matrix *)
    controllabilityMatrix[[All,q]] = controllabilityMatrix;

    Return[{controllabilityMatrix, q}];
          
  ];


  (* NCR Controllable Realization *)
      
  NCRControllableRealization[rat_NCRational, 
                             opts:OptionsPattern[{}]] := Module[
    {A,B,C,D,
     A2,B2,C2,
     n,ctrb,q,rank,R,L},
    
    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];
    n = Length[B];
                                 
    (* Scale by inv[A0] *)
    A0inv = LinearSolve[A[[1]]];
    {A2, B2} = {Map[A0inv, Rest[A]], A0inv[B]};
    C2 = C;

    (* Calculate row-reduced controllability subspace *)
    {ctrb, q} = NCRControllableSubspace[A2, B2];
    rank = Length[ctrb];

    (*
    Print["A2 = ", A2];
    Print["B2 = ", B2];
    Print["ctrb = ", ctrb];
    Print["rank = ", rank];
    *)

    If[ rank < n,

        (* Realization is not controllable *)
        Message[NCRControllableRealization::Reduction, n, rank];

        (* Calculate nullspace *)
        (* [I X] [-X; I] = 0 *)
        nullSpace = Join[-ctrb[[1;;rank,q[[rank+1;;]]]], 
                         IdentityMatrix[n-rank]];
        nullSpace[[q]] = nullSpace;

        (* Calculate projection *)
        R = Transpose[Join[ctrb, Transpose[nullSpace]]];
        L = Inverse[R][[1;;rank]];
        R = R[[All,1;;rank]];

        (*
        Print["NullSpace = ", nullSpace];
        Print["ctrb . NullSpace = ", ctrb . nullSpace];
        Print["L = ", L];
        Print["R = ", R];
        *)

        (* Calculate reduced realization *)
        Return[
          NCRational[
            Prepend[Map[MatMult[L, #, R]&, A2], IdentityMatrix[rank]], 
            MatMult[L, B2], MatMult[C2, R], D, 
            rat[[5]], {}
          ]
        ];
            
       ,
        
        (* Realization is already controllable *)
        Return[rat];
        
    ];
           
  ];
      
  (* NCRTranspose *)
  NCRTranspose[rat_NCRational] := Module[
    {A,B,C,D},

    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];

    Return[
      NCRational[
        Transpose[A,{1,3,2}],
        Transpose[C],
        Transpose[B],
        Transpose[D],
        rat[[5]], rat[[6]]
      ]
    ];
      
  ];
      
  (* NCR Observable Realization *)

  NCRObservableRealization[rat_NCRational, 
                           opts:OptionsPattern[{}]] := 
    NCRTranspose[NCRControllableRealization[NCRTranspose[rat], opts]];

  (* NCR Minimial Realization *)
      
  NCRMinimalRealization[rat_NCRational, opts:OptionsPattern[{}]] := 
    NCRObservableRealization[
      NCRControllableRealization[rat]
    ];

End[]

EndPackage[]
