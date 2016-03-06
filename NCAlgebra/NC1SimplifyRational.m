(* :Title: 	NCSimplify1Rational // Mathematica 1.2 and 2.0 *)

(* :Authors: 	Bill Helton (helton)
		Lois Yu (lyu) 
		David Hurst (dhurst)
*)

(* :Context: 	NCSimplify1Rational` *)

(* :Summary: 	Simplifies noncommutative expressions in one or two variables 
		and certain functions of their inverses. 

		NCSimplify1Rational[ expr ] simplifies noncommutative 
		polynomials in x & y, inv[x] & inv[x], inv[1-xy] by 
		repeatedly applying a set of reduction rules to the 
		polynomial until it stops changing.

		NCSimplify1RationalSinglePass[ expr ] simplifies 
		noncommutative polynomials in  x & y, inv[x] & inv[y], 
		inv[1-xy] by applying a set of reduction rules to the 
		polynomial for one single application of each rule.

*)

(* :Alias: 	NCS1R::= NCSimplify1Rational
		NCS1RSP::= NCSimplify1RationalSinglePass
*)

(* :Warnings: 	Although This program can handle explicit numeric scalar 
		multipliers, symbolic commutative multipliers must be 
		appropriately typed as commutative.  
		See SetCommutative and CommutativeQ.
*)

(* :History: 
   :7/3/91      Rewrote NCRS. (lyu)
   :7/31/91 	Added rhs's in FullForm. (dhurst)
   :7/20/92     Reformated comments, supplied missing blank in the
  		2nd lhs of rule 2, changed < to <= 
		in the For loop. (dhurst)
   :8/1/97      Replaced the local variable K with LLLLL.  (rowell)
   :9/8/04      Fixed normrule, added locals, replaced Expand with NCExpand. JShopple
*)

BeginPackage[ "NCSimplify1Rational`", "NonCommutativeMultiply`" ]

NCSimplify1Rational::usage =
     "NCSimplify1Rational[ expr ] simplifies noncommutative expressions in\n
     x, x & y, inv[x], inv[x] & inv[y], inv[1-x], inv[1-x] & inv[1-y],\n
     inv[1-xy] by repeatedly applying a set of reduction rules. ";

NCSimplify1RationalSinglePass::usage =
     "NCSimplify1RationalSinglePass[ expr ] simplifies noncommutative \n 
     expressions in x, x & y, inv[x], inv[x] & inv[y], inv[1-x], inv[1-x]\n
     & inv[1-y], inv[1-xy] by applying a set of reduction rules for one \n
     single pass.";

(* :Definitions:
NCS1Rdefinitions:=Message[NCS1R::definitions];
NCS1Rrule:=Information[ NCSimplify1Rational`Private`rule ];
NCS1Rrule1:=NCSimplify1Rational`Private`rule[1];
NCS1Rrule2:=NCSimplify1Rational`Private`rule[2];
NCS1Rrule3:=NCSimplify1Rational`Private`rule[3];
NCS1Rrule4:=NCSimplify1Rational`Private`rule[4];
NCS1Rrule5:=NCSimplify1Rational`Private`rule[5];
NCS1Rrule6:=NCSimplify1Rational`Private`rule[6];
*)

Begin[ "`Private`" ]

NCSimplify1Rational[expr1_] := 
     FixedPoint[ NCSimplify1RationalSinglePass, expr1 ];

NCSimplify1RationalSinglePass[ input_Symbol ] :=
     Return[input];

NCSimplify1RationalSinglePass[ input_Times ] :=
     Return[input] /; LeafCount[input]===3;

NCSimplify1RationalSinglePass[expr2_] :=
     Block[ { LLLLL, a, b, c, d, e, x, z, expr3, Good, normrule, rule },
(* Added x, z, Good, normrule and rule to the list of locals. JShopple 9/04 *)
     
	SetCommutative[LLLLL,A,B];
	SetNonCommutative[a,b,c,d,e,x];

(* Good[x] is fine as is, Symbolic Commutative elem. should also fail,
if there is any chance of them becoming zero, *)
        Good[z__] := CommutativeQ[z] && Not[z===1] && Not[z===0];
        
        normrule := inv[A_?Good + x_] :> inv[1 + x/A]/A;


(**** 4 rules replaced by one above NCTest file 13-16. JShopple 9/04
       normrule := 
           { 
              inv[A_?Good + B_ x_ ** y___] -> inv[A]**inv[Id + (B/A)x**y],
              inv[A_?Good +  x_ ** y___] -> inv[A]**inv[Id + (1/A)x**y],
 	      inv[A_?Good + B_ x_] -> inv[A]**inv[Id + (B/A)x],
 	      inv[A_?Good + x_] -> inv[A]**inv[Id + (1/A)x] 
           };
*****************************)

(*---------------------------------RULE 1-------------------------------*) 
(* rule 1 is as follows:                                                *) 
(*		inv[a] inv[1 + LLLLL a b] -> inv[a] - LLLLL b inv[1 + LLLLL a b]    *) 
(*		inv[a] inv[1 + LLLLL a] -> inv[a] - LLLLL inv[1 + LLLLL a]          *)
(*----------------------------------------------------------------------*)
rule[1] :=
{
(d___) ** inv[a__] ** inv[Id + (LLLLL_.)*(a__) ** (b__)] ** (e___):>
(*  OutputForm:  d ** inv[a] ** e - LLLLL*d ** b ** inv[Id + LLLLL*a ** b] ** e  *)
Plus[NonCommutativeMultiply[d, inv[a], e], Times[-1, LLLLL,
   NonCommutativeMultiply[d, b, inv[Plus[Id, Times[LLLLL,
   NonCommutativeMultiply[a, b]]]], e]]]
,
(d___) ** inv[a_] ** inv[Id + (LLLLL_.)*(a_)] ** (e___):>
(*  OutputForm:  d ** inv[a] ** e - LLLLL*d ** inv[Id + LLLLL*a] ** e  *)
Plus[NonCommutativeMultiply[d, inv[a], e], Times[-1, LLLLL,
NonCommutativeMultiply[d, inv[Plus[1, Times[LLLLL, a]]], e]]]
};

(*---------------------------------RULE 2-------------------------------*) 
(* rule 2 is as follows:                                                *) 
(*		inv[1 + LLLLL a b] inv[b] -> inv[b] - LLLLL inv[1 + LLLLL a b] a    *) 
(*		inv[1 + LLLLL a] inv[a] -> inv[a] - LLLLL inv[1 + LLLLL a ]         *) 
(*----------------------------------------------------------------------*)
rule[2] :=
{
(d___) ** inv[Id + (LLLLL_.)*(a__) ** (b__)] ** inv[b__] ** (e___):>
(*  OutputForm:  d ** inv[b] ** e - LLLLL*d ** inv[Id + LLLLL*a ** b] ** a ** e  *)
Plus[NonCommutativeMultiply[d, inv[b], e],
Times[-1, LLLLL, NonCommutativeMultiply[d, inv[Plus[1,
Times[LLLLL, NonCommutativeMultiply[a, b]]]], a, e]]]
,
(d___) ** inv[Id + (LLLLL_.)*a_] ** inv[a_] ** (e___):>
(*  OutputForm:  d ** inv[a] ** e - LLLLL*d ** inv[Id + LLLLL*a] ** e  *)
Plus[NonCommutativeMultiply[d, inv[a], e],
Times[-1, LLLLL, NonCommutativeMultiply[d, inv[Plus[1, Times[LLLLL, a]]], e]]]
};

(*---------------------------------RULE 3-------------------------------*) 
(* rule 3 is as follows:  inv[1 + LLLLL a b ] a b -> (1 - inv[1 + LLLLL a b])/LLLLL *)
(*                        inv[1 + LLLLL a] a -> (1 - inv[1 + LLLLL a])/LLLLL        *) 
(*----------------------------------------------------------------------*)
rule[3] :=
{
(d___) ** inv[Id + (LLLLL_.)*(a__) ** (b__)] ** (a__) ** (b__) ** (e___):>
(*  OutputForm:  (d ** e + -1*d ** inv[Id + LLLLL*a ** b] ** e)/LLLLL  *)
Times[Power[LLLLL, -1], Plus[NonCommutativeMultiply[d, e],
Times[-1, NonCommutativeMultiply[d, inv[Plus[1,
Times[LLLLL, NonCommutativeMultiply[a, b]]]], e]]]]
, 
(d___) ** inv[Id + (LLLLL_.)*(a_)] ** (a_) ** (e___):>
(*  OutputForm:  (d ** e + -1*d ** inv[Id + LLLLL*a] ** e)/LLLLL  *)
Times[Power[LLLLL, -1], Plus[NonCommutativeMultiply[d, e],
Times[-1, NonCommutativeMultiply[d, inv[Plus[1, Times[LLLLL, a]]], e]]]]
};
 
(*---------------------------------RULE 4-------------------------------*) 
(* rule 4 is as follows:  a b inv[1 + LLLLL a b] -> (inv[1 + LLLLL a b] - 1)/LLLLL  *)
(*		       	  a inv[1 + LLLLL a] -> (inv[1 + LLLLL a] - 1)/LLLLL        *)
(*----------------------------------------------------------------------*)
rule[4] :=
{
(d___) ** (a__) ** (b__) ** inv[Id + (LLLLL_.)*(a__) ** (b__)] ** (e___):>
(*  OutputForm:  (d ** e + -1*d ** inv[Id + LLLLL*a ** b] ** e)/LLLLL  *)
Times[Power[LLLLL, -1], Plus[NonCommutativeMultiply[d, e],
Times[-1, NonCommutativeMultiply[d, inv[Plus[1,
Times[LLLLL, NonCommutativeMultiply[a, b]]]], e]]]]
,
(d___) ** (a_) ** inv[Id + (LLLLL_.)*(a_)] ** (e___):>
(*  OutputForm:  (d ** e + -1*d ** inv[Id + LLLLL*a] ** e)/LLLLL  *)
Times[Power[LLLLL, -1], Plus[NonCommutativeMultiply[d, e],
Times[-1, NonCommutativeMultiply[d, inv[Plus[1, Times[LLLLL, a]]], e]]]]
};

(*---------------------------------RULE 5-------------------------------*) 
(* rule 5 is as follows:                                                *) 
(*		 inv[1 + LLLLL a b] inv[a] -> inv[a] inv[1 + LLLLL a b]         *)
(*		 inv[1 + LLLLL a] inv[a] -> inv[a] inv[1 + LLLLL a]             *)
(*----------------------------------------------------------------------*)
rule[5] :=
{
(d___) ** inv[Id + (LLLLL_.)*(a__) ** (b__)] ** inv[a__] ** (e___):>
(*  OutputForm:  d ** inv[a] ** inv[Id + LLLLL*b ** a] ** e  *)
NonCommutativeMultiply[d, inv[a], inv[Plus[1,
Times[LLLLL, NonCommutativeMultiply[b, a]]]], e]
,
(d___) ** inv[Id + (LLLLL_.)*(a_)] ** inv[a_] ** (e___):>
(*  OutputForm:  d ** inv[a] ** inv[Id + LLLLL*a] ** e  *)
NonCommutativeMultiply[d, inv[a], inv[Plus[1, Times[LLLLL, a]]], e]
};

(*---------------------------------RULE 6-------------------------------*) 
(* rule 6 is as follows:   inv[1 + LLLLL a b] a  =  a inv[1 + LLLLL b a]        *) 
(*----------------------------------------------------------------------*)
rule[6] :=
{
(d___) ** inv[Id + (LLLLL_.)*(a__) ** (b__)] ** (a__) ** (e___):>
(*  OutputForm:  d ** a ** inv[Id + LLLLL*b ** a] ** e  *)
NonCommutativeMultiply[d, a, inv[Plus[1,
Times[LLLLL, NonCommutativeMultiply[b, a]]]], e]
};

	expr3 = expr2 //. normrule ; 
	For[ n=1, n <= 6, n++,
             expr3 = ExpandNonCommutativeMultiply[expr3 //. rule[n]];
(* Changed Expand to ExpandNonCommutativeMultiply. (NCTest #9 failed.) JShopple 9/04 *)
                     ];
	Return[ expr3 ]
]

End[ ]

EndPackage[ ]
