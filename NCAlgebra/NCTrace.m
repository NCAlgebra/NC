
(*  NCTrace Utilities   *)
(* cycles terms of an expression about a give leteer or monomial  *)
(* The following takes the gradient with respect to VARIABLE of the Trace of a 
FUNCTION *)
(* The following takes the Directional derivative with respect to VARIABLE of 
the Natural Log Determinant of a FUNCTION 
in DIRECTION *)
(* Sept1999  Dell K and Bill H *)


NCCycleTerms[exp_,cycleabout_ ]:=
         Module[{CyclingRules, locVar },

(********** NOW  WE MAKE THE CYCLING RULES *************)

locVar = cycleabout;

SetNonCommutative[left, locVar, right];


CyclingRules = 
        {
          (number1_:1)*left___**locVar**right___ :> 
          (number1)*NonCommutativeMultiply[right]
          ** left**locVar
        };

(********** NOW  WE APPLY THE CYCLING RULES *************)

CycledExpression = 
    exp//.CyclingRules ;

   Return[CycledExpression];
];




(*********************************************************************)
(* The following takes the gradient with respect to VARIABLE of the Trace of a 
FUNCTION *)

NCGradTrace[ function_,variable_]:= 
NCCycleTerms[  DirD[function,  variable,  direction], 
direction ]//.direction ->1;

(* The following takes the Directional derivative with respect to VARIABLE of 
the Natural Log Determinant of a FUNCTION 
in DIRECTION *)

DirDLnDet[ function_,variable_, direction_]:= 
NCXTrace[NCCollect[NCCycleTerms[ NCExpand[
 DirD[function,  
variable,  direction]**inv[function]], 
direction ], direction]];
                
