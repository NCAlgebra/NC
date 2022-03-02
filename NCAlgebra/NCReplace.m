(* :Title: 	NCReplace *)

(* :Author: 	mauricio *)

(* :Context: 	NCReplace` *)

(* :Summary:
		NCReplace is a package containing several functions that 
		are useful in making replacements in noncommutative expressions.
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCReplace`",
             {"NCDot`",
              "NCTr`",
              "NCUtil`",
              "NonCommutativeMultiply`"}];

Clear[NCReplace, 
      NCReplaceAll, 
      NCReplaceRepeated, 
      NCReplaceList,
      NCMakeRuleSymmetric, NCMakeRuleSelfAdjoint,
      NCReplaceSymmetric, 
      NCReplaceAllSymmetric, 
      NCReplaceRepeatedSymmetric, 
      NCReplaceListSymmetric,
      NCReplaceSelfAdjoint, 
      NCReplaceAllSelfAdjoint, 
      NCReplaceRepeatedSelfAdjoint, 
      NCReplaceListSelfAdjoint,
      NCReplacePowerRule,
      NCMatrixExpand,
      NCMatrixReplaceAll, 
      NCMatrixReplaceRepeated,
      NCR, NCRA, NCRR, NCRL,
      NCRSym, NCRASym, NCRRSym, NCRLSym,
      NCRSA, NCRASA, NCRRSA, NCRLSA];

Get["NCReplace.usage", CharacterEncoding->"UTF8"];

Options[NCReplace] = {
  ApplyPowerRule -> False
};

