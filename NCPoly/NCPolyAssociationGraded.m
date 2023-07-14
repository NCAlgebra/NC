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
  (* MAURICIO: BUG IN NCPolyMonomial
  NCPolyMonomial[monomials_List, {var__List}, opts:OptionsPattern[]] := 
    NCPolyMonomial[
       Flatten[Map[(Position[Flatten[{var}], #]-1)&, monomials]]
      ,
       Map[Length,{var}]
      ,
       opts
    ];

  ( * DEG constructor * )
  NCPolyMonomial[monomials_List, var_List, opts:OptionsPattern[]] := 
    NCPolyMonomial[monomials, {var}, opts];
  *)

  NCPolyMonomial[monomials_List, var_List, opts:OptionsPattern[]] := 
    NCPolyMonomial[
       Flatten[Map[(Position[Flatten[var], #]-1)&, monomials]]
      ,
       NCPolyVarsToIntegers[var]
      ,
       opts
    ];
       

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
    Print["varnames = ", varnames];
    Print["monomials = ", monomials];
    Print["tpVars = ", tpVars];
    Print["ajVars = ", ajVars];
    Print["varRule = ", varRule];
    Print["options = ", options];
    Print["vars = ", vars];
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
                    Map[NCMonomialToDigits[#, varnames]&, monomials]
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

  NCPoly[r_,s_,OptionsPattern[]] := (
    Message[NCPoly::NotPolynomial];
    Print["r = ", r, ", s = ", s];
    $Failed
  ) /; (Head[r] =!= List || Depth[r] =!= 2 || Head[s] =!= Association);

  (* NCPolyConvert *)
  NCPolyConvert[{p__NCPoly}, Vars_List] := 
    Map[NCPolyConvert[#, Vars]&, {p}];
      
  NCPolyConvert[p_NCPoly, Vars_List] := p /; p[[1]] === Vars;

  NCPolyConvert[p_NCPoly, Vars_List] := Module[
    {vars},
      
    (* list of variables *)
    Check[ vars = NCPolyVarsToIntegers[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
      
    (* convert *)
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
            DeleteCases[p[[2]], _?NCPolyPossibleZeroQ],
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

  NCPolyLeadingTerm[NCPoly[{n_Integer}, terms_, opts___], 1] := Block[
    {key = Last[Keys[terms]]},
    Rule[
      key,
      terms[key]
    ]
  ];

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

  NCPolyTermsToList[p_NCPoly] :=
    Map[NCPoly[p[[1]], #, p[[3]]] &, KeyValueMap[<|Rule@##|> &, p[[2]]]] /; Length[p] == 3;

  NCPolyTermsToList[p_NCPoly] :=
    Map[NCPoly[p[[1]], #] &, KeyValueMap[<|Rule@##|> &, p[[2]]]];

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

    (* Is it self adjoint? *) 
    If[ !NCPolySelfAdjointQ[p],
	Message[NCPoly::NotSelfAdjoint];
    ];
    
    (* Get square half-digits *)
    {even, halfDigits} = NCPolyQuadraticTermsAux[p];

    (* MAURICIO: FEB 2022 NOT SURE WHY THE COMPLICATION
    ( * generate chipset * )
    chipset = Union[Join @@ Map[Table[Take[#, i], {i, Length[#]}]&, halfDigits]];
    If[ MemberQ[halfDigits, {}],
        PrependTo[chipset, {}];
    ];
    chipset = Map[NCFromDigits[#, p[[1]]]&, chipset];
    *)
    
    If[ MemberQ[halfDigits, {}],
        PrependTo[halfDigits, {}];
    ];
    chipset = Map[NCFromDigits[#, p[[1]]]&, halfDigits];
      
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

  (* Chop *)
  NCPoly /: Chop[r_NCPoly, args___] :=
    NCPoly[r[[1]],
	   KeySort[DeleteCases[Map[Chop[#,args]&, r[[2]]], _?NCPolyPossibleZeroQ]],
           NCPolyGetOptionsSequence[r]
    ];

  (* Times *)
  NCPoly /: Times[r_, s_NCPoly] := NCPoly[s[[1]], r s[[2]], 
                                          NCPolyGetOptionsSequence[s] ];

  (* Plus *)
  (* MAURICIO: FEB 2022: NCPolyPossibleZeroQ is needed to handle borderline zeros *)
  NCPolySum[r_NCPoly, s__NCPoly] := NCPoly[
    r[[1]], 
    KeySort[DeleteCases[Merge[{r, s}[[All,2]], Total], _?NCPolyPossibleZeroQ]],
    NCPolyGetOptionsSequence[r]
  ] /; {s}[[1,1]] === r[[1]];

  (*
     CheapSum can lead to coefficients that are not simplified;
     It also does not check for consistency;
     It is used in NCPolyReduce in which the leading monomials
     are automatically checked for zeroness
  *)
  Clear[NCPolyCheapSum];
  NCPolyCheapSum[r_NCPoly, s_NCPoly] := NCPoly[
    r[[1]], 
    KeySort[Merge[{r[[2]], s[[2]]}, Total]],
    NCPolyGetOptionsSequence[r]
  ];

  (* Product *)

  NCPolyMonomialProduct[r_, s_] := Block[
    {n = r[[1]], nvars, nsets, sdigits, rdigits, sdegree, loffset},

    (* Compute monomials *)
    nvars = Total[n];
    nsets = Length[n];
    sdigits = Keys[s[[2]]][[1]];
    rdigits = Keys[r[[2]]][[1]];
    sdegree = Total[Drop[sdigits, -1]];
    loffset = nvars^(sdegree);

    (*
    Print["nvars = ", nvars];
    Print["nsets = ", nsets];

    Print["sdegree = ", sdegree];
    Print["loffset = ", loffset];

    Print["rdigits = ", rdigits];
    Print["sdigits = ", sdigits];
    *)

    digits = Append[rdigits[[1 ;; nsets]] + sdigits[[1 ;; nsets]],
		    rdigits[[nsets+1]] * loffset + sdigits[[nsets+1]]];
    coeff = r[[2]][[1]] * s[[2]][[1]];
    
    Return[NCPoly[n, <|digits -> coeff|>, NCPolyGetOptionsSequence[r]]];
	   
  ] /; (s[[1]] === r[[1]] && ((Length[s]==Length[r]==2) || s[[3]] === r[[3]]));

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

  NCPolyReduceWithQuotient[f_NCPoly, g_NCPoly, j_Integer:1,
			   options:OptionsPattern[NCPolyReduce]] := Block[
    { maxIterations =
      OptionValue[NCPolyReduce, {options}, MaxIterationsFactor] * NCPolyNumberOfTerms[f],
      debugLevel = OptionValue[NCPolyReduce, {options}, DebugLevel],
      returnQuotient = OptionValue[NCPolyReduce, {options}, ReturnQuotient],
      zeroTest = OptionValue[NCPolyReduce, {options}, ZeroTest],
      n = f[[1]], leadG, leadR, r, rr, q, qi, k, needToPack = False },

    (* f = p1 g p2 + r *)

    If[ debugLevel > 2,
	Print["* NCPolyReduce"];
	If[ debugLevel > 3,
	    Print["options = ", {options}];
	    Print["debugLevel = ", debugLevel];
	    Print["returnQuotient = ", returnQuotient];
	    Print["maxIterations = ", maxIterations];
        ];
	Print["f = ", NCPolyDisplay[f]];
	Print["g = ", NCPolyDisplay[g]];
	Print["f = ", f];
	Print["g = ", g];
	Print["j = ", j];
    ];

    k = 0;
    r = f;
    q = {};
    leadG = NCPolyLeadingTerm[g];
    If[ debugLevel > 1, Print["leadG = ", leadG]; ];
    While[ k < maxIterations,
           k++;
           If[ debugLevel > 1, Print["k = ", k]; ];
           leadR = NCPolyLeadingTerm[r, j];
           If[ debugLevel > 1, Print["leadR = ", leadR]; ];
           If [ leadR === $Failed,
                (* does not divide, terminate *)
                If[ debugLevel > 1, Print["does not divide, terminate"]; ];
                Break[];
           ];
	   If[ zeroTest[leadR[[2]]],
               (* Leading term can be zero because NCPolyCheapSum does not simplify *)
               If[ debugLevel > 1, Print["leading term is zero"]; ];
	       (* then drop leading monomial *)
	       r = NCPoly[r[[1]], Drop[r[[2]],{-j}], NCPolyGetOptionsSequence[r]];
               If[ debugLevel > 0,
		   Print["r has " <> ToString[NCPolyNumberOfTerms[r]] <> " terms"]; ];
               If[ debugLevel > 2, Print["r = ", r]; ];
	       If [ r === 0
		   ,
                    (* no reminder, terminate *)
                    If[ debugLevel > 1, Print["no reminder, terminate"]; ];
                    Break[];
		   ,
                    (* get next leading term *)
                    Continue[];
	       ];
           ];
           qi = NCPolyDivideLeading[leadR, leadG, n];
           If[ debugLevel > 1, Print["qi = ", qi]; ];
           If [ qi === {}
               ,
                (* does not divide, terminate *)
                If[ debugLevel > 1,
		    Print["does not divide, terminate, even if not complete"]; ];
                Break[];
               ,
                (* divide, update quotient and residual *)
                If[ returnQuotient, AppendTo[q, qi] ];
                If[ debugLevel > 1, Print["q = ", q]; ];
                (* r -= NCPoly`Private`QuotientExpand[qi, g]; *)
                (* r = NCPolyCheapSum[r, -NCPoly`Private`QuotientExpand[qi, g]]; *)
                r = NCPolyCheapSum[r, -NCPoly`Private`QuotientExpand[qi, g]];
                needToPack = True;
                If[ debugLevel > 2, Print["r = ", r]; Print["r = ", NCPolyDisplay[r]]; Print["j = ", j]; ];
           ];
           (* MAURICIO: OK to test with exact 0 here because
              QuotientExpand will apply NCPolyPossibleZeroQ *)
           If [ r === 0, 
                (* no reminder, terminate *)
                If[ debugLevel > 1, Print["no reminder, terminate"]; ];
                Break[];
           ];
    ];

    (* Issue warning if max iterations exceeded *)
    If[k >= maxIterations, Message[NCPolyReduce::MaxIter]];

    (* Pack poly if needed *)
    If[!complete && Head[r] === NCPoly && needToPack,
       r = NCPolyPack[r]];

    Return[If[returnQuotient, {q, r}, r]];

  ] /; f[[1]] === g[[1]];

  (* NCPolyCoefficientArray *)
      
  Clear[DegreeToIndex];
  DegreeToIndex[d_, n_] := (n^d - 1)/(n - 1);
      
  Clear[IndexToDegree];
  IndexToDegree[m_, n_] := Floor[Log[n, (1/(1 - n) - m)*(1 - n)]];
  
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

    (*
    Print["m = ", Normal[m]];
    Print["n = ", n];
    Print["Vars = ", Vars];
    Print["vars = ", vars];
    Print["rules = ", rules];
     *)
    
    degree = Map[IndexToDegree[# - 1, n] &, rules[[All, 1]], {2}];
    index = Map[DegreeToIndex[#, n] &, degree, {2}];
    index = rules[[All,1]] - index - 1;
    
    (* flip digits on the right *)
    rindex = NCFromDigits[
               Map[Reverse,
		   Map[NCIntegerDigits[#,n]&, 
		       Transpose[{degree[[All,2]], index[[All, 2]]}]]
		   ], n][[All,2]];
    
    (* offset digits on the left *)
    loffset = Map[n^(#)&, degree[[All,2]] ];
    digits = index[[All,1]] * loffset + rindex;
    coeff = Transpose[{Map[Total, degree], digits}];
    
    (*
    Print["degree = ", degree];
    Print["index = ", index];
    Print["rindex = ", rindex];
    Print["rows = ", rows];
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

  (* NCPolyFromGramMatrixFactors *)
  NCPolyFromGramMatrixFactors[l_List?MatrixQ, r_List?MatrixQ, Vars_List] := 
    NCPolyFromGramMatrixFactors[SparseArray[l], SparseArray[r], Vars];
  
  NCPolyFromGramMatrixFactors[l_SparseArray, r_SparseArray, Vars_List] := Module[
    {n, vars,
     index, degree, digits, rindex, rpoly, lpoly,
     lrules = Drop[ArrayRules[l], -1],
     rrules = Drop[ArrayRules[r], -1],
     coeff},

    (* list of variables *)
    Check[ vars = NCPolyVarsToIntegers[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
    n = Total[vars];

    (*
    Print["n = ", n];
    Print["Vars = ", Vars];
    Print["vars = ", vars];
    Print["rrules = ", rrules];
    Print["lrules = ", lrules];
    *)
    
    (* right product *)

    (*
    index = rrules[[All, 1, 2]];
    degree = Map[IndexToDegree[# - 1, n]&, index];
    *)

    degree = Map[IndexToDegree[# - 1, n] &, rrules[[All, 1, 2]]];
    index = Map[DegreeToIndex[#, n] &, degree];
    index = rrules[[All, 1, 2]] - index - 1;

    (*
    Print["index = ", index];
    Print["degree = ", degree];
    Print["rows = ", rrules[[All, 1, 1]]];
    *)
    
    (* flip digits on the right *)
    rindex = NCFromDigits[
	       Map[Reverse,
		   Map[NCIntegerDigits[#,n]&, 
		       Transpose[{degree, index}]]
		   ], n][[All,2]];

    (*
    Print["rindex = ", rindex];
    *)

    coeff = Transpose[{degree, rindex}];
    rpoly = Map[
	      NCPoly[{n}, Association[#]]&,
	      Values[
		KeySort[
 	          Merge[ Thread[rrules[[All, 1, 1]] -> Thread[coeff -> rrules[[All,2]]]]
		        ,
		         Join
		  ]
	        ]
	      ]
	    ];

    (*
    Print["degree = ", degree];
    Print["index = ", index];
    Print["rindex = ", rindex];
    Print["coeff = ", coeff];
    Print["rpoly = ", rpoly];
    *)

    (*
    index = lrules[[All, 1, 1]];
    degree = Map[IndexToDegree[# - 1, n]&, index];
    *)

    degree = Map[IndexToDegree[# - 1, n] &, lrules[[All, 1, 1]]];
    index = Map[DegreeToIndex[#, n] &, degree];
    index = lrules[[All, 1, 1]] - index - 1;
    
    coeff = Transpose[{degree, index}];
    lpoly = Map[
	      NCPoly[{n}, Merge[#, Total]]&,
	      Values[
		KeySort[
  	          Merge[ Thread[lrules[[All, 1, 2]] -> Thread[coeff -> lrules[[All, 2]]]]
		        ,
		         Join
	          ]
		]
	      ]
	    ];
    
    (*
    Print["degree = ", degree];
    Print["index = ", index];
    Print["coeff = ", coeff];
    Print["lpoly = ", lpoly];
    *)

    Return[{NCPolyConvert[lpoly, Vars], NCPolyConvert[rpoly, Vars]}];
	
  ];

  Clear[NCPolyVeroneseAux1];
    NCPolyVeroneseAux1[digits_, deg_, hasOne_] :=
    Table[{digits[[;; i]], 
           Reverse@digits[[i + 1 ;;]]}, 
          {i, Min[Length[digits]-If[hasOne, 0, 1],Ceiling[deg/2]]}];

  NCPolyVeronese[degree_Integer, vars_, options:OptionsPattern[NCPoly]] := Block[
    {Vars = NCPolyVarsToIntegers[vars], nvars = Total[Vars]},
    Return[
      NCPolyConvert[
        NCPoly[{nvars}, <|Thread[
			    Flatten[
			      Table[
			        Table[{j, i}, {i, 0, nvars^j - 1}],
				{j, 0, degree}
			      ], 1
			    ] -> 1]|>, options], Vars]];
  ];

  NCPolyVeronese[p_NCPoly] := Module[
    {digits, deg, base, hasOne},

    digits = NCPolyGetDigits[p];
    deg = Max[Map[Length, digits]];
    base = p[[1]];
    hasOne = MemberQ[digits, {}];

    (*
    Print["digits = ", digits];
    Print["deg = ", deg];
    Print["hasOne = ", hasOne];
    Print["base = ", base];
     *)
    
    (* split digits *)
    digits = Union[Flatten[Map[NCPolyVeroneseAux1[##,deg,hasOne]&, digits], 1][[All,1]]];

    (* add constant *)
    If[ hasOne, PrependTo[digits, {}]];
    
    (* Print["digits = ", digits]; *)
    
    Return[NCPoly[base, <|Thread[Map[NCFromDigits[#, base]&, digits] -> 1]|>]];
  ];

  NCPolyMomentMatrix[degree_Integer, vars_, options:OptionsPattern[NCPoly]] := Module[
    {ver = NCPolyVeronese[Ceiling[degree/2], vars, options], Vars},
    Vars = NCPolyVarsToIntegers[vars];
    ver = NCPolyTermsToList[NCPolyConvert[ver, {Total[Vars]}]];
    Return[
      Map[NCPolyConvert[#, Vars]&,
        Outer[NCPolyMonomialProduct, ver, Map[NCPolyReverseMonomials, ver]],
        {2}
      ]
    ];
  ];

  Clear[NCPolyMomentMatrixAux1];
  NCPolyMomentMatrixAux1[digits_, vars_, halfDegree_] :=
    Null /; Length[digits] > 2 halfDegree;
  NCPolyMomentMatrixAux1[digits_, vars_, halfDegree_] := Module[
    {min = Max[Length[digits] - halfDegree, 0], max},
    max = Length[digits] - min;
    Return[
      Table[
        {NCFromDigits[digits[[;; i]], vars],
	 NCFromDigits[Reverse@digits[[i + 1 ;;]], vars]}, {i, min, max}]
    ];
  ];

  Clear[NCPolyMomentMatrixAux2]
  NCPolyMomentMatrixAux2[nvars_, degree_, index_] :=
    (nvars^degree - 1)/(nvars - 1) + index;

  NCPolyMomentMatrix[p_NCPoly] :=
    NCPolyMomentMatrix[p, NCPolyDegree[p]];

  NCPolyMomentMatrix[p_NCPoly, veronese_NCPoly:Null] :=
    NCPolyMomentMatrix[p, NCPolyDegree[p], veronese];

  NCPolyMomentMatrix[p_NCPoly, degree_Integer, veronese_NCPoly:Null] := Module[
    {halfDegree, nvars, ver, digits, verIndex, halfPolys, index, m},
    
    halfDegree = Ceiling[degree/2];
    nvars = Total[p[[1]]];

    (* Calculate dimension *)
    m = NCPolyMomentMatrixAux2[nvars, halfDegree+1, 0];
    
    (* Calculate digits of the veronese *)
    verIndex = If[ veronese =!= Null
	          ,
		   DeleteCases[
        	     Flatten[
		       Map[NCPolyMomentMatrixAux2[nvars, Total[Drop[#, -1]], Rest[#]]&,
		           Keys[veronese[[2]]]]],
		     _?((# > m)&)
		   ]
		  ,
	           Null
		];
    
    (* Grab monomials off normalized polynomial list *)
    ver = NCPolyTermsToList[NCPoly[p[[1]], <|Thread[Keys[p[[2]]] -> 1]|>]];

    (* Exclude terms of degree higher than degree *)
    If[ NCPolyDegree[p] > degree,
	ver = DeleteCases[ver, _?((NCPolyDegree[#] > degree)&)]
    ];

    (* Calculate digits *)
    digits = Map[NCIntegerDigits[Keys[#[[2]]][[1]], p[[1]]]&, ver];

    (*
    Print["degree = ", degree];
    Print["halfDegree = ", halfDegree];
    Print["degree[p] = ", NCPolyDegree[p]];
    Print["m = ", m];
    Print["ver = ", ver];
    Print["digits = ", digits];
    Print["verIndex = ", verIndex];
    *)
    
    (* Calculate partitions of degree <= halfDegree *)
    halfPolys = DeleteCases[
		  Map[NCPolyMomentMatrixAux1[#, {nvars}, halfDegree] &, digits],
		  Null
		];

    (* Calculate indices in the veronese *)
    index = Map[NCPolyMomentMatrixAux2[nvars, #[[1]], #[[2]]]&, halfPolys, {3}];

    (*
    Print["halfPolys = ", halfPolys];
    Print["index = ", index];
    *)
    
    (* Restric indices to veronese *)
    If[ verIndex =!= Null
       ,
	index = Map[
	  Cases[#, _?((MemberQ[verIndex, #[[1]]]&&MemberQ[verIndex, #[[2]]])&)]&,
	  index];
    ];
    
    (*
    Print["index = ", index];
    *)
    
    Return[
      SparseArray[
        Append[
	  Flatten[MapThread[Thread[(#1 + 1) -> #2]&, {index, ver}]],
	  {1,1}->NCPolyConstant[1, p[[1]]]
        ], {m,m}
      ]
    ];
      
  ];

  NCPolyMomentMatrix[degree_Integer, {gbs__NCPoly}] := Module[
    {gb = {gbs}, halfDegree, nvars, v, ver,
     redVer, redIndex, activeIndex, p, redP, m, parallelize = False},
    
    halfDegree = Ceiling[degree/2];
    nvars = Total[gb[[1,1]]];

    (* Calculate dimension *)
    m = NCPolyMomentMatrixAux2[nvars, halfDegree+1, 0];

    (*
    Print["nvars = ", nvars];
    Print["degree = ", degree];
    Print["halfDegree = ", halfDegree];
    Print["m = ", m];
    *)
    
    (* Calculate veronese *)
    v = NCPolyVeronese[halfDegree, {nvars}];
    ver = NCPolyTermsToList[v];

    (* Reduce and zero repeated entries *)
    redVer = If[parallelize,
		Parallelize[Map[NCPolyReduce[#, gb], ver]],
		Map[NCPolyReduce[#, gb], ver]
		];
    redIndex = GatherBy[Range@Length@redVer, redVer[[#]] &];
    activeIndex = Flatten[Map[First, redIndex]];
    redIndex = Flatten[Map[Rest, redIndex]];
    redVer[[redIndex]] = 0;

    (*
    Print["redIndex = ", redIndex];
    Print["activeIndex = ", activeIndex];
    *)

    (*
    Print["ver = ", ver];
    Print["redVer = ", redVer];
    *)

    (* Square veronese *)
    p = If[parallelize,
           Parallelize[Outer[NCPolyMonomialProduct,
			     ver[[activeIndex]],
                             Map[NCPolyReverseMonomials, ver[[activeIndex]]]]],
	   Outer[NCPolyMonomialProduct,
	         ver[[activeIndex]],
                 Map[NCPolyReverseMonomials, ver[[activeIndex]]]]
	  ];
    redP = SparseArray[{},{m,m}];
    redP[[activeIndex,activeIndex]] = If[parallelize,
					 Parallelize[Map[NCPolyReduce[#, gb]&, p, {2}]],
					 Map[NCPolyReduce[#, gb]&, p, {2}]
					];
    
    (*
    Print["degree = ", degree];
    Print["halfDegree = ", halfDegree];
    Print["degree[p] = ", NCPolyDegree[p]];
    Print["m = ", m];
    Print["ver = ", ver];
    Print["p = ", p];
    Print["redP = ", Normal[redP,SparseArray]];
    *)
    
    Return[redP];
    
  ];



End[];
EndPackage[]
