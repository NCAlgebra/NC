<<NCGB.m;
<<NCSR6.m;

Put[Date[],"STARTtime"];

SetNonCommutative[A,B,L,M,X];
SetMonomialOrder[{A,B,X},{L,Inv[L],M,Inv[M]}];

relations = { 
Inv[L]**L-1,
L**Inv[L]-1,
Inv[M]**M-1,
M**Inv[M]-1,
(A-L)**X, 
(B-M)**X,
A**L - L**A,
B**L - L**B,
A**Inv[L] - Inv[L]**A,
B**Inv[L] - Inv[L]**B,
A**M - M**A,
B**M - M**B,
A**Inv[M] - Inv[M]**A,
B**Inv[M] - Inv[M]**B,
L**M - M**L,
L**Inv[M] - Inv[M]**L,
Inv[L]**M - M**Inv[L],
Inv[L]**Inv[M] - Inv[M]**Inv[L]
};

rules = NCProcess[relations,4,0,3,3,"smallMarkus"];
Put[Date[],"ENDtime"];

Print["ans:",ans];
