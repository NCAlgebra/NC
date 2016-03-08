(* :Title: 	NCTransposes *)

(* :Author: 	mauricio *)

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

tp::usage =
"tp[x] is the tranpose of x. It is a linear involution. \
Note that all commutative expressions are assummed self-adjoint. \
See also aj.";

Begin[ "`Private`" ]

  (* tp is NonCommutative *)
  SetNonCommutative[tp];

  (* tp is Linear *)
  tp[a_ + b_] := tp[a] + tp[b];
  tp[c_?NumberQ] := c;
  tp[a_?CommutativeQ] := a;

  (* tp is Idempotent *)
  tp[tp[a_]] := a;

  (* tp threads over Times *)
  tp[a_Times] := tp /@ a;

  (* tp reverse threads over NonCommutativeMultiply *)
  HoldPattern[tp[NonCommutativeMultiply[a__]]] := 
        (NonCommutativeMultiply @@ (tp /@ Reverse[{a}]));

  (* tp[inv[]] = inv[tp[]] *)
  tp[inv[a_]] := inv[tp[a]];
                
End[]

EndPackage[]
