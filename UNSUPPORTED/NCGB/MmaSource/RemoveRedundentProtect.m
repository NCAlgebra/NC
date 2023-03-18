Clear[RemoveRedundentProtect];
RemoveRedundentProtect[]:=
   RemoveRedundentProtect[WhatIsPartialGB[],WhatIsHistory[WhatAreNumbers[]]];
(*
RemoveRedundentProtect[fc:GBMarker[_Integer,"factcontrol"],nums_GBMarker]:=
Module[{result,knowns,digested,knownsnumbers,digestednumbers,ints,rules},
Print["Calling RemoveRedundentProtect!!!!"];
   knowns=knownRelations[fc,nums];     
Print["MXS12:knowns"];
PrintMarker[knowns];

   digested=DigestedRelations[fc,nums];
Print["MXS13:digested",digested];
PrintMarker[digested];
   (* knowns and digested are markers of rules *)

   knownsnumbers=NumbersFromRuleMarker[fc,knowns];
   digestednumbers=NumbersFromRuleMarker[fc,digested];
   (* knownsnumbers and digestednumbers are markers of integers *)
Print["MXS14"];
   ints=CPPRemoveRedundent[fc,knownsnumbers]; 
   ints=Union[ints,CPPRemoveRedundent[fc,digestednumbers]]; 
   ints=Union[ints,CPPRemoveRedundent[fc,nums]]; 
   (* ints is a list of integers *)

   rules=CopyMarker[fc,"rules"];
   result=MarkerTake[rules,ints];
   (* rules and result are markers of rules *)

   DestroyMarker[{knowns,digested,knownsnumbers,digestednumbers,rules}];
   Return[result];
];
*)

RemoveRedundentProtect[fc:GBMarker[_Integer,"factcontrol"],
     nums:GBMarker[_Integer,"integers"]]:=
Module[{rules,result,hist},
   rules = RulesFromFCAndNumbers[fc,nums];
   hist  = HistoryOfFactControlMarker[fc];
   result = RemoveRedundentProtect[rules,hist];
   result = PolynomialsToGBRules[result];
   result = ListToMarker[result,"rules"];
   Return[result];
];

RemoveRedundentProtect[polys_List,hist_List]:=
Module[{dummy,result},
   CreateCategories[polys,dummy];
   result = RemoveRedundent[dummy[{}],hist];
   result = Union[result,RemoveRedundent[
                            GetCategories["Digested",dummy],hist]];
   result = Union[result,RemoveRedundent[polys,hist]];
   Clear[dummy];
   Return[result];
];
  
RemoveRedundentProtect[x___]:= BadCall["RemoveRedundentProtect",x];
