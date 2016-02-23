complicate[aRule_Rule] := preTransform[NCMonomial[complicated]];

complicate[x_] := complicate[NCGBConvert[x]];

tinyReduction[aListOfData_List,aListToReduceBy_List] :=
Module[{ToReduceBy,new,old},
     ToReduceBy = Flatten[Map[complicate,aListToReduceBy]];
Print["About to more on ToReduceBy"];
more[ToReduceBy];
     new = aListOfData; 
     old = Null;
     While[Not[new===old], 
               old = new;
               new = new//.ToReduceBy;
               new = ExpandNonCommutativeMultiply[new];
     ];
     Return[new];
];

ReduceUsingWavrik[someData_List,{aNumber_?NumberQ}] :=
   ReduceUsingWavrik[someData,{1,aNumber}];

ReduceUsingWavrik[someData_List,aNumber_?NumberQ] :=
   ReduceUsingWavrik[someData,{1,aNumber}];

ReduceUsingWavrik[someData_List,{aNumber_?NumberQ,anotherNumber_?NumberQ}] :=
   ReduceWavrikAux[someData,Range[aNumber,anotherNumber]];

ReduceWavrikAux[x_,y_] := tinyReduction[x,Map[Rel,y]];
