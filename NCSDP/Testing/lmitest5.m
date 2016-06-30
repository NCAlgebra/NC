AppendTo[$Echo, "stdout"]

<< SDP`
<< cSDP`

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

(* X *)
X1 = { {{1}}, {{2,1},{1,2}}, {{3,2},{2,3}} };
X2 = { {{-1}}, {{0,-1},{-1,3}}, {{2,3},{3,-1}} };

(* Get problem data *)
{AA,n,sizeBlocks} = SDPcData[{A,y,X1}]

(* TEST EVALUATIONS *)
Z = SDPcDualEval[sizeBlocks,y]

ZZ = SDPcPrimalEval[X1]

(* THESE SHOULD BE ALL ZEROS *)
Map[Norm, Z - SDPDualEval[A,y]]
Norm[ZZ - SDPPrimalEval[A,X1]]

(* TEST SYLVESTER *)
M1 = SDPcSylvesterEval[n,X1]
M2 = SDPcSylvesterEval[n,X1,X2]

(* THESE SHOULD BE ALL ZEROES *)
Norm[Tr[M1 - SDPSylvesterEval[A, X1], List]]
Norm[Tr[M2 - SDPSylvesterEval[A, X1, X2], List]]

(* TEST LMI FUNCTIONS *)
{FPrimalEval, FDualEval, \
 FSylvesterEval, FSylvesterDiagonalEval, FSylvesterSolve} \
  = SDPFunctions[AA,n,sizeBlocks]

FPrimalEval @@ X1
FDualEval @@ {{y}}
FSylvesterEval @@ {X1, X1}
FSylvesterDiagonalEval @@ {X1, X1}

{FPrimalEval, FDualEval, \
 FSylvesterEval, FSylvesterDiagonalEval, FSylvesterSolve} \
  = SDPFunctions[{A,y,X1}]

H = SDPcSylvesterEval[n,X1]
x = SDPcSylvesterSolve[X1,ZZ]
Norm[H . x - ZZ]

ZZ2 = SDPcPrimalEval[X2]
x = SDPcSylvesterSolve[X1,{ZZ,ZZ2}]
Norm[H . x[[1]] - ZZ]
Norm[H . x[[2]] - ZZ2]

x = SDPcSylvesterSolve[X1,{ZZ,ZZ2,ZZ,ZZ2}]

RHS = {ZZ,ZZ2}
x = SDPcSylvesterSolve[X1,RHS]
RHS

$Echo = DeleteCases[$Echo, "stdout"];
