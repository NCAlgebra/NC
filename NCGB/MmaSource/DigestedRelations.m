
DigestedRelations[fc:Global`GBMarker[_Integer,"factcontrol"],
                  ints:Global`GBMarker[_Integer,"integers"] ] :=
Module[{us,kr},
  us = userSelects[];
  kr = knownRelations[fc,ints];
  AppendMarker[kr,us];
  DestroyMarker[us];
  Return[kr];
];

DigestedRelations[aListOfPolynomials_List] :=
Module[{result,dummy},
  CreateCategories[aListOfPolynomials,dummy];
  result = GetCategories["Digested",dummy];
  Clear[dummy];
  Return[result];
];

DigestedRelations[x___] := BadCall[DigestedRelations,x];
