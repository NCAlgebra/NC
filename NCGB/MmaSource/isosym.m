Get["NCGB.m"];

ClearMonomialOrderAll[];

SNC[Aj,A,V,U,b];

B = {
{A, 0, 0,0},
{0, V, 0,0},
{0, 0, U,b},
{0, 0, 0,Aj[U]}
};

starting = {
Aj[A] - A,
Aj[V]**V-1,
Aj[U]**U-1,
U**Aj[U]-1
};

L = Table[ToExpression[ToString[a]<>ToString[i]<>ToString[j]],{i,1,4},{j,1,3}];

T = {
{S ,E ,F},
{0 ,R ,G},
{0 ,0 ,H}
};

SNC[S,E,R,t];

starting = Join[starting,{
Aj[S]**S-1,
E**S-1,
Aj[S]**Aj[E]-1,
Aj[R]-R,
Aj[E]**E + R**R - t,
Aj[t]-t
}];


variables = Flatten[{L,B,T,t}];
variables = Complement[variables,{0,Aj[U]}];
variables = Join[variables,Map[Aj,variables]];
Apply[SNC, variables];

UNK = {A,V,U,b,F,G,H};
UNK = Join[UNK,Map[Aj,UNK]];

KN = Complement[variables,UNK];

SetMonomialOrder[KN,UNK];

Aj[x_?MatrixQ] := 
Module[{temp},
  temp = x/.Aj->aj;
  temp = aj[x];
  temp = temp/.aj->Aj;
  Return[temp];
];

starting = Join[starting, 
Map[{b**#==#**b,R**#==#**R,t**#==#**t}&,variables]
];

relations = Flatten[{
MatMult[B,L]-MatMult[L,T], (* B L = L T "intertwining" *)
MatMult[Aj[L],L]-IdentityMatrix[3],
MatMult[L,Aj[L]]-IdentityMatrix[4],
starting,
R
}];

relations = Complement[relations,{0,True}];

NCProcess[relations,0,0,0,0,"junker",RR->False,SB->False,SBByCat->False];
