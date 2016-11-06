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
  NCPolyMonomial[s_List, n_Integer] := 
    NCPoly[{n}, Association[NCFromDigits[s, n] -> 1]];

  (* DIGITS LEX MONOMIAL constructor *)
  NCPolyMonomial[s_List, {n__Integer}] := 
    NCPoly[{n}, Association[NCFromDigits[s, {n}] -> 1]];

  (* RULE MONOMIAL constructors *)
  NCPolyMonomial[s_Rule, {n__Integer}] := 
    NCPoly[
      {n}, 
      Association[NCFromDigits[NCIntegerDigits[s[[1]], Flatten[{n}]], {n}] -> s[[2]]]
    ];

  NCPolyMonomial[s_Rule, n_Integer] := 
    NCPolyMonomial[s, {n}];

  NCPolyMonomial[s_Rule, {var__List}] :=
    NCPolyMonomial[s, Map[Length,{var}]];

  NCPolyMonomial[s_Rule, var_List] :=
    NCPolyMonomial[s, {var}];

  (* LEX constructor *)
  NCPolyMonomial[monomials_List, {var__List}] := 
    NCPolyMonomial[
       Flatten[Map[(Position[Flatten[{var}], #]-1)&, monomials]]
      ,Map[Length,{var}]
    ];

  (* DEG constructor *)
  NCPolyMonomial[monomials_List, var_List] := 
    NCPolyMonomial[monomials, {var}];

  Clear[NCPolyAux];
  NCPolyAux[vars__Symbol] := Length[{vars}];
  NCPolyAux[var___] := (Message[NCPoly::InvalidList]; $Failed);
  
  (* NCPoly Constructor *)
  
  NCPoly[{}, {}, var_List] := 0;

  NCPoly[coeff_List, monomials_List, {Vars__}] := Module[
    {vars, varnames},

    If[ Length[coeff] =!= Length[monomials],
        Message[NCPoly::SizeMismatch];
        Return[$Failed];
    ];

    (* list of variables *)

    If[ Depth[{Vars}] > 3,
        Message[NCPoly::InvalidList];
        Return[$Failed];
    ];
      
    (* normalize list of variables *)
      
    Check[ vars = Apply[NCPolyAux, Map[Flatten, Map[List, {Vars}]], 1]
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
    varnames = Flatten[{Vars}];
      
    Check[
      NCPolyPack[
        NCPoly[ vars
           ,
            KeySort[
              AssociationThread[ 
                NCFromDigits[
                    Map[ NCMonomialToDigits[#, varnames]&, monomials]
                   ,vars
                  ],
                  coeff
              ]
            ]
        ]
      ]
     ,
      $Failed
     ,
      NCMonomialToDigits::InvalidSymbol
    ]
  ];

  NCPoly[r_,Association[]] := 0;
  
  (* errors *)
  
  NCPoly[r_,s_] := (Message[NCPoly::NotPolynomial]; 
    $Failed) /; Or[ Head[r] =!= List, Depth[r] =!= 2,
                   Head[s] =!= Association ];

  NCPoly[r___] := (Message[NCPoly::NotPolynomial]; 
    $Failed) /; Length[{r}] =!= 2;

  (* NCPoly Utilities *)

  NCPolyPack[p_NCPoly] := 
    NCPoly[ p[[1]], DeleteCases[p[[2]], 0] ];

  NCPolyMonomialQ[p_NCPoly] := (Length[Part[p, 2]] === 1);
  NCPolyMonomialQ[p_] := False;

  NCPolyNumberOfVariables[p_NCPoly] := Plus @@ p[[1]];

  NCPolyDegree[p_NCPoly] := Max @@ Map[Plus @@ Drop[#, -1] &, Keys[p[[2]]]];

  NCPolyGetCoefficients[p_NCPoly] := Values[p[[2]]];

  NCPolyCoefficient[p_NCPoly, m_?NCPolyMonomialQ] :=
    Part[Lookup[p[[2]], {First[Keys[m[[2]]]]}, 0], 1];

  NCPolyGetIntegers[p_NCPoly] := Keys[p[[2]]];

  NCPolyGetDigits[p_NCPoly] := 
    NCIntegerDigits[NCPolyGetIntegers[p], p[[1]]];

  NCPolyLeadingMonomial[{p__NCPoly}, i_Integer:1] := 
    Map[NCPolyLeadingMonomial[#, i]&, {p}];

  NCPolyLeadingMonomial[p_NCPoly, i_Integer:1] := 
    NCPolyMonomial[NCPolyLeadingTerm[p, i], p[[1]]];

  NCPolyLeadingTerm[{p__NCPoly}, i_Integer:1] := 
    Map[NCPolyLeadingTerm[#, i]&, {p}];

  NCPolyLeadingTerm[p_NCPoly] := 
    NCPolyLeadingTerm[p, 1];

  NCPolyLeadingTerm[p_NCPoly, 1] := Block[{key = Last[Keys[p[[2]]]]},
    Rule[
      NCFromDigits[NCIntegerDigits[key, p[[1]]], Plus @@ p[[1]]],
      p[[2]][key]
    ]
  ];

  NCPolyLeadingTerm[p_NCPoly, i_Integer] := Block[{key},
    Quiet[
      Check[ 
        key = Part[Keys[p[[2]]],-i];
        Rule[
             NCFromDigits[NCIntegerDigits[key, p[[1]]], Plus @@ p[[1]]]
            ,p[[2]][key]
        ]
        ,$Failed
        ,Part::partw
      ]
    ]
  ];

  NCPolyNormalize[{p__NCPoly}] := Map[NCPolyNormalize, {p}];

  NCPolyNormalize[p_NCPoly] := Times[p, 1/Part[NCPolyLeadingTerm[p], 2]];

  (* Display Order *)

  Clear[NCPolyDisplayOrderAux];
  NCPolyDisplayOrderAux[a_, b__, symbol_String] :=
    ToString[a] <> " " <> symbol <> " " <> NCPolyDisplayOrderAux[b, symbol];

  NCPolyDisplayOrderAux[a_, symbol_String] := ToString[a];

  NCPolyDisplayOrder[vars_List] := 
    (NCPolyDisplayOrderAux[##, "\[LessLess] "]&) @@
    Apply[NCPolyDisplayOrderAux[##,"<"]&,  vars, 1];

  (* NCPoly Operators *)

  (* Times *)
  NCPoly /: Times[r_, s_NCPoly] := 
    NCPoly[s[[1]], r s[[2]]];

  (* Plus *)
  NCPolySum[r_NCPoly, s_NCPoly] := NCPoly[
    r[[1]], 
    KeySort[DeleteCases[Merge[{r[[2]], s[[2]]}, Total], 0]]
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
    sdegree = Map[Plus @@ Drop[#, -1] &, Keys[s[[2]]]];
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
      Return[NCPoly[n, KeySort[Association[MapThread[Rule,{digits, coeff}]]]]];
      ,

      (* Handle repeats with Merge *) 
      Return[NCPoly[n, KeySort[Merge[MapThread[Rule,{digits, coeff}], Total]]]];

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

End[];
EndPackage[]
