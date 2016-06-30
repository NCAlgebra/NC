AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->170];

<< Sylvester`

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
dims=Map[Dimensions,{Y}]

y = {ToVector[Y]};

AAA1 = SylvesterDualVectorize[AA, dims, syms];

x1 = Map[ToVector, (X1 = SylvesterDualEval[AA,{Y}])];
x11 = Map[Dot[#, y[[1]]]&, AAA1];
Norm[x1 - x11]

AAA1t = SylvesterPrimalVectorize[AA, dims, syms];
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, x1[[1]]]&, AAA1t];
Norm[y1 - y11]

AAA1 = ArrayFlatten[Transpose[{AAA1}]];
AAA1t = ArrayFlatten[Transpose[{AAA1t}]];

X11 = {IdentityMatrix[2]};
H1 = AAA1t . AAA1;
H11 = SylvesterSylvesterVecEval[AA, X11, dims, syms];
Norm[H1 - H11]

y = {SymmetricToVector[Y]};

AAA2 = SylvesterDualVectorize[AA, dims, syms, True];
x11 = Map[Dot[#,y[[1]]]&, AAA2];
Norm[x1 - x11]

AAA2t = SylvesterPrimalVectorize[AA, dims, syms, True];
y1 = Map[SymmetricToVector[#,2]&, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, x1[[1]]]&, AAA2t];
Norm[y1 - y11]

AAA2 = ArrayFlatten[Transpose[{AAA2}]];
AAA2t = ArrayFlatten[Transpose[{AAA2t}]];

P2 = {{1, 0, 0, 0}, {0, 1/2, 1/2, 0}, {0, 0, 0, 1}};
Q2 = Transpose[P2].Inverse[P2.Transpose[P2]];

Norm[AAA1 . Q2 - AAA2]
Norm[Transpose[Q2] . AAA1t - AAA2t]

X11 = {IdentityMatrix[2]};
H2 = AAA2t . AAA2;
H22 = SylvesterSylvesterVecEval[AA, X11, dims, syms, True];
Norm[H2 - H22]

Norm[Transpose[Q2] . H1 . Q2 - H2]

(* Test #2 *)

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

y = {ToVector[Y]};

AAA1 = SylvesterDualVectorize[AA, dims, syms];

x1 = Map[ToVector, (X1 = SylvesterDualEval[AA,{Y}])];
x11 = Map[Dot[#, Flatten[y]]&, AAA1];
Norm[x1 - x11]

AAA1t = SylvesterPrimalVectorize[AA, dims, syms];
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, Flatten[x1]]&, AAA1t];
Norm[y1 - y11]

AAA1 = ArrayFlatten[Transpose[{AAA1}]];
AAA1t = ArrayFlatten[Transpose[{AAA1t}]];

X11 = {IdentityMatrix[2],IdentityMatrix[2]};
H1 = AAA1t . AAA1;
H11 = SylvesterSylvesterVecEval[AA, X11, dims, syms];
Norm[H1 - H11]

y = {SymmetricToVector[Y]};

AAA2 = SylvesterDualVectorize[AA, dims, syms, True];
x11 = Map[Dot[#,y[[1]]]&, AAA2];
Norm[x1 - x11]

AAA2t = SylvesterPrimalVectorize[AA, dims, syms, True];
y1 = Map[SymmetricToVector[#,2]&, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, Flatten[x1]]&, AAA2t];
Norm[y1 - y11]

AAA2 = ArrayFlatten[Transpose[{AAA2}]];
AAA2t = ArrayFlatten[Transpose[{AAA2t}]];

P2 = {{1, 0, 0, 0}, {0, 1/2, 1/2, 0}, {0, 0, 0, 1}};
Q2 = Transpose[P2].Inverse[P2.Transpose[P2]];

Norm[AAA1 . Q2 - AAA2]
Norm[Transpose[Q2] . AAA1t - AAA2t]

X11 = {IdentityMatrix[2],IdentityMatrix[2]};
H2 = AAA2t . AAA2;
H22 = SylvesterSylvesterVecEval[AA, X11, dims, syms, True];
Norm[H2 - H22]

Norm[Transpose[Q2] . H1 . Q2 - H2]

(* Test #3 *)

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

AAA1 = SylvesterDualVectorize[AA, dims, syms];
x1 = Map[ToVector, (X1 = SylvesterDualEval[AA,{Y,K}])];
x11 = Map[Dot[#,y[[1]]]&, AAA1];
Map[Norm, x1 - x11]

AAA1t = SylvesterPrimalVectorize[AA, dims, syms];
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, Flatten[x1]]&, AAA1t];
Map[Norm, y1 - y11]

AAA1 = ArrayFlatten[Transpose[{AAA1}]];
AAA1t = ArrayFlatten[Transpose[{AAA1t}]];

X11 = {IdentityMatrix[2],IdentityMatrix[2],IdentityMatrix[3]};
H1 = AAA1t . AAA1;
H11 = SylvesterSylvesterVecEval[AA, X11, dims, syms];
Norm[H1 - H11]

y = {Flatten[{SymmetricToVector[Y],ToVector[K]}]};

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

Norm[AAA1[[All,1;;4]] . Q2 - AAA2[[All,1;;3]]]
Norm[AAA1[[All,5;;6]] - AAA2[[All,4;;5]]]
Norm[Transpose[Q2] . AAA1t[[1;;4,All]] - AAA2t[[1;;3,All]]]
Norm[AAA1t[[5;;6,All]] - AAA2t[[4;;5,All]]]

X11 = {IdentityMatrix[2],IdentityMatrix[2],IdentityMatrix[3]};
H2 = AAA2t . AAA2;
H22 = SylvesterSylvesterVecEval[AA, X11, dims, syms, True];
Norm[H2 - H22]

Norm[Transpose[Q2] . H1[[1;;4,1;;4]] . Q2 - H2[[1;;3,1;;3]] ]
Norm[Transpose[Q2] . H1[[1;;4,5;;6]] - H2[[1;;3,4;;5]] ]
Norm[H1[[5;;6,1;;4]] . Q2 - H2[[4;;5,1;;3]] ]
Norm[H1[[5;;6,5;;6]] - H2[[4;;5,4;;5]] ]

(* Riccati *)

n=2;
m=2;

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
{{-2 IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-2 IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
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

y = {Flatten[{ToVector[X],ToVector[L],ToVector[W]}]};

AAA1 = SylvesterDualVectorize[AA, dims, syms];
x1 = Map[ToVector, (X1 = SylvesterDualEval[AA,{X,L,W}])];
x11 = Map[Dot[#,y[[1]]]&, AAA1];
Map[Norm, x1 - x11]

AAA1t = SylvesterPrimalVectorize[AA, dims, syms];
y1 = Map[ToVector, SylvesterPrimalEval[AA,X1,syms]];
y11 = Map[Dot[#, Flatten[x1]]&, AAA1t];
Map[Norm, y1 - y11]

AAA1 = ArrayFlatten[Transpose[{AAA1}]];
AAA1t = ArrayFlatten[Transpose[{AAA1t}]];

X11 = {IdentityMatrix[n],IdentityMatrix[n+m]};
H1 = AAA1t . AAA1;
H11 = SylvesterSylvesterVecEval[AA, X11, dims, syms];
Norm[H1 - H11]

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

Norm[AAA1[[All,1;;4]] . Q2 - AAA2[[All,1;;3]]]
Norm[AAA1[[All,5;;6]] - AAA2[[All,4;;5]]]
Norm[Transpose[Q2] . AAA1t[[1;;4,All]] - AAA2t[[1;;3,All]]]
Norm[AAA1t[[5;;6,All]] - AAA2t[[4;;5,All]]]

X11 = {IdentityMatrix[n],IdentityMatrix[n+m]};
H2 = AAA2t . AAA2
H22 = SylvesterSylvesterVecEval[AA, X11, dims, syms, True]
Norm[H2 - H22]

Norm[Transpose[Q2] . H1[[1;;4,1;;4]] . Q2 - H2[[1;;3,1;;3]] ]
Norm[Transpose[Q2] . H1[[1;;4,5;;6]] - H2[[1;;3,4;;5]] ]
Norm[H1[[5;;6,1;;4]] . Q2 - H2[[4;;5,1;;3]] ]
Norm[H1[[5;;6,5;;6]] - H2[[4;;5,4;;5]] ]

MatrixForm[H2]
MatrixForm[H22]

$Echo = DeleteCases[$Echo, "stdout"];
