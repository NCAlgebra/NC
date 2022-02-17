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

Get["NCReplace.usage"];

Options[NCReplace] = {
  ApplyPowerRule -> False
};

Begin["`Private`"]

  NCReplacePowerRule[{expr___Rule}] := Map[NCReplacePowerRule, {expr}];
  NCReplacePowerRule[Power[l_?NCSymbolOrSubscriptQ, i_.] ** s___ ** Power[r_?NCSymbolOrSubscriptQ, j_.] -> expr_] :=
    If[ i == 1
       ,
        If[ j == 1
	   ,
	    l^(n_.) ** s ** r^(m_.)
	   ,
            l^(n_.) ** s ** r^(m_Integer?((#>=j)&))
	]
       ,
        If[ j == 1
	   ,
            l^(n_Integer?((#>=i)&)) ** s ** r^(m_.)
	   ,
            l^(n_Integer?((#>=i)&)) ** s ** r^(m_Integer?((#>=j)&))
	]
    ] -> l^(n - i) ** expr ** r^(m - j);
  NCReplacePowerRule[Power[l_?NCSymbolOrSubscriptQ, i_.] ** s__ -> expr_] :=
    If[ i == 1
       ,
        l^(n_.) ** s
       ,
        l^(n_Integer?((#>=i)&))
    ] -> l^(n - i) ** expr;
  NCReplacePowerRule[s__ ** Power[r_?NCSymbolOrSubscriptQ, j_.] -> expr_] :=
    If[ j == 1
       ,
	s ** r^(m_.)
       ,
        s ** r^(m_Integer?((#>=j)&))
    ] -> expr ** r^(m - j);
  NCReplacePowerRule[expr_Rule] := expr;
  
  Clear[FlatNCMultiply];
  SetAttributes[FlatNCMultiply, {Flat, OneIdentity}];

  FlatNCMultiply[a___, b_?CommutativeQ c_, d___] :=
    b FlatNCMultiply[a, c, d];
    
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
    If[ OptionValue[ApplyPowerRule]
       ,
	NCReplacePowerRule[rule]
       ,
	rule
    ];

  NCReplace[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    ((Replace @@ 
        ({expr, NCRuleProcessOptions[rule, options]} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplace[expr_, rule_, levelspec_, options:OptionsPattern[NCReplace]] := 
    ((Replace @@ 
        Append[({expr, NCRuleProcessOptions[rule, options]} 
                  /. NCReplaceFlatRules),
               levelspec])
        /. NCReplaceReverseFlatRules);
        
  NCReplaceAll[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    ((ReplaceAll @@ 
        ({expr, NCRuleProcessOptions[rule, options]} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplaceRepeated[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    ((ReplaceRepeated @@ 
        ({expr, NCRuleProcessOptions[rule, options]} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplaceList[expr_, rule_, options:OptionsPattern[NCReplace]] := 
    ((ReplaceList @@ 
        ({expr, NCRuleProcessOptions[rule, options]} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplaceList[expr_, rule_, n_, options:OptionsPattern[NCReplace]] := 
    ((ReplaceList @@ 
        Append[({expr, NCRuleProcessOptions[rule, options]} 
                  /. NCReplaceFlatRules),
                n])
        /. NCReplaceReverseFlatRules);
        
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
