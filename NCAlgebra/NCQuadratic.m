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
	      "MatrixDecompositions`",
	      "NCMatMult`",
              "NCUtil`",
	      "NCOptions`",
	      "NonCommutativeMultiply`" ];

Clear[NCQuadratic,
      NCQuadraticToNCPolynomial,
      NCQuadraticMakeSymmetric];

Get["NCQuadratic.usage"];

NCQuadraticMakeSymmetric::NotSymmetric = "Quadratic form is not \
symmetric. Use SymmetricVariables to declare variables symmetric.";

Options[NCQuadraticMakeSymmetric] = {
  SymmetricVariables -> {}
};

Options[NCQuadraticToNCPolynomial] = {
  Collect -> True
};

Begin[ "`Private`" ]

  (* NCQuadratic *)

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

    basis = Merge[Thread[list -> Range[1, Length[list]]],
                  Identity];
     
    coefficient = SparseArray[
               Thread[Flatten[
                        Apply[List, 
                              MapIndexed[Thread[#1 -> First[#2]]&, 
                                         Values[basis]], {2}], 1] -> 1]];

    Return[{Keys[basis], coefficient}];
      
  ];
  
  NCQuadratic[p_NCPolynomial] := Module[
    {terms},

    If [!NCPQuadraticQ[p],
        Message[NCQuadratic::NotQuadratic];
        Return[$Failed];
    ];

    (* select quadratic terms *)
    {left, middle, right} = 
      Transpose[Flatten[KeyValueMap[NCQuadraticAux, 
                                    NCPTermsOfTotalDegree[p, 2]], 1]];

    (*
    Print["left = ", left];
    Print["middle = ", middle];
    Print["right = ", right];
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
    middleMatrix = SparseArray[MatMult[Transpose[leftMatrix], 
                           SparseArray[
                               MapIndexed[({First[#2],First[#2]} -> #1)&, 
                                          middle]],
                           rightMatrix]];
      
    (* Print["middleMatrix = ", middleMatrix]; *)

    Return[Join[NCSylvester[p, False], {leftBasis, middleMatrix, rightBasis}]];
      
  ];

  (* NCQuadraticMakeSymmetric *)
  
  NCQuadraticMakeSymmetric[{s0_,sylv_,left_,middle_,right_},
                           opts:OptionsPattern[{}]] := Module[
    {options, symmetricVars,
     vars, lt},
    
    (* process options *)

    options = Flatten[{opts}];

    symmetricVars = SymmetricVariables 
          /. options
          /. Options[NCQuadraticMakeSymmetric, SymmetricVariables];

    (* Pick variables *)
    vars = Keys[sylv];
    tpRule = Thread[Map[tp,symmetricVars] -> symmetricVars];

    Print["tpRule = ", tpRule];
                               
    (* Transpose right vector *)
    rt = right /. tpRule;
    lt = left /. tpRule;
    tpRt = Map[tp, right] /. tpRule;
    
    Print["lt = ", lt];
    Print["rt = ", rt];
    Print["tpRt = ", tpRt];
                               
    If[ Complement[lt, tpRt] =!= {},
        Message[NCQuadraticMakeSymmetric::NotSymmetric];
        Return[{s0,sylv,left,middle,right}];
    ];
   
    (* Otherwise find permutation *)
    perm = Lookup[Association[Thread[lt -> Range[1, Length[lt]]]], tpRt];

    Print["perm = ", perm];
                               
    perm = Flatten[Map[Position[tpRt, #, {1}]&, lt]];
                           
    Print["perm = ", perm];
                               
    (* and permute representation *)
                               
    Return[{s0, sylv, lt[[perm]], middle[[perm]], rt}];
                            
  ];
  
  (* NCQuadraticToNCPolynomial *)

  Clear[LeftFactorMultiply];
  LeftFactorMultiply[left_, l_, r_] :=  
    MatMult[Transpose[KroneckerProduct[left, IdentityMatrix[r]]], l]

  Clear[RightFactorMultiply];
  RightFactorMultiply[right_, u_, s_] :=
    MatMult[u, KroneckerProduct[right, IdentityMatrix[s]]];

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

  NCQuadraticToNCPolynomial[sylv_, 
                      opts:OptionsPattern[{}]] := Module[
    {options, collect, m0, rules, vars},

    (* process options *)

    options = Flatten[{opts}];

    collect = Collect
	    /. options
	    /. Options[NCQuadraticToNCPolynomial, Collect];
      
    m0 = First[sylv];
    vars = sylv[[2;;,4]];
                          
    (* Collect polynomial *)

    rules = Map[NCQuadraticToNCPolynomialAux[#,collect]&,
                Rest[sylv], {1}];

    (* 
    Print["vars = ", vars];
    Print["rules = ", rules];
    *)

    rules = <|Map[{#[[3]]}->Transpose[#[[{1,2}]]]&, rules]|>;

    (* Print["rules = ", rules]; *)

    (* Add scalar *)
    rules = Map[Prepend[#,1]&, rules, {2}];

    (* Print["rules = ", rules]; *)

    Return[NCPNormalize[NCPolynomial[m0, rules, vars]]];
      
  ];

  
End[]

EndPackage[]
