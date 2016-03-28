(* :Title: 	NCQuadratic.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCQuadratic` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCQuadratic`",
	      "NCPolynomial`",
	      "MatrixDecompositions`",
	      "NCMatMult`",
	      "NonCommutativeMultiply`" ];

Clear[NCQuadratic,
      NCQuadraticToNCPolynomial];

Get["NCQuadratic.usage"];

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
    {left, middle, right}
      = Transpose[
              Flatten[
                MapThread[NCQuadraticAux,
                          Transpose[
                             Apply[List, 
                                   Normal[NCPTermsOfTotalDegree[p, 2]],
                                   {1}]]], 1]];

    Print["left = ", left];
    Print["middle = ", middle];
    Print["right = ", right];
      
    {rightBasis, rightMatrix} = NCQuadraticBasis[right];
    {leftBasis, leftMatrix} = NCQuadraticBasis[left];

    Print["rightBasis = ", rightBasis];
    Print["rightMatrix = ", Normal[rightMatrix]];
    Print["rightMatrix . basis = ", rightMatrix . rightBasis];

    Print["leftBasis = ", leftBasis];
    Print["leftMatrix = ", Normal[leftMatrix]];
    Print["leftMatrix . basis = ", leftMatrix . leftBasis];

    middleMatrix = MatMult[Transpose[leftMatrix], 
                           SparseArray[
                               MapIndexed[({First[#2],First[#2]} -> #1)&, 
                                          middle]],
                           rightMatrix];
      
    Print["middleMatrix = ", middleMatrix];

    Return[{{}, {leftBasis, middleMatrix, rightBasis}}];
      
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

  (* ------------------------------------------------------------ *)
  (* OLDER CODE *)
    
  (* Blow representation from scalar to matrix representation *)

  Clear[BlowRepresentation]
  BlowRepresentation[
    {leftBasis_, rightBasis_},
    {r_, s_},
    {left_, right_, F_, var_},
    {ii_, jj_}
    ] := Module[
    {i, j},

    i = r (Flatten[Map[Position[leftBasis, #, 1] &, left]] - 1) + ii;
    j = s (Flatten[Map[Position[rightBasis, #, 1] &, right]] - 1) + jj;

    MapThread[(#1 -> #2) &, {Flatten[Outer[List, i, j], 1], 
      Flatten[F]}]
    ];

  (* Grow representation to equalize sizes given common left and right basis *)

  Clear[GrowRepresentation]
  GrowRepresentation[
    {leftBasis_, rightBasis_},
    {r_, s_},
    {left_, right_, F_, var_}
    ] := Module[
    {p, q, FF},

    p = Length[leftBasis];
    q = Length[rightBasis];

    NCDebug[2, p, q];

    If[p + q == 0, 
      Return[{{}}];
    ]

    FF = If [Length[rightBasis] === Length[right],
      F
     ,
      F.KroneckerProduct[
        Part[SparseArray[{i_, i_} -> 1, {q, q}], 
         Flatten[Map[Position[rightBasis, #, 1] &, right]], All],
        SparseArray[{i_, i_} -> 1, {s, s}]
        ]
      ];

    If [Length[leftBasis] =!= Length[left],
     FF =
       KroneckerProduct[
         Part[SparseArray[{i_, i_} -> 1, {p, p}], All, 
          Flatten[Map[Position[leftBasis, #, 1] &, left]]],
         SparseArray[{i_, i_} -> 1, {r, r}]
         ].FF;
     ];

    Return[FF];

  ];

  NCOldQuadratic[f_?MatrixQ, 
                            var_?MatrixQ] := Module[
     {exp, leftBasis, rightBasis,
      p, q, r, s, F},

     exp = ExpandNonCommutativeMultiply[f];
     {r, s} = Dimensions[exp, 2];

     exp = Map[NCOldQuadratic[exp, #] &, var, {2}];

     leftBasis = Union[Flatten[Part[exp, All, All, 1]]];
     rightBasis = Union[Flatten[Part[exp, All, All, 2]]];

     NCDebug[2, r, s, exp];

     Return[
      {leftBasis, rightBasis, Map[GrowRepresentation[
          {leftBasis, rightBasis}, {r, s}, #] &, exp, {2}], var}
      ];

     ];

  NCOldQuadratic[f_, var_?MatrixQ] :=
    NCOldQuadratic[{{f}}, var];

  NCOldQuadratic[f_?MatrixQ, var_Symbol] := Module[
     {exp, leftBasis, rightBasis,
      p, q, r, s, F},

     exp = Map[NCOldQuadratic[#, var] &, f, {2}];
     leftBasis = Union[Flatten[Part[exp, All, All, 1]]];
     rightBasis = Union[Flatten[Part[exp, All, All, 2]]];

     {r, s} = Dimensions[exp, 2];
     p = Length[leftBasis];
     q = Length[rightBasis];

     F = If[ p + q == 0,

         {{}}
         ,
         SparseArray[
           Flatten[MapIndexed[
             BlowRepresentation[
               {leftBasis, rightBasis}, {r, s}, ##] &, exp, {2}]],
           {p r, q s}]
     ];

     Return[{leftBasis, rightBasis, F, var}];
  ];
  
End[]

EndPackage[]
