(* :Title: NCOutput *)

(* :Context: Global` and NonCommutativeMultiply` *)

Needs["Notation`"];
Needs["NonCommutativeMultiply`"];

tp /: MakeBoxes[tp[a_], fmt_] := 
  SuperscriptBox[MakeBoxes[a, fmt],
                 MakeBoxes[Global`T, fmt]];

aj /: MakeBoxes[aj[a_], fmt_] := 
  MakeBoxes[SuperStar[a], fmt];

co /: MakeBoxes[co[a_], fmt_] := 
  MakeBoxes[OverBar[a], fmt];

inv /: MakeBoxes[inv[a_], fmt_] := 
  SuperscriptBox[Parenthesize[a, fmt, Power, Left], -1];

rt /: MakeBoxes[rt[a_], fmt_] := 
  SuperscriptBox[Parenthesize[a, fmt, Superscript, Left], 
                 MakeBoxes[1/2, fmt]];

InfixNotation[ParsedBoxWrapper["\[FilledSmallCircle]"], 
              NonCommutativeMultiply];
