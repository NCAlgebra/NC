BeginPackage["NCNagyFoias`",
             "Inequalities`",
             "Grabs`",
             "NonCommutativeMultiply`",
             "Global`",
             "Lazy`",
             "Errors`"];

Clear[NCNagyFoias];

NCNagyFoias::usage = "NCNagyFoias[...] usage note not yet written.";

Begin["`Private`"];

rules = {
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower1_], LazyPower[Inv[1 - (x_)], FixLazyPower2_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower2] + LazyPower[x, -1 + FixLazyPower1] ** LazyPower[Inv[1 - x], FixLazyPower2]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower1 >= 1, FixLazyPower2 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower3_], LazyPower[Inv[x_], FixLazyPower4_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[x, -1 + FixLazyPower3] ** LazyPower[Inv[x], -1 + FixLazyPower4]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower3 >= 1, FixLazyPower4 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower5_], LazyPower[x_, FixLazyPower6_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower5] ** LazyPower[x, -1 + FixLazyPower6] + LazyPower[Inv[1 - x], FixLazyPower5] ** LazyPower[x, -1 + FixLazyPower6]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower5 >= 1, FixLazyPower6 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower7_], LazyPower[Inv[x_], FixLazyPower8_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower7] ** LazyPower[Inv[x], FixLazyPower8] + LazyPower[Inv[1 - x], FixLazyPower7] ** LazyPower[Inv[x], -1 + FixLazyPower8]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower7 >= 1, FixLazyPower8 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower9_], LazyPower[x_, FixLazyPower10_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower9] ** LazyPower[x, -1 + FixLazyPower10]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower10 >= 1, FixLazyPower9 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower11_], LazyPower[Inv[1 - (x_)], FixLazyPower12_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower11] ** LazyPower[Inv[1 - x], FixLazyPower12] + LazyPower[Inv[x], FixLazyPower11] ** LazyPower[Inv[1 - x], -1 + FixLazyPower12]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower11 >= 1, FixLazyPower12 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower13_], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower14_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], FixLazyPower13] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower14] + LazyPower[Inv[x], -1 + FixLazyPower13] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], FixLazyPower14]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower13 >= 1, FixLazyPower14 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[y_], FixLazyPower15_], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower16_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[y], FixLazyPower15] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower16] + LazyPower[Inv[y], -1 + FixLazyPower15] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], FixLazyPower16]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower15 >= 1, FixLazyPower16 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower17_], LazyPower[x_, FixLazyPower18_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x ** y], -1 + FixLazyPower17] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower18]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower17 >= 1, FixLazyPower18 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower19_], LazyPower[Inv[y_], FixLazyPower20_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x ** y], -1 + FixLazyPower19] ** LazyPower[Inv[y], FixLazyPower20] + LazyPower[Inv[1 - x ** y], -1 + FixLazyPower19] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[Inv[y], -1 + FixLazyPower20]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower19 >= 1, FixLazyPower20 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower21_], LazyPower[y_, FixLazyPower22_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y ** x], -1 + FixLazyPower21] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower22]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower21 >= 1, FixLazyPower22 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower23_], LazyPower[Inv[x_], FixLazyPower24_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y ** x], -1 + FixLazyPower23] ** LazyPower[Inv[x], FixLazyPower24] + LazyPower[Inv[1 - y ** x], -1 + FixLazyPower23] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[Inv[x], -1 + FixLazyPower24]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower23 >= 1, FixLazyPower24 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower25_], LazyPower[y_, 1], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower26_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower25] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower26] + LazyPower[x, -1 + FixLazyPower25] ** LazyPower[Inv[1 - x ** y], FixLazyPower26]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower25 >= 1, FixLazyPower26 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower27_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (x_)], FixLazyPower28_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower27] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], -1 + FixLazyPower28] + LazyPower[x, -1 + FixLazyPower27] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], FixLazyPower28]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower27 >= 1, FixLazyPower28 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower29_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (y_)], FixLazyPower30_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower29] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Inv[1 - y], FixLazyPower30] + LazyPower[x, -1 + FixLazyPower29] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - y], FixLazyPower30] + LazyPower[x, FixLazyPower29] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower30]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower29 >= 1, FixLazyPower30 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower31_], LazyPower[x_, 1], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower32_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower31] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower32] + LazyPower[y, -1 + FixLazyPower31] ** LazyPower[Inv[1 - y ** x], FixLazyPower32]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower31 >= 1, FixLazyPower32 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower33_], LazyPower[Inv[1 - (x_) ** (y_)], m_], LazyPower[Inv[1 - (y_)], FixLazyPower34_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower33] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], -1 + FixLazyPower34] + LazyPower[y, -1 + FixLazyPower33] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], FixLazyPower34]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower33 >= 1, FixLazyPower34 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower35_], LazyPower[Inv[1 - (x_) ** (y_)], n_], LazyPower[Inv[1 - (x_)], FixLazyPower36_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower35] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Inv[1 - x], FixLazyPower36] + LazyPower[y, -1 + FixLazyPower35] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - x], FixLazyPower36] + LazyPower[y, FixLazyPower35] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower36]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower35 >= 1, FixLazyPower36 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower37_], LazyPower[y_, 1], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower38_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], FixLazyPower37] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower38] + LazyPower[Inv[1 - x], FixLazyPower37] ** LazyPower[Inv[1 - x ** y], FixLazyPower38] + LazyPower[Inv[1 - x], -1 + FixLazyPower37] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], FixLazyPower38]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower37 >= 1, FixLazyPower38 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower39_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (x_)], FixLazyPower40_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower39] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - x], FixLazyPower40] - LazyPower[Inv[1 - x], FixLazyPower39] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], -1 + FixLazyPower40] + LazyPower[Inv[1 - x], FixLazyPower39] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], FixLazyPower40]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower39 >= 1, FixLazyPower40 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower41_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (y_)], FixLazyPower42_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower41] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower42] + LazyPower[Inv[1 - x], -1 + FixLazyPower41] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], FixLazyPower42] - LazyPower[Inv[1 - x], FixLazyPower41] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Inv[1 - y], FixLazyPower42] + LazyPower[Inv[1 - x], FixLazyPower41] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - y], FixLazyPower42] + LazyPower[Inv[1 - x], FixLazyPower41] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower42]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower41 >= 1, FixLazyPower42 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower43_], LazyPower[x_, 1], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower44_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], FixLazyPower43] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower44] + LazyPower[Inv[1 - y], FixLazyPower43] ** LazyPower[Inv[1 - y ** x], FixLazyPower44] + LazyPower[Inv[1 - y], -1 + FixLazyPower43] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], FixLazyPower44]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower43 >= 1, FixLazyPower44 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower45_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (y_)], FixLazyPower46_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], -1 + FixLazyPower45] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - y], FixLazyPower46] + LazyPower[Inv[1 - y], FixLazyPower45] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - y], FixLazyPower46] + LazyPower[Inv[1 - y], FixLazyPower45] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], -1 + FixLazyPower46]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower45 >= 1, FixLazyPower46 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower47_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (x_)], FixLazyPower48_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y], -1 + FixLazyPower47] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower48] - LazyPower[Inv[1 - y], -1 + FixLazyPower47] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], FixLazyPower48] - LazyPower[Inv[1 - y], FixLazyPower47] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower48] + LazyPower[Inv[1 - y], FixLazyPower47] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], FixLazyPower48] + LazyPower[Inv[1 - y], FixLazyPower47] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Inv[1 - x], FixLazyPower48]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower47 >= 1, FixLazyPower48 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower49_], LazyPower[x_, 1], LazyPower[y_, FixLazyPower50_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x ** y], -1 + FixLazyPower49] ** LazyPower[y, -1 + FixLazyPower50] + LazyPower[Inv[1 - x ** y], FixLazyPower49] ** LazyPower[y, -1 + FixLazyPower50]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower49 >= 1, FixLazyPower50 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower51_], LazyPower[y_, 1], LazyPower[x_, FixLazyPower52_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y ** x], -1 + FixLazyPower51] ** LazyPower[x, -1 + FixLazyPower52] + LazyPower[Inv[1 - y ** x], FixLazyPower51] ** LazyPower[x, -1 + FixLazyPower52]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower51 >= 1, FixLazyPower52 >= 1}\
]};


FactQ[x_] := Inequalities`InequalityFactQ[x];

NCNagyFoias[0] := 0;

NCNagyFoias[expr_] := expr//.rules;

NCNagyFoias[x___] := BadCall["NCNagyFoias",x];


End[];
EndPackage[]
