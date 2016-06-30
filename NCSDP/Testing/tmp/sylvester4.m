AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< Sylvester`

<< SDP`

(* All you should see are zeros *)

(* Test #1 *)

A={{-1,1},{0,-2}};
B={{2,1},{1,2}};
Q=IdentityMatrix[2];

AA={
{
{ArrayFlatten[{{Transpose[A],B}}],ArrayFlatten[{{Transpose[B],A}}]}
}
};
CC={-Q};
BB={IdentityMatrix[2]};

Y={{1,3},{3,2}}
syms = {True};
dims = Map[Dimensions,{Y}]

(* Test #1 : One symmetric variable, one inequality *)

y = {ToVector[Y]}

AA1 = SylvesterDualVectorize[AA, dims, syms]
AASDP1 = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AA1], {2}]]

X11 = SDPDualEval[AASDP1, Flatten[y]]
X1 = SylvesterDualEval[AA,{Y}]
Map[Norm, X1 - X11]

y11 = {SDPPrimalEval[AASDP1, X1]}
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]]
Norm[y1 - y11]

H11 = SDPSylvesterEval[AASDP1, X1]
H1 = SylvesterSylvesterVecEval[AA, X11, dims, syms]
Norm[H1 - H11]

(* Test #2 : One symmetric variable, one inequality, reduced *)

y = {SymmetricToVector[Y]}

AA2 = SylvesterDualVectorize[AA, dims, syms, True]
AASDP2 = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AA2], {2}]]

X22 = SDPDualEval[AASDP2, Flatten[y]]
X2 = SylvesterDualEval[AA,{Y}]
Map[Norm, X2 - X22]

y22 = {SDPPrimalEval[AASDP2, X2]}
y2 = Map[SymmetricToVector, SylvesterPrimalEval[AA,X2,syms]]
Map[Norm, y2 - y22]

H22 = SDPSylvesterEval[AASDP2, X2]
H2 = SylvesterSylvesterVecEval[AA, X22, dims, syms, True]
Norm[H2 - H22]

AA={
{
{IdentityMatrix[2],IdentityMatrix[2]}
}
,
{
{Transpose[A],Transpose[B]}
}
};
CC={-Q,-Q};
BB={IdentityMatrix[2]};

Y={{1,3},{3,2}}
syms = {True};
dims=Map[Dimensions,{Y}]

(* Test #3 : One symmetric variable, two inequalities *)

y = {ToVector[Y]}

AA1 = SylvesterDualVectorize[AA, dims, syms]
AASDP1 = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AA1], {2}]]

X11 = SDPDualEval[AASDP1, Flatten[y]]
X1 = SylvesterDualEval[AA,{Y}]
Map[Norm, X1 - X11]

y11 = {SDPPrimalEval[AASDP1, X1]}
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]]
Norm[y1 - y11]

H11 = SDPSylvesterEval[AASDP1, X1]
H1 = SylvesterSylvesterVecEval[AA, X11, dims, syms]
Norm[H1 - H11]

(* Test #4 : One symmetric variable, two inequalities, reduced *)

y = {SymmetricToVector[Y]}

AA2 = SylvesterDualVectorize[AA, dims, syms, True]
AASDP2 = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AA2], {2}]]

X22 = SDPDualEval[AASDP2, Flatten[y]]
X2 = SylvesterDualEval[AA,{Y}]
Map[Norm, X2 - X22]

y22 = {SDPPrimalEval[AASDP2, X2]}
y2 = Map[SymmetricToVector, SylvesterPrimalEval[AA,X2,syms]]
Map[Norm, y2 - y22]

H22 = SDPSylvesterEval[AASDP2, X2]
H2 = SylvesterSylvesterVecEval[AA, X22, dims, syms, True]
Norm[H2 - H22]

(* Test #3 : Two variable, three inequalities *)

F={{3},{7}};
K={{-1,2}};
syms={True,False};

AA={
{
{IdentityMatrix[2],IdentityMatrix[2]}
,
{ConstantArray[0,{2,1}],ConstantArray[0,{2,2}]}
}
,
{
{Transpose[A],Transpose[B]}
,
{F,IdentityMatrix[2]}
}
,
{
{ConstantArray[0,{3,2}],ConstantArray[0,{2,3}]}
,
{{{0},{0},{1}},{{1,0,0},{0,1,0}}}
}
};
CC={-Q,-Q};
BB={IdentityMatrix[2]};

syms = {True,False};
dims=Map[Dimensions,{Y,K}]

y = {Flatten[{ToVector[Y],ToVector[K]}]};

AA1 = SylvesterDualVectorize[AA, dims, syms]
AASDP1 = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AA1], {2}]]

X11 = SDPDualEval[AASDP1, Flatten[y]]
X1 = SylvesterDualEval[AA,{Y,K}]
Map[Norm, X1 - X11]

y11 = {SDPPrimalEval[AASDP1, X1]}
y1 = {Flatten[ Map[ToVector, SylvesterPrimalEval[AA,X1,syms]], 1]}
Norm[y1 - y11]

H11 = SDPSylvesterEval[AASDP1, X1]
H1 = SylvesterSylvesterVecEval[AA, X11, dims, syms]
Norm[H1 - H11]

(* Test #3 : Two variable, three inequalities, reduced *)

y = {Flatten[{SymmetricToVector[Y],ToVector[K]}]};

AA2 = SylvesterDualVectorize[AA, dims, syms, True]
AASDP2 = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AA2], {2}]]

X22 = SDPDualEval[AASDP2, Flatten[y]]
X2 = SylvesterDualEval[AA,{Y,K}]
Map[Norm, X2 - X22]

y22 = {SDPPrimalEval[AASDP2, X2]}
y2 = {Flatten[ MapAt[SymmetricToVector, SylvesterPrimalEval[AA,X2,syms],{1}], 2]}
Map[Norm, y2 - y22]

H22 = SDPSylvesterEval[AASDP2, X2]
H2 = SylvesterSylvesterVecEval[AA, X22, dims, syms, True]
Norm[H2 - H22]

$Echo = DeleteCases[$Echo, "stdout"];
