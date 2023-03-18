GrbIt[fileName_String,n_] := 
Module[{ans},
  SetGlobalPtr[];
  SetOrderFromGrbFile[fileName];
  PrintMonomialOrder[];
  StartingRelationsFromGrbFile["ex1.rel"];
  SetIterations[n];
  MoraRun[];
  ans = WhatIsPartialGB[];
  Global`RegularOutput[ans,fileName,"Mma"];  
  Return[ans];
];
