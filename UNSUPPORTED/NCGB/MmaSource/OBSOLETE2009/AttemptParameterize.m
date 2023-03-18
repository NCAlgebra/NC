
Clear[AttemptParameterize];
Clear[AttemptParameterizeAux];

AttemptParameterize[data_,vars_List,
                    iter_Integer,extraRels_List] :=
Module[{newdata,dummy,result,newvars,newrels,saveit,j,len,k},
  newdata = Flatten[{data}];

  Clear[dummy];
  dummy["newsides"] = {};
  AttemptParameterizeAux[newdata,vars,dummy];
  newvars = Flatten[Map[dummy[#,"variables"]&,newdata]];
  newrels = Flatten[Map[dummy[#,"newrelations"]&,newdata]];
  newrels = Join[newrels,newdata];
  Clear[dummy];

  (* Save old order *)
  Clear[saveit];
  len = WhatIsMultiplicityOfGrading[];
  Do[ saveit[j] = WhatIsSetOfIndeterminants[j];
  ,{j,1,len}];

  (* set the new order *)
  ClearMonomialOrderAll[];
  Apply[SetKnowns,saveit[1]];
  Table[SetMonomialOrder[{newvars[[j]]},1+j],{j,1,Length[newvars]}];
  k = 1 + Length[newvars] + 10;
  Do[SetMonomialOrder[saveit[j],k+j];
  ,{j,2,len}];

  result = NCMakeGB[newrels,iter];
  RegularOutput[result,"junk"];
   
  (* Restore the order the way it was *)
  ClearMonomialOrderAll[];
  Do[ SetMonomialOrder[saveit[j],j];
  ,{j,1,len}];
 
  Clear[saveit];

  Return[result];
];

AttemptParameterize[x___] := BadCall["AttemptParameterize",x];

AttemptParameterizeAux[aList_List,vars_List,symbol_Symbol] :=
  Map[AttemptParameterizeAux[#,vars,symbol]&,aList];

AttemptParameterizeAux[aPolynomial_,vars_List,symbol_Symbol] := 
Module[{sides,j,newvars},
  sides = NCGrabSides[aPolynomial,vars];
  sides = Union[Flatten[sides]];
  sides = Map[AttemptParameterizeNormalize,sides];
  sides = Complement[sides,{1}];
  sides = Select[sides,(Head[#]===Plus ||
                        Head[#]===Times||
                        Head[#]===NonCommutativeMultiply)&];
  sides = Union[sides];
  sides = Complement[sides,symbol["newsides"]];
  symbol["newsides"] = Join[symbol["newsides"],sides];
  len = Length[sides];
  newvars = Table[Unique["side"],{j,1,len}];
  symbol[aPolynomial,"variables"] = newvars;
  Apply[SNC,newvars];
  symbol[aPolynomial,"newrelations"] = 
       Table[newvars[[j]]-sides[[j]],{j,1,len}];
];

AttemptParameterizeAux[x___] := BadCall["AttemptParameterizeAux",x];

Clear[AttemptParameterizeNormalize];

AttemptParameterizeNormalize[x_Plus] := x/LeadingCoefficient[x[[1]]];

AttemptParameterizeNormalize[x_] := x/LeadingCoefficient[x];

AttemptParameterizeNormalize[x___] := BadCall["AttemptParameterizeNormalize",x];
