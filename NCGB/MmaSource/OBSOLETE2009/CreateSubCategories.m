
unExp[x_NonCommutativeMultiply] :=
Module[{aList,i},
  aList = {};
  Do[ If[Not[x[[i]] === aList[[-1]]]
          , AppendTo[aList,x[[i]]];
      ];
  ,{i,1,Length[x]}];
  return[aList];
];

unExp[x_] := x;

unExp[x_NonCommutativeMultiply] :=
Module[{aList,i,numList},
  aList = {};
  numList = {};
  Do[ If[Not[x[[i]] === aList[[-1]]]
          , AppendTo[aList,x[[i]]];
            AppendTo[numList,1];
          , numList[[-1]] = numList[[-1]] + 1;
      ];
  ,{i,1,Length[x]}];
  return[numList];
];

unExp[x___] := BadCall["unExp",x];

unBase[x_] := 1;

unBase[x___] := BadCall["unBase",x];

CreateSubCategories[aList_List,relations_Symbol] :=
Module[{dom,item,i},
  Clear[relations];
  Clear[dom];
  relations[_] := {};
  Do[ item = ToGBRule[aList[[i]]]; 
     dom[i] = unExp[item[[1]]];
     AppendTo[relations[dom[i]],item];
  ,{i,1,Length[aList]}];
  relations["domain"] = Union[Table[dom[i],{i,1,Length[aList]}]];
  Return[relations];
];

CreateSubCategories[x___] := BadCall["CreateSubCategories",x];
