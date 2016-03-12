(* :Title: 	NCMatMult.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NCMatMult` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :3/13/13: Deprecated LinearAlgebra`MatrixManipulation`. (mauricio)
   :04/23/93: Added a few usage statements.(mstankus)
   :11/08/94: Added NCMToMatMultSub, BlockDecompose and
              BlockDiagonal.(mstankus)
   :07/18/97: Bill added SchurComplement and coMat
   :07/19/99: Added LDU decomposition and Inverse. (Juan)
   :08/19/99: Added Diag (Juan)
   :09/09/04: Put a new NCInverse function in. JShopple
*)


BeginPackage["NCMatMult`",
	     "NonCommutativeMultiply`",
	     "NCLinearAlgebra`",
	     "NCSimplifyRational`"];

Clear[MatMult];

MatMult::usage=
"MatMult[x,y] (where x and y are matrices) gives the matrix \
multiplication of x and y using NonCommutativeMultiply \
rather than Times as Dot[] does.";

Clear[tpMat];

tpMat::usage =
"tpMat[x] (where x is a matrix) gives the matrix \
transpose using tp instead of Transpose";

Clear[ajMat];

ajMat::usage =
"ajMat[x] (where x is a matrix) gives the matrix \
adjoint transpose using aj instead of ConjugateTranspose";

Clear[coMat];

coMat::usage =
"coMat takes the complex conjugate (co) of each entry.";

Clear[NCInverse];

NCInverse::usage = "If M is a square matrix, then NCInverse[m] gives the noncommutative inverse of M.
Uses recursion and uses partial pivoting to find a nonzero pivot.
This command is primarily used symbolically.
Usually the elements of the inverse matrix are huge expressions.
We recommend using NCSimplifyRational to improve the results.";


Begin["`Private`"];

  (* -------------------------------------------------------------- *)
  (*  This defines block matrix multiplication and their transpose  *)
  (* -------------------------------------------------------------- *)
  (*  Long comment ------------
  The experienced matrix analyst should always remember that the 
  Mathematia convention for handling vectors is tricky. 

           v={{1,2,4}} -- is a 1x3 matrix or a row vector

           v={{1},{2},{4}} ---is a 3x1 matrix or a row vector

           v={1,2,4}  ----is a vector but NOT A MATRIX. Indeed whether it 
                          is a row or column vector depends on the context. 
                          DON'T USE IT. DON'T USE IT. Always remember to 
                          put TWO curly brackets on your vectors or 
                          there will probably be trouble. 
  End of Long comment ----- *)

  MatMult[x_?MatrixQ, y_?MatrixQ] := Inner[NonCommutativeMultiply,x,y,Plus];

  MatMult[x_List,y_List]:=Inner[NonCommutativeMultiply,x,y,Plus];

  MatMult[x_,y_,z__]:=MatMult[MatMult[x,y],z];

  (*  tp, aj, and co *)
  tpMat[u_]:=Transpose[Map[tp,u,{2}]] /; Length[Dimensions[u]] >=2

  ajMat[u_]:=Transpose[Map[aj,u,{2}]] /; Length[Dimensions[u]] >=2

  coMat[u_]:= Map[co,u,{2}] /; Length[Dimensions[u]] >=2

  (********* New NCInverse. JShopple 9/9/04  **********)
  (* Pivots on the 1-by-1 upper left element after pivoting (exchanging rows),
     and uses recursion on the n-1 by n-1 lower right block. *)

  NCInverse::NotSquare = "The input matrix is not SQUARE.";
  NCInverse::Singular = "The input matrix appears to be SINGULAR.";
  NCInverse::NotMatrix = "The input argument is not a MATRIX.";

  NCInverse[InputMat_?MatrixQ] := 
      Module[{m, n, Mat = InputMat, PivotPosition, PivotRow, Ainv, AinvB, 
          CAinv, Minv},

        (*** Check if Mat is square ***)
        {m, n} = Dimensions[Mat];
        If[m != n, Message[NCInverse::NotSquare]; Return[]];

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

        Mat = NCBlockMatrix[{{Ainv + 
                  MatMult[AinvB, Minv, CAinv], -MatMult[AinvB, 
                    Minv]}, {-MatMult[Minv, CAinv], Minv}}];

        (*** Permute columns because of pivoting ***)

        Mat[[All, {1, PivotRow}]] = Mat[[All, {PivotRow, 1}]];

        Return[Mat];
        ];
  NCInverse[NotMat_] := Message[NCInverse::NotMatrix];


  (* NCSymmetricTest *)
  
  NCSymmetricTest[mat_?MatrixQ, opts:OptionsPattern[{}]] := 
    NonCommutativeMultiply`Private`NCSymmetricTestAux[
        mat, 
        ExpandNonCommutativeMultiply[mat - tpMat[mat]], 
        ConstantArray[0, Dimensions[mat]], opts];

  (* NCSelfAdjointTest *)
  
  NCSelfAdjointTest[mat_?MatrixQ, opts:OptionsPattern[{}]] := 
    NonCommutativeMultiply`Private`NCSelfAdjointTestAux[
        mat, 
        ExpandNonCommutativeMultiply[mat - ajMat[mat]], 
        ConstantArray[0, Dimensions[mat]], opts];

End[];
EndPackage[];

