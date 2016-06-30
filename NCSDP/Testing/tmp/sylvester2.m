AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< Sylvester`

(* All you should see are zeros *)

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

Y={{1,3},{3,2}};
syms = {True};

Transpose[A].Y.Transpose[B]+B.Y.A;
X1={(%+Transpose[%])/2};
X11=SylvesterDualEval[AA,{Y}];
{XX}=X1;
Map[Norm,X1-X11]

Transpose[B].XX.Transpose[A]+A.XX.B;
Y1={(%+Transpose[%])/2};
Y11=SylvesterPrimalEval[AA,{XX},syms];
Map[Norm,Y1-Y11]

X11 = MapThread[Dot, {X11,X11}];

dims=Map[Dimensions,{Y}]
syms={True}
H11=SylvesterSylvesterVecEval[AA,X11,dims,syms];
H11
Eigenvalues[H11]//N

dims=Map[Dimensions,{Y}]
syms={True}
H11=SylvesterSylvesterVecEval[AA,X11,dims,syms,True];
H11
Eigenvalues[H11]//N

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

    
{Y,Transpose[A].Y.Transpose[B]+F.K,AA[[3,2,1]].K.AA[[3,2,2]]};
X1=Map[SylvesterEntrySymmetrize,%];
X11=SylvesterDualEval[AA,{Y,K}];
{XX1,XX2,XX3}=X11;
Map[Norm,X1-X11]

{XX1+A.XX2.B,Transpose[F].XX2+Transpose[AA[[3,2,1]]].XX3.Transpose[AA[[3,2,2]]]};
Y1=MapAt[SylvesterEntrySymmetrize,%,{1}];
Y11=SylvesterPrimalEval[AA,{XX1,XX2,XX3},syms];
Map[Norm,Y1-Y11]

X11 = MapThread[Dot, {X11,X11}];

dims=Map[Dimensions,{Y,K}];
H11=SylvesterSylvesterVecEval[AA,X11,dims,syms];
H11
Eigenvalues[H11]//N

dims=Map[Dimensions,{Y,K}];
H11=SylvesterSylvesterVecEval[AA,X11,dims,syms,True];
H11
Eigenvalues[H11]//N

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

syms={True,False,True};

AA={
{{2 A,Id},{2B,Id},{Zenm,Transpose[Zenm]}},(* A X + B L < 0*)
{{-2 IdX,Transpose[IdX]},{-2 IdW,Transpose[IdX]},{-2 IdW,Transpose[IdW]}} (* -[W, L; L^T X] < 0 *)
};
CC={-Id,Zenpm};
BB={Ze,Transpose[Zenm],-Idm};

X=RandomReal[{-10,10},{n,n}];
L=RandomReal[{-10,10},{m,n}];
W=RandomReal[{-10,10},{m,m}];
 
2 {A.X + B.L, -ArrayFlatten[{{W, L},{0*Transpose[L], X}}]};
X1=Map[SylvesterEntrySymmetrize,%];
X11=SylvesterDualEval[AA,{X,L,W}];
{XX1, XX2}=X11;
Map[Norm,X1-X11]

2 {Transpose[A].XX1-XX2[[3;;5,3;;5]], Transpose[B].XX1-XX2[[1;;2,3;;5]], -XX2[[1;;2,1;;2]]};
Y1=MapAt[SylvesterEntrySymmetrize,%,{{1},{3}}];
Y11=SylvesterPrimalEval[AA,{XX1,XX2},syms];
Map[Norm,Y1-Y11]

X11 = MapThread[Dot, {X11,X11}];

dims=Map[Dimensions,{X,L,W}];
H11=SylvesterSylvesterVecEval[AA,X11,dims,syms];
Eigenvalues[H11]//N

dims=Map[Dimensions,{X,L,W}];
H11=SylvesterSylvesterVecEval[AA,X11,dims,syms,True];
Eigenvalues[H11]//N

$Echo = DeleteCases[$Echo, "stdout"];
