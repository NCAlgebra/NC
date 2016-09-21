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
      NCGrabIndeterminants,
      NCConsolidateList,
      NCConsistentQ];

Get["NCUtil.usage"];

Begin["`Private`"];

  NCGrabSymbols[expr_] := Union[Cases[expr, _Symbol, {0, Infinity}]];
  NCGrabSymbols[expr_, pattern_] := 
    Union[Cases[expr, (pattern)[_Symbol], {0, Infinity}]];

  NCGrabFunctions[expr_] :=
    Union[Cases[expr, (Except[Plus|Times|NonCommutativeMultiply|List])[__], {0, Infinity}]];
  NCGrabFunctions[expr_, f_] :=
    Union[Cases[expr, (f)[__], {0, Infinity}]];

  NCGrabIndeterminants[expr_] := Union[NCGrabSymbols[expr], 
                                       NCGrabFunctions[expr]];
    
  NCConsolidateList[list_] := Block[
      {basis, index = Range[1, Length[list]]},
      basis = Merge[Thread[list -> index], Identity];
      MapIndexed[(index[[#1]] = #2[[1]])&, Values[basis]];
      Return[{Keys[basis], index}];
  ];
    
  NCConsistentQ[expr_] := 
    Length[Cases[expr, 
            a_?NonCommutativeQ * b_?NonCommutativeQ, {0, Infinity}]] == 0;

End[];
EndPackage[];
