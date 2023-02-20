RRBC[fc:GBMarker[n_Integer,"factcontrol"]]:= 
Module[{junk,temp,knownsMarker,otherCategories,combinedMarker,
        result,DOIT,len,i},
  Clear[junk];
  CreateCategories[junk];
 
  (* Obtain the knowns as a list of rules *)
  temp = GetCategory[{},junk];
  knownsMarker = CopyMarker[temp,"rules"];
  DestroyMarker[temp];

  (* Obtain the names of the other categories *)
  otherCategories = GetCategory["AllCategories",junk];
  otherCategories = Complement[otherCategories,{{}}];

  (* coming the single rules with the knowns *)
  temp = sendMarkerList["rules",GetCategory["singleRules",junk]];
  AppendMarker[combinedMarker,temp];
  DestroyMarker[temp];

  Print["About to do RR on knowns and rules"];

  result = fastRemoveRedundent[fc,combinedMarker];
  Print["About to do ",Length[otherCategories]," iterations in RRBC."];
  Print["Combined Marker is:"];
  PrintMarker[combinedMarker];

  DOIT[baseMarker_,variables_,symbol_Symbol] := 
  Module[{digPlusCat},
     digPlusCat = CopyMarker[baseMarker,"rules"];
     Global`AppendMarker[digPlusCat,GetCategories[variables,symbol]];
     Print["digPlusCat Marker is:"];
     PrintMarker[digPlusCat];
     Print["Done with digPlusCat output"];

     remainNumbers = fastRemoveRedundent[fc,digPlusCat];
     DestoryMarker[digPlusCat];
     Return[remainNumbers];
  ];
 
  len = Length[otherCategories];
  Do[ result = {result,DOIT[combinedMarker,otherCategories[[i]],junk]};
      WriteString[$Output,ToString[i],","];
  ,{i,len-1}];
  If[len>0
    , result={result,DOIT[combinedMarker,otherCategories[[-1]],junk]};
  ];
  result = Union[Flatten[result]];
  Clear[junk,DOIT];
  Return[result];
];

RRBC[x___]:=  BadCall["RRBC",x];
