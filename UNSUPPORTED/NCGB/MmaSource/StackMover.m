Clear[StackMover];
Clear[StackUp];
Clear[StackDown];
Clear[StackHere];

StackMover[] := 
Block[{i,item,count},
  BadStack[] = Stack[];
Print[BadStack[]];
  Map[(BadStack[#] = Stack[#];Print[#,BadStack[#]])&,Union[BadStack[]]];
  stackNumber = Length[BadStack[]];
  items = {};
  Clear[count];
  Do[ item = BadStack[][[i]];
      If[MemberQ[items,item]
        , count[item] = count[item] + 1;
        , count[item] = 1;
          AppendTo[items,item];
      ];
      stackItem[i] = BadStack[item][[count[item]]];
  ,{i,1,Length[BadStack[]]}];
  Clear[count];
];

StackUp[] := StackUp[1];
StackDown[] := StackDown[1];

StackUp[n_] := (stackNumber = Max[1,stackNumber+n];StackHere[];);
StackDown[n_] := (stackNumber = Min[Length[Stack[]],stackNumber+n];
                  StackHere[];);

StackHere[] := Print[stackNumber,":",stackItem[stackNumber]];
