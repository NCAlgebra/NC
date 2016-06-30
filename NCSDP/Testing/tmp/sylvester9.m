AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->170];

<< Sylvester`

(* Riccati *)

n=3;
m=2;
SeedRandom[1234];

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

(* Eval *)

X11 = { A . X + X . Transpose[A] + B . L + Transpose[B . L], 
        -ArrayFlatten[{{W, L}, {Transpose[L], X}}] };
X1 = SylvesterDualEval[AA,{X,L,W}];
Map[Norm, X11 - X1]

(* Vec Eval *)

y = {Flatten[{ToVector[X],ToVector[L],ToVector[W]}]};

AAA1 = SylvesterDualVectorize[AA, dims, syms];
x1 = Map[ToVector, X1];
x11 = Map[Dot[#,y[[1]]]&, AAA1];
Map[Norm, x1 - x11]

AAA1t = SylvesterPrimalVectorize[AA, dims, syms];
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, Flatten[x1]]&, AAA1t];
Map[Norm, y1 - y11]

AAA1 = ArrayFlatten[Transpose[{AAA1}]];
AAA1t = ArrayFlatten[Transpose[{AAA1t}]];

(* X11 = {IdentityMatrix[n],IdentityMatrix[n+m]}; *)

X11Scale = ConstantArray[0, {n*n+(n+m)*(n+m),n*n+(n+m)*(n+m)}];
X11Scale[[1;;n*n,1;;n*n]] = KroneckerProduct[X11[[1]], X11[[1]]];
X11Scale[[n*n+1;;n*n+(n+m)*(n+m),n*n+1;;n*n+(n+m)*(n+m)]] = KroneckerProduct[X11[[2]], X11[[2]]];

H1 = AAA1t . X11Scale . AAA1;
H11 = SylvesterSylvesterVecEval[AA, X11, dims, syms];
Norm[H1 - H11]

(* Term 11 *)

(* 
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
*)

AAAA11  = KroneckerProduct[Transpose[Id], (2 A)];
AAAA11 += Part[ AAAA11, TransposePermutation[n,n], All];
AAAA11 /= 2;

AAAA12	= KroneckerProduct[IdX, (- IdX)];
AAAA12 += Part[ AAAA12, TransposePermutation[n+m,n+m], All];
AAAA12 /= 2;

AAAA1 = ArrayFlatten[{{AAAA11}, {AAAA12}}];

Norm[AAAA1 - AAA1[[All,1;;9]]]

AAAA11t  = KroneckerProduct[Id, Transpose[2 A]];
AAAA11t += Part[ AAAA11t,
                 TransposePermutation[n,n], 
                 TransposePermutation[n,n] ];
AAAA11t /= 2;

AAAA12t  = KroneckerProduct[Transpose[IdX], Transpose[-IdX]];
AAAA12t += Part[ AAAA12t, 
                 TransposePermutation[n,n],
                 TransposePermutation[n+m,n+m] ];
AAAA12t /= 2;

AAAA1t = ArrayFlatten[{{AAAA11t, AAAA12t}}];

Norm[AAAA1t - AAA1t[[1;;9,All]]]

U111 = KroneckerProduct[Id . X11[[1]] . Transpose[Id], 
                        Transpose[2 A] . X11[[1]] . (2 A)];
U112 = KroneckerProduct[Transpose[IdX] . X11[[2]] . IdX, 
                        (- Transpose[IdX]) . X11[[2]] . (- IdX)];
U11 = U111 + U112;

V111 = KroneckerProduct[Id . X11[[1]] . (2 A), 
                        Transpose[2 A] . X11[[1]] . Transpose[Id]];
V112 = KroneckerProduct[Transpose[IdX] . X11[[2]] . (-IdX), 
                        Transpose[-IdX] . X11[[2]] . IdX];
V11 = V111 + V112;

S11 = (U11 + Part[V11, All, TransposePermutation[n,n]]) / 4;
S11 += Part[S11, TransposePermutation[n,n], All];

Norm[H1[[1;;9,1;;9]] - S11]

Norm[H1[[1;;9,1;;9]] - H11[[1;;9,1;;9]]]


(* Term 22 *)

(* 
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
*)

AAAA21  = KroneckerProduct[Transpose[Id], (2 B)];
AAAA21 += Part[ AAAA21, TransposePermutation[n,n], All];
AAAA21 /= 2;

AAAA22	= KroneckerProduct[IdX, (-2 IdW)];
AAAA22 += Part[ AAAA22, TransposePermutation[n+m,n+m], All];
AAAA22 /= 2;

AAAA2 = ArrayFlatten[{{AAAA21}, {AAAA22}}];

Norm[AAAA2 - AAA1[[All,10;;15]]]

AAAA21  = Part[ KroneckerProduct[(2 B), Transpose[Id]], 
	        All, TransposePermutation[n,m] ];
AAAA21 += KroneckerProduct[Transpose[Id], (2 B)];
AAAA21 /= 2;

AAAA22	= Part[ KroneckerProduct[(-2 IdW), IdX],
	        All, TransposePermutation[n,m] ];
AAAA22 += KroneckerProduct[IdX, (-2 IdW)];
AAAA22 /= 2;

AAAA2 = ArrayFlatten[{{AAAA21}, {AAAA22}}];

Norm[AAAA2 - AAA1[[All,10;;15]]]

AAAA21t  = KroneckerProduct[Id, Transpose[2 B]];
AAAA22t  = KroneckerProduct[Transpose[IdX], Transpose[-2 IdW]];

AAAA2t = ArrayFlatten[{{AAAA21t, AAAA22t}}];

Norm[AAAA2t - AAA1t[[10;;15,All]]]

U221 = KroneckerProduct[Id . X11[[1]] . Transpose[Id], 
                        Transpose[2 B] . X11[[1]] . (2 B)];
U222 = KroneckerProduct[Transpose[IdX] . X11[[2]] . IdX, 
                        Transpose[-2 IdW] . X11[[2]] . (- 2 IdW)];
U22 = U221 + U222;

V221 = KroneckerProduct[Id . X11[[1]] . (2 B), 
                        Transpose[2 B] . X11[[1]] . Transpose[Id]];
V222 = KroneckerProduct[Transpose[IdX] . X11[[2]] . (-2 IdW), 
                        Transpose[-2 IdW] . X11[[2]] . IdX];
V22 = V221 + V222;

S22 = (U22 + Part[V22, All, TransposePermutation[n,m]]) / 2;

Norm[H1[[10;;15,10;;15]] - S22]

Norm[H1[[10;;15,10;;15]] - H11[[10;;15,10;;15]]]


(* Term 21 *)

(* 
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
*)

U211 = KroneckerProduct[Id . X11[[1]] . Transpose[Id], 
                        Transpose[2 B] . X11[[1]] . (2 A)];
U212 = KroneckerProduct[Transpose[IdX] . X11[[2]] . IdX, 
                        Transpose[-2 IdW] . X11[[2]] . (-IdX)];
U21 = U211 + U212;

V211 = KroneckerProduct[Id . X11[[1]] . (2 A), 
                        Transpose[2 B] . X11[[1]] . Transpose[Id]];
V212 = KroneckerProduct[Transpose[IdX] . X11[[2]] . (-IdX), 
                        Transpose[-2 IdW] . X11[[2]] . IdX];
V21 = V211 + V212;

S21 = (U21 + Part[V21, All, TransposePermutation[n,n]]) / 2;

Norm[H1[[10;;15,1;;9]] - S21]

Norm[H1[[10;;15,1;;9]] - H11[[10;;15,1;;9]]]

(* Term 31 *)

(* 
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
*)

U312 = KroneckerProduct[Transpose[IdW] . X11[[2]] . IdX, 
                        Transpose[-IdW] . X11[[2]] . (-IdX)];
U31 = U312;

V312 = KroneckerProduct[Transpose[IdW] . X11[[2]] . (-IdX), 
                        Transpose[-IdW] . X11[[2]] . IdX];
V31 = V312;

S31 = (U31 + Part[V31, All, TransposePermutation[n,n]]) / 4;
S31 += Part[S31, TransposePermutation[m,m], All];

Norm[H1[[16;;19,1;;9]] - S31]

Norm[H1[[16;;19,1;;9]] - H11[[16;;19,1;;9]]]


(* Term 12 *)

(* 
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
*)

U121 = KroneckerProduct[Id . X11[[1]] . Transpose[Id], 
                        Transpose[2 A] . X11[[1]] . (2 B)];
U122 = KroneckerProduct[Transpose[IdX] . X11[[2]] . IdX, 
                        Transpose[-IdX] . X11[[2]] . (-2 IdW)];
U12 = U121 + U122;

V121 = KroneckerProduct[Id . X11[[1]] . (2 B), 
                        Transpose[2 A] . X11[[1]] . Transpose[Id]];
V122 = KroneckerProduct[Transpose[IdX] . X11[[2]] . (-2 IdW), 
                        Transpose[-IdX] . X11[[2]] . IdX];
V12 = V121 + V122;

S12 = (U12 + Part[V12, All, TransposePermutation[n,m]]) / 4;
S12 += Part[S12, TransposePermutation[n,n], All];

Norm[H1[[1;;9,10;;15]] - S12]

Norm[H1[[1;;9,10;;15]] - H11[[1;;9,10;;15]]]


(* Term 32 *)

(* 
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
*)

U322 = KroneckerProduct[Transpose[IdW] . X11[[2]] . IdX, 
                        Transpose[-IdW] . X11[[2]] . (-2 IdW)];
U32 = U322;

V322 = KroneckerProduct[Transpose[IdW] . X11[[2]] . (-2 IdW), 
                        Transpose[-IdW] . X11[[2]] . IdX];
V32 = V322;

S32 = (U32 + Part[V32, All, TransposePermutation[n,m]]) / 4;
S32 += Part[S32, TransposePermutation[m,m], All];

Norm[H1[[16;;19,10;;15]] - S32]

Norm[H1[[16;;19,10;;15]] - H11[[16;;19,10;;15]]]

y = {Flatten[{SymmetricToVector[X],ToVector[L],SymmetricToVector[W]}]};

AAA2 = SylvesterDualVectorize[AA, dims, syms, True];
x11 = Map[Dot[#,y[[1]]]&, AAA2];
Map[Norm, x1 - x11]

AAA2t = SylvesterPrimalVectorize[AA, dims, syms, True];
y1 = MapThread[If[#2, SymmetricToVector[#1,2], ToVector[#1]]&, 
               {SylvesterPrimalEval[AA,X1,syms], syms}];
y11 = Map[Dot[#, Flatten[x1]]&, AAA2t];
Map[Norm, y1 - y11]

AAA2 = ArrayFlatten[Transpose[{AAA2}]];
AAA2t = ArrayFlatten[Transpose[{AAA2t}]];

P2 = {{1, 0, 0, 0}, {0, 1/2, 1/2, 0}, {0, 0, 0, 1}};
Q2 = Transpose[P2].Inverse[P2.Transpose[P2]];

P3 = {{2, 0, 0, 0, 0, 0, 0, 0, 0}, 
      {0, 1, 0, 1, 0, 0, 0, 0, 0},
      {0, 0, 1, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 1, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 2}} / 2;
Q3 = Transpose[P3].Inverse[P3.Transpose[P3]];

Norm[AAA1[[All,1;;9]] . Q3 - AAA2[[All,1;;6]]]
Norm[AAA1[[All,10;;15]] - AAA2[[All,7;;12]]]
Norm[AAA1[[All,16;;19]] . Q2 - AAA2[[All,13;;15]]]

Norm[Transpose[Q3] . AAA1t[[1;;9,All]] - AAA2t[[1;;6,All]]]
Norm[AAA1t[[10;;15,All]] - AAA2t[[7;;12,All]]]
Norm[Transpose[Q2] . AAA1t[[16;;19,All]] - AAA2t[[13;;15,All]]]

X11Scale = ConstantArray[0, {n*n+(n+m)*(n+m),n*n+(n+m)*(n+m)}];
X11Scale[[1;;n*n,1;;n*n]] = KroneckerProduct[X11[[1]], X11[[1]]];
X11Scale[[n*n+1;;n*n+(n+m)*(n+m),n*n+1;;n*n+(n+m)*(n+m)]] = KroneckerProduct[X11[[2]], X11[[2]]];

H2 = AAA2t . X11Scale . AAA2;
H22 = SylvesterSylvesterVecEval[AA, X11, dims, syms, True];
Norm[H2 - H22]

Norm[Transpose[Q3] . H1[[1;;9,1;;9]] . Q3 - H2[[1;;6,1;;6]] ]
Norm[Transpose[Q3] . H1[[1;;9,10;;15]] - H2[[1;;6,7;;12]] ]
Norm[Transpose[Q3] . H1[[1;;9,16;;19]] . Q2 - H2[[1;;6,13;;15]] ]

Norm[H1[[10;;15,1;;9]] . Q3 - H2[[7;;12,1;;6]] ]
Norm[H1[[10;;15,10;;15]] - H2[[7;;12,7;;12]] ]
Norm[H1[[10;;15,16;;19]] . Q2 - H2[[7;;12,13;;15]] ]

Norm[Transpose[Q2] . H1[[16;;19,1;;9]] . Q3 - H2[[13;;15,1;;6]] ]
Norm[Transpose[Q2] . H1[[16;;19,10;;15]] - H2[[13;;15,7;;12]] ]
Norm[Transpose[Q2] . H1[[16;;19,16;;19]] . Q2 - H2[[13;;15,13;;15]] ]

<< SDP`
<< cSDP`

AAvec = SylvesterDualVectorize[AA, dims, syms, True];
AASDP = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]];
BBSDP = {{Flatten[{SymmetricToVector[BB[[1]], 2],ToVector[BB[[2]]],SymmetricToVector[BB[[3]], 2]}]}};

y = {Flatten[{SymmetricToVector[X],ToVector[L],SymmetricToVector[W]}]};
x1 = SylvesterDualEval[AA,{X,L,W}];

x11 = Map[ToMatrix, Map[Dot[#,y[[1]]]&, AAvec]];
Map[Norm, x1 - x11]

x11 = Plus @@ (AASDP * Flatten[y]);
Map[Norm, x1 - x11]

h1 = SDPSylvesterEval[AASDP,{IdentityMatrix[n], IdentityMatrix[m+n]}];
h11 = SylvesterSylvesterVecEval[AA,{IdentityMatrix[n], IdentityMatrix[m+n]},dims,syms,True];
Norm[h1 - h11]

$Echo = DeleteCases[$Echo, "stdout"];
