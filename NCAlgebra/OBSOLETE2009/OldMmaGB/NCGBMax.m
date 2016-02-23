(* :Title: 	NCGBMax // Mathematica 2.0 *)

(* :Author: 	Mark Stankus *)

(* :Context: 	NCGBMax` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
*)

BeginPackage["NCGBMax`","NonCommutativeMultiply`","NCMakeGreater`",
                        "SimplePower`","Global`","System`","Errors`"];

Clear[SimpleMax];

SimpleMax::usage =
     "SimpleMax";

Clear[SimpleMaxNumbers];

SimpleMaxNumbers::usage =
     "SimpleMaxNumbers";

Clear[ComplicatedMax];

ComplicatedMax::usage =
     "ComplicatedMax";

Clear[OrderOnNn];

OrderOnNn::usage =
     "OrderOnNn[aTuple,anotherTuple] implements lexical order
      on N^n where n == Length[aTuple] == Length[anotherTuple];.";

Clear[TheDegree];

TheDegree::usage =
     "TheDegree";

Begin["`Private`"];

If[Not[Global`runningGeneral]
    ,
   SimpleMax[pairs_List] := 
   Module[{max,numbers,len,item,itemnumbers,result,j},
      max = pairs[[1,1]];
      numbers = {1};
      len = Length[pairs];
      Do[ item = pairs[[j]];
          itemnumbers = item[[1]];
          Which[itemnumbers==max, AppendTo[numbers,j];
              , OrderOnNn[itemnumbers,max], max = itemnumbers;
                                            numbers = {j};
          ];
      ,{j,2,len}];
      result = Map[pairs[[#]]&,numbers];
      Return[result];
   ];
     ,
   SimpleMax[pairs_List] :=
   Module[{result,numbersToConsider,max,len,item,j,itemnumber},
      result = {};
      numbersToConsider = {};
      max = {-1};
      len = Length[pairs];
      Do[ item = pairs[[j]];
          itemnumber = item[[1,1]];
          If[NumberQ[itemnumber]
              , Which[itemnumber>max[[1]], max = {itemnumber};
                                      numbersToConsider = {j};
                    , itemnumber==max[[1]], AppendTo[numbersToConsider,j];
                ];
              , AppendTo[result,item];
          ];
      ,{j,1,len}];
      result = Join[result,
                    Map[pairs[[#]]&,numbersToConsider]
                   ];
      Return[result];
   ];
];

SimpleMax[x___] := BadCall["SimpleMax",x];

ComplicatedMax[pairs_List] :=
Module[{result,unchanged,newlow,aLengthTuple,smallList,j,k,element},
     result = SimpleMax[pairs];
     unchanged = False;
     While[Not[unchanged],
           unchanged = True;
           newlow = {};
           Do[ aLengthTuple = result[[j,1]];
               smallList = Join[Take[result,{1,j-1}],
                                Take[result,{j+1,Length[result]}]];
               Do[ element = smallList[[k,1]];
                   If[OrderOnNn[aLengthTuple,element],
                                    AppendTo[newlow,smallList[[k]]]
                   ];
               ,{k,1,Length[smallList]}];
            ,{j,1,Length[result]}];
            result = Complement[result,newlow];
      ];
      Return[result];
];
     
ComplicatedMax[x___] := BadCall["ComplicatedMax",x];

(* Implements first > second *)

OrderOnNn[tuple1_,tuple2_,assumptions_] :=
Module[{len,first,second,condeq,result,j},
   len = Length[tuple1];
   If[Not[len===Length[tuple2]], BadCall["OrderOnNn",tuple1,
                                         tuple2,assumptions];];
   condeq = True;
   result = False;
   Do[ first = tuple1[[j]];
       second = tuple2[[j]];
       result = Or[result,condeq && first - second > 0];
       condeq = condeq && first - second == 0;
   ,{j,1,len}];
   Return[result];
]; 

OrderOnNn[first_,second_] := OrderOnNn[first,second,Null];
(*
OrderOnNn[{},{},_] := False;

OrderOnNn[tuple1_List,tuple2_List,assumptions_] :=
Module[{len,lower1,lower2,condeq,condineq,result},
   len = Length[tuple1];
   If[Not[len===Length[tuple2]], BadCall["OrderOnNn",tuple1,
                                         tuple2,assumptions];];
   lower1 = Take[tuple1,{2,-1}];
   lower2 = Take[tuple2,{2,-1}];
   condeq = tuple1[[1]] == tuple2[[1]];
   If[condeq, Return[OrderOnNn[lower1,lower2,assumptions]]];
   condineq = tuple1[[1]] - tuple2[[1]] >= 1;
   If[condineq, result = True;
              , result = False;
              , result = Or[And[condeq,OrderOnNn[lower1,lower2,assumptions]],
                            condineq];
                result = LogicalExpand[result];
   ];
   Return[result];
];
*)

OrderOnNn[x___] := BadCall["OrderOnNn",x];
   
TheDegree[x_] := 
   Which[NumberQ[x], NCMakeGreater`Private`zeroTuple,
         Head[x]===Power && NumberQ[x[[1]]], NCMakeGreater`Private`zeroTuple,
         Head[x]===Sum, sumTuple,
         Head[x]===NonCommutativeMultiply, TheDegree[Apply[List,x]],
         Head[x]===List, Apply[Plus,Map[TheDegree,x]],
         Head[x]===Times, TheDegree[Apply[List,x]],
         True, ThePower[x] NCMakeGreater`Private`indicator[
          WhatIsMultiplicityOfGradingOld[] - WhichSetOfIndeterminants[TheBase[x]]+1
                                    ]
   ];

TheDegree[x___] := BadCall["TheDegree",x];

End[];
EndPackage[]
