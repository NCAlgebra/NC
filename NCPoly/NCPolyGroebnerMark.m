(*  NCPolyGroebner.m                                                       *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: August 2010                                                    *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyGroebnerMark`",
              "NCPoly`"  ];

Clear[NCPolyGroebner];
NCPolyGroebner::usage="NCPolyGroebner[G] computes the noncommutative Groebner basis of the list of polynomials G. See Options[NCPolyGroebner] for many options. The algorithm is based on T. Mora, An introduction to commuative and noncommutative Groebner Bases, Theoretical Computer Science, v. 134, pp. 131-173, 2000.";

Clear[NCPolySFactors];

Clear[NCPolySFactorExpand];
Clear[PrintBasis, PrintObstructions, PrintSPolynomials, 
      SimplifyObstructions, VerboseLevel];
Options[NCPolyGroebner] = {
  VerboseLevel -> 1,
  PrintBasis -> False,
  PrintObstructions -> False,
  PrintSPolynomials -> False,
  SimplifyObstructions -> True,
  SortBasis -> True
};

Begin["`Private`"];

(* Other operations *)

NCPolySFactorExpand[s_List, p1_NCPoly, p2_NCPoly] := 
  MapThread[NCPolyQuotientExpand[{#1},#2]&, {s, {p1, p2}}];

(* S-Polynomial matches *)
NCPolySFactors[r_NCPoly, s_NCPoly] := Module[
  { n = r[[1]] },

  Return[ 
    Map[ NCPolyMonomial[#, n]&
        ,
         NCPadAndMatch[
           NCIntegerDigits[Part[NCPolyLeadingTerm[r], 1], n],
           NCIntegerDigits[Part[NCPolyLeadingTerm[s], 1], n]
         ]
        ,
         {3} 
       ]
  ];
] /; NCPolyNumberOfVariables[r] === NCPolyNumberOfVariables[s];


(* Utilities *)

Clear[NCPolyGroebnerObstructions];
NCPolyGroebnerObstructions[G_List, j_Integer, simplify_] := Module[
  { i, OBS = {}, OBSi, d },

  (* Compute new set of obstructions *)
  For[ i = 1, i <= j, i++,

       (* Compute matches *)
       OBSi = NCPolySFactors[G[[i]], G[[j]]];

       (* Compute degree *)
       d = NCPolyDegree[G[[j]]];

       If[ OBSi =!= {},
           (* compute sugar *)
           d += Apply[Plus, Map[NCPolyDegree, OBSi[[All, 2]], {2}], {1}];

 	   (* add to OBS *)
           (* OBS = Join[OBS, Map[{{i, j}, #}&, OBSi]]; *)
           OBS = Join[OBS, MapThread[{{i, j}, #1, #2}&, {OBSi, d}]];
       ];
  ];

  Return[OBS];

];

Clear[NCPolyGroebnerSimplifyObstructions];
NCPolyGroebnerSimplifyObstructions[OBSs_List, TG_List, m_Integer, verboseLevel_Integer] := Module[
  { tt, n, l, i, ij, jj, tk, ltkr, match, k, OBS = OBSs },

  (* ATTENTION: TG is list with leading monomials only! *)

  (* Simplify OBS(i) for all i < m  *)
 
  (* get leading term of the mth polynomial *)
  tt = TG[[m]];
  n = NCPolyNumberOfVariables[tt];
  (* Print["tt = ", NCPolyDisplay[tt]]; *)

  l = Length[OBS];
  For[ i = 1, i <= l, i++,

       ij = Part[OBS, i, 1];
       jj = Part[ij, 2]; 
       OBSij = Part[OBS, i, 2, 2];

       (* Print["ij = ", ij];
	Print["OBSij = ", OBSij]; *)

       If[ jj >= m,
           (* All remaining obstructions have i >= m *)
           Print["* All remaining obstructions have i >= m"];
           Break[];
       ];

       (* get leading term of the jth polynomial *)
       tk = TG[[jj]];
       (* Print["tk = ", NCPolyDisplay[tk]]; *)

       (* compute expanded monomial ltkr = l tk r *)
       ltkr = NCPolyQuotientExpand[{OBSij}, tk];
       (* Print["ltkr = ", NCPolyDisplay[ltkr]]; *)

       (* try match with right and left sides different than 1 *)
       match = MatchQ[
		  NCIntegerDigits[Part[NCPolyLeadingTerm[ltkr], 1], n],
                  Join[{l__}, NCIntegerDigits[Part[NCPolyLeadingTerm[tt], 1], n], {r__}]
		]; 
       (* Print["match = ", match]; *)

       If[ match === True,

           If[ verboseLevel >= 2,  
               Print[ "* Removing obstructions (", 
                      ToString[ij], ") ",
                      "from set of obstructions" ];
           ];

           (* Remove obstructions from OBS *)
           OBS = Delete[OBS, i];
           i--; l--;

           (* Print["> ", Map[ColumnForm,{OBS[[All,1]], Map[NCPolyDisplay, Map[Rest, OBS], {4}]}]]; *)

       ];
   ];

  Return[OBS];

];

(* Groebner Basis Algortihm *)

NCPolyGroebner[{g__NCPoly}, iterations_Integer, opts___Rule] := Module[
  { i, j, k, l, m, n,
    G, TG, 
    OBS = {}, ij, OBSij, 
    q, h,
    sortFirst, simplifyOBS, sortBasis,
    printObstructions, printBasis, printSPolynomials, 
    verboseLevel },

  (* Process Options *)
  { simplifyOBS, sortBasis,
    printObstructions, printBasis, printSPolynomials,
    verboseLevel } = 
     { SimplifyObstructions, SortBasis,
       PrintObstructions, PrintBasis, PrintSPolynomials,
       VerboseLevel } /. Flatten[{opts}] /. Options[NCPolyGroebner];

  (* Banner *)
  Print["* * * * * * * * * * * * * * * *"];
  Print["* * *   NCPolyGroebner    * * *"];
  Print["* * * * * * * * * * * * * * * *"];
  If[ verboseLevel >= 2,
      Print["* Options:"];
      Print["> VerboseLevel         -> ", verboseLevel];
      Print["> SortBasis            -> ", sortBasis];
      Print["> SimplifyObstructions -> ", simplifyOBS];
      Print["> PrintObstructions    -> ", printObstructions];
      Print["> PrintBasis           -> ", printBasis];
      Print["> PrintSPolynomials    -> ", printSPolynomials];
  ];
 
  G = {g};
  If[ printBasis,
      Print["* Initial basis:"];
      Print["> G(0) = ", ColumnForm[NCPolyDisplay[G]]];
  ];

  (* Simplify and normalize initial relations *)
  If[ verboseLevel >= 1,
      Print["* Reduce and normalize initial basis"];
  ];

  (* Print["> G() = ", ColumnForm[NCPolyDisplay[NCPolyReduce[G,False,3]]]]; *)

  m = Length[G];
  (* G = NCPolyNormalize[FixedPoint[NCPolyReduce,G]]; *)
  G = NCPolyNormalize[NCPolyFullReduce[G]];
  If[ Length[G] < m, 
      Print[ "> Initial basis reduced to '", ToString[Length[G]],
             "' out of '", ToString[m], "' initial relations." ] 
  ];

  (* Sort basis *)
  If[ sortBasis, 
      If[ verboseLevel >= 2,
        Print["* Sort initial basis"];
      ];
      G = Sort[G];
  ];

  If[ verboseLevel >= 2,
      Print["* Extract leading monomials"];
  ];
  TG = Map[NCPolyLeadingMonomial, G];

  (* Iterate *)
  k = 0;
  Gf = {True};
  While[ And[k < iterations, Gf =!= {}],

    k++;

    (* Future basis *)
    Gf = {};
    TGf = {};

    If[ printBasis,
        Print["* Current basis:"];
        Print["> G(", ToString[k], ") = ", ColumnForm[NCPolyDisplay[G]]];
        (* Print["> TG(", ToString[k], ") = ", ColumnForm[NCPolyDisplay[TG]]]; *)
    ];

    (* Compute OBS *)
    If[ verboseLevel >= 1,
        Print["* Computing set of obstructions"];
    ];
    m = Length[G];
    OBSS = {};
    For[ j = 1, j <= m, j++,

       (* Simplify previous obstructions *)
       If[ And[ simplifyOBS, j >= 2 ],
           OBS = NCPolyGroebnerSimplifyObstructions[OBS, TG, j, verboseLevel];
       ];

       (* add new obstructions *)
       OBS = Join[OBS, NCPolyGroebnerObstructions[G, j, simplifyOBS]];
    ];
    If[ printObstructions, 
       Print["* Current obstructions:"];
               Print["> OBS = ", Map[ColumnForm,{OBS[[All,1]], Map[NCPolyDisplay, Map[Part[#, 2]&, OBS], {3}], OBS[[All,3]]}]];
    ];
 
    If[ verboseLevel >= 1,
        Print["* Iteration ", k, ", ", Length[G], " polys in the basis, ", Length[OBS], " obstructions"];
    ];

    While[ OBS =!= {},

      (* Choose obstruction *)
      l = Part[Ordering[Part[OBS, All, 3], 1], 1];
      (* Print["l = ", l]; *)
      ij = Part[OBS, l, 1];
      OBSij = Part[OBS, l, 2];

      If[ verboseLevel >= 2,
        Print["* Selecting obstruction OBS(", ij[[1]], ",", ij[[2]], ")"];
        If[ printObstructions, 
            Print["* Current obstructions:"];
	    Print["> OBS = ", Map[NCPolyDisplay, OBSij, {2}]];
        ];
      ];

      (* Remove first term from OBS *)
      OBS = Delete[OBS, l];

      If[ verboseLevel >= 2,
          Print["* Building S-Polynomial"];
      ];

      (* Construct S-Polynomial *)
      h = Subtract @@ NCPolySFactorExpand[ OBSij, G[[ij[[1]]]], G[[ij[[2]]]]];
      If [ h =!= 0,

         If[ printSPolynomials, 
           Print["* S-Polynomial:"];
           Print["> ", NCPolyDisplay[h]];
         ];

         If[ verboseLevel >= 2,
             Print["* Reducing S-Polynomial"];
         ];

         (* Reduce S-Polynomial *)
         q = {1};
         While[ And[ h =!= 0, Flatten[q] =!= {}], 
                {q, h} = NCPolyReduce[h, G];
                (* Print["h = ", NCPolyDisplay[h]];
                   Print["q = ", Map[NCPolyDisplay, q, {3}]]; *)
         ];

         ,

         If[ verboseLevel >= 2,
             Print["> Zero S-Polynomial!"];
         ];

      ];

      If [ h =!= 0,

         If[ printSPolynomials, 
             Print["* Reduced S-Polynomial:"];
             Print["> ", NCPolyDisplay[h]];
         ];

         (* Normalize and add h to Gf, TGf *)
         AppendTo[Gf, NCPolyNormalize[h]];
         AppendTo[TGf, NCPolyLeadingMonomial[Last[Gf]]];

         If[ verboseLevel >= 2,
             Print["* S-Polynomial added to future basis"];
         ];

         If[ printBasis,
             Print["* Future basis:"];
             Print["> Gf(", ToString[k], ") = ", ColumnForm[NCPolyDisplay[Gf]]];
            (* Print["> TGf(", ToString[k], ") = ", ColumnForm[NCPolyDisplay[TGf]]]; *)
         ];
        ,
         If[ verboseLevel >= 2,
             Print["* S-Polynomial can be completely reduced and has been removed from the set of obstructions."];
         ];

      ];

    ];

    (* Cleared all obstructions *)

    If[ Gf =!= {}, 
       G = Join[G, Gf];
       TG = Join[TG, TGf];
    ];

    (* Clean up basis *)
    If[ verboseLevel >= 1,
        Print["* Cleaning up basis."];
    ];
    (* G = NCPolyNormalize[FixedPoint[NCPolyReduce,G]]; *)
    G = NCPolyNormalize[NCPolyFullReduce[G]];
    TG = Map[NCPolyLeadingMonomial, G];

  ];

  If[ Gf === {}
     , 
      Print["* Found Groebner basis with ", ToString[Length[G]], " relations"];
     ,
      Print["* Interrupted before Groebner basis with ", ToString[Length[G]], " relations currently on the basis"];
  ];
  Print["* * * * * * * * * * * * * * * *"];

  Return[G];

];

End[];
EndPackage[]
