(* :Title: 	NCMonomial // Mathematica 1.2 and 2.0 *)

(* :Author: 	mauricio *)

(* :Context: 	NCMonomial` *)

(* :Summary:	
*)

(* :Alias:	None. *)

(* :Warnings: 	*)

(* :History: 
   :3/3/16:  Clean-up. Powers are in!
*)

BeginPackage["NonCommutativeMultiply`"];

Begin[ "`Private`" ];

  (* Expand monomial rules *)
  Unprotect[Power];
  Power[b_, c_Integer?Positive] := 
    Apply[NonCommutativeMultiply, Table[b, {c}]] /; !CommutativeQ[b];
  Power[b_, c_Integer?Negative] := 
    inv[Apply[NonCommutativeMultiply, Table[b, {-c}]]] /; !CommutativeQ[b];
  Protect[Power];

End[];
EndPackage[]
