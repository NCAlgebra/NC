
(* ------------------------------------------------------------------ *)
(*    NCBlockPartition.m                                              *)
(* ------------------------------------------------------------------ *)

BeginPackage["BlockPartition`"];

ValueOf::usage =
     "ValueOf[ $1 ] returns the value of the block from the \
     temporary name assigned to by PartitionMatrix.";

BlockQ::usage = 
     "BlockQ[ symbol ] returns True if SetBlock[ symbol ] has been set \
     true, else it returns False.";

SetBlock::usage = 
     "SetBlock[ symbol ] returns {True} and designates BlockQ[ symbol ] \
     to be true.";

PartitionMatrix::usage = 
     "PartitionMatrix[ matrix, rownumber, columnnumber, entrylabel ] \
     will return a 2 X 2 matrix with the entries assigned to 'entrylabel' \
     variables.";

FormMatrix::usage = 
     "FormMatrix[PartitionMatrix[x, m, n]] returns x."


Begin["`Private`"];


ValueOf[x_] := x;

BlockQ[___] := False;

SetBlock[a__] :=
     (
          Function[
               x,
               BlockQ[x] =
                    True; BlockQ[x[___]] = True
          ] /@{a}
     );

PartitionMatrix[matr_, rownu_, colnu_] := 
     PartitionMatrix[matr, rownu, colnu, "$"];

PartitionMatrix[matr_, rownu_, colnu_, name_] :=  
     Block[{dims, NumberOfRows, NumberOfCols, i, j}, 
          dims = Dimensions[matr];
          NumberOfRows = dims[[1]];
          NumberOfCols = dims[[2]];
          UpperLeft    = Unique[name];
          UpperRight   = Unique[name];
          LowerLeft    = Unique[name];
          LowerRight   = Unique[name];
          UpperLeft2   = Unique["PartitionMatrix"];
          UpperRight2  = Unique["PartitionMatrix"];
          LowerLeft2   = Unique["PartitionMatrix"];
          LowerRight2  = Unique["PartitionMatrix"];
          Do[ 
               Do[
                    UpperLeft2[i, j] = matr[[i, j]], 
                    {i, rownu - 1}
               ], 
               {j, colnu - 1}
          ]; 
          Do[ 
               Do[
                    UpperRight2[i, j] = matr[[i, j + colnu - 1]],
                    {i, rownu - 1}
               ],
               {j, NumberOfCols - colnu + 1}
          ]; 
          Do[ 
               Do[
                    LowerLeft2[i, j] = matr[[i + rownu - 1, j]],
                    {i, NumberOfRows - rownu + 1}
               ],
               {j, colnu - 1}
          ]; 
          Do[ 
               Do[
                    LowerRight2[i, j] = matr[[i + rownu - 1, j + colnu - 1]],
                    {i, NumberOfRows - rownu + 1}
               ],
               {j, NumberOfCols - colnu + 1}
          ]; 
          size1 = rownu - 1;
          size2 = colnu - 1;
          ValueOf[UpperLeft] = Array[UpperLeft2, {size1, size2}];
          size1 = rownu - 1;
          size2 = NumberOfCols - colnu + 1;
          ValueOf[UpperRight] = Array[UpperRight2, {size1, size2}];
          size1 = NumberOfRows - rownu + 1;
          size2 = colnu - 1;
          ValueOf[LowerLeft] = Array[LowerLeft2, {size1, size2}];
          size1 = NumberOfRows - rownu + 1;
          size2 = NumberOfCols - colnu + 1;
          ValueOf[LowerRight] = Array[LowerRight2, {size1, size2}];
          SetBlock[UpperLeft];
          SetBlock[UpperRight];
          SetBlock[LowerLeft];
          SetBlock[LowerRight];
          Return[List[List[UpperLeft, UpperRight], List[LowerLeft, LowerRight]]]
     ]; 

FormMatrix[{{UpperLeft_, UpperRight_}, {LowerLeft_, LowerRight_}}] :=  
     Block[{rownu, colnu, NumberOfRows, NumberOfCols, i, j, matr}, 
          dims = Dimensions[ValueOf[UpperLeft]];
          rownu = dims[[1]]+1;
          colnu = dims[[2]]+1;
          NumberOfRows = rownu + Dimensions[ValueOf[LowerLeft]][[1]] - 1 ;
          NumberOfCols = colnu + Dimensions[ValueOf[UpperRight]][[2]] - 1 ;
          name = Unique[];
          matr = Array[name, {NumberOfRows, NumberOfCols}];
          Do[ 
               Do[
                    name[i, j] = ValueOf[UpperLeft][[i, j]],
                    {i, rownu - 1}
               ],
               {j, colnu - 1}
          ]; 
          Do[ 
               Do[
                    name[i, j + colnu - 1] = ValueOf[UpperRight][[i, j]],
                    {i, rownu - 1}
               ],
               {j, NumberOfCols - colnu + 1}
          ]; 
          Do[ 
               Do[
                    name[i + rownu - 1, j] = ValueOf[LowerLeft][[i, j]],
                    {i, NumberOfRows - rownu + 1}
               ],
               {j, colnu - 1}
          ]; 
          Do[ 
               Do[
                    name[i + rownu - 1, j + colnu - 1] = 
                         ValueOf[LowerRight][[i, j]],
                    {i, NumberOfRows - rownu + 1}
               ],
               {j, NumberOfCols - colnu + 1}
          ];
          Return[matr]
     ];


End[ ]

EndPackage[ ]

