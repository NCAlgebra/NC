(* :Title: 	Ajize.m // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus).*)

(* :Context: 	Ajize` *)

(* :Summary:
*)

(* :Warnings: 
*)

(* :History: 
   :3/13/93:  Wrote this function via the MakeRules.m file. (mstankus)
*)
BeginPackage["Ajize`",
      "NonCommutativeMultiply`","SimpleConvert2`","Global`",
      "System`"];

Clear[Rank1];

Rank1::usage = 
     "Rank1[V,k] represents the linear transformation\
      from the complex plane into the vector space V \
      which sends 1 to the vector k.";

Clear[Aj];

Aj::usage =
     "Aj[x] is a partial implementation of the aj command \
      from the NonCommutativeMultiply` package. The intention \
      is to have a form of adjoint which can by used for \
      Mora's algorithm.";

Clear[Ajize];

Ajize::usage = 
     "Ajize[expr] computes the Aj (adjoint) of the expression. \
      The constructs PolynomialTuple, RuleTuple,== and \
      -> are processed as one would expect. In the case of rules, \
      the processing is done via Convert2. Lists are treated \
      term-wise.";

Clear[ToAj];

ToAj::usage = 
     "ToAj[expr] returns the expression with every occurence of \
      aj replaced with Aj.";

Begin["`Private`"];

NonCommutativeMultiply`SetNonCommutative[Rank1];
NonCommutativeMultiply`SetCommutative[Aj];


Rank1[h_,k_ + m_] := Rank1[h,k] + Rank1[h,m];
Literal[Rank1[h_,NonCommutativeMultiply[a__,b_]]] := 
    NonCommutativeMultiply[a]**Rank1[h,b];
Rank1[h_,0] := 0;
Rank1[h_,c_?CommutativeQ k_] := c Rank1[h,k];
Rank1[h_,c_] := c Rank1[h,1] /; And[c=!=1,CommutativeQ[c]]

Aj[x_?CommutativeQ] := Conjugate[x];

(* Nov 2015 Mauricio : CommutativeQ pattern issue BEGIN *)
(* NonCommutativeMultiply`CommutativeQ[x_Conjugate] := True; *)
NonCommutativeMultiply`CommutativeQ[_Conjugate] = True;
(* Nov 2015 Mauricio : CommutativeQ pattern issue END *)

Aj[Aj[x_]] := x;

Aj[c_?CommutativeQ x_.] := Conjugate[c] Aj[x];
Aj[1] := 1;

Aj[x_+y_] := Aj[x] + Aj[y];

Aj[x_NonCommutativeMultiply] := 
Module[{temp},
     temp = Apply[List,x];
     temp = Reverse[x];
     temp = Map[Aj,temp];
     Return[Apply[NonCommutativeMultiply,temp]];
];

Ajize[aList_List] := Map[Ajize,aList];

Ajize[x_Global`RuleTuple] := 
Module[{temp,result},
     temp = x;
     temp[[1]] = Ajize[temp[[1]]];
     Return[result]
];

Ajize[LHS_==RHS_] := Aj[LHS] == Aj[RHS];
Ajize[LHS_->RHS_] := SimpleConvert2[Aj[LHS] == Aj[RHS]];

Ajize[expr_] := Aj[expr];

ToAj[expr_] := expr/.aj->Aj;

End[];
EndPackage[]
