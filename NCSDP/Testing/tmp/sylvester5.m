AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< Sylvester`
<< SDP`
<< SDPSylvester`

(* All you should see are zeros *)

A={{-1,1},{0,-2}};
B={{2,1},{1,2}};
Q=IdentityMatrix[2];

(* Test #1 : One symmetric variable, one inequality, reduced *)

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

y = SymmetricToVector[Y]

AAvec = SylvesterDualVectorize[AA, dims, syms, True]
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]]

XSDP = SDPDualEval[AASDP, y]
XSyl = SylvesterDualEval[AA, {Y}]
Map[Norm, XSDP - XSyl]

ySDP = SDPPrimalEval[AASDP, XSyl]
ySyl = SylvesterPrimalEval[AA, XSyl, syms]
Map[Norm, Flatten[Map[SymmetricToVector[#, 2]&, ySyl]] - ySDP]

<< SDP`

{F1PrimalEval, F1DualEval, 
 F1SylvesterEval, F1SylvesterDiagonalEval, 
 F1SylvesterSolve, F1SylvesterSolveFactored} \
  = SDPFunctions[{AASDP, {{y}}, XSyl}];

<< SDPSylvester`

{F2PrimalEval, F2DualEval, 
 F2SylvesterEval, F2SylvesterDiagonalEval, 
 F2SylvesterSolve, F2SylvesterSolveFactored} \
  = SDPFunctions[AA, BB, CC, syms];

Map[Norm, F1DualEval @@ {{y}} - F2DualEval @@ {Y}]
Map[{SymmetricToVector[#,2]}&, F2PrimalEval @@ XSyl];
Map[Norm, % - F1PrimalEval @@ XSyl]
Norm[F1SylvesterEval @@ {XSyl, XSyl} - F2SylvesterEval @@ {XSyl, XSyl}]

(* Test #2 : One symmetric variable, two inequalities, reduced *)

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

y = SymmetricToVector[Y]

AAvec = SylvesterDualVectorize[AA, dims, syms, True]
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]]

XSDP = SDPDualEval[AASDP, y]
XSyl = SylvesterDualEval[AA, {Y}]
Map[Norm, XSDP - XSyl]

ySDP = SDPPrimalEval[AASDP, XSyl]
ySyl = SylvesterPrimalEval[AA, XSyl, syms]
Map[Norm, Flatten[Map[SymmetricToVector[#, 2]&, ySyl]] - ySDP]

<< SDP`

{F1PrimalEval, F1DualEval, 
 F1SylvesterEval, F1SylvesterDiagonalEval, 
 F1SylvesterSolve, F1SylvesterSolveFactored} \
  = SDPFunctions[{AASDP, {{y}}, XSyl}];

<< SDPSylvester`

{F2PrimalEval, F2DualEval, 
 F2SylvesterEval, F2SylvesterDiagonalEval, 
 F2SylvesterSolve, F2SylvesterSolveFactored} \
  = SDPFunctions[AA, BB, CC, syms];

Map[Norm, F1DualEval @@ {{y}} - F2DualEval @@ {Y}]
Map[{SymmetricToVector[#,2]}&, F2PrimalEval @@ XSyl];
Map[Norm, % - F1PrimalEval @@ XSyl]
Norm[F1SylvesterEval @@ {XSyl, XSyl} - F2SylvesterEval @@ {XSyl, XSyl}]

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
BB={IdentityMatrix[2], ConstantArray[0, {1, 2}]};

syms = {True,False};
dims=Map[Dimensions,{Y,K}]

y = Flatten[{SymmetricToVector[Y],ToVector[K]}];

AAvec = SylvesterDualVectorize[AA, dims, syms, True]
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]]

XSDP = SDPDualEval[AASDP, y]
XSyl = SylvesterDualEval[AA, {Y,K}]
Map[Norm, XSDP - XSyl]

ySDP = SDPPrimalEval[AASDP, XSyl]
ySyl = SylvesterPrimalEval[AA, XSyl, syms]
Map[Norm, Flatten[MapAt[SymmetricToVector[#, 2]&, ySyl, {1}]] - ySDP]

<< SDP`

{F1PrimalEval, F1DualEval, 
 F1SylvesterEval, F1SylvesterDiagonalEval, 
 F1SylvesterSolve, F1SylvesterSolveFactored} \
  = SDPFunctions[{AASDP, {{y}}, XSyl}];

<< SDPSylvester`

{F2PrimalEval, F2DualEval, 
 F2SylvesterEval, F2SylvesterDiagonalEval, 
 F2SylvesterSolve, F2SylvesterSolveFactored} \
  = SDPFunctions[AA, BB, CC, syms]

{F2PrimalEval, F2DualEval, 
 F2SylvesterEval, F2SylvesterDiagonalEval, 
 F2SylvesterSolve, F2SylvesterSolveFactored} \
  = SDPFunctions[{AA, BB, CC}, SymmetricVariables -> {1} ]

Map[Norm, F1DualEval @@ {{y}} - F2DualEval @@ {Y,K}]
{{Flatten[MapAt[{SymmetricToVector[#,2]}&, F2PrimalEval @@ XSyl, {1}]]}}
Map[Norm, % - F1PrimalEval @@ XSyl]
Norm[F1SylvesterEval @@ {XSyl, XSyl} - F2SylvesterEval @@ {XSyl, XSyl}]

$Echo = DeleteCases[$Echo, "stdout"];
