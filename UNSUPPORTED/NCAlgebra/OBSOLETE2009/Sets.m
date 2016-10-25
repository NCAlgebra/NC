BeginPackage["Sets`","Grabs`","Errors`"];

Clear[SubsetQ];

SubsetQ::usage = 
      "SubsetQ[A,B] returns true if A is a subset of B and \
       False otherwise.";

Clear[CartesianProduct];

CartesianProduct::usage = 
     "CartesianProduct[aList,bList,...] gives a list whose elements \
      are of the for CartesianTuple[...] and have n arguments where \
      n is the number of lists. This is the mathematical cartesian \
      product.";

Clear[CartesianTuple];

CartesianTuple::usage = 
     "See CartesianProduct";

Begin["`Private`"];
              
SubsetQ[A_List,B_List] := Length[Complement[A,B]]==0; 

SubsetQ[x___] := BadCall["SubsetQ",x];

CartesianProduct[x___List] := 
    Flatten[Apply[Outer,{Sets`CartesianTuple,x}],2];

End[];
EndPackage[]
