(*  NCPolyArray.m                                                          *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyArray`",
              "NCPoly`" ];

(* All declarations from NCPoly` *)

Begin["`Private`"];

(* Display *)

NCPolyDisplay[{p__NCPoly}] := 
  Map[NCPolyDisplay, {p}];

NCPolyDisplay[p_NCPoly] := 
  NCPolyDisplay[p, Table[Symbol["x" <> ToString[i]], {i, p[[1]]}]];

NCPolyDisplay[{p__NCPoly}, vars_List] := 
  Map[NCPolyDisplay[#, vars]&, {p}];

NCPolyDisplay[p_NCPoly, vars_List] := 
  Plus @@ 
    MapThread[
      Times, 
      { NCPolyGetCoefficients[p],
        Apply[Dot, Map[Part[vars,#]&, NCPolyGetDigits[p] + 1] /. {} -> 1, 1] }
    ];

NCPolyDisplay[p_?NumericQ, vars_List:{}] := p;


(* NCPoly Constructor *)

NCPolyMonomial[monomials_List, var_List] := 
  NCPolyMonomial[Flatten[Map[(Position[var, #]-1)&, monomials]], Length[var]];

NCPolyMonomial[{}, n_Integer] := 1;

NCPolyMonomial[s_List, n_Integer] := Module[
  { d = Length[s] },
  NCPoly[n, SparseArray[ {NCFromDigits[s, n]+1 -> 1}, {d+1, n^d}]]
];

NCPolyMonomial[s_Rule, n_Integer] := Module[
  { d = s[[1,1]] },
  NCPoly[n, SparseArray[Replace[s, (a_ -> b_) -> (a+1 -> b)], {d+1, n^d}]]
];

NCPoly[coeff_List, monomials_List, var_List] := Module[
  { n = Length[var], 
    d = Max[Map[Length, monomials]] },

  NCPoly[
    n,
    SparseArray[
      MapThread[Rule, 
        { NCFromDigits[
            Flatten[Map[Flatten[Position[var, #]-1]&, monomials, {2}], {3,1}],
            n
          ]+1,
          coeff
        } 
      ],
      {d+1, n^d}
    ]
  ]
];

NCPoly[r_,s_] := 
  $Failed /; Or[ Head[r] =!= Integer,
                 Head[s] =!= SparseArray ];

NCPoly[r___] := $Failed /; Length[{r}] =!= 2;

(* NCPoly Utilities *)

Clear[FindLeading];
FindLeading[s_SparseArray, 0] := $Failed;

(* Search row by row *)
FindLeading[s_SparseArray, i_Integer] :=
  Quiet[
    Check[
      Last[Cases[ArrayRules[Part[s, i]], Except[_ -> 0]]]
         /. ({a_} -> b_) -> ({i, a} - 1) -> b
     ,
      FindLeading[s, i - 1]
     ,
      Last::nolast
    ]
   ,
    Last::nolast
  ];
FindLeading[s_SparseArray] := FindLeading[s, Length[s]];

Clear[NormalizeSparseArray];
NormalizeArrayRules[s_SparseArray] := Module[
  { lc = Part[FindLeading[s], 2] },
  SparseArray[ArrayRules[s] /. (a_ -> b_) -> (a -> b / lc), Dimensions[s]]
];
  
NCPolyNormalize[{p__NCPoly}] := 
  Map[NCPolyNormalize, {p}];

NCPolyNormalize[p_NCPoly] := 
  NCPoly[p[[1]], NormalizeArrayRules[p[[2]]]];

NCPolyLeadingMonomial[{p__NCPoly}, i_Integer:1] := 
  Map[NCPolyLeadingMonomial[#, i]&, {p}];

NCPolyLeadingMonomial[p_NCPoly, i_Integer:1] := 
  NCPolyMonomial[NCPolyLeadingTerm[p, i], p[[1]]];

NCPolyLeadingTerm[{p__NCPoly}, i_Integer:1] := 
  Map[NCPolyLeadingTerm[#, i]&, {p}];

NCPolyLeadingTerm[p_NCPoly] := 
  NCPolyLeadingTerm[p, 1];

(* Search only on the last row *)
NCPolyLeadingTerm[p_NCPoly, 1] := Module[
  { d = Length[p[[2]]], lastRowRules },
  lastRowRules = Cases[ArrayRules[Part[p[[2]], d]], Except[_ -> 0]];
  Part[lastRowRules, First[Ordering[lastRowRules, -1]]] /.
    ({a_} -> b_) -> ({d - 1, a - 1} -> b)
];

(* Search on the entire array *)
NCPolyLeadingTerm[p_NCPoly, i_Integer] := Module[
  { rowRules = Cases[ArrayRules[p[[2]]], Except[_ -> 0]] },
  Quiet[
    Check[ 
      Replace[
        Part[rowRules, First[Ordering[rowRules, -i]]]
       ,
        (a_ -> b_) -> ((a - 1) -> b)
      ]
     ,
      $Failed
     ,
      Take::take
    ]
  ]
];

NCPolyMonomialQ[p_NCPoly] := (NCPolyLeadingTerm[p, 2] === $Failed);
NCPolyMonomialQ[p_] := False;

NCPolyNumberOfVariables[p_NCPoly] := p[[1]];

NCPolyDegree[p_NCPoly] := Part[Dimensions[p[[2]]], 1] - 1;

NCPolyGetCoefficients[p_NCPoly] := 
  p[[2]] /. (HoldPattern[SparseArray[_, _, _, {_,_,c_}]] :> c);

NCPolyCoefficient[p_NCPoly, m_?NCPolyMonomialQ] := 
  Part[p[[2]], ##]& @@ First[First[ArrayRules[m[[2]]]]];

NCPolyGetDigits[p_NCPoly] := 
  NCIntegerDigits[NCPolyGetIntegers[p], p[[1]]];

NCPolyGetIntegers[p_NCPoly] := 
  Map[First, Most[ArrayRules[p[[2]]]]] - 1;

(* NCPoly Operators *)

(* Times *)
NCPoly /: Times[r_?NumericQ, s_NCPoly] := NCPoly[s[[1]], r s[[2]]];

(* Plus *)
NCPolySum[r_NCPoly, s_NCPoly] := Module[
  { tmp, pack, d },

(*
  Print["r[", NCPolyDegree[r], "](", Dimensions[r[[2]]], ") = ", ArrayRules[r[[2]]]];
  Print["s[", NCPolyDegree[s], "](", Dimensions[s[[2]]], ") = ", ArrayRules[s[[2]]]];
*)

  pack = False;
  tmp = Switch[ Sign[NCPolyDegree[r] - NCPolyDegree[s]]
      (* deg[r] == deg[s] *)
     ,0,
      pack = True;
      r[[2]] + s[[2]]
      (* deg[r] > deg[s] *)
     ,1,
      r[[2]] + PadRight[s[[2]], Dimensions[r[[2]]] ]
      (* deg[r] < deg[s] *)
     ,-1,
      s[[2]] + PadRight[r[[2]], Dimensions[s[[2]]] ]
    ];

  If[ pack
     ,
      (* find true degree *)
      d = FindLeading[tmp];
      If[ d === $Failed
         ,
          (* return 0 *)
          Return[0];
         ,
          d = Part[d, 1, 1];
          If[ d != Length[tmp] - 1
             ,
              (* repack polynomial *)
              tmp = SparseArray[tmp, {d+1, s[[1]]^d}];
          ];
      ];
   ];

   (* return polynomial *)
   NCPoly[ r[[1]], tmp ]

] /; s[[1]] === r[[1]];

(* Product *)

NCPolyProduct[r_NCPoly, s_NCPoly] := Module[
  { digits, coeff, 
    n = r[[1]], 
    d = NCPolyDegree[r] + NCPolyDegree[s] },

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
  coeff = Flatten[
            Outer[
              Times, 
              NCPolyGetCoefficients[r], 
              NCPolyGetCoefficients[s], 
              1
            ]
          ];

  (* Sort *)
  index = Ordering[digits];
  digits = digits[[index]];
  coeff = coeff[[index]];

  (* Collect *)
  {coeff, digits} = 
    Transpose[
      Apply[{Plus @@ #1, Part[#2, 1]} &, 
            Map[ Transpose, 
                 Split[
                   Transpose[{coeff, digits}], 
                   Last[#1] === Last[#2]&
                 ] 
                ,{1}
            ],
           {1}
          ]
        ];

  (* Build new polynomial *) 
  NCPoly[
    n,
    SparseArray[
      MapThread[Rule, 
        { digits+1, coeff } 
      ],
      {d+1, n^d}
    ]
  ]
] /; s[[1]] === r[[1]];


(* Reduce *)

NCPolyReduce[f_NCPoly, g_NCPoly, complete_:False, debugLevel_:0] := Module[
  { maxIterations = 10, 
    n = f[[1]], leadG, leadR, r, rr, q, qi, j, k },

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
