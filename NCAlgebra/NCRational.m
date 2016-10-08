(* :Title: 	NCRational.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCRational` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCRational`",
	      "MatrixMultiplications`",
	      "NCMatMult`",
              "NCUtil`",
	      "NCOptions`",
	      "NonCommutativeMultiply`" ];

Clear[NCToNCRational,
      NCRControllableSubspace,
      NCRControllableRealization,
      NCRObservableRealization,
      NCRMinimalRealization];

Get["NCRational.usage"];

NCRational::NotRational = "Expression is not an nc rational.";
NCRational::VarNotSymbol = "All variables must be Symbols.";

Begin[ "`Private`" ]

  (* NCToNCRational *)

  NCToNCRational[expr_, vars_List] := Module[
    {},

     (* Make sure vars is a list of Symbols *)
     If [ Not[MatchQ[vars, {___Symbol}]],
          Message[NCRational::VarNotSymbol];
          Return[$Failed];
     ];

     Return[NCRational[{{{}}},{{}},{{}},{{}}, vars];
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
    {A,B,C,D} = rat[[1;;4]];
    n = Length[B];
                                 
    (* Scale by inv[A0] *)
    A0inv = LinearSolve[A[[1]]];
    {A2, B2} = {Map[A0inv, Rest[A]], A0inv[B]};
    C2 = C;

    (* Calculate row-reduced controllability subspace *)
    {ctrb, q} = NCControllableSubspace[A2, B2];
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
            {IdentityMatrix[rank], Map[MatMult[L, #, R]&, A2]}, 
            MatMult[L, B2], MatMult[C2, R], D, 
            vars
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
    {A,B,C,D} = rat[[1;;4]];
    n = Length[B];
                                 
    (* Scale by inv[A0] *)
    A0inv = LinearSolve[A[[1]]];
    {A2, B2} = {Map[A0inv, Rest[A]], A0inv[B]};
    C2 = C;

    (* Calculate row-reduced observability subspace *)
    {ctrb, q} = NCControllableSubspace[Map[Transpose, A2], Transpose[C2]];
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
            {IdentityMatrix[rank], Map[MatMult[L, #, R]&, A2]}, 
            MatMult[L, B2], MatMult[C2, R], D, 
            vars
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
