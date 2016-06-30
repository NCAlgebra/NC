AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NC`
<< NCAlgebra`

<<NCSDP`
<<SDPSylvester`
<<Kronecker`

mm = 100 (* 100 kg *);
r = 300*10^3 (* 300 km *);
R0 = 6.37*10^6 (* 6.37 10^3 km *);
G = 6.673*10^(-11) (* 6.673 N m^2/kg^2 *);
M = 5.98*10^(24) (* 5.98 10^24 kg *);
k = G*M;
w = Sqrt[k/((R0+r)^3)];
v = w*(R0+r);

A = {{0,0,1,0},{0,0,0,1},{3*w^2,0,0,2*(r+R0)*w},{0,0,-2*w/(r+R0),0}};
Bu = {{0,0},{0,0},{1/mm,0},{0,1/(mm*r)}};
T = DiagonalMatrix[{1,r,1,r}]
At = T.A.Inverse[T]
But = T.Bu

n = Length[At];
m=1;

SNC[a,b,q,x,l];
F={a**x+b**l+x**tp[a]+tp[b**l]+q,-x};
vars={x,l};
obj={0,0};

data={a->At,b->But[[All,{2}]],q->IdentityMatrix[4]};

{abc,rules}=NCSDP[F,vars,obj,data,UserRules->{tp[q]->q}];

{AAvec, BBvec, CC} = SylvesterToVectorizedSDP[abc,rules];
AAVec = Map[SymmetricToVector, AAvec,{2}]
AAVec = ArrayFlatten[ {{Transpose[AAVec[[All, 1]]]}, {Transpose[AAVec[[All, 2]]]}} ];
Dimensions[AAVec]
MatrixRank[AAVec]

{Y,X,S,iters}=SDPSolve[abc,rules];

X=Y[[1]]
L=Y[[2]];

LMI1=At.X+But[[;;,2;;2]].L;
LMI1=.5*(LMI1+Transpose[LMI1]);
Eigenvalues[LMI1]

LMI2=X;
Eigenvalues[LMI2]

K = L.Inverse[X]
Acl=At+But[[;;,2;;2]].K
Eigenvalues[Acl]

data={a->At,b->But,q->IdentityMatrix[4]};
{abc,rules}=NCSDP[F,vars,obj,data,UserRules->{tp[q]->q}];

{AAvec, BBvec, CC} = SylvesterToVectorizedSDP[abc,rules];
AAVec = Map[SymmetricToVector, AAvec,{2}]
AAVec = ArrayFlatten[ {{Transpose[AAVec[[All, 1]]]}, {Transpose[AAVec[[All, 2]]]}} ];
Dimensions[AAVec]
MatrixRank[AAVec]

$Echo = DeleteCases[$Echo, "stdout"];

(*{Y,X,S,iters}=SDPSolve[abc,rules,DebugLevel->2]; *)


(* ::Input:: *)
(*Y*)


(* ::Text:: *)
(**)
(*Check the eigenvalues to show that this is a feasible soultion.*)


(* ::Input:: *)
(*X=Y[[1]]*)
(*L=Y[[2]]*)


(* ::Input:: *)
(*LMI1=At.X+But.L*)
(*LMI1=.5*(LMI1+Transpose[LMI1])*)
(*Eigenvalues[LMI1]*)


(* ::Input:: *)
(*LMI2=X;*)
(*Eigenvalues[LMI2]*)


(* ::Text:: *)
(*Construct K and check closed loop stability*)


(* ::Input:: *)
(*K = L.Inverse[X]*)
(*Acl=At+But.K*)
(*Eigenvalues[Acl]*)



