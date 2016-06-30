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

f = { tp[a] ** x ** a - x, -x }
vars = {x}

n = 50;
SeedRandom[1];

range = 10;
AA = RandomInteger[{-range,range}, {n,n}];

{DD,VV} = Eigensystem[N[AA]];

Norm[AA - Transpose[VV] . DiagonalMatrix[DD] . Inverse[Transpose[VV]]]
PosQ[x_] := (Abs[x] > 1);
DDn = DD /. x_?PosQ -> 1/x;

AA = Re[Transpose[VV] . DiagonalMatrix[DDn] . Inverse[Transpose[VV]]];

Eigenvalues[AA]

data = {a -> AA};

BB = -{ IdentityMatrix[n] };
CC = { -IdentityMatrix[n], 0*IdentityMatrix[n] };

{Y, X, S, iters} = SylvesterSDPSolve[ \
    f, BB, CC, vars, data, SparseWeights -> False, Profiling -> False ];

Y

$Echo = DeleteCases[$Echo, "stdout"];
