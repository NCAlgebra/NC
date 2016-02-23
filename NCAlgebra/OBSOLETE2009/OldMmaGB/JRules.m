BeginPackage["JRules`",
             "Inequalities`",
             "Grabs`",
             "NonCommutativeMultiply`",
             "Global`",
             "Lazy`",
             "Errors`"];

Clear[JRules];

JRules::usage = "JRules[...] usage note not yet written.";

Begin["`Private`"];

rules = {
LazyPower[OperatorSignature[1 - x ** y], FixLazyPower1_]\
:> \
LazyPower[OperatorSignature[1 - x ** y], -2 + FixLazyPower1]\
 /; Inequalities`InequalityFactQ[\
{FixLazyPower1 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - x ** y], FixLazyPower1_]\
,back___]] :> \
front**(\
LazyPower[OperatorSignature[1 - x ** y], -2 + FixLazyPower1]\
)**back /; Inequalities`InequalityFactQ[\
{FixLazyPower1 >= 2}\
],
LazyPower[OperatorSignature[1 - y ** x], FixLazyPower2_]\
:> \
LazyPower[OperatorSignature[1 - y ** x], -2 + FixLazyPower2]\
 /; Inequalities`InequalityFactQ[\
{FixLazyPower2 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - y ** x], FixLazyPower2_]\
,back___]] :> \
front**(\
LazyPower[OperatorSignature[1 - y ** x], -2 + FixLazyPower2]\
)**back /; Inequalities`InequalityFactQ[\
{FixLazyPower2 >= 2}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - y ** x], FixLazyPower3_], LazyPower[x, FixLazyPower4_]\
,back___]] :> \
front**(\
LazyPower[OperatorSignature[1 - y ** x], -1 + FixLazyPower3] ** LazyPower[x, 1] ** LazyPower[OperatorSignature[1 - x ** y], 1] ** LazyPower[x, -1 + FixLazyPower4]\
)**back /; Inequalities`InequalityFactQ[\
{FixLazyPower3 >= 1, FixLazyPower4 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - x ** y], FixLazyPower5_], LazyPower[y, FixLazyPower6_]\
,back___]] :> \
front**(\
LazyPower[OperatorSignature[1 - x ** y], -1 + FixLazyPower5] ** LazyPower[y, 1] ** LazyPower[OperatorSignature[1 - y ** x], 1] ** LazyPower[y, -1 + FixLazyPower6]\
)**back /; Inequalities`InequalityFactQ[\
{FixLazyPower5 >= 1, FixLazyPower6 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - x ** y], FixLazyPower7_], LazyPower[x, 1], LazyPower[y, FixLazyPower8_]\
,back___]] :> \
front**(\
LazyPower[OperatorSignature[1 - x ** y], -1 + FixLazyPower7] ** LazyPower[x, 1] ** LazyPower[y, 1] ** LazyPower[OperatorSignature[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower8]\
)**back /; Inequalities`InequalityFactQ[\
{FixLazyPower7 >= 1, FixLazyPower8 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - y ** x], FixLazyPower9_], LazyPower[y, 1], LazyPower[x, FixLazyPower10_]\
,back___]] :> \
front**(\
LazyPower[OperatorSignature[1 - y ** x], -1 + FixLazyPower9] ** LazyPower[y, 1] ** LazyPower[x, 1] ** LazyPower[OperatorSignature[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower10]\
)**back /; Inequalities`InequalityFactQ[\
{FixLazyPower10 >= 1, FixLazyPower9 >= 1}\
]};


FactQ[x_] := Inequalities`InequalityFactQ[x];

JRules[0] := 0;

JRules[expr_] := expr//.rules;

JRules[x___] := BadCall["JRules",x];


End[];
EndPackage[]
