(* :Title: 	NCMatrixDecompositions.m *)

(* :Authors: 	Mauricio C. de Oliveira *)

(* :Context: 	MatrixDecompositions` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCMatrixDecompositions`",
              "MatrixDecompositions`",
              "NCMatMult`",
              "NonCommutativeMultiply`"];

Options[NCMatrixDecompositions] = {
  ZeroTest -> PossibleZeroQ,
  DivideBy -> NCDivideBy,
  Dot -> MatMult
};

Clear[NCLUPartialPivoting];
NCLUPartialPivoting::usage="";

Clear[NCLUCompletePivoting];
NCLUCompletePivoting::usage="";

Clear[NCDivideBy];
NCDivideBy::usage="";

Clear[NCLUDecompositionWithCompletePivoting];
NCLUDecompositionWithCompletePivoting::usage="";

Options[NCLUDecompositionWithPartialPivoting] = {
  Pivoting -> NCLUPartialPivoting
};

Options[NCLUDecompositionWithCompletePivoting] = {
  Pivoting -> NCLUCompletePivoting
};

Begin[ "`Private`" ]

  (* NC DivideBy *)
  NCDivideBy[x_, y_] := Map[NonCommutativeMultiply[#, inv[y]]&, x];

  (* NC leaf count *)
  Clear[NCLeafCount];
  NCLeafCount[x_List] := Map[NCLeafCount, x];
  
  NCLeafCount[0] := -Infinity;
  NCLeafCount[x_?NumberQ] := Abs[x];
  NCLeafCount[x_] := -LeafCount[x];

  (* partial pivoting *)
  NCLUPartialPivoting[mat_?MatrixQ, f_:NCLeafCount] := 
    NCLUPartialPivoting[mat[[All,1]], f];

  NCLUPartialPivoting[vec_List, f_:NCLeafCount] :=
    Part[Ordering[f[vec], 1, Greater], 1];
  
  (* complete pivoting *)
  NCLUCompletePivoting[A_?MatrixQ, f_:NCLeafCount] := Module[
    {minCol, minRow},
  
    minCol = Flatten[Map[NCLUPartialPivoting[#,f]&, A]];
    (* Print[minCol]; *)

    minRow = NCLUPartialPivoting[Apply[Part[A,##]&, 
                                       MapIndexed[{Part[#2,1],#1}&, minCol]
                                       , 2], f];
    (* Print[minRow]; *)

    Return[{minRow, minCol[[minRow]]}];

  ];
  
  NCLUDecompositionWithPartialPivoting[AA_?MatrixQ, 
                                       opts:OptionsPattern[{}]] := Module[
    {options},
                                            
    (* process options *)
    options = Flatten[{opts}];

    zeroTest = ZeroTest
           /. options 
           /. Options[NCMatrixDecompositions, ZeroTest];

    pivoting = Pivoting
           /. options
 	   /. Options[NCLUDecompositionWithPartialPivoting, Pivoting];
    
    divideBy = DivideBy
           /. options
  	   /. Options[NCMatrixDecompositions, DivideBy];

    dot = Dot
           /. options
 	   /. Options[NCMatrixDecompositions, Dot];

    LUDecompositionWithPartialPivoting[AA, 
                                       ZeroTest -> zeroTest, 
                                       Pivoting -> pivoting,
                                       DivideBy -> divideBy,
                                       Dot -> dot]
                                            
 ]; 

  NCLUDecompositionWithCompletePivoting[AA_?MatrixQ, 
                                        opts:OptionsPattern[{}]] := Module[
    {options},
                                            
    (* process options *)
    options = Flatten[{opts}];

    zeroTest = ZeroTest
           /. options 
           /. Options[NCMatrixDecompositions, ZeroTest];

    pivoting = Pivoting
           /. options
 	   /. Options[NCLUDecompositionWithCompletePivoting, Pivoting];
    
    divideBy = DivideBy
           /. options
  	   /. Options[NCMatrixDecompositions, DivideBy];

    dot = Dot
           /. options
 	   /. Options[NCMatrixDecompositions, Dot];

    LUDecompositionWithCompletePivoting[AA, 
                                        ZeroTest -> zeroTest, 
                                        Pivoting -> pivoting,
                                        DivideBy -> divideBy,
                                        Dot -> dot]
                                            
 ]; 
  
End[]

EndPackage[]
