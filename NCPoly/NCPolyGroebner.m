(*  NCPolyGroebner.m                                                       *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyGroebner`",
              "NCPoly`"  ];

Clear[NCPolyGroebner,
      VerboseLevel,
      PrintBasis, 
      PrintObstructions, 
      PrintSPolynomials, 
      SimplifyObstructions,
      ReduceBasis,
      CleanUpBasis,
      SortObstructions,
      SortBasis
     ];
Options[NCPolyGroebner] = {
  VerboseLevel -> 1,
  PrintBasis -> False,
  PrintObstructions -> False,
  PrintSPolynomials -> False,
  SimplifyObstructions -> True,
  ReduceBasis -> True,
  CleanUpBasis -> False,
  SortObstructions -> False,
  SortBasis -> False,
  Labels -> {}
};

Get["NCPolyGroebner.usage"];

NCPolyGroebner::Interrupted = "Stopped trying to find a Groebner basis at `1` polynomials";

Begin["`Private`"];

(* Other operations *)
Clear[NCPolySFactorExpand];
NCPolySFactorExpand[s_List, p1_NCPoly, p2_NCPoly] := 
  MapThread[NCPolyQuotientExpand[{#1},#2]&, {s, {p1, p2}}];

(* S-Polynomial matches *)
Clear[NCPolySFactors];
NCPolySFactors[r_NCPoly, s_NCPoly] := Block[
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
NCPolyGroebnerObstructions[G_List, j_Integer, simplify_] := Block[
  { i, OBS = {}, OBSi, d },

  (* Compute new set of obstructions *)
  For[ i = 1, i <= j, i++,

       (* Compute matches *)
       OBSi = NCPolySFactors[G[[i]], G[[j]]];

       (* Print["OBSi = ", OBSi]; *)

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
NCPolyGroebnerSimplifyObstructions[OBSs_List, TG_List, m_Integer, verboseLevel_Integer] := Block[
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

           If[ verboseLevel >= 3,  
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

(* Add to basis *)
Clear[AddToBasis];
AddToBasis[g_, tg_, obs_, h_, 
           labels_, simplifyOBS_, verboseLevel_] := Module[
  {G,TG,OBS,m},
         
  (* Normalize and add h to G, TG *)
  G = Append[g, NCPolyNormalize[h]];
  TG = Append[tg, NCPolyLeadingMonomial[Last[G]]];
  m = Length[G];

  If[ verboseLevel >= 3,
      Print["* S-Polynomial added to current basis"];
  ];

  If[ simplifyOBS,
    If[ verboseLevel >= 3,
        Print["* Simplify current set of obstructions"];
    ];
    OBS = NCPolyGroebnerSimplifyObstructions[obs, TG, m, verboseLevel];
  ];

  If[ verboseLevel >= 3,
      Print["* Computing new set of obstructions"];
  ];

  (* add new obstructions *)
  OBS = Join[OBS, NCPolyGroebnerObstructions[G, m, simplifyOBS]];

  If[ printObstructions, 
      Print["* New set of obstructions:"];
      Print["> OBS = ", Map[ColumnForm,{OBS[[All,1]], Map[NCPolyDisplay[#,labels]&, Map[Part[#, 2]&, OBS], {3}], OBS[[All,3]]}]];
  ];
    
  Return[{G,TG,OBS,m}];
               
];
        
Clear[ReduceSPolynomial];
ReduceSPolynomial[G_,H_,labels_,
                  symbolicCoefficients_,verboseLevel_] := Module[
  {q,h = H},

  q = {1};
  While[ And[ h =!= 0, Flatten[q] =!= {}], 
         {q, h} = NCPolyReduce[h, G];
         (* Make sure to simplify coefficients in case of
            symbolic coefficients *)
         If[ h =!= 0 && symbolicCoefficients,
             h = NCPolyPack[NCPolyTogether[h]];
         ];
         If[ verboseLevel >= 4,
             Print["> h = ", NCPolyDisplay[h, labels]];
         ];
         (* Print["h = ", NCPolyDisplay[h, labels]];
            Print["q = ", Map[NCPolyDisplay[#,labels]&, q, {3}]]; *)
  ];
  
  Return[h];
    
];



(* Groebner Basis Algortihm *)

NCPolyGroebner[{}, iterations_Integer, opts___Rule] := {};

NCPolyGroebner[{g__NCPoly}, iterations_Integer, opts___Rule] := Block[
  { i, j, k, kk, l, m, mm, n,
    G, TG, 
    OBS = {}, ij, OBSij, 
    q, h,  
    reducible, ii, Gii, index,
    symbolicCoefficients,
    sortFirst, simplifyOBS, sortBasis,
    printObstructions, printBasis, printSPolynomials, 
    labels, sortObstructions, reduceBasis, cleanUpBasis,
    verboseLevel },

  (* Process Options *)
  { simplifyOBS, sortBasis,
    printObstructions, printBasis, printSPolynomials,
    labels, sortObstructions, reduceBasis, cleanUpBasis,
    verboseLevel } = 
     { SimplifyObstructions, SortBasis,
       PrintObstructions, PrintBasis, PrintSPolynomials,
       Labels, SortObstructions, ReduceBasis, CleanUpBasis,
       VerboseLevel } /. Flatten[{opts}] /. Options[NCPolyGroebner];

  (* Banner *)
  If[ verboseLevel >= 1,
      Print["* * * * * * * * * * * * * * * *"];
      Print["* * *   NCPolyGroebner    * * *"];
      Print["* * * * * * * * * * * * * * * *"];
      If[ verboseLevel >= 2,
          Print["* Options:"];
          Print["> VerboseLevel         -> ", verboseLevel];
          Print["> SortBasis            -> ", sortBasis];
          Print["> SimplifyObstructions -> ", simplifyOBS];
          Print["> SortObstructions     -> ", sortObstructions];
          Print["> PrintObstructions    -> ", printObstructions];
          Print["> PrintBasis           -> ", printBasis];
          Print["> PrintSPolynomials    -> ", printSPolynomials];
      ];
  ];
 
  G = {g};

  (* Set labels *)
  varnum = G[[1,1]];
  labels = If[ labels == {},
    Table[Symbol[FromCharacterCode[ToCharacterCode["@"]+i]], {i, Plus @@ varnum}]
    ,
    Flatten[labels]
  ];
  
  (* Wrap labels *)
  start = Drop[FoldList[Plus, 0, varnum], -1] + 1;
  end = start + varnum - 1;

  (*
     Print["labels = ", labels];
     Print["varnum = ", varnum];
     Print["start = ", start];
     Print["end = ", end];
  *)

  labels = MapThread[Take[labels,{#1,#2}]&, {start, end}];

  (* Symbolic coefficients? *)
  symbolicCoefficients = 
    Not[And @@ Flatten[Map[NumberQ,
                           Map[NCPolyGetCoefficients, G], {2}]]];
    
  If[ symbolicCoefficients && verboseLevel >= 1,
      Print["* Symbolic coefficients detected"];
  ];
    
  If[ verboseLevel >= 1,
    (* Print order *)
    Print["* Monomial order: ", NCPolyDisplayOrder[labels]];
  ];

  If[ verboseLevel >= 3,
    (* Print initial basis *)
    Print["> G(0) = ", ColumnForm[NCPolyDisplay[G, labels]]];
  ];

  (* Simplify and normalize initial relations *)
  If[ verboseLevel >= 1,
      Print["* Reduce and normalize initial set"];
  ];

  m = Length[G];
  G = NCPolyNormalize[NCPolyFullReduce[G]];
  If[ verboseLevel >= 1,
      If[ Length[G] < m, 
          Print[ "> Initial set reduced to '", ToString[Length[G]],
                 "' out of '", ToString[m], "' polynomials" ];
         ,
          Print[ "> Initial set could not be reduced" ];
      ];
  ];

  If[ verboseLevel >= 3,
    (* Print initial basis *)
    Print["> G(0) = ", ColumnForm[NCPolyDisplay[G, labels]]];
  ];

  (* Sort basis *)
  If[ sortBasis, 
      If[ verboseLevel >= 1,
        Print["* Sorting initial basis"];
      ];
      G = Sort[G];
  ];

  If[ printBasis,
      Print["> G(0) = ", ColumnForm[NCPolyDisplay[G, labels]]];
  ];
      
  If[ verboseLevel >= 2,
      Print["* Extracting leading monomials"];
  ];
  TG = Map[NCPolyLeadingMonomial, G];

  If[ verboseLevel >= 3,
      Print["> TG(0) = ", NCPolyDisplay[TG, labels]];
  ];

  (* Compute OBS *)
  If[ verboseLevel >= 1,
      Print["* Computing initial set of obstructions"];
  ];
  m = Length[G];
  mm = m;
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
             Print["> OBS = ", Map[ColumnForm,{OBS[[All,1]], Map[NCPolyDisplay[#, labels]&, Map[Part[#, 2]&, OBS], {3}], OBS[[All,3]]}]];
  ];
 
  (* Iterate *)
  k = 0;
  kk = 0;
  While[ OBS =!= {},

    k++;
    If[ verboseLevel >= 2,
        Print["- Minor Iteration ", k, ", ", Length[G], " polys in the basis, ", Length[OBS], " obstructions"];
    ];

    (* Call Together if symbolic coefficients *)
    If[ symbolicCoefficients,
        G = Map[NCPolyTogether, G];
    ];
         
    If[ printBasis,
        Print["* Current basis:"];
        Print["> G(", ToString[k], ") = ", ColumnForm[NCPolyDisplay[G, labels]]];
        (* Print["> TG(", ToString[k], ") = ", ColumnForm[NCPolyDisplay[TG, labels]]]; *)
    ];

    (* Choose obstruction *)
    l = If[ sortObstructions
       ,
        If[ verboseLevel >= 3,
          Print["* Sorting obstructions (SUGAR)"];
        ];
        (* Use SUGAR heuristic to sort obstructions *)
        Part[Ordering[Part[OBS, All, 3], 1], 1]
       ,
        (* Pick first one *)
        1
    ];

    (* Print["l = ", l]; *)
    ij = Part[OBS, l, 1];
    OBSij = Part[OBS, l, 2];

    If[ ij[[2]] > mm,
      (* Major iteration reached *)
      kk ++;
      mm = Part[OBS, -1, 1, 2];
      If[ verboseLevel >= 1,
        Print["> MAJOR Iteration ", kk, ", ", Length[G], " polys in the basis, ", Length[OBS], " obstructions"];
      ];
      If[ kk >= iterations,
          Break[];
      ];
    ];

    If[ verboseLevel >= 3,
        Print["* Selecting obstruction OBS(", ij[[1]], ",", ij[[2]], ")"];
        If[ printObstructions, 
            Print["* Current obstructions:"];
	    Print["> OBS = ", Map[NCPolyDisplay[#,labels]&, OBSij, {2}]];
        ];
    ];

    (* Remove first term from OBS *)
    OBS = Delete[OBS, l];

    If[ verboseLevel >= 3,
        Print["* Building S-Polynomial"];
    ];

    (* Construct S-Polynomial *)
    h = Subtract @@ NCPolySFactorExpand[ OBSij, G[[ij[[1]]]], G[[ij[[2]]]]];
    If [ h =!= 0,

         If[ printSPolynomials, 
           Print["* S-Polynomial:"];
           Print["> ", NCPolyDisplay[h, labels]];
         ];

         If[ verboseLevel >= 3,
             Print["* Reducing S-Polynomial"];
         ];

         (* Reduce S-Polynomial *)
         h = ReduceSPolynomial[G,h,labels,symbolicCoefficients,verboseLevel];

         ,

         If[ verboseLevel >= 3,
             Print["> Zero S-Polynomial!"];
         ];

    ];

    If [ h =!= 0,

         If[ printSPolynomials, 
             Print["* Reduced S-Polynomial:"];
             Print["> ", NCPolyDisplay[h, labels]];
         ];

         (* Does h divide any poly in the basis? *)
         reducible = Pick[Range[m], 
                          Map[(First[NCPolyReduce[#, 
                                     NCPolyLeadingMonomial[h]]]=!={})&,
                              TG]];
         
         If[ verboseLevel >= 2 && Length[reducible] > 0,
             Print["> ", Length[reducible], 
                   " polys in the current base can be reduced by S-Polynomial"];
         ];
             
         (* Add h to basis *)
         {G,TG,OBS,m} = AddToBasis[G,TG,OBS,h,labels,
                                   simplifyOBS,verboseLevel];
         
         If[ reduceBasis,
             
             If[ verboseLevel >= 2,
                 Print["* Reducing current base"];
             ];
             
             While[ reducible =!= {},
                    
                    ii = First[reducible];
                    reducible = Rest[reducible];
                    
                    If[ verboseLevel >= 3,
                        Print["> Reducing current base poly ", ii];
                    ];

                    (* Reduce candidate *)
                    Gii = ReduceSPolynomial[Delete[G,ii],G[[ii]],labels,
                                            symbolicCoefficients,verboseLevel];

                    (* Remove obstructions involving G[ii] *)
                    OBS = Delete[OBS,
                                 Position[OBS[[All,1]], ii][[All,{1}]]];

                    (* Adjust index in OBS *)
                    index = Insert[Range[m-1], 0, ii];
                    OBS[[All,1,1]] = index[[OBS[[All,1,1]]]];
                    OBS[[All,1,2]] = index[[OBS[[All,1,2]]]];

                    (* Adjust index in reducible *)
                    reducible = index[[reducible]];

                    (* Remove element ii from base *)
                    G = Delete[G, ii];
                    TG = Delete[TG, ii];
                    m -= 1;
                    mm -= 1;
                    
                    If[ PossibleZeroQ[Gii],
                        
                        (* Completely reduced, remove *)
                        
                        If[ verboseLevel >= 3,
                            Print["> Poly ", ii, " reduced to zero; removing from base"];
                        ];
                        
                       ,
                        
                        (* Remainder found, add to base *)
                        
                        If[ verboseLevel >= 3,
                            Print["> Poly ", ii, 
                                  " does not reduce to zero;",
                                  " remainder added to base"];
                        ];
                        
                        (* Does Gii divide any poly in the basis? *)
                        mreducible = Pick[Range[m], 
                                          Map[(First[NCPolyReduce[#, 
                                            NCPolyLeadingMonomial[Gii]]]=!={})&,
                                              TG]];
                        
                        (* Add divisible polys to reducible list *)
                        reducible = Union[reducible, mreducible];
                        
                        (* Add Gii back basis *)
                        {G,TG,OBS,m} = AddToBasis[G,TG,OBS,Gii,labels,
                                                  simplifyOBS,verboseLevel];

                    ];
                    
             ];
                  
         ];
         
        ,

         If[ verboseLevel >= 3,
             Print["* S-Polynomial was completely reduced and has been removed from the set of obstructions"];
         ];

    ];

  ];

  If[ cleanUpBasis,
      (* Cleaning up current basis *)
      If[ verboseLevel >= 1,
          Print["* Cleaning up..."];
      ];
      G = NCPolyNormalize[NCPolyFullReduce[G]];
  ];

  (* Call Together if symbolic coefficients *)
  If[ symbolicCoefficients,
      G = Map[NCPolyTogether, G];
  ];
      
  If[ OBS =!= {}
     ,
      Message[NCPolyGroebner::Interrupted, Length[G]];
     ,
      If[ verboseLevel >= 1,
          Print["* Found Groebner basis with ", 
                ToString[Length[G]], 
                " polynomials"];
      ];
  ];
      
  If[ verboseLevel >= 1,
      Print["* * * * * * * * * * * * * * * *"];
  ];
      
  Return[G];
];

End[];
EndPackage[]
