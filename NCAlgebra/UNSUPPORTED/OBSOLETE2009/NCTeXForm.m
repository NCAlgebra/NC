
(* ------------------------------------------------------------------ *)
(*   NCTeXForm.m                                                      *)
(* ------------------------------------------------------------------ *)
BeginPackage["TeXStuff`","System`","NonCommutativeMultiply`"];

Clear[TeXFormAux];

TeXFormAux::usage=""

Clear[TeXTest];

TeXTest::usage=""

Clear[TeXexceptions];

TeXexceptions::usage=""

Begin["`Private`"];

tp/:Literal[Format[tp[x_],TeXForm]] := 
 StringJoin[TeXFormAux[x],"{}^T"];
aj/:Literal[Format[aj[x_],TeXForm]] := 
 StringJoin[TeXFormAux[x],"{}^{*}"];
rt/:Literal[Format[rt[x_],TeXForm]] := 
    StringJoin[TeXFormAux[x],"{}^{ 1 \\over 2}"];
inv/:Literal[Format[inv[x_],TeXForm]]  := 
    StringJoin[TeXFormAux[x],"{}^{-1}"];
NonCommutativeMultiply/:Literal[
       Format[NonCommutativeMultiply[x_,y_,z__],TeXForm]]  := 
           StringJoin[TeXFormAux[x]," ", 
           ToString[Format[NonCommutativeMultiply[y,z],TeXForm]]]; 

NonCommutativeMultiply/:Literal[Format[NonCommutativeMultiply[x_,y_],TeXForm]]  := StringJoin[TeXFormAux[x]," ", TeXFormAux[y]]; 

(* ------------------------------------------------------------------ *)
(*      Stuff to worry about whether to add parenthesis or not        *)
(* ------------------------------------------------------------------ *)

TeXFormAux[expr_] := 
         StringJoin["(",ToString[Format[expr,TeXForm]],")"]/; TeXTest[expr]

TeXFormAux[expr_] := ToString[Format[expr,TeXForm]] /; Not[TeXTest[expr]]

(* ------------------------------------------------------------------ *)
(*     List functions which are to be outputted in infix              *)
(*     notation here.                                                 *)
(* ------------------------------------------------------------------ *)

TeXexceptions := {Plus,NonCommutativeMultiply,Times};
TeXTest[expr_] := Not[Length[expr] == 0] && 
                  MemberQ[TeXexceptions,Head[expr]];

End[];
EndPackage[]
