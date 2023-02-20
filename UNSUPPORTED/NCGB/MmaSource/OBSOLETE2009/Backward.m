If[Not[$NCGB$Summer1999$Setup]
  ,
PolynomialsToGBRules[L_List] := Map[PolynomialToGBRule,L];
];
