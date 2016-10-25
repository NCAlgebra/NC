(* :Title: 	EB // Mathematica 2.0 *)

(* :Author: 	Stan Yoshniobu (yoshinob) and Mark Stankus (mstankus).*)

(* :Context: 	EB` *)

(* :Summary:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage["EB`",
     "NonCommutativeMultiply`","Global`","Errors`"];

EB::usage =
     "EB[x,y] defines the inverse relations for x, y and 1 - x**y \
      the relations which would define a Groebner basis \
      for this set of relations.";
 
Begin["`Private`"];

EB[x_,y_] := EB[x,y,1];

EB[x_,y_,lambda_] := {
Inv[x] ** x -> 1,
 x ** Inv[x] -> 1,
Inv[y] ** y -> 1,
y ** Inv[y] -> 1,
x ** y ** Inv[1-x**y] -> -(- Inv[1-x**y] + 1),
y ** x ** Inv[1-y**x] -> -(- Inv[1-y**x] + 1),
Inv[1-x**y] ** x ** y -> -(- Inv[1-x**y] + 1),
 Inv[1-y**x] ** y ** x -> -(- Inv[1-y**x] + 1),
Inv[1-y**x] ** Inv[x] ->-(- y ** Inv[1-x**y] - Inv[x]),
Inv[1-x**y] ** Inv[y] -> -(- x ** Inv[1-y**x] - Inv[y]),
Inv[x] ** Inv[1-x**y] -> -(- y ** Inv[1-x**y] - Inv[x]),
Inv[y] ** Inv[1-y**x] -> -(- x ** Inv[1-y**x] - Inv[y]),
Inv[1-y**x] ** y -> -(- y ** Inv[1-x**y]),
Inv[1-x**y] ** x -> -(- x ** Inv[1-y**x])}

EB[x___] := BadCall["EB",x];

End[];
EndPackage[]