Begin["`Private`"]

  (*
    - Single letter symbols match within the power and they do not need generalization
  *)
  NCReplacePowerRule[{expr___Rule}] := Map[NCReplacePowerRule, {expr}];
  NCReplacePowerRule[(op:(Rule|RuleDelayed))
		     [Power[l_?NCSymbolOrSubscriptQ, i:_Integer?Positive:1] ** s___ ** Power[r_?NCSymbolOrSubscriptQ, j:_Integer?Positive:1], expr_]] := op[
    If[ i == 1
       ,
        If[ j == 1
	   ,
	    l^(n:_Integer?Positive:1) ** s ** r^(m:_Integer?Positive:1)
	   ,
            l^(n:_Integer?Positive:1) ** s ** r^(m_Integer?((#>=j)&))
	]
       ,
        If[ j == 1
	   ,
            l^(n_Integer?((#>=i)&)) ** s ** r^(m:_Integer?Positive:1)
	   ,
            l^(n_Integer?((#>=i)&)) ** s ** r^(m_Integer?((#>=j)&))
	]
    ], If[ n != i
	  ,
	   l^(n - i) ** expr ** r^(m - j)
	  ,
	   If[ m != j
	      ,
	       expr ** r^(m - j)
	      ,
	       expr
	   ]
       ]
  ];
  NCReplacePowerRule[(op:(Rule|RuleDelayed))
		     [Power[l_?NCSymbolOrSubscriptQ, i:_Integer?Positive:1] ** s__, expr_]] := op[
    If[ i == 1
       ,
        l^(n:_Integer?Positive:1) ** s
       ,
        l^(n_Integer?((#>=i)&))
    ], If[n != i, l^(n - i) ** expr, expr]
  ];
  NCReplacePowerRule[(op:(Rule|RuleDelayed))
		     [s__ ** Power[r_?NCSymbolOrSubscriptQ, j:_Integer?Positive:1], expr_]] := op[
   If[ j == 1
       ,
	s ** r^(m:_Integer?Positive:1)
       ,
       s ** r^(m:_Integer?((#>=j)&))
     ], If[m != j, expr ** r^(m - j), expr]
  ];
  NCReplacePowerRule[(expr_Rule|expr_RuleDelayed)] := expr;
  
  (* Flat property rules must be defined using Verbatim. See:
     https://mathematica.stackexchange.com/questions/5067/constructing-a-function-with-flat-and-oneidentity-attribute-with-the-property-th
   *)
  Clear[FlatNCMultiply];
  SetAttributes[FlatNCMultiply, {Flat, OneIdentity}];

  Verbatim[FlatNCMultiply][a___, b_?NotMatrixQ, d:(b_ ..), c___] :=
    FlatNCMultiply[a, Power[b, Length[{d}]+1], c];
  Verbatim[FlatNCMultiply][a___, b_?CommutativeQ c_, d___] :=
    b FlatNCMultiply[a, c, d];
  Verbatim[FlatNCMultiply][a___, b_?CommutativeQ, d___] :=
    b FlatNCMultiply[a, d];
  Verbatim[FlatNCMultiply][a_] := a;
  Verbatim[FlatNCMultiply][] := 1;
    
  Clear[NCReplaceFlatRules];
  NCReplaceFlatRules = {
      NonCommutativeMultiply -> FlatNCMultiply
  };

  Clear[NCReplaceReverseFlatRules];
  NCReplaceReverseFlatRules = {
      FlatNCMultiply -> NonCommutativeMultiply
  };

  Clear[NCRuleProcessOptions];
  NCRuleProcessOptions[rule_, OptionsPattern[NCReplace]] :=
    If[ OptionValue[ApplyPowerRule] === True
       ,
	NCReplacePowerRule[rule]
       ,
	rule
    ];

  Clear[NCApplyFlatRules];
  NCApplyFlatRules[expr_, rule_, options:OptionsPattern[NCReplace]] :=
    {expr, NCRuleProcessOptions[rule, options]} /. NCReplaceFlatRules;

  Clear[NCReverseFlatRules];
  NCReverseFlatRules[expr_] := expr /. NCReplaceReverseFlatRules;
  NCReverseFlatRules[seq__] := Sequence @@ (List @ seq /. NCReplaceReverseFlatRules);
  
  NCReplace[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    NCReverseFlatRules[Replace @@ NCApplyFlatRules[expr, rule, options]];

  NCReplace[expr_, rule_, levelspec_, options:OptionsPattern[NCReplace]] := 
    NCReverseFlatRules[Replace @@ 
        Append[NCApplyFlatRules[expr, rule, options], levelspec]];
        
  NCReplaceAll[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    NCReverseFlatRules[ReplaceAll @@ NCApplyFlatRules[expr, rule, options]];

  NCReplaceRepeated[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    NCReverseFlatRules[ReplaceRepeated @@ NCApplyFlatRules[expr, rule, options]];

  NCReplaceList[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    NCReverseFlatRules[ReplaceList @@ NCApplyFlatRules[expr, rule, options]];

  NCReplaceList[expr_, rule_, n_, options:OptionsPattern[NCReplace]] := 
    NCReverseFlatRules[ReplaceList @@ 
        Append[NCApplyFlatRules[expr, rule, options], n]];
        
  (* NCMakeRuleSymmetric *)
  (* Adapted from http://mathematica.stackexchange.com/questions/31238/how-to-combine-elements-of-two-matrices *)
  
  NCMakeRuleSymmetric[rule_Rule] := NCMakeRuleSymmetric[{rule}];
  NCMakeRuleSymmetric[rule_RuleDelayed] := NCMakeRuleSymmetric[{rule}];
  NCMakeRuleSymmetric[rules_List] := 
    Function[Null, ##, Listable][rules, 
       Function[Null, Map[tp, ##], Listable][rules]];
        
  (* NCMakeRuleSelfAdjoint *)
  
  NCMakeRuleSelfAdjoint[rule_Rule] := NCMakeRuleSelfAdjoint[{rule}];
  NCMakeRuleSelfAdjoint[rule_RuleDelayed] := NCMakeRuleSelfAdjoint[{rule}];
  NCMakeRuleSelfAdjoint[rules_List] := 
    Function[Null, ##, Listable][rules, 
       Function[Null, Map[aj, ##], Listable][rules]];

  (* NCMatrixReplaceAll *)
  
  Clear[FlatNCPlus];
  SetAttributes[FlatNCPlus, {Orderless, OneIdentity}];
  FlatNCPlus[x_,y_] := (Plus @@ {x,y} /; 
     And[Not[MatchQ[x, _. (_NonCommutativeMultiply|_FlatNCMultiply|_inv)]],
         Not[MatchQ[y, _. (_NonCommutativeMultiply|_FlatNCMultiply|_inv)]]]);

  Clear[FlatMatrix];
  Clear[FlatInv];
     
  Clear[NCMatrixReplaceReverseFlatPlusRules];
  NCMatrixReplaceReverseFlatPlusRules = {
      inv -> NCInverse,
      Power[x_, -1] -> NCInverse[x],
      FlatNCPlus[x_?MatrixQ,y_?MatrixQ] :> 
        Plus @@ {x,y}
  };
      
  Clear[NCMatrixReplaceFlatRules];
  NCMatrixReplaceFlatRules = {
      NonCommutativeMultiply -> FlatNCMultiply,
      Plus -> FlatNCPlus,
      Power[x_, -1] -> FlatInv[x],
      inv -> FlatInv
  };
  Clear[NCMatrixReplaceFlatRulesOnce];
  NCMatrixReplaceFlatRulesOnce = {
      x_?MatrixQ :> FlatMatrix[x]
  };

  Clear[NCMatrixReplaceReverseFlatRules];
  NCMatrixReplaceReverseFlatRules = {
      FlatNCMultiply -> NonCommutativeMultiply,
      FlatMatrix -> ArrayFlatten,
      FlatInv -> NCInverse
  };


  (* Expand ** between matrices *)
  NCMatrixExpand[expr_] :=
    NCReplaceRepeated[
      (expr //. HoldPattern[inv[a_?MatrixQ]] :> NCInverse[a])
     ,
      {
       NonCommutativeMultiply[b_?ArrayQ, c__?ArrayQ] :> NCDot[b, c],
       tr[m_?ArrayQ] :> Plus @@ tr /@ Diagonal[m]
      }
    ];

  NCMatrixReplaceAll[expr_, rule_, options:OptionsPattern[NCReplace]] :=
    NCMatrixExpand[
      (ReplaceAll @@ 
          ({expr, NCRuleProcessOptions[rule, options]} 
	      //. NCMatrixReplaceFlatRules /. NCMatrixReplaceFlatRulesOnce ))
	        /. NCMatrixReplaceReverseFlatRules
    ] /. FlatNCPlus -> Plus;

  NCMatrixReplaceAll[expr_?MatrixQ, rule_, options:OptionsPattern[NCReplace]] :=
    ArrayFlatten[
      Map[NCMatrixReplaceAll[#, NCRuleProcessOptions[rule, options]]&, expr, {2}]
    ];
  
  NCMatrixReplaceRepeated[expr_, rule_, options:OptionsPattern[NCReplace]] :=
    NCMatrixExpand[
      (ReplaceRepeated @@ 
         ({expr, NCRuleProcessOptions[rule, options]} 
	      //. NCMatrixReplaceFlatRules /. NCMatrixReplaceFlatRulesOnce ))
               /. NCMatrixReplaceReverseFlatRules
    ] /. FlatNCPlus -> Plus;

  NCMatrixReplaceRepeated[expr_?MatrixQ, rule_, options:OptionsPattern[NCReplace]] :=
    ArrayFlatten[
      Map[NCMatrixReplaceRepeated[#, NCRuleProcessOptions[rule, options]]&, expr, {2}]
    ];
    
  (* Convenience methods *)
      
  NCReplaceSymmetric[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplace[expr, NCMakeRuleSymmetric[rule], args, options];
  NCReplaceAllSymmetric[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplaceAll[expr, NCMakeRuleSymmetric[rule], args, options];
  NCReplaceRepeatedSymmetric[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplaceRepeated[expr, NCMakeRuleSymmetric[rule], args, options];
  NCReplaceListSymmetric[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplaceList[expr, NCMakeRuleSymmetric[rule], args, options];
  
  NCReplaceSelfAdjoint[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplace[expr, NCMakeRuleSelfAdjoint[rule], args, options];
  NCReplaceAllSelfAdjoint[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplaceAll[expr, NCMakeRuleSelfAdjoint[rule], args, options];
  NCReplaceRepeatedSelfAdjoint[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplaceRepeated[expr, NCMakeRuleSelfAdjoint[rule], args, options];
  NCReplaceListSelfAdjoint[expr_, rule_, args___, options:OptionsPattern[NCReplace]] := 
    NCReplaceList[expr, NCMakeRuleSelfAdjoint[rule], args, options];

  (* Aliases *)
  NCR = NCReplace;
  NCRA = NCReplaceAll;
  NCRR = NCReplaceRepeated;
  NCRL = NCReplaceList;

  NCRSym = NCReplaceSymmetric;
  NCRASym = NCReplaceAllSymmetric;
  NCRRSym = NCReplaceRepeatedSymmetric;
  NCRLSym = NCReplaceListSymmetric;
  
  NCRSA = NCReplaceSelfAdjoint;
  NCRASA = NCReplaceAllSelfAdjoint;
  NCRRSA = NCReplaceRepeatedSelfAdjoint;
  NCRLSA = NCReplaceListSelfAdjoint;
    
End[];

EndPackage[];
