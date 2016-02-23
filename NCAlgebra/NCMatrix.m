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
(*                "NCCollectOnVariables`", *)
                "NCCollect`",
                "NonCommutativeMultiply`"
];

Clear[NCMatrix]

NCMatrix::usage = "NCAlgebra support for Matrix.";

Begin["`Private`"]; 

MatrixEntryDimensions[(a_:1)*b_NonCommutativeMultiply] :=
    Apply[MatrixProductDimensions,Map[MatrixEntryDimensions,Apply[List,b]]];

NonCommutativeMultiply`CommutativeAllQ[x_Matrix] ^:= False;
NonCommutativeMultiply`CommutativeQ[x_Matrix] ^:= False;

NonCommutativeMultiply`ExpandNonCommutativeMultiply[expr_] := 
  Expand[ expr //. 
	{
		HoldPattern[NonCommutativeMultiply[a___, b_Plus, c___]] :>
		  (NonCommutativeMultiply[a, #, c]& /@ b),
		HoldPattern[NonCommutativeMultiply[a___, b_Matrix, c_Matrix, d___]] :>
		  NonCommutativeMultiply[a, 
 			Matrix[NCMatMult`MatMult[MatrixToList[b],MatrixToList[c]]], d],
		HoldPattern[NonCommutativeMultiply[a___, b_, c_Matrix, d___]] :>
		  NonCommutativeMultiply[a, 
		    Map[NonCommutativeMultiply[b, #]&, c, {2}], d],
		HoldPattern[NonCommutativeMultiply[a___, b_Matrix, c_, d___]] :>
		  NonCommutativeMultiply[a, 
		    Map[NonCommutativeMultiply[#, c]&, b, {2}], d]
	}
];

HoldPattern[NonCommutativeMultiply[a___, b_Matrix, c_Matrix, d___]] :=
  Check[NonCommutativeMultiply[a, 
    Matrix[NCMatMult`MatMult[MatrixToList[b],MatrixToList[c]]], d],$Failed] /; NumericMatrixQ[b] && NumericMatrixQ[c];

tp[x_Matrix] ^:= Transpose[Map[tp,x,{2}]];

aj[x_Matrix] ^:= Transpose[Map[aj,x,{2}]];

co[x_Matrix] ^:= Map[co,x,{2}];

inv[x_Matrix] ^:= Matrix[NCMatMult`NCInverse[MatrixToList[x]]]

NCCollect`NCCollect[x_Matrix,varlist_] ^:= Map[(NCCollect`NCCollect[#,varlist])&,x,{2}]

(*
Matrix /: NCCollectOnVariables[exp_Matrix, knowns_List, options___] :=
   Map[(NCCollectOnVariables[#,knowns,options])&,exp,{2}];
   *)

(* Products inside Matrix are expanded in replace *)

(* ArrayFlatten *)

ArrayFlatten[a_Matrix] ^:= Matrix[ArrayFlatten[MatrixToList[NonCommutativeMultiply`ExpandNonCommutativeMultiply[a],Infinity]]];


Clear[MMatrix]

Clear[MExpand]
MExpand[NonCommutativeMultiply[a___,b__Matrix,c___]] := NonCommutativeMultiply[a,MExpand[b],c];
Unprotect[ReplaceAll]
ReplaceAll[exp_, rule_, ExpandNonCommutativeMultiply->True] := 
  Module[{tmp},
    tmp = Replace[
       ReplaceAll[
         Replace[exp, Matrix->MMatrix, {1,Infinity}, Heads->True]
         , rule
       ]
       , Matrix->MMatrix, {1,Infinity}, Heads->True
    ];
    (* Print[tmp]; *)
    tmp = NonCommutativeMultiply`ExpandNonCommutativeMultiply[
      Replace[tmp, MMatrix->Matrix, {2,Infinity}, Heads->True]
    ];
    (* Print[tmp]; *)
    Replace[tmp, MMatrix->Matrix, 1, Heads->True]
  ];
Protect[ReplaceAll]
(*
NonCommutativeMultiply`ExpandNonCommutativeMultiply[c],d},e] /; !FreeQ[c,NonCommutativeMultiply] && (NonCommutativeMultiply`ExpandNonCommutativeMultiply[c] != c);
*)

End[];

EndPackage[];
