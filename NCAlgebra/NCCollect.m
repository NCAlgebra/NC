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
              "NCReplace`",
              "NCPolynomial`",
              "NCUtil`",
              "NonCommutativeMultiply`" ];

Clear[NCCollect,NCStrongCollect, 
      NCCollectSymmetric, NCCollectSelfAdjoint,
      NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint,
      NCDecompose, NCCompose,
      NCTermsOfDegree, NCTermsOfTotalDegree];

Begin["`Private`"];

  Get["NCCollect.usage"];

  (* Auxiliary tests *)
                                        
  Clear[IsNegative];
  IsNegative[a_?NumberQ] := Negative[a];
  IsNegative[a_Times] := Negative[a[[1]]];
  IsNegative[_] = False;

  Clear[IsFirstNegative];
  IsFirstNegative[expr_Plus] := IsNegative[expr[[1]]];
  (* IsFirstNegative[_] := False; *)

  (* NCStrongCollect *)

  NCStrongCollect[expr_List, vars_] := 
     Map[NCStrongCollect[#, vars]&, expr];

  NCStrongCollect[expr_, vars_List] := Module[
    {tmp = expr},
    (* Print["in = ", tmp]; *)
    Scan[(tmp = NCStrongCollect[tmp, #]; 
          (* Print["tmp(" <> ToString[#] <> ") = ", tmp];*) )&, vars];
    (* Print["out = ", FullForm[tmp]]; *)
    Return[tmp];
  ];

  NCStrongCollect[f_, x_] :=
    ReplaceRepeated[f, {

         A_. * left___**x**right___ + B_. * left___**x**right___ :> 
           (A + B)
           NonCommutativeMultiply[left, x, right],

         A_. * left___**x**a___ + B_. * left___**x**b___ :> 
           NonCommutativeMultiply[
             left, 
             x,
             A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]
           ],

         A_. * a___**x**right___ + B_. *b___**x**right___ :> 
           NonCommutativeMultiply[
             (A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]),
             x,
             right
           ],

         A_. * x + B_. * x**b___ :> 
           NonCommutativeMultiply[x, (A + B*NonCommutativeMultiply[b])],

         A_. * x + B_. * b___**x :> 
           NonCommutativeMultiply[(A + B*NonCommutativeMultiply[b]), x],

         left___**(a_Plus?IsFirstNegative)**right___ :> 
             -NonCommutativeMultiply[left, Expand[-a], right]
        
    }
  ];

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

  NCCollect[expr_List, vars_] := 
     Map[NCCollect[#, vars]&, expr];

  NCCollect[expr_, var_] := NCCollect[expr, {var}];
                             
  NCCollect[exp_, var_List] := Module[
    {vars = var, expr = exp, rules = {}, dec, rvars, rrules},

    If [ Not[MatchQ[vars, {___?NCSymbolOrSubscriptQ}]], 
         
         (* select expressions which are not symbols *)
         pos = Flatten[Position[vars, Except[_?NCSymbolOrSubscriptQ], {1}]];
         exprs = vars[[pos]];
         
         (* create replacement variables *)
         expVars = Table[Unique["exp"], Length[exprs]];
         SetNonCommutative[expVars];

         (* and a rule to replace *)
         rules = Thread[exprs -> expVars];

         (* replace in expression and vars *)
         expr = NCReplaceAll[expr, rules];
         vars[[pos]] = expVars;
         
         (* reverse rule *)
         rules = Map[Reverse, rules];

         (*
         Print["expr = ", expr];
         Print["vars = ", vars];
         Print["rules = ", rules];
         *)
         
    ];
      
    {dec,rvars,rrules} = Quiet[
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
    Print["rrules = ", rrules];
    Print["collected = ", 
          Map[NCStrongCollect[#, Join[vars, rvars]]&, dec]];
    *)
      
    Return[NCCompose[Map[NCStrongCollect[#, Join[vars, rvars]]&,
                         dec]] //. rrules //. rules]
      
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

  NCTermsOfTotalDegree[expr_, vars_, degree_] :=
    NCPTermsToNC[NCPTermsOfTotalDegree[NCToNCPolynomial[expr, vars], degree]];

End[]

EndPackage[]
