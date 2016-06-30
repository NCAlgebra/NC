AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< SDP`
<< cSDP`

(* All you should see are zeros *)

n=2;
m=2;

Id=IdentityMatrix[n];
A=RandomReal[{-10,10},{n,n}];
A-=1.1*Max[Re[Eigenvalues[A]]]*Id;
B=RandomReal[{-10,10},{n,m}];
Ze=ConstantArray[0,{n,n}];

Idm=IdentityMatrix[m];
Zemm=ConstantArray[0,{m,m}];
Zenm=ConstantArray[0,{n,m}];
IdX=ArrayFlatten[{{Transpose[Zenm]},{Id}}];
IdW=ArrayFlatten[{{Idm},{Zenm}}];
Zenpm=ConstantArray[0,{n+m,n+m}];

(* Test #1 : Riccati inequality *)

AA={
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < -I *)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{- IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
};
CC={-Id,Zenpm};
BB={Ze,Transpose[Zenm],-Idm};

<< Sylvester`

dims = {{n,n},{m,n},{m,m}};
syms = {True,False,True};
AAvec = SylvesterDualVectorize[AA, dims, syms, True];
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]]
BBSDP = {Flatten[{SymmetricToVector[BB[[1]], 2],ToVector[BB[[2]]],SymmetricToVector[BB[[3]], 2]}]}

{Y, X, S, iters} = \
  SDPSolve[{AASDP, BBSDP, CC}, DebugLevel -> 0];
Y = ToSymmetricMatrix[Flatten[Y], n];
Norm[A . Y + Y . Transpose[A] + Id]
Min[Eigenvalues[Y]]

<< SDPSylvester`

(* AA = Map[SparseArray, AA, {3}]; *)

{Y, X, S, iters} = \
  SDPSolve[{AA, BB, CC}, SymmetricVariables -> {1}, DebugLevel -> 0];
Y = Part[Y, 1];
Norm[A . Y + Y . Transpose[A] + Id]
Min[Eigenvalues[Y]]

$Echo = DeleteCases[$Echo, "stdout"];
