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

Clear[NCCollect,NCStrongCollect, 
      NCCollectSymmetric, NCCollectSelfAdjoint,
      NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint,
      NCDecompose, NCCompose,
      NCTermsOfDegree];

Clear[NCStrongCollectOnFunction];

Get["NCCollect.usage"];
                                        
Begin["`Private`"];

  (* Auxiliary tests *)
                                        
  Clear[IsNegative];
  IsNegative[a_?NumberQ] = True /; Negative[a];
  IsNegative[Times[a_?NumberQ, __]] = True; /; Negative[a];
  IsNegative[_] = False;

  Clear[IsFirstNegative];
  IsFirstNegative[expr_Plus] := If[IsNegative[expr[[1]]], True, False];
  IsFirstNegative[expr] = False;

  (* NCStrongCollect *)

  NCStrongCollect[expr_, vars_List] := Module[
    {tmp = expr},
    Scan[(tmp = NCStrongCollect[tmp, #])&, vars];
    Return[tmp];
  ];
  
  NCStrongCollect[f_, x_] :=
    ReplaceRepeated[
      ReplaceRepeated[f, {

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

      }], left___**(a_Plus?IsFirstNegative)**right___ :> 
             -NonCommutativeMultiply[left, Expand[-a], right]];

  NCStrongCollectOnFunction[f_, x_] :=
    ReplaceRepeated[
      ReplaceRepeated[f, {

         (A_:1) * left___**x[y_]**right___ + (B_:1) * left___**x[y_]**right___ :> 
           (A + B)
           NonCommutativeMultiply[left, x[y], right],

         (A_:1) * left___**x[y_]**a___ + (B_:1) * left___**x[y_]**b___ :> 
           NonCommutativeMultiply[
             left, 
             x[y],
             A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]
           ],

         (A_:1) * a___**x[y_]**right___ + (B_:1) *b___**x[y_]**right___ :> 
           NonCommutativeMultiply[
             (A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]),
             x[y],
             right
           ],

         (A_:1) * x[y_] + (B_:1) * x[y_]**b___ :> 
           NonCommutativeMultiply[x[y], (A + B*NonCommutativeMultiply[b])],

         (A_:1) * x[y_] + (B_:1) * b___**x[y_] :> 
           NonCommutativeMultiply[(A + B*NonCommutativeMultiply[b]), x[y]]

      }], left___**(a_Plus?IsFirstNegative)**right___ :> 
             -NonCommutativeMultiply[left, Expand[-a], right]];
    
          
  (* NCDecompose *)                                       
                                        
  NCDecompose[expr_] := 
    Quiet[
       Check[ NCPDecompose[NCToNCPolynomial[expr]]
             ,
              Apply[(NCPDecompose[#1] /. #3)&, NCRationalToNCPolynomial[expr]]
             ,
              NCPolynomial::NotPolynomial
       ]
      ,
       NCPolynomial::NotPolynomial
    ];

  NCDecompose[expr_, vars_List] := 
    Quiet[
       Check[ NCPDecompose[NCToNCPolynomial[expr, vars]]
             ,
              Apply[(NCPDecompose[#1] /. #3)&, NCRationalToNCPolynomial[expr, vars]]
             ,
              NCPolynomial::NotPolynomial
       ]
      ,
       NCPolynomial::NotPolynomial
    ];

  (* NCCompose *)
                                        
  NCCompose[expr_Association] := Total[Values[expr]];
  NCCompose[expr_Association, degree_List] := expr[degree];

  (* NCCollect *)

  NCCollect[expr_, var_] := NCCollect[expr, {var}];
                             
  NCCollect[expr_, vars_List] := Module[
    {dec,rvars,rules},
      
    {dec,rvars,rules} = Quiet[
       Check[ {NCPDecompose[NCToNCPolynomial[expr, vars]], {}, {}}
             ,
              Apply[{NCPDecompose[#1], #2, #3}&, NCRationalToNCPolynomial[expr, vars]]
             ,
              NCPolynomial::NotPolynomial
       ]
      ,
       NCPolynomial::NotPolynomial
    ];
   
    (*
    Print["dec = ", dec];
    Print["rvars = ", rvars];
    Print["rules = ", rules];
    *)
      
    Return[NCCompose[Map[NCStrongCollect[#, Join[vars, rvars]]&,
                         dec]] //. rules]
      
  ];
      
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

  (* NCTermsOfDegree *)
  
  NCTermsOfDegree[expr_, vars_, degree_] :=
    NCPTermsToNC[NCPTermsOfDegree[NCToNCPolynomial[expr, vars], degree]];

End[]

EndPackage[]
