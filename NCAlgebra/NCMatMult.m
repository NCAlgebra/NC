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
             "NonCommutativeMultiply`",
             "NCReplace`" ];

Clear[MatMult, NCInverse,
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
  
  (********* New NCInverse. JShopple 9/9/04  **********)
  (* Pivots on the 1-by-1 upper left element after pivoting (exchanging rows),
     and uses recursion on the n-1 by n-1 lower right block. *)

  NCInverse[InputMat_?MatrixQ] := 
      Module[{m, n, Mat = InputMat, PivotPosition, PivotRow, Ainv, AinvB, 
          CAinv, Minv},

        (*** Check if Mat is square ***)
        {m, n} = Dimensions[Mat];
        If[m != n, Message[NCInverse::NotSquare]; Return[Mat]];

        (*** Check if matrix is 1 - by - 1 ***)

        If[m == 1, If[Mat[[1, 1]] =!= 0, Return[{{inv[Mat[[1, 1]]]}}],
            (* else *) 
            Message[NCInverse::Singular]; Return[Null]]
          ];

        (*** Find a pivot ***)

        PivotPosition = 
          Position[Mat[[All, {1}]], x_?(Rationalize[#] =!= 0 &), {2}, 1, 
            Heads -> False]; 
            (* ??? OK to use Rationalize to check for 0.0*NCexpr and 0.0 ??? JShopple *)
            (* Assumes Rationalize[THE PIVOT] =!= 0 -- Shopple, Stankus *)



        (*** If first column all zero, then singular ***)

        If[Length[PivotPosition] == 0, Message[NCInverse::Singular]; 
          Return[]];

        (*** Swap rows ***)
        PivotRow = PivotPosition[[1, 1]];
        Mat[[{1, PivotRow}]] = Mat[[{PivotRow, 1}]];

        (*** Invert {{A, B}, {C, D}} where A is a 1 - by - 1 block ***)

        Ainv = NCInverse[ Mat[[{1}, {1}]] ];
        AinvB = MatMult[ Ainv, Mat[[{1}, Range[2, m]]] ];
        CAinv = MatMult[ Mat[[Range[2, m], {1}]], Ainv ];

        (*** M = D - C ** NCInverse[A] ** B     ***)

        Minv = NCInverse[ 
            Mat[[Range[2, m], Range[2, m]]] - 
              MatMult[Mat[[Range[2, m], {1}]], AinvB] ];

        (*** Was M singular? ***)

        If[Minv == Null, Return[]]; (*** M was singular ***)

        (*** The inverse of the row permuted input matrix ***)

        Mat = ArrayFlatten[{{Ainv + 
                  MatMult[AinvB, Minv, CAinv], -MatMult[AinvB, 
                    Minv]}, {-MatMult[Minv, CAinv], Minv}}];

        (*** Permute columns because of pivoting ***)

        Mat[[All, {1, PivotRow}]] = Mat[[All, {PivotRow, 1}]];

        Return[Mat];
             
  ];
  NCInverse[NotMat_] := Message[NCInverse::NotMatrix];

End[];
EndPackage[];

