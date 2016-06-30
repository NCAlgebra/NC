AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->160];

<< NC`
<< NCAlgebra`

<< NC`NCExpressionToFunction`
<< NC`NCExtras`
<< NC`NCSylvester`

<< SDP`

(* example3: vectorized problem *)

Clear[f, b, Y, y, y0, y1, y2]

(* dual mapping *)
f = {a ** y ** tp[a], 
     b ** y ** tp[c] + c ** y ** tp[b] - b ** y ** tp[d] - d ** y ** tp[b],  
     2 d ** y ** tp[c] + 2 c ** y ** tp[d] - 4 d ** y ** tp[d]}
vars = {y}
symVars = {y}


(* Evaluate mappings *)

n = 2;
range = 10;
data = {a -> {{1, 0}}, b -> {{1, 0}, {0, 0}}, 
  c -> {{0, 1}, {1, 0}}, d -> {{0, 1/2}, {0, 0}}};
X = RandomReal[{-range,range}, {n,n}];
X += Transpose[X];

FDualEval = (ExpressionToFunction[f, vars] /. data);
AA = SylvesterToVectorized[f, vars, symVars, {{n,n}}, data];
Map[Norm, SDPDualEval[AA, SymmetricToVector[X]] - FDualEval @@ {X}]

(* primal mapping *)

SNC[z1, z2, z3];
adjVars = {z1, z2, z3};
symAdjVars = {z1, z2, z3};

fStar = NCAdjoint[f, adjVars, vars]

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[fStar, adjVars] /. data);
AA = SylvesterToVectorized[fStar, adjVars, symAdjVars, {{1,1},{n,n},{n,n}}, data];

Z1 = {{1}};

Z2 = RandomReal[{-range,range}, {n,n}];
Z2 += Transpose[Z2];

Z3 = RandomReal[{-range,range}, {n,n}];
Z3 += Transpose[Z3];

Zvec = Flatten[{SymmetricToVector[Z1], SymmetricToVector[Z2], SymmetricToVector[Z3]}];
Map[Norm, SDPDualEval[AA, Zvec] - FDualEval @@ {Z1, Z2, Z3}]


(* data for the remaining problems *)

n = 2;
range = 10;
RandomSeed[1];

A = RandomReal[{-range,range}, {n,n}];
X = RandomReal[{-range,range}, {n,n}];
X += Transpose[X];

Z1 = RandomReal[{-range,range}, {n,n}];
Z1 += Transpose[Z1];

Z2 = RandomReal[{-range,range}, {n,n}];
Z2 += Transpose[Z2];

data = {a -> A};


(* dual mapping: example 1 *)

SNC[a,b,c,d,x,y];

f = {tp[a] ** x + x ** a, -x};
vars = {x};
symVars = {x};

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[f, vars] /. data);
AA = SylvesterToVectorized[f, vars, symVars, {{n,n}}, data];
Map[Norm, SDPDualEval[AA, SymmetricToVector[X]] - FDualEval @@ {X}]


(* primal mapping *)

SNC[z1, z2];
adjVars = {z1, z2};
symAdjVars = {z1, z2};

fStar = NCAdjoint[f, adjVars, vars]

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[fStar, adjVars] /. data)
AA = SylvesterToVectorized[fStar, adjVars, symAdjVars, {{n,n},{n,n}}, data];

Zvec = Flatten[{SymmetricToVector[Z1], SymmetricToVector[Z2]}];
Map[Norm, SDPDualEval[AA, Zvec] - FDualEval @@ {Z1, Z2}]


(* dual mapping: example 2 *)

f = {tp[a] ** x ** a - x, -x};
vars = {x};
symVars = {x};

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[f, vars] /. data);
AA = SylvesterToVectorized[f, vars, symVars, {{n,n}}, data];
Map[Norm, SDPDualEval[AA, SymmetricToVector[X]] - FDualEval @@ {X}]

(* primal mapping *)

SNC[z1, z2];
adjVars = {z1, z2};
symAdjVars = {z1, z2};

fStar = NCAdjoint[f, adjVars, vars]

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[fStar, adjVars] /. data)
AA = SylvesterToVectorized[fStar, adjVars, symAdjVars, {{n,n},{n,n}}, data];

Zvec = Flatten[{SymmetricToVector[Z1], SymmetricToVector[Z2]}];
Map[Norm, SDPDualEval[AA, Zvec] - FDualEval @@ {Z1, Z2}]


(* example with two symmetric variables, stabilization *)

(* dual mapping *)

SNC[a,b,c,d,x,y];

f = {a ** x + x ** tp[a] + b ** y + tp[y] ** tp[b], -x};
vars = {x,y};
symVars = {x,y};

B = RandomReal[{-range,range}, {n,n}];
Y = RandomReal[{-range,range}, {n,n}];
Y += Transpose[Y];

data = {a -> A, b -> B};

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[f, vars] /. data);
AA = SylvesterToVectorized[f, vars, symVars, {{n,n},{n,n}}, data];
vecX = Join[SymmetricToVector[X], SymmetricToVector[Y]];
Map[Norm, SDPDualEval[AA, vecX] - FDualEval @@ {X, Y}]


(* primal mapping *)

SNC[z1, z2];
adjVars = {z1, z2};

fStar = NCAdjoint[f, adjVars, vars]

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[fStar, adjVars] /. data)
AA = SylvesterToVectorized[fStar, adjVars, symAdjVars, {{n,n},{n,n}}, data];

Zvec = Flatten[{SymmetricToVector[Z1], SymmetricToVector[Z2]}];
Map[Norm, SDPDualEval[AA, Zvec] - FDualEval @@ {Z1, Z2}]


(* example with two variables, stabilization *)

(* dual mapping *)

SNC[a,b,c,d,x,y];

f = {a ** x + x ** tp[a] + b ** y + tp[y] ** tp[b], -x} /. x -> (x+tp[x])/2;
vars = {x,y};
symVars = {x};

m = 1;
B = RandomReal[{-range,range}, {n,m}];
Y = RandomReal[{-range,range}, {m,n}];

data = {a -> A, b -> B};

(* Evaluate mappings *)

FDualEval = (ExpressionToFunction[f, vars] /. data);
AA = SylvesterToVectorized[f, vars, symVars, {{n,n},{m,n}}, data];
vecX = Join[SymmetricToVector[X], Flatten[Y]];
Map[Norm, SDPDualEval[AA, vecX] - FDualEval @@ {X, Y}]

Quit


fCoeff
Map[SylvesterVectorizeCoefficientList, fCoeff]

(* primal mapping *)

SNC[z1, z2];
adjVars = {z1, z2};

fStar = NCAdjointSymmetric[f, adjVars, vars];
fStar - {-z2 + tp[a] ** z1 + z1 ** a, 2 tp[b] ** z1}

fStarCoeff = Map[SylvesterCoefficientList[#, adjVars] &, fStar];
fStarCoeffExpand = Map[SylvesterExpandCoefficientList[#, adjVars] &, fStarCoeff];
fStar - fStarCoeffExpand

fStarCoeff
Map[SylvesterVectorizeCoefficientList, fStarCoeff]

(* scaled dual mapping *)

SNC[w1, w2];
scaleVars = {w1, w2};

fScaled = MapThread[NonCommutativeMultiply, {scaleVars, f, scaleVars}];
fScaled - {w1 ** (a ** x + b ** y + x ** tp[a] + tp[y] ** tp[b]) ** w1, 
           -w2 ** x ** w2}

fScaledCoeff = Map[SylvesterCoefficientList[#, vars] &, fScaled];
fScaledCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
fScaled - fScaledCoeffExpand // NCExpand


(* Sylvester mapping *)

Sylv = fStar /. MapThread[Rule, {adjVars, fScaled}];
Sylv - {w2 ** x ** w2 + tp[a] ** w1 ** (a ** x + b ** y + x ** tp[a] + tp[y] ** tp[b]) ** w1 + w1 ** (a ** x + b ** y + x ** tp[a] + tp[y] ** tp[b]) ** w1 ** a, 
    2 tp[b] ** w1 ** (a ** x + b ** y + x ** tp[a] + tp[y] ** tp[b]) ** w1} // NCExpand

SylvCoeff = Map[SylvesterCoefficientList[#, vars] &, Sylv];
SylvCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
Sylv - SylvCoeffExpand // NCExpand

NCExpand[Sylv]
SylvCollect = SylvesterCollect[Sylv, vars]
Sylv - SylvCollect // NCExpand
Map[Length,Sylv]
Map[Length,NCExpand[Sylv]]
Map[Length,SylvCollect]

SylvCoeff
SylvCoeffVec = Map[SylvesterVectorizeCoefficientList, SylvCoeff]

n = 6;
m = 2;
range = 10;

A = RandomReal[{-range,range}, {n,n}]
B = RandomReal[{-range,range}, {n,m}]

Q1 = RandomInteger[{-range,range}, {n,n}];
Q1 = Q1 + Transpose[Q1];

Q2 = RandomInteger[{-range,range}, {m,n}];

W1 = RandomInteger[{-range,range}, {n,n}];
W1 = Transpose[W1] . W1

W2 = RandomInteger[{-range,range}, {n,n}];
W2 = Transpose[W2] . W2

data = {a -> A, b -> B}

SylvEval = ExpressionToFunction[SylvCoeff, {w1, w2}] /. data

s = SylvEval @@ {W1, W2}

{dx, dy} = SylvesterSolve[s, {Q1, Q2}]

MatrixForm[dx]
MatrixForm[dy]

{dx, dy} = SylvesterSolve[s, {Q1, Q2}, {1}]

MatrixForm[dx]
MatrixForm[dy]


Quit

MM = ArrayFlatten[s];
Norm[MM - Transpose[MM]]
N[Eigenvalues[MM]]

p = LowerTriangularProjection[n,n]
sp = { {s[[1,1,p,p]], s[[1,2,p,All]]},
       {s[[2,1,All,p]], s[[2,2,All,All]]} }

Map[Dimensions,sp,{1}]
MMp = ArrayFlatten[sp];
Norm[MMp - Transpose[MMp]]
N[Eigenvalues[MMp]]

$Echo = DeleteCases[$Echo, "stdout"];
