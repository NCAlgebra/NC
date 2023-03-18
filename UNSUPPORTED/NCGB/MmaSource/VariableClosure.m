
VariableClosure[StartSet_List,Additional_List] :=
Module[{add,totalvars,result,remaining,shouldLoop,i,temp},
  totalvars = Grabs`GrabIndeterminants[StartSet];
  result = StartSet;
  remaining = Additional;
  shouldLoop = True;
  While[shouldLoop
    , Clear[temp];
      Do[ temp[i] = Select[remaining,Not[FreeQ[#,totalvars[[i]]]]&];
          If[Not[Length[temp[i]]===0]
             , remaining = Complement[remaining,temp[i]];
               totalvars = Union[totalvars,
                                 Grabs`GrabIndeterminants[temp[i]]];
          ];
      ,{i,1,Length[totalvars]}];
      add = Flatten[Table[temp[i],{i,1,Length[totalvars]}]];
      result = Union[result,add];
      shouldLoop = Length[add]>0;
  ];
  Clear[temp];
  Return[result];
];

VariableClosure[x___] := BadCall["VariableClosure",x];
