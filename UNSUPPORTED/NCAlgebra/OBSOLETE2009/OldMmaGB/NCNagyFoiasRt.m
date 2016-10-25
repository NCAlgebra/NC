BeginPackage["NCNagyFoiasRt`",
             "Inequalities`",
             "Grabs`",
             "NonCommutativeMultiply`",
             "Global`",
             "Lazy`",
             "Errors`"];

Clear[NCNagyFoiasRt];

NCNagyFoiasRt::usage = "NCNagyFoiasRt[...] usage note not yet written.";

Begin["`Private`"];

rules = {
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower53_]\
:> ExpandNonCommutativeMultiply[\
LazyPower[Rt[1 - x ** y], -2 + FixLazyPower53] - LazyPower[Rt[1 - x ** y], -2 + FixLazyPower53] ** LazyPower[x, 1] ** LazyPower[y, 1]\
] /; Inequalities`InequalityFactQ[\
{FixLazyPower53 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower53_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -2 + FixLazyPower53] - LazyPower[Rt[1 - x ** y], -2 + FixLazyPower53] ** LazyPower[x, 1] ** LazyPower[y, 1]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower53 >= 2}\
],
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower54_]\
:> ExpandNonCommutativeMultiply[\
LazyPower[Rt[1 - y ** x], -2 + FixLazyPower54] - LazyPower[Rt[1 - y ** x], -2 + FixLazyPower54] ** LazyPower[y, 1] ** LazyPower[x, 1]\
] /; Inequalities`InequalityFactQ[\
{FixLazyPower54 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower54_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -2 + FixLazyPower54] - LazyPower[Rt[1 - y ** x], -2 + FixLazyPower54] ** LazyPower[y, 1] ** LazyPower[x, 1]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower54 >= 2}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower55_], LazyPower[Inv[1 - (x_)], FixLazyPower56_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower55] ** LazyPower[Inv[1 - x], -1 + FixLazyPower56] + LazyPower[x, -1 + FixLazyPower55] ** LazyPower[Inv[1 - x], FixLazyPower56]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower55 >= 1, FixLazyPower56 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower57_], LazyPower[Inv[x_], FixLazyPower58_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[x, -1 + FixLazyPower57] ** LazyPower[Inv[x], -1 + FixLazyPower58]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower57 >= 1, FixLazyPower58 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower59_], LazyPower[x_, FixLazyPower60_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower59] ** LazyPower[x, -1 + FixLazyPower60] + LazyPower[Inv[1 - x], FixLazyPower59] ** LazyPower[x, -1 + FixLazyPower60]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower59 >= 1, FixLazyPower60 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower61_], LazyPower[Inv[x_], FixLazyPower62_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower61] ** LazyPower[Inv[x], FixLazyPower62] + LazyPower[Inv[1 - x], FixLazyPower61] ** LazyPower[Inv[x], -1 + FixLazyPower62]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower61 >= 1, FixLazyPower62 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower63_], LazyPower[x_, FixLazyPower64_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower63] ** LazyPower[x, -1 + FixLazyPower64]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower63 >= 1, FixLazyPower64 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower65_], LazyPower[Inv[1 - (x_)], FixLazyPower66_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower65] ** LazyPower[Inv[1 - x], FixLazyPower66] + LazyPower[Inv[x], FixLazyPower65] ** LazyPower[Inv[1 - x], -1 + FixLazyPower66]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower65 >= 1, FixLazyPower66 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower67_], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower68_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], FixLazyPower67] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower68] + LazyPower[Inv[x], -1 + FixLazyPower67] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], FixLazyPower68]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower67 >= 1, FixLazyPower68 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[y_], FixLazyPower69_], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower70_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[y], FixLazyPower69] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower70] + LazyPower[Inv[y], -1 + FixLazyPower69] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], FixLazyPower70]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower69 >= 1, FixLazyPower70 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower71_], LazyPower[x_, FixLazyPower72_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x ** y], -1 + FixLazyPower71] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower72]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower71 >= 1, FixLazyPower72 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower73_], LazyPower[Inv[y_], FixLazyPower74_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x ** y], -1 + FixLazyPower73] ** LazyPower[Inv[y], FixLazyPower74] + LazyPower[Inv[1 - x ** y], -1 + FixLazyPower73] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[Inv[y], -1 + FixLazyPower74]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower73 >= 1, FixLazyPower74 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower75_], LazyPower[y_, FixLazyPower76_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y ** x], -1 + FixLazyPower75] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower76]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower75 >= 1, FixLazyPower76 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower77_], LazyPower[Inv[x_], FixLazyPower78_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y ** x], -1 + FixLazyPower77] ** LazyPower[Inv[x], FixLazyPower78] + LazyPower[Inv[1 - y ** x], -1 + FixLazyPower77] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[Inv[x], -1 + FixLazyPower78]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower77 >= 1, FixLazyPower78 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower79_], LazyPower[x_, FixLazyPower80_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -1 + FixLazyPower79] ** LazyPower[x, 1] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower80]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower79 >= 1, FixLazyPower80 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower81_], LazyPower[Inv[y_], FixLazyPower82_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -1 + FixLazyPower81] ** LazyPower[Inv[y], 1] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[y], -1 + FixLazyPower82]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower81 >= 1, FixLazyPower82 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower83_], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower84_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -1 + FixLazyPower83] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower84]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower83 >= 1, FixLazyPower84 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower85_], LazyPower[y_, FixLazyPower86_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -1 + FixLazyPower85] ** LazyPower[y, 1] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower86]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower85 >= 1, FixLazyPower86 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower87_], LazyPower[Inv[x_], FixLazyPower88_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -1 + FixLazyPower87] ** LazyPower[Inv[x], 1] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[x], -1 + FixLazyPower88]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower87 >= 1, FixLazyPower88 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower89_], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower90_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -1 + FixLazyPower89] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower90]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower89 >= 1, FixLazyPower90 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower91_], LazyPower[y_, 1], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower92_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower91] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower92] + LazyPower[x, -1 + FixLazyPower91] ** LazyPower[Inv[1 - x ** y], FixLazyPower92]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower91 >= 1, FixLazyPower92 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower93_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (x_)], FixLazyPower94_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower93] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], -1 + FixLazyPower94] + LazyPower[x, -1 + FixLazyPower93] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], FixLazyPower94]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower93 >= 1, FixLazyPower94 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower95_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (y_)], FixLazyPower96_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower95] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Inv[1 - y], FixLazyPower96] + LazyPower[x, -1 + FixLazyPower95] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - y], FixLazyPower96] + LazyPower[x, FixLazyPower95] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower96]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower95 >= 1, FixLazyPower96 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower97_], LazyPower[x_, 1], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower98_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower97] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower98] + LazyPower[y, -1 + FixLazyPower97] ** LazyPower[Inv[1 - y ** x], FixLazyPower98]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower97 >= 1, FixLazyPower98 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower99_], LazyPower[Inv[1 - (x_) ** (y_)], m_], LazyPower[Inv[1 - (y_)], FixLazyPower100_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower99] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], -1 + FixLazyPower100] + LazyPower[y, -1 + FixLazyPower99] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], FixLazyPower100]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower100 >= 1, FixLazyPower99 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower101_], LazyPower[Inv[1 - (x_) ** (y_)], n_], LazyPower[Inv[1 - (x_)], FixLazyPower102_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower101] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Inv[1 - x], FixLazyPower102] + LazyPower[y, -1 + FixLazyPower101] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - x], FixLazyPower102] + LazyPower[y, FixLazyPower101] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower102]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower101 >= 1, FixLazyPower102 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower103_], LazyPower[y_, 1], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower104_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], FixLazyPower103] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower104] + LazyPower[Inv[1 - x], FixLazyPower103] ** LazyPower[Inv[1 - x ** y], FixLazyPower104] + LazyPower[Inv[1 - x], -1 + FixLazyPower103] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], FixLazyPower104]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower103 >= 1, FixLazyPower104 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower105_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (x_)], FixLazyPower106_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower105] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - x], FixLazyPower106] - LazyPower[Inv[1 - x], FixLazyPower105] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], -1 + FixLazyPower106] + LazyPower[Inv[1 - x], FixLazyPower105] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], FixLazyPower106]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower105 >= 1, FixLazyPower106 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower107_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (y_)], FixLazyPower108_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower107] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower108] + LazyPower[Inv[1 - x], -1 + FixLazyPower107] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], FixLazyPower108] - LazyPower[Inv[1 - x], FixLazyPower107] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Inv[1 - y], FixLazyPower108] + LazyPower[Inv[1 - x], FixLazyPower107] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - y], FixLazyPower108] + LazyPower[Inv[1 - x], FixLazyPower107] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower108]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower107 >= 1, FixLazyPower108 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower109_], LazyPower[Rt[1 - (x_) ** (y_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower110_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower109] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower110] + LazyPower[Inv[x], FixLazyPower109] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower110]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower109 >= 1, FixLazyPower110 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower111_], LazyPower[x_, 1], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower112_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], FixLazyPower111] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower112] + LazyPower[Inv[1 - y], FixLazyPower111] ** LazyPower[Inv[1 - y ** x], FixLazyPower112] + LazyPower[Inv[1 - y], -1 + FixLazyPower111] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], FixLazyPower112]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower111 >= 1, FixLazyPower112 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower113_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (y_)], FixLazyPower114_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], -1 + FixLazyPower113] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - y], FixLazyPower114] + LazyPower[Inv[1 - y], FixLazyPower113] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - y], FixLazyPower114] + LazyPower[Inv[1 - y], FixLazyPower113] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], -1 + FixLazyPower114]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower113 >= 1, FixLazyPower114 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower115_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (x_)], FixLazyPower116_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y], -1 + FixLazyPower115] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower116] - LazyPower[Inv[1 - y], -1 + FixLazyPower115] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], FixLazyPower116] - LazyPower[Inv[1 - y], FixLazyPower115] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower116] + LazyPower[Inv[1 - y], FixLazyPower115] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], FixLazyPower116] + LazyPower[Inv[1 - y], FixLazyPower115] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Inv[1 - x], FixLazyPower116]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower115 >= 1, FixLazyPower116 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[y_], FixLazyPower117_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower118_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[y], -1 + FixLazyPower117] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower118] + LazyPower[Inv[y], FixLazyPower117] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower118]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower117 >= 1, FixLazyPower118 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower119_], LazyPower[x_, 1], LazyPower[y_, FixLazyPower120_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x ** y], -1 + FixLazyPower119] ** LazyPower[y, -1 + FixLazyPower120] + LazyPower[Inv[1 - x ** y], FixLazyPower119] ** LazyPower[y, -1 + FixLazyPower120]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower119 >= 1, FixLazyPower120 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower121_], LazyPower[y_, 1], LazyPower[x_, FixLazyPower122_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y ** x], -1 + FixLazyPower121] ** LazyPower[x, -1 + FixLazyPower122] + LazyPower[Inv[1 - y ** x], FixLazyPower121] ** LazyPower[x, -1 + FixLazyPower122]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower121 >= 1, FixLazyPower122 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower123_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower124_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower123] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower124] + LazyPower[x, -1 + FixLazyPower123] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower124]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower123 >= 1, FixLazyPower124 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower125_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower126_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower125] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower126] + LazyPower[x, -1 + FixLazyPower125] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower126] + LazyPower[x, FixLazyPower125] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower126]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower125 >= 1, FixLazyPower126 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower127_], LazyPower[Inv[1 - (x_) ** (y_)], m_], LazyPower[Rt[1 - (x_) ** (y_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower128_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower127] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower128] + LazyPower[y, -1 + FixLazyPower127] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], FixLazyPower128]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower127 >= 1, FixLazyPower128 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower129_], LazyPower[Inv[1 - (x_) ** (y_)], n_], LazyPower[Rt[1 - (x_) ** (y_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower130_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower129] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower130] + LazyPower[y, -1 + FixLazyPower129] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower130] + LazyPower[y, FixLazyPower129] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower130]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower129 >= 1, FixLazyPower130 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower131_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower132_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower131] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower132] - LazyPower[Inv[1 - x], FixLazyPower131] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower132] + LazyPower[Inv[1 - x], FixLazyPower131] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower132]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower131 >= 1, FixLazyPower132 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower133_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower134_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower133] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower134] + LazyPower[Inv[1 - x], -1 + FixLazyPower133] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], FixLazyPower134] - LazyPower[Inv[1 - x], FixLazyPower133] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower134] + LazyPower[Inv[1 - x], FixLazyPower133] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower134] + LazyPower[Inv[1 - x], FixLazyPower133] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower134]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower133 >= 1, FixLazyPower134 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower135_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower136_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], -1 + FixLazyPower135] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower136] + LazyPower[Inv[1 - y], FixLazyPower135] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower136] + LazyPower[Inv[1 - y], FixLazyPower135] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower136]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower135 >= 1, FixLazyPower136 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower137_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower138_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y], -1 + FixLazyPower137] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower138] - LazyPower[Inv[1 - y], -1 + FixLazyPower137] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower138] - LazyPower[Inv[1 - y], FixLazyPower137] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower138] + LazyPower[Inv[1 - y], FixLazyPower137] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower138] + LazyPower[Inv[1 - y], FixLazyPower137] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower138]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower137 >= 1, FixLazyPower138 >= 1, n >= 1}\
]};


FactQ[x_] := Inequalities`InequalityFactQ[x];

NCNagyFoiasRt[0] := 0;

NCNagyFoiasRt[expr_] := expr//.rules;

NCNagyFoiasRt[x___] := BadCall["NCNagyFoiasRt",x];


End[];
EndPackage[]
