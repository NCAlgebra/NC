(* :Title: 	MatrixVector.m *)

(* :Author: 	Mauricio C. de Oliveira *)

(* :Context: 	MatrixVector` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "MatrixVector`",
              "Kronecker`",
              "BlockMatrix`" ]

Clear[MatrixVectorDimensions];
MatrixVectorDimensions::usage = "MatrixVectorDimensions[m] return the dimensions of the vector 'm ' entries on a list.";

Clear[MatrixVectorBlockDimensions];
MatrixVectorBlockDimensions::usage = "MatrixVectorBlockDimensions[m] return the dimensions of the vector 'm' entries on a list including block partitioning.";

Clear[MatrixVectorFrobeniusInner];
MatrixVectorFrobeniusInner::usage = "MatrixVectorFrobeniusInner[a, b] computes the standard inner product of two vector of matrices 'a' and 'b', i.e., < a, b > = sum_i Tr[ Transpose[a_i] . b_i ].";

Clear[MatrixVectorFrobeniusNorm];
MatrixVectorFrobeniusNorm::usage = "MatrixVectorFrobeniusNorm[a] computes the norm of the vector of matrices 'a' induced by the standard inner product. MatrixVectorFrobeniusNorm[a] = Sqrt[MatrixVectorFrobeniusInner[a, a]].";

Clear[MatrixVectorTranspose];
MatrixVectorTranspose::usage = "MatrixVectorTranspose[a] computes the vector of matrices where each entry appears transposed.";

Clear[MatrixVectorSymmetrize];
MatrixVectorSymmetrize::usage = "MatrixVectorSymmetrize[a] compues (a + tp[a])/2";

Clear[MatrixVectorInverse];
MatrixVectorInverse::usage = "MatrixVectorInverse[a] computes the vector of matrices where each entry of 'a' appears inverted.";

Clear[MatrixVectorCholeskyInverse];
MatrixVectorCholeskyInverse::usage = "MatrixVectorInverse[a] computes the vector of matrices where each entry of 'a' appears inverted.";

Clear[MatrixVectorCholeskyDecomposition];
MatrixVectorCholeskyDecomposition::usage = "MatrixVectorInverse[a] computes the vector of matrices where each entry of 'a' appears inverted.";

Clear[MatrixVectorDot];
MatrixVectorDot::usage = "MatrixVectorDot[a, b] computes the vector of matrices resulting from multiplying each entry a_i by the corresponding b_i in the usual matrix sense.";

Clear[MatrixVectorEigenvalues];
MatrixVectorEigenvalues::usage = "MatrixVectorEigenvalues[a] computes eigenvalues of the vector of matrices 'a'.";

Clear[MatrixVectorOp];
MatrixVectorOp::usage = "MatrixVectorOp[m, op] apply 'op' on 'm'. If 'm' is a block matrix it is first converted into a contiguous matrix.";

Clear[MatrixVectorPartition];
MatrixVectorPartition::usage = "MatrixVectorPartition[x, {m,n}] partition 'x' as a block matrix of dimensions 'm' and 'n'.";

Clear[MatrixVectorBlockMatrix];
MatrixVectorBlockMatrix::usage = "MatrixVectorPartition[x, {m,n}] partition 'x' as a block matrix of dimensions 'm' and 'n'.";

Clear[MatrixVectorFlatten];
MatrixVectorFlatten::usage = "MatrixVectorDot[a, b] gives the partitioned block matrix corresponding to Dot[a, b].";

Clear[MatrixVectorTr];
MatrixVectorTr::usage = "MatrixVectorTr[a, op] gives the partitioned block matrix corresponding to Tr[a, op].";

Clear[MatrixVectorToVector];
MatrixVectorToVector::usage = "";

Clear[MatrixVectorReshape];
MatrixVectorReshape::usage = "MatrixVectorReshape[v, m] reshape vector v according to the block dimensions m.";

Begin[ "`Private`" ]

(* Matrix Vector Dimensions *)

MatrixVectorEntryDimensions[x_?MatrixQ] := Dimensions[x];
MatrixVectorEntryDimensions[x_List] := Apply[Plus,BlockMatrixDimensions[x],{1}];
MatrixVectorEntryDimensions[x_] := {1, 1};

MatrixVectorDimensions[x_] := Map[MatrixVectorEntryDimensions, x];


(* Matrix Vector Block Dimensions *)

MatrixVectorEntryBlockDimensions[x_?MatrixQ] := Dimensions[x];
MatrixVectorEntryBlockDimensions[x_List] := BlockMatrixDimensions[x];
MatrixVectorEntryBlockDimensions[x_] := {1, 1};

MatrixVectorBlockDimensions[x_] := Map[MatrixVectorEntryBlockDimensions, x];

(* Matrix Vector Frobenius *)

MatrixVectorFrobeniusInner[a_List, b_List] := Apply[Plus, Flatten[a * b]];


(* Matrix Vector Frobenius Norm *)

MatrixVectorFrobeniusNorm[a_List] := Sqrt[MatrixVectorFrobeniusInner[a,a]];

(* Matrix Vector Transpose *)

MatrixVectorEntryTranspose[a_?MatrixQ] := Transpose[a];
MatrixVectorEntryTranspose[a_List] := BlockMatrixTranspose[a];
MatrixVectorEntryTranspose[a_?NumberQ] := a;

MatrixVectorTranspose[x_] := Map[MatrixVectorEntryTranspose, x];
MatrixVectorSymmetrize[x_] := (x+MatrixVectorTranspose[x])/2;

(* Matrix Vector Cholesky Factorization *)

MatrixVectorEntryCholeskyDecomposition[a_?MatrixQ] := 
  CholeskyDecomposition[a];

