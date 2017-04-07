(* :Title: 	NCSDP.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	NCSDP` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCSDP`",
              "NCOptions`",
              "NCUtil`",
              "NCSelfAdjoint`",
              "NCPolynomial`",
              "NCSylvester`",
	      "PrimalDual`",
	      "NCDebug`",
	      "NCDot`",
	      "NonCommutativeMultiply`" ];

Clear[NCSDP,NCSDPDual,NCSDPForm,NCSDPDualForm];

Get["NCSDP.usage"];

NCSDP::errorInBlock = "Error in block # `1`.";
NCSDP::invalidParameters = "Invalid parameter: `1`.";
NCSDP::invalidData = "Problems substituting problem data `1`. Check expressions and dimension of the matrices.";
NCSDP::dimensionMismatch = "Dimension mismatch.";
NCSDP::incompleteDimensions = "Incomplete dimensions.";
NCSDP::costMismatch = "Dimension mismatch in objective function.";
NCSDP::usage = "NCSDP[constraint, vars, obj, data] converts list 'constraint' of NC polynomials and NC polynomial matrix inequalities that are linear in the unknowns listed in 'vars' into the semidefinite program with linear objective 'obj':\n\n max  <obj, vars>  s.t.  constraints \[LessEqual] 0.\n\nNCSDP[constraint, vars, data] converts problem into a feasibility semidefinite program.\nNCSDP uses the user supplied 'data' to set up the problem data.";

