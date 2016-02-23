(* :Title: 	NCMtools // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NCMtools` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["NCMtools`",
     "NonCommutativeMultiply`","Errors`"];

Clear[NCMToList];

NCMToList::usage = 
     "NCMToList";

Clear[LeadingCoefficient];

LeadingCoefficient::usage = 
     "LeadingCoefficient";

Clear[ToPolynomial];

ToPolynomial::usage = 
     "ToPolynomial";

Clear[RulesToRelations];

RulesToRelations::usage = 
     "RulesToRelations";

Clear[NormalizeCoefficient];

NormalizeCoefficient::usage = 
     "NormalizeCoefficient";

Begin["`Private`"];

NCMToList[x_NonCommutativeMultiply] := Apply[List,x];

NCMToList[x_List] := Map[NCMToList,x];

NCMToList[x_] := 
Module[{lead,result,y},
     lead = LeadingCoefficient[x];
     If[lead===1, result = {x};
                , result = NCMToList[x/lead];
                  result[[1]] = result[[1]] lead;
     ];
     Return[result];
];

NCMToList[x___] := BadCall["NCMToList",x];

LeadingCoefficient[c_?NumberQ x_] := c LeadingCoefficient[x];

LeadingCoefficient[x_/c_?NumberQ] := LeadingCoefficient[x]/c;

LeadingCoefficient[x_] := 1;

LeadingCoefficient[x___] := BadCall["LeadingCoefficient",x];

RulesToRelations[x_] := ToPolynomial[x];

RulesToRelations[x___] := BadCall["RulesToRelations",x];

ToPolynomial[aList_List] := Map[ToPolynomial,aList];

ToPolynomial[rule_Rule] := rule[[1]] - rule[[2]];

ToPolynomial[anEqual_Equal] := anEqual[[1]] - anEqual[[2]];

ToPolynomial[x_] := x;

ToPolynomial[x___] := BadCall["ToPolynomial",x];

NormalizeCoefficient[x_] := x/LeadingCoefficient[x];

NormalizeCoefficient[x___] := BadCall["NormalizeCoefficient",x];

End[];
EndPackage[]
