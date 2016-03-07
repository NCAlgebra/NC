(* :Title: 	Grabs // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	Grabs` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["Grabs`","Errors`"];

Clear[GrabInsides];

GrabInsides::usage = 
       "GrabInsides[aHead, expr] gives a list of lists \
	of the arguments of every subexpression with head \
        aHead. For example, \n \
        GrabInsides[inv,inv[x+y]**inv[g] + inv[h]**m  - 2 k] \n \
        gives {{x+y},{g},{h}} and \n \
        GrabInsides[NonCommutativeMultiply, \n \
                    inv[x+y]**inv[g] + inv[h]**m - 2 k] \n \
        gives {{inv[x+y],inv[g]},{inv[h],m}}.";

Clear[GrabSubExpr];

GrabSubExpr::usage = 
      "GrabSubExpr[aHead,expr] gives all subexpressions \
       at the highest level with AHead as the head of the \
       subexpression. For example, \
       GrabSubExpr[inv,inv[inv[x]+1] + t**inv[y]] gives \
       {inv[inv[x]+1],inv[y]}.";

Clear[GrabVariable];

GrabVariable::usage = 
       "GrabVariable[x^n] gives x. \n \
        GrabVariable[LazyPower[x,m]] gives x. \n \
        GrabVariable[x] = x.";

Clear[GrabVariables];

GrabVariables::usage = 
       "Find all symbols in an expression.";

Clear[GrabIndeterminants];

GrabIndeterminants::usage =
     "GrabIndeterminants";

Begin["`Private`"];

GrabInsides[ahead_,x_] := Map[Apply[List,#]&,GrabSubExpr[ahead,x]];

GrabInsides[x___] := BadCall["GrabInsides",x];

GrabSubExpr[ahead_,x_] := {} /; Length[x]===0

GrabSubExpr[ahead_,ahead_[insides___]] := {ahead[insides]};

GrabSubExpr[ahead_,adifferenthead_[insides___]] := 
   Union[Apply[Join,Map[GrabSubExpr[ahead,#]&,{insides}]]];

GrabSubExpr[x___] := BadCall["GrabSubExpr",x];

GrabVariables[x_] := GrabVariablesAux[Apply[List,x]] /; Length[x] > 0 
GrabVariables[{}] := {};
GrabVariables[x_?NumberQ] := {};
GrabVariables[x_Symbol] := {x};

GrabVariables[x___] := BadCall["GrabVariables",x];

GrabVariablesAux[x_] := Apply[Join,Map[GrabVariables,x]];
GrabVariablesAux[x___] := BadCall["GrabVariablesAux",x];

(* :Note: See LazyPower.m
GrabVariable[LazyPower[U_,m_]] := U;
*)

GrabVariable[Power[U_,m_]] := U;
GrabVariable[x_] := x;

GrabVariable[x___] := BadCall["GrabVariable",x];


GrabIndeterminants[x_Rule] := 
    GrabIndeterminants[Apply[List,x]];

GrabIndeterminants[x_Power] := GrabIndeterminants[x[[1]]];

GrabIndeterminants[x_Equal] := 
    GrabIndeterminants[Apply[List,x]];

GrabIndeterminants[x_Plus] := 
    GrabIndeterminants[Apply[List,x]];

GrabIndeterminants[x_NonCommutativeMultiply] := 
   GrabIndeterminants[Apply[List,x]];

GrabIndeterminants[x_Times] := GrabIndeterminants[Apply[List,x]];

GrabIndeterminants[x_List] := 
Module[{asaList},
   asaList = Apply[List,x];
   Return[Apply[Union,Map[GrabIndeterminants,asaList]]];
];

GrabIndeterminants[c_?NumberQ] := {};

GrabIndeterminants[x_] := {x};

GrabIndeterminants[x___] := BadCall["GrabIndeterminants",x];

End[];
EndPackage[]
