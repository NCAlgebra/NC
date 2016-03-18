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

Clear[NCQuadraticRepresentation];
NCQuadraticRepresentation::usage="\
NCQuadraticRepresentation[p] gives an expanded representation \
for the quadratic NCPolynomial p.
    
NCQuadraticRepresentation returns a list with the coefficients \
of the linear polynomial p where
\tthe first element is a the independent term,
and the remaining elements are lists with four elements:
\tthe first element is a list of right nc symbols;
\tthe second element is a list of right nc symbols;
\tthe third element is a numeric array;
\tthe fourth element is a variable.

Example:
\tp = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
\tNCQuadraticRepresentation[exp,x]
produces
\t{2, {left1,right1,array1,var1}, {left2,right2,array2,var2}}
where
\tleft1 = {a,c}
\tright1 = {b,d}
\tarray1 = {{1,0},{0,1}}
\tvar1 = x
and
\tleft1 = {1}
\tright1 = {1}
\tarray1 = {{1}}
\tvar1 = y

See also:
NCQuadraticRepresentationToNCPolynomial, NCPolynomial.";
NCQuadraticRepresentation::NotLinear = "Polynomial is not linear.";

Clear[NCQuadraticRepresentationToNCPolynomial];
NCQuadraticRepresentationToNCPolynomial::usage = "\
NCQuadraticRepresentationToNCPolynomial[args] takes the list args \
produced by NCQuadraticRepresentation and converts it back \
to an NCPolynomial.
NCQuadraticRepresentationToNCPolynomial[args, options] uses options.

The following options can be given:
\tCollect (True): controls whether the coefficients of the resulting \
NCPolynomial are collected to produce the minimal possible number \
of terms.
    
See also:
NCQuadraticRepresentation, NCPolynomial.";

Options[NCQuadraticRepresentationToNCPolynomial] = {
  Collect -> True
};

Begin[ "`Private`" ]

  (* NCQuadraticRepresentation *)

  NCQuadraticRepresentationAux;
  Clear[NCQuadraticRepresentationAux];
  NCQuadraticRepresentationAux[m_, terms_] := (
    Map[{#[[2]]**m[[1]], #[[1]]*#[[3]], m[[2]]**#[[4]]}&, terms] 
    ) /; Length[m] == 2;

  NCQuadraticRepresentationAux[m_, terms_] := (
    Map[{#[[2]]**m[[1,1]], #[[1]], m[[1,2]]**#[[3]]}&, terms] 
    ) /; Length[m] == 1;

  NCQuadraticRepresentation[p_NCPolynomial] := Module[
    {terms},

    If [!NCPQuadraticQ[p],
        Message[NCQuadraticRepresentation::NotQuadratic];
        Return[$Failed];
    ];

    terms = Flatten[
              MapThread[NCQuadraticRepresentationAux, 
                       {Keys[p[[2]]], Values[p[[2]]]}], 1];

    Print["terms = ", terms];

    left = terms[[All,1]];
    middle = terms[[All,2]];
    right = terms[[All,3]];

    Print["left = ", left];
    Print["middle = ", middle];
    Print["right = ", right];
      
    rightBasis = Merge[Thread[right -> Range[1, Length[right]]],
                      Identity];
    rightMatrix = 
       SparseArray[
         Thread[
           Flatten[Apply[List, 
                         MapIndexed[Thread[#1 -> First[#2]]&, 
                                    Values[rightBasis]], {2}], 1] -> 1]];

    rightBasis = Keys[rightBasis];

    Print["rightBasis = ", rightBasis];
    Print["rightMatrix = ", Normal[rightMatrix]];
    Print["rightMatrix . basis = ", rightMatrix . Keys[rightBasis]];

    leftBasis = Merge[Thread[left -> Range[1, Length[left]]],
                      Identity];
    leftMatrix = 
       SparseArray[
         Thread[
           Flatten[Apply[List, 
                         MapIndexed[Thread[#1 -> First[#2]]&, 
                                    Values[leftBasis]], {2}], 1] -> 1]];
    leftBasis = Keys[leftBasis];
      
    Print["leftBasis = ", leftBasis];
    Print["leftMatrix = ", Normal[leftMatrix]];
    Print["leftMatrix . basis = ", leftMatrix . leftBasis];

    middleMatrix = 
      SparseArray[
         MapIndexed[({First[#2],First[#2]} -> #1)&, middle]];
      
    Print["middleMatrix = ", Normal[middleMatrix]];

    middleMatrix = MatMult[Transpose[leftMatrix], middleMatrix, rightMatrix];
  
    Print[{leftBasis, middleMatrix, rightBasis}];
      
  ];


  (* NCQuadraticRepresentationToNCPolynomial *)

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
  
  Clear[NCQuadraticRepresentationToNCPolynomialAux];
  NCQuadraticRepresentationToNCPolynomialAux[{{},{},F_,var_}, 
                      collect_] := 
     Return[{{},{},var}];

  NCQuadraticRepresentationToNCPolynomialAux[{left_,right_,F_,var_},
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

  NCQuadraticRepresentationToNCPolynomial[sylv_, 
                      opts:OptionsPattern[{}]] := Module[
    {options, collect, m0, rules, vars},

    (* process options *)

    options = Flatten[{opts}];

    collect = Collect
	    /. options
	    /. Options[NCQuadraticRepresentationToNCPolynomial, Collect];
      
    m0 = First[sylv];
    vars = sylv[[2;;,4]];
                          
    (* Collect polynomial *)

    rules = Map[NCQuadraticRepresentationToNCPolynomialAux[#,collect]&,
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

  NCOldQuadraticRepresentation[f_?MatrixQ, 
                            var_?MatrixQ] := Module[
     {exp, leftBasis, rightBasis,
      p, q, r, s, F},

     exp = ExpandNonCommutativeMultiply[f];
     {r, s} = Dimensions[exp, 2];

     exp = Map[NCOldQuadraticRepresentation[exp, #] &, var, {2}];

     leftBasis = Union[Flatten[Part[exp, All, All, 1]]];
     rightBasis = Union[Flatten[Part[exp, All, All, 2]]];

     NCDebug[2, r, s, exp];

     Return[
      {leftBasis, rightBasis, Map[GrowRepresentation[
          {leftBasis, rightBasis}, {r, s}, #] &, exp, {2}], var}
      ];

     ];

  NCOldQuadraticRepresentation[f_, var_?MatrixQ] :=
    NCOldQuadraticRepresentation[{{f}}, var];

  NCOldQuadraticRepresentation[f_?MatrixQ, var_Symbol] := Module[
     {exp, leftBasis, rightBasis,
      p, q, r, s, F},

     exp = Map[NCOldQuadraticRepresentation[#, var] &, f, {2}];
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
