(* :Title: 	NCCo // Mathematica 1.2 and 2.0 *)

(* :Author: 	mauricio . *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :2/03/16:    First real implementation (mauricio)
*)

(* ------------------------------------------------------------------ *)
(*     Some people like to use the abbreviation co for aj[tp[x]].     *)
(*     See also complex.m                                             *)
(* ------------------------------------------------------------------ *)

BeginPackage[ "NonCommutativeMultiply`" ]

co::usage =
     "co[x] is the conjugate of x. It is a linear involution. \
      See also aj,SetSelfAdjoint, SetIsometry,....";

Begin[ "`Private`" ]

SetNonCommutative[co];

(* 
Literal[aj[tp[x_]]] := co[x];
Literal[tp[aj[x_]]] := co[x];
*)

SetConjugateLinear[co];
SetIdempotent[co];

Unset[co[0]];
co[s_Times] := co /@ s;
co[z_]:= Conjugate[z] /; CommutativeAllQ[z]

(* Relationship with aj and tp *)

aj[tp[x_]] := co[x];
tp[aj[x_]] := co[x];

ExpandQ[co] ^= True;
NCHomo[co];

End[]

EndPackage[]
