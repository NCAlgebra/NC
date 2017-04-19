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

  (* NCPoly Constructor *)
  
  Clear[NCPolyAux];
  NCPolyAux[vars:(_Symbol|Subscript[_Symbol,__])..] := Length[{vars}];
  NCPolyAux[var___] := (Message[NCPoly::InvalidList]; $Failed);

  Clear[NCPolyVarAux];
  NCPolyVarAux[Vars_List] := Block[
    {vars},
      
    (* list of variables *)

    If[ And[Depth[Vars] > 3, 
            Depth[Vars /. Subscript[x_,__] -> x] > 3],
        Message[NCPoly::InvalidList];
        Return[$Failed];
    ];
      
    (* repeat variables *)
    If[ Length[Flatten[Vars]] != Length[Union[Flatten[Vars]]],
        Message[NCPoly::InvalidList];
        Return[$Failed];
    ];
      
    (* normalize list of variables *)
      
    vars = Check[
           Apply[NCPolyAux, Map[Flatten, Map[List, Vars]], 1]
          ,
           $Failed
          ,
           NCPoly::InvalidList
    ];

    Return[vars];
  ];
  
  NCPoly[{}, {}, var_List] := 0;

  NCPoly[coeff_List, monomials_List, Vars_List] := Module[
    {vars, varnames},

    (* check monomial and coefficient size *)
    If[ Length[coeff] =!= Length[monomials],
        Message[NCPoly::SizeMismatch];
        Return[$Failed];
    ];

    (* list of variables *)
    Check[ vars = NCPolyVarAux[Vars];
          ,
           Return[$Failed]
          ,
           NCPoly::InvalidList
    ];
    varnames = Flatten[Vars];
      
    Check[
      NCPolyPack[
        NCPoly[ vars
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

  (* NCPolyConvert *)
  NCPolyConvert[p_List, Vars_List] := 
    Map[NCPolyConvert[#, Vars]&, p];
      
  NCPolyConvert[p_NCPoly, Vars_List] := Module[
    {vars},
      
    (* list of variables *)
    Check[ vars = NCPolyVarAux[Vars];
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
      NCPoly[vars, 
             KeySort[ KeyMap[ NCFromDigits[#, vars] &,
                              KeyMap[NCIntegerDigits[#, p[[1]]] &, 
                                     p[[2]] ] ] ]
    ]];
      
  ];
  
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

  NCPolyLeadingMonomial[p_NCPoly] := NCPolyLeadingMonomial[p, 1];

  NCPolyLeadingMonomial[p_NCPoly, 1] := 
    NCPoly[p[[1]], 
           KeyTake[p[[2]], {Last[Keys[p[[2]]]]}]];

  NCPolyLeadingMonomial[p_NCPoly, i_Integer] := Block[
    {key},
    Quiet[
      Check[ 
         key = Part[Keys[p[[2]]],-i];
         NCPoly[p[[1]], KeyTake[p[[2]], {key}]]
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
      NCFromDigits[NCIntegerDigits[key, p[[1]]], Plus @@ p[[1]]],
      p[[2]][key]
    ]
  ];

  NCPolyLeadingTerm[p_NCPoly, i_Integer] := Block[
    {key},
    Quiet[
      Check[ 
        key = Part[Keys[p[[2]]],-i];
        Rule[
          NCFromDigits[NCIntegerDigits[key, p[[1]]], Plus @@ p[[1]]],
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

  (* Display Order *)

  Clear[NCPolyDisplayOrderAux];
  NCPolyDisplayOrderAux[a_, b__, symbol_String] :=
    Join[{a, symbol}, NCPolyDisplayOrderAux[b, symbol]];

  NCPolyDisplayOrderAux[a_, symbol_String] := {a};

  NCPolyDisplayOrder[vars_List] := 
    DisplayForm[
      RowBox[Flatten[(NCPolyDisplayOrderAux[##, "\[LessLess] "]&) @@
              Apply[NCPolyDisplayOrderAux[##,"<"]&,  vars, 1]]]];

  (* NCPoly Operators *)

  (* Times *)
  NCPoly /: Times[r_, s_NCPoly] := NCPoly[s[[1]], r s[[2]]];

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
  
  NCPolyCoefficientArray[ps_List] := Block[
    {d},
    d = Max[Map[NCPolyDegree, ps]];
    Return[SparseArray[Map[NCPolyCoefficientArray[#,d]&, ps]]];
  ]; /; Count[Unitize[Max /@ ps[[All,1]] - Min /@ ps[[All,1]]], 0]

  Clear[IndexToDegree];
  IndexToDegree[m_, n_] := Floor[Log[n, (m - 1/(1 - n)) (-1 + n)]];

  NCPolyFromCoefficientArray[m_SparseArray /; Depth[m] == 3, vars_List] := 
    Map[NCPolyFromCoefficientArray[#,vars]&, m];

  NCPolyFromCoefficientArray[m_SparseArray /; Depth[m] == 2, Vars_List] := Module[
    {index, degree, n,
     rules = Drop[ArrayRules[m], -1],
     vars,flatvars},

    (* list of variables *)
    Check[ vars = NCPolyVarAux[Vars];
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

  
End[];
EndPackage[]
