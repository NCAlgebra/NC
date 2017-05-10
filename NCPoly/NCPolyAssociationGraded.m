(*  NCPolyAssociationGraded.m                                              *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2014                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyAssociationGraded`",
              "NCPoly`" ];

(* All declarations from NCPoly` *)

Begin["`Private`"];

  (* NCPoly Constructor *)

  (* NULL MONOMIAL constructor *)
  NCPolyMonomial[{}, n_Integer] := 1;
  NCPolyMonomial[{}, {n__Integer}] := 1;

  (* DIGITS DEG MONOMIAL constructor *)
  NCPolyMonomial[s_List, n_Integer, opts:OptionsPattern[]] := 
    NCPoly[{n}, Association[NCFromDigits[s, n] -> 1], opts];

  (* DIGITS LEX MONOMIAL constructor *)
  NCPolyMonomial[s_List, {n__Integer}, opts:OptionsPattern[]] := 
    NCPoly[{n}, Association[NCFromDigits[s, {n}] -> 1], opts];

  (* RULE MONOMIAL constructors *)
  NCPolyMonomial[s_Rule, {n__Integer}, opts:OptionsPattern[]] := 
    NCPoly[
      {n}, 
      Association[NCFromDigits[NCIntegerDigits[s[[1]], Flatten[{n}]], {n}] -> s[[2]]]
      opts
  ];

  NCPolyMonomial[s_Rule, n_Integer, opts:OptionsPattern[]] := 
    NCPolyMonomial[s, {n}, opts];

  NCPolyMonomial[s_Rule, {var__List}, opts:OptionsPattern[]] :=
    NCPolyMonomial[s, Map[Length,{var}], opts];

  NCPolyMonomial[s_Rule, var_List, opts:OptionsPattern[]] :=
    NCPolyMonomial[s, {var}, opts];

  (* LEX constructor *)
  NCPolyMonomial[monomials_List, {var__List}, opts:OptionsPattern[]] := 
    NCPolyMonomial[
       Flatten[Map[(Position[Flatten[{var}], #]-1)&, monomials]]
      ,
       Map[Length,{var}]
      ,
       opts
    ];

  (* DEG constructor *)
  NCPolyMonomial[monomials_List, var_List, opts:OptionsPattern[]] := 
    NCPolyMonomial[monomials, {var}, opts];

  (* NCPoly Constructor *)
  
  (* NCPolyVarsToIntegers *)
  NCPolyVarsToIntegers[{Vars__Integer}] := Return[{Vars}];

  NCPolyVarsToIntegers[Vars_List] := 
    NCPolyVarsToIntegers[Map[List, Vars]];
  
  NCPolyVarsToIntegers[{Vars__List}] := Block[
    {vars = {Vars}},
      
    (* list of variables *)
      
    If[ Cases[Map[Part[#, 0] &, Level[vars, {2}]], 
                  Except[Symbol|Subscript]] =!= {},
        Message[NCPoly::InvalidList];
        Return[$Failed];
    ];
      
    (* repeat variables *)
    If[ Length[Flatten[vars]] != Length[Union[Flatten[vars]]],
        Message[NCPoly::InvalidList];
        Return[$Failed];
    ];
      
    (* convert to integers *)
    Return[Map[Length, vars]];
      
  ];
  
  NCPoly[{}, {}, var_List, OptionsPattern[]] := 0;

  NCPoly[coeff_List, monomials_List, Vars_List, 
         opts:OptionsPattern[]] := Module[
    {vars, varnames, varRule, tpVars, ajVars, options = {}},

    (* check monomial and coefficient size *)
    If[ Length[coeff] =!= Length[monomials],
        Message[NCPoly::SizeMismatch];
        Return[$Failed];
    ];

    (* list of variables *)
    Check[ vars = NCPolyVarsToIntegers[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
    varnames = Flatten[Vars];
    varRule = Flatten[MapIndexed[{#1 -> #2[[1]]-1} &, varnames]];

    tpVars = OptionValue[TransposePairs];
    If[ tpVars =!= {},
        AppendTo[options,
                 TransposePairs -> (tpVars /. varRule)];
    ];

    ajVars = OptionValue[SelfAdjointPairs];
    If[ ajVars =!= {},
        AppendTo[options,
                 SelfAdjointPairs -> (ajVars /. varRule)];
    ];
             
    (* 
    Print["tpVars = ", tpVars];
    Print["ajVars = ", ajVars];
    Print["varRule = ", varRule];
    Print["options = ", options];
    *)
      
    Check[
      NCPolyPack[
        NCPoly[
            vars
           ,
            KeySort[
              Merge[
                Thread[ 
                  NCFromDigits[
                    Map[ NCMonomialToDigits[#, varnames]&, monomials]
                   ,vars
                  ] ->  coeff
                ]
               ,
                Total
              ]
            ]
           , 
            Sequence @@ options
        ]
      ]
     ,
      $Failed
     ,
      NCMonomialToDigits::InvalidSymbol
    ]
  ];

  NCPoly[r_, Association[], OptionsPattern[]] := 0;

  (* NCPolyGetOptions *)
  NCPolyGetOptions[p_NCPoly] := Drop[List @@ p, 2];
  
  Clear[NCPolyGetOptionsSequence];
  NCPolyGetOptionsSequence[p_NCPoly] := Sequence @@ Drop[List @@ p, 2];
  
  (* errors *)
  
  NCPoly[r_,s_,OptionsPattern[]] := (Message[NCPoly::NotPolynomial]; 
    $Failed) /; Or[ Head[r] =!= List, Depth[r] =!= 2,
                   Head[s] =!= Association ];

  (*
  NCPoly[r___,opt:OptionsPattern[]] := (Print["opts =", opts]; Message[NCPoly::NotPolynomial]; 
    $Failed) /; Length[{r}] != 2;
  *)

  (* NCPolyConvert *)
  NCPolyConvert[{p__NCPoly}, Vars_List] := 
    Map[NCPolyConvert[#, Vars]&, {p}];
      
  NCPolyConvert[p_NCPoly, Vars_List] := Module[
    {vars},
      
    (* list of variables *)
    Check[ vars = NCPolyVarsToIntegers[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
      
    If[p[[1]] == Vars,
       (* same poly's, return *)
       Return[p];
    ];
    
    (* Need to convert *)
    Return[
      NCPoly[ vars
             , 
              KeySort[ KeyMap[ NCFromDigits[#, vars] &,
                               KeyMap[NCIntegerDigits[#, p[[1]]] &, 
                                      p[[2]] ] ] ]
             ,
              NCPolyGetOptionsSequence[p]
      ]
    ];
      
  ];
  
  (* NCPoly Utilities *)

  NCPolyPack[p_NCPoly] := 
    NCPoly[ p[[1]], 
            DeleteCases[p[[2]], 0], 
            NCPolyGetOptionsSequence[p] ];

  NCPolyMonomialQ[p_NCPoly] := (Length[Part[p, 2]] === 1);
  NCPolyMonomialQ[p_] := False;

  NCPolyNumberOfVariables[p_NCPoly] := Total[p[[1]]];
  NCPolyNumberOfTerms[p_NCPoly] := Length[p[[2]]];

  NCPolyDegree[p_NCPoly] := Max @@ Map[Total[Drop[#, -1]]&, Keys[p[[2]]]];

  NCPolyPartialDegree[p_NCPoly] := 
    Apply[Max, Transpose[NCPolyMonomialDegree[p]], {1}];
  
  NCPolyMonomialDegree[p_NCPoly] := 
    Range[0, Total[p[[1]]]-1] /.
      Map[Append[#, _Integer -> 0] &,
          Apply[Rule,
                Map[Tally[NCIntegerDigits[#, p[[1]]]]&, Keys[p[[2]]]],
                {2}]];
      
  NCPolyGetCoefficients[p_NCPoly] := Values[p[[2]]];

  NCPolyCoefficient[p_NCPoly, m_?NCPolyMonomialQ] :=
    Part[Lookup[p[[2]], {First[Keys[m[[2]]]]}, 0], 1];

  NCPolyGetIntegers[p_NCPoly] := Keys[p[[2]]];

  NCPolyGetDigits[p_NCPoly] := 
    NCIntegerDigits[NCPolyGetIntegers[p], p[[1]]];

  NCPolyLeadingMonomial[{p__NCPoly}, i_Integer:1] := 
    Map[NCPolyLeadingMonomial[#, i]&, {p}];

  NCPolyLeadingMonomial[p_NCPoly] := NCPolyLeadingMonomial[p, 1];

  NCPolyLeadingMonomial[p_NCPoly, 1] := 
    NCPoly[ p[[1]], 
            KeyTake[p[[2]], {Last[Keys[p[[2]]]]}],
            NCPolyGetOptionsSequence[p] ];

  NCPolyLeadingMonomial[p_NCPoly, i_Integer] := Block[
    {key},
    Quiet[
      Check[ 
         key = Part[Keys[p[[2]]],-i];
         NCPoly[p[[1]], KeyTake[p[[2]], {key}], NCPolyGetOptionsSequence[p] ]
        ,$Failed
        ,Part::partw
      ]
    ]
  ];
    
  NCPolyLeadingTerm[{p__NCPoly}, i_Integer:1] := 
    Map[NCPolyLeadingTerm[#, i]&, {p}];

  NCPolyLeadingTerm[p_NCPoly] := NCPolyLeadingTerm[p, 1];

  NCPolyLeadingTerm[p_NCPoly, 1] := Block[
    {key = Last[Keys[p[[2]]]]},
    Rule[
      NCFromDigits[NCIntegerDigits[key, p[[1]]], Total[p[[1]]]],
      p[[2]][key]
    ]
  ];

  NCPolyLeadingTerm[p_NCPoly, i_Integer] := Block[
    {key},
    Quiet[
      Check[ 
        key = Part[Keys[p[[2]]],-i];
        Rule[
          NCFromDigits[NCIntegerDigits[key, p[[1]]], Total[p[[1]]]],
          p[[2]][key]
        ]
       ,$Failed
       ,Part::partw
      ]
    ]
  ];

  NCPolyNormalize[{p__NCPoly}] := Map[NCPolyNormalize, {p}];

  NCPolyNormalize[p_NCPoly] := Times[p, 1/Part[NCPolyLeadingTerm[p], 2]];

  NCPolyTogether[p_NCPoly] := MapAt[Together, p, {2}];

  (* NCPolyTerms *)
  NCPolyTermsOfDegree[p_NCPoly, degree_List] := Block[
      {d = Total[degree], tmp},

      (* First pick the monomials with the right degree *)
      tmp = NCPolyTermsOfTotalDegree[p, d];
      
      (* then select by monomial *)
      Return[tmp];
  ];
  
  NCPolyTermsOfTotalDegree[p_NCPoly, degree_Integer] := 
    NCPoly[p[[1]], 
           p[[2]][[Flatten[Position[Map[Total[Drop[#, -1]]&, 
                                        Keys[p[[2]]]], degree]]]]
           NCPolyGetOptionsSequence[p] ];

  (* NCPolyQuadraticTerms *)
  Clear[NCPolyQuadraticTermsAux];
  NCPolyQuadraticTermsAux[p_NCPoly] := Block[
    {even, digits, halfDigits, sameDigits,
     opts = NCPolyGetOptions[p],
     tpRules, ajRules, index},

    (* ajRules *)
    If[ (ajRules = OptionValue[NCPoly, opts, SelfAdjointPairs]) =!= {}
       ,
        ajRules = Apply[Rule, 
                        Join[ajRules, Map[Reverse, ajRules]], 
                        {1}];
    ];
      
    (* tpRules *)
    If[ (tpRules = OptionValue[NCPoly, opts, TransposePairs]) =!= {}
       ,
        ajRules = Join[ajRules, Apply[Rule, 
                                      Join[tpRules, Map[Reverse, tpRules]], 
                                      {1}] ];
    ];
      
    (* even terms *)
    even = KeySelect[p[[2]], EvenQ[Total[Drop[#, -1]]] &];
      
    (* split digits *)
    digits = Map[NCIntegerDigits[#,p[[1]]]&, Keys[even]];
    halfDigits = Map[{Take[#, Length[#]/2], 
                      Reverse[Take[#, {Length[#]/2+1, -1}]] /. ajRules}&, 
                     digits];
      
    (* select for symmetry *)
    sameDigits = Apply[Equal, halfDigits, {1}];  
    index = Flatten[Position[sameDigits,True]];

    (*
    Print["even = ", even];
    Print["digits = ", digits];
    Print["halfDigits = ", halfDigits];
    Print["sameDigits = ", sameDigits];
    Print["index = ", index];
    *)
      
    Return[{even[[index]], halfDigits[[index, 1]]}];
      
  ];
  
  NCPolyQuadraticTerms[p_NCPoly] := 
    NCPoly[ p[[1]],
            NCPolyQuadraticTermsAux[p][[1]],
            NCPolyGetOptionsSequence[p] ];
    
  (* NCPolyQuadraticChipset *)

  NCPolyQuadraticChipset[p_NCPoly] := Block[
    {even, halfDigits, chipset},
    
    (* Get square half-digits *)
    {even, halfDigits} = NCPolyQuadraticTermsAux[p];
    
    (* generate chipset *)
    chipset = Union[Join @@ Map[Table[Take[#, i], {i, Length[#]}]&, halfDigits]];
    If[ MemberQ[halfDigits, {}],
        PrependTo[chipset, {}];
    ];
      
    chipset = Map[NCFromDigits[#, p[[1]]]&, chipset];
      
    (*
    Print["even = ", even];
    Print["halfDigits = ", halfDigits];
    Print["chipset = ", chipset];
    *)
    
    Return[NCPoly[ p[[1]],
                   KeySort[<|Thread[chipset -> 1]|>],
                   NCPolyGetOptionsSequence[p] ] ];
  ];
      
  (* Display Order *)

  Clear[NCPolyDisplayOrderAux];
  NCPolyDisplayOrderAux[a_, b__, symbol_String] :=
    Join[{a, symbol}, NCPolyDisplayOrderAux[b, symbol]];

  NCPolyDisplayOrderAux[a_, symbol_String] := {a};

  NCPolyDisplayOrder[vars_List] := 
    DisplayForm[
      RowBox[Flatten[(NCPolyDisplayOrderAux[##, "\[LessLess] "]&) @@
              Apply[NCPolyDisplayOrderAux[##,"<"]&,  vars, 1]]]];

  (* NCPolyReverseMonomials *)
  (* DOES IT NEED SORTING? *)
  NCPolyReverseMonomials[p_NCPoly] :=
    NCPoly[ p[[1]], 
            KeySort[KeyMap[NCIntegerReverse[#, p[[1]]]&, p[[2]]]],
            NCPolyGetOptionsSequence[p] ];
    
  (* NCPolyTranspose *)
  NCPolyTranspose[p_NCPoly] := NCPolyReverseMonomials[p] /; Length[p] == 2;

  NCPolyTranspose[p_NCPoly] := Block[
    {tmp = p,
     opts = NCPolyGetOptions[p],
     tpRules },
      
    (* Transpose variables *)
    Return[
      If[ (tpRules = OptionValue[NCPoly, opts, TransposePairs]) =!= {}
         ,
          tpRules = Apply[Rule, 
                          Join[tpRules, Map[Reverse, tpRules]], 
                          {1}];
          
          (* Print["tpRules = ", tpRules]; *)
          
          NCPoly[ p[[1]],
                  KeySort[KeyMap[NCFromDigits[Reverse[NCIntegerDigits[#, p[[1]]]] /. tpRules, p[[1]]]&, p[[2]]]],
                  NCPolyGetOptionsSequence[p] ]
         ,
          NCPolyReverseMonomials[p]
      ]
    ];

  ];

  (* NCPolyAdjoint *)
  NCPolyAdjoint[p_NCPoly] := NCPolyReverseMonomials[p] /; Length[p] == 2;

  NCPolyAdjoint[p_NCPoly] := Block[
    {tmp = p,
     opts = NCPolyGetOptions[p],
     tpRules, ajRules },
      
    (* ajRules *)
    If[ (ajRules = OptionValue[NCPoly, opts, SelfAdjointPairs]) =!= {}
       ,
        ajRules = Apply[Rule, 
                        Join[ajRules, Map[Reverse, ajRules]], 
                        {1}];
    ];
      
    (* tpRules *)
    If[ (tpRules = OptionValue[NCPoly, opts, TransposePairs]) =!= {}
       ,
        ajRules = Join[ajRules, Apply[Rule, 
                                      Join[tpRules, Map[Reverse, tpRules]], 
                                      {1}] ];
    ];
      
    (* Adjoint variables? *)
    Return[
      If[ ajRules =!= {}
         ,
          NCPoly[ p[[1]],
                  KeySort[Map[Conjugate, KeyMap[NCFromDigits[Reverse[NCIntegerDigits[#, p[[1]]]] /. ajRules, p[[1]]]&, p[[2]]]]],
                  NCPolyGetOptionsSequence[p] ]
         ,
          NCPolyReverseMonomials[p]
      ]
    ];
       
  ];
  
  (* NCPoly Operators *)

  (* Times *)
  NCPoly /: Times[r_, s_NCPoly] := NCPoly[s[[1]], r s[[2]], 
                                          NCPolyGetOptionsSequence[s] ];

  (* Plus *)
  NCPolySum[r_NCPoly, s_NCPoly] := NCPoly[
    r[[1]], 
    KeySort[DeleteCases[Merge[{r[[2]], s[[2]]}, Total], 0]],
    NCPolyGetOptionsSequence[s]
  ] /; s[[1]] === r[[1]];

  (* Product *)
  NCPolyProduct[r_NCPoly, s_NCPoly] := Block[
    { digits, coeff, sets,
      rdigits, sdigits, 
      sdegree, loffset,
      n = r[[1]], 
      nvars, nsets },

    nvars = Total[n];
    nsets = Length[n];

    (*
      Print["nvars = ", nvars];
      Print["nsets = ", nsets];

      Print["r = ", r];
      Print["s = ", s];
    *)

    (* Compute coefficients *)
    coeff = Flatten[
              Outer[
                Times, 
                NCPolyGetCoefficients[r], 
                NCPolyGetCoefficients[s], 
                1
              ]
            ];

    (*
      Print["coeff = ", coeff];
    *)

    (* Compute monomials *)
    sdegree = Map[Total[Drop[#, -1]] &, Keys[s[[2]]]];
    loffset = Map[nvars^(#)&, sdegree];

    rdigits = NCPolyGetIntegers[r];
    sdigits = NCPolyGetIntegers[s];

    (*
      Print["sdegree = ", sdegree];
      Print["loffset = ", loffset];

      Print["rdigits = ", rdigits];
      Print["sdigits = ", sdigits];
    *)

    sets = Flatten[ 
                Outer[
                  Plus, 
                  rdigits[[All, 1 ;; nsets]], 
                  sdigits[[All, 1 ;; nsets]], 
                  1
                ]
               ,1
              ];

    digits = Flatten[Transpose[{rdigits[[All, nsets+1]]}] . {loffset} 
           + ConstantArray[1,{Length[rdigits],1}] . {sdigits[[All, nsets+1]]}];

    (*
      Print["digits = ", digits];
      Print["sets = ", sets];
    *)

    digits = Join[sets, Transpose[{digits}], 2];

    (*
      Print["digits = ", digits];
    *)

    (* OLD CODE
      digits = NCFromDigits[ 
              Flatten[ 
                Outer[
                  Join, 
                  NCPolyGetDigits[r], 
                  NCPolyGetDigits[s], 
                  1
                ]
               ,1
              ],
              r[[1]]
            ];
      Print["digits = ", digits];
    *)

    (* Build new polynomial *) 

    (* Left/Right term is monomial *)
    If [ NCPolyMonomialQ[r] || NCPolyMonomialQ[s],

      (* No repeats! *)  
      Return[NCPoly[n, 
                    KeySort[Association[MapThread[Rule,{digits, coeff}]]],
                    NCPolyGetOptionsSequence[r] ]
      ];
      ,

      (* Handle repeats with Merge *) 
      Return[NCPoly[n, 
                    KeySort[Merge[MapThread[Rule,{digits, coeff}], Total]],
                    NCPolyGetOptionsSequence[r] ]
      ];

    ];

  ] /; s[[1]] === r[[1]];

  (* Division *)

  NCPolyReduce[f_NCPoly, g_NCPoly, complete_:False, debugLevel_:0] := Block[
    { maxIterations = 10, 
      n = f[[1]], leadG, leadR, r, rr, q, qi, j, k },

    (* f = p1 g p2 + r *)

    If[ debugLevel > 2,
      Print["* NCPolyReduce"];
      Print["f = ", NCPolyDisplay[f]];
      Print["g = ", NCPolyDisplay[g]];
      Print["f = ", FullForm[f]];
      Print["g = ", FullForm[g]];
    ];

    k = 0;
    r = f;
    q = {};
    j = 1;
    leadG = NCPolyLeadingTerm[g];
    If[ debugLevel > 1, Print["leadG = ", leadG]; ];
    While[ k < maxIterations,
           k++;
           leadR = NCPolyLeadingTerm[r, j];
           If[ debugLevel > 1, Print["leadR = ", leadR]; ];
           If [ leadR === $Failed,
                (* does not divide, terminate *)
                If[ debugLevel > 1, Print["does not divide, terminate"]; ];
                Break[];
           ];
           qi = NCPolyDivideLeading[leadR, leadG, n];
           If[ debugLevel > 1, Print["qi = ", qi]; ];
           If [ qi === {}
               ,
                If[ complete
                   ,
                    (* does not divide, try next term *)
                    If[ debugLevel > 1, Print["does not divide, try next term"]; ];
                    j++;
                    If[ debugLevel > 1, Print["j = ", j]; ];
                    Continue[];
                   ,
                    (* if not complete, does not divide, terminate *)
                    If[ debugLevel > 1, Print["does not divide, terminate, even if not complete"]; ];
                    Break[];
                ];
               ,
                (* divide, update quotient and residual *)
                AppendTo[q, qi];
                If[ debugLevel > 1, Print["q = ", q]; ];
                r -= NCPoly`Private`QuotientExpand[qi, g];
                If[ debugLevel > 1, Print["r = ", NCPolyDisplay[r]]; Print["j = ", j]; ];
           ];
           If [ r === 0,
                (* no reminder, terminate *)
                If[ debugLevel > 1, Print["no reminder, terminate"]; ];
                Break[];
           ];
    ];

    Return[{q, r}]

  ] /; f[[1]] === g[[1]];

  (* NCPolyCoefficientArray *)
      
  Clear[DegreeToIndex];
  DegreeToIndex[d_, n_] := (n^d - 1)/(n - 1);
      
  Clear[IndexToDegree];
  IndexToDegree[m_, n_] := Floor[Log[(m - 1/(1 - n)) (-1 + n)] / Log[n]];
  
  NCPolyCoefficientArray[p_NCPoly, dd_:-1] := Module[
    {n = Total[p[[1]]], d = NCPolyDegree[p]},

    (* degree *)
    d = If[dd >= 0,
           If[d > dd, 
              Message[NCPolyCoefficientArray::InvalidDegree];
              Return[$Failed];
           ];
           dd, d];
    
    (* calculate coefficients *)
    Return[
      SparseArray[
        Normal[
          KeyMap[(DegreeToIndex[Total[Drop[#,-1]],n]+Last[#]+1)&,
                 p[[2]]]
        ],{DegreeToIndex[d+1,n]}]
    ];
  ];
  
  NCPolyCoefficientArray[{ps__NCPoly}] := Block[
    {d},
    d = Max[Map[NCPolyDegree, {ps}]];
    Return[SparseArray[Map[NCPolyCoefficientArray[#,d]&, {ps}]]];
  ] /; (Count[Unitize[Max /@ {ps}[[All,1]] - Min /@ {ps}[[All,1]]], 0] == Length[{ps}]);

  Clear[IndexToDegree];
  IndexToDegree[m_, n_] := Floor[Log[n, (m - 1/(1 - n)) (-1 + n)]];

  NCPolyFromCoefficientArray[m_SparseArray?MatrixQ, vars_List] := 
    Map[NCPolyFromCoefficientArray[#,vars]&, m];

  NCPolyFromCoefficientArray[m_SparseArray, Vars_List] := Module[
    {index, degree, coeff, n, 
     rules = Drop[ArrayRules[m], -1],
     vars},

    (* list of variables *)
    Check[ vars = NCPolyVarsToIntegers[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
    n = Total[vars];

    If[ DegreeToIndex[IndexToDegree[Length[m], n], n] != Length[m]
       , 
        Message[NCPolyFromCoefficientArray::InvalidDegree];
        Return[$Failed];
    ];
      
    degree = Apply[IndexToDegree[# - 1, n] &, 
                   rules[[All, 1]], {1}];
    index = Map[DegreeToIndex[#, n] &, degree];
    coeff = Transpose[{degree, Flatten[rules[[All,1]]] - index - 1}];

    (*
    Print["m = ", Normal[m]];
    Print["Vars = ", Vars];
    Print["vars = ", vars];
    Print["Depth[m] = ", Depth[m]];
    Print["n = ", n];
    Print["rules = ", rules];
    Print["degree = ", degree];
    Print["index = ", index];
    Print["coeff = ", coeff];
    *)
    
    Return[
      NCPolyConvert[
          NCPoly[{n}, <|Thread[coeff -> rules[[All,2]]]|>],
          Vars
      ]
    ];
  ];
  
  (* From GramMatrix *)

  NCPolyFromGramMatrix[m_List?MatrixQ, Vars_List] := 
    NCPolyFromGramMatrix[SparseArray[m], Vars];
  
  NCPolyFromGramMatrix[m_SparseArray, Vars_List] := Module[
    {n, vars,
     index, degree, digits, rindex,
     rules = Drop[ArrayRules[m], -1],
     loffset, coeff},

    (* list of variables *)
    Check[ vars = NCPolyVarsToIntegers[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
    n = Total[vars];

    degree = Map[IndexToDegree[# - 1, n] &, 
                   rules[[All, 1]], {2}];
    index = Map[DegreeToIndex[#, n] &, degree, {2}];
    index = rules[[All,1]] - index - 1;

    (* flip digits on the right *)
    rindex = NCFromDigits[
               Map[Reverse,
                   Map[NCIntegerDigits[#,n]&, 
                       Transpose[{degree[[All,2]], index[[All,2]]}]]
               ], n][[All,2]];

    (* offset digits on the left *)
    loffset = Map[n^(#)&, degree[[All,2]] ];
    digits = index[[All,1]] * loffset + rindex;
    coeff = Transpose[{Map[Total, degree], digits}];
      
    (*
    Print["m = ", Normal[m]];
    Print["n = ", n];
    Print["Vars = ", Vars];
    Print["vars = ", vars];
    Print["rules = ", rules];
    Print["degree = ", degree];
    Print["index = ", index];
    Print["digits = ", digits];
    Print["loffset = ", loffset];
    Print["coeff = ", coeff];
    *)
    
    Return[
      NCPolyConvert[
          NCPoly[{n}, Merge[Thread[coeff -> rules[[All,2]]], Total]],
          Vars
      ]
    ];
      
  ];
  
End[];
EndPackage[]
