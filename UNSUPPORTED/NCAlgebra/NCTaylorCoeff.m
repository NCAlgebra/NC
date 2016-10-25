(* :Title:      NCTaylorCoeff.m // Mathematica 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NCTaylorCoeff` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
   09/22/04    Mark Stankus adds packaging to stop contaminating the Global context
   01/??/99    Dells version which handles powers was installed
*)

BeginPackage["NCTaylorCoeff`","NonCommutativeMultiply`","Errors`"];

Clear[NCTermArrayMatrix];

NCTermArrayMatrix::usage =
  "NCTermArrayMatrix usage message not yet written.";

Clear[NCTermArray];

NCTermArray::usage =
     "NCTermArray[expr,aList,anArray] (where expr is an expression, \
      aList is a list of variables and anArray is a symbol)  creates \
      an array anArray whose contents represent the terms of expr \
      sorted by order. The variables anArray[\"variables\"], \
      anArray[\"types\"] and elements such as anArray[x**x,y] and \
      anArray [x**x**x,y**y] to hold the terms with 2 x\`s and \
      1 y and 3 x\'s and 2 y's, respectively (assuming that 
      aList = {x,y}). You can reconstruct expr from anArray via \
      NCReconstructFromTermArray[anArray].";

Clear[NCReconstructFromTermArray];

NCReconstructFromTermArray::usage =
     "NCTermArray[expr,aList,anArray]; \
      newexpr = NCReconstructFromTermArray[anArray]; \
      sets newexpr equal to expr.";

Clear[NCTermsOfDegree];

NCTermsOfDegree::usage = 
     "NCTermsOfDegree[expr,aList,indices] (where expr is an \
      expression, aList is a list of variable names and indices \
      is a list of positive integers) returns an expression such that \
      each term in the expression has the right number of factors \
      of the variables. For example, \
      NCTermsOfDegree[x**y**x + x**w,{x,y},indices] returns \
      x**y**x if indices = {2,1}, return x**w if indices = {1,0} \
      and returns 0 otherwise. This routine is used heavily by \
      NCTermList.";

Clear[NCTermsOfDegreeArrayMatrix];

NCTermsOfDegreeArrayMatrix::usage = 
  "NCTermsOfDegreeArrayMatrix usage message not yet written.";

Clear[NCTermsOfDegreeArray];

NCTermsOfDegreeArray::usage =
     "If you has executed NCTermArray[expr,aList,anArray], then \
      NCTermsOfDegreeArray[anArray,aList,indices] will give the same \
      result as (and be much faster than) NCTermsOfDegree[expr,aList,indices].";
(*
Clear[NCTaylorType];

NCTaylorType::usage =
     "NCTaylorType[expr,aList] (where expr is an expression and aList \
      is a list of variables) returns a list of types corresponding \
      to the terms of expr. For example, if  \
      expr = x**y**x + x**w + y + t \
      and aList = {x,y}, then the result of the function call would \
      be {{2,1},{1,0},{0,1},{0,0}}. This routine is used heavily by \
      NCTermArray.";
*)

Begin["`Private`"];

