Clear[NCExternalMakeRules];

NCExternalMakeRules[aList_List,iter_?NumberQ] := 
Module[{n,i,result},
  Run["rm ncexternalmakerules.multiplicity"];
  Run["rm ncexternalmakerules.inputfile"];
  Run["rm ncexternalmakerules.outputfile"];
  Run["rm ncexternalmakerules.numberofsteps"];

  n = WhatIsMultiplicityOfGrading[];
  Put[n,"ncexternalmakerules.multiplicity"];
  Do[ Put[WhatIsSetOfIndeterminants[i],
          "ncexternalmakerules.order."<>ToString[i]];
  ,{i,1,n}];
  Put[aList,"ncexternalmakerules.inputfile"];
  Put[iter,"ncexternalmakerules.numberofsteps"];

  Run["math < ncexternalmakerules.mora.file"]; 

  result = Get["ncexternalmakerules.outputfile"];
  Return[result];
];

NCExternalMakeRules[x___] :=  BadCall["NCExternalMakeRules",x];

