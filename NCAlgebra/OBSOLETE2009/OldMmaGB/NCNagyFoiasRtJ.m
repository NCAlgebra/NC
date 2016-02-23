BeginPackage["NCNagyFoiasRtJ`",
             "Inequalities`",
             "Grabs`",
             "NonCommutativeMultiply`",
             "Global`",
             "Lazy`",
             "Errors`"];

Clear[NCNagyFoiasRtJ];

NCNagyFoiasRtJ::usage = "NCNagyFoiasRtJ[...] usage note not yet written.";

Begin["`Private`"];

rules = {
LazyPower[OperatorSignature[1 - (x_) ** (y_)], FixLazyPower139_]\
:> ExpandNonCommutativeMultiply[\
LazyPower[OperatorSignature[1 - x ** y], -2 + FixLazyPower139]\
] /; Inequalities`InequalityFactQ[\
{FixLazyPower139 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - (x_) ** (y_)], FixLazyPower139_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[OperatorSignature[1 - x ** y], -2 + FixLazyPower139]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower139 >= 2}\
],
LazyPower[OperatorSignature[1 - (y_) ** (x_)], FixLazyPower140_]\
:> ExpandNonCommutativeMultiply[\
LazyPower[OperatorSignature[1 - y ** x], -2 + FixLazyPower140]\
] /; Inequalities`InequalityFactQ[\
{FixLazyPower140 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - (y_) ** (x_)], FixLazyPower140_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[OperatorSignature[1 - y ** x], -2 + FixLazyPower140]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower140 >= 2}\
],
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower141_]\
:> ExpandNonCommutativeMultiply[\
LazyPower[Rt[1 - x ** y], -2 + FixLazyPower141] - LazyPower[Rt[1 - x ** y], -2 + FixLazyPower141] ** LazyPower[x, 1] ** LazyPower[y, 1]\
] /; Inequalities`InequalityFactQ[\
{FixLazyPower141 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower141_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -2 + FixLazyPower141] - LazyPower[Rt[1 - x ** y], -2 + FixLazyPower141] ** LazyPower[x, 1] ** LazyPower[y, 1]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower141 >= 2}\
],
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower142_]\
:> ExpandNonCommutativeMultiply[\
LazyPower[Rt[1 - y ** x], -2 + FixLazyPower142] - LazyPower[Rt[1 - y ** x], -2 + FixLazyPower142] ** LazyPower[y, 1] ** LazyPower[x, 1]\
] /; Inequalities`InequalityFactQ[\
{FixLazyPower142 >= 2}\
],Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower142_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -2 + FixLazyPower142] - LazyPower[Rt[1 - y ** x], -2 + FixLazyPower142] ** LazyPower[y, 1] ** LazyPower[x, 1]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower142 >= 2}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower143_], LazyPower[Inv[1 - (x_)], FixLazyPower144_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower143] ** LazyPower[Inv[1 - x], -1 + FixLazyPower144] + LazyPower[x, -1 + FixLazyPower143] ** LazyPower[Inv[1 - x], FixLazyPower144]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower143 >= 1, FixLazyPower144 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower145_], LazyPower[Inv[x_], FixLazyPower146_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[x, -1 + FixLazyPower145] ** LazyPower[Inv[x], -1 + FixLazyPower146]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower145 >= 1, FixLazyPower146 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower147_], LazyPower[x_, FixLazyPower148_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower147] ** LazyPower[x, -1 + FixLazyPower148] + LazyPower[Inv[1 - x], FixLazyPower147] ** LazyPower[x, -1 + FixLazyPower148]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower147 >= 1, FixLazyPower148 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower149_], LazyPower[Inv[x_], FixLazyPower150_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower149] ** LazyPower[Inv[x], FixLazyPower150] + LazyPower[Inv[1 - x], FixLazyPower149] ** LazyPower[Inv[x], -1 + FixLazyPower150]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower149 >= 1, FixLazyPower150 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower151_], LazyPower[x_, FixLazyPower152_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower151] ** LazyPower[x, -1 + FixLazyPower152]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower151 >= 1, FixLazyPower152 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower153_], LazyPower[Inv[1 - (x_)], FixLazyPower154_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower153] ** LazyPower[Inv[1 - x], FixLazyPower154] + LazyPower[Inv[x], FixLazyPower153] ** LazyPower[Inv[1 - x], -1 + FixLazyPower154]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower153 >= 1, FixLazyPower154 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower155_], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower156_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], FixLazyPower155] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower156] + LazyPower[Inv[x], -1 + FixLazyPower155] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], FixLazyPower156]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower155 >= 1, FixLazyPower156 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[y_], FixLazyPower157_], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower158_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[y], FixLazyPower157] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower158] + LazyPower[Inv[y], -1 + FixLazyPower157] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], FixLazyPower158]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower157 >= 1, FixLazyPower158 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower159_], LazyPower[x_, FixLazyPower160_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x ** y], -1 + FixLazyPower159] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower160]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower159 >= 1, FixLazyPower160 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower161_], LazyPower[Inv[y_], FixLazyPower162_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x ** y], -1 + FixLazyPower161] ** LazyPower[Inv[y], FixLazyPower162] + LazyPower[Inv[1 - x ** y], -1 + FixLazyPower161] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[Inv[y], -1 + FixLazyPower162]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower161 >= 1, FixLazyPower162 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower163_], LazyPower[y_, FixLazyPower164_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y ** x], -1 + FixLazyPower163] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower164]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower163 >= 1, FixLazyPower164 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower165_], LazyPower[Inv[x_], FixLazyPower166_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y ** x], -1 + FixLazyPower165] ** LazyPower[Inv[x], FixLazyPower166] + LazyPower[Inv[1 - y ** x], -1 + FixLazyPower165] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[Inv[x], -1 + FixLazyPower166]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower165 >= 1, FixLazyPower166 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - (x_) ** (y_)], FixLazyPower167_], LazyPower[y_, FixLazyPower168_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[OperatorSignature[1 - x ** y], -1 + FixLazyPower167] ** LazyPower[y, 1] ** LazyPower[OperatorSignature[1 - y ** x], 1] ** LazyPower[y, -1 + FixLazyPower168]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower167 >= 1, FixLazyPower168 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - (y_) ** (x_)], FixLazyPower169_], LazyPower[x_, FixLazyPower170_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[OperatorSignature[1 - y ** x], -1 + FixLazyPower169] ** LazyPower[x, 1] ** LazyPower[OperatorSignature[1 - x ** y], 1] ** LazyPower[x, -1 + FixLazyPower170]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower169 >= 1, FixLazyPower170 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower171_], LazyPower[x_, FixLazyPower172_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -1 + FixLazyPower171] ** LazyPower[x, 1] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower172]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower171 >= 1, FixLazyPower172 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower173_], LazyPower[Inv[y_], FixLazyPower174_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -1 + FixLazyPower173] ** LazyPower[Inv[y], 1] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[y], -1 + FixLazyPower174]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower173 >= 1, FixLazyPower174 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (x_) ** (y_)], FixLazyPower175_], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower176_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - x ** y], -1 + FixLazyPower175] ** LazyPower[Inv[1 - x ** y], 1] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower176]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower175 >= 1, FixLazyPower176 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower177_], LazyPower[y_, FixLazyPower178_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -1 + FixLazyPower177] ** LazyPower[y, 1] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower178]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower177 >= 1, FixLazyPower178 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower179_], LazyPower[Inv[x_], FixLazyPower180_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -1 + FixLazyPower179] ** LazyPower[Inv[x], 1] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[x], -1 + FixLazyPower180]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower179 >= 1, FixLazyPower180 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Rt[1 - (y_) ** (x_)], FixLazyPower181_], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower182_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Rt[1 - y ** x], -1 + FixLazyPower181] ** LazyPower[Inv[1 - y ** x], 1] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower182]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower181 >= 1, FixLazyPower182 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower183_], LazyPower[y_, 1], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower184_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower183] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower184] + LazyPower[x, -1 + FixLazyPower183] ** LazyPower[Inv[1 - x ** y], FixLazyPower184]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower183 >= 1, FixLazyPower184 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower185_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (x_)], FixLazyPower186_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower185] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], -1 + FixLazyPower186] + LazyPower[x, -1 + FixLazyPower185] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], FixLazyPower186]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower185 >= 1, FixLazyPower186 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower187_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (y_)], FixLazyPower188_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower187] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Inv[1 - y], FixLazyPower188] + LazyPower[x, -1 + FixLazyPower187] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - y], FixLazyPower188] + LazyPower[x, FixLazyPower187] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower188]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower187 >= 1, FixLazyPower188 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower189_], LazyPower[x_, 1], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower190_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower189] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower190] + LazyPower[y, -1 + FixLazyPower189] ** LazyPower[Inv[1 - y ** x], FixLazyPower190]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower189 >= 1, FixLazyPower190 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower191_], LazyPower[Inv[1 - (x_) ** (y_)], m_], LazyPower[Inv[1 - (y_)], FixLazyPower192_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower191] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], -1 + FixLazyPower192] + LazyPower[y, -1 + FixLazyPower191] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], FixLazyPower192]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower191 >= 1, FixLazyPower192 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower193_], LazyPower[Inv[1 - (x_) ** (y_)], n_], LazyPower[Inv[1 - (x_)], FixLazyPower194_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower193] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Inv[1 - x], FixLazyPower194] + LazyPower[y, -1 + FixLazyPower193] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - x], FixLazyPower194] + LazyPower[y, FixLazyPower193] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower194]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower193 >= 1, FixLazyPower194 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower195_], LazyPower[y_, 1], LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower196_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], FixLazyPower195] ** LazyPower[Inv[1 - x ** y], -1 + FixLazyPower196] + LazyPower[Inv[1 - x], FixLazyPower195] ** LazyPower[Inv[1 - x ** y], FixLazyPower196] + LazyPower[Inv[1 - x], -1 + FixLazyPower195] ** LazyPower[y, 1] ** LazyPower[Inv[1 - x ** y], FixLazyPower196]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower195 >= 1, FixLazyPower196 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower197_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (x_)], FixLazyPower198_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower197] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - x], FixLazyPower198] - LazyPower[Inv[1 - x], FixLazyPower197] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], -1 + FixLazyPower198] + LazyPower[Inv[1 - x], FixLazyPower197] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - x], FixLazyPower198]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower197 >= 1, FixLazyPower198 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower199_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (y_)], FixLazyPower200_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower199] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower200] + LazyPower[Inv[1 - x], -1 + FixLazyPower199] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], FixLazyPower200] - LazyPower[Inv[1 - x], FixLazyPower199] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Inv[1 - y], FixLazyPower200] + LazyPower[Inv[1 - x], FixLazyPower199] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - y], FixLazyPower200] + LazyPower[Inv[1 - x], FixLazyPower199] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Inv[1 - y], -1 + FixLazyPower200]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower199 >= 1, FixLazyPower200 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[x_], FixLazyPower201_], LazyPower[Rt[1 - (x_) ** (y_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower202_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[x], -1 + FixLazyPower201] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower202] + LazyPower[Inv[x], FixLazyPower201] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower202]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower201 >= 1, FixLazyPower202 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower203_], LazyPower[x_, 1], LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower204_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], FixLazyPower203] ** LazyPower[Inv[1 - y ** x], -1 + FixLazyPower204] + LazyPower[Inv[1 - y], FixLazyPower203] ** LazyPower[Inv[1 - y ** x], FixLazyPower204] + LazyPower[Inv[1 - y], -1 + FixLazyPower203] ** LazyPower[x, 1] ** LazyPower[Inv[1 - y ** x], FixLazyPower204]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower203 >= 1, FixLazyPower204 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower205_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Inv[1 - (y_)], FixLazyPower206_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], -1 + FixLazyPower205] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - y], FixLazyPower206] + LazyPower[Inv[1 - y], FixLazyPower205] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Inv[1 - y], FixLazyPower206] + LazyPower[Inv[1 - y], FixLazyPower205] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Inv[1 - y], -1 + FixLazyPower206]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower205 >= 1, FixLazyPower206 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower207_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Inv[1 - (x_)], FixLazyPower208_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y], -1 + FixLazyPower207] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower208] - LazyPower[Inv[1 - y], -1 + FixLazyPower207] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], FixLazyPower208] - LazyPower[Inv[1 - y], FixLazyPower207] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], -1 + FixLazyPower208] + LazyPower[Inv[1 - y], FixLazyPower207] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Inv[1 - x], FixLazyPower208] + LazyPower[Inv[1 - y], FixLazyPower207] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Inv[1 - x], FixLazyPower208]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower207 >= 1, FixLazyPower208 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[y_], FixLazyPower209_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower210_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[y], -1 + FixLazyPower209] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower210] + LazyPower[Inv[y], FixLazyPower209] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower210]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower209 >= 1, FixLazyPower210 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_) ** (y_)], FixLazyPower211_], LazyPower[x_, 1], LazyPower[y_, FixLazyPower212_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x ** y], -1 + FixLazyPower211] ** LazyPower[y, -1 + FixLazyPower212] + LazyPower[Inv[1 - x ** y], FixLazyPower211] ** LazyPower[y, -1 + FixLazyPower212]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower211 >= 1, FixLazyPower212 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_) ** (x_)], FixLazyPower213_], LazyPower[y_, 1], LazyPower[x_, FixLazyPower214_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y ** x], -1 + FixLazyPower213] ** LazyPower[x, -1 + FixLazyPower214] + LazyPower[Inv[1 - y ** x], FixLazyPower213] ** LazyPower[x, -1 + FixLazyPower214]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower213 >= 1, FixLazyPower214 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - (x_) ** (y_)], FixLazyPower215_], LazyPower[x_, 1], LazyPower[y_, FixLazyPower216_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[OperatorSignature[1 - x ** y], -1 + FixLazyPower215] ** LazyPower[x, 1] ** LazyPower[y, 1] ** LazyPower[OperatorSignature[1 - x ** y], 1] ** LazyPower[y, -1 + FixLazyPower216]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower215 >= 1, FixLazyPower216 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[OperatorSignature[1 - (y_) ** (x_)], FixLazyPower217_], LazyPower[y_, 1], LazyPower[x_, FixLazyPower218_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[OperatorSignature[1 - y ** x], -1 + FixLazyPower217] ** LazyPower[y, 1] ** LazyPower[x, 1] ** LazyPower[OperatorSignature[1 - y ** x], 1] ** LazyPower[x, -1 + FixLazyPower218]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower217 >= 1, FixLazyPower218 >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower219_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower220_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower219] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower220] + LazyPower[x, -1 + FixLazyPower219] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower220]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower219 >= 1, FixLazyPower220 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[x_, FixLazyPower221_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower222_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[x, -1 + FixLazyPower221] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower222] + LazyPower[x, -1 + FixLazyPower221] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower222] + LazyPower[x, FixLazyPower221] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower222]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower221 >= 1, FixLazyPower222 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower223_], LazyPower[Inv[1 - (x_) ** (y_)], m_], LazyPower[Rt[1 - (x_) ** (y_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower224_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower223] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower224] + LazyPower[y, -1 + FixLazyPower223] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], FixLazyPower224]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower223 >= 1, FixLazyPower224 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[y_, FixLazyPower225_], LazyPower[Inv[1 - (x_) ** (y_)], n_], LazyPower[Rt[1 - (x_) ** (y_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower226_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[y, -1 + FixLazyPower225] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower226] + LazyPower[y, -1 + FixLazyPower225] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower226] + LazyPower[y, FixLazyPower225] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower226]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower225 >= 1, FixLazyPower226 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower227_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower228_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - x], -1 + FixLazyPower227] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower228] - LazyPower[Inv[1 - x], FixLazyPower227] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower228] + LazyPower[Inv[1 - x], FixLazyPower227] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower228]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower227 >= 1, FixLazyPower228 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (x_)], FixLazyPower229_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower230_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - x], -1 + FixLazyPower229] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower230] + LazyPower[Inv[1 - x], -1 + FixLazyPower229] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], FixLazyPower230] - LazyPower[Inv[1 - x], FixLazyPower229] ** LazyPower[Inv[1 - x ** y], -1 + n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower230] + LazyPower[Inv[1 - x], FixLazyPower229] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower230] + LazyPower[Inv[1 - x], FixLazyPower229] ** LazyPower[Inv[1 - y ** x], n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower230]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower229 >= 1, FixLazyPower230 >= 1, n >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower231_], LazyPower[Inv[1 - (y_) ** (x_)], m_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (y_)], FixLazyPower232_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
-LazyPower[Inv[1 - y], -1 + FixLazyPower231] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower232] + LazyPower[Inv[1 - y], FixLazyPower231] ** LazyPower[Inv[1 - x ** y], m] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - y], FixLazyPower232] + LazyPower[Inv[1 - y], FixLazyPower231] ** LazyPower[Inv[1 - y ** x], m] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - y], -1 + FixLazyPower232]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower231 >= 1, FixLazyPower232 >= 1, m >= 1}\
],
Literal[NonCommutativeMultiply[front___,\
LazyPower[Inv[1 - (y_)], FixLazyPower233_], LazyPower[Inv[1 - (y_) ** (x_)], n_], LazyPower[Rt[1 - (y_) ** (x_)], 1], LazyPower[Inv[1 - (x_)], FixLazyPower234_]\
,back___]] :> \
ExpandNonCommutativeMultiply[front**(\
LazyPower[Inv[1 - y], -1 + FixLazyPower233] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower234] - LazyPower[Inv[1 - y], -1 + FixLazyPower233] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower234] - LazyPower[Inv[1 - y], FixLazyPower233] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], -1 + FixLazyPower234] + LazyPower[Inv[1 - y], FixLazyPower233] ** LazyPower[Inv[1 - x ** y], n] ** LazyPower[Rt[1 - x ** y], 1] ** LazyPower[Inv[1 - x], FixLazyPower234] + LazyPower[Inv[1 - y], FixLazyPower233] ** LazyPower[Inv[1 - y ** x], -1 + n] ** LazyPower[Rt[1 - y ** x], 1] ** LazyPower[Inv[1 - x], FixLazyPower234]\
)**back] /; Inequalities`InequalityFactQ[\
{FixLazyPower233 >= 1, FixLazyPower234 >= 1, n >= 1}\
]};


FactQ[x_] := Inequalities`InequalityFactQ[x];

NCNagyFoiasRtJ[0] := 0;

NCNagyFoiasRtJ[expr_] := expr//.rules;

NCNagyFoiasRtJ[x___] := BadCall["NCNagyFoiasRtJ",x];


End[];
EndPackage[]
