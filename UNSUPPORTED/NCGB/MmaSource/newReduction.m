(* :Title:      Reduce.m // Mathematica 2.0				*)
(* :Author: 	Victor Shih (vshih)					*)
(* :Context: 	*)
(* :Summary:	*)
(* :Alias:	*)
(* :Warnings:	*)
(* :History:	*)

BeginPackage["Reduce`", "Global`","Errors`"];

Clear[Reduction];

Reduction::usage =
  "Reduction[{Polynomial, ...}, {Groebner Rule, ...}]\
   substitutes into the given Polynomials using the \
   given Groebner Rules. Also, \
   Reduction[{Polynomial, ...},{anInteger, ...}]\
   substitutes into the given Polynomials using the \
   Groebner Rules associated to the given integers."

Clear[FastReduction];

FastReduction::usage =
   "FastReduction[aListOfPolynomials] is the same as\
    Reduction[aListOfPolynomials,WhatIsPartialGB[]]\
    but is much faster.";

Clear[ReduceAlsoUsing];

ReduceAlsoUsing::usage =
     "ReduceAlsoUsing";

Clear[internalReduction];

internalReduction::usage =
   "internalReduction";

Begin["`Private`"];

internalReduction[Global`GBMarker[polyC_Integer,"polynomials"],
                  Global`GBMarker[ruleC_Integer,"rules"]] :=
  Global`ReduceUsingMarkers[polyC,ruleC];

Reduction[Poly_List,Rules:{___Rule}] :=
Module[{polyM,ruleM,ansM,result},
  polyM = Global`sendMarkerList["polynomials",Poly];
  ruleM = Global`sendMarkerList["rules",Rules];
  ansM = internalReduction[polyM,ruleM];
  result = Global`RetrieveMarker[ansM];
  Global`DestroyMarker[{polyM,ruleM,ansM}];
  Return[result];
];

FastReduction[Poly_List] :=
Module[{polyM,ansM,result},
  polyM = Global`sendMarkerList["polynomials",Poly];
  ansM = FastReduction[polyM];
  result = Global`RetrieveMarker[ansM]; 
  Global`DestroyMarker[{polyM,ansM}];
  Return[result];
];

FastReduction[polyM:GBMarker[n_,"polynomials"]] :=
Module[{ruleM,ansM},
  ruleM = Global`transferPartialGBTo[];
  ansM = internalReduction[polyM,ruleM];
  Global`DestroyMarker[ruleM];
  Return[ansM];
];

Reduction[x___] := BadCall["Reduction",x];

End[];
EndPackage[]
