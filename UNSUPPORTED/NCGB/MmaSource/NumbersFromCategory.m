(* Takes polynomials and gives associatied numbers *)

Clear[NumbersFromHistory];

NumbersFromHistory[aPolynomial_,history_] := 
Module[{result,i,aRule},
  result = {};
  aRule = ToGBRule[aPolynomial];
  Do[ If[ToGBRule[history[[i,2]]]==aRule, 
             AppendTo[result,history[[i,1]]]
        ];
  ,{i,1,Length[history]}];
  Return[result];
];

NumbersFromHistory[x___] :=  BadCall["NumbersFromHistory",x];
