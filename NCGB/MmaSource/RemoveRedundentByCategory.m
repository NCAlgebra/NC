RemoveRedundentByCategory[] := 
Module[{fullhist,kpoly},
  fullhist = MoraAlg`WhatIsHistory[WhatAreNumbers[]];
  kpoly = WhatIsPartialGB[];
  Return[RemoveRedundentByCategory[kpoly,fullhist]];
];

RemoveRedundentByCategory[kpoly_List,history_List] := 
Module[{len,dummy,cats,digested,lump,smalllump,cond,
        digPlusCat,i,j,poly,theNumbers,result},
  CreateCategories[kpoly,dummy];
  cats = dummy["AllCategories"];
  AppendTo[cats,{}];
  cats = Union[cats];
  len = Length[cats];
  digested=Union[dummy["singleRules"],dummy[{}]];
  lump = {};
  Print["About to do ",len,
        " iterations in RemoveRedundentByCategory."];
  Do[ If[i==len
           , WriteString[$Output,ToString[i]];
           , WriteString[$Output,ToString[i],","];
      ];
      digPlusCat = Union[digested,GetCategories[cats[[i]],dummy]];
Put[digPlusCat,"digPlusCat"<>ToString[i]];
      cond = Or[cats[[i]]==={},Not[digPlusCat===digested]];
      If[cond,
        theNumbers= {};
        Do[ poly = digPlusCat[[j]];
            theNumbers =  Union[theNumbers,
                                NumbersFromHistory[poly,history]];
       ,{j,1,Length[digPlusCat]}];
Put[theNumbers,"theNumbers"<>ToString[i]];
       smalllump = RemoveRedundent[theNumbers,history,
                                 RemoveRedundentUseNumbers->True];
       lump = Union[lump,smalllump];
       result = Map[(#[[2]])&,MoraAlg`WhatIsHistory[smalllump]];
Put[result,"result"<>ToString[i]];
(*
       file=StringJoin["demoData/lump",ToString[i]];
       RegularOutput[result,file];
*)
    ,  (* Nothing *)
    ,  Print["OOPS:",cond]; 
       Abort[];
   ];
  ,{i,len}];
  result = Map[(#[[2]])&,MoraAlg`WhatIsHistory[lump]];
Put[result,"finalResult"];
  Return[result];
];

RemoveRedundentByCategory[x___] := 
       BadCall["RemoveRedundentByCategory",x];
