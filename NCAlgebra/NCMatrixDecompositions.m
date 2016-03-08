(* :Title: 	MatrixDecompositions.m *)

(* :Authors: 	Mauricio C. de Oliveira and Burack Guven *)

(* :Context: 	MatrixDecompositions` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCMatrixDecompositions`",
              "MatrixDecompositions`",
              "NCMatMult`",
              "NonCommutativeMultiply`"];

Clear[NCLUPartialPivoting];
NCLUPartialPivoting::usage="";

Clear[NCLUCompletePivoting];
NCLUCompletePivoting::usage="";

Clear[NCDivideBy];
NCDivideBy::usage="";

Clear[NCLUDecompositionWithCompletePivoting];
NCLUDecompositionWithCompletePivoting::usage="";

Options[NCLUDecompositionWithCompletePivoting] = {
  ZeroTest -> PossibleZeroQ,
  Pivoting -> NCLUCompletePivoting,
  DivideBy -> NCDivideBy,
  Dot -> MatMult
};

Begin[ "`Private`" ]

  Clear[leafCount];
  leafCount[0] := -Infinity;
  leafCount[x_?NumberQ] := Abs[x];
  leafCount[x_] := -LeafCount[x];

  NCLUPartialPivoting[mat_?MatrixQ] := NCPartialPivoting[mat[[All,1]]];

  NCPartialPivoting[vec_List] :=
    Part[Ordering[Map[leafCount, vec], 1, Greater], 1];
  
  NCLUCompletePivoting[A_?MatrixQ] := Module[
    {minCol, minRow},
  
    minCol = Flatten[Map[NCPartialPivoting, A]];
    (* Print[minCol]; *)

    minRow = NCPartialPivoting[Apply[Part[A,##]&, 
                                     MapIndexed[{Part[#2,1],#1}&, minCol], 2]];
    (* Print[minRow]; *)

    Return[{minRow, minCol[[minRow]]}];

  ];
  
  NCDivideBy[x_, y_] := Map[NonCommutativeMultiply[#, inv[y]]&, x];

  NCLUDecompositionWithCompletePivoting[AA_?MatrixQ, 
                                        opts:OptionsPattern[{}]] := Module[
    {options},
                                            
    (* process options *)
    options = Flatten[{opts}];

    zeroTest = ZeroTest
           /. options 
           /. Options[NCLUDecompositionWithCompletePivoting, ZeroTest];

    pivoting = Pivoting
           /. options
 	   /. Options[NCLUDecompositionWithCompletePivoting, Pivoting];
    
    divideBy = DivideBy
           /. options
  	   /. Options[NCLUDecompositionWithCompletePivoting, DivideBy];

    dot = Dot
           /. options
 	   /. Options[NCLUDecompositionWithCompletePivoting, Dot];

    LUDecompositionWithCompletePivoting[AA, ZeroTest -> zeroTest, 
                                        Pivoting -> pivoting,
                                        DivideBy -> divideBy,
                                        Dot -> dot]
                                            
 ]; 
  
End[]

EndPackage[]
