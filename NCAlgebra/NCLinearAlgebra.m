(* :Title: 	NCLinearAlgebra.m *)

(* :Author: 	Mauricio de Oliveira. *)

(* :Context: 	NCLinearAlgebra` *)

(* :Summary:    Make up for loss of `LinearAlgebra`MatrixManipulations in 
                MMA V9*)

(* :Alias: *)

(* :Warnings: *)

(* :History: 
   :3/13/13: Packaged (mauricio)
*)

(* TODO: Update NCAlgebra code to use modern MMA Matrix Manipulation *)

BeginPackage["NCLinearAlgebra`"];

Clear[NCTakeMatrix];
Clear[NCSubMatrix];
Clear[NCZeroMatrix];
Clear[NCBlockMatrix];
Clear[NCAppendRows];
Clear[NCAppendColumns];

Begin["`Private`"];

  NCTakeMatrix[matrix_, pos1_, pos2_] := 
    Apply[Take[matrix,##]&, Transpose[{pos1,pos2}]];

  NCSubMatrix[matrix_, pos_, dim_] := NCTakeMatrix[matrix, pos, pos + dim - 1];

  NCZeroMatrix[m_,n_] := ConstantArray[0, {m,n}];
  NCZeroMatrix[m_] := ConstantArray[0, {m,m}];

(* MAURICIO 07/28/2013: 
   Improved old NCAppendRows and NCAppendColumns that allowed for 
   only two arguments *) 

  NCAppendRows[a__] := Join[a,2];
  NCAppendColumns[a__] := Join[a];
  NCBlockMatrix[a_] := ArrayFlatten[a];

End[];

EndPackage[];

