GENR[1] := h_[x_**y_]**x_ -> x**h[y**x];
GENR[2] := h_[y_**x_]**Inv[x_] -> Inv[x]**h[x**y];
GENR[3] := x_**(h_[y_**x_])**Inv[1-x_] -> -h[x**y] + h[x**y]**Inv[1-x];
(*
GENR[4] := (Inv[1-x_]**(h_[y_**x_])**Inv[1-x_] -> 
            Inv[1-x]**h[x**y]**Inv[1-x] + 
            h[y**x]**Inv[1-x] - 
            Inv[1-x]**h[x**y] /; ?NCSort[{x,y}] == {x,y};);
*)
GENR[4] := 0->0;
GENRRules = preTransform[Table[GENR[j],{j,1,4}]];

GENRSimplify[expr_] := 
Module[{newexpr,result},
     newexpr = expr;
     result = newexpr//.GENRRules;
     Return[result];
];
