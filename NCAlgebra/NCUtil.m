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

Clear[NCGrabSymbols];
NCGrabSymbols::usage = "";

Clear[NCConsistentQ];
NCConsistentQ::usage = "";

Begin["`Private`"];

  NCGrabSymbols[exp_] := Union[Cases[exp, _Symbol, {0, Infinity}]];
  NCGrabSymbols[exp_, pattern_] := 
    Union[Cases[exp, (pattern)[_Symbol], {0, Infinity}]];

  NCConsistentQ[exp_] := 
    Length[Cases[exp, 
            a_?NonCommutativeQ * b_?NonCommutativeQ, {0, Infinity}]] == 0;
    
End[];
EndPackage[];
