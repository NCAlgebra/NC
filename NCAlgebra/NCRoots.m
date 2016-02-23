(* :Title: 	NCRoots // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :4/21/93: Added rt/: to some commands. (mstankus)
   :4/23/93: Wrapped a few commands with Literal's. (mstankus)
*)

(* ---------------------------------------------------------------- *)
(*	This defines square roots of elements.                      *)
(*	They are not neccessarily symmetric; invoke SetSelfAdjoint  *)
(*      to make them symmetric			                    *)
(* ---------------------------------------------------------------- *)
	
BeginPackage[ "NonCommutativeMultiply`" ]

(* :Note: inv is Cleared and used in NCMultiplication.m which
          preceeds this file.
*)
(* Clear[rt]; *)

rt::usage = 
     "rt[x] is the (not neccessarily self-adjoint) root \
      of x. ";

Begin[ "`Private`" ]

SetNonCommutative[k,n,m,l,rt];

rt/:Literal[NonCommutativeMultiply[n___,rt[m_],rt[m_],l___]] :=
        NonCommutativeMultiply[n,m,l] 

rt/:Literal[NonCommutativeMultiply[n___,rt[Id - x_** m_],x_,l___]] :=
   NonCommutativeMultiply[n,x,rt[Id-m**x],l];

rt/:Literal[NonCommutativeMultiply[n___,rt[Id - m_**tp[m_]],m_,l___]] :=
   NonCommutativeMultiply[n,m,rt[Id-tp[m]**m],l];

LeftQ[inv,rt] := False;
SetCommutingFunctions[inv,rt];

(* --------------------------------------------------------------------- *)
(*   Roots and adjoints                                                  *)    
(* --------------------------------------------------------------------- *)

rt/:Literal[NonCommutativeMultiply[n___,rt[m_],aj[rt[m_]],l___]] :=
        NonCommutativeMultiply[n,m,l]

rt/:Literal[NonCommutativeMultiply[n___,rt[Id - aj[m_]** m_],aj[m_],l___]] :=
   NonCommutativeMultiply[n,aj[m],rt[Id -m**aj[m]],l];

rt/:Literal[NonCommutativeMultiply[n___,rt[Id - m_**aj[m_]], m_,l___]] :=
   NonCommutativeMultiply[n,m,aj[Id -aj[m]**m],l];

End[];
EndPackage[]
