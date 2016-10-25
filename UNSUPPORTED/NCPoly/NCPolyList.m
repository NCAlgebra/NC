(*  NCPolyList.m                                                           *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyList`",
              "NCPoly`" ];

(* All declarations from NCPoly` *)

Begin["`Private`"];

(* NCPoly Order *)
NCPolyOrderType[p_NCPoly] = NCPolyDegLex;

(* NCPoly Constructor *)

NCPolyMonomial[monomials_List, var_List] := 
  NCPolyMonomial[Flatten[Map[(Position[var, #]-1)&, monomials]], Length[var]];

(* NULL MONOMIAL constructor *)
NCPolyMonomial[{}, n_Integer] := 1;

(* DIGITS DEG MONOMIAL constructor *)
NCPolyMonomial[s_List, n_Integer] := 
  NCPoly[n, List[{NCFromDigits[s, n], 1}]];

(* RULE DEG MONOMIAL constructor *)
NCPolyMonomial[s_Rule, n_Integer] := 
  NCPoly[n, {List @@ s}];

NCPoly[coeff_List, monomials_List, var_List] := NCPolyPack[
  NCPoly[ Length[var]
         ,
          Sort[
            MapThread[List, 
              { NCFromDigits[
                  Flatten[Map[Flatten[Position[var, #]-1]&, monomials, {2}], {3,1}],
                  Length[var]
                ],
                coeff
              } 
            ]
          ]
  ]
];

NCPoly[r_,{}] := 0;
NCPoly[r_,s_] := 
  $Failed /; Or[ Head[r] =!= Integer,
                 Head[s] =!= List ];

NCPoly[r___] := $Failed /; Length[{r}] =!= 2;

(* NCPoly Utilities *)

NCPolyPack[p_NCPoly] := Module[
  { ind },

  (* Find zeros *)
  ind = Position[p, 0, {3}];
  If[ ind =!= {}
     ,
      Return[Delete[p, Part[ind, All, {1, 2}]]];
     ,
      Return[p];
  ];
];

NCPolyMonomialQ[p_NCPoly] := (Length[Part[p, 2]] === 1);
NCPolyMonomialQ[p_] := False;

NCPolyNumberOfVariables[p_NCPoly] := p[[1]];

NCPolyDegree[p_NCPoly] := Part[Last[Part[p, 2]], 1, 1];

NCPolyGetCoefficients[p_NCPoly] := Part[p, 2, All, 2];

NCPolyCoefficient[p_NCPoly, m_?NCPolyMonomialQ] := Module[
    {pos},
    pos = FirstPosition[p[[2]][[All,1]], First[First[m[[2]]]]];
    If[pos =!= Missing["NotFound"], p[[2, pos[[1]]]][[2]], 0]
];

NCPolyGetIntegers[p_NCPoly] := Part[p, 2, All, 1];

NCPolyGetDigits[p_NCPoly] := NCIntegerDigits[NCPolyGetIntegers[p], p[[1]]];

NCPolyLeadingMonomial[{p__NCPoly}, i_Integer:1] := 
  Map[NCPolyLeadingMonomial[#, i]&, {p}];

NCPolyLeadingMonomial[p_NCPoly, i_Integer:1] := 
  NCPolyMonomial[NCPolyLeadingTerm[p, i], p[[1]]];

NCPolyLeadingTerm[{p__NCPoly}, i_Integer:1] := 
  Map[NCPolyLeadingTerm[#, i]&, {p}];

NCPolyLeadingTerm[p_NCPoly] := NCPolyLeadingTerm[p, 1];

NCPolyLeadingTerm[p_NCPoly, 1] := Rule @@ Part[p, 2, -1];

NCPolyLeadingTerm[p_NCPoly, i_Integer] := Quiet[
  Check[ Rule @@ Part[p, 2, -i]
        ,
         $Failed
        ,
        Part::partw
  ]
];

NCPolyNormalize[{p__NCPoly}] := Map[NCPolyNormalize, {p}];

NCPolyNormalize[p_NCPoly] := Times[p, 1/Part[NCPolyLeadingTerm[p], 2]];

(* Display *)

NCPolyDisplay[{p__NCPoly}] := 
  Map[NCPolyDisplay, {p}];

NCPolyDisplay[p_NCPoly] := 
  NCPolyDisplay[p, Table[Symbol["x" <> ToString[i]], {i, p[[1]]}]];

NCPolyDisplay[{p__NCPoly}, vars_List] := 
  Map[NCPolyDisplay[#, vars]&, {p}];

NCPolyDisplay[p_NCPoly, vars_List, plus_:List] := 
  plus @@ 
    MapThread[
      Times, 
      { NCPolyGetCoefficients[p],
        Apply[Dot, Map[Part[vars,#]&, NCPolyGetDigits[p] + 1] /. {} -> 1, 1] }
    ];

NCPolyDisplay[p_?NumericQ, vars_List:{}] := p;


(* NCPoly Operators *)

(* Times *)
NCPoly /: Times[r_?NumericQ, s_NCPoly] := Module[
  { ss = s },
  Part[ss, 2, All, 2] = r Part[ss, 2, All, 2];
  Return[ss];
]

(* Plus *)
NCPolySum[r_NCPoly, s_NCPoly] := Module[
  { tmp },

  (* Join two polys *)
  tmp = Sort[ Join[ Part[r, 2], Part[s, 2] ] ];
  (* Print["tmp = ", tmp]; *)

  (* Split *)
  tmp = Map[({Part[#, 1, 1], Plus @@ Part[#, All, 2]})&, Split[tmp, (First[#1]===First[#2])&]];
  (* Print["tmp = ", tmp]; *)

  (* Pack and Return Polynomial *)
  Return[NCPolyPack[ NCPoly[ r[[1]], tmp ]] ];

] /; s[[1]] === r[[1]];

NCPolyProduct[r_NCPoly, s_NCPoly] := Module[
  { digits, coeff, 
    n = r[[1]] },

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
  Return[NCPolyPack[NCPoly[ n, MapThread[List,{digits, coeff}]]]];

] /; s[[1]] === r[[1]];


(* Division *)

NCPolyReduce[f_NCPoly, g_NCPoly, complete_:False, debugLevel_:0] := Module[
  { maxIterations = 10, 
    n = f[[1]], leadG, leadR, dG, dr, r, rr, q, qi, j, k },

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
  dG = Part[leadG, 1, 1];
  If[ debugLevel > 1, Print["leadG = ", leadG, "dG = ", dG]; ];
  While[ k < maxIterations,
         k++;
         leadR = NCPolyLeadingTerm[r, j];
         If[ debugLevel > 1, Print["leadR = ", leadR]; ];
         If [ leadR === $Failed,
              (* does not divide, terminate *)
              If[ debugLevel > 1, Print["does not divide, terminate"]; ];
              Break[];
         ];
         dR = Part[leadR, 1, 1];
         (* Print["dR = ", dR]; *)
         If[ dR < dG,
             (* Can't divide, all other terms are lower order, terminate, *)
             If[ debugLevel > 1, Print["does not divide, terminate, all other terms lower order"]; ];
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
