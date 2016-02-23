(* :Title: 	SimplePower // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	SimplePower` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["SimplePower`",
    "Errors`"];

Clear[TheBase];

TheBase::usage = 
     "TheBase[x] gives x and TheBase[x^m] gives x.";

Clear[ThePower];

ThePower::usage = 
     "ThePower[x] gives 1 and ThePower[x^m] gives m.";

Begin["`Private`"];

TheBase[x_Power] := x[[1]];
TheBase[x_] := x;

TheBase[x___] := BadCall["TheBase",x];

ThePower[x_Power] := x[[2]];
ThePower[x_] := 1;

ThePower[x___] := BadCall["ThePower",x];

End[];
EndPackage[]
