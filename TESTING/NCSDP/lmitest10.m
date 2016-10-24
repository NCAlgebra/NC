AppendTo[$Echo, "stdout"]

<< NC`
<< NCAlgebra`

<< SDP`

<< NC`NCExtras`
<< NC`NCExpressionToFunction`
<< NC`NCSylvester`

(* Block Diagonal Example *)

m = 2
n = 3

(* Ai's *)
A1 = -{ {{1}}, {{0, 1},{1, 0}}, {{0, 0},{0, 0}} }
A2 = -{ {{0}}, {{1, 0},{0, 0}}, {{0, 1},{1, 0}} }
A3 = -{ {{0}}, {{0, 0},{0, 0}}, {{1, 0},{0, 0}} }
A= {A1, A2, A3}

(* y *)
y = {1,2,3};
Y = {{y[[1]],y[[2]]},{y[[2]],y[[3]]}};

(* X *)
X1 = { {{1}}, {{2,1},{1,2}}, {{3,2},{2,3}} };
X2 = { {{-1}}, {{0,-1},{-1,3}}, {{2,3},{3,-1}} };

(* Define matrix problem *)

SNC[a,b,c,d,x];

f = -{ a**x**tp[a], \
       b**x**tp[c]+c**x**tp[b]-b**x**tp[d]-d**x**tp[b], \
       2 d**x**tp[c]+2 c**x**tp[d]-4 d**x**tp[d] }
vars = {x}

data = {a -> {{1, 0}}, b -> {{1, 0}, {0, 0}}, c -> {{0, 1}, {1, 0}}, \
        d -> {{0, 1/2}, {0, 0}}} 

{FPrimalEval, FDualEval, FSylvesterEval, \
   FSylvesterDiagEval, FSylvesterSolve} = \
  SylvesterSDPFunctions[f, vars, data];

(* TEST EVALUATIONS *)
Z = FDualEval @@ {Y}
ZZ = FPrimalEval @@ X1

(* THESE SHOULD BE ALL ZEROS *)
Map[Norm, Z - SDPDualEval[A,y]]
Norm[ZZ - SDPPrimalEval[A,X1]]

(* TEST SYLVESTER *)
M1 = FSylvesterEval @@ {X1,X1}
M2 = FSylvesterEval @@ {X1,X2}

(* THESE SHOULD BE ALL ZEROES *)
Norm[Tr[M1 - SDPSylvesterEval[A, X1], List]]
Norm[Tr[M2 - SDPSylvesterEval[A, X1, X2], List]]

(* LYAPUNOV EXAMPLE *)

n = 3;
SeedRandom[1];

range = 10;
AA = RandomInteger[{-range,range}, {n,n}];

{DD,VV} = Eigensystem[N[AA]];

Norm[AA - Transpose[VV] . DiagonalMatrix[DD] . Inverse[Transpose[VV]]]
PosQ[x_] := (Abs[x] > 1);
DDn = DD /. x_?PosQ -> 1/x;

AA = Re[Transpose[VV] . DiagonalMatrix[DDn] . Inverse[Transpose[VV]]]

Eigenvalues[AA]

data = {a -> AA} 

f = { x - tp[a] ** x ** a, x }
vars = {x}

BB = -{ IdentityMatrix[n] }
CC = { -IdentityMatrix[n], -IdentityMatrix[n] }

{FPrimalEval, FDualEval, FSylvesterEval, \
   FSylvesterDiagEval, FSylvesterSolve} = \
  SylvesterSDPFunctions[f, vars, data];

(* TEST EVALUATIONS *)

Y = Transpose[AA] . AA

Z = FDualEval @@ {Y}
ZZ = FPrimalEval @@ Z
M1 = ArrayFlatten[FSylvesterEval @@ {Z,Z}]

$Echo = DeleteCases[$Echo, "stdout"];
