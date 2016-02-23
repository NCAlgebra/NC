Clear[RelationsInOrder];
Clear[relationsInOrder];

RelationsInOrder[aList_List,opts___] := 
Module[{anArray,ans,theNumbers,i,num},
  CreateCategories[aList,anArray];
  ans = anArray["singleRules"];
  ans = Join[ans,relationsInOrder[anArray,0]];
  ans = Join[ans,anArray["userSelects"]];
  theNumbers = anArray["numbers"];
  Do[  num = theNumbers[[i]];
       If[Not[num===0]
         , ans = Join[ans,relationsInOrder[anArray,num]];
       ];
  ,{i,1,Length[theNumbers]}];
  Clear[anArray];
  Return[ans];
];

RelationsInOrder[x___] := BadCall["RelationsInOrder",x];

relationsInOrder[anArray_Symbol,n_Integer] :=
Module[{aMono,ans,shouldAdd,monomials,j},
  monomials = anArray[n];
  ans = {};
  Do[ aMono = monomials[[j]];
      shouldAdd = True;
      If[Length[anArray[aMono]]===1
          , If[MemberQ[anArray["singleRules"],anArray[aMono][[1]]]
              , shouldAdd = False;
            ];
      ];
      ans = Join[ans,anArray[aMono]];
  ,{j,1,Length[monomials]}];
  Return[ans];
];

relationsInOrder[x___] := BadCall["RelationsInOrder",x];
