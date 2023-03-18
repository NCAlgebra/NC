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

Clear[NCCollect,NCStrongCollect, NCCollectExponents,
      NCCollectSymmetric, NCCollectSelfAdjoint,
      NCStrongCollectSymmetric, NCStrongCollectSelfAdjoint,
      NCDecompose, NCCompose,
      NCTermsOfDegree, NCTermsOfTotalDegree];

NCCollect::NotPolynomial = "Could not transform expression into nc polynomial";

Options[NCCollect] = {ByTotalDegree -> False};

Get["NCCollect.usage", CharacterEncoding->"UTF8"];

Begin["`Private`"];

  (* Auxiliary tests *)
                                        
  Clear[IsNegative];
  IsNegative[a_?NumberQ] := Negative[a];
  IsNegative[a_Times] := Negative[a[[1]]];
  IsNegative[_] = False;

  Clear[IsFirstNegative];
  IsFirstNegative[expr_Plus] := IsNegative[expr[[1]]];
  (* IsFirstNegative[_] := False; *)

  NCCollectExponents[expr_] :=
    expr //. {
      NonCommutativeMultiply[a___, b_^n_., c___, d_^r_., b_^m_., c___, d_^s_., e___] /; n >= m && s >= r :>
        a ** b^(n - m) ** (b^m ** c ** d^r)^2 ** d^(s - r) ** e,
      NonCommutativeMultiply[a___, b_^n_., c__, b_^m_., c__, e___] /; n >= m :>
	a ** b^(n - m) ** (b^m ** c)^2 ** e,
     NonCommutativeMultiply[a___, c___, d_^r_., c___, d_^s_., e___] /; s >= r :>
	a ** (c ** d^r)^2 ** d^(s - r) ** e,
     NonCommutativeMultiply[a___, b_^n_., c__, (b_^m_. ** c__)^r_., e___] :>
        a ** b^(n - m) ** (b^m ** c)^(r + 1) ** e,
     NonCommutativeMultiply[a___, (b__ ** c_^n_.)^r_, b__, c_^m_., e___] :>
        a ** (b ** c^n)^(r + 1) ** c^(m - n) ** e,
     NonCommutativeMultiply[a___, b__, d : (b__ ..), c___] :>
        a ** Power[NonCommutativeMultiply[b], Length[{d}]/Length[{b}] + 1] ** c
  };

  (* NCStrongCollect *)

  NCStrongCollect[expr_List, vars_] := 
     Map[NCStrongCollect[#, vars]&, expr];

  NCStrongCollect[expr_, vars_List] := Module[
    {tmp = expr},
    (* Print["in = ", tmp]; *)
    (* Scan[(tmp = NCStrongCollect[tmp, #];
	     (* Print["tmp(" <> ToString[#] <> ") = ", tmp];*) )&, vars]; *)
    (* Print["out = ", FullForm[tmp]]; *)
    Scan[(tmp = NCStrongCollect[tmp, #])&, vars];
    Return[tmp];
  ];

  NCStrongCollect[f_, x_?CommutativeQ] := 
    MapAt[Collect[#, x]&, f, Position[f, _Plus]];

  Clear[NCStrongCollectRules]
  (* OLD RULES WITHOUT EXPONENTS *)
  NCStrongCollectRules[x_] := {
    A_. * left___**x**right___ + B_. * left___**x**right___ :> 
      (A + B) * left ** x ** right,
    A_. * left___**x**a___ + B_. * left___**x**b___ :> 
      left ** x ** (A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]),
    A_. * a___**x**right___ + B_. *b___**x**right___ :> 
      (A*NonCommutativeMultiply[a]+B*NonCommutativeMultiply[b]) ** x ** right,
    A_. * x + B_. * x**b___ :> 
      x ** (A + B*NonCommutativeMultiply[b]),
    A_. * x + B_. * b___**x :> 
      (A + B*NonCommutativeMultiply[b]) ** x,
    left___ ** (a_Plus?IsFirstNegative) ** right___ :> 
      -NonCommutativeMultiply[left, Expand[-a], right]
  };

  Clear[NCStrongCollectPowerRules];
  (* MAURICIO: FEB 2022
     NEW RULES ACCOUTING FOR EXPONENTS ON SYMBOLS
     OTHER NC THINGS MATCH WITHOUT EXPONENTS
   *)
  NCStrongCollectPowerRules[x_] := {
    A_.*left___ ** x^n_. ** right___ + B_.*left___ ** x^n_. ** right___ :>
      (A + B)*left ** x^n ** right,
    A_.*left___ ** x^n_. ** a___ + B_.*left___ ** x^m_. ** b___ :> 
      left ** x^(Min[m, n]) ** (A*x^(n - Min[m, n]) ** a + B*x^(m - Min[m, n]) ** b),
    A_.*a___ ** x^n_. ** right___ + B_.*b___ ** x^m_. ** right___ :>
      (A*a ** x^(n - Min[m, n]) + B*b ** x^(m - Min[m, n])) ** x^(Min[m, n]) ** right,
    A_.*x^n_. + B_.*x^m_. ** b___ :>
      x^(Min[m, n]) ** (A*x^(n - Min[m, n]) + B*x^(m - Min[m, n]) ** b),
    A_.*x^n_. + B_.*b___ ** x^m_. :>
      (A*x^(n - Min[m, n]) + B*b ** x^(m - Min[m, n])) ** x^(Min[m, n]),
    left___ ** (a_Plus?IsFirstNegative) ** right___ :>
      -NonCommutativeMultiply[left, Expand[-a], right]
  };

  NCStrongCollect[f_, x:((tp|aj)[_?NCSymbolOrSubscriptQ])] :=
    ReplaceRepeated[f, NCStrongCollectPowerRules[x]];

  NCStrongCollect[f_, x_?NCSymbolOrSubscriptQ] :=
    ReplaceRepeated[f, NCStrongCollectPowerRules[x]];
    
  NCStrongCollect[f_, x_NonCommutativeMultiply] :=
    ReplaceRepeated[f, Join[NCStrongCollectPowerRules[x], NCStrongCollectRules[x]]];

  NCStrongCollect[f_, x_?NonCommutativeQ] :=
    ReplaceRepeated[f, NCStrongCollectRules[x]];

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
         pos = Flatten[Position[ncVars, 
                                Except[_?NCSymbolOrSubscriptQ|_?CommutativeQ], {1}]];
         exprs = ncVars[[pos]];
         
         (* create replacement variables *)
         expVars = Table[Unique["exp"], Length[exprs]];
         SetNonCommutative[expVars];

         (* and a rule to replace *)
         rules = Thread[exprs -> expVars];

         (* replace in expression and ncVars *)
         expr = NCReplaceRepeated[expr, rules];
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
