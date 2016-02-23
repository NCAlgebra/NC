Clear[MakeMatix];

MakeMatrix::usage =
     "MakeMatrix[numberOfRows,numberOfCols,aSymbol] creates a \
      matrix with the indicated number of rows and columns,
      the entries of the matrix are filled with \
      aSymbol[rowNumber,colNumber]. \
      MakeMatrix[numberOfRows,numberOfColumns] is the same \
      as MakeMatrix[numberOfRows,numberOfColumns,ToString[Unique[]]];";

Clear[MakeLeftMatrix];

MakeLeftMatrix::usage =
     "MakeLeftMatrix[aMatrix,aSymbol] creates a matrix whose \
      dimensions are the same as the dimensions of tp[aMatrix] \
      and returns a pair {left,relations} where left is the \
      generated matrix and relations is a list of expressions \
      which represent the conditions for left to be a left \
      inverse of aMatrix.";

Clear[MakeLeftInverse];

MakeLeftInverse::usage =
     "MakeLeftInverse is similar to MakeLeftMatrix, except that \
      it also invokes Mora's algorithm to round out the relations. \
      MakeLeftInverse[aMatrix,aSymbol,aNumber] creates a matrix whose \
      dimensions are the same as the dimensions of tp[aMatrix] \
      and returns a pair {left,relations} where left is the \
      generated matrix and relations is a list of expressions \
      which represent the conditions for left to be a left \
      inverse of aMatrix. The relations are those generated \
      by applying the relations from MakeLeftInverse to \
      NCMakeGBOld while looping at most aNumber of times. \
      MakeLeftInverse[aMatrix,aSymbol] is the same as \
      MakeLeftInverse[aMatrix,aSymbol,4].";


MakeMatrix[nrows_?NumberQ,ncols_?NumberQ] :=
     MakeMatrix[nrows,ncols,ToString[Unique[]]];

MakeMatrix[nrows_?NumberQ,ncols_?NumberQ,name_Symbol] :=
Module[{mat,variables},
     mat = Table[name[i,j],{i,1,ncols},{j,1,nrows}];
     variables = Flatten[mat];
     Apply[SetNonCommutative,variables];
     Map[AddToMonomialOrder,variables];
     Return[mat];
];

MakeLeftMatrix[mat_?MatrixQ,name_Symbol] :=
Module[{dim,left,result,num},
     dim = Dimensions[mat];
     left = MakeMatrix[dim[[2]],dim[[1]],name];
     result = MatMult[left,mat];
     num = Length[result];
     result = result - IdentityMatrix[num];
     result = Flatten[result];
     Return[{left,result}]
];

MakeLeftInverse[mat_?MatrixQ,name_Symbol] := 
        MakeLeftInverse[mat,name,4];

MakeLeftInverse[mat_?MatrixQ,name_Symbol,number_?NumberQ] :=
Module[{temp,result,left},
   {left,temp} = MakeLeftMatrix[mat,name];
   result = NCMakeGBOld[temp,NumberOfIterations->number
                               ,CleanUpBasisOld->True];
   result = result[[2]];
   left = left//.result;
   Return[{left,result}]
];
