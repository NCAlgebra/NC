AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NC`
<< NCAlgebra`

<< SDP`
(* << SDPFlat` *)
<< cSDP`

<< NC`NCExtras`
<< NC`NCExpressionToFunction`
<< NC`NCSylvester`

(* Define matrix problem *)

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

XX = CreateMatrixOfSymbols[x, {n, n}] SparseArray[{i_, j_} /; j <= i -> 1, {n, n}];
XX = XX + Transpose[XX] - DiagonalMatrix[Tr[XX, List]]

A = -{Transpose[AA] . XX . AA - XX + IdentityMatrix[n], -XX};
b = Tr[XX];
y = Union[Flatten[XX]];

sdp = 1.* SDPMatrices[b, A, y];

{Y, X, S, iters} = SDPSolve[sdp, Profiling -> True];


$Echo = DeleteCases[$Echo, "stdout"];
