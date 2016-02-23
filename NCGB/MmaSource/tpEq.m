
tpEq[x:(_List | _Equal | _Rule  | Plus | Times),
     opts___Rule] := Map[tpEq[#,opts]&,x];

tpEq[x_NonCommutativeMultiply] :=
Module[{y},
  y = Apply[List,x];
  y = Reverse[y];
  Return[Apply[NonCommutativeMultiply,y]];
];

tpEq[tp[x_]] := x;

tpEq[c_?Number] := c;

tpEq[x_] := tp[x];
