Run["date"];
Get["NCGB.m"];

SetNonCommutative[A0,A1,A2,A3,A4,B0,B1,B2,B3,B4];

SetMonomialOrder[{A0,A1,A2,A3,A4,B4},1];
SetMonomialOrder[{B0,B1,B2,B3},2];

(* The conditions for n=4 are : *)

My4 = {
A0**B0, B0**A0,
A0**B1+A1**B0, B1**A0 + B0**A1,
A0**B2 + A1**B1 + A2**B0, B0**A2 + B1**A1 + B2**A0,
A0**B3 + A1**B2 + A2**B1 + A3**B0, B0**A3 + B1**A2 + B2**A1 + B3**A0,
A0**B4 + A1**B3 + A2**B2 + A3**B1 + A4**B0 - 1, 
B0**A4 + B1**A3 + B2**A2 + B3**A1 + B4**A0 - 1,
A1**B3+2*A2**B2 + 3*A3**B1 + 4*A4**B0}; 

Run["date"];
GB = PolyToRule[NCMakeGB[My4,6]];
Run["date"];
RegularOutput[GB,"problem.GB"];
Print["GB without starting relations"];
RegularOutput[Complement[GB,PolyToRule[My4]],"newRelations"];
