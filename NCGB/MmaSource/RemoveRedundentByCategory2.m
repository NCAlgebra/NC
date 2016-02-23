
RemoveRedundentByCategory[] := 
Module[{hist,fullhist,kpoly},
  fullhist = WhatIsHistory[WhatAreNumbers[]];
  hist = WhatIsHistory[WhatAreGBNumbers[]];
  kpoly = Map[(#[[2]])&,hist];
  Return[RemoveRedundentByCategory[kpoly,fullhist]];
];

RemoveRedundentByCategory[kpoly_List,history_List] := 
Module[{dummy,cats,digested,lump,smalllump,
        digPlusCat,i,j,poly,theNumbers,result},
  CreateCategories[kpoly,dummy];
  cats = dummy["AllCategories"];
  digested=Union[dummy["singleRules"],dummy[{}]];
  digestedNumbers = Flatten[Map[NumbersFromHistory[#,history]&,digested]];
  smalldigestedNumbers = RemoveRedundent[digestedNumbers,history,
                RemoveRedundentUseNumbers->True,
                RemoveRedundentProtected->{}];
  lump = smalldigestedNumbers;
  Print["About to do ",Length[cats],
        " iterations in RemoveRedundentByCategory."];
  Do[ If[i==Length[cats]
           , WriteString[$Output,ToString[i]];
           , WriteString[$Output,ToString[i],","];
      ];
      newCat = GetCategories[cats[[i]],dummy];
      Put[newCat,"newCat"<>ToString[i]];
      If[Not[digPlusCat===digested]
         , theNumbers = Flatten[Map[NumbersFromHistory[#,history]&,digested]];
           Put[theNumbers,"theNumbers"<>ToString[i]];
           smalllump = RemoveRedundent[theNumbers,history,
                RemoveRedundentProtected->smalldigestedNumbers,
                RemoveRedundentUseNumbers->True];
           lump = Union[lump,smalllump];
           result = Map[(#[[2]])&,WhatIsHistory[smalllump]];
           Put[result,"result"<>ToString[i]];
(*
     file=StringJoin["demoData/lump",ToString[i]];
     RegularOutput[result,file];
*)
     ];
  ,{i,Length[cats]}];
  result = Map[(#[[2]])&,WhatIsHistory[lump]];
  Put[result,"finalResult"];
  Return[result];
];


