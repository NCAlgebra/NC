AppendTo[$Echo, "stdout"]

<< NC`
<< NCAlgebra`

<< NCSDP`
<< NCExpressionToFunction`
<< NCLinear`
<< MatrixVector`

<< NCOptimizationNew.m

<< PrimalDualEmbedding.m

(* Continuou-time H2 Optimization Problem *)
SNC[ x, y, q, a, b, cz, dzu ];
Xd = { x, q, y }
FDual = { 
  -{{x, cz ** q + dzu ** y}, {tp[cz ** q + dzu ** y], q}},
  a ** q + q ** tp[a] + b ** y + tp[y] ** tp[b]
}
Rd = {LessEqual, LessEqual};
SymVars = { x, q };

(* Random System Generation *)
n = 3;
SeedRandom[13];

(* n = 10;
 SeedRandom[4]; *)

A = Table[Random[Real,{-10,10}],{i,n},{j,n}]
lm = Max[Map[Re,Eigenvalues[A]]]
(* A = A - 1.1*lm*IdentityMatrix[n]; *)

A = {{-3, 3, -3}, {-3, -1, -1}, {-3, -1, 3}}
lm = N[Max[Map[Re,Eigenvalues[A,Cubics->True]]]]

(* Initialization *)
Q = 1.*IdentityMatrix[n];

B = Transpose[{Table[0,{i,n}]}]; B[[1,1]] = 1;
Dzu = Transpose[{Table[0,{i,n+1}]}]; Dzu[[n+1,1]] = 1;
Cz = BlockMatrix[{ {IdentityMatrix[n]},{Table[0,{i,1},{j,n}]} }];

data = { a -> A, b -> B, cz -> Cz, dzu -> Dzu };

CC = { 
  { { ZeroMatrix[n+1,n+1], ZeroMatrix[n+1,n] }, 
    { ZeroMatrix[n,n+1], ZeroMatrix[n,n] } },
  -Q
};
BB = -{
  IdentityMatrix[n+1], 
  ZeroMatrix @@ Dimensions[A],
  ZeroMatrix @@ Dimensions[Transpose[B]]
};

{FPrimalEval, FDualEval, SylvesterVecEval, SylvesterVecDiagonalEval} = \
  NCSDPFunctions[FDual, Xd, BB, CC, Rd, SymVars, data, DebugLevel -> 0]

{Yk, Xk, Sk, iters} = PrimalDual[ FPrimalEval, FDualEval, \
            SylvesterVecEval, SylvesterVecDiagonalEval,\
            BB, CC, \
	    Method -> LongStep, \
	    LeastSquares -> CG, \
            GapTol -> 10.^(-10), DebugLevel -> 0];

MatrixForm[A]
MatrixForm[B]

Ctrb = ArrayFlatten[{{B,A.B}}];
Tr[SingularValueDecomposition[Ctrb][[2]],List]

Q = Yk[[2]];
Q = (Q + Transpose[Q]) / 2;
L = Yk[[3]];
K = L . Inverse[Q]

Eigenvalues[Q]

Acl = A + B . K
Eigenvalues[Acl]

Acl . Q + Q . Transpose[Acl] + IdentityMatrix[n]

$Echo = DeleteCases[$Echo, "stdout"];
