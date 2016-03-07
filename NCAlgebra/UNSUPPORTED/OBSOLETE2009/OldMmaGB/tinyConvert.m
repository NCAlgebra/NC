Module[{complicate,j},
     complicate[aRule_Rule] := preTransform[NCMonomial[aRule]];
     complicate[x___] := BadCall["complicate",x];
     Do[ Print["Processing relation ",j];
         RuleRel[j] = complicate[NCGBConvert[Rel[j]][[1]]];
     ,{j,1,TOPRel}];
     Return[];
];


