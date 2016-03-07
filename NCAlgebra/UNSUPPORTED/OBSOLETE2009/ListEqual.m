ListEqual[aList_List,anotherList_List] :=
Module[{len,result},
   len = Length[aList];
   If[Length[anotherList]===len
         , result = Table[ListEqual[aList[[j]],anotherList[[j]]],{j,1,len}];
   
         , result = False;
    ];
    Return[result];
];

ListEqual[x_,y_] := x==y;
    