Begin[ "`Private`" ]

  (* NCSDP auxiliary functions *)

  Clear[tpAux];
  tpAux[x_?MatrixQ] := tpMat[x];
  tpAux[x_] := tp[x];
  
  Clear[DimensionsAux];
  DimensionsAux[exp_, False] := Dimensions[exp] /. {} -> -1;
  DimensionsAux[exp_, True] := Module[
    {dims, m, n},

    (* Compute dimensions *)
    dims = Map[Dimensions, exp, {2}] /. {} -> {-1,-1};

    NCDebug[2, dims];

    (* Consolidate m and n *)
    m = Part[dims, All, All, 1];
    m = Flatten[Map[ConsolidateDimensions, m]];
    n = Part[dims, All, All, 2];
    n = Flatten[Map[ConsolidateDimensions, Transpose[n]]];

    m = MapThread[Max, {m,n}];

    Return[m];

  ];

  Clear[ConsolidateDimensions];
  ConsolidateDimensions[dims_] := Module[
     {tmp},

     tmp = Union[dims];
     If[Length[tmp] > 1,
      tmp = DeleteCases[tmp, -1];
      ];
     If[Length[tmp] > 1,
      Message[NCSDP::dimensionMismatch];
      Return[$Failed]
      ];
     Return[Flatten[tmp]];
  ];

  Clear[LinearDataDimensionsAux1];
  LinearDataDimensionsAux1[dims_List,False] := Module[
     {tmp},

     NCDebug[4, ">> LinearDataDimensionsAux1"];

     tmp = Union[dims];
     If[Length[tmp] > 1,
      tmp = DeleteCases[tmp, {}];
      ];
     If[Length[tmp] > 1,
      Message[NCSDP::dimensionMismatch];
      Return[$Failed]
      ];

     NCDebug[4, "<< LinearDataDimensionsAux1"];

     Return[Flatten[tmp] /. {} -> {-1, -1}];
  ];
  LinearDataDimensionsAux1[dims_List,True] := Module[
     {tmp},

     NCDebug[4, ">> LinearDataDimensionsAux1"];

     tmp = dims /. {} -> {-1, -1};
     NCDebug[4, tmp];

     (* Consolidate dimensions *)
     tmp = Transpose[tmp, {4, 1, 2, 3}];
     NCDebug[4, tmp];

     tmp = Map[Flatten, Apply[ConsolidateDimensions[{##}]&, tmp, {3}], {2}];
     NCDebug[4, tmp];

     NCDebug[4, "<< LinearDataDimensionsAux1"];

     Return[tmp];
  ];

  Clear[LinearDataDimensionsAux2];
  LinearDataDimensionsAux2[{left_, right_, x_},False] :=
    {LinearDataDimensionsAux1[Map[Dimensions, left],False], 
     LinearDataDimensionsAux1[Map[Dimensions, right],False]};

  LinearDataDimensionsAux2[{left_, right_, x_},True] := 
    {LinearDataDimensionsAux1[Map[Dimensions, left, {3}],True], 
     LinearDataDimensionsAux1[Map[Dimensions, right, {3}],True]};

  Clear[LinearDataDimensionsBlockAux1];
  LinearDataDimensionsBlockAux1[{left_,right_}] := Module[
    {rs, mn},

    NCDebug[2, ">> LinearDataDimensionsBlockAux1"];

    NCDebug[2, left, right];

    rs = {Part[left, All, All, 1], Part[right, All, All, 2]};
    mn = {Flatten[Part[left, All, All, 2]], Flatten[Part[right, All, All, 1]]};
    NCDebug[2, rs, mn];

    mn = Flatten[ Map[ConsolidateDimensions, mn] ];
    NCDebug[2, mn];

    NCDebug[2, "<< LinearDataDimensionsBlockAux1"];

    Return[{mn, rs}];

  ];

  Clear[InferMNFromRSAux1];
  InferMNFromRSAux1[exp_, mn_, rs_, {i_, j_}] :=
    InferMNFromRSAux2[Part[exp, i, j], mn, rs, i, j];

  Clear[InferMNFromRSAux2];
  InferMNFromRSAux2[term_, mn_, rs_?MatrixQ, i_, j_] := Module[
    {ind, mmnn},

    (* j = 1 => 2 *)
    (* j = 2 => 3 *)
    ind = Union[Flatten[MapIndexed[ If[(#1!=0), #2[[j+1]], {}]&, term, {3} ]]];
    NCDebug[2, ind];

    If [ Length[ind] > 0, 

      mmnn = mn;
      mmnn[[i, j]] = Max[ mn[[i, j]], rs[[j, First[ind] ]] ];
      Return[ mmnn ];

      ,

      Return[ mn ];

    ];

  ];

  InferMNFromRSAux2[term_, mn_, rs_, i_, j_] := Module[
    {ind, mmnn},

    ind = Union[Flatten[MapIndexed[ If[(#1!=0), #2, {}]&, term ]]];
    NCDebug[2, ind];

    If [ Length[ind] > 0, 

      mmnn = mn;
      mmnn[[i, j]] = Max[ mn[[i, j]], rs[[j]] ];
      Return[ mmnn ];

      ,

      Return[ mn ];

    ];

  ];

  Clear[InferMNFromRS];
  InferMNFromRS[exp_, mn_, rs_] := Module[
    {ind, mmnn},

    (* Infer mn based on r and s *)
    ind = Position[ mn, -1 ];
    NCDebug[2, ind];

    Return[ If[ ind != {}, 

      mmnn = Map[InferMNFromRSAux1[exp, mn, rs, #]&, ind];
      NCDebug[2, mmnn];

      mmnn = MapThread[Max, mmnn, 2];
      NCDebug[2, mmnn];

      mmnn

      , 

      mn

    ]];
 
  ];

  Clear[LinearDataDimensionsAux3];
  LinearDataDimensionsAux3[exp_, False, index_] := Module[
     {dims, mn, rs, r, s},
   
     NCDebug[1, ">> LinearDataDimensionsAux3"];
   
     (* Dimensions are r x m x n x s *)
   
     Check[ 

       (* Calculate dimensions *)
       dims = Map[Flatten, Map[LinearDataDimensionsAux2[#,False]&, exp], {1}];
       NCDebug[2, dims];

       (* Gather m and n *)
       mn = Part[dims, All, {2, 3}];
   
       (* Gather r and s *)
       rs = Part[dims, All, {1, 4}];

       NCDebug[2, rs, mn];
   
       (* Consolidate rs *)
   
       rs = Map[Union[DeleteCases[#, -1]] &, 
          Transpose[rs]] /. {} -> {-1};
       NCDebug[2, rs];
   
       (* Check for consistency and flatten rs *)
  
       If[Or[ Map[Length[#] > 1 &, rs]],
        Message[NCSDP::dimensionMismatch];
        ];
       rs = Flatten[rs];
       NCDebug[2, rs];
   
       (* Complement dimensions: r == s *)
   
       If[rs[[1]] < 0, rs[[1]] = rs[[2]]];
       If[rs[[2]] < 0, rs[[2]] = rs[[1]]];
       NCDebug[2, rs];

       mn = InferMNFromRS[exp, mn, rs];

       ,

       Message[NCSDP::errorInBlock, index];

       , 

       NCSDP::dimensionMismatch

     ];
    
     NCDebug[1, "<< LinearDataDimensionsAux3"];
   
     Return[{mn, rs}];
   
   ];

  LinearDataDimensionsAux3[exp_, True, index_] := Module[
     {dims, mn, rs, r, s, ind},
   
     NCDebug[1, ">> LinearDataDimensionsAux3"];
   
     (* Dimensions are r x m x n x s *)
   
     (* Calculate dimensions *)
     dims = Map[LinearDataDimensionsBlockAux1, 
		Map[LinearDataDimensionsAux2[#,True]&, exp], {1}];
     NCDebug[2, dims];

     (* Gather m and n *)
     mn = Part[dims, All, 1];
 
     (* Gather r and s *)
     rs = Part[dims, All, 2];

     NCDebug[2, rs, mn];
   
     (* Consolidate rs *)
   
     r = Flatten[Map[ConsolidateDimensions, Transpose[Map[Flatten, Part[rs, All, 1], {1}]]]];
     s = Flatten[Map[ConsolidateDimensions, Transpose[Flatten[Part[rs, All, 2], 1]]]];
     NCDebug[2, r, s];
   
     (* Complement dimensions: r == s *)
     r = MapThread[ Max, {r, s}];
     s = r;
     rs = {r,s};
     NCDebug[2, rs];

     mn = InferMNFromRS[exp, mn, rs];
   
     NCDebug[1, "<< LinearDataDimensionsAux3"];
   
     Return[{mn, rs}];
   
   ];


  Clear[LinearDataDimensionsAux5];
  LinearDataDimensionsAux5[{{0}, {0}, v_}, varIndex_, mn_] := {-1, -1};
  LinearDataDimensionsAux5[{left_, right_, v_}, varIndex_, mn_] := mn[[v /. varIndex]];

  Clear[LinearDataDimensionsAux4];
  LinearDataDimensionsAux4[exp_, varIndex_, block_, mn_, {-1, -1}, cDim_] := Module[
     {rs},
   
     NCDebug[1, ">> LinearDataDimensionsAux4"];
   
     (* Infer rs *)
   
     rs = Map[LinearDataDimensionsAux5[#, varIndex, mn] &, exp];
     NCDebug[2, rs];
   
     (* Consolidate rs *)
     rs = Transpose[rs];
     NCDebug[2, rs];
   
     rs = Map[Union[DeleteCases[#, -1]] &, rs] /. {} -> {-1};
     NCDebug[2, rs];
   
     (* Check for consistency and flatten rs *)
   
     If[Or[ Map[Length[#] > 1 &, rs]],
      Message[NCSDP::dimensionMismatch];
      ];
   
     NCDebug[1, "<< LinearDataDimensionsAux4"];
   
     Return[Flatten[rs]];
  ];
  LinearDataDimensionsAux4[exp_, varIndex_, True, mn_, rs_, cDim_] := Module[
     {r,s,rrss},
   
     NCDebug[2, ">> LinearDataDimensionsAux4"];
   
     (* Infer rs from cDim *)
     r = s = Flatten[Map[ConsolidateDimensions, Transpose[Append[rs, cDim]]]];
     NCDebug[2, r, s];

     (* Fast return *)
     If [FreeQ[r, -1],
       Return[{r, s}];
     ];

     (* Infer based on mn *)
     rrss = MapThread[LinearDataDimensionsAux8[#1, #2, rs]&, {exp, mn}];
     NCDebug[2, rrss];

     (* Consolidate rrss *)
     rrss = Map[Flatten,Map[ConsolidateDimensions, Transpose[rrss, {3, 1, 2}], {2}]];
     NCDebug[2, rrss];

     r = s = Flatten[Map[ConsolidateDimensions, Transpose[rrss]]];
     NCDebug[2, r, s];

     Return[{r,s}];

  ];
  LinearDataDimensionsAux4[exp_, varIndex_, block_, mn_, rs_, cDim_] := Module[
     {rrss},
   
     NCDebug[2, ">> LinearDataDimensionsAux4"];

     (* Infer rs from cDim *)
     rrss = Flatten[Map[ConsolidateDimensions, Transpose[{rs, cDim}]]];
     NCDebug[2, rrss];

     Return[rrss];
  ];
  LinearDataDimensionsAux4[exp_, varIndex_, block_, mn_, rs_, -1] := rs;

  Clear[LinearDataDimensionsAux8];
  LinearDataDimensionsAux8[term_, mn_, rs_] := Module[
    {j, rrss, fun},

    NCDebug[2, term];
    rrss = rs;

    (* Try right terms (i = 2) *)

    j = Intersection[ 
            Flatten[Position[ rs[[2]], -1 ]],
            Union[Flatten[
              MapIndexed[If[(AtomQ[#1]&&#1!=0), #2[[3]], {}]&, term[[2]], {3}]
            ]]
    ];
    NCDebug[2, j];

(* BUG
    rrss[[1,j]] = 
      rrss[[2,j]] = ConsolidateDimensions[ Append[rs[[2,j]], mn[[2]]] ];
*)

    Map[ (rrss[[1,{#}]] = rrss[[2,{#}]] = 
          ConsolidateDimensions[ Append[rs[[2,{#}]], mn[[2]]] ] )&, j];
    NCDebug[2, rrss];

    (* Fast return *)
    If [FreeQ[rrss, -1],
       Return[rrss];
    ];

    (* Try left terms (i = 1) *)

    j = Intersection[ 
            Flatten[Position[ rs[[2]], -1 ]],
            Union[Flatten[
              MapIndexed[If[(AtomQ[#1]&&#1!=0), #2[[2]], {}]&, term[[1]], {3}]
            ]]
    ];
    NCDebug[2, j];

(* BUG
    rrss[[2,j]] = 
      rrss[[1,j]] = ConsolidateDimensions[ Append[rs[[1,j]], mn[[1]]] ];
*)
    Map[ (rrss[[2,{#}]] = rrss[[1,{#}]] = 
          ConsolidateDimensions[ Append[rs[[1,{#}]], mn[[1]]] ])&, j];
    NCDebug[2, rrss];

    Return[rrss];

  ];

  Clear[ConsolidateSymmetry];
  ConsolidateSymmetry[{-1, n_}] := {n,n};
  ConsolidateSymmetry[{m_, -1}] := {m,m};
  ConsolidateSymmetry[{m_, n_}] := {m,n};

  Clear[ConsolidateMN];
  ConsolidateMN[mn_, symVarsIndex_] := Module[
    {mmnn},

    NCDebug[2, ">> ConsolidateMN"];

    NCDebug[2, mn];

    (* Consolidate mn *)
    mmnn = Transpose[mn, {3, 1, 2}];
    NCDebug[2, mmnn];
  
    mmnn = Map[Union[DeleteCases[#, -1]] &, mmnn, {2}] /. {} -> {-1};
    NCDebug[2, mmnn];
  
    (* Check for consistency and flatten mn *)
  
    If[ Or @@ Flatten[Map[Length[#] > 1 &, mmnn, {2}]],
     Message[NCSDP::dimensionMismatch];
     ];
  
    mmnn = Map[Flatten, mmnn, {1}];
    NCDebug[2, mmnn];

    (* Check Symmetry *)

    mmnn = MapAt[ConsolidateSymmetry, mmnn, Map[List,symVarsIndex]];

    NCDebug[2, symVarsIndex];
    NCDebug[2, mmnn];

    NCDebug[2, "<< ConsolidateMN"];

    Return[ mmnn ];
  ];


  Clear[LinearDataDimensions];
  LinearDataDimensions[exp_, varIndex_, symVars_,
                       blockMatrixQ_, blockIndex_, 
                       cDims_, bDims_] := Module[
    {dims, mn, rs},
   
    NCDebug[1, "> LinearDataDimensions"];
  
    dims = MapThread[LinearDataDimensionsAux3, {exp, blockMatrixQ, blockIndex}];
    NCDebug[2, dims];
  
    (* Extract rs and consolidate mn *)
    rs = Part[dims, All, 2];
    NCDebug[2, rs];
  
    mn = ConsolidateMN[ Part[dims, All, 1], symVars /. varIndex ];
    NCDebug[2, mn];

    (* Resolve missing dimension in rs *)
    rs = MapThread[
           LinearDataDimensionsAux4[#1, varIndex, #2, mn, #3, #4]&, 
           {exp, blockMatrixQ, rs, cDims}
    ];
    NCDebug[2, rs];

    (* Resolve dimension in mn *)

    mn = ConsolidateMN[ MapThread[InferMNFromRS[#1, mn, #2]&, {exp, rs}], 
                        symVars /. varIndex ];
    NCDebug[2, mn];

    (* Consolidate mn with dimensions from b *)

    mn = ConsolidateMN[ {mn, bDims}, symVars /. varIndex ];
    NCDebug[2, mn];

    NCDebug[1, "< LinearDataDimensions"];
  
    Return[{mn, rs}];
  ];

  Clear[SparseIdentityMatrix];
  SparseIdentityMatrix[m_, n_] := SparseArray[{i_, i_} -> 1, {m, n}];

  Clear[BlowUpScalarsAux1];
  BlowUpScalarsAux1[exp_, m_List, n_] := 
    MapThread[BlowUpScalarsAux1[#1, #2, n, {1}]&, {exp, m}];
  BlowUpScalarsAux1[exp_, m_, n_List] :=
    {MapThread[BlowUpScalarsAux1[#1, m, #2, {0}]&, {Part[exp, 1], n}]};
  BlowUpScalarsAux1[exp_, m_, n_, level_:{0}] :=
    Replace[exp, x_?NumberQ -> Normal[x SparseIdentityMatrix[m, n]], level];

  Clear[BlowUpScalarsAux2];
  BlowUpScalarsAux2[exp_, {m_, n_}, True] := 
   MapIndexed[BlowUpScalarsAux2[#1, {m[[#2[[1]]]],n[[#2[[2]]]]}, False]&, exp, {2}];

  BlowUpScalarsAux2[exp_, {m_, n_}, False] :=
   Replace[exp, x_?NumberQ -> Normal[x SparseIdentityMatrix[m, n]]]

  Clear[BlowUpScalarsAux3];
  BlowUpScalarsAux3[{left_, right_, v_}, varIndex_, mn_, rs_] := Module[
    {i = v /. varIndex},
    {Map[BlowUpScalarsAux1[##, rs[[1]], mn[[i, 1]]]&, left],
     Map[BlowUpScalarsAux1[##, mn[[i, 2]], rs[[2]]]&, right]}
  ]

  Clear[BlowUpScalars];
  BlowUpScalars[exp_, varIndex_, mn_, rs_] := 
    Map[BlowUpScalarsAux3[#, varIndex, mn, rs] &, exp];

  Clear[ArrayFlattenAux];
  ArrayFlattenAux[exp_, True] := Map[ArrayFlatten[{#}]&, Map[ArrayFlatten, exp, {3}], {2}];
  ArrayFlattenAux[exp_, False] := Map[ArrayFlatten[{#}]&, exp, {2}];

  Clear[NCSylvesterToSylvesterAux];
  NCSylvesterToSylvesterAux[{var_} -> terms_] := Module[
      {tmp},
      
      NCDebug[2, terms];
      
      tmp = Map[{#[[1]] #[[2]], #[[3]]}&, terms];
      
      NCDebug[2, tmp];

      tmp = Append[Transpose[tmp], var];
      
      NCDebug[2, tmp];

      Return[tmp];
  ];
  
  Clear[NCSylvesterToSylvester];
  NCSylvesterToSylvester[exp_] := Module[
     {rules},
      
     rules = Normal[exp[[2]]];

     NCDebug[2, rules];
      
     Return[Prepend[Map[NCSylvesterToSylvesterAux, rules], exp[[1]] ]];
  ];
  
  NCSDP[exp_List, Vars_List, obj_:{}, data_List, 
        OptionsPattern[{DebugLevel -> 0, UserRules -> {}}]] := Module[
    {tmp, sylv, vars, symVars, 
     userRules,
     aa, bb, cc, 
     aDims, bbDims, ccDims, rs, mn, 
     varIndex, blockMatrixQ, blockIndex, debugLevel},
  
    (* Options *)
    debugLevel = OptionValue[DebugLevel];
    userRules = OptionValue[UserRules];

    SetOptions[NCDebug, DebugLevel -> debugLevel];

    (* Begin check parameters *)

    (* Check NC poly map *)
    tmp = Map[ArrayDepth, exp];
    If[ Max[tmp] > 2,

      tmp = Flatten[Position[tmp, _?(#>2&)]];
      Message[NCSDP::invalidParameters, "'exp' should be a list of NC polynomials or polynomial matrices. Entries number " <> ToString[tmp] <> " do not seem to be NC polynomials or NC polynomial matrices"];

      Return[{{$Failed, $Failed, $Failed}, $Failed}];
    ];

    (* Check variable list *)
    vars = Flatten[Vars];
    If [vars =!= Vars,

      Message[NCSDP::invalidParameters, "'vars' should be a list a list of symbols. It cannot contain sublist or matrices"];

      Return[{{$Failed, $Failed, $Failed}, $Failed}];

    ];

    (* Check data replacement rules *)
    tmp = Flatten[Position[data, Except[_Rule|_RuleDelayed], 1, Heads -> False]];
    If[ tmp =!= {},

      Message[NCSDP::invalidParameters, "'data' should be a list of rules. Entry(ies) number " <> ToString[tmp] <> " does not seem to be a rule"];

      Return[{{$Failed, $Failed, $Failed}, $Failed}];
    ];

    (* End check parameters *)

    (* Test and simplify symmetric terms *)
    Check[

      tmp = Map[NCSymmetricPart, exp];
      symVars = Intersection[Union[Flatten[tmp[[All,2]]]], vars];
      sylv = tmp[[All,1]];
        
      (* Ensure no tp[] of vars are present *)
      tmp = sylv /. Map[(tp[#] -> 0)&, vars];
      NCDebug[2, tmp];
      diff = sylv - tmp;
      NCDebug[2, diff];
      sylv = tmp + Map[tpAux, diff];
      NCDebug[2, sylv];
        
      , 
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
      ,
      NCSymmetricPart::notSymmetric
    ];
            
    NCDebug[2, sylv];
    NCDebug[2, symVars];
  
    (* Convert to Sylverster form *)
    Check[

      sylv = Map[NCToNCPolynomial[#, vars]&, sylv];
      NCDebug[2, sylv];
      sylv = Map[NCPToNCSylvester, sylv];
      NCDebug[2, sylv];
      sylv = Map[NCSylvesterToNCPolynomial[#,KeepZeros->True]&, sylv];
      NCDebug[2, sylv];
      sylv = Map[NCSylvesterToSylvester, sylv];
      , 
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
      ,
      NCSylvester::NotLinear
    ];
            
    NCDebug[2, sylv];
            
    blockMatrixQ = Map[MatrixQ, Part[sylv, All, 1]];
    blockIndex = Range[Length[sylv]];
    NCDebug[2, blockMatrixQ];

    (* Replace data and compute dimension of independent terms *)
    Check[
 
      cc = Map[NCReplaceData[#, data] &, -Normal[Part[sylv, All, 1]]];
      NCDebug[2, cc];

      ,

      Message[NCSDP::invalidData, "in constant term"];
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
      
    ];

    ccDims = MapThread[DimensionsAux, {cc, blockMatrixQ}];
    NCDebug[2, ccDims];
  
    (* Replace data and compute dimension of cost function *)

    Check[
 
      bb = If[ obj != {}, 
               Map[NCReplaceData[#, data] &, obj]
              ,
               0*vars
      ];
      NCDebug[2, bb];

      ,

      Message[NCSDP::invalidData, "in objective function"];
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
      
    ];

    (* Check dimensions *)
    If[ Length[bb] != Length[vars],
      Message[NCSDP::costMismatch];
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
    ];
            
    bbDims = Map[DimensionsAux[#, False]&, bb] /. -1 -> {-1, -1};
    NCDebug[2, bbDims];

    (* Replace data and compute dimension of linear terms *)
    Check[

      aa = Map[NCReplaceData[#, data] &, Part[sylv, All, 2 ;;]];
      NCDebug[2, aa];
  
      ,

      Message[NCSDP::invalidData, "in linear map"];
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
      
    ];

    (* Compute dimensions of linear terms *)
    
    varIndex = MapIndexed[#1 -> #2[[1]] &, vars];
    NCDebug[2, varIndex];

    Check[ 
      {mn, rs} = LinearDataDimensions[aa, varIndex, symVars,
                                      blockMatrixQ, blockIndex, 
                                      ccDims, bbDims];
      ,
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
      ,
      NCSDP::dimensionMismatch
    ];
  
    NCDebug[2, mn];
    NCDebug[2, rs];

    If [ !And[FreeQ[rs, -1], FreeQ[mn, -1]],
       Message[NCSDP::incompleteDimensions];
       Return[{{$Failed, $Failed, $Failed}, $Failed}];
    ];

    (* Blow up scalars *)
  
    aa = MapThread[BlowUpScalars[#1, varIndex, mn, #2]&, {aa, rs}];
    NCDebug[2, aa];

    aa = MapThread[ArrayFlattenAux[#1,#2]&, {aa, blockMatrixQ}];
    NCDebug[2, aa];

    cc = MapThread[BlowUpScalarsAux2, {cc, rs, blockMatrixQ}];
    NCDebug[2, cc];

    cc = MapThread[(If[#2, ArrayFlatten[#1], #1])&, {cc, blockMatrixQ}];

    bb = MapThread[BlowUpScalarsAux2[#1, #2, False]&, {bb, mn}];
    NCDebug[2, bb];
  
    Return[{{aa, bb, cc}, SymmetricVariables -> Sort[symVars/. varIndex]}];

  ];

  (* NCSDPDual auxiliary function *)
  
  Clear[NCSDPDualTransposeEntryAux];
  NCSDPDualTransposeEntryAux[{scl_, left_, right_}] := {scl, tpAux[left], tpAux[right]};
    
  Clear[NCSDPDualTransposeAux];
  NCSDPDualTransposeAux[entries_] := Map[NCSDPDualTransposeEntryAux, entries];

  Clear[NCSDPDualMatrixAux];
  NCSDPDualMatrixAux[entry_?MatrixQ, var_] := 
      Array[Subscript[var,##]&, Dimensions[entry]];
  NCSDPDualMatrixAux[entry_, var_] := var;
      
  Clear[NCSDPDualReplaceAux];
  NCSDPDualReplaceAux[entry_, dvar_, vars_] := Block[
    {dims = Dimensions[dvar]},
      
    Return[
      Map[({dvar} -> Lookup[entry, Key[{#}], 
                            If[MatrixQ[dvar], 
                               {{0, ConstantArray[0, {1,dims[[1]]}], 
                                    ConstantArray[0, {dims[[2]],1}]}}, 
                               {{0, 0, 0}}]
                            ])&, vars] ];
   ];

  NCSDPDual[exp_, Vars_, obj_List:{}, dualVars_List:{},
           OptionsPattern[{DebugLevel -> 0, DualSymbol -> "w"}]] := Module[
    {cc, bb, vars, varIndex, 
     dVars, dVarList, dSymVars,
     tmp, symVars, sylv, 
     debugLevel, dualSymbol},

    (* Options *)
    debugLevel = OptionValue[DebugLevel];
    dualSymbol = OptionValue[DualSymbol];

    SetOptions[NCDebug, DebugLevel -> debugLevel];

    NCDebug[2, obj, dualVars];
               
    (* Check variable list *)
    vars = Flatten[Vars];
    If [vars =!= Vars,

      Message[NCSDP::invalidParameters, "'vars' should be a list a list of symbols. It cannot contain sublist or matrices"];

      Return[{$Failed, $Failed, $Failed}];

    ];

    (* Test and simplify symmetric terms *)
    Check[

      tmp = Map[NCSymmetricPart, exp];
      symVars = Intersection[Union[Flatten[tmp[[All,2]]]], vars];
      sylv = tmp[[All,1]];
        
      (* Ensure no tp[] of vars are present *)
      tmp = sylv /. Map[(tp[#] -> 0)&, vars];
      diff = sylv - tmp;
      sylv = tmp + Map[tpAux, diff];
      NCDebug[2, tmp, diff, sylv];
        
      , 
      Return[{$Failed, $Failed, $Failed}];
      ,
      NCSymmetricPart::notSymmetric
    ];
            
    NCDebug[2, sylv, symVars];
  
    (* Convert to NCPolynomial *)
    sylv = Map[NCToNCPolynomial[#, vars]&, sylv];
    NCDebug[2, sylv];
      
    (* Non linear? *)
    If[ Not[And @@ Map[NCPLinearQ, sylv]],
        Return[{$Failed, $Failed, $Failed}];
    ];

    (* Index of variables *)
    varIndex = MapIndexed[#1 -> #2[[1]] &, vars];

    (* Create dual variables *)
    dVarList = If[ dualVars === {},
      Table[Symbol[ToString[dualSymbol] <> ToString[i]], {i, Length[sylv]}]
     ,
      If[ Length[dualVars] != Length[sylv], 
          Message[NCSDP::invalidParameters, 
                 "'dualVars' should have the same length as 'exp'"];
          Return[{$Failed, $Failed, $Failed}];
      ];
      dualVars
    ];
    SetNonCommutative[dVarList];

    dVars = MapThread[NCSDPDualMatrixAux[#1, #2]&, 
                      {Part[sylv, All, 1], dVarList}];
    NCDebug[2, varIndex, dVarList, dVars];

    (* Make symmetric *) 
    dVars = dVars /. (Subscript[x_,k_,l_] /; k < l :> tp[Subscript[x,l,k]]);
    NCDebug[2, dVars];

    (* Symmetric dual variables *)
    dSymVars = Flatten[Map[If[MatrixQ[#], Tr[#, List], #]&, dVars]];
    NCDebug[2, dSymVars];

    (* Independent terms *)
    cc = -Normal[Part[sylv, All, 1]];
    NCDebug[2, cc];

    (* Cost function *)
    bb = If[ obj != {}, 
             obj
            ,
             0*vars
    ];
    NCDebug[2, bb];
      
    (* Check dimensions *)
    If[ Length[bb] != Length[vars],
      Message[NCSDP::costMismatch];
      Return[{{$Failed, $Failed, $Failed}, $Failed}];
    ];

    (* Transponse mapping *)
    tmp = Map[Map[NCSDPDualTransposeAux, #[[2]]]&, sylv];
    NCDebug[2, tmp];
      
    (* Replace dual variables *)
    tmp = Transpose[MapThread[NCSDPDualReplaceAux[#1, #2, vars]&, 
                              {tmp, dVars}]];
    NCDebug[2, tmp];
      
    (* Transform into association *)
    tmp = Map[Association, tmp, {2}];
    NCDebug[2, tmp];

    (* Merge entries *)
    tmp = Map[Merge[#,(Join[Flatten[#,1]])&]&, tmp, {1}];
    NCDebug[2, tmp];

    (* Transform to NCPolynomial *)
    tmp = MapThread[NCPolynomial[#1, #2, dVars]&, {bb, tmp}];
    NCDebug[2, tmp];
      
    (* Transform back to NC *)
    tmp = Map[NCPolynomialToNC, tmp];
    NCDebug[2, tmp];
    
    (* Symmetrize entries *)
    ind = symVars /. varIndex;
    tmp[[ind]] = (tmp[[ind]] + Map[tpAux, tmp[[ind]]])/2;
    NCDebug[2, tmp];
  
    (* Symmetrize dual variables *)
    tmp = ExpandNonCommutativeMultiply[tmp /. Map[(tp[#] -> #)&, dSymVars]];
    NCDebug[2, tmp];
    
    (* Flatten *)
    tmp = Flatten[tmp, 2];
    NCDebug[2, tmp];
    
    Return[{tmp, dVars, -cc}];
      
  ];
  
  NCSDPForm[f_, vars_, obj_:{}] := Module[
    { objForm, constraintForm, rules, varRules },

    rules = {
       HoldPattern[tp[x_]] -> Superscript[x,"T"], 
       NonCommutativeMultiply -> Dot
    };
    varRules = Map[# -> Style[#, Bold]&, vars];
    constraintForm = ColumnForm[
      Map[If[MatrixQ[#], MatrixForm[#], #] <= 0 &, 
        (f /. rules /. varRules)
      ]
    ];

    objForm = If [ obj != {},
      DeleteCases[Transpose[{obj, vars}], {0,_}],
      obj
    ];

    If [ objForm != {},

      objForm = Plus @@ (
        MapThread[AngleBracket[#1, #2]&, 
                  Transpose[objForm]]
      ) /. AngleBracket[x_?Negative,y_] -> -AngleBracket[-x,y] /. varRules;

      DisplayForm[
         GridBox[{
           {UnderscriptBox["max", vars /. varRules], objForm},
           {"s.t.", constraintForm}},
           ColumnAlignments->{Right,Left}
         ]
      ]

     ,

      DisplayForm[
       GridBox[{
         {UnderscriptBox["find", vars /. varRules], "s.t.", 
         constraintForm} },
         ColumnAlignments->{Right,Right,Left}
       ]
      ]

    ]

  ];

  Clear[NCSDPDualFormAux1];
  NCSDPDualFormAux1[var_?MatrixQ] := 
    Map[(# -> Style[#, Bold])&, 
        NCGrabFunctions[var, var[[1,1]] /. f_[__] -> f]];
  NCSDPDualFormAux1[var_] := var -> Style[var, Bold];
  
  NCSDPDualForm[f_, vars_, obj_:{}] := Module[
    { objForm, constraintForm, rules, varRules },

    rules = {
       HoldPattern[tp[x_]] -> Superscript[x,"T"], 
       NonCommutativeMultiply -> Dot
    };
    varRules = Flatten[Map[NCSDPDualFormAux1, vars]];
      
    (* Print["vars = ", vars];
       Print["varRules = ", varRules]; *)
    constraintForm = ColumnForm[
      Join[
        Map[If[MatrixQ[#], MatrixForm[#], #] == 0 &, 
          (f /. rules /. varRules)
        ],
        Map[If[MatrixQ[#], MatrixForm[#], #] >= 0 &, 
          (vars /. rules /. varRules)
        ]
      ]
    ];

    objForm = If [ obj != {},
      DeleteCases[Transpose[{obj,vars}], {0,_}],
      obj
    ];

    (* Print["objForm = ", objForm]; *)
      
    objForm = Map[MatrixForm, objForm, {2}];
      
    (* Print["objForm = ", objForm]; *)
      
    If [ objForm != {},

      objForm = Plus @@ (
        MapThread[AngleBracket[#1, #2]&, 
                  Transpose[objForm]]
      ) /. AngleBracket[x_?Negative,y_] -> -AngleBracket[-x,y] 
        /. rules /.varRules;

      DisplayForm[
         GridBox[{
           {UnderscriptBox["max", Map[MatrixForm,vars] /. rules /. varRules], objForm},
           {"s.t.", constraintForm}},
           ColumnAlignments->{Right,Left}
         ]
      ]

     ,

      DisplayForm[
       GridBox[{
         {UnderscriptBox["find", vars /. varRules], "s.t.", 
         constraintForm} },
         ColumnAlignments->{Right,Right,Left}
       ]
      ]

    ]

  ];

End[]

EndPackage[]
