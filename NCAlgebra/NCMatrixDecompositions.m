(* :Title: 	NCMatrixDecompositions.m *)

(* :Authors: 	mauricio *)

(* :Context: 	MatrixDecompositions` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCMatrixDecompositions`",
              "MatrixDecompositions`",
              "NCSelfAdjoint`",
              "NCDot`",
              "NCUtil`",
              "NonCommutativeMultiply`"];

Clear[NCLUDecompositionWithPartialPivoting,
      NCLUDecompositionWithCompletePivoting,
      NCLDLDecomposition,
      NCUpperTriangularSolve,
      NCLowerTriangularSolve,
      NCLUInverse,
      NCInverse,
      NCLUPartialPivoting,
      NCLUCompletePivoting,
      NCLeftDivide,
      NCRightDivide];

Get["NCMatrixDecompositions.usage"];

Options[NCMatrixDecompositions] = {
  ZeroTest -> PossibleZeroQ,
  LeftDivide -> NCLeftDivide,
  RightDivide -> NCRightDivide,
  Dot -> NCDot,
  SelfAdjointMatrixQ -> NCSelfAdjointQ
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
  Inverse -> NCLUInverse
};

Begin[ "`Private`" ]

  (* NCInverse *)
  NCInverse[x_?MatrixQ] := NCLUInverse[x];
  NCInverse[x_] := inv[x];
  
  (* NC Divide *)
  NCRightDivide[x_SparseArray, y_] := Map[NonCommutativeMultiply[#, inv[y]]&, x];
  NCRightDivide[x_List, y_] := Map[NonCommutativeMultiply[#, inv[y]]&, x];
  
  NCLeftDivide[x_, y_SparseArray] := Map[NonCommutativeMultiply[inv[x], #]&, y];
  NCLeftDivide[x_, y_List] := Map[NonCommutativeMultiply[inv[x], #]&, y];
  
  (* partial pivoting *)
  NCLUPartialPivoting[mat_?MatrixQ, f_:NCLeafCount] := 
    NCLUPartialPivoting[mat[[All,1]], f];

  NCLUPartialPivoting[vec_SparseArray, f_:NCLeafCount] :=
    NCLUPartialPivoting[Normal[vec], f];
   
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
    
    leftDivide = LeftDivide
  	   /. Options[NCMatrixDecompositions, LeftDivide];

    rightDivide = RightDivide
  	   /. Options[NCMatrixDecompositions, RightDivide];
                                           
    dot = Dot
 	   /. Options[NCMatrixDecompositions, Dot];

    LUDecompositionWithPartialPivoting[mat, 
                                       ZeroTest -> zeroTest, 
                                       Pivoting -> pivoting,
                                       LeftDivide -> leftDivide,
                                       RightDivide -> rightDivide,
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
    
    leftDivide = LeftDivide
  	   /. Options[NCMatrixDecompositions, LeftDivide];

    rightDivide = RightDivide
  	   /. Options[NCMatrixDecompositions, RightDivide];
                                            
    dot = Dot
 	   /. Options[NCMatrixDecompositions, Dot];

    LUDecompositionWithCompletePivoting[mat, 
                                        ZeroTest -> zeroTest, 
                                        Pivoting -> pivoting,
                                        LeftDivide -> leftDivide,
                                        RightDivide -> rightDivide,
                                        Dot -> dot]
                                            
  ]; 

  NCLDLDecomposition[mat_?MatrixQ, opts:OptionsPattern[{}]] := Module[
    {options, zeroTest, partialPivoting, completePivoting, 
     leftDivide, rightDivide, dot, inverse, selfAdjointQ},

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

    leftDivide = LeftDivide
  	   /. Options[NCMatrixDecompositions, LeftDivide];

    rightDivide = RightDivide
  	   /. Options[NCMatrixDecompositions, RightDivide];

    dot = Dot
 	   /. Options[NCMatrixDecompositions, Dot];

    inverse = Inverse
           /. options
 	   /. Options[NCLDLDecomposition, Inverse];

    selfAdjointQ = SelfAdjointMatrixQ
	    /. options
	    /. Options[NCMatrixDecompositions, SelfAdjointMatrixQ];

    LDLDecomposition[mat, 
                     ZeroTest -> zeroTest, 
                     PartialPivoting -> partialPivoting,
                     CompletePivoting -> completePivoting,
                     LeftDivide -> leftDivide,
                     RightDivide -> rightDivide,
                     Dot -> dot,
                     Inverse -> inverse,
                     SelfAdjointMatrixQ -> selfAdjointQ]
                                            
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
                         LeftDivide -> NCLeftDivide,
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
                         LeftDivide -> NCLeftDivide,
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
        Message[MatrixDecompositions::Square]; 
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
