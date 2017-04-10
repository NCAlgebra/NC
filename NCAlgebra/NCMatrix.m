(* :Title: NCMatrix.m *)

(* :Author: Mauricio C. de Oliveira *)

(* :Context: NCMatrix` *)

(* :Sumary: *)

(* :Alias: *)

(* :Warnings: *)

(* :History:
   :06/01/2004: First Version
*)

BeginPackage[ 
	        "NCMatrix`",
	        "Matrix`",
	        "NCDot`",
	        "NCReplace`",
(*              "NCCollectOnVariables`", *)
                "NCCollect`",
                "NonCommutativeMultiply`"
];

Clear[NCMatrix, MatrixExpand]

NCMatrix::usage = "NCAlgebra support for Matrix.";

Begin["`Private`"]; 

  MatrixEntryDimensions[(a_:1)*b_NonCommutativeMultiply] :=
      Apply[MatrixProductDimensions,Map[MatrixEntryDimensions,Apply[List,b]]];

  NonCommutativeMultiply`CommutativeQ[x_Matrix] ^:= False;

  ExpandExpression[expr_Matrix] := Map[Expand, expr];
  ExpandExpression[expr_List] := Map[Expand, expr];
  ExpandExpression[expr_] := Expand[expr];

  MatrixExpand[expr_] := 
    ExpandExpression[ NCReplaceRepeated[expr, {
        NonCommutativeMultiply[b_Matrix, c_Matrix] :>
             Matrix[NCDot[MatrixToList[b],MatrixToList[c]]],
        NonCommutativeMultiply[b_Matrix, c_] :>
             Map[NonCommutativeMultiply[#, c]&, b, {2}],
        NonCommutativeMultiply[b_, c_Matrix] :>
             Map[NonCommutativeMultiply[b, #]&, c, {2}]
    }]];

  tp[x_Matrix] ^:= Transpose[Map[tp,x,{2}]];

  aj[x_Matrix] ^:= Transpose[Map[aj,x,{2}]];

  co[x_Matrix] ^:= Map[co,x,{2}];

  inv[x_Matrix] ^:= Matrix[NCDot`NCInverse[MatrixToList[x]]]

  NCCollect`NCCollect[x_Matrix,varlist_] ^:= Map[(NCCollect`NCCollect[#,varlist])&,x,{2}]

  (*
  Matrix /: NCCollectOnVariables[exp_Matrix, knowns_List, options___] :=
     Map[(NCCollectOnVariables[#,knowns,options])&,exp,{2}];
     *)

  (* Products inside Matrix are expanded in replace *)

  (* ArrayFlatten *)

  (*
  ArrayFlatten[a_Matrix] ^:= Matrix[ArrayFlatten[MatrixToList[NonCommutativeMultiply`ExpandNonCommutativeMultiply[a],Infinity]]];
  *)

End[];

EndPackage[];
