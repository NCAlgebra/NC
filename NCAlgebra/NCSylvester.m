(* :Title: 	NCSylvester.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCSylvester` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCSylvester`",
	      "NCPolynomial`",
	      "MatrixDecompositions`",
	      "NCMatMult`",
	      "NonCommutativeMultiply`" ];

Clear[NCSylvesterRepresentation,
      NCSylvesterRepresentationToNCPolynomial];

Get["NCSylvester.usage"];

Options[NCSylvesterRepresentationToNCPolynomial] = {
  Collect -> True
};

Begin[ "`Private`" ]

  (* NCSylvesterRepresentation *)

  NCSylvesterRepresentationAux;
  Clear[NCSylvesterRepresentationAux];
  NCSylvesterRepresentationAux[poly_Association, 
                               var_Symbol] := Module[
    {exp, coeff, left, right, leftBasis, rightBasis,
     i, j, p, q, F},

    (* Easy return if independent of var *)
    If [!KeyExistsQ[poly, {var}]
        ,
        Return[{{},{},SparseArray[{}, {0, 0}],var}];
    ];
                           
    (* This will never fail *)
    exp = poly[{var}];

    (* Print["exp1 = ", exp]; *)

    {coeff, left, right} = Transpose[exp];
    leftBasis = Union[left];
    rightBasis = Union[right];

    p = Length[leftBasis];
    q = Length[rightBasis];

    i = Flatten[Map[Position[leftBasis, #, 1] &, left]];
    j = Flatten[Map[Position[rightBasis, #, 1] &, right]];

    F = SparseArray[
      MapThread[({#2, #3} -> #1) &, {coeff, i, j}], {p, q}];

    Return[{leftBasis, rightBasis, F, var}];

  ];

  NCSylvesterRepresentation[p_NCPolynomial] := (
    If [!NCPLinearQ[p],
        Message[NCSylvesterRepresentation::NotLinear];
        Return[$Failed];
    ];
    Prepend[Map[NCSylvesterRepresentationAux[p[[2]], #]&, p[[3]]],
            p[[1]] ]
  );


  (* NCSylvesterRepresentationToNCPolynomial *)

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
  
  Clear[NCSylvesterRepresentationToNCPolynomialAux];
  NCSylvesterRepresentationToNCPolynomialAux[{{},{},F_,var_}, 
                      collect_] := 
     Return[{{},{},var}];

  NCSylvesterRepresentationToNCPolynomialAux[{left_,right_,F_,var_},
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

  NCSylvesterRepresentationToNCPolynomial[sylv_, 
                      opts:OptionsPattern[{}]] := Module[
    {options, collect, m0, rules, vars},

    (* process options *)

    options = Flatten[{opts}];

    collect = Collect
	    /. options
	    /. Options[NCSylvesterRepresentationToNCPolynomial, Collect];
      
    m0 = First[sylv];
    vars = sylv[[2;;,4]];
                          
    (* Collect polynomial *)

    rules = Map[NCSylvesterRepresentationToNCPolynomialAux[#,collect]&,
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

  NCOldSylvesterRepresentation[f_?MatrixQ, 
                            var_?MatrixQ] := Module[
     {exp, leftBasis, rightBasis,
      p, q, r, s, F},

     exp = ExpandNonCommutativeMultiply[f];
     {r, s} = Dimensions[exp, 2];

     exp = Map[NCOldSylvesterRepresentation[exp, #] &, var, {2}];

     leftBasis = Union[Flatten[Part[exp, All, All, 1]]];
     rightBasis = Union[Flatten[Part[exp, All, All, 2]]];

     NCDebug[2, r, s, exp];

     Return[
      {leftBasis, rightBasis, Map[GrowRepresentation[
          {leftBasis, rightBasis}, {r, s}, #] &, exp, {2}], var}
      ];

     ];

  NCOldSylvesterRepresentation[f_, var_?MatrixQ] :=
    NCOldSylvesterRepresentation[{{f}}, var];

  NCOldSylvesterRepresentation[f_?MatrixQ, var_Symbol] := Module[
     {exp, leftBasis, rightBasis,
      p, q, r, s, F},

     exp = Map[NCOldSylvesterRepresentation[#, var] &, f, {2}];
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
