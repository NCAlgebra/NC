
Get["doit"];

supressNone;

SetMonomialOrder[{a,b,p,x},1];

NCMakeGB[{p**a**p - a**p,p**p-p},5,ReturnRelations->False];

Print[WhatAreNumbers[]];
Print[WhatAreGBNumbers[]];
Run["date"];
ans = Global`internalRemoveRedundent[WhatAreGBNumbers[],{1}];
Run["date"];
