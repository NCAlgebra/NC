AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->160];

<< NC`
<< NCAlgebra`

<< NC`NCExpressionToFunction`
<< NC`NCExtras`
<< NC`NCSylvester`

(* first matrix example, lyapunov discrete *)

(* dual mapping *)

SNC[a,b,x,g];

f = (a + b) ** g + x;
vars = {x,g};

fCollect = SylvesterCollect[f, vars]

f = {{x, tp[a+b] ** tp[g]}, {(a + b)** g, g+tp[g]-x}};
vars = {x,g};

fCollect = SylvesterCollect[f, vars];

$Echo = DeleteCases[$Echo, "stdout"];
