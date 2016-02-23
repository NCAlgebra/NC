(* :Title: 	NCTransposes // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage[ "NonCommutativeMultiply`" ]

(* MAURICIO: JUNE 2009: MUST BE DONE IN NCMULTIPLICATION FOR CE TO WORK *)
(* Clear[tp]; *)

tp::usage =
     "tp[x] is the tranpose of x. It is a linear involution. \
      Note that all commutative expressions are assummed self-adjoint. \
      See also aj,SetSelfAdjoint, SetIsometry,....";

Clear[SetInvRightTp];

SetInvRightTp::usage = 
     "If set to True,then the rule tp[invL[a_]]:=invR[tp[a]]; will \
      be executed and if False, then the reverse rule \
      invR[tp[a_]]:=tp[invL[a]]; will be executed.";

Begin[ "`Private`" ]

SetNonCommutative[tp];

(* ---------------------------------------------------------------- *)
(*	Rules for transposes                                        *)
(* ---------------------------------------------------------------- *)
SetLinear[tp];
SetIdempotent[tp];
tp[s_*az_]:=s*tp[az]/;CommutativeAllQ[s];
tp[Id] := Id;
tp[-1]:=-1;
tp[z_]:= z/;NumberQ[z]
tp[z_]:=z/;CommutativeAllQ[z]

(* ---------------------------------------------------------------- *)
(*      The product of transposes is the reverse product of the     *)
(*      tranposes.                                                  *)
(* ---------------------------------------------------------------- *)
ExpandQ[tp] = True;
NCAntihomo[tp];

(* ---------------------------------------------------------------- *)
(*	Relation between transposes and inverses                    *)
(* ---------------------------------------------------------------- *)
(* --- Not necessary. Done in NCInverses.m
inv[tp[a_]]**tp[a_]:=Id;
tp[a_]**inv[tp[a_]]:=Id;
*)

LeftQ[inv,tp] := True;
SetCommutingFunctions[inv,tp];

SetInvRightTp = True;
tp[invL[a_]] := invR[tp[a]] /; SetInvRightTp== True;
invR[tp[a_]] := tp[invL[a]] /; SetInvRightTp == False;

End[]

EndPackage[]
