SameZeros[a_,A_,similarity_] := 
       SamePoles[Cross[a],Cross[A],similarity];

SamePoles[a_,A_,similarity_] := 
    AppendTo[NCSetRelations[{Inv,similarity}], 
             similarity**a-A**similarity];
