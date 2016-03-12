(* :Title: 	NCConjugates *)

(* :Author: 	mauricio *)

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

BeginPackage[ "NonCommutativeMultiply`" ]

co::usage =
     "co[x] is the conjugate of x. It is a linear involution. \
      See also aj,SetSelfAdjoint, SetIsometry,....";

Begin[ "`Private`" ]

  (* co is NonCommutative *)
  SetNonCommutative[co];

  (* co is Conjugate Linear *)
  co[a_ + b_] := co[a] + co[b];
  co[c_?NumberQ] := Conjugate[c];
  co[a_?CommutativeQ]:= Conjugate[a];

  (* co is Idempotent *)
  co[co[a_]] := a;

  (* co threads over Times *)
  co[a_Times] := co /@ a;

  (* co threads over Times *)
  co[a_Times] := co /@ a;

  (* co threads over NonCommutativeMultiply *)
  co[NonCommutativeMultiply[a__]] := 
    (NonCommutativeMultiply @@ (co /@ {a}));
  
  (* Relationship with aj and tp *)

  aj[tp[a_]] := co[a];
  tp[aj[a_]] := co[a];

  co[tp[a_]] := aj[a];
  co[aj[a_]] := tp[a];

End[]

EndPackage[]
