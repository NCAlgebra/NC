(* :Title: 	NCAdjoints // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :3/25/91:    Wrote code. (mstankus)
   :5/02/91:    Changed name from ADJOINT to aj and genrally 
                fixed up the code. (mstankus) 
   :5/04/91:    Added references to Sesq. (mstankus) 
   :6/24/91:    General Cleanup. (mstankus)
   :3/07/93:    Added Setajinv and Setinvaj. (mstankus)
*)

BeginPackage[ "NonCommutativeMultiply`" ]

(* MAURICIO: JUNE 2009: MUST BE DONE IN NCMULTIPLICATION FOR CE TO WORK *)
(* Clear[aj]; *)

aj::usage = 
     "If T is a matrix, aj[T] is the adjoint. If T is a number, \
      then aj[T] gives the conjugate of T. aj[] automatically makes \
      certain simplifications(e.g., aj[x+y] returns aj[x] + aj[y] \
      aj is a conjugate linear function.  Commutative expressions \
      are not assumed to be self-adjoint (in contrast to tp). \
      See also tp,SetSelfAdjoint, SetIsometry,....";

Clear[Setajinv];

Setajinv::usage = 
     "When Setajinv[] is executed, all instances (from that point on) of \
      of inv[aj[expr]] will be replaced with aj[inv[expr]]. The effect of \
      this command can be reversed by invoking Setinvaj[]. When NCAlgebra is \
      started, Setinvaj[] is invoked.";

Clear[Setinvaj];

Setinvaj::usage = 
     "When Setinvaj[] is executed, all instances (from that point on) of \
      aj[inv[expr]] will be replaced with inv[aj[expr]]. The effect of \
      this command can be reversed by invoking Setajinv[]. When NCAlgebra is \
      started, Setinvaj[] is invoked.";

Begin[ "`Private`" ]

aj[] := Id;

SetNonCommutative[aj,u,s,z,a];

aj[u_]:=Transpose[Map[aj[#]&,u,{2}]] /; Length[Dimensions[u]] >=2

(* --------------------------------------------------------------------- *)
(*   Rules for ADJOINTS                                                  *)    
(* --------------------------------------------------------------------- *)
SetConjugateLinear[aj];
SetIdempotent[aj];
aj[s_*az_]:=aj[s]*aj[az];
aj[Id] := Id;
aj[z_]:= Conjugate[z] /;NumberQ[z]

ExpandQ[aj] = True;
NCAntihomo[aj];
(* --------------------------------------------------------------------- *)
(*   The adjoint and inverse commute. LeftQ[aj,inv] = False means that   *)    
(*   aj[inv[x]] will be changed to inv[aj[x]].                           *)    
(* --------------------------------------------------------------------- *)
LeftQ[aj,inv] := False;
SetCommutingFunctions[aj,inv];

Setajinv[] := LeftQ[aj,inv] := True;
Setinvaj[] := LeftQ[aj,inv] := False;

SetInvRightTp = True;
aj[invL[a_]] := invR[aj[a]] /; SetInvRightTp== True;
invR[aj[a_]] := aj[invL[a]] /; SetInvRightTp == False;

End[]

EndPackage[]
