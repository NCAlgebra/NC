(* :Title: 	NCMPolynomialQ.m // Mathematica 2.0 *)

(* :Author: 	Mark Stankus. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings:   
*)

(* :History: 
   :7/21/97:  Wrote code
*)

BeginPackage[ "NonCommutativeMultiply`","Errors`"]

Clear[NCMPolynomialQ];

NCMPolynomialQ::usage =
  "NCMPolynomialQ[expr,vars] determines if the expression expr  \
   is a polynomial or a rule (or a list of polynomials or rules)  \
   in the variables in the list vars.";

Clear[NCMPolynomialStrictQ];

NCMPolynomialStrictQ::usage =
  "NCMPolynomialStrictQ[expr,vars] determines if the expression expr \
   is a polynomial or a rule ((or a list of polynomials or rules) \
   in the variables in the list vars, but determines \
   that the coefficients are numbers rather than commutative expression.";

Begin[ "`Private`" ]

NCMPolynomialQ[x:(_Plus | 
                  _Times | 
                  _Rule | 
                  _List | 
                  _System`NonCommutativeMultiply),vars_List] :=
   Apply[And,Map[NCMPolynomialQ[#,vars]&,Apply[List,x]]];

NCMPolynomialQ[x_?NumberQ,_List] := True;

NCMPolynomialQ[x_,vars_List] := MemberQ[vars,x];

NCMPolynomialQ[x___] := BadCall["NCMPolynomialQ",x];

NCMPolynomialStrictQ[x:(_Plus | _Rule | _List | 
                        _System`NonCommutativeMultiply)
                     ,vars_List] :=
   Apply[And,Map[NCMPolynomialQ[#,vars]&,Apply[List,x]]];

NCMPolynomialStrictQ[x_Times,vars_List] := 
Module[{temp},
  temp = Select[Apply[List,x],Not[NumberQ[#]]&];
  Return[Or[Length[temp]===0,
            And[Length[temp]===1,NCMPolynomialStrictQ[temp[[1]],vars]]
           ]
  ];
];

NCMPolynomialStrictQ[x_?NumberQ,_List] := True;

NCMPolynomialStrictQ[x_,vars_List] := MemberQ[vars,x];

NCMPolynomialStrictQ[x___] := BadCall["NCMPolynomialStrictQ",x];

End[];
EndPackage[]
