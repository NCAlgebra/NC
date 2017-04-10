(* :Title: 	NCRational.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCRational` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCRational`",
              "NCPolynomial`",
              "NCPoly`",
              "NCGBX`",
	      "MatrixDecompositions`",
	      "NCDot`",
              "NCUtil`",
	      "NCOptions`",
	      "NonCommutativeMultiply`" ];

Clear[NCToNCRational,
      NCRationalToNC,
      NCRationalToCanonical,
      CanonicalToNCRational,
      NCROrder,
      NCRLinearQ,
      NCRPolynomialQ,
      NCRPlus,
      NCRTimes,
      NCRInverse,
      NCRTranspose,
      NCRStrictlyProperQ,
      NCRControllableSubspace,
      NCRControllabilityGramian,
      NCRObservabilityGramian,
      NCRControllableRealization,
      NCRObservableRealization,
      NCRMinimalRealization];

Get["NCRational.usage"];

NCRational::NotRational = "Expression is not an nc rational.";
NCRational::VarNotSymbol = "All variables must be Symbols.";
NCRational::NotSimple = "Expression is not a simple nc rational. Results cannot be trusted.";

NCRControllableRealization::Reduction = "Representation has been reduced from order `1` to order `2`.";

NCRational::NotAnalytic = "Expression is not analytic at 0.";
NCRational::Singular = "Singular pencils are not supported yet.";

Options[NCRational] = {
  Linear -> False,
  Polynomial -> False
};

NCToNCRational::Failed = "Cannot convert to NCRational. `1`";

