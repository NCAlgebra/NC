
Clear[linearConvert];

linearConvert[x_Equal] := linearConvert[x[[1]]->x[[2]]];

linearConvert[True] := 0->0;

linearConvert[aRule_Rule] :=
Module[{poly,theTerms,term,lead,otherterms,result},
     poly = aRule[[1]] - aRule[[2]];
     If[Head[poly]===Plus
          , theTerms =  Apply[List,poly];
            theTerms = Sort[theTerms];
            term = theTerms[[-1]];
            lead = LeadingCoefficient[term];
            term = term/lead;
            otherterms = Drop[theTerms,{-1}];
            otherterms = -otherterms/lead;
            otherterms = Apply[Plus,otherterms];
            result = term->otherterms;
          , result = NormalizeCoefficient[poly]->0;
     ];
     Return[{result}];
];

linearConvert[x___] := BadCall["linearConvert",x];
(*
linearConvert[x___] := smallConvert[x];
*)
