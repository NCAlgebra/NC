(* :Title: 	NCQuadratic.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCQuadratic` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCQuadratic`",
	      "NCSylvester`",
	      "NCPolynomial`",
	      "NCSelfAdjoint`",
	      "NCDot`",
              "NCUtil`",
	      "NCOptions`",
	      "NonCommutativeMultiply`" ];

Clear[NCPToNCQuadratic,
      NCToNCQuadratic,
      NCQuadraticToNCPolynomial,
      NCQuadraticToNC,
      NCQuadraticMakeSymmetric,
      NCMatrixOfQuadratic];

Get["NCQuadratic.usage"];

NCQuadratic::NotQuadratic = "Function is not quadratic.";

NCQuadraticMakeSymmetric::NotSymmetric = "Quadratic form is not \
symmetric. Use SymmetricVariables to declare variables symmetric.";

NCMatrixOfQuadratic::NotSymmetric = "Quadratic form is not \
symmetric.";

Options[NCQuadraticMakeSymmetric] = {
  SymmetricVariables -> {}
};

Options[NCQuadraticToNCPolynomial] = {
  Collect -> True
};

Begin[ "`Private`" ]

  (* NCPToNCQuadratic *)

  Clear[NCQuadraticAux];
  NCQuadraticAux[m_, terms_] := (
    Map[{#[[2]]**m[[1]], #[[1]]*#[[3]], m[[2]]**#[[4]]}&, terms] 
    ) /; Length[m] == 2;

  NCQuadraticAux[m_, terms_] := (
    Map[{#[[2]]**m[[1,1]], #[[1]], m[[1,2]]**#[[3]]}&, terms] 
    ) /; Length[m] == 1;

  Clear[NCQuadraticBasis];
  NCQuadraticBasis[list_] := Module[
    {basis, coefficient},

    {basis, index} = NCConsolidateList[list];

    coefficient = SparseArray[Thread[MapIndexed[{First[#2], #1}&, index] -> 1]];
      
    Return[{basis, coefficient}];
      
  ];

  NCToNCQuadratic[p_, vars_] := NCPToNCQuadratic[NCToNCPolynomial[p, vars]];
  
  NCPToNCQuadratic[p_NCPolynomial] := Module[
    {terms},

    If [!NCPQuadraticQ[p],
        Message[NCQuadratic::NotQuadratic];
        Return[{$Failed,$Failed,$Failed,$Failed,$Failed}];
    ];

    (* Print["p = ", NCPolynomialToNC[p]]; *)
      
    (* select quadratic terms *)
    {left, middle, right} = 
      Transpose[Flatten[KeyValueMap[NCQuadraticAux, 
                                    NCPTermsOfTotalDegree[p, 2]], 1]];

    (*
    Print["left = ", left];
    Print["middle = ", middle];
    Print["right = ", right];
    Print["l.m.r = ", 
          NCDot[left, 
                  DiagonalMatrix[middle], right] - NCPolynomialToNC[p]];
    *)
      
    {rightBasis, rightMatrix} = NCQuadraticBasis[right];
    {leftBasis, leftMatrix} = NCQuadraticBasis[left];

    (* 
    Print["rightBasis = ", rightBasis];
    Print["rightMatrix = ", Normal[rightMatrix]];
    Print["rightMatrix . basis = ", rightMatrix . rightBasis];

    Print["leftBasis = ", leftBasis];
    Print["leftMatrix = ", Normal[leftMatrix]];
    Print["leftMatrix . basis = ", leftMatrix . leftBasis];
    *)

    (* build middle matrix *)
    middleMatrix = SparseArray[NCDot[Transpose[leftMatrix], 
                           SparseArray[
                               MapIndexed[({First[#2],First[#2]} -> #1)&, 
                                          middle]],
                           rightMatrix]];
      
    (* Print["middleMatrix = ", MatrixForm[middleMatrix]]; *)

    Return[Join[NCPToNCSylvester[p, False], {leftBasis, middleMatrix, rightBasis}]];
      
  ];

  (* NCQuadraticMakeSymmetric *)
  
  NCQuadraticMakeSymmetric[{s0_,sylv_,left_,middle_,right_},
                           opts:OptionsPattern[{}]] := Module[
    {options, symmetricVars,
     vars, tpRule, rt, lt, rmat, lmat, mmat, perm},
    
    (* process options *)

    options = Flatten[{opts}];

    symmetricVars = SymmetricVariables 
          /. options
          /. Options[NCQuadraticMakeSymmetric, SymmetricVariables];

    (* Pick variables *)
    vars = Keys[sylv];
    tpRule = Thread[Map[tp,symmetricVars] -> symmetricVars];

    (* Print["tpRule = ", tpRule]; *)
                               
    (* Consolidate vectors *)
    {rt, rmat} = NCQuadraticBasis[right /. tpRule];
    {lt, lmat} = NCQuadraticBasis[left /. tpRule];
    mmat = Transpose[lmat] . middle . rmat;
                               
    (* Transpose right vector *)
    tpRt = Map[tp, rt] /. tpRule;
    
    (*                               
    Print["lt = ", lt];
    Print["rt = ", rt];
    Print["mmat = ", MatrixForm[Normal[mmat]]];
    Print["tpRt = ", tpRt];
    *)
                               
    (* Is it symmetric? *)
    If[ Complement[lt, tpRt] =!= {},
        Message[NCQuadraticMakeSymmetric::NotSymmetric];
        Return[{s0,sylv,left,middle,right}];
    ];
   
    (* Otherwise find permutation *)
    perm = Lookup[Association[Thread[lt -> Range[1, Length[lt]]]], tpRt];

    (* Print["perm = ", perm]; *)
                               
    (* and permute representation *)
                               
    Return[{s0, sylv, lt[[perm]], mmat[[perm]], rt}];
                            
  ];
  
  (* NCMatrixOfQuadratic *)
  NCMatrixOfQuadratic[p_, vars_, opts:OptionsPattern[{}]] := Module[
      {options, symmetricVars,
       sym, symVars, symRule, expr,
       m0,sylv,l,m,r},

      (* process options *)

      options = Flatten[{opts}];

      symmetricVars = SymmetricVariables 
            /. options
            /. Options[NCQuadraticMakeSymmetric, SymmetricVariables];

      (* Is p symmetric *)
      {sym, symVars} = NCSymmetricTest[p, 
                              SymmetricVariables -> symmetricVars];
      
      (* Quick return if it failed *)
      If [ !sym,
           Message[NCMatrixOfQuadratic::NotSymmetric];
           Return[{{},{},{}}];
      ];

      (* Symmetrization rule *)
      symRule = Thread[Map[tp, symVars] -> symVars];
      
      (* Convert to NCPolynomial *)
      expr = NCToNCPolynomial[p /. symRule, vars];
      
      (* Compute decomposition *) 
      Check[ {m0,sylv,l,m,r} = NCPToNCQuadratic[expr];
            ,
             Return[{{},{},{}}];
            ,
             NCQuadratic::NotQuadratic
      ];

      (* Symmetrize decomposition *) 
      {m0,sylv,l,m,r} = NCQuadraticMakeSymmetric[{m0,sylv,l,m,r}, 
                                     SymmetricVariables -> symVars];

      Return[{l,m,r}];
      
  ]; 
  
  (* NCQuadraticToNCPolynomial *)

  Clear[LeftFactorMultiply];
  LeftFactorMultiply[left_, l_, r_] :=  
    NCDot[Transpose[KroneckerProduct[left, IdentityMatrix[r]]], l]

  Clear[RightFactorMultiply];
  RightFactorMultiply[right_, u_, s_] :=
    NCDot[u, KroneckerProduct[right, IdentityMatrix[s]]];

  Clear[FactorMultiply];
  FactorMultiply[left_, right_, l_, u_, var_, r_, s_] := { 
    LeftFactorMultiply[left, l, r],
    RightFactorMultiply[right, u, s],
    var 
  };
  
  Clear[NCQuadraticToNCPolynomialAux];
  NCQuadraticToNCPolynomialAux[{{},{},F_,var_}, 
                      collect_] := 
     Return[{{},{},var}];

  NCQuadraticToNCPolynomialAux[{left_,right_,F_,var_},
                      collect_] := 
  Module[
    {l, u, pr, qs, r, s, p, q},

    {pr, qs} = Dimensions[F];
    p = Length[left];
    q = Length[right];
    r = pr/p;
    s = qs/q;

    {l,u} = If [collect
        , 
      
        (* Factor coefficient matrix F and 
           compute LU matrices truncated and permuted *)
        GetLUMatrices @@ LUDecompositionWithCompletePivoting[F]

        ,
        
        (* Do not factor coefficient matrix F *)
        {SparseArray[{{i_, i_} -> 1}, {p, p}], F}
        
    ];

    (*
    Print["l = ", Normal[l]];
    Print["u = ", Normal[u]];
    *)

    (* Multiply factors *)
    l = LeftFactorMultiply[left, l, r];
    u = RightFactorMultiply[right, u, s];
     
    Return[ 
      If [ r === 1 && s === 1, 
         {Flatten[l, 1], Flatten[u, 1], var}
        ,
         { Flatten[Partition[l, {r, 1}], 1],
           Map[Flatten[#,1]&, Partition[u, {1, s}]], var }
      ]
    ];

  ];

  NCQuadraticToNC[{m0_, lin_, left_, middle_, right_}, 
                  opts:OptionsPattern[{}]] := Module[
    {retval},
  
    (* process options *)

    retval = NCSylvesterToNC[{m0, lin}, opts] \
           + NCMatrixExpand[left ** middle ** right];

    Return[retval];
      
  ];

End[]

EndPackage[]