MatrixVectorEntryCholeskyDecomposition[a_List] := 
  BlockMatrixPartition[ CholeskyDecomposition[ArrayFlatten[a]], 
                        BlockMatrixDimensions[a] ];

MatrixVectorEntryCholeskyDecomposition[a_?NumberQ] := Sqrt[a];

MatrixVectorCholeskyDecomposition[x_] :=
  Map[MatrixVectorEntryCholeskyDecomposition, x];

(* Matrix Vector Cholesky Inverse *)

CholeskyInverse[a_] :=
  LinearSolve[ a, 
               SparseArray[{i_,i_} -> 1., Dimensions[a]], 
               Method -> Cholesky ];

MatrixVectorEntryCholeskyInverse[a_?MatrixQ] := 
  CholeskyInverse[a];

MatrixVectorEntryCholeskyInverse[a_List] := 
  BlockMatrixPartition[ CholeskyInverse[ArrayFlatten[a]], 
                        BlockMatrixDimensions[a] ];

MatrixVectorEntryCholeskyInverse[a_?NumberQ] := 1/a;

MatrixVectorCholeskyInverse[x_] := 
  Map[MatrixVectorEntryCholeskyInverse, x];


(* Matrix Vector Inverse *)

MatrixVectorEntryInverse[a_?MatrixQ] := 
  Inverse[a];

MatrixVectorEntryInverse[a_List] := 
  BlockMatrixPartition[ Inverse[ArrayFlatten[a]], 
                        BlockMatrixDimensions[a] ];

MatrixVectorEntryInverse[a_?NumberQ] := 1/a;


MatrixVectorInverse[x_] := Map[MatrixVectorEntryInverse, x];


(* Matrix Vector Dot *)

MatrixVectorEntryDot[a__?MatrixQ] := Dot[a];
MatrixVectorEntryDot[a__List] := BlockMatrixDot[a];
MatrixVectorEntryDot[a__?NumberQ] := Times[a];

MatrixVectorDot[a__] := MapThread[MatrixVectorEntryDot,{a}];


(* Matrix Vector Eigenvalues *)

MatrixVectorEntryEigenvalues[a_?MatrixQ] := Eigenvalues[a];
MatrixVectorEntryEigenvalues[a_List] := Eigenvalues[ArrayFlatten[a]];
MatrixVectorEntryEigenvalues[a_?NumberQ] := a;

MatrixVectorEigenvalues[x_] := Map[MatrixVectorEntryEigenvalues, x];



(* Block Matrix Op *)

MatrixVectorEntryOp[x_?MatrixQ, op_, option_:(Partition -> False)] := op[x];
MatrixVectorEntryOp[x_List, op_, option_:(Partition -> False)] := Module[
  { result },
  
  (* Compute result of the operation *)
  result = op[MatrixVector[x]];

  If[ Partition /. option, 
    result = MatrixVectorPartition[result, MatrixVectorDimensions[x]];
  ];

  Return[ result ];

  ];


(* Block Partition *)

MatrixVectorEntryPartition[x_, {m_List, n_List}] := 
   BlockMatrixPartition[x, {m, n}];
MatrixVectorEntryPartition[x_, m_] := x;

MatrixVectorPartition[x_List, m_List] :=
  MapThread[MatrixVectorEntryPartition, {x, m}];

(* Block Matrix *) 
MatrixVectorEntryBlockMatrix[x_?MatrixQ] := x;
MatrixVectorEntryBlockMatrix[x_List] := ArrayFlatten[x];
MatrixVectorEntryBlockMatrix[x_] := x;

MatrixVectorBlockMatrix[x_List] :=
  Map[MatrixVectorEntryBlockMatrix, x];

(* Block Matrix Inner *)

MatrixVectorInner[f_:Times, a_?MatrixQ, b_?MatrixQ, g_:Plus] := 
  Inner[f, a, b, g];
MatrixVectorInner[f_:Dot, a_List, b_List, g_:Plus] := 
  Inner[f, Apply[Matrix, a, {2}], Apply[Matrix, b, {2}], g] /. {Matrix -> List}

(* Block Matrix Flatten *)

MatrixVectorFlatten[a_?MatrixQ] := Flatten[a];
MatrixVectorFlatten[a_List] := Apply[Join, a]

(* Block Matrix ToVector *)
MatrixVectorToVector[a_List] := Apply[Join, Map[Flatten, a, {1}]];

(* Block Matrix Trace *)

MatrixVectorTr[a_?MatrixQ, op_:Plus] := Tr[a, op];
MatrixVectorTr[a_List, op_:Plus] := Tr[Map[Tr[#, op]&, a, {2}], op]

(* Reshape Vector *)
MatrixVectorReshape[v_, dims_] := Module[
  { mdims, start, end, matrices },

  (* Determine vector dimensions *)
  mdims = Apply[Times, dims, 2];

  (* Determine start points *)
  start = Drop[FoldList[Plus, 0, mdims], -1] + 1;

  (* Determine end points *)
  end = start + mdims - 1;

  (*
    Print["mdims = ", mdims];
    Print["start = ", start];
    Print["end = ", end];
  *)

  matrices = MapThread[ToMatrix[#1,#2]&, 
      { MapThread[Take[v,{#1,#2}]&, {start, end}],
        Part[dims, All, 1] }];

  (* Print["matrices = ", matrices ]; *)

  (* Flatten one dimensional matrices *)

  (* 
   THIS HAS BEEN COMMENTED OUT. FOR CONSISTENCY WITH SOLVER!
   NEEDS MORE TESTING THOUGH
   matrices = matrices //. {a___,{{b_}},c___} -> {a,b,c}; 
   *)

  (* Print["matrices = ", matrices ]; *)

  Return[ matrices ];

  ];

End[]

EndPackage[]
