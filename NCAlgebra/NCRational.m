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
      NCRPlus,
      NCRControllableSubspace,
      NCRControllableRealization,
      NCRObservableRealization,
      NCRMinimalRealization];

(*
Get["NCRational.usage"];
*)

NCRational::NotRational = "Expression is not an nc rational.";
NCRational::VarNotSymbol = "All variables must be Symbols.";

Begin[ "`Private`" ]

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
        SparseArray[{n,1}->1,{n,1}],  
        SparseArray[{1,1}->1,{1,n}], 
        SparseArray[{},{1,1}],
        vars]
    ];
  ] /; Length[coefficients] == 3;
  
  NCToNCRational[expr_, vars_List] := Module[
    {poly, ratVars, ruleRatRev,
     terms},

    {poly, ratVars, ruleRatRev} = NCRationalToNCPolynomial[expr, vars];

    (*
    Print["poly = ", poly];
    Print["ratVars = ", ratVars];
    Print["ruleRatRev = ", ruleRatRev];
    *)

    Return[NCRPlus @@ KeyValueMap[NCToNCRationalAux[##,vars]&, poly[[2]]]];

  ];

  NCRationalToNC[rat_NCRational] := Module[
    {A,B,C,D},

    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];

    Return[
      MatMult[C, 
              NCInverse[First[A] + Plus @@ (Rest[A] * rat[[5]])],
              B] + D
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
  
  (* NCRational Plus *)
  NCRPlus[term_NCRational] := Return[term];
  
  NCRPlus[tterms__NCRational] := Module[
      {terms},
      terms = {tterms};
      
      Return[
        NCRational[ 
          Apply[SparseArray[Band[{1, 1}] -> {##}]&,
                Transpose[terms[[All,1]],{2,1,3,4}], {1}],
          Join @@ terms[[All,2]], 
          Join[##,2]& @@ terms[[All,3]],
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
        Print["Realization is not controllable."];

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
      
  (* NCR Controllable Realization *)
      
  NCRObservableRealization[rat_NCRational, 
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

    (* Calculate row-reduced observability subspace *)
    {ctrb, q} = NCRControllableSubspace[Map[Transpose, A2], Transpose[C2]];
    rank = Length[ctrb];

    (*
    Print["ctrb = ", ctrb];
    Print["rank = ", rank];
    *)

    If[ rank < n,

        (* Realization is not observable *)
        Print["Realization is not observable."];

        (* Calculate nullspace *)
        (* [I X] [-X; I] = 0 *)
        nullSpace = Join[-ctrb[[1;;rank,q[[rank+1;;]]]], 
                         IdentityMatrix[n-rank]];
        nullSpace[[q]] = nullSpace;

        (* Calculate projection *)
        L = Transpose[Join[ctrb, Transpose[nullSpace]]];
        R = Inverse[L][[All,1;;rank]];
        L = L[[1;;rank]];

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
        
        (* Realization is already observable *)
        Return[rat];
        
    ];

  ];

  (* NCR Minimial Realization *)
      
  NCRMinimalRealization[rat_NCRational, opts:OptionsPattern[{}]] := 
    NCRObservableRealization[
      NCRControllableRealization[rat]
    ];

End[]

EndPackage[]
