(* :Title: 	NCMatMult.m *)

(* :Author: 	Unknown. *)

(* :Context: 	NCMatMult` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)


BeginPackage["NCMatMult`",
             "NCReplace`",
             "NonCommutativeMultiply`"];

Clear[MatMult,
      tpMat, ajMat, coMat,
      NCMatrixExpand];

Get["NCMatMult.usage"];

NCInverse::NotSquare = "The input matrix is not SQUARE.";
NCInverse::Singular = "The input matrix appears to be SINGULAR.";
NCInverse::NotMatrix = "The input argument is not a MATRIX.";

Begin["`Private`"];

  (* No need to test for matrices *)
  (* MatMult[x_?MatrixQ, y_?MatrixQ] := 
     Inner[NonCommutativeMultiply,x,y,Plus]; *)
      
  MatMult[x_,y_] := Inner[NonCommutativeMultiply,x,y,Plus];
  MatMult[x_,y_,z__] := MatMult[MatMult[x,y],z];

  
  (*  tp, aj, and co *)

  tpMat[u_]:=Transpose[Map[tp,u,{2}]] /; Length[Dimensions[u]] >=2
  ajMat[u_]:=Transpose[Map[aj,u,{2}]] /; Length[Dimensions[u]] >=2
  coMat[u_]:= Map[co,u,{2}] /; Length[Dimensions[u]] >=2

  
  (* Expand ** between matrices *)
  
  NCMatrixExpand[expr_] := 
      NCReplaceRepeated[
          (expr //. inv[a_?MatrixQ] :> NCInverse[a])
         , 
          NonCommutativeMultiply[b_List, c__List] :>
               MatMult[b, c]

(*
      {
          NonCommutativeMultiply[b_List, c__List] :>
               MatMult[b, c],
          NonCommutativeMultiply[b_List, c_] /; Head[c] =!= List :>
               (* Map[NonCommutativeMultiply[#, c]&, b, {2}], *)
               MatMult[b, {{c}}],
          NonCommutativeMultiply[b_, c_List] /; Head[b] =!= List :>
               (* Map[NonCommutativeMultiply[b, #]&, c, {2}] *)
               MatMult[{{b}}, c]
      }
*)
      ];

  (* Automatically expand tp over matrices *)
  
  tp[x_?MatrixQ] := tpMat[x];
  aj[x_?MatrixQ] := ajMat[x];
  co[x_?MatrixQ] := coMat[x];
  
End[];
EndPackage[];

