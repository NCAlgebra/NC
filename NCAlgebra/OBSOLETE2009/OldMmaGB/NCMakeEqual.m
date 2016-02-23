(* :Title: 	NCMakeEqual // Mathematica  2.0 *)

(* :Author: 	Mark Stankus *)

(* :Context: 	NCMakeEqual` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
*)

BeginPackage["NCMakeEqual`","NonCommutativeMultiply`",
             "SimplePower`","NCMtools`","Errors`"];

Clear[MakeEqual];

MakeEqual::usage =
     "MakeEqual";

Begin["`Private`"];

MakeEqual[x_,x_] := False;
MakeEqual[{},_] := False;
MakeEqual[_,{}] := False;
MakeEqual[{first_,rest_},{first_,REST_}] := MakeEqual[{rest},{REST}];
MakeEqual[aList_,anotherList_] := makeEqual[aList,anotherList];

MakeEqual[x___] := BadCall["MakeEqual",x];

Clear[MakeEqual];

makeEqual[aList_List,anotherList_List] :=
Module[{FIRST,first,REST,rest,BASE,base,simpleEqual,simpleTest,
        POWER,power,newTest,aux,result,newList,thisCase,computed,
        firstCase,secondCase,answer,item,j},
     FIRST = NormalizeCoefficient[aList[[1]]];
     first = NormalizeCoefficient[anotherList[[1]]];
     REST = Take[aList,{2,-1}];
     rest = Take[anotherList,{2,-1}];
     BASE = TheBase[FIRST];
     base = TheBase[first];
     POWER = ThePower[FIRST];
     power = ThePower[first];
     simpleEqual = BASE===base;

(* POWER==power *)
     computed = False;
     thisCase = And[POWER==0,power==0];
     If[thisCase===False 
         , result[1,1] = False;
         , aux[1] = MakeEqual[REST,rest];
           computed = True;
           result[1,1] = LogicalExpand[And[thisCase,aux[1]]];
     ];
     thisCase = And[POWER-power==0,power>=1,POWER>=1];
     If[thisCase===False 
         , result[1,2] = False;
         , If[simpleEqual, result[1,2] = True;
     ];

(* POWER==0, power>0 *)
     thisCase = And[POWER==0,power>=1];
     If[thisCase===False
          , result[2] = False;
          , aux[2] = MakeEqual[REST,anotherList];
            result[2] = LogicalExpand[And[thisCase,aux[2]]];
     ];

(* POWER>0, power==0 *)
     thisCase = And[POWER>=1,power==0];
     If[thisCase===False
          , result[3] = False;
          , aux[3] = MakeEqual[aList,rest];
            result[3] = LogicalExpand[And[thisCase,aux[3]]];
     ];

     answer = Or[result[1,1],result[1,2],result[2],result[3]];
     answer = LogicalExpand[answer];
     Return[answer];
];

makeEqual[x___] := BadCall["makeEqual",x];

End[];
EndPackage[]