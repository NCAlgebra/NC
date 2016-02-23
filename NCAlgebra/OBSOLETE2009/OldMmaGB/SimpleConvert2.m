(* :Title: 	SimpleConvert2 // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus).
                Based on the work of David Hurst (dhurst)
                in the file NCTools.m
*)

(* :Context: 	SimpleConvert2` *)

(* :Summary:
		SimpleConvert2 is a version of the Convert
                program found in NCTools.m which is based
                on the recursive function NCSort.
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["SimpleConvert2`",
       "Global`","NonCommutativeMultiply`","NCSort`",
       "Coefficients`","Errors`"];

Clear[SimpleConvert2];

SimpleConvert2::usage = 
     "SimpleConvert2[expr] is a variant of Convert[expr] which is \
      recursive and follows a slightly different ordering.";
 
SimpleConvert2NormalizeSupress::usage = 
     "SimpleConvert2NormalizeSupress is an option for SimpleConvert2. The \
      default is False. If SimpleConvert2NormalizeSupress->True \
      is given as an option in a call to SimpleConvert2, then \
      a noncommutative polynomial can have a symbolic \
      commutative coefficient.";

Begin["`Private`"];

(*
      Change input given in the wrong format to the
      correct format with a head of Equal.
*)
Options[SimpleConvert2] := {SimpleConvert2NormalizeSupress->False}; 

SimpleConvert2[x_RuleTuple] := 
Module[{result,rule,LHS,coeff,firstRuleTuple,otherRuleTuples},
     rule = x[[1]];
     rule = SimpleConvert2[rule][[1]];
     LHS = rule[[1]];
     If[Not[FreeQ[LHS,Coeff]],
          coeff = TheCoefficient[LHS];
          firstRuleTuple = RuleTuple[rule[[1]]/coeff->rule[[2]]/coeff,
                                     Join[x[[2]],{Not[coeff==0]}],
                                     x[[3]]
                                    ];
          otherRuleTuples = SimpleConvert2[RuleTuple[
                               0-> (rule[[2]]/.coeff->0),
                               Join[x[[2]],{coeff==0}],
                               x[[3]]
                                                    ]
                                          ];
          result = Append[otherRuleTuples,firstRuleTuple];
        , result = {RuleTuple[rule,x[[2]],x[[3]]]};
     ];
     Return[{result}]
];

SimpleConvert2[x_,opts___] := SimpleConvert2[x==0,opts];

SimpleConvert2[x_Rule,opts___] := SimpleConvert2[x[[1]]-x[[2]]==0,opts];

SimpleConvert2[x_RuleDelayed,opts___] := SimpleConvert2[x[[1]]==x[[2]],opts];

SimpleConvert2[x_List,opts___] := Map[SimpleConvert2[#,opts]&,x];

SimpleConvert2[True,opts___] := {0->0};

SimpleConvert2[False,opts___] := 
Module[{},
    Print[" :-( Severe Warning from SimpleConvert2: Converting False"];
Abort[];
    Return[{0->0}]
];

(* 
      The important code.
*)
SimpleConvert2[x_Equal,opts___]:= 
        SimpleConvert2[Equal[x[[1]]-x[[2]],0],opts] /; 
                                                  Not[x[[2]]===0]

SimpleConvert2[0] := SimpleConvert2[True];

SimpleConvert2[x_Equal,opts___]:=
Module[{expr,expr2,orderedlist,left,right,coeff,
        temp,supressnormalization},
     supressnormalization = 
         SimpleConvert2NormalizeSupress/.{opts}/.Options[SimpleConvert2];
     expr = ExpandNonCommutativeMultiply[x[[1]]];
     expr = SimplifyCoeff[expr];
(*
     expr = expr/.{Literal[
                 NonCommutativeMultiply[front___,
                                        w_,w_^m_,
                                        back___]
                         ]  :> front**(w^(m+1))**back,
                   Literal[
                 NonCommutativeMultiply[front___,
                                        w_^m_,w_,
                                        back___]
                         ]  :> front**(w^(m+1))**back,
                  Literal[
                 NonCommutativeMultiply[front___,
                                        w_^m_,w_^n_,
                                        back___]
                         ]  :> front**(w^(m+n))**back,
                  Literal[
                 NonCommutativeMultiply[front___,
                                        w_,w_,
                                        back___]
                         ]  :> front**(w^2)**back
                  };
*)
     If[Head[expr]===Plus,expr2 = Apply[List,expr];
                         ,expr2 = {expr};
     ];
     orderedlist = NCSort`NCSort[expr2];
     left = orderedlist[[-1]];
     right = -expr + left;
     If[Head[left]===Times && NumberQ[left[[1]]],
                   coeff= left[[1]];
                   left = left/coeff;
                   right = Expand[right]/coeff;
     ];
     If[Not[supressnormalization] && Head[left]===Times,
                   coeff= Select[left,CommutativeAllQ];
                   left = left/coeff;
                   right = right/coeff;
     ];
     temp = right/.left->right;
     If[temp=!=right,
           Print["Using the rule ",left->right];
           Print["leads to an infinite loop."];
     ];
     Return[{left->right}]
] /; x[[2]]===0

SimpleConvert2[x___] := BadCall["SimpleConvert2",x];

End[];
EndPackage[]
