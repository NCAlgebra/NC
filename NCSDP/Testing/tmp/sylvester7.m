AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< SDP`
<< cSDP`

(* All you should see are zeros *)

n = 40;

Id = IdentityMatrix[n];
A = RandomReal[{-10,10}, {n, n}];
A -= 1.1 * Max[Re[Eigenvalues[A]]] * Id;
Ze = ConstantArray[0, {n,n}];

(* Test #1 : Lyapunov inequality *)

AA = {
 {
   {2 A,Id}
 }
 ,
 {
   {-Id,Id}
 }
};
CC={-Id, Ze};
BB={-Id};

<< Sylvester`

dims = {{n,n}};
syms = {True};
AAvec = SylvesterDualVectorize[AA, dims, syms, True];
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]];
BBSDP = {{SymmetricToVector[BB[[1]], 2]}};

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
