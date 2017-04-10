(* :Title: 	NCDeprecated.m *)

(* :Author: 	mauricio *)

(* :Context: 	NCDeprecated` *)

(* :Summary: 
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage["NCDeprecated`",
	     "NCReplace`",
             "NCDot`",
	     "NCUtil`",
             "NonCommutativeMultiply`"];

Clear[MatMult,
      Transform,
      Substitute,
      SubstituteAll,
      SubstituteSingleReplace,
      SubstituteSymmetric,
      GrabIndeterminants,
      GrabVariables];

NCDeprecated::Going = "Command \"`1`\" is in the process of being deprecated. It has been made obsolete by \"`2`\" instead.";

NCDeprecated::Gone = "Command \"`1`\" has been deprecated and is no longer supported. From now on use \"`2`\" instead.";

NCDeprecated::OptionGone = "Option \"`1`\" has been deprecated and is no longer supported.";

Begin["`Private`"];

  MatMult[expr___] :=
    (Message[NCDeprecated::Going, MatMult, NCDot]; NCDot[expr]);
    
  Transform[expr_, rules_] :=
    (Message[NCDeprecated::Going, Transform, NCReplaceRepeated]; NCReplaceRepeated[expr, rules]);

  Substitute[expr_, rules_] :=
    (Message[NCDeprecated::Going, Substitute, NCReplaceRepeated]; NCReplaceRepeated[expr, rules]);

  SubstituteSingleReplace[expr_, rules_] :=
    (Message[NCDeprecated::Going, SubstituteSingleReplace, NCReplaceAll]; NCReplaceAll[expr, rules]);

  SubstituteAll[expr_, rules_] :=
    (Message[NCDeprecated::Gone, SubstituteAll, NCReplaceAll]; $Failed);

  GrabIndeterminants[expr_] :=
    (Message[NCDeprecated::Going, GrabIndeterminants, NCGrabIndeterminants]; NCGrabIndeterminants[expr]);

  GrabVariables[expr_] :=
    (Message[NCDeprecated::Going, GrabVariables, NCGrabSymbols]; NCGrabSymbols[expr]);

End[];
EndPackage[];
