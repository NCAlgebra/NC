(* :Title: 	smallSimpleMatchImplementation // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	MatchImplementation` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
*)

If[runningGeneral===True, Print["Reset runningGeneral and reGet"];
                          Abort[]
];

BeginPackage["MatchImplementation`",
      "NonCommutativeMultiply`","MoraData`","Errors`"];

Clear[Match1Implementation];

Match1Implementation::usage = 
     "Match1Implementation";

Clear[Match3Implementation];

Match3Implementation::usage = 
     "Match3Implementation";

Clear[MoraMatchDebug];

MoraMatchDebug::usage =
     "MoraMatchDebug";

Clear[MoraMatchNoDebug];

MoraMatchNoDebug::usage =
     "MoraMatchNoDebug";

Begin["`Private`"];

MoraMatchDebug[] := debugMoraMatch = True;

MoraMatchDebug[x___] := BadCall["MoraMatchDebug",x];

MoraMatchNoDebug[] := debugMoraMatch = False;
 
MoraMatchNoDebug[x___] := BadCall["MoraMatchNoDebug",x];

MoraMatchNoDebug[];

(* ------------------------------------------------------------- *)
(*   Apply[NonCommutativeMultiply,aList] and                     *)
(*   Apply[NonCommutativeMultiply,anotherList] are the leading   *)
(*   terms which we are matching.                                *)
(* ------------------------------------------------------------- *)
(*   The matches checked here are of the form                    *)
(*   alpha beta1 gamma  versus beta2. We get a match if beta1    *)
(*   equals beta2.                                               *)
(* ------------------------------------------------------------- *)
Match1Implementation[aList_List,anotherList_List] := 
Module[{n,m,i1},
If[debugMoraMatch,Print["Starting match1"];];
     n = Length[aList];
     m = Length[anotherList];
     Which[n === m, If[aList===anotherList, AddaMatch[1,1,1,1]]
         , n  <  m, (* Nothing here *)
         , n  >  m, Do[ If[debugMoraMatch,
                              debugMatch1[aList,anotherList,i1,m,n];
                        ];
                        If[aList[[i1]]==anotherList[[1]],
                           If[Take[aList,{i1,i1+m-1}]===anotherList,
If[debugMoraMatch, Print["Yes"]];
                                AddaMatch[
                                     1,1,
                                     Apply[NonCommutativeMultiply,
                                           Take[aList,{1,i1-1}]],
                                     Apply[NonCommutativeMultiply,
                                           Take[aList,{i1+m,n}]]
                                         ];
                           ];
                        ];
                    ,{i1,1,n-m+1}];
     ];
     Return[]
];

Match1Implementation[x___] := BadCall["Match1Implementation",x];

debugMatch1[aList_,anotherList_,i1_,m_,n_] :=
     (
      Print["Checking"];
      Print["alpha = ",Take[aList,{1,i1-1}]];
      Print["beta1 = ",Take[aList,{i1,i1+m-1}]];
      Print["gamma = ",Take[aList,{i1+m,n}]];
      Print["beta2 = ",anotherList];
    );

(* ------------------------------------------------------------- *)
(*   Apply[NonCommutativeMultiply,aList] and                     *)
(*   Apply[NonCommutativeMultiply,anotherList] are the leading   *)
(*   terms which we are matching.                                *)
(* ------------------------------------------------------------- *)
(*   The matches checked here are of the form                    *)
(*   alpha beta1 versus beta2 gamma.  We get a match if beta1    *)
(*   equals beta2.                                               *)
(* ------------------------------------------------------------- *)
Match3Implementation[aList_List,anotherList_List] := 
Module[{n,m,i2,diff},
If[debugMoraMatch,Print["Starting match3"];];
     n = Length[aList];
     m = Length[anotherList];
     diff = Max[0,n-m];
     Do[ If[debugMoraMatch, 
              debugMatch3[aList,anotherList,i2,m,n];
         ];
         If[aList[[i2+1]] ===anotherList[[1]],
           If[Take[aList,{i2+1,n}]===Take[anotherList,{1,n-i2}], 
If[debugMoraMatch, Print["Yes"]];
                AddaMatch[1,
                          Apply[NonCommutativeMultiply,
                            Take[anotherList,{n-i2+1,m}]],
                          Apply[NonCommutativeMultiply,
                            Take[aList,{1,i2}]],
                          1
                ];
           ];
         ];
     ,{i2,diff,n-1}];
     Return[];
];

Match3Implementation[x___] := BadCall["Match3Implementation",x];

debugMatch3[aList_,anotherList_,i2_,m_,n_] :=
    (
     Print["Checking"];
     Print["alpha = ",Take[aList,{1,i2}]];
     Print["beta1 = ",Take[aList,{i2+1,n}]];
     Print["beta2 = ",Take[anotherList,{1,n-i2}]];
     Print["gamma = ",Take[anotherList,{n-i2+1,m}]];
    );

End[];
EndPackage[]
