(* :Title: 	BlockMatrix.m *)

(* :Author: 	Mauricio C. de Oliveira *)

(* :Context: 	BlockMatrix` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "BlockMatrix`" ]

Clear[BlockMatrixDimensions];
BlockMatrixDimensions::usage = "BlockMatrixDimensions[m] return the block dimensions on a two dimmensional list.";

Clear[BlockMatrixPartition];
BlockMatrixPartition::usage = "BlockMatrixPartition[m, dims] partitions matrix 'm' into.";

Clear[BlockMatrixOp];
BlockMatrixOp::usage = "BlockMatrixOp[m, op] apply 'op' on 'm'. If 'm' is a block matrix it is first converted into a contiguous matrix.";

Clear[BlockMatrixTranspose];
BlockMatrixTranspose::usage = "BlockMatrixTranspose[a] gives the partitioned block matrix corresponding to Transpose[a].";

Clear[BlockMatrixDot];
BlockMatrixDot::usage = "BlockMatrixDot[a, b] gives the partitioned block matrix corresponding to Dot[a, b].";

Clear[BlockMatrixFlatten];
BlockMatrixFlatten::usage = "BlockMatrixDot[a, b] gives the partitioned block matrix corresponding to Dot[a, b].";

Clear[BlockMatrixTr];
BlockMatrixTr::usage = "BlockMatrixTr[a, op] gives the partitioned block matrix corresponding to Tr[a, op].";

Clear[BlockMatrixFrobeniusInner];
BlockMatrixFrobeniusInner::usage = "Yet to come.";

Clear[BlockMatrixFrobeniusNorm];
BlockMatrixFrobeniusNorm::usage = "Yet to come.";

Begin[ "`Private`" ]


(* Block Dimensions *)

BlockMatrixDimensions[x_List] := {
  Map[Part[Dimensions[#], 1]&, Part[x, All, 1] ],
  Map[Part[Dimensions[#], 2]&, Part[x, 1, All] ]
};


(* Block Matrix Op *)

BlockMatrixOp[x_?MatrixQ, op_, option_:(Partition -> False)] := op[x];
BlockMatrixOp[x_List, op_, option_:(Partition -> False)] := Module[
  { result },
  
  (* Compute result of the operation *)
  result = op[ArrayFlatten[x]];

  If[ Partition /. option, 
    result = BlockMatrixPartition[result, BlockMatrixDimensions[x]];
  ];

  Return[ result ];

  ];


(* Block Partition *)

BlockMatrixPartition[x_, m_List] := BlockMatrixPartition[x, {m, m}];
BlockMatrixPartition[x_?MatrixQ, {m_List, n_List}] := Module[
  { start, end },

  (* Determine start points *)
  start = Outer[List, Drop[FoldList[Plus, 0, m], -1] + 1, Drop[FoldList[Plus, 0, n], -1] + 1];

  (* Determine end points *)
  end = start + Outer[List, m, n] - 1;

  Return[
    MapThread[Apply[Take[x,#1,#2]&,Transpose[{#1,#2}]]&, {start, end}, 2]
  ]

  ];


(* Block Matrix Transpose *)

BlockMatrixTranspose[a_List] := Transpose[Map[Transpose, a, {2}]];


(* Block Matrix Inner *)

BlockMatrixInner[f_:Dot, a_List, b_List, g_:Plus] := 
  Inner[f, Apply[Matrix, a, {2}], Apply[Matrix, b, {2}], g] /. {Matrix -> List}


(* Block Matrix Dot *)

BlockMatrixDot[a_List, b_List] := 
  BlockMatrixInner[a, b];
BlockMatrixDot[a__List] := 
  Fold[BlockMatrixDot, First[{a}], Rest[{a}]];


(* Block Matrix Flatten *)

BlockMatrixFlatten[a_?MatrixQ] := Flatten[a];
BlockMatrixFlatten[a_List] := Apply[Join, a]


(* Block Matrix Trace *)

BlockMatrixTr[a_?MatrixQ, op_:Plus] := Tr[a, op];
BlockMatrixTr[a_List, op_:Plus] := Tr[Map[Tr[#, op]&, a, {2}], op]

(* Block Matrix Frobenius *)

BlockMatrixFrobeniusInner[a_List,b_List] := Apply[Plus, Flatten[a * b]];

(* Block Matrix Frobenius Norm *)

BlockMatrixFrobeniusNorm[a_List] := Sqrt[BlockMatrixFrobeniusInner[a,a]];

End[]

EndPackage[]
