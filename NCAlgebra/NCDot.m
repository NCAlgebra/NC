(* :Title: 	NCDot.m *)

(* :Author: 	Unknown. *)

(* :Context: 	NCDot` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)


BeginPackage["NCDot`",
	     {"NonCommutativeMultiply`"}];

Clear[NCDot,
      tpMat, ajMat, coMat];

Get["NCDot.usage"];

NCInverse::NotSquare = "The input matrix is not SQUARE.";
NCInverse::Singular = "The input matrix appears to be SINGULAR.";
NCInverse::NotMatrix = "The input argument is not a MATRIX.";

Begin["`Private`"];

  (* new dot operator *)
  (* MatMult = NCDot; *)

  (* No need to test for matrices *)
  (* NCDot[x_?MatrixQ, y_?MatrixQ] := 
     Inner[NonCommutativeMultiply,x,y,Plus]; *)
      
  NCDot[x_,y_] := Inner[NonCommutativeMultiply,x,y,Plus];
  NCDot[x_,y_,z__] := NCDot[NCDot[x,y],z];

  
  (*  tp, aj, and co *)

  tpMat[u_]:=Transpose[Map[tp,u,{2}]] /; Length[Dimensions[u]] >=2
  ajMat[u_]:=Transpose[Map[aj,u,{2}]] /; Length[Dimensions[u]] >=2
  coMat[u_]:= Map[co,u,{2}] /; Length[Dimensions[u]] >=2

  (* Automatically expand tp over matrices *)
  
  tp[x_?MatrixQ] := tpMat[x];
  aj[x_?MatrixQ] := ajMat[x];
  co[x_?MatrixQ] := coMat[x];
  
End[];
EndPackage[];

