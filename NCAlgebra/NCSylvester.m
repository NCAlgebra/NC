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

Clear[NCSylvesterRepresentation];
NCSylvesterRepresentation::usage="\
NCSylvesterRepresentation[p] gives an expanded representation \
for the linear NCPolynomial p.
    
NCSylvesterRepresentation returns a list with the coefficients \
of the linear polynomial p where
\tthe first element is a the independent term,
and the remaining elements are lists with four elements:
\tthe first element is a list of right nc symbols;
\tthe second element is a list of right nc symbols;
\tthe third element is a numeric array;
\tthe fourth element is a variable.

Example:
\tp = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
\tNCSylvesterRepresentation[exp,x]
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
NCSylvesterRepresentationToNCPolynomial, NCPolynomial.";
NCSylvesterRepresentation::NotLinear = "Polynomial is not linear.";

Clear[NCSylvesterRepresentationToNCPolynomial];
NCSylvesterRepresentationToNCPolynomial::usage = "\
NCSylvesterRepresentationToNCPolynomial[args] takes the list args \
produced by NCSylvesterRepresentation and converts it back \
to an NCPolynomial.
NCSylvesterRepresentationToNCPolynomial[args, options] uses options.

The following options can be given:
\tCollect (True): controls whether the coefficients of the resulting \
NCPolynomial are collected to produce the minimal possible number \
of terms.
    
See also:
NCSylvesterRepresentation, NCPolynomial.";

Options[NCSylvesterRepresentationToNCPolynomial] = {
  Collect -> True
};

Clear[RepresentationToPoly];
RepresentationToPoly::usage="RepresentationToPoly[leftBasis, rightBasis, F, var] computes an NC polynomial given its expanded representation.";

Clear[RepresentationToSylvester];
RepresentationToSylvester::usage="RepresentationToSylvester[leftBasis, rightBasis, F, var] computes a Sylvester representation given an expanded representation of an NC polynomial.";

Clear[SylvesterToPoly];
SylvesterToPoly::usage="SylvesterToPoly[leftBasis, rightBasis, var] computes an NC polynomial given its Sylvester representation.";

Clear[NCLinearCollect];
NCLinearCollect::usage="NCLinearCollect[p, var] computes an NC polynomial given its Sylvester representation.";

Clear[NCPolyToSylvester];
NCPolyToSylvester::notLinear = "Expression is not linear on the variables.";
NCPolyToSylvester::usage="";

