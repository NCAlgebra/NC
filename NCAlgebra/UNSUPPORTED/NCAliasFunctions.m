(* OBSOLETE -DELETE THIS AFTER Sept 1997 *)
(* This was subsumed by NCAlias.m   *)
(* NCAliasFunctions.m                   *)

NCE[x_] := NonCommutativeMultiply`ExpandNonCommutativeMultiply[x];
SubSym[x___] := NCSubstitute`SubstituteSymmetric[x];
Crit[x___]:=NCDiff`CriticalPoint[x];
Sub[x___] := NCSubstitute`Substitute[x];
NCCSym[x___] := NCCollect`NCCollectSymmetric[x];
NCC[x___] := NCCollect`NCCollect[x];
(*Grad[x___] := Gradient[x];*)
MM[x___]:= NCMatMult`MatMult[x];
SC[x___]:= NonCommutativeMultiply`SetCommutative[x];
SNC[x___] := NonCommutativeMultiply`SetNonCommutative[x];
CE[x___]:=NonCommutativeMultiply`CommuteEverything[x];
DirD[x___] := NCDiff`DirectionalD[x];
NCSolve[x___] := NCSolveLinear1`NCSolveLinear1[x];
