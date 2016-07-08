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
      NCConsolidateList,
      NCConsistentQ];

Get["NCUtil.usage"];

Begin["`Private`"];

  NCGrabSymbols[exp_] := Union[Cases[exp, _Symbol, {0, Infinity}]];
  NCGrabSymbols[exp_, pattern_] := 
    Union[Cases[exp, (pattern)[_Symbol], {0, Infinity}]];

  NCGrabFunctions[exp_, f_] :=
    Union[Cases[exp, (f)[__], {0, Infinity}]];

  NCConsolidateList[list_] := Block[
      {basis, index = Range[1, Length[list]]},
      basis = Merge[Thread[list -> index], Identity];
      MapIndexed[(index[[#1]] = #2[[1]])&, Values[basis]];
      Return[{Keys[basis], index}];
  ];
    
  NCConsistentQ[exp_] := 
    Length[Cases[exp, 
            a_?NonCommutativeQ * b_?NonCommutativeQ, {0, Infinity}]] == 0;

End[];
EndPackage[];
