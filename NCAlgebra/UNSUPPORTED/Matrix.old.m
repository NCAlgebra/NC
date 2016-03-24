(* :Title: Matrix.m *)

(* :Author: Mauricio C. de Oliveira *)

(* :Context: Matrix` *)

(* :Sumary: *)

(* :Alias: *)

(* :Warnings: *)

(* :History:
   :3/13/13: Deprecated LinearAlgebra`MatrixManipulation`. (mauricio)
   :06/01/2004: First Version
*)

BeginPackage[ 
     "Matrix`",
     "NCLinearAlgebra`"
];

Clear[Matrix]

Matrix::usage = "
Matrix[m] wraps a two-dimensional list under a Matrix head. \ 
Try to substitute 'a + b.c' with matrices by applying a rule for one \
matrix at a time and see what happens... \ 
This is all because Plus is Listable and Mathematica makes no \
distinction between two-dimensional lists and matrices.";


Clear[MatrixToList]

MatrixToList::usage = "MatrixToList[m] converts Matrix m into a two dimensional list.";


Clear[MatrixToVector]

MatrixToList::usage = "MatrixToVector[m] converts Matrix m into a one dimensional list (column oriented).";


Clear[SymmetricMatrixToVector]

MatrixToList::usage = "SymmetricMatrixToVector[m] converts symmetric Matrix m into a one dimensional list (lower diagonal, column oriented).";


Clear[MatrixFlatten]

MatrixFlatten::usage = "MatrixFlatten[m] attempts to flatten first level entries in a Matrix. If it fails it returns the original Matrix";

Clear[NumericMatrixQ]

NumericMatrixQ::usage = "NumericMatrixQ[m] returs True if all entries \
of Matrix return True to NumericQ";

Clear[ZeroQ]

ZeroQ::usage = "ZeroQ[m] returs True if all entries \
of Matrix are zero";

Clear[VectorToMatrix]

VectorToMatrix::usage = "VectorToMatrix[m] converts a Mathematica vector (unidimensional list) into a column Matrix.";

Clear[MatrixDimensions]

MatrixDimensions::usage = "MatrixDimensions[m] provides Dimensions that accounts for Matrix entries.";

Clear[MatrixProductDimensions]
Clear[MatrixEntryDimensions]
Clear[MatrixCompatibleDimensionsQ]


