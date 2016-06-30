AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< Sylvester`

(* All you should see are zeros *)

A={{-1,1},{0,-2}};
B={{2,1},{1,2}};
Q=IdentityMatrix[2];

Y={{1,3},{3,2}};

(* Test #1: Fully symmetric *)

l1=ArrayFlatten[{{Transpose[A],B}}];
r1=ArrayFlatten[{{Transpose[B],A}}];

X1=Transpose[A].Y.Transpose[B]+B.Y.A;
X11=SylvesterEntryDualMultiply[{l1,r1},Y];
Norm[X1-X11]

Y1=Transpose[B].X1.Transpose[A]+A.X1.B;
Y11=SylvesterEntryPrimalMultiply[{l1,r1},X1];
Norm[Y1-Y11]

{l1s,r1s} = {ArrayFlatten[{{X11.Transpose[A],X11.B}}], 
             ArrayFlatten[{{Transpose[B].X11,A.X11}}]};
{l11s,r11s} = SylvesterEntryScale[{l1,r1},X11];
Norm[ l1s - l11s ]
Norm[ r1s - r11s ]

{m,n}=Dimensions[Y];
KroneckerProduct[B,Transpose[A]]+KroneckerProduct[Transpose[A],B];
K1=(%+Part[%,TransposePermutation[m,n],All])/2;
K11=SylvesterEntryDualVectorize[{l1,r1},Dimensions[Y]];
Norm[K1-K11]

A1=KroneckerProduct[Transpose[B].B,A.Transpose[A]]+
KroneckerProduct[Transpose[B].Transpose[A],A.B]+
KroneckerProduct[A.B,Transpose[B].Transpose[A]]+
KroneckerProduct[A.Transpose[A],Transpose[B].B];
A2=KroneckerProduct[Transpose[B].Transpose[A],A.B]+
KroneckerProduct[Transpose[B].B,A.Transpose[A]]+
KroneckerProduct[A.Transpose[A],Transpose[B].B]+
KroneckerProduct[A.B,Transpose[B].Transpose[A]];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l1,r1},{l1,r1},{m,n},{m,n}];
Norm[A1-A11]
Norm[A2-A22]

A1=KroneckerProduct[Transpose[B].B,A.Transpose[A]]+
KroneckerProduct[Transpose[B].Transpose[A],A.B]+
KroneckerProduct[A.B,Transpose[B].Transpose[A]]+
KroneckerProduct[A.Transpose[A],Transpose[B].B];
A2=KroneckerProduct[Transpose[B].Transpose[A],A.B]+
KroneckerProduct[Transpose[B].B,A.Transpose[A]]+
KroneckerProduct[A.Transpose[A],Transpose[B].B]+
KroneckerProduct[A.B,Transpose[B].Transpose[A]];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l1,r1},{l1,r1},{m,n},{m,n}];
Norm[A1-A11]
Norm[A2-A22]

(* Test #2: Not symmetric mapping, symmetric variable *)

l2=Transpose[A];
r2=Transpose[B];

X2=Transpose[A].Y.Transpose[B];
X22=SylvesterEntryDualMultiply[{l2,r2},Y];
Norm[X2-X22]

Transpose[A].Y.Transpose[B];
X2=(%+Transpose[%])/2;
SylvesterEntryDualMultiply[{l2,r2},Y];
X22=(%+Transpose[%])/2;
Norm[X2-X22]

Y2=A.X2.B;
Y22=SylvesterEntryPrimalMultiply[{l2,r2},X2];
Norm[Y2-Y22]

{m,n}=Dimensions[Y];
KroneckerProduct[B,Transpose[A]];
K2=(%+Part[%,TransposePermutation[m,n],All])/2;
K22=SylvesterEntryDualVectorize[{l2,r2},{m,n},True];
Norm[K2-K22]

A1=KroneckerProduct[Transpose[B].B,A.Transpose[A]];
A2=KroneckerProduct[Transpose[B].Transpose[A],A.B];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l2,r2},{l2,r2},{m,n},{m,n}];
Norm[A1-A11]
Norm[A2-A22]

(* Test #3: Not symmetric mapping, not symmetric variable *)

F={{3},{7}};
K={{-1,2}};

l3=F;
r3=IdentityMatrix[2];

X3=F.K;
X33=SylvesterEntryDualMultiply[{l3,r3},K];
Norm[X3-X33]

F.K;
X3=(%+Transpose[%])/2;
SylvesterEntryDualMultiply[{l3,r3},K];
X33=(%+Transpose[%])/2;
Norm[X3-X33]

Y3=Transpose[F].X3;
Y33=SylvesterEntryPrimalMultiply[{l3,r3},X3];
Norm[Y3-Y33]

{m,n}=Dimensions[K];
KroneckerProduct[F,r3];
K3=(%+Part[%,TransposePermutation[2,2],All])/2;
K33=SylvesterEntryDualVectorize[{l3,r3},{m,n},True];
Norm[K3-K33]

A1=KroneckerProduct[r3.Transpose[r3],Transpose[l3].l3];
A2=KroneckerProduct[r3.l3,Transpose[l3].Transpose[r3]];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l3,r3},{l3,r3},{m,n},{m,n}];
Norm[A1-A11]
Norm[A2-A22]

{m1,n1}=Dimensions[K];
{m2,n2}=Dimensions[Y];
A1=KroneckerProduct[r3.Transpose[r2],Transpose[l3].l2];
A2=KroneckerProduct[r3.l2,Transpose[l3].Transpose[r2]];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l3,r3},{l2,r2},{m1,n1},{m2,n2}];
Norm[A1-A11]
Norm[A2-A22]

{m2,n2}=Dimensions[K];
{m1,n1}=Dimensions[Y];
A1=KroneckerProduct[r2.Transpose[r3],Transpose[l2].l3];
A2=KroneckerProduct[r2.l3,Transpose[l2].Transpose[r3]];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l2,r2},{l3,r3},{m1,n1},{m2,n2}];
Norm[A1-A11]
Norm[A2-A22]

A1=KroneckerProduct[r2.Transpose[r3],Transpose[l2].l3];
A2=KroneckerProduct[r2.l3,Transpose[l2].Transpose[r3]];
{A11,A22}=SylvesterEntrySylvesterVectorize[{l2,r2},{l3,r3},{m1,n1},{m2,n2}];
Norm[A1-A11]
Norm[A2-A22]

$Echo = DeleteCases[$Echo, "stdout"];
