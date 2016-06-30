AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< SDP`

(* All you should see are zeros *)

A = {{-1,1},{0,-2}};
B = {{2,1},{1,2}};
Id = IdentityMatrix[2];
Ze = ConstantArray[0, {2,2}];

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

dims = {{2,2}}
syms = {True}
AAvec = SylvesterDualVectorize[AA, dims, syms, True]
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]]

BBSDP = {{SymmetricToVector[BB[[1]], 2]}}

{Y, X, S, iters} = \
  SDPSolve[{AASDP, BBSDP, CC}, DebugLevel -> 0];
Y
Y = ToSymmetricMatrix[Part[Y, 1, 1], 2]
A . Y + Y . Transpose[A] + Id
Eigenvalues[Y]

<< SDPSylvester`

{Y, X, S, iters} = \
  SDPSolve[{AA, BB, CC}, SymmetricVariables -> {1}, DebugLevel -> 0];
Y
Y = Part[Y, 1];
A . Y + Y . Transpose[A] + Id
Eigenvalues[Y]

$Echo = DeleteCases[$Echo, "stdout"];