(* BEGIN MAURICIO MAR 2016 *)
NCMonomial`NCMonomial = Identity;
(* END MAURICIO MAR 2016 *)

debugTaylor = False;
checkTaylor = True;

NCTermArrayMatrix[aMatrix_?MatrixQ,aList_List,anArray_Symbol] :=
Module[{nrows,ncols,i,j},
     Clear[anArray];
     anArray["dimensions"] = {nrows,ncols} = Dimensions[aMatrix];
     Do[ Do[ ncNCTermArray[aMatrix[[i,j]],aList,anArray[i,j]];
        ,{i,1,nrows}];
     ,{j,1,ncols}];
     Return[anArray];
];

NCTermArrayMatrix[x___] := BadCall["NCTermArrayMatrix",x];

NCTermArray[expr_,aList_List,anArray_Symbol] :=
Module[{},
    Clear[anArray];
    Return[ncNCTermArray[expr,aList,anArray]];
];

NCTermArray[x___] := BadCall["NCTermArray",x];

ncNCTermArray[expr_,aList_List,anArray_] := 
Module[{check},
     anArray[x___] := 0;
     anArray["variables"] := aList;
     anArray["types"] := {};
     internalNCTermArray[expr,aList,anArray];
     If[checkTaylor, check = NCReconstructFromTermArray[anArray];
                     check = ExpandNonCommutativeMultiply[check-expr];
                     If[Not[check===0]
                          , Print["Error in NCTermsOfDegree.m"];
                            Abort[];
                     ];
     ];
     Return[anArray];
];

ncNCTermArray[x___] := BadCall["NCTermArray",x];

internalNCTermArray[expr_Plus,aList_,anArray_] := 
Module[{},
     asaList = Apply[List,expr];
     Map[internalNCTermArray[#,aList,anArray]&,asaList];
     Return[];
];

internalNCTermArray[expr_,aList_,anArray_] :=
Module[{aType,aExpr,theIndices,someIndices,j,theTypes},
     theTypes = Union[NCTaylorType[expr,aList]];
     anArray["types"] = Union[anArray["types"],theTypes];
     Do[ aType = theTypes[[j]];
         aExpr = NCTermsOfDegree[expr,aList,aType];
         theIndices = Table[(aList[[k]])^(aType[[k]])
                            ,{k,1,Length[aType]}];
         someIndices = NCMonomial`NCMonomial[theIndices];
         mySumSet[anArray,someIndices,aExpr];
     ,{j,1,Length[theTypes]}];
     Return[]
];

internalNCTermArray[x___] := BadCall["internalNCTermArray",x];

