(* :Title: 	Coefficients // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus).
*)

(* :Context: 	Coefficients` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["Coefficients`","Errors`"];

Clear[TheCoefficient];

TheCoefficient::usage = 
     "TheCoefficient";

Clear[Coeff];

Coeff::usage = 
     "Coeff";

Clear[SimplifyCoeff];

SimplifyCoeff::usage = 
     "SimplifyCoeff";

Begin["`Private`"];

TheCoefficient[x_Coeff y_.] := x;

TheCoefficient[x___] := BadCall["TheCoefficient",x];

SimplifyCoeff[expr_] := expr//. {
           Coeff[x_] y_ + Coeff[z_] y_ :> Coeff[x+z] y,
           Coeff[x_] Coeff[y_] :> Coeff[x y]
                                };

Coeff[1] = 1;

Coeff[x_,y__] := BadCall["Coeff",x,y];

SimplifyCoeff[x___] := BadCall["SimplifyCoeff",x,y,z];

End[];
EndPackage[];