Begin["`Private`"]; 

  (* Messages *)

  Matrix::notamatrix = "This is not a Matrix.";
  Matrix::wrongdimensions="Incompatible dimensions."


  (* Attributes *)

  SetAttributes[Matrix, NumericFunction];


  (* Constructors *)

  Matrix[x_?MatrixQ] := Apply[Matrix, x];
  Matrix[x___] := Matrix[] /; !MatrixCompatibleDimensionsQ[{x}];
  Matrix[] := (Message[Matrix::notamatrix]; $Failed);


  (* Dimension (for List) *)

  MatrixProductDimensions[a_]:=a
  MatrixProductDimensions[{a_,b_},{c_,d_}]:=(If[b=!=c, Message[Matrix::wrongdimensions]];{a,d});
  MatrixProductDimensions[a__,b_,c_]:=MatrixProductDimensions[a,MatrixProductDimensions[b,c]]

  MatrixEntryDimensions[(a_:1)*b_Dot] :=
      Apply[MatrixProductDimensions,Map[MatrixEntryDimensions,Apply[List,b]]];
  (* MatrixEntryDimensions[Plus[a_Matrix,b___]]:=MatrixEntryDimensions[a]; *)
  MatrixEntryDimensions[x_Plus] := Union[Map[MatrixEntryDimensions, Apply[List, x]]][[1]]
  MatrixEntryDimensions[m_Matrix]:=MatrixDimensions[m];
  MatrixEntryDimensions[exp_]:={1,1}

  MatrixCompatibleDimensionsQ[m_?MatrixQ]:=
    Module[
      {tmp},
      tmp=Check[Map[MatrixEntryDimensions,m,{2}],Return[False]];
  (*
      Print["* ", m, ", ", Apply[Equal,tmp[[All,All,1]],{1}], ", ", Apply[Equal,Transpose[tmp[[All,All,2]]],{1}]];
   *)
      Return[ Apply[And, Apply[Equal, tmp[[All,All,1]], {1}]] && 
              Apply[And, Apply[Equal, Transpose[tmp[[All,All,2]]], {1}]] ]
    ];
  MatrixCompatibleDimensionsQ[m___]:=False;


  (* Dimensions (for Matrix) *)

  Dimensions[m_Matrix] ^:= Dimensions[MatrixToList[m]]

  MatrixDimensions[m_Matrix] := Module[
      {col=MatrixToList[m][[All,1]],row=MatrixToList[m][[1,All]]},
  (*
      Print["1) col = ", col, ", row = ", row];
      Print["2) col = ", Map[MatrixEntryDimensions,col], ", row = ", Map[MatrixEntryDimensions,row]];
      Print["3) col = ", Map[MatrixEntryDimensions,col][[All,1]], ", row = ", Map[MatrixEntryDimensions,row][[All,2]]];
      Print["4) col = ", Apply[Plus, Map[MatrixEntryDimensions,col][[All,1]]], ", row = ", Apply[Plus, Map[MatrixEntryDimensions,row][[All,2]]]];
   *)
      {
       Apply[Plus, Map[MatrixEntryDimensions,col][[All,1]] ],
       Apply[Plus, Map[MatrixEntryDimensions,row][[All,2]] ]
      }
    ];


  (* Conversions *)

  VectorToMatrix[l_?VectorQ] := Matrix[Map[List,l]];
  VectorToMatrix[l_?MatrixQ] := Matrix[l];
  VectorToMatrix[l_] := l;

  MatrixToList[a_Matrix, Infinity] := a //. x_Matrix->MatrixToList[x];
  MatrixToList[a_Matrix] := Apply[List,a];

  MatrixToVector[a_Matrix] := Flatten[MatrixToList[a]];
  SymmetricMatrixToVector[a_Matrix] := Module[
      {m, n},

      {m, n} = Dimensions[a]; 
      Flatten[Table[a[[i, j]], {i, 1, m}, {j, 1, i}]]
  ];

  (* ArrayFlatten *)

  ArrayFlatten[a_Matrix] ^:= Matrix[ArrayFlatten[MatrixToList[a,Infinity]]];

  (* MatrixFlatten *)

  MatrixFlatten[a_Matrix] := 
      Check[Apply[Matrix,Apply[FlatMatrix,a]],a] /; Dimensions[a]=!=MatrixDimensions[a]
  MatrixFlatten[a_] := Map[MatrixFlatten,a];


  (* FlatMatrix *)

  (* 
   * FlatMatrix is an internal matrix that is completely flat at the level 1.
   * MatrixFlatten operates by replacing the first level construction of Matrix 
   * by a FlatMatrix and then reversing it back to Matrix if nothing fails.
   *)

  Clear[FlatMatrix]

  (* Single Matrix Concatenate *)

  FlatMatrix[{a_Matrix}] := Apply[FlatMatrix,a];

  (* Vertical Concatenate *)

  FlatMatrix[a___,{b_Matrix},{c_Matrix},d___] := 
          FlatMatrix[a,{Apply[Matrix,NCAppendColumns[MatrixToList[b],MatrixToList[c]]]},d];
  FlatMatrix[a___,{b_Matrix},c___] :=
    Apply[FlatMatrix[a,##,c]&,b];

  (* Horizontal Concatenate *)

  FlatMatrix[a___,{b___,c_Matrix,d_Matrix,e___},f___] :=
          FlatMatrix[a,{b,Apply[Matrix,NCAppendRows[MatrixToList[c],MatrixToList[d]]],e},f];
  FlatMatrix[a___,{b___,c_Matrix,d___},e___] :=
          Apply[FlatMatrix[a,{b,##,d},e]&,c[[1]]] /; MatrixDimensions[c][[1]] == 1;


  (* Part *)

  Part[m_Matrix, i_, j_] ^:= VectorToMatrix[Part[MatrixToList[m], i, j]]


  (* Numeric tests *)

  (*
  NumberQ[a_Matrix] ^:= Apply[And, Flatten[Map[NumberQ, MatrixToList[a], {2}]]]

  NumericMatrixQ[a_Matrix] := Apply[And, Flatten[Map[NumericQ, MatrixToList[a], {2}]]]
  NumericMatrixQ[a_] := False;
  *)

  NumberQ[a_Matrix] ^:= MatrixQ[MatrixToList[a], NumberQ];

  NumericMatrixQ[a_Matrix] := MatrixQ[MatrixToList[a], NumberQ];
  NumericMatrixQ[a_] := False;


  ZeroQ[a_Matrix] ^:= Apply[And, Flatten[Map[(# === 0) &, MatrixToList[a], {2}]]];


  (* Ouput *)

  MatrixForm[a_Matrix] ^:= MatrixForm[MatrixToList[a]]

  Format[x_Matrix, StandardForm] ^:= MatrixForm[x]


  (* Arithmetic Operations *)


  (* Plus *)

  (* Prevents addition with different sizes

  Matrix /: 
    Plus[a_Matrix, (c : 1)*b_NonCommutativeMultiply] := $Failed /; 
      SameEntries[Map[MatrixDimensions, {a, b}]] == -1

  Plus[a_Matrix, b_Matrix] ^:= $Failed /; 
      SameEntries[Map[MatrixDimensions, {a, b}]] == -1
  *)

  (* General rule *)
  Plus[a_Matrix, b_Matrix] ^:= Matrix[Plus[MatrixToList[a], MatrixToList[b]]];

  Times[a_Matrix, b_Matrix] ^:= Matrix[Times[MatrixToList[a], MatrixToList[b]]];
  Times[a_, b_Matrix] ^:= Matrix[a MatrixToList[b]]

  Power[a_Matrix, b_] ^:= Matrix[Power[MatrixToList[a], b]];


  (* Matrix Algebra *)

  Dot[a_Matrix, b_Matrix] ^:= Matrix[Dot[MatrixToList[a], MatrixToList[b]]];

  Transpose[a_Matrix] ^:= Matrix[Transpose[MatrixToList[a]]];

  Conjugate[a_Matrix] ^:= Matrix[Conjugate[MatrixToList[a]]];

  Inverse[a_Matrix] ^:= Matrix[Inverse[MatrixToList[a]]];

  Det[a_Matrix] ^:= Det[MatrixToList[a]];
  Det[a_Matrix, option_] ^:= Det[MatrixToList[a], option];

  Tr[a_Matrix] ^:= Tr[MatrixToList[a]];
  Tr[a_Matrix, f_] ^:= Tr[MatrixToList[a], f];
  Tr[a_Matrix, f_, n_] ^:= Tr[MatrixToList[a], f, n];


  (* Linear Algebra *)

  Eigenvalues[a_Matrix] ^:= Eigenvalues[MatrixToList[a]];
  Eigenvalues[a_Matrix, b_Matrix] ^:= Eigenvalues[{MatrixToList[a], MatrixToList[b]}];
  Eigenvalues[a_Matrix, k_] ^:= Eigenvalues[MatrixToList[a], k];

  Eigenvectors[a_Matrix] ^:= Eigenvectors[MatrixToList[a]];
  Eigenvectors[a_Matrix, b_Matrix] ^:= Eigenvectors[{MatrixToList[a], MatrixToList[b]}];
  Eigenvectors[a_Matrix, k_] ^:= Eigenvectors[MatrixToList[a], k];

  Eigensystem[a_Matrix] ^:= Eigensystem[MatrixToList[a]];
  Eigensystem[a_Matrix, b_Matrix] ^:= Eigensystem[{MatrixToList[a], MatrixToList[b]}];
  Eigensystem[a_Matrix, k_] ^:= Eigensystem[MatrixToList[a], k];

  CharacteristicPolynomial[a_Matrix, x_] ^:= CharacteristicPolynomial[MatrixToList[a], x];

  LinearSolve[a_Matrix, b_Matrix] ^:= Matrix[LinearSolve[MatrixToList[a], MatrixToList[b]]];

  NullSpace[a_Matrix] ^:= Matrix[NullSpace[MatrixToList[a]]];

  MatrixRank[a_Matrix] ^:= MatrixRank[MatrixToList[a]];

  RowReduce[a_Matrix] ^:= Matrix[RowReduce[MatrixToList[a]]];

  Minors[a_Matrix] ^:= Matrix[Minors[MatrixToList[a]]];
  Minors[a_Matrix, k_] ^:= Matrix[Minors[MatrixToList[a], k]];

  MatrixPower[a_Matrix, n_] ^:= Matrix[MatrixPower[MatrixToList[a], n]];

  MatrixExp[a_Matrix] ^:= Matrix[MatrixExp[MatrixToList[a]]];

  (* Outer[f_, a_Matrix] ^:= MatrixExp[MatrixToList[a]]; *)

  Norm[a_Matrix] ^:= Norm[MatrixToList[a]];
  Norm[a_Matrix, p_] ^:= Norm[MatrixToList[a], p];

  SingularValueList[a_Matrix] ^:= SingularValueList[MatrixToList[a]];
  SingularValueList[a_Matrix, b_Matrix] ^:= SingularValueList[{MatrixToList[a], MatrixToList[b]}];
  SingularValueList[a_Matrix, k_] ^:= SingularValueList[MatrixToList[a], k];

  SingularValueDecomposition[a_Matrix] ^:= Map[Matrix, SingularValueDecomposition[MatrixToList[a]]];
  SingularValueDecomposition[a_Matrix, b_Matrix] ^:= Map[Matrix, SingularValueDecomposition[{MatrixToList[a], MatrixToList[b]}] ];
  SingularValueDecomposition[a_Matrix, k_] ^:= Map[Matrix, SingularValueDecomposition[MatrixToList[a], k] ];

  PseudoInverse[a_Matrix] ^:= PseudoInverse[MatrixToList[a]];

  QRDecomposition[a_Matrix] ^:= Map[Matrix, QRDecomposition[MatrixToList[a]]];

  LUDecomposition[a_Matrix] ^:= MapAt[Matrix, LUDecomposition[MatrixToList[a]], {1}];

  CholeskyDecomposition[a_Matrix] ^:= Matrix[CholeskyDecomposition[MatrixToList[a]]];

  SchurDecomposition[a_Matrix] ^:= Map[Matrix, SchurDecomposition[MatrixToList[a]]];
  SchurDecomposition[a_Matrix, b_Matrix] ^:= Map[Matrix, SchurDecomposition[{MatrixToList[a], MatrixToList[b]}]];

  JordanDecomposition[a_Matrix] ^:= Map[Matrix, JordanDecomposition[MatrixToList[a]]];

End[];

EndPackage[];