NCReconstructFromTermArray[anArray_] := 
Module[{theTypes,theVariables,sum,aType,indices,data,k},
     theTypes = anArray["types"];
     theVariables = anArray["variables"];
     sum = 0;
     Do[ aType = theTypes[[k]];
         indices = Table[(theVariables[[k]])^(aType[[k]])
                         ,{k,1,Length[aType]}];
         indices = NCMonomial`NCMonomial[indices];
         data = Apply[anArray,indices];
         sum = sum + data;
     ,{k,1,Length[theTypes]}];
     Return[sum];
];

mySumSet[anArray_,{indices___},aExpr_] := 
             anArray[indices] = anArray[indices] + aExpr;

mySumSet[x___] := BadCall["mySumSet",x];

NCTermsOfDegree[expr_Plus,aList_List,indices_List] := 
Module[{expandedExpr, asaList,temp,result},
    expandedExpr = ExpandNonCommutativeMultiply[expr ];
    asaList = Apply[List, expandedExpr ];
    temp = Map[NCTermsOfDegree[#,aList,indices]&,asaList];
    result = Apply[Plus,temp];
    Return[result];
];

NCTermsOfDegree[expr1_ expr2_ ,aList_List,indices_List] := 
   NCTermsOfDegreeProduct[{Times,expr1,expr2},aList,indices];

Literal[NCTermsOfDegree[NonCommutativeMultiply[expr1_,expr2__],
                  aList_List,indices_List]] := 
   NCTermsOfDegreeProduct[{NonCommutativeMultiply,
                      expr1,
                      NonCommutativeMultiply[expr2]},
                     aList,indices];

NCTermsOfDegreeProduct[{aHead_,expr1_,expr2_},
                         aList_List,indices_List] := 
Module[{types1,aType,diff,neg,result,output,data1,data2,j},
     If[Not[Length[aList]===Length[indices]]
          , BadCall["NCTermsOfDegreeProduct",{expr1,expr2},aList,indices];
     ];
     types1 = Union[NCTaylorType[expr1,aList]];
     Do[ aType = types1[[j]];
         data1 = NCTermsOfDegree[expr1,aList,aType];
         diff = indices - aType;
         neg = Select[diff,(#<0)&];
         If[neg==={}
              , data2 = NCTermsOfDegree[expr2,aList,diff];
                result[j] = aHead[data1,data2];
              , result[j] = 0;
         ];
     ,{j,1,Length[types1]}];
     output = Apply[Plus,Table[result[j],{j,1,Length[types1]}]];
     Clear[result];
     Return[output];
];

NCTermsOfDegreeProduct[x___] := BadCall["NCTermsOfDegreeProduct",x];

NCTermsOfDegree[aSymbol_,aList_List,indices_List] :=
     If[NCTaylorType[aSymbol,aList]==={indices}, aSymbol, 0];

NCTermsOfDegree[aNumber_?NumberQ,aList_List,indices_List] :=
     If[Union[indices]==={0}, aNumber,0];

NCTermsOfDegree[x___] := BadCall["NCTermsOfDegree",x];

NCTermsOfDegreeArrayMatrix[anArray_Symbol,aList_List,indices_List] :=
Module[{nrows,ncols,i,j,result},
    If[Not[Length[aList]===Length[indices]]
         , BadCall["NCTermsOfDegreeArrayMatrix",anArray,aList,indices];
    ];
    {nrows,ncols} = anArray["dimensions"];
    result = Table[ncTaylorTermArray[anArray[i,j],aList,indices]
                   ,{i,1,nrows},{j,1,ncols}];
    Return[result];
];
     
NCTermsOfDegreeArray[anArray_Symbol,aList_List,indices_List] :=
Module[{temp,result},
    If[Not[Length[aList]===Length[indices]]
         , BadCall["NCTermsOfDegreeArray",anArray,aList,indices];
    ];
    Return[ncTaylorTermArray[anArray,aList,indices]];
];

ncTaylorTermArray[anArray_,aList_List,indices_List] :=
Module[{temp,result},
    temp = Table[aList[[j]]^indices[[j]],{j,1,Length[aList]}];
    temp = NCMonomial`NCMonomial[temp];
    result = Apply[anArray,temp];
    Return[result];
];

ncTaylorTermArray[x___] := BadCall["ncTaylorTermArray",x];

NCTermsOfDegreeArray[x___] := BadCall["NCTermsOfDegreeArray",x];

(* returns a list of types of terms in expr *)

NCTaylorType[expr_,aList_] := 
Module[{head,result},
     head = Head[expr];
     Which[ head===Plus
              , result = NCTaylorTypeThrough[expr,aList];
          , MemberQ[{Times,NonCommutativeMultiply},head]
              , result = NCTaylorTypeProduct[expr,aList];
          , head === Power,
		 result = NCTaylorTypePower[ expr, aList ];
          , True
              , result = NCTaylorTypeOther[expr,aList];
     ];
     Return[result];
];

NCTaylorTypeOther[c_?NumberQ,aList_] := 
Module[{j},
     Return[{Table[0,{j,1,Length[aList]}]}];
];

NCTaylorTypeOther[aSymbol_,aList_] := 
Module[{position,result,i},
  position = -1;
  Do[ If[aList[[i]] == aSymbol
          , position = i;
       ]; 
  ,{i,1,Length[aList]}];
  result = Table[0,{j,1,Length[aList]}];
  If[Not[position===-1], result[[position]] = 1; ];
  Return[{result}];
];

NCTaylorTypePower[ powerExp_ , aList_ ] :=
    powerExp[[2]]*NCTaylorType[ powerExp[[1]] , aList ];

NCTaylorType[x___] := BadCall["NCTaylorType",x];

NCTaylorTypeThrough[expr_,aList_] := 
Module[{asaList,types},
     asaList = Apply[List,expr];
     types = Map[NCTaylorType[#,aList]&,asaList];
     types = Flatten[types,1];
     Return[types];
];

NCTaylorTypeThrough[x___] := BadCall["NCTaylorTypeThrough",x];

NCTaylorTypeProduct[expr_,aList_] := 
Module[{asaList,types,result},
     asaList = Apply[List,expr];
     types = Map[NCTaylorType[#,aList]&,asaList];
     result = Apply[SumItUp,types];
     Return[result];
];

NCTaylorTypeProduct[x___] := BadCall["NCTaylorTypeProduct",x];

SumItUp[aList_List,anotherList_List,otherLists___] := 
Module[{sum,j,k},
If[debugTaylor
     , Print["aList:",aList];
       Print["anotherList:",anotherList];
];
     sum = Table[aList[[j]] + anotherList[[k]]
                 ,{j,1,Length[aList]},{k,1,Length[anotherList]}];
     sum = Flatten[sum,1];
If[debugTaylor
     , Print["sum:",sum];
];
     Return[SumItUp[sum,otherLists]];
];

SumItUp[aList_] := aList;

SumItUp[x___] := BadCall["SumItUp",x];

End[];
EndPackage[]
