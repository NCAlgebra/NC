(*  NCTeXForm.m                                                            *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage["NCTeXForm`",
             "NonCommutativeMultiply`"];

Clear[NCTeXForm,
      NCTeXFormSetStar,
      NCTeXFormSetStarStar];

Get["NCTeXForm.usage"];

Begin["`Private`"];

  (* FORMATTING TOOLS *)

  (* Postfix operator display *)

  Clear[NCTeXSetPostfix];
  NCTeXSetPostfix[f_, postfix_String] := (
    NCTeXForm[HoldPattern[f[x_]]] := 
    StringJoin["{", NCTeXParenthesize[x] ,"}", postfix];
  );

  (* Infix operator display *)

  Clear[NCTeXSetInfix];
  NCTeXSetInfix[f_, infix_String] := (
    NCTeXForm[HoldPattern[f[x_,y_,z__]]] := 
      StringJoin[NCTeXParenthesize[x, f], infix, NCTeXForm[f[y,z]]];
    NCTeXForm[HoldPattern[f[y_,z_]]] := 
      StringJoin[NCTeXParenthesize[y, f], infix, NCTeXParenthesize[z, f]];
  );

  Clear[NCTeXSetInfixSimple];
  NCTeXSetInfixSimple[f_, infix_String] := (
    NCTeXForm[HoldPattern[f[x_,z__]]] := 
      StringJoin[NCTeXForm[x], infix, NCTeXForm[f[z]]];
  );

  (* Functional display *)

  Clear[NCTeXSetFunction];
  NCTeXSetFunction[f_, fname_String] := (
    NCTeXForm[HoldPattern[f[x_]]] := 
    StringJoin["\\operatorname{", fname, "}{", NCTeXParenthesize[x] ,"}"];
  );

  (* Parenthesize *)

  Clear[NCTeXParenthesize];
  NCTeXParenthesize[x_, y_] := NCTeXParenthesize[x] /; (Head[x] =!= y);
  NCTeXParenthesize[x_, y_] := NCTeXForm[x] /; (Head[x] === y);

  NCTeXParenthesize[x_Plus] := StringJoin["\\left (", NCTeXForm[x], "\\right )"];
  NCTeXParenthesize[x_Times] := StringJoin["\\left (", NCTeXForm[x], "\\right )"];
  NCTeXParenthesize[x_NonCommutativeMultiply] := StringJoin["\\left(", NCTeXForm[x], "\\right )"];
  NCTeXParenthesize[x_] := NCTeXForm[x];


  (* BASIC TYPES *)

  NCTeXForm[x_Symbol] := ToString[Format[x, TeXForm]];
  NCTeXForm[x_?NumericQ] := ToString[Format[x, TeXForm]];


  (* MATRICES *)

  Clear[NCTeXColumnSeparate];
  Clear[NCTeXRowSeparate];
  NCTeXColumnSeparate[x_, y__] := StringJoin[x, " & ", NCTeXColumnSeparate[y]];
  NCTeXColumnSeparate[x_] := x;

  NCTeXRowSeparate[x_, y__] := StringJoin[NCTeXColumnSeparate @@ x, " \\\\ ", NCTeXRowSeparate[y]];
  NCTeXRowSeparate[x_] := NCTeXColumnSeparate @@ x;

  NCTeXForm[x_?MatrixQ] := 
    StringJoin["\\begin{bmatrix} ", NCTeXRowSeparate @@ Map[NCTeXForm, x, {2}], " \\end{bmatrix}"];

  NCTeXForm[x_?MatrixQ] := 
    StringJoin["\\left[ \\begin{array}{", 
               Table["c", {i, Part[Dimensions[x],2]}], "} ",
               NCTeXRowSeparate @@ Map[NCTeXForm, x, {2}], 
               " \\end{array} \\right ]"] /; (Part[Dimensions[x],2] > 10)


  (* LISTS *)

  Clear[NCTeXListSeparate];
  NCTeXListSeparate[x_, y__] := 
     StringJoin[x, ", ", NCTeXListSeparate[y]];
  NCTeXListSeparate[x_] := x;

  NCTeXForm[{}] := "\\{ \\}";
  NCTeXForm[x_List] := 
    StringJoin["\\{ ", NCTeXListSeparate @@ (NCTeXForm /@ x), " \\}"];


  (* POSTFIX OPERATORS *)

  NCTeXSetPostfix[tp, "^T"];
  NCTeXSetPostfix[aj, "^*"];
  NCTeXSetPostfix[rt, "^{1/2}"];
  NCTeXSetPostfix[inv, "^{-1}"];
  NCTeXSetPostfix[pinv, "^{\\dag}"];

  (* NCGB OPERATORS *)
  NCTeXSetPostfix[Global`Tp, "^T"];
  NCTeXSetPostfix[Global`Aj, "^*"];
  NCTeXSetPostfix[Global`Rt, "^{1/2}"];
  NCTeXSetPostfix[Global`Inv, "^{-1}"];
  NCTeXSetPostfix[Global`Pinv, "^{\\dag}"];


  (* INFIX OPERATORS *)
  (* RULE *)
  NCTeXForm[HoldPattern[Rule[y_,z_]]] := 
      StringJoin[NCTeXForm[y], "\\rightarrow ", NCTeXForm[z]];

  (* PLUS *)
  (*
  NCTeXForm[HoldPattern[Plus[y__,-x_Times]]] := 
      StringJoin[NCTeXForm[Plus[y]], "-", NCTeXForm[x]];
  NCTeXForm[HoldPattern[Plus[y__,-a_. x_NonCommutativeMultiply]]] := 
      StringJoin[NCTeXForm[Plus[y]], "-", NCTeXForm[a x]];
  NCTeXForm[HoldPattern[Plus[y__,-x_]]] := 
      StringJoin[NCTeXForm[Plus[y]], "-", NCTeXParenthesize[x]];

  NCTeXForm[HoldPattern[Plus[y__,x_Times]]] := 
      StringJoin[NCTeXForm[Plus[y]], "+", NCTeXForm[x]];
  NCTeXForm[HoldPattern[Plus[y__,x_NonCommutativeMultiply]]] := 
      StringJoin[NCTeXForm[Plus[y]], "+", NCTeXForm[x]];
  NCTeXSetInfix[Plus, "+"];

  NCTeXForm[HoldPattern[Plus[x_,z__]]] := 
      StringJoin[NCTeXForm[x], "+", NCTeXForm[Plus[z]]];
  *)

  NCTeXForm[HoldPattern[Plus[y__,-x_]]] := 
      StringJoin[NCTeXForm[Plus[y]], "-", NCTeXForm[x]];
  NCTeXSetInfixSimple[Plus, "+"];

  (* TIMES *)
  NCTeXForm[HoldPattern[Times[y__,Power[x_,-1]]]] := 
      StringJoin["\\frac{", NCTeXForm[y], "}{", NCTeXForm[x], "}"];
  (* NCTeXSetInfix[Times, "*"]; *)
  NCTeXSetInfix[Times, " "];
  NCTeXFormSetStar[str_String] := 
    NCTeXSetInfix[Times, str];

  (* NONCOMMUTATIVEMULTIPLY *)
  (* NCTeXSetInfix[NonCommutativeMultiply, "*\!\!*"]; *)
  NCTeXSetInfix[NonCommutativeMultiply, "."];
  NCTeXFormSetStarStar[str_String] := 
    NCTeXSetInfix[NonCommutativeMultiply, str];

  (* EQUAL *)
  NCTeXForm[HoldPattern[Equal[x_,z_]]] := 
      StringJoin[NCTeXForm[x], "\\text{==}" , NCTeXForm[z]];
  NCTeXForm[HoldPattern[Equal[x_,z__]]] := 
      StringJoin[NCTeXForm[x], "\\text{==}" , NCTeXForm[Unevaluated[Equal[z]]]];

  (* PREFIX OPERATORS *)
  NCTeXForm[-x_] := StringJoin["-", NCTeXParenthesize[x]];
  NCTeXForm[Power[x_,-1]] := StringJoin["\\frac{1}{", NCTeXForm[x], "}"];

  NCTeXForm[Power[x_,y_]] := 
     StringJoin["{", NCTeXParenthesize[x], "}^{", NCTeXForm[y], "}"];


  (* FUNCTIONS *)

  NCTeXSetFunction[Sin, "sin"];
  NCTeXSetFunction[Cos, "cos"];
  NCTeXSetFunction[Tan, "tan"];
  NCTeXSetFunction[ArcTan, "arctan"];

  (* Default function handler *)
  NCTeXForm[f_[x_]] := StringJoin[ "\\operatorname{", ToString[f], "}",
                                   "\\left (", NCTeXForm[x], "\\right )" ];
  NCTeXForm[f_[x__]] := StringJoin[ "\\operatorname{", ToString[f], "}",
                                    "\\left (",
                                      NCTeXListSeparate @@ (NCTeXForm /@ {x}),
                                    "\\right )" ];

End[];
EndPackage[]
