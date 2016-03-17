(* :Title: 	NCCollect.m *)

(* :Author: 	mauricio *)

(* :Context: 	NCCollect` *)

(* :Summary:	NCCollect.m is a collection of functions useful in
		reorganizing expressions with respect to inputted 
		variables.
*)

(* :Alias:	NCDec ::= NCDecompose, NCCom ::= NCCompose,
		decompose ::= NCDecompose, compose ::= NCCompose,
                NCC ::= NCCollect,
		NCSC ::= NCStrongCollect, NCCSym ::= NCCollectSymmetric,
*)

(* :Warnings: *)

(* :History: 
*)

BeginPackage[ "NCCollect`",
              "NCPolynomial`",
              "NonCommutativeMultiply`" ];

Clear[NCDecompose];
NCDecompose::usage = "\
NCDecompose[p,vars] gives an association of elements of the \
nc polynomial p in variables vars which elements of the same order \
are collected together.

NCDecompose uses NCPDecompose.

See also NCPDecompose";
    
Clear[NCCompose];
NCCompose::usage = "\
NCCompose[NCDecompose[p,vars]] will reproduce the nc polynomial p \
in variables vars.
NCCompose[NCDecompose[p,vars], d] will reproduce only the \
terms of degree d.

See also NCDecompose, NCPDecompose.";

Clear[NCStrongCollect];
NCStrongCollect::usage = "\
NCStrongCollect[expr,vars] collects terms of expression \
expr according to the elements of vars and attempts to \
combine by association. 

In the noncommutative case the Taylor expansion and so the collect \
function is not uniquely specified. This collect function often \
collects too much and while correct it may be stronger than you \
want.

For example, x will factor out of terms where it appears both \
linearly and quadratically thus mixing orders.

See NCCollect, NCCollectSymmetric, NCCollectSelfAdjoint, NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint.";

Clear[NCCollect];
NCCollect::usage = "\
NCCollect[expr,vars] collects terms of expression expr \
according to the elements of vars and attempts to combine \ 
them using rulesCollect.  It is weaker than NCStrongCollect \
in that only same order terms are collected togther. \

It basically is NCCompose[NCStrongCollect[NCDecompose]]].

See also NCStrongCollect, NCCollectSymmetric, NCCollectSelfAdjoint, NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint.";

Clear[NCCollectSymmetric];
NCCollectSymmetric::usage = "\
NCCollectSymmetric[expr, vars] allows one to collect on the \
variables and their transposes without writing out the \
transposes.

See also NCCollect, NCStrongCollect, NCCollectSelfAdjoint, NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint.";

Clear[NCCollectSelfAdjoint];
NCCollectSelfAdjoint::usage = "\
NCCollectSelfAdjoint[expr, vars] allows one to collect on the \
variables and their adjoints without writing out the \
adjoints.

See also NCCollect, NCStrongCollect, NCCollectSymmetric, NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint.";
                             
Clear[NCStrongCollectSymmetric];
NCStrongCollectSymmetric::usage = "\
NCStrongCollectSymmetric[expr, vars] allows one to collect on the \
variables and their transposes without writing out the \
transposes.

See also NCCollect, NCStrongCollect, NCCollectSelfAdjoint, NCCollectSymmetric, NCStrongCollectSelfAdjoint.";

Clear[NCStrongCollectSelfAdjoint];
NCStrongCollectSelfAdjoint::usage = "\
NCStrongCollectSelfAdjoint[expr, vars] allows one to collect on the \
variables and their adjoints without writing out the \
adjoints.

See also NCCollect, NCStrongCollect, NCCollectSymmetric, NCStrongCollectSymmetric, NCCollectSelfAdjoint.";
                                        
Begin["`Private`"];

  (* Auxiliary tests *)
                                        
  Clear[IsNegative];
  IsNegative[a_?NumberQ] = True /; Negative[a];
  IsNegative[Times[a_?NumberQ, __]] = True; /; Negative[a];
  IsNegative[_] = False;

  Clear[IsFirstNegative];
  IsFirstNegative[exp_Plus] := If[IsNegative[exp[[1]]], True, False];
  IsFirstNegative[exp] = False;

  (* NCStrongCollect *)

  NCStrongCollect[exp_, vars_List] := Module[
    {tmp = exp},
    Scan[(tmp = NCStrongCollect[tmp, #])&, vars];
    Return[tmp];
  ];
                                
  NCStrongCollect[f_, x_] :=
    (f //. {

       (A_:1) * left___**x**right___ + (B_:1) * left___**x**right___ :> 
         (A + B)
         NonCommutativeMultiply[left, x, right],

       (A_:1) * left___**x**a___ + (B_:1) * left___**x**b___ :> 
         NonCommutativeMultiply[
           left, 
           x,
           A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]
         ],

       (A_:1) * a___**x**right___ + (B_:1) *b___**x**right___ :> 
         NonCommutativeMultiply[
           (A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]),
           x,
           right
         ],

       (A_:1) * x + (B_:1) * x**b___ :> 
         NonCommutativeMultiply[x, (A + B*NonCommutativeMultiply[b])],

       (A_:1) * x + (B_:1) * b___**x :> 
         NonCommutativeMultiply[(A + B*NonCommutativeMultiply[b]), x]

      }) //. 
        left___**(a_Plus?IsFirstNegative)**right___ :> 
          -NonCommutativeMultiply[left, Expand[-a], right];

  (* NCDecompose *)                                       
                                        
  NCDecompose[exp_, vars_List] := 
    NCPDecompose[NCToNCPolynomial[exp, vars]];

  (* NCCompose *)
                                        
  NCCompose[exp_Association] := Total[Values[exp]];
  NCCompose[exp_Association, degree_List] := exp[degree];

  (* NCCollect *)

  NCCollect[expr_, var_] := NCCollect[expr, {var}];
                             
  NCCollect[expr_, vars_List] := 
    NCCompose[Map[NCStrongCollect[#, vars]&, 
                  NCDecompose[expr, vars] ] ]; 
      
  (* NCCollectSymmetric *)
                             
  NCCollectSymmetric[expr_, vars_] := NCCollectSymmetric[expr, {vars}];
  NCCollectSymmetric[expr_, vars_List] :=
    NCCollect[expr, Flatten[Transpose[{vars,Map[tp,vars]}]]];

  NCCollectSelfAdjoint[expr_, vars_] := NCCollectSelfAdjoint[expr, {vars}];
  NCCollectSelfAdjoint[expr_, vars_List] :=
    NCCollect[expr, Flatten[Transpose[{vars,Map[aj,vars]}]]];

  (* NCStrongCollectSymmetric *)
                             
  NCStrongCollectSymmetric[expr_, vars_] := 
    NCStrongCollectSymmetric[expr, {vars}];
  NCStrongCollectSymmetric[expr_, vars_List] :=
    NCStrongCollect[expr, Flatten[Transpose[{vars,Map[tp,vars]}]]];

  NCStrongCollectSelfAdjoint[expr_, vars_] := 
    NCStrongCollectSelfAdjoint[expr, {vars}];
  NCStrongCollectSelfAdjoint[expr_, vars_List] :=
    NCStrongCollect[expr, Flatten[Transpose[{vars,Map[aj,vars],Map[tp,vars]}]]];
                             
End[]

EndPackage[]


