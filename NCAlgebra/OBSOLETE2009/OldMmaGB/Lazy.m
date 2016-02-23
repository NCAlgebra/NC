(* :Title: 	Lazy // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	Lazy` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["Lazy`",
    "Global`","NonCommutativeMultiply`","Errors`"];

Clear[CollapseLazyPower];

CollapseLazyPower::usage = 
      "CollapseLazyPower[LazyPower[x,n]**LazyPower[x,m]] gives \
       LazyPower[x,m+n].";

Clear[PowerToLazyPower];

PowerToLazyPower::usage = 
     "PowerToLazyPower[expr] takes an expression expr and \
      changes every occurance of Power with LazyPower AND \
      interprets some expressions as LazyPower[expr,1] \
      which Mathematica cannot do with Power.";

Clear[LazyPowerToPower];

LazyPowerToPower::usage = 
     "LazyPowerToPower[expr_] := expr/.LazyPower->Power;";

Clear[LazyPower];

LazyPower::usage = 
     "LazyPower is a lazy implementation of Power. \
      Treats x^1 as x^1 and not x.";

Begin["`Private`"];

SetNonCommutative[LazyPower];

LazyPower[x_,0] := 1;
LazyPower[x_?CommutativeAllQ,c_] := x^c;
LazyPower/:Power[LazyPower[x_,n_],m_] := LazyPower[x,mn];

PowerToLazyPower[x_Global`RuleTuple] := 
Module[{result},
     result = x;
     result[[1]] = PowerToLazyPower[x[[1]]];
     Return[result]
];

PowerToLazyPower[x_RuleDelayed] := Map[PowerToLazyPower,x];
PowerToLazyPower[x_Rule] := Map[PowerToLazyPower,x];
PowerToLazyPower[x_List] := Map[PowerToLazyPower,x];
PowerToLazyPower[x_Plus] := Map[PowerToLazyPower,x];
PowerToLazyPower[x_Sum] := Apply[Sum,
                               {PowerToLazyPower[x[[1]]],x[[2]]}];
PowerToLazyPower[x_Times] := Map[PowerToLazyPower,x];
PowerToLazyPower[x_Power] := LazyPower[x[[1]],x[[2]]];
PowerToLazyPower[x_Equal] := Map[PowerToLazyPower,x];

PowerToLazyPower[x_LazyPower] := x;

PowerToLazyPower[x_NonCommutativeMultiply] := 
       Map[PowerToLazyPower,x];

PowerToLazyPower[x_Global`NonCommutativeProduct] := 
       Map[PowerToLazyPower,x];

PowerToLazyPower[x_] := LazyPower[x,1];

PowerToLazyPower[x___] := BadCall["PowerToLazyPower",x];

LazyPowerToPower[expr_] := expr/.LazyPower->Power;

LazyPowerToPower[x___] := BadCall["LazyPowerToPower",x];

CollapseLazyPower[x_] :=  ExpandNonCommutativeMultiply[x] //. {
                Literal[NonCommutativeMultiply[
                             w___,
                             LazyPower[y_,n_],
                             LazyPower[y_,m_],
                             z___             ]
                       ]:>
                NonCommutativeMultiply[w,LazyPower[y,n+m],z]};

CollapseLazyPower[x___] := BadCall["CollapseLazyPower",x];

End[];
EndPackage[] 
