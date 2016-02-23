BeginPackage["ArrayManager`","Errors`"];

Clear[AppendToArray];

AppendToArray::usage = 
     "AppendToArray[aSymbol,anElement] puts anElement at the \
      end of the array attached to the symbol aSymbol. Note \
      that Array2List[AppendToArray[x,y]] will return \
      Join[Array2List[x],{y}].";

Clear[InitializeArray];

InitializeArray::usage = 
     "InitializeArray[aSymbol] will attach an array to the \
      symbol aSymbol. Array2List[InitializeArray[aSymbol]] \
      will return {}.";

Clear[UnionArray];

UnionArray::usage = 
     "UnionArray[aSymbol] performs a union on the array attached \
      to the symbol aSymbol. \
      Array2List[UnionArray[List2Array[aSymbol,aList]]] will \
      return Union[aList]";

Clear[UnionListToArray];

UnionListToArray::usage = 
     "UnionListToArray[aSymbol,aList] is a more efficient \
      version of the combination \
      UnionArray[JoinListToArray[aSymbol,aList]].";

Clear[ListToArray];

ListToArray::usage = 
     "ListToArray[aSymbol,aList] puts the contents of aList into \
      the array attached to the symbol aSymbol.";

Clear[List2Array];

List2Array::usage = 
     "Use ListToArray, not List2Array. List2Array will be removed shortly.";

Clear[ArrayToList];

ArrayToList::usage = 
     "ArrayToList[aSymbol] outputs a list representation of the \
      array attached to the symbol aSymbol into a list.";

Clear[Array2List];

Array2List::usage = 
     "Use ArrayToList, not Array2List. Array2List will be removed shortly.";

Clear[JoinListToArray];

JoinListToArray::usage = 
     "JoinListToArray[aSymbol,aList] joins aList to the end \
      of the array attached to the symbol aSymbol. Note that  \
      Array2List[aSymbol,JoinListToArray[aSymbol,aList]] will \
      return Join[Array2List[aSymbol],aList].";

Clear[LengthArray];

LengthArray::usage = 
     "LengthArray[aSymbol] has the same effect as \
      Length[Array2List[aSymbol]]. If aSymbol[0] is not \
      a number (i.e., aSymbol is not an array, then \
      aSymbol is initialized and 0 is returned.";

Clear[PartArray];

PartArray::usage = 
     "PartArray[aSymbol_Symbol,n_Integer?Positive] has the \
      same effect as Array2List[aSymbol][[n]]";

Clear[PartIndirectArray];

PartIndirectArray::usage = 
     "PartIndirectArray[aSymbol_Symbol,n_Integer?Positive] has the \
      same effect as Apply[PartArray,PartArray[aSymbol,n]]";

Clear[SetArray];

SetArray::usage = 
     "SetArray[aSymbol,anotherSymbol] copies all of the \
      information from the array attached to the symbol \
      anotherSymbol to the array attached to the symbol \
      aSymbol.";

Clear[MapToArray];

MapToArray::usage = 
     "MapToArray[aFunction,aSymbol] \
      takes the array attached to the symbol aSymbol \
      and applies each aFunction to each element of the array.\
      The result is put back into the array aSymbol.";

Clear[MapToIndirectArray];

MapToIndirectArray::usage = 
     "MapToIndirectArray[aFunction,aSymbol] \
      takes indirect array attached to the symbol aSymbol \
      and applies each aFunction to each element of \
      the indirect array. The result is put back into the indirect\
      array aSymbol.";

Clear[MakeIndirectArray];

MakeIndirectArray::usage = 
     "MakeIndirectArray[aSymbol] returns a new symbol. \
      The new symbol will be an array and an indirect array \
      to the contents of the array aSymbol.";

Clear[IndirectArrayToList];

IndirectArrayToList::usage =
     "IndirectArrayToList[anIndirectArray] gives the contents \
      of the indirect array in the form of a list.";

Clear[ListToIndirectArray];

ListToIndirectArray::usage = 
     "ListToIndirectArray[aSymbol,aList] creates an \
      indirect array containing the contents of aList.";

Clear[IndirectArrayToArray];

IndirectArrayToArray::usage =
     "IndirectArrayToArray";

Clear[ReplaceArray];

ReplaceArray::usage = 
     "ReplaceArray[aSymbol,index,newdata]";

Clear[RemoveFromArray];

RemoveFromArray::usage =
     "RemoveFromArray[aSymbol,index]";

Begin["`Private`"];

AppendToArray[aSymbol_Symbol,anElement_] :=
Block[{},
    aSymbol[0]++;
    aSymbol[aSymbol[0]] = anElement;
    Return[anElement]
];

AppendToArray[x___] := BadCall["AppendToArray",x];

InitializeArray[aSymbol_Symbol] := 
Block[{},
      ToExpression[StringJoin["Clear[",
                              ToString[Format[aSymbol,InputForm]],
                              "]"]
      ];
      aSymbol[0] = 0;
      Return[aSymbol[0]]; 
];

InitializeArray[x___] := BadCall["InitializeArray",x];

UnionArray[aSymbol_Symbol] := 
     ListToArray[aSymbol,Union[ArrayToList[aSymbol]]];

UnionArray[x___] := BadCall["UnionArray",x];

