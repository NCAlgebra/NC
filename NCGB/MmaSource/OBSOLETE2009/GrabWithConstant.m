
GrabWithConstant[aList_List] :=
Module[{const,result,test,i},
  test = Map[Grabs`GrabIndeterminants,aList];
  result = {};
  Do[ const = aList[[i]]/.Map[(#->0)&,test];
      If[Not[const===0], AppendTo[result,aList[[i]]];];
  ,{i,1,Length[aList]}];
  Return[result];
];

GrabWithConstant[x___] := BadCall["GrabWithConstant",x];

GrabWithOutConstant[aList_List] := 
    Complement[aList,GrabWithConstant[aList]];

GrabWithOutConstant[x___] := BadCall["GrabWithOutConstant",x];
