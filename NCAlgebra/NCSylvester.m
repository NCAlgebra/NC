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
      NCSylvesterRepresentationToNCPolynomial,
      NCSylvesterCollectOnVars];

Get["NCSylvester.usage"];

Options[NCSylvesterRepresentationToNCPolynomial] = {
  Collect -> True
};

Begin[ "`Private`" ]

  (* NCSylvesterRepresentation *)

  Clear[NCSylvesterRepresentationAux];
  NCSylvesterRepresentationAux[poly_Association, 
                               var_Symbol] := Module[
    {exp, coeff, left, right, leftBasis, rightBasis,
     i, j, p, q, F},

    (* Quick return if independent of var *)
    If [!KeyExistsQ[poly, {var}] || (exp = poly[{var}]) === {}
        ,
        Return[{{},{},SparseArray[{}, {0, 0}],var}];
    ];

    (* Print["exp = ", exp]; *)

    {coeff, left, right} = Transpose[exp];
    leftBasis = Union[Flatten[left]];
    rightBasis = Union[Flatten[right]];

    (*                                   
    Print["coeff = ", coeff];
    Print["leftBasis = ", leftBasis];
    Print["rightBasis = ", rightBasis];
                                   
    Print["left = ", left];
    Print["right = ", right];
    *)

    If [ MatrixQ[left[[1]]] || MatrixQ[right[[1]]]
        ,
         
         (* Matrix Polynomial *)
         
         r = Length[left[[1]]];
         s = Length[right[[1,1]]];

         (*
         Print["r = ", r];
         Print["s = ", s];
         *)

         (* Determine indices *)
                      
         i = r*(Map[Flatten[Map[(Position[leftBasis,#,1])&,#]]&,left,{2}]-2);
         j = s*(Map[Flatten[Map[(Position[rightBasis,#,1])&,#]]&,right,{2}]-2);

         (* 
         Print["i = ", i];
         Print["j = ", j];
         *)

         i = Map[Max, MapIndexed[(#1 + #2[[2]])&, i, {3}], {1}];
         j = Map[Max, MapIndexed[(#1 + #2[[3]])&, j, {3}], {1}];

         (*
         Print["i = ", i];
         Print["j = ", j];
         *)
         
         (* Drop 0 from basis *)
         leftBasis = Rest[leftBasis];
         rightBasis = Rest[rightBasis];
         
        ,
         
         (* Scalar Polynomial *)
         
         r = 1;
         s = 1;

         (* Determine indices *)
                      
         i = Flatten[Map[Position[leftBasis, #, 1] &, left]];
         j = Flatten[Map[Position[rightBasis, #, 1] &, right]];

         (*
         Print["i = ", i];
         Print["j = ", j];
         *)
         
    ];

    (* Assemble F *)
    F = SparseArray[
           MapThread[({#2, #3} -> #1) &, 
                     {coeff, i, j}], 
             {r*Length[leftBasis], s*Length[rightBasis]}];

    (* Print["F = ", Normal[F]]; *)
         
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

  
  (* NCSylvesterCollectOnVar *)
  
  Clear[NCSylvesterGrowRepresentation];
  NCSylvesterGrowRepresentation[
    {leftBasis_, rightBasis_},
    {r_, s_},
    {left_, right_, F_, var_}
    ] := Module[
      {p, q, FF},

      p = Length[leftBasis];
      q = Length[rightBasis];

      (*
      Print["r = ", r];
      Print["s = ", s];
      Print["p = ", p];
      Print["q = ", q];
      Print["leftBasis = ", leftBasis];
      Print["rightBasis = ", rightBasis];
      Print["left = ", left];
      Print["right = ", right];
      Print["F = ", F];
      Print["var = ", var];
      *)

      If[p + q == 0, 
        Return[{{}}];
      ];

      FF = If [Length[rightBasis] === Length[right],
        F
       ,
        F.KroneckerProduct[
          Part[SparseArray[{i_, i_} -> 1, {q, q}], 
           Flatten[Map[Position[rightBasis, #, 1] &, right]], All],
          SparseArray[{i_, i_} -> 1, {s, s}]
          ]
        ];

      (* Print["FF = ", FF]; *)

      If [Length[leftBasis] =!= Length[left],
       FF =
         KroneckerProduct[
           Part[SparseArray[{i_, i_} -> 1, {p, p}], All, 
            Flatten[Map[Position[leftBasis, #, 1] &, left]]],
           SparseArray[{i_, i_} -> 1, {r, r}]
           ].FF;
       ];

      (* Print["FF = ", FF]; *)

      Return[FF];

  ];

  Clear[NCSylvesterCollectOnVarsAux];
  NCSylvesterCollectOnVarsAux[{s0_, slv__}, var_] := 
    Select[{slv}, (#[[4]] == var)&];

  NCSylvesterCollectOnVarsAux[{s0_, slv__}, var_?MatrixQ] := Module[
      {sylv = {slv}, pos, leftBasis, rightBasis, exp},
      
      {r, s} = Dimensions[s0];

      (* Retrieve representation *)
      pos = Map[Flatten, Map[Position[sylv[[All, 4]], #] &, var, {2}]];
      exp = Map[sylv[[#]]&, pos, {2}];

      leftBasis = Union[Flatten[sylv[[All, 1]]]];
      rightBasis = Union[Flatten[sylv[[All, 2]]]];

      (*
      Print["r = ", r];
      Print["s = ", s];
      Print["pos = ", pos];
      Print["exp = ", exp];
      Print["leftBasis = ", leftBasis];
      Print["rightBasis = ", rightBasis];
      *)

      Return[
        {leftBasis, rightBasis, 
         Map[NCSylvesterGrowRepresentation[
              {leftBasis, rightBasis}, {r, s}, #] &, exp, {2}],
         var}
      ];

  ];

  NCSylvesterCollectOnVars[sylv_, vars_] := 
      Prepend[Map[NCSylvesterCollectOnVarsAux[sylv,#]&, vars], sylv[[1]]];

  
End[]

EndPackage[]