UnionListToArray[aSymbol_Symbol,aList_List] :=
Block[{contents},
      contents = ArrayToList[aSymbol];
      Map[If[Not[MemberQ[contents,#]], AppendToArray[aSymbol,#]]&,
          aList];
      Return[aSymbol]
];

UnionListToArray[x___] := BadCall["UnionListToArray",x];

List2Array[x___] :=
    (
     Print["List2Array called from the context: ",$Context];
     Print["Please change to ListToArray."];
     ListToArray[x]
    );

ListToArray[aSymbol_Symbol,aList_List] := 
    (
     InitializeArray[aSymbol];
     Map[AppendToArray[aSymbol,#]&,aList];
     aSymbol
    );

ListToArray[x___] := BadCall["ListToArray",x];

Array2List[x___] :=
    (
     Print["Array2List called from the context: ",$Context];
     Print["Please change to ArrayToList."];
     ListToArray[x]
    );

ArrayToList[aSymbol_Symbol] := Table[aSymbol[j],{j,1,aSymbol[0]}];

ArrayToList[x___] := BadCall["ArrayToList",x];

JoinListToArray[aSymbol_Symbol,aList_List] := 
Block[{j},
   Do[ aSymbol[0]++;
       aSymbol[aSymbol[0]] = aList[[j]];
   ,{j,1,Length[aList]}
   ];
   Return[aSymbol]
];

JoinListToArray[x___] := BadCall["JoinListToArray",x];

LengthArray[aSymbol_Symbol] := 
Module[{result},
     result = aSymbol[0];
     If[Not[NumberQ[result]], result = 0;
                              IniitializeArray[aSymbol];
     ];
     Return[result]
];

LengthArray[x___] := BadCall["LengthArray",x];

PartArray[aSymbol_Symbol,n_Integer?Positive] :=  aSymbol[n];

PartArray[aSymbol_Symbol,n_Integer?Negative] :=  
                      aSymbol[aSymbol[0]+1+n];

PartArray[x___] := BadCall["PartArray",x];

ReplaceArray[aSymbol_Symbol,index_,newdata_] := aSymbol[index] = newdata;

RemoveFromArray[aSymbol_Symbol,index_] :=
    (
      If[Not[index===aSymbol[0]], aSymbol[index] = aSymbol[aSymbol[0]]];
      aSymbol[0] = aSymbol[0] - 1
    );

PartIndirectArray[aSymbol_Symbol,n_?NumberQ] :=
      Apply[PartArray,PartArray[aSymbol,n]];
    
PartIndirectArray[x___]  := BadCall["PartIndirectArray",x];

SetArray[aSymbol_Symbol,anotherSymbol_Symbol] :=
     ToExpression[StringJoin["DownValues[",
                             ToString[Format[aSymbol,InputForm]],
                             "] := ",
                             ToString[Format[
                     DownValues[anotherSymbol]/.anotherSymbol->aSymbol,
                                                        InputForm]]
                            ]
                 ];

SetArray[x___] := BadCall["SetArray",x];

MapToArray[aFunction_,aSymbol_Symbol] :=
Module[{len},
     len = aSymbol[0];
     Do[ aSymbol[j] = aFunction[aSymbol[j]];
     ,{j,1,len}];
     Return[aSymbol]
];

MapToArray[x___] := BadCall["MapToArray",x];

MapToIndirectArray[aFunction_,aSymbol_Symbol] :=
Module[{len},
     len = aSymbol[0];
     Do[ {theArray,theindex} = aSymbol[j];
         theArray[theindex] =  aFunction[theArray[theindex]]
     ,{j,1,len}];
     Return[aSymbol]
];

MapToIndirectArray[x___] := BadCall["MapToIndirectArray",x];

MakeIndirectArray[aSymbol_Symbol] :=
Module[{result},
     result = Unique["MkIndirect"];
     len = aSymbol[0];
     result[0] = len;
     Do[ result[j] = {aSymbol,j}
     ,{j,1,len}];
     Return[result]
];

MakeIndirectArray[x___] := BadCall["MakeIndirectArray",x];

IndirectArrayToList[anIndirectArray_Symbol] := 
Module[{len},
     len = anIndirectArray[0];
     If[Not[NumberQ[len]], Print["Severe error from IndirectArrayToList"];
                           Print[len," is not a number."];
     ];
     result = Table[anIndirectArray[j],{j,1,len}];
     result = Map[(Apply[#[[1]],{#[[2]]}])&,result];
     Return[result]
];

IndirectArrayToList[x___] := BadCall["IndirectArrayToList",x];

ListToIndirectArray[anIndirectArray_Symbol,aList_List] :=
Module[{temp},
     temp = Unique["ListToIndirectArray"];
     ListToArray[temp,aList];
     len = Length[aList];
     anIndirectArray[0] = len;
     Do[ anIndirectArray[j] = {temp,j};
     ,{j,1,len}];
     Return[anIndirectArray]
];

ListToIndirectArray[x___] := BadCall["ListToIndirectArray",x];

IndirectArrayToArray[aSymbol_Symbol] := MapToArray[pairToElement,aSymbol];

IndirectArrayToArray[x___] := BadCall["IndirectArrayToArray",x];

pairToElement[{f_,x_}] := f[x];

pairToElement[x___] := BadCall["pairToElement",x];

End[];
EndPackage[]
