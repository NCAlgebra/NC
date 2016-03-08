(* :Title: 	NCAdjoints *)

(* :Author: 	mauricio. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :2/03/16:    Clean up (mauricio)
*)

BeginPackage[ "NonCommutativeMultiply`" ]

aj::usage = 
"aj[x] is the adjoint of x. aj is a conjugate linear involution. \
See also tp.";

Begin[ "`Private`" ]

  (* aj is NonCommutative *)
  SetNonCommutative[aj];

  (* aj is Conjugate Linear *)
  aj[a_ + b_] := aj[a] + aj[b];
  aj[c_?NumberQ] := Conjugate[c];
  aj[a_?CommutativeQ]:= Conjugate[a];

  (* aj is Idempotent *)
  aj[aj[a_]] := a;

  (* aj threads over Times *)
  aj[a_Times] := aj /@ a;

  (* aj reverse threads over NonCommutativeMultiply *)
  HoldPattern[aj[NonCommutativeMultiply[a__]]] := 
        (NonCommutativeMultiply @@ (aj /@ Reverse[{a}]));

  (* aj[inv[]] = inv[aj[]] *)
  aj[inv[a_]] := inv[aj[a]];

End[]

EndPackage[]
