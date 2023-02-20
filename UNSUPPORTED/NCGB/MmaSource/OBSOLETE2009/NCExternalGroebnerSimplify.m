Clear[NCExternalGroebnerSimplify];

NCExternalGroebnerSimplify[toReduce_,aList_List,iter_?NumberQ] := 
GroebnerSimplify[{n,i,result,toreduce},
  toreduce = Flatten[{toReduce}];
  Run["rm ncexternalgroebnersimplify.multiplicity"];
  Run["rm ncexternalgroebnersimplify.inputfile"];
  Run["rm ncexternalgroebnersimplify.toreducefile"];
  Run["rm ncexternalgroebnersimplify.outputfile"];
  Run["rm ncexternalgroebnersimplify.numberofsteps"];

  n = WhatIsMultiplicityOfGrading[];
  Put[n,"ncexternalgroebnersimplify.multiplicity"];
  Do[ Put[WhatIsSetOfIndeterminants[i],
          "ncexternalgroebnersimplify.order."<>ToString[i]];
  ,{i,1,n}];
  Put[aList,"ncexternalgroebnersimplify.inputfile"];
  Put[toreduce,"ncexternalgroebnersimplify.toreduce"];
  Put[iter,"ncexternalgroebnersimplify.numberofsteps"];

  Run["math < ncexternalgroebnersimplify.mora.file"]; 

  result = Get["ncexternalgroebnersimplify.outputfile"];
  Return[result];
];

NCExternalGroebnerSimplify[x___] :=  
       BadCall["NCExternalGroebnerSimplify",x];
