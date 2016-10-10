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
      NCRPlus,
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

NCRControllableRealization::Reduction = "Representation has been reduced from order `1` to order `2`.";

NCToNCRational::Failed = "Cannot convert to NCRational.";

Begin[ "`Private`" ]

  (* NCROrder *)
  
  NCROrder[rat_NCRational] := Dimensions[rat[[3]]][[2]];

  (* NCRStrictlyProperQ *)
  
  NCRStrictlyProperQ[rat_NCRational] := 
    PossibleZeroQ[Total[Abs[rat[[4]]],2]];
  
  (* NCToNCRational *)

  Clear[NCToNCRationalAuxRule];
  NCToNCRationalAuxRule[var_, positions_] := 
      Map[{var+1, #, #+1}->-1&, positions];

  Clear[NCToNCRationalAux];
  NCToNCRationalAux[{monomial_}, {coefficients_}, vars_] := Module[
    {n = Length[monomial]+1, m = Length[vars]},
    
    Return[
      NCRational[
        SparseArray[
            Prepend[Flatten[
              Apply[NCToNCRationalAuxRule,
                MapIndexed[{#2[[1]],Flatten[Position[monomial,#1]]}&, 
                           vars], 1], 1], {1,i_,i_}->1], {m+1,n,n}],
        SparseArray[{n,1}->(Times @@ coefficients),{n,1}],
        SparseArray[{1,1}->1,{1,n}], 
        SparseArray[{},{1,1}],
        vars]
    ];
  ] /; Length[coefficients] == 3;

  NCToNCRationalAux[___] := 
    (Message[NCToNCRational::Failed]; $Failed)

  (* scalars *)
  
  NCToNCRational[expr_?CommutativeQ, vars_List] := Module[
    {n = 0, m = Length[vars]},
    Return[
      NCRational[SparseArray[{},{m+1,n,n}],
                 SparseArray[{},{n,1}],
                 SparseArray[{},{1,n}],
                 SparseArray[{{expr}}],
                 vars]
    ];
  ];

  (* A + B inv[] *)
  
  NCToNCRational[(aa_:0) + (B_:1) inv[bb_],
                 vars_List] := Module[
    {n = 1, m = Length[vars],
     a, b, poly,
     A,tmp},
    
    (* convert first term *)
    a = NCToNCRational[aa, vars];
    
    (* convert inverse to NCPolynomial *)
    Quiet[
       Check[ (* linear polynomial *)
              poly = NCToNCPolynomial[bb, vars];
              If[ (poly =!= $Failed) && NCPLinearQ[poly],
                  (* linear: already in canonical form *)

                  (*
                  Print[">> linear"];
                  Print["poly = ", poly];
                  Print["bb = ", bb];
                  *)
                  
                  b = NCRational[SparseArray[
                                   Map[{{#}}&,
                                       Flatten[CoefficientArrays[bb, vars]]]
                                 ], 
                                 SparseArray[{{B}}], 
                                 SparseArray[{{1}}], 
                                 SparseArray[{{0}}], 
                                 vars];
                 ,
                  (* force nonlinear *)
                  Message[NCPolynomial::NotPolynomial];
              ]
             ,
              (* nonlinear: convert first then invert *)
              (* Print["> Nonlinear"]; *)
              b = NCRInverse[NCToNCRational[(1/B) bb, vars]];
             ,
              NCPolynomial::NotPolynomial
        ]
      ,
       NCPolynomial::NotPolynomial
    ];

    (*
    Print["a = ", Map[Normal,a]];
    Print["b = ", Map[Normal,b]];
    *)
                  
    Return[NCRPlus[a, b]];
                     
  ];
  
  
  (* polynomials *)

  NCToNCRational[expr_, vars_List] := Module[
    {poly, ratVars, ruleRatRev,
     tmp},

    (* convert to NCPolynomial *)
    {poly, ratVars, ruleRatRev} = NCRationalToNCPolynomial[expr, vars];

    (*
    Print["poly = ", poly];
    Print["ratVars = ", ratVars];
    Print["ruleRatRev = ", ruleRatRev];
    *)

    (* convert to NCRational *)
    tmp = NCRPlus @@ KeyValueMap[NCToNCRationalAux[##,vars]&, poly[[2]]];

    (* add constant term *)
    tmp[[4]] = If[ MatrixQ[poly[[1]]], poly[[1]], {{poly[[1]]}} ];
      
    Return[tmp];

  ];

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
      
    Return[NCRational[Prepend[A1,A0], B, C, D, vars]];
  ];

  Normal[rat_NCRational] ^:= (List @@ rat)[[1;;4]];
  
  (* NCRational Inverse *)
  NCRInverse[rrat_NCRational] := Module[
    {n = NCROrder[rat], d, rat = rrat},

    If[ NCRStrictlyProperQ[rat],

        (* strictly proper inverse embedding *)
        (* grow all coefficients *)
        rat[[1]] = PadLeft[rat[[1]], {m+1,r+1,r+1}];
        (* add c and b to the first coefficient *)
        rat[[1,1,1,2;;]] = rat[[3]]; (* c *)
        rat[[1,1,2;;,1]] = rat[[2]]; (* d *)

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

  
  (* NCRational Plus *)
  
  NCRPlus[term_NCRational] := Return[term];
  
  NCRPlus[tterms__NCRational] := Module[
      {terms,nonzero},
      terms = {tterms};
      
      (* Exclude zero-order terms *)
      nonzero = Flatten[Position[Map[NCROrder[#] > 0&, terms], 
                                 True]];
      
      Return[
        NCRational[ 
          Apply[SparseArray[Band[{1, 1}] -> {##}]&,
                Transpose[terms[[nonzero,1]],{2,1,3,4}], {1}],
          Join @@ terms[[nonzero,2]], 
          Join[##,2]& @@ terms[[nonzero,3]],
          Plus @@ terms[[All,4]],
          terms[[1,5]]]
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
            rat[[5]]
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
        rat[[5]]
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