Begin[ "`Private`" ]

  (* NCROrder *)
  
  NCROrder[rat_NCRational] := Dimensions[rat[[3]]][[2]];

  (* NCRStrictlyProperQ *)
  
  NCRStrictlyProperQ[rat_NCRational] := 
    PossibleZeroQ[Total[Abs[rat[[4]]],2]];
  
  (* NCRLinearQ *)
  NCRLinearQ[rat_NCRational] :=
    Linear /. rat[[6]] /. Options[NCRational];

  (* NCRPolynomialQ *)
  NCRPolynomialQ[rat_NCRational] :=
    Polynomial /. rat[[6]] /. Options[NCRational];

  (* NCToNCRational *)

  Clear[NCToNCRationalAux];
  
  NCToNCRational[expr_, vars_] := Module[
    {},
    Return[
      Check[ NCToNCRationalAux[expr, vars]
            ,
             $Failed
            ,
             NCToNCRational::Failed
      ]
    ];
  ];
  
  (* commutative scalars *)
  
  NCToNCRationalAux[expr_?CommutativeQ, vars_List] := Module[
    {n = 0, m = Length[vars]},
    Return[
      NCRational[SparseArray[{},{m+1,n,n}],
                 SparseArray[{},{n,1}],
                 SparseArray[{},{1,n}],
                 SparseArray[{{expr}}],
                 vars,
                 {Linear -> True, Polynomial -> True}]
    ];
  ];

  (* commutative scalars products *)
  
  NCToNCRationalAux[B_?CommutativeQ bb_, vars_List] := Module[
    {b},

    b = NCToNCRationalAux[bb, vars];
    If[ B =!= 1,

        (* Multiply B and D by scalar *)
        b[[2]] *= B;
        b[[4]] *= B;
        
    ];

    Return[b];
  ];

  (* symbols *)
  
  NCToNCRationalAux[expr_Symbol, vars_List] := Module[
    {n = 2, m = Length[vars], 
     r = Flatten[Position[vars,expr]]},

    (* warn if expr is not variable *)
    If[ Length[r] == 0,
       Message[NCToNCRational::Failed, 
               "NC Symbol '" <> ToString[expr] <> 
                 "' is not in list of variables"];
       Return[$Failed];
    ];
      
    Return[
      NCRational[SparseArray[{{r[[1]]+1,1,2}->-1,{1,i_,i_}->1},{m+1,n,n}],
                 SparseArray[{n,1}->1,{n,1}],
                 SparseArray[{1,1}->1,{1,n}], 
                 SparseArray[{},{1,1}],
                 vars,
                 {Linear -> True, Polynomial -> True}]
    ];
  ];

  (* products *)
  
  NCToNCRationalAux[expr_NonCommutativeMultiply, vars_List] := 
    NCRTimes @@ Map[NCToNCRationalAux[#, vars]&, List @@ expr];

  (* inverses *)
  
  NCToNCRationalAux[inv[expr_], vars_List] := Module[
    {b,coeffs},

    (* Print["> NCToNCRational[inv[", expr, "]]"]; *)
      
    (* convert expr *)
    b = NCToNCRationalAux[expr, vars];
    
    (* Print["b = ", b]; *)
      
    (* simplify if linear *)
    If[ NCRLinearQ[b],
      
        (* Print["> Linear"]; *)
        
        coeffs = Flatten[CoefficientArrays[expr, vars]];

        (* Print["coeffs = ", coeffs]; *)
        
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
        (* Print["> Nonlinear"]; *)
        Return[NCRInverse[b]];
    ];
      
  ];

  (* sums *)
  
  (* NCToNCRationalAux[a_ + b:(_. _inv)..., vars_List] := Module[ *)
  Clear[NCToNCRationalPlusAux];
  NCToNCRationalPlusAux[a_, b_List, vars_List] := Module[
    {poly,
     A,B,C,D,
     rat, opts = {}},

    (*
    Print["> NCToNCRational::Polynomial"];
    Print["a = ", a];
    Print["b = ", b];
    *)

    (* polynomial part *)
    rat = If[ a =!= 0,
        
        (* Print["> Converting polynomial to NCPoly"]; *)
              
        (* convert polynomial part to NCPoly *)
        poly = Check[ NCToNCPoly[a, {Flatten[vars]}]
                      ,
                      Message[NCToNCRational::Failed, 
                              "Expression '" <> ToString[a] <> 
                              "' is not a simple polynomial"];
                      Return[$Failed]
                     ,
                      NCPoly::NotPolynomial
               ];

        (* Print["> Calculating minimal realization"]; *)
                      
        (* calculate minimal realization *)
        {A,B,C,D} = NCPolyRealization[poly];

        (*
        Print["polynomial term = ", a];
        Print["rational terms = ", b];
        Print["poly = ", poly];
        Print["a = ", Normal[A]];
        Print["b = ", Normal[B]];
        Print["c = ", Normal[C]];
        Print["d = ", Normal[D]];
        *)

        If[ NCPolyLinearQ[poly],
            AppendTo[opts, Linear -> True];
        ];
        AppendTo[opts, Polynomial -> True];
                      
        {NCRational[A, B, C, D, vars, opts]}
       ,
        (* If a === 0, *) 
        {}
    ];
        
    (* Print["> Adding rational terms"]; *)

    (* add rational part *)
    If[ Length[b] > 0,
        rat = Join[rat, Map[NCToNCRationalAux[#, vars]&, b]];
    ];

    (* Print["rat = ", rat]; *)
      
    Return[NCRPlus @@ rat];
                        
  ];

  NCToNCRationalAux[Plus[a__?(FreeQ[inv])], vars_List] := 
    NCToNCRationalPlusAux[Plus[a], {}, vars];
  NCToNCRationalAux[a__?(FreeQ[inv]) + b__, vars_List] :=
    NCToNCRationalPlusAux[Plus[a], {b}, vars];
  NCToNCRationalAux[Plus[b__], vars_List] :=
    NCToNCRationalPlusAux[0, List @@ b, vars];
                       
  (*
  NCToNCRationalAux[expr_Plus, vars_List] := 
    NCRPlus @@ Map[NCToNCRationalAux[#, vars]&, List @@ expr];
  *)

  NCToNCRationalAux[expr_, vars_] :=
    (Message[NCToNCRational::Failed, "'" <> ToString[expr] 
             <> "' may not be NC rational"];
     Return[$Failed])
      
  (* NCRational to NC *)

  NCRationalToNC[rat_NCRational] := Module[
    {A,B,C,D},

    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];

    Return[
      If[ NCROrder[rat] > 0,
          NCDot[C, 
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
  NCRInverse[rat_NCRational] := Module[
    {n, b1, c1, 
     BB, CC, DDi, AA},

    (* Is upper triangular? *)
    If[ Map[UpperTriangularize, A] != A,
       Print["NOT UpperTriangular"];
       Print[Map[Total[Abs[#]]&, A[[2;;]], {2}]];
    ];
       
    n = NCROrder[rat];
    b1 = rat[[2, n, 1]];
    c1 = rat[[3, 1, 1]];
    BB = Join[rat[[2, 1;;n-1, {1}]], rat[[1,1,1;;n-1,{1}]], 2];
    CC = Join[rat[[1,1,{n},2;;n]], rat[[3, {1}, 2;;n]]];
    DDi = {{1/b1, 0},{rat[[4,1,1]]/b1/c1, -1/c1}};
    AA = rat[[1, All, 1;;n-1, 2;;n]];

    (*
    Print["b1 = ", b1];
    Print["c1 = ", c1];
    Print["BB = ", Normal[BB]];
    Print["CC = ", Normal[CC]];
    Print["DDi = ", DDi];
    Print["AA = ", Normal[AA]];
    *)

    AA[[1]] -= BB . DDi . CC;
    BB = BB . DDi[[All, {2}]];
    CC = DDi[[{1}, All]]. CC;

    (*
    Print["AA = ", Normal[AA]];
    Print["BB = ", Normal[BB]];
    Print["CC = ", Normal[CC]];
    *)

    Return[NCRational[AA, BB, CC, {{0}}, rat[[5]], {}]];
      
  ] /; NCRPolynomialQ[rat];
  
  NCRInverse[Rat_NCRational] := Module[
    {rat = Rat, n, m},

    (* strictly proper inverse embedding *)
    n = NCROrder[rat];
    m = Length[rat[[5]]] + 1;
      
    (* grow all coefficients *)
    rat[[1]] = PadLeft[rat[[1]], {m,n+1,n+1}];

    (* add c and b to the first coefficient *)
    rat[[1,1,{1},2;;]] = -rat[[3]]; (* c *)
    rat[[1,1,2;;,{1}]] = rat[[2]]; (* b *)

    (* create new b's and c's *)
    rat[[2]] = SparseArray[{1,1}->1,{n+1,1}];
    rat[[3]] = SparseArray[{1,1}->1,{1,n+1}]; 

    Return[rat];
      
  ] /; NCRStrictlyProperQ[Rat];

  NCRInverse[Rat_NCRational] := Module[
    {rat = Rat, d},

    (* proper inverse embedding (scalar) *)
    rat[[1,1]] +=  rat[[2]] . rat[[3]] / rat[[4,1,1]];
    rat[[2]] = -rat[[2]] / rat[[4,1,1]];
    rat[[3]] = rat[[3]] / rat[[4,1,1]];
    rat[[4]] = SparseArray[{{1/rat[[4,1,1]]}}];

    Return[rat];
      
  ];
  
  (* NCRational Times *)
  
  NCRTimes[term_NCRational] := Return[term];

  NCRTimes[a_NCRational, b_NCRational] := Module[
    {m,vars,tmp,coeffs,
     nA,nB,
     terms,A,B,C,D,polynomial},

    (* Evaluate a ** b *)
      
    (* Print["> NCRTimes"]; *)

    (* Number of variables + 1 *)
    m = Length[a[[5]]] + 1;
    vars = a[[5]];
    terms = {a,b};
      
    (* polynomial? *)
    polynomial = And @@ Map[NCRPolynomialQ, terms];

    (*
    Print["a = ", Map[Normal,a]];
    Print["b = ", Map[Normal,b]];
    *)
      
    (* multiplication by constant *)
      
    nA = NCROrder[a];
    nB = NCROrder[b];

    If[ nA == 0,
        Return[NCRational[b[[1]],a[[4,1,1]]*b[[2]],
                          b[[3]],a[[4,1,1]]*b[[4]],b[[5]]],
                          b[[6]],b[[7]]];
    ];

    If[ nB == 0,
        Return[NCRational[a[[1]],b[[4,1,1]]*a[[2]],
                          a[[3]],b[[4,1,1]]*a[[4]],a[[5]]],
                          a[[6]],a[[7]]];
    ];

    If[ NCRLinearQ[b] && NCRLinearQ[a], 
        
        (* Multiplication of linear terms *)
       
        A = SparseArray[{1,i_,i_} -> 1,{m,3,3}];
        
        A[[All,1,2]] = Flatten[
            CoefficientArrays[-NCRationalToNC[a][[1,1]], vars]
        ];
        A[[All,2,3]] = Flatten[
            CoefficientArrays[-NCRationalToNC[b][[1,1]], vars]
        ];
        B = SparseArray[{3,1}->1,{3,1}];
        C = SparseArray[{1,1}->1,{1,3}];
        D = SparseArray[{},{1,1}];
        
        (*
        Print["A = ", Map[Normal, A]];
        Print["B = ", Map[Normal, B]];
        Print["C = ", Map[Normal, C]];
        Print["D = ", Map[Normal, D]];
        *)
        
        Return[NCRational[A, B, C, D, a[[5]], {Polynomial -> True}]];
        
    ];

    If [ NCRLinearQ[b] && NCRStrictlyProperQ[a], 
        
        (* Multiplication on the right by a linear term *)
       
        tmp = NCRationalToNC[b][[1,1]];
        coeffs = Flatten[CoefficientArrays[tmp, vars]];
        
        (*
        Print["tmp = ", tmp];
        Print["coeffs = ", Normal[coeffs]];
        *)
        
        A = PadRight[a[[1]], {m,nA+1,nA+1}];
        A[[All,1;;nA,{nA+1}]] = Outer[Times, -coeffs, a[[2]]];
        A[[1,nA+1,nA+1]] = 1;
        B = SparseArray[{nA+1,1}->1,{nA+1,1}];
        C = PadRight[a[[3]], {1,nA+1}, 0];
        D = a[[4]];
       
        (*
        Print["A = ", Map[Normal, A]];
        Print["B = ", Map[Normal, B]];
        Print["C = ", Map[Normal, C]];
        Print["D = ", Map[Normal, D]];
        *)

        Return[NCRational[A, B, C, D, a[[5]], 
               If[polynomial, {Polynomial -> True}, {}]]];
        
    ];

    If[ NCRLinearQ[a] && NCRStrictlyProperQ[b], 
        
        (* Multiplication on the left by a linear term *)
       
        tmp = NCRationalToNC[a][[1,1]];
        coeffs = Flatten[CoefficientArrays[tmp, vars]];
          
        (*
        Print["tmp = ", tmp];
        Print["coeffs = ", Normal[coeffs]];
        *)
        
        A = PadLeft[b[[1]], {m,nB+1,nB+1}];
        A[[All,{1},2;;nB+1]] = Outer[Times, -coeffs, b[[3]]];
        A[[1,1,1]] = 1;
        B = PadLeft[b[[2]], {nB+1,1}, 0];
        C = SparseArray[{1,1}->1,{1,nB+1}];
        D = b[[4]];
       
        (*
        Print["A = ", Map[Normal, A]];
        Print["B = ", Map[Normal, B]];
        Print["C = ", Map[Normal, C]];
        Print["D = ", Map[Normal, D]];
        *)
        
        Return[NCRational[A, B, C, D, b[[5]], 
               If[polynomial, {Polynomial -> True}, {}]]];
        
    ];
      
    (* general product *)
      
    A = SparseArray[
          Apply[
            SparseArray[Band[{1, 1}] -> {##}]&,
                        Map[terms[[All,1,#1]]&, Range[m]],
            {1}
          ]
        ];
    A[[1,1;;nA,nA+1;;nA+nB]] = - a[[2]] . b[[3]];
      
    Return[
      NCRational[A, Join[a[[2]] . b[[4]], b[[2]]],
                 Join[a[[3]], a[[4]] . b[[3]], 2], a[[4]] . b[[4]],
                 a[[5]], 
                 If[polynomial, {Polynomial -> True}, {}]
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
       nonlinear,nonZeroOrder,polynomial},
      terms = {tterms};

      (* Print["> NCRPlus"]; *)
      
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
                      vars, {Linear -> True, Polynomial -> True}]
                   ,
                    (* constant *)
                    NCToNCRationalAux[coeffs[[1]],vars]
                ];

          (*
          Print["tmp = ", Map[Normal,tmp]];
          *)

          If[ Length[nonlinear] == 0,
              Return[tmp];
          ];
         
          (* select linear and nonlinear terms *)
          terms = Append[terms[[nonlinear]], tmp];
          nonZeroOrder = Range[
              If[ degree > 0, Length[terms], Length[terms] - 1]
          ];
          
         ,
          
          (* select nonlinear terms *)
          terms = terms[[nonlinear]];
          nonZeroOrder = All;
      ];

      (* polynomial? *)
      polynomial = And @@ Map[NCRPolynomialQ, terms[[nonZeroOrder]]];
      
      (* add linear and nonlinear terms *)
      Return[
        NCRational[ 
          SparseArray[
            Apply[
              SparseArray[Band[{1, 1}] -> {##}]&,
                          Map[terms[[nonZeroOrder,1,#1]]&, Range[m]],
              {1}
            ]
          ],
          Join @@ terms[[nonZeroOrder,2]], 
          Join[##,2]& @@ terms[[nonZeroOrder,3]],
          Plus @@ terms[[All,4]],
          terms[[1,5]],
          If[polynomial, {Polynomial -> True}, {}]
        ]
     ];
      
  ];

  (* NCRControllableSubspace *)

  Clear[AllPerms];
  AllPerms[cWords_, ncWords_] := Block[
    {pattern},
    pattern = Flatten[Join[Map[{___,#}&, ncWords], {___}]];

    (*
    Print["word = ", Join[cWords, ncWords]];
    Print["pattern = ", pattern];
    *)
        
    Return[DeleteCases[Permutations[Join[cWords, ncWords]], 
                       Except[pattern]]];
  ];
  
  Clear[CommuteWords];
  CommuteWords[words_, commutativeVars_] := Module[
    {commutativeQ,x,
     CWords,NCWords},
      
    commutativeQ[x_] := MemberQ[commutativeVars, x];
    
    CWords = Map[Sort[Select[#, commutativeQ]]&, words];
    NCWords = Map[Select[#, (Not[commutativeQ[#]]&)]&, words];
      
    Return[{Join[CWords, NCWords, 2],
            MapThread[AllPerms, {CWords, NCWords}]}];
  ];
  
  NCRControllableSubspace[A_, B_, 
                          commutativeVars_:{}, 
                          opts:OptionsPattern[{}]] := Module[
    {letters = Range[Length[A]],
     wordLength = 0,
     words = {{}},
     controllabilityMatrix,
     newColumns,
     AB,ABStore,
     p,q,rank,newRank,newQ,
     candidateWords,
     candidateColumns,
     commutativeWords},

    (* Store products for faster evaluation *)
    ABStore = <|{} -> B|>;
    AB[word_List] := 
       AppendTo[ABStore, 
         word -> A[[First[word]]] . Lookup[ABStore, 
                                           Key[Rest[word]],
                                           AB[Rest[word]]]][word];

    (* words = {{}}; *)
    (* wordLength = 0 *)
    {controllabilityMatrix,p,q,rank} = LURowReduce[Transpose[B]];

    If[ rank == 0,
        (* trivially uncontrollable *)
        Return[{{}, q}];
    ];
                              
    (* otherwise iniatialize subspace *)
    controllabilityMatrix = Take[controllabilityMatrix,rank];

    (*
    Print["commutativeVars = ", commutativeVars];
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

       If[ Length[commutativeVars] > 0,

           (* Commute words *)
           {candidateWords,commutativeWords} = 
             CommuteWords[candidateWords, commutativeVars];
           
           (*
           Print["commutativeWords = ", commutativeWords]; 
           *)
           
           candidateColumns = ArrayFlatten[
                                {Apply[Plus, 
                                       Map[AB, commutativeWords, {2}],
                                       {1}]}][[q]];

          ,

           (* assemble candidate columns *)
           candidateColumns = ArrayFlatten[{Map[AB, candidateWords]}][[q]];

       ];
          
       (* row reduce to find range *)
       {u,p,newQ,newRank} = LURowReduceIncremental[
                              controllabilityMatrix,
                              Transpose[candidateColumns]
                             ];
       controllabilityMatrix = If[rank > 0, 
                                  Take[u,newRank],
                                  {}
                               ];

       (* adjust permutations *)
       q = q[[newQ]];

       (*
       Print["wordLength = ", wordLength];
       Print["candidateWords = ", candidateWords];
       Print["candidateColumns = ", Normal[Transpose[candidateColumns]]];
       Print["controllabilityMatrix = ", Normal[controllabilityMatrix]];
       Print["u = ", Normal[u]];
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
      
  Clear[NCRScale];
  NCRScale[A_, B_, C_] := Module[
    {n = Length[B],
     A0inv,
     A2, B2, C2},

    (* 
      C (A0 + Ai x)^-1 B ~ C (I + A0^-1 Ai x)^-1 A0^-1 B
    *)

    (*
    Print["A = ", A];
    Print["B = ", B];
    Print["C = ", C];
    *)
      
    (* Scale by inv[A0] *)
    Quiet[                             
      Check[ A0inv = If[ n == 1
                        ,
                         LinearSolve[Normal[A[[1]]]]
                        ,
                         LinearSolve[A[[1]]]
                     ]
            ,
             Message[NCRational::NotAnalytic];
             Return[{A,B,C}];
            ,
             {Divide::infy,LinearSolve::sing1,LinearSolve::nosol}
      ]; 
      ,
       {Divide::infy,LinearSolve::sing1,LinearSolve::nosol}
    ];

    {A2, B2} = {Map[A0inv, Rest[A]], A0inv[B]};
    C2 = C;
    
    Return[{A2,B2,C2}];
  ];
      
  NCRControllableRealization[
      rat_NCRational, 
      OptionsPattern[{Method -> "Analytic",
                      CommutativeVariables -> {}}]] := Module[
    {A,B,C,D,
     A2,B2,C2,
     n,m,
     x0,A0,A0inv,
     singular = False,
     ctrb,q,rank,R,L,
     method,
     commutativeVariables},

    (* Process Options *)
    method = OptionValue[Method];
    commutativeVariables = OptionValue[CommutativeVariables];
                                 
    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];
    n = Length[B];
    m = Length[A];                             

    Switch[ method
           ,
            "Analytic"
           , 
        
            (* Print["> ANALYTIC SHIFT"]; *)
            
            (*
              A0~ = A0 + Ai x0
              C [A0~ + Ai (x-x0)]^-1 B 
                       ~ C (I + A0~^-1 Ai (x - x0))^-1 A0~^-1 B
                       = C ([I - A0~^-1 Ai x0] + A0~^-1 Ai x)^-1 A0~^-1 B
                       = C ([I - A2 x0] + A2 x) B2
            *)

            (* Scale by inv[A0] *)
            Check[ {A2,B2,C2} = NCRScale[A,B,C];
                  ,
                   (* singular realization *)
                   singular = True;

                   (* shift realization *)
                   (* A0 + Ai x = (A0 + Ai x0) + Ai (x - x0) *)
                   x0 = Table[RandomInteger[{1,10}],{i,m-1}];
                   A0 = A[[1]] + Plus @@ (x0 * Rest[A]);

                   (* Print["x0 = ", x0]; *)

                   Check[ {A2,B2,C2} = NCRScale[Prepend[Rest[A], A0],B,C];
                         ,
                          Message[NCRational::Singular];
                          Return[rat];
                         ,
                          NCRational::NotAnalytic
                   ];
                  ,
                   NCRational::NotAnalytic
            ];

            (* Calculate row-reduced controllability subspace *)
            {ctrb, q} = NCRControllableSubspace[A2, B2, 
                                                commutativeVariables];
            rank = Length[ctrb];
            
           ,
            "CommutativeScaling"
           ,
            
            (* Print["> COMMUTATIVE SCALING SHIFT"]; *)
            
            {A2,B2,C2} = {A,B,C};
            A2[[1]] = A2[[1]] - IdentityMatrix[n];
            
            {ctrb, q} = NCRControllableSubspace[A2, B2, 
                           Join[{1}, commutativeVariables+1]];
            rank = Length[ctrb];

    ];
                                 

    (*
    Print["A2 = ", A2];
    Print["B2 = ", B2];
    Print["C2 = ", C2];
    Print["ctrb = ", ctrb];
    Print["rank = ", rank];
    *)

    If[ rank == 0,
        (* return constant term *)
        Return[NCToNCRational[rat[[4]][[1,1]], rat[[5]]]];
    ];
                                 
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

        Switch[ method
               ,
                "Analytic"
               ,
                
                A2 = Map[NCDot[L, #, R]&, A2];
                B2 = NCDot[L, B2];
                C2 = NCDot[C2, R];
                A0 = IdentityMatrix[rank];
                If[ singular,
                    A0 -= Plus @@ (x0 * A2);
                    (* Print["A0 = ", A0]; *)
                  ];
                
               ,
                "CommutativeScaling"
               ,

                A0 = NCDot[L, First[A], R];
                A2 = Map[NCDot[L, #, R]&, Rest[A]];
                B2 = NCDot[L, B2];
                C2 = NCDot[C2, R];

        ];
        
        (* Calculate reduced realization *)
        Return[
          NCRational[
            Prepend[A2, A0], 
            B2, C2, D, 
            rat[[5]], 
            rat[[6]]
          ]
        ];
        
       ,
        
        (* Realization is already controllable *)
        Return[rat];
        
    ];
           
  ];
      
  (* NCRTranspose *)
  NCRTranspose[rat_NCRational] := rat /; NCROrder[rat] == 0;
  
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
        rat[[5]], 
        rat[[6]]
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
      NCRControllableRealization[rat, opts], opts
    ];

  (* NCR Gramian *)
  NCRControllabilityGramian[rat_NCRational,
                            opts:OptionsPattern[{}]] := Module[
    {A,B,C,D, n,
     AA, bb, XX},

    (* Grab matrices *)
    {A,B,C,D} = Normal[rat];
    n = Length[B];

    AA = KroneckerProduct[A[[1]],A[[1]]] -
           Plus @@ Map[KroneckerProduct[#,#]&, Rest[A]];
    bb = KroneckerProduct[B,B];
    XX = LinearSolve[AA, bb];

    Return[Transpose[ArrayReshape[XX,{n,n}]]];

  ];

  (* NCR Gramian *)
  NCRObservabilityGramian[rat_NCRational,
                          opts:OptionsPattern[{}]] :=
    NCRControllabilityGramian[NCRTranspose[rat], opts];
    
End[]

EndPackage[]
