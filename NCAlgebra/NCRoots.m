(* :Title: 	NCRoots // Mathematica 1.2 and 2.0 *)

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

rt::usage = 
"rt[x] is the root of x. ";

Begin[ "`Private`" ]

  SetNonCommutative[rt];

  (* rt commutative *)
  rt[c_?NumberQ] := Sqrt[c];
  rt[a_?CommutativeQ] := Sqrt[a];

  (* rt threads over Times *)
  rt[a_Times] := rt /@ a;

  (* Simplification *)
  NonCommutativeMultiply[n___,rt[m_],rt[m_],l___] :=
    NonCommutativeMultiply[n,m,l] 
 
  (* tp[rt[]] = rt[tp[]] *)
  tp[rt[a_]] := rt[tp[a]];

  (* BEGIN MAURICIO MAR 2016 *)
  (* There are best left for SimplifyRational *)
  (*
    rt/:Literal[NonCommutativeMultiply[n___,rt[Id - x_** m_],x_,l___]] :=
      NonCommutativeMultiply[n,x,rt[Id-m**x],l];

    rt/:Literal[NonCommutativeMultiply[n___,rt[Id - m_**tp[m_]],m_,l___]] :=
      NonCommutativeMultiply[n,m,rt[Id-tp[m]**m],l];
  *)

  (*
    NonCommutativeMultiply[n___,rt[m_],aj[rt[m_]],l___] :=
       NonCommutativeMultiply[n,m,l];
     
    rt/:Literal[NonCommutativeMultiply[n___,rt[Id - aj[m_]** m_],aj[m_],l___]] :=
      NonCommutativeMultiply[n,aj[m],rt[Id -m**aj[m]],l];

    rt/:Literal[NonCommutativeMultiply[n___,rt[Id - m_**aj[m_]], m_,l___]] :=
      NonCommutativeMultiply[n,m,aj[Id -aj[m]**m],l];
  *)
  (* END MAURICIO MAR 2016 *)
      
End[];
EndPackage[]
