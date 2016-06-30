AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->160];

<< NC`
<< NCAlgebra`

<< NC`NCExpressionToFunction`
<< NC`NCExtras`
<< NC`NCSylvester`

(* first example, lyapunov discrete *)

(* dual mapping *)

SNC[a,b,c,d,x,y];

f = {tp[a] ** x ** a - x, -x};
vars = {x};

fCoeff = Map[SylvesterCoefficientList[#, vars]&, f]
fCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %]
f - fCoeffExpand

fCoeff
Map[SylvesterVectorizeCoefficientList, fCoeff]

(* primal mapping *)

SNC[z1, z2];
adjVars = {z1, z2};

fStar = NCAdjoint[f, adjVars, vars];
fStar - {-z1 - z2 + a ** z1 ** tp[a]}

fStarCoeff = Map[SylvesterCoefficientList[#, adjVars] &, fStar];
fStarCoeffExpand = Map[SylvesterExpandCoefficientList[#, adjVars] &, fStarCoeff];
fStar - fStarCoeffExpand

fStarCoeff
Map[SylvesterVectorizeCoefficientList, fStarCoeff]

(* scaled dual mapping *)

SNC[w1, w2];
scaleVars = {w1, w2};

fScaled = MapThread[NonCommutativeMultiply, {scaleVars, f, scaleVars}];
fScaled - {w1 ** (-x + tp[a] ** x ** a) ** w1, -w2 ** x ** w2}

fScaledCoeff = Map[SylvesterCoefficientList[#, vars] &, fScaled];
fScaledCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
fScaled - fScaledCoeffExpand // NCExpand


(* Sylvester mapping *)

Sylv = fStar /. MapThread[Rule, {adjVars, fScaled}];
Sylv - {w1 ** x ** w1 + w2 ** x ** w2 - a ** w1 ** x ** w1 ** tp[a] - 
  w1 ** tp[a] ** x ** a ** w1 + 
  a ** w1 ** tp[a] ** x ** a ** w1 ** tp[a]} // NCExpand

SylvCoeff = Map[SylvesterCoefficientList[#, vars] &, Sylv];
SylvCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
Sylv - SylvCoeffExpand // NCExpand

Sylv
SylvCollect = Map[SylvesterCollect[#, x]&, Sylv]
Sylv - SylvCollect // NCExpand
Map[Length, NCExpand[Sylv]]
Map[Length, SylvCollect]

SylvCoeff
Map[SylvesterVectorizeCoefficientList, SylvCoeff]


(* Second example, vectorized problem *)

Clear[f, b, Y, y, y0, y1, y2]

(* dual mapping *)
f = {a ** y ** tp[a], 
     b ** y ** tp[c] + c ** y ** tp[b] - b ** y ** tp[d] - d ** y ** tp[b],  
     2 d ** y ** tp[c] + 2 c ** y ** tp[d] - 4 d ** y ** tp[d]}
vars = {y}

fCoeff = Map[SylvesterCoefficientList[#, vars]&, f];
fCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
f - fCoeffExpand

fCoeff
Map[SylvesterVectorizeCoefficientList, fCoeff]


(* primal mapping *)

SNC[z1, z2, z3];
adjVars = {z1, z2, z3};

fStar = NCAdjoint[f, adjVars, vars]
fStar - {tp[a] ** z1 ** a + tp[b] ** z2 ** c - tp[b] ** z2 ** d + 
  tp[c] ** z2 ** b + 2 tp[c] ** z3 ** d - tp[d] ** z2 ** b + 
  2 tp[d] ** z3 ** c - 4 tp[d] ** z3 ** d}

fStarCoeff = Map[SylvesterCoefficientList[#, adjVars] &, fStar];
fStarCoeffExpand = Map[SylvesterExpandCoefficientList[#, adjVars] &, fStarCoeff];
fStar - fStarCoeffExpand

fStarCoeff
Map[SylvesterVectorizeCoefficientList, fStarCoeff]

(* scaled dual mapping *)

SNC[w1, w2, w3];
scaleVars = {w1, w2, w3};

fScaled = MapThread[NonCommutativeMultiply, {scaleVars, f, scaleVars}];
fScaled - {w1 ** a ** y ** tp[a] ** w1, 
 w2 ** (b ** y ** tp[c] - b ** y ** tp[d] + c ** y ** tp[b] - 
    d ** y ** tp[b]) ** w2, 
 w3 ** (2 c ** y ** tp[d] + 2 d ** y ** tp[c] - 4 d ** y ** tp[d]) ** 
  w3}

fScaledCoeff = Map[SylvesterCoefficientList[#, vars] &, fScaled];
fScaledCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
fScaled - fScaledCoeffExpand // NCExpand


(* Sylvester mapping *)

Sylv = fStar /. MapThread[Rule, {adjVars, fScaled}]
Sylv - {tp[a] ** w1 ** a ** y ** tp[a] ** w1 ** a + 
  tp[b] ** w2 ** b ** y ** tp[c] ** w2 ** c - 
  tp[b] ** w2 ** b ** y ** tp[c] ** w2 ** d - 
  tp[b] ** w2 ** b ** y ** tp[d] ** w2 ** c + 
  tp[b] ** w2 ** b ** y ** tp[d] ** w2 ** d + 
  tp[b] ** w2 ** c ** y ** tp[b] ** w2 ** c - 
  tp[b] ** w2 ** c ** y ** tp[b] ** w2 ** d - 
  tp[b] ** w2 ** d ** y ** tp[b] ** w2 ** c + 
  tp[b] ** w2 ** d ** y ** tp[b] ** w2 ** d + 
  tp[c] ** w2 ** b ** y ** tp[c] ** w2 ** b - 
  tp[c] ** w2 ** b ** y ** tp[d] ** w2 ** b + 
  tp[c] ** w2 ** c ** y ** tp[b] ** w2 ** b - 
  tp[c] ** w2 ** d ** y ** tp[b] ** w2 ** b + 
  4 tp[c] ** w3 ** c ** y ** tp[d] ** w3 ** d + 
  4 tp[c] ** w3 ** d ** y ** tp[c] ** w3 ** d - 
  8 tp[c] ** w3 ** d ** y ** tp[d] ** w3 ** d - 
  tp[d] ** w2 ** b ** y ** tp[c] ** w2 ** b + 
  tp[d] ** w2 ** b ** y ** tp[d] ** w2 ** b - 
  tp[d] ** w2 ** c ** y ** tp[b] ** w2 ** b + 
  tp[d] ** w2 ** d ** y ** tp[b] ** w2 ** b + 
  4 tp[d] ** w3 ** c ** y ** tp[d] ** w3 ** c - 
  8 tp[d] ** w3 ** c ** y ** tp[d] ** w3 ** d + 
  4 tp[d] ** w3 ** d ** y ** tp[c] ** w3 ** c - 
  8 tp[d] ** w3 ** d ** y ** tp[c] ** w3 ** d - 
  8 tp[d] ** w3 ** d ** y ** tp[d] ** w3 ** c + 
  16 tp[d] ** w3 ** d ** y ** tp[d] ** w3 ** d} // NCExpand

SylvCoeff = Map[SylvesterCoefficientList[#, vars] &, Sylv]
SylvCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
Sylv - SylvCoeffExpand // NCExpand

NCExpand[Sylv]
SylvCollect = Map[SylvesterCollect[#, vars]&, Sylv]
Sylv - SylvCollect // NCExpand
Map[Length,Sylv]
Map[Length,NCExpand[Sylv]]
Map[Length,SylvCollect]

SylvCoeff
Map[SylvesterVectorizeCoefficientList, SylvCoeff]

(* example with two symmetric variables, stabilization *)

(* dual mapping *)

SNC[a,b,c,d,x,y];

f = {tp[a] ** x + x ** a + tp[b] ** y + y ** b, -x};
vars = {x,y};

fCoeff = Map[SylvesterCoefficientList[#, vars]&, f];
fCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
f - fCoeffExpand

fCoeff
Map[SylvesterVectorizeCoefficientList, fCoeff]

(* primal mapping *)

SNC[z1, z2];
adjVars = {z1, z2};

fStar = NCAdjoint[f, adjVars, vars]
fStar - {-z2 + a ** z1 + z1 ** tp[a], b ** z1 + z1 ** tp[b]}

fStarCoeff = Map[SylvesterCoefficientList[#, adjVars] &, fStar];
fStarCoeffExpand = Map[SylvesterExpandCoefficientList[#, adjVars] &, fStarCoeff];
fStar - fStarCoeffExpand

fStarCoeff
Map[SylvesterVectorizeCoefficientList, fStarCoeff]

(* scaled dual mapping *)

SNC[w1, w2];
scaleVars = {w1, w2};

fScaled = MapThread[NonCommutativeMultiply, {scaleVars, f, scaleVars}];
fScaled - {w1 ** (x ** a + y ** b + tp[a] ** x + tp[b] ** y) ** w1, 
           -w2 ** x ** w2}

fScaledCoeff = Map[SylvesterCoefficientList[#, vars] &, fScaled];
fScaledCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
fScaled - fScaledCoeffExpand // NCExpand


(* Sylvester mapping *)

Sylv = fStar /. MapThread[Rule, {adjVars, fScaled}]
Sylv - {w2 ** x ** w2 + a ** w1 ** (x ** a + y ** b + tp[a] ** x + tp[b] ** y) ** w1 + w1 ** (x ** a + y ** b + tp[a] ** x + tp[b] ** y) ** w1 ** tp[a], 
    b ** w1 ** (x ** a + y ** b + tp[a] ** x + tp[b] ** y) ** w1 + w1 ** (x ** a + y ** b + tp[a] ** x + tp[b] ** y) ** w1 ** tp[b]} // NCExpand

SylvCoeff = Map[SylvesterCoefficientList[#, vars] &, Sylv];
SylvCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
Sylv - SylvCoeffExpand // NCExpand

NCExpand[Sylv]
SylvCollect = Map[SylvesterCollect[#, vars]&, Sylv]
Sylv - SylvCollect // NCExpand
Map[Length,Sylv]
Map[Length,NCExpand[Sylv]]
Map[Length,SylvCollect]

SylvCoeff
Map[SylvesterVectorizeCoefficientList, SylvCoeff]


(* example with two variables, stabilization *)

(* dual mapping *)

SNC[a,b,c,d,x,y];

f = {a ** x + x ** tp[a] + b ** y + tp[y] ** tp[b], -x} /. x -> (x+tp[x])/2;
vars = {x,y};

fCoeff = Map[SylvesterCoefficientList[#, vars]&, f];
fCoeffExpand = Map[SylvesterExpandCoefficientList[#, vars] &, %];
f - fCoeffExpand

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
SylvCollect = Map[SylvesterCollect[#, vars]&, Sylv]
Sylv - SylvCollect // NCExpand
Map[Length,Sylv]
Map[Length,NCExpand[Sylv]]
Map[Length,SylvCollect]

SylvCoeff
SylvCoeffVec = Map[SylvesterVectorizeCoefficientList, SylvCoeff]

$Echo = DeleteCases[$Echo, "stdout"];
