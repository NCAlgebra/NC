(* :Title: 	NCCollect.m *)

(* :Author: 	mauricio *)

(* :Context: 	NCCollect` *)

(* :Summary:	NCCollect.m is a collection of functions useful in
		reorganizing expressions with respect to inputted 
		variables.
*)

(* :Alias: *)

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

NCCollect::NotPolynomial = "Could not transform expression into nc polynomial";

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

  NCStrongCollect[f_, x_?CommutativeQ] := Collect[f, x];

  NCStrongCollect[f_, x_?NonCommutativeQ] :=
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
              Check[ Apply[(NCPDecompose[#1] /. #3)&, NCRationalToNCPolynomial[expr]]
                    ,
                     Message[NCCollect::NotPolynomial];
                     $Failed
                    ,
                     NCPolynomial::NotRational
              ]
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
              Check[ Apply[(NCPDecompose[#1] /. #3)&, NCRationalToNCPolynomial[expr, vars]]
                    ,
                     Message[NCCollect::NotPolynomial];
                     $Failed
                    ,
                     NCPolynomial::NotRational
              ]
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

  Options[NCCollect] = {TotalDegree -> False};
  
  NCCollect[expr_List, vars_, opts:OptionsPattern[]] := 
     Map[NCCollect[#, vars, opts]&, expr];

  NCCollect[expr_, var_, opts:OptionsPattern[]] := 
     NCCollect[expr, {var}, opts];
                             
  NCCollect[exp_, var_List, opts:OptionsPattern[]] := Module[
    {vars = var, expr = exp, rules = {}, 
     dec, rvars, rrules, cvars},

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
      
    (* Handle commutative symbols *)
    cvars = Select[vars, CommutativeQ];
    If[ cvars =!= {},
        vars = DeleteCases[vars, _?CommutativeQ];
        Print["cvars = ", cvars];
        Print["vars = ", vars];
    ];
      
    {dec,rvars,rrules} = Quiet[
       Check[ {NCPDecompose[NCToNCPolynomial[expr, vars]], {}, {}}
             ,
              Check[ Apply[{NCPDecompose[#1], #2, #3}&, 
                           NCRationalToNCPolynomial[expr, vars]]
                    ,
                     Message[NCCollect::NotPolynomial];
                     {$Failed, $Failed, $Failed}
                    ,
                     NCPolynomial::NotRational
              ]
             ,
              NCPolynomial::NotPolynomial
       ]
      ,
       {NCPolynomial::NotPolynomial,NCPolynomial::NotRational}
    ];

    If[ dec === $Failed, Return[expr] ];
      
    (* group by total degree? *)
    If[ OptionValue[TotalDegree]
       ,
        (* sum degree in decompose before applying NCStrongCollect *)
        dec = Merge[MapAt[Total, Normal[dec], {All, 1}], Total];
    ];
      
    (*
    Print["dec = ", dec];
    Print["rvars = ", rvars];
    Print["rrules = ", rrules];
    Print["collected = ", 
          Map[NCStrongCollect[#, Join[vars, rvars]]&, dec]];
    *)

    (* Apply NCStrongCollect *)
    expr = NCCompose[Map[NCStrongCollect[#, Join[vars, rvars]]&,
                         dec]] //. rrules //. rules;
      
    Return[ 
      If[ cvars === {}
         ,
          expr
         ,
          Collect[expr, cvars]
      ]
    ];
      
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
  
  NCTermsOfDegree[expr_, var:(_Symbol|Subscript[_Symbol,___]), degree_Integer] :=
    NCTermsOfDegree[expr, {var}, {degree}]

  NCTermsOfDegree[expr_, vars_List, degree_List] :=
    NCPTermsToNC[NCPTermsOfDegree[NCToNCPolynomial[expr, vars], degree]];

  NCTermsOfTotalDegree[expr_, vars_, degree_Integer] :=
    NCPTermsToNC[NCPTermsOfTotalDegree[NCToNCPolynomial[expr, vars], degree]];

End[]

EndPackage[]
