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

Clear[NCLeafCount];
NCLeafCount::usage="";

Clear[NCLUPartialPivoting];
NCLUPartialPivoting::usage="";

Clear[NCLUCompletePivoting];
NCLUCompletePivoting::usage="";

Clear[NCRightDivideBy];
NCRightDivideBy::usage="";

Clear[NCLeftDivideBy];
NCLeftDivideBy::usage="";

Clear[NCLUDecompositionWithPartialPivoting];
NCLUDecompositionWithPartialPivoting::usage = "";

Clear[NCLUDecompositionWithCompletePivoting];
NCLUDecompositionWithCompletePivoting::usage = "";

Clear[NCLDLDecomposition];
NCLDLDecomposition::usage = "";

Clear[NCUpperTriangularSolve];
NCUpperTriangularSolve::usage="";

Clear[NCLowerTriangularSolve];
NCLowerTriangularSolve::usage="";

Clear[NCLUInverse];
NCLUInverse::usage = "";

Options[NCMatrixDecompositions] = {
  ZeroTest -> PossibleZeroQ,
  DivideBy -> NCRightDivideBy,
  Dot -> MatMult
};

Options[NCLUDecompositionWithPartialPivoting] = {
  Pivoting -> NCLUPartialPivoting
};

Options[NCLUDecompositionWithCompletePivoting] = {
  Pivoting -> NCLUCompletePivoting
};

Options[NCLDLDecomposition] = {
  PartialPivoting -> NCLUPartialPivoting,
  CompletePivoting -> NCLUCompletePivoting,
  Transpose -> (Map[tp, #]&),
  Inverse -> NCLUInverse
};

Begin[ "`Private`" ]

  (* NC DivideBy *)
  NCRightDivideBy[x_, y_] := Map[NonCommutativeMultiply[#, inv[y]]&, x];
  NCLeftDivideBy[x_, y_] := Map[NonCommutativeMultiply[inv[y], #]&, x, {1}];

  (* NC leaf count *)
  NCLeafCount[x_List] := Map[NCLeafCount, x];
  
  NCLeafCount[0] := -Infinity;
  NCLeafCount[x_?NumberQ] := Abs[x];
  NCLeafCount[x_] := -LeafCount[x];

  (* partial pivoting *)
  NCLUPartialPivoting[mat_?MatrixQ, f_:NCLeafCount] := 
    NCLUPartialPivoting[mat[[All,1]], f];

  (* NOTE: GreaterEqual ensures that the first greatest element is 
           picked rather than the last *)
  NCLUPartialPivoting[vec_List, f_:NCLeafCount] :=
    Part[Ordering[f[vec], 1, GreaterEqual], 1];
  
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
  
  NCLUDecompositionWithPartialPivoting[mat_?MatrixQ, 
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
  	   /. Options[NCMatrixDecompositions, DivideBy];

    dot = Dot
 	   /. Options[NCMatrixDecompositions, Dot];

    LUDecompositionWithPartialPivoting[mat, 
                                       ZeroTest -> zeroTest, 
                                       Pivoting -> pivoting,
                                       DivideBy -> divideBy,
                                       Dot -> dot]
                                            
  ]; 

  NCLUDecompositionWithCompletePivoting[mat_?MatrixQ, 
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
  	   /. Options[NCMatrixDecompositions, DivideBy];

    dot = Dot
 	   /. Options[NCMatrixDecompositions, Dot];

    LUDecompositionWithCompletePivoting[mat, 
                                        ZeroTest -> zeroTest, 
                                        Pivoting -> pivoting,
                                        DivideBy -> divideBy,
                                        Dot -> dot]
                                            
  ]; 

  NCLDLDecomposition[mat_?MatrixQ, opts:OptionsPattern[{}]] := Module[
    {options, zeroTest, partialPivoting, completePivoting, 
     divideBy, dot, transpose, inverse},
                                            
    (* process options *)
    options = Flatten[{opts}];

    zeroTest = ZeroTest
           /. options 
           /. Options[NCMatrixDecompositions, ZeroTest];

    partialPivoting = PartialPivoting
           /. options
 	   /. Options[NCLDLDecomposition, PartialPivoting];
    
    completePivoting = CompletePivoting
           /. options
 	   /. Options[NCLDLDecomposition, CompletePivoting];

    divideBy = DivideBy
  	   /. Options[NCMatrixDecompositions, DivideBy];

    dot = Dot
 	   /. Options[NCMatrixDecompositions, Dot];

    transpose = Transpose
           /. options
 	   /. Options[NCLDLDecomposition, Transpose];

    inverse = Inverse
           /. options
 	   /. Options[NCLDLDecomposition, Inverse];

    LDLDecomposition[mat, 
                     ZeroTest -> zeroTest, 
                     PartialPivoting -> partialPivoting,
                     CompletePivoting -> completePivoting,
                     DivideBy -> divideBy,
                     Dot -> dot,
                     Inverse -> inverse,
                     Transpose -> transpose]
                                            
  ]; 
  
  NCLowerTriangularSolve[l_, b_, opts:OptionsPattern[{}]] := Module[
    {options},
                                            
    (* process options *)
    options = Flatten[{opts}];

    zeroTest = ZeroTest
           /. options 
           /. Options[NCMatrixDecompositions, ZeroTest];

    LowerTriangularSolve[l, b,
                         ZeroTest -> zeroTest, 
                         DivideBy -> NCLeftDivideBy,
                         Dot -> (Dot /. Options[NCMatrixDecompositions, Dot])]
                                            
  ]; 

  NCUpperTriangularSolve[l_, b_, opts:OptionsPattern[{}]] := Module[
    {options},
                                            
    (* process options *)
    options = Flatten[{opts}];

    zeroTest = ZeroTest
           /. options 
           /. Options[NCMatrixDecompositions, ZeroTest];

    UpperTriangularSolve[l, b,
                         ZeroTest -> zeroTest, 
                         DivideBy -> NCLeftDivideBy,
                         Dot -> (Dot /. Options[NCMatrixDecompositions, Dot])]
                                            
  ]; 

  NCLUInverse[A_?MatrixQ, opts:OptionsPattern[{}]] := Module[
     {lu,p,l,u,id,m,n},

     (* process options *)
     options = Flatten[{opts}];

     zeroTest = ZeroTest
            /. options 
            /. Options[NCMatrixDecompositions, ZeroTest];
      
     (* Solve *)
     {m,n} = Dimensions[A];
     id = IdentityMatrix[m];
     If[m != n
        , 
        Message[MatrixDecompositions::NotSquare]; 
        Return[id];
     ];
      
     {lu, p} = NCLUDecompositionWithPartialPivoting[A, ZeroTest -> zeroTest];
     {l, u} = GetLUMatrices[lu];

     (*
        Print["lu = ", Normal[lu]];
        Print["l = ", Normal[l]];
        Print["u = ", Normal[u]];
     *)

     Return[
       Check[
         NCUpperTriangularSolve[u, 
                                NCLowerTriangularSolve[l, id[[p]], 
                                                       ZeroTest -> zeroTest], 
                                ZeroTest -> zeroTest]
         ,
         id
         ,
         MatrixDecompositions::Singular
       ]
     ];

  ]; 

End[]

EndPackage[]
