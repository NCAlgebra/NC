(* :Title: 	NCUtil.m *)

(* :Author: 	mauricio *)

(* :Context: 	NCUtil` *)

(* :Summary: 
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage["NCUtil`",
             "NonCommutativeMultiply`"];

Clear[NCGrabSymbols,
      NCGrabFunctions,
      NCConsistentQ];

Get["NCUtil.usage"];

Begin["`Private`"];

  NCGrabSymbols[exp_] := Union[Cases[exp, _Symbol, {0, Infinity}]];
  NCGrabSymbols[exp_, pattern_] := 
    Union[Cases[exp, (pattern)[_Symbol], {0, Infinity}]];

  NCGrabFunctions[exp_, f_] :=
    Union[Cases[exp, (f)[_], {0, Infinity}]];
    
  NCConsistentQ[exp_] := 
    Length[Cases[exp, 
            a_?NonCommutativeQ * b_?NonCommutativeQ, {0, Infinity}]] == 0;

End[];
EndPackage[];
