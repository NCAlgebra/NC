(* :Title: 	NCPInverses // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus. (mstankus) *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:    Implementation of genralized (psuedo) inverses
                via pinv.
*)

(* :Alias:
*)

(* :Warnings:   
*)

(* :History: 
   :3/7/93:   Wrote package. (mstankus)
*)

BeginPackage[ "NonCommutativeMultiply`" ]

pinv::usage =
     "pinv[x] implements the Moore-Penrose inverse of a matrix. \
      pinv follows the following six rules: \n \n \
      pinv[A_]**A_**pinv[A_] := pinv[A]; \n \
      A_**pinv[A_]**A_       := A; \n \
      tp[A_]**tp[pinv[A_]]   := pinv[A]**A; \n \
      tp[pinv[A_]]**tp[A_]   := A**pinv[A]; \n \
      aj[A_]**aj[pinv[A_]]   := pinv[A]**A; \n \
      aj[pinv[A_]]**aj[A_]   := A**pinv[A]";

ginv::usage =
     "ginv[x] implements the genralized inverse of a matrix. \
      ginv follows the following two rules: \n \n \
      ginv[A_]**A_**ginv[A_] := ginv[A]; \n \
      A_**ginv[A_]**A_       := A;  \n \
      See pinv.";

Begin[ "`Private`" ]

SetNonCommutative[pinv,A,anything1,anything2];

NCSetRule[pinv[A_]**A_**pinv[A_],pinv[A],Trigger->pinv];

NCSetRule[A_**pinv[A_]**A_,A,Trigger->pinv];

NCSetRule[tp[A_]**tp[pinv[A_]],pinv[A]**A,Trigger->tp];

NCSetRule[tp[pinv[A_]]**tp[A],A**pinv[A],Trigger->tp];

NCSetRule[aj[A_]**aj[pinv[A_]],pinv[A]**A,Trigger->aj];

NCSetRule[aj[pinv[A_]]**aj[A],A**pinv[A],Trigger->aj];

NCSetRule[ginv[A_]**A_**ginv[A_],ginv[A],Trigger->ginv];

NCSetRule[A_**ginv[A_]**A_,A,Trigger->ginv];

End[]

EndPackage[]
