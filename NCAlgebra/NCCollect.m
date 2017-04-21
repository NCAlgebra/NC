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

Options[NCCollect] = {ByTotalDegree -> False};

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

  NCStrongCollect[f_, x_?CommutativeQ] := 
    MapAt[Collect[#, x]&, f, Position[f, _Plus]];

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

  NCCollect[expr_List, vars_, opts:OptionsPattern[]] := 
     Map[NCCollect[#, vars, opts]&, expr];

  NCCollect[expr_, var_, opts:OptionsPattern[]] := 
     NCCollect[expr, {var}, opts];
                             
  NCCollect[exp_, var_List, opts:OptionsPattern[]] := Module[
    {ncVars = var, cVars, expr = exp, rules = {}, 
     dec, rVars, rrules},

    If [ Not[MatchQ[ncVars, {___?NCSymbolOrSubscriptQ}]], 
         
         (* select expressions which are not symbols *)
         pos = Flatten[Position[ncVars, Except[_?NCSymbolOrSubscriptQ], {1}]];
         exprs = ncVars[[pos]];
         
         (* create replacement variables *)
         expVars = Table[Unique["exp"], Length[exprs]];
         SetNonCommutative[expVars];

         (* and a rule to replace *)
         rules = Thread[exprs -> expVars];

         (* replace in expression and ncVars *)
         expr = NCReplaceAll[expr, rules];
         ncVars[[pos]] = expVars;
         
         (* reverse rule *)
         rules = Map[Reverse, rules];

         (*
         Print["expr = ", expr];
         Print["ncVars = ", ncVars];
         Print["rules = ", rules];
         *)
         
    ];
      
    (* Split commutative symbols *)
    cVars = Select[ncVars, CommutativeQ];
    If[ cVars =!= {}
       , 
        ncVars = DeleteCases[ncVars, _?CommutativeQ];
    ];
      
    {dec,rVars,rrules} = Quiet[
       Check[ {NCPDecompose[NCToNCPolynomial[expr, ncVars]], {}, {}}
             ,
              Check[ Apply[{NCPDecompose[#1], #2, #3}&, 
                           NCRationalToNCPolynomial[expr, ncVars]]
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
    If[ OptionValue[ByTotalDegree]
       ,
        (* sum degree in decompose before applying NCStrongCollect *)
        dec = Merge[MapAt[Total, Normal[dec], {All, 1}], Total];
    ];
      
    (*
    Print["dec = ", dec];
    Print["rVars = ", rVars];
    Print["rrules = ", rrules];
    Print["collected = ", 
          Map[NCStrongCollect[#, Join[ncVars, rVars]]&, dec]];
    *)

    (* Apply NCStrongCollect *)
    Return[NCCompose[Map[NCStrongCollect[#, Join[ncVars, rVars, cVars]]&,
                         dec]] //. rrules //. rules];
      
  ];
      
  (* NCCollectSymmetric *)
                             
  NCCollectSymmetric[expr_, vars_, opts:OptionsPattern[]] := 
    NCCollectSymmetric[expr, {vars}, opts];
  NCCollectSymmetric[expr_, vars_List, opts:OptionsPattern[]] :=
    NCCollect[expr, Flatten[Transpose[{vars,Map[tp,vars]}]], opts];

  NCCollectSelfAdjoint[expr_, vars_, opts:OptionsPattern[]] := 
    NCCollectSelfAdjoint[expr, {vars}, opts];
  NCCollectSelfAdjoint[expr_, vars_List, opts:OptionsPattern[]] :=
    NCCollect[expr, Flatten[Transpose[{vars,Map[aj,vars]}]], opts];

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