Clear[NCSylvesterDisplay];
NCSylvesterDisplay::usage="";

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
  
  (* Split factors into a list with products *)

  Clear[SplitFactors];
  SplitFactors[f_Symbol] := {f};
  SplitFactors[a_?CommutativeQ*f_Symbol] := {a*f};
  SplitFactors[NonCommutativeMultiply[f___]] := {f};
  SplitFactors[a_?CommutativeQ*NonCommutativeMultiply[f___]] := {a f};
  SplitFactors[f_Plus] := List @@ f;

  (* Split products involving a given variable into three list with 
     coefficient, left term and right term *)

  Clear[SplitVariable];
  SplitVariable[var_Symbol, var_Symbol] := {1, 1, 1};
  SplitVariable[a_?CommutativeQ*var_Symbol, var_Symbol] := {a, 1, 1};
  SplitVariable[
     HoldPattern[NonCommutativeMultiply[l___, var_Symbol, r___]], 
     var_Symbol] := {1, NonCommutativeMultiply[l], 
     NonCommutativeMultiply[r]};
  SplitVariable[
     a_?CommutativeQ*
      HoldPattern[NonCommutativeMultiply[l___, var_Symbol, r___]], 
     var_Symbol] := {a, NonCommutativeMultiply[l], 
     NonCommutativeMultiply[r]};


  (* Reconstruct polynomial starting from its expanded represetation *)

  RepresentationToPoly[left_, right_, F_, var_?MatrixQ] := Module[
    {pr, qs, r, s, p, q, FF},

    {pr, qs} = Dimensions[F[[1, 1]]];
    p = Length[left];
    q = Length[right];
    r = pr/p;
    s = qs/q;

    FF = Plus @@ (Plus @@ MapThread[Times, {F, var}, 2]);

    If [r === 1 && s === 1,
     Inner[NonCommutativeMultiply, left, 
      Inner[NonCommutativeMultiply, FF, right]
      ]
     ,
     MatMult[
      Transpose[KroneckerProduct[left, IdentityMatrix[r]]],
      MatMult[FF, KroneckerProduct[right, IdentityMatrix[s]]]
      ]
     ]

    ];

  RepresentationToPoly[left_, right_, F_, var_] := Module[
    {pr, qs, r, s, p, q},

    {pr, qs} = Dimensions[F];
    p = Length[left];
    q = Length[right];
    r = pr/p;
    s = qs/q;

    If [r === 1 && s === 1,
     Inner[NonCommutativeMultiply, left, 
      Inner[NonCommutativeMultiply, F var, right]
      ]
     ,
     MatMult[
      Transpose[KroneckerProduct[left, IdentityMatrix[r]]],
      MatMult[F var, 
       KroneckerProduct[right, IdentityMatrix[s]]]
      ]
     ]

    ];


  (* SylvesterFactorMultiply *)

  Clear[SylvesterFactorLeftMultiply];
  SylvesterFactorLeftMultiply[left_, l_, r_] :=  
    MatMult[Transpose[KroneckerProduct[left, IdentityMatrix[r]]], l]

  Clear[SylvesterFactorRightMultiply];
  SylvesterFactorRightMultiply[right_, u_, s_] :=
    MatMult[u, KroneckerProduct[right, IdentityMatrix[s]]];

  Clear[SylvesterFactorMultiply];
  SylvesterFactorMultiply[left_, right_, l_, u_, var_, r_, s_] := { 
    SylvesterFactorLeftMultiply[left, l, r],
    SylvesterFactorRightMultiply[right, u, s],
    var 
  };

  RepresentationToSylvester[left_, right_, {{}}, var_] := {{0}, {0}, var};

  RepresentationToSylvester[left_, right_, F_, var_?MatrixQ] := Module[
    {pr, qs, r, s, p, q, m, n, rank, ind},

    {pr, qs} = Dimensions[F[[1, 1]]];
    p = Length[left];
    q = Length[right];
    r = pr/p;
    s = qs/q;

    NCDebug[2, r, s];

    (* Factor matrix F *)
    {l,u} = GetLUMatrices @@ LUDecompositionWithCompletePivoting[ArrayFlatten[F]];
    rank = Part[ Dimensions[l], 2 ];

    NCDebug[2, Normal[l], Normal[u], rank];

    (* Partition factors *)
    l = Flatten[Partition[l, {pr, rank}], 1];
    u = Flatten[Partition[u, {rank ,qs}], 1];

    NCDebug[2, l, u];

    (* Compute left and right terms *)

    l = ArrayFlatten[{Map[ SylvesterFactorLeftMultiply[left, #, r]&, l]}];
    u = ArrayFlatten[Map[{SylvesterFactorRightMultiply[right, #, s]}&, u]];

    NCDebug[2, l, u];

    (* Rearrange terms *)
    {m, n} = Dimensions[var];

    NCDebug[2, m, n];

    ind = Flatten[Transpose[Partition[ Table[i, {i, m rank}], m]]];
    l = Flatten[ Partition[ l[[All, ind]], {r, m}], 1];

    NCDebug[2, ind, l];

    ind = Flatten[Transpose[Partition[ Table[i, {i, n rank}], n]]];
    u = Flatten[ Partition[ u[[ind, All]], {n, s}], 1];

    NCDebug[2, ind, u];

    Return[{l, u, var}];

  ];

  RepresentationToSylvester[left_, right_, F_, var_] := Module[
    {l, u, rank,
     pr, qs, r, s, p, q, FF},

    {pr, qs} = Dimensions[F];
    p = Length[left];
    q = Length[right];
    r = pr/p;
    s = qs/q;

    NCDebug[2, r, s];

    (* Factor matrix F *)
    {l,u} = GetLUMatrices @@ LUDecompositionWithCompletePivoting[F];
    rank = Part[ Dimensions[l], 2 ];

    {l, u, var} = SylvesterFactorMultiply[left, right, l, u, var, r, s];

    NCDebug[2, l, u];

    Return[ 
      If [ r === 1 && s === 1, 
         {Flatten[l, 1], Flatten[u, 1], var}
        ,
         { Flatten[Partition[l, {r, 1}], 1],
           Map[Flatten[#,1]&, Partition[u, {1, s}]], var }
      ]
    ];

  ];


  (* Reconstruct polynomial starting from its Sylvester represetation *)

  SylvesterToPoly[left_, right_, var_?MatrixQ] := Module[
    {r, s, p},

    p = Plus @@ MapThread[ MatMult[#1, var, #2]&, {left, right}];

    Return[ If [ Dimensions[p, 2] === {1, 1}, Part[p, 1, 1], p] ];

  ];

  SylvesterToPoly[{left__?MatrixQ}, {right__?MatrixQ}, var_] :=
    Plus @@ MapThread[ MatMult[#1, {{var}}, #2]&, {{left}, {right}}];

  SylvesterToPoly[left_, right_, var_] :=
    Plus @@ MapThread[ NonCommutativeMultiply[#1, var, #2]&, {left, right}];

  (* NCPolyToSylvester *)

  (* Handles polys in lists *)
  NCPolyToSylvester[p_List, v_] := Map[NCPolyToSylvester[#, v]&, p] /; Not[MatrixQ[p]];

  (* Handles matrix variables *)
  NCPolyToSylvester[p_, v_?MatrixQ] := Module[
    {lb, rb, F, l, r, var, rem, tpV, ruleTp, ruleInvTp},

    If [ And @@ Map[FreeQ[p, #]&, Flatten[tpMat[v]]], 

      (* Does not depend on transposes *)

      {lb, rb, F, var} = NCOldSylvesterRepresentation[p, v];
      {l, r, var} = RepresentationToSylvester[lb, rb, F, var];

      rem = p /. Map[(# -> 0)&, Flatten[v]];

      Return[{rem, {l, r, var}}];

    ,

      (* Expression depends on transposes *)

      (* Protect symbol in expression and call NCPolySylvester *)
      tpV = Map[Unique, v];
      Map[SetNonCommutative, tpV, {2}];

      ruleTp = MapThread[Rule, {Map[tp,Flatten[v]], Flatten[tpV]}];
      ruleInvTp = MapThread[Rule, {Flatten[tpV], Map[tp,Flatten[v]]}];

      Return[ NCPolyToSylvester[p /. ruleTp, {v, Transpose[tpV]}] /. ruleInvTp];

    ];

  ];

  (* Handles symbol variables *)
  NCPolyToSylvester[p_, v_Symbol] := Module[
    {lb, rb, F, l, r, var, rem, tpV},

    If [ FreeQ[p, tp[v]], 

      (* Expression does not depend on transposes *)

      {lb, rb, F, var} = NCOldSylvesterRepresentation[p, v];
      {l, r, var} = RepresentationToSylvester[lb, rb, F, var];

      (* Calculate remainder *)
      rem = p /. v -> 0;

      Return[{rem, {l, r, var}}];

     ,

      (* Expression depends on transposes *)

      (* Protect symbol in expression and call NCPolySylvester *)
      SetNonCommutative[tpV];

      Return[ NCPolyToSylvester[p /. tp[v] -> tpV, {v, tpV}] /. tpV -> tp[v] ];

    ];

  ];

  (* Handles list variables *)
  NCPolyToSylvester[p_, v_List] := Module[
    {sylv, rem, pos, dims, tmp},

    NCDebug[2, ">> NCPolyToSylvester"];

    sylv = Flatten[Map[Rest[NCPolyToSylvester[p, #]]&, v], 1];

    NCDebug[2, sylv];

    rem = p /. Map[(# -> 0)&, Flatten[v]];

    (* Check for linearity *)
    If[ Not[And @@ Map[FreeQ[Part[sylv, All, {1, 2}],#]&, v]],
      Message[NCPolyToSylvester::notLinear];
    ];

    pos = Position[sylv, {{0},{0},x_}, 1];
    NCDebug[2, pos, Depth[sylv]];

    NCDebug[2, Part[sylv, All, 1 ;; 2] ];
    NCDebug[2, Map[ArrayDepth, Part[sylv, All, 1 ;; 2], {3} ] ];
    NCDebug[2, Max[ Map[ArrayDepth, Part[sylv, All, 1 ;; 2], {3} ]] ];

    If [ pos != {} && Max[ Map[ArrayDepth, Part[sylv, All, 1 ;; 2], {3} ]] >= 2, 

      NCDebug[2, Max[ Map[ArrayDepth, Part[sylv, All, 1 ;; 2], {3} ]] ];

      (* Blow up zeros *)

      NCDebug[2, sylv];

      dims = Part[Map[Dimensions, sylv, {3}], All, {1,2}];
      NCDebug[2, dims];

      dims = First[DeleteCases[dims, {{{}},{{}}}]];
      NCDebug[2, dims];

      dims = Part[dims, All, 1];
      NCDebug[2, dims];

      dims = Map[{ConstantArray[0,{#[[1]],#[[2]]}]}&, dims];
      NCDebug[2, dims];

      sylv = MapAt[Replace[#,{{0},{0},x_} -> Append[dims,x]]&, sylv, pos];
      NCDebug[2, sylv];

    ];

    NCDebug[2, "<< NCPolyToSylvester"];

    Return[Prepend[sylv, rem]];

  ];

  (* NCSylvesterDisplay *)
  Clear[NCSylvesterDisplayTerm];
  NCSylvesterDisplayTerm[left_?MatrixQ, right_?MatrixQ, var_?MatrixQ] := 
    (MatrixForm[left] ** MatrixForm[var] ** MatrixForm[right]);

  NCSylvesterDisplayTerm[left_?MatrixQ, right_?MatrixQ, var_] := 
    (MatrixForm[left] ** var ** MatrixForm[right]);

  NCSylvesterDisplayTerm[left_, right_, var_] := (left ** var ** right);

  Clear[NCSylvesterDisplayAux];
  NCSylvesterDisplayAux[{left_List, right_List, var_}] := 
   Plus @@ MapThread[NCSylvesterDisplayTerm[#1,#2,var]&, {left, right}];

  NCSylvesterDisplayAux[exp_?MatrixQ] := MatrixForm[exp];

  NCSylvesterDisplayAux[exp_] := exp;

  NCSylvesterDisplay[sylv_] := Plus @@ Map[NCSylvesterDisplayAux, sylv];

  (* NCLinearCollect *)
  NCLinearCollect[p_, var_] := p;

End[]

EndPackage[]
