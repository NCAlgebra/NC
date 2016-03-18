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
             "NCPolynomial`",
             "NonCommutativeMultiply`"];

Clear[NCGrabSymbols];
NCGrabSymbols::usage = "";

Clear[NCConsistentQ];
NCConsistentQ::usage = "";

Clear[NCTermsOfDegree];
NCTermsOfDegree::usage = 
     "NCTermsOfDegree[expr,aList,indices] (where expr is an \
      expression, aList is a list of variable names and indices \
      is a list of positive integers) returns an expression such that \
      each term in the expression has the right number of factors \
      of the variables. For example, \
      NCTermsOfDegree[x**y**x + x**w,{x,y},indices] returns \
      x**y**x if indices = {2,1}, return x**w if indices = {1,0} \
      and returns 0 otherwise. This routine is used heavily by \
      NCTermList.";    

Begin["`Private`"];

  NCGrabSymbols[exp_] := Union[Cases[exp, _Symbol, {0, Infinity}]];
  NCGrabSymbols[exp_, pattern_] := 
    Union[Cases[exp, (pattern)[_Symbol], {0, Infinity}]];

  NCConsistentQ[exp_] := 
    Length[Cases[exp, 
            a_?NonCommutativeQ * b_?NonCommutativeQ, {0, Infinity}]] == 0;

  NCTermsOfDegree[expr_, vars_, degree_] :=
    NCPTermsToNC[NCPTermsOfDegree[NCToNCPolynomial[expr, vars], degree]];
    
End[];
EndPackage[];
