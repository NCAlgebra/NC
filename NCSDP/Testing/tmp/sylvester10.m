AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->170];

<< Sylvester`

(* Riccati *)

n=10;
m=3;

(* SeedRandom[1234]; *)

Id = IdentityMatrix[n];
A = RandomReal[{-10,10},{n,n}];
B = RandomReal[{-10,10},{n,m}];
Ze = ConstantArray[0,{n,n}];

Idm = IdentityMatrix[m];
Zemm = ConstantArray[0,{m,m}];
Zenm = ConstantArray[0,{n,m}];
IdX = ArrayFlatten[{{Transpose[Zenm]},{Id}}];
IdW = ArrayFlatten[{{Idm},{Zenm}}];
Zenpm = ConstantArray[0,{n+m,n+m}];

AA={
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
};
CC={-Id,Zenpm};
BB={Ze,Transpose[Zenm],-Idm};

X=RandomReal[{-10,10},{n,n}];
X = X + Transpose[X];
L=RandomReal[{-10,10},{m,n}];
W=RandomReal[{-10,10},{m,m}];
W = W + Transpose[W];
 
dims=Map[Dimensions,{X,L,W}];
syms={True,False,True};

<< SDP`
<< cSDP`

AAvec = SylvesterDualVectorize[AA, dims, syms, True];
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]];
BBSDP = {{Flatten[{SymmetricToVector[BB[[1]], 2],ToVector[BB[[2]]],SymmetricToVector[BB[[3]], 2]}]}};

{Y, X, S, iters} = \
  SDPSolve[{AASDP, BBSDP, CC}, DebugLevel -> 0];
Y = Flatten[Y];
nn = n*(n+1)/2;
X1 = ToSymmetricMatrix[Y[[1;;nn]], n];
L1 = ToMatrix[Y[[nn+1;;nn+m*n]], m];
K1 = L1 . Inverse[X1];
nn += m*n;
W1 = ToSymmetricMatrix[Y[[nn+1;;nn+(m*(m+1)/2)]], m];

Acl1 = A + B . K1;
Max[Re[Eigenvalues[Acl1]]]

Max[Eigenvalues[Acl1 . X1 + X1 . Transpose[Acl1] + Id]]
Max[Eigenvalues[W1 - K1 . X1 . Transpose[K1]]]

<< SDPSylvester`

{AASDP2,BBSDP2,CCSDP2} = SylvesterToVectorizedSDP[{AA, BB, CC}, SymmetricVariables -> {1,3}];

Total[Abs[Flatten[AASDP2 - AASDP]]]
Map[Norm, BBSDP2 - BBSDP]
Map[Norm, CCSDP2 - CC]

{Y, X, S, iters} = \
  SDPSolve[{AA, BB, CC}, SymmetricVariables -> {1,3}, DebugLevel -> 0];
{X2, L2, W2} = Y;
K2 = L2 . Inverse[X2];

Acl2 = A + B . K2;
Max[Re[Eigenvalues[Acl2]]]

Max[Eigenvalues[Acl2 . X2 + X2 . Transpose[Acl2] + Id]]
Max[Eigenvalues[W2 - K2 . X2 . Transpose[K2]]]

$Echo = DeleteCases[$Echo, "stdout"];
