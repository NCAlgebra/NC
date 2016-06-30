AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NC`
<< NCAlgebra`

<< SDP`

<< NC`NCExtras`
<< NC`NCExpressionToFunction`
<< NC`NCSylvester`

(* Define matrix problem *)

SNC[a,b,c,d,x];

f = -{ a**x**tp[a], \
       b**x**tp[c]+c**x**tp[b]-b**x**tp[d]-d**x**tp[b], \
       2 d**x**tp[c]+2 c**x**tp[d]-4 d**x**tp[d] }
vars = {x}

data = {a -> {{1, 0}}, b -> {{1, 0}, {0, 0}}, c -> {{0, 1}, {1, 0}}, \
        d -> {{0, 1/2}, {0, 0}}} 

BB = -{ {{0,0},{0,1}} }
CC = { {{-2}}, {{0,0},{0,1}}, {{0,0},{0,1}} }

{Y, X, S, iters} = SylvesterSDPSolve[ \
    f, BB, CC, vars, data ];

Y

$Echo = DeleteCases[$Echo, "stdout"];
