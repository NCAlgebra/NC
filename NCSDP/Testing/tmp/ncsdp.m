AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NC`
<< NCAlgebra`

<< NC`NCExpressionToFunction`
<< NC`NCExtras`
<< SDP`
<< PrimalDualEmbedding.m

SNC[a,b,c,d,e,f,g,h]
SNC[x,y,z]
SNC[w,w1,w2,w3]

exp1 = {-(a**x + tp[x]**tp[a] + q), x} /. x -> x + tp[x]

n = 10;
SeedRandom[1]

range = 10;
AA = RandomInteger[{-range,range},{n,n}];

{DD,VV} = Eigensystem[N[AA]]

Norm[AA - Transpose[VV] . DiagonalMatrix[DD] . Inverse[Transpose[VV]]]
Select[DD, (Re[#] > 0)&];
PosQ[x_] := (Re[x] > 0);
DDn = DD /. x_?PosQ -> -x;

AA = Re[Transpose[VV] . DiagonalMatrix[DDn] . Inverse[Transpose[VV]]];

QQ = IdentityMatrix[n];

Max[Re[Eigenvalues[AA]]] // N

data = {a -> AA, q -> QQ};
fun = ExpressionToFunction[exp1, {x}, data];

XX = CreateMatrixOfSymbols[x, {n, n}];

vars = Union[Flatten[XX]];
eqs = Flatten[Map[(# /. {0 -> {}, x_ -> (x == 0)})&, Flatten[XX - Transpose[XX]]]];
sol = Flatten[Solve[eqs, vars]];

vars = Union[Flatten[vars /. sol]]
f = fun[XX] /. sol

cost = -Part[Tr[XX] /. sol, 1]
BBB = {{CoefficientArrays[cost, vars][[2]]}} // Normal

{CCC, AAA} = SDPLinearCoefficientArrays[f, vars] // Normal

{FPrimalEval, FDualEval, SylvesterVecEval, SylvesterVecDiagonalEval} \
   = SDPFunctions[1.*AAA];

{Yk, Xk, Sk, iters} = PrimalDual[ FPrimalEval, FDualEval, \
                SylvesterVecEval, SylvesterVecDiagonalEval,\
                1.*BBB, 1.*CCC, \
                Method -> LongStep, \
                SearchDirection -> NesterovTodd, \
		ScaleHessian -> True, \
                LeastSquares -> Direct, \
                ScaleHessian -> True, \
                CGPreconditioner -> Identity, \
                GapTol -> 10.^(-12), \
                DebugLevel -> 0 ];

Map[MatrixForm, Yk]
Map[MatrixForm, Sk]
Map[MatrixForm, Xk]
Map[MatrixVectorFrobeniusNorm, (FDualEval @@ Yk) + Sk - CCC]
Map[MatrixVectorFrobeniusNorm, (FPrimalEval @@ Xk) - BBB]
Min[Map[Eigenvalues, Sk]]
Min[Map[Eigenvalues, CCC - (FDualEval @@ Yk)]]
Min[Map[Eigenvalues, Xk]]


$Echo = DeleteCases[$Echo, "stdout"];
