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
              "NonCommutativeMultiply`" ];

Clear[NCReplace, NCReplaceAll, 
      NCReplaceRepeated, NCReplaceList,
      NCMakeRuleSymmetric, NCMakeRuleSelfAdjoint];

Begin["`Private`"]

  Clear[FlatNCMultiply];
  SetAttributes[FlatNCMultiply, {Flat, OneIdentity}];

  Clear[FlatMatMult];
  FlatMatMult[x_,y_] := Inner[FlatNonCommutativeMultiply,x,y,Plus];
  FlatMatMult[x_,y_,z__] := FlatMatMult[FlatMatMult[x,y],z];
 
  Clear[NCReplaceFlatRules];
  NCReplaceFlatRules = {
      NonCommutativeMultiply -> FlatNCMultiply,
      MatMult -> FlatMatMult
  };

  Clear[NCReplaceReverseFlatRules];
  NCReplaceReverseFlatRules = {
      FlatNCMultiply -> NonCommutativeMultiply,
      FlatMatMult -> MatMult
  };

  NCReplace[expr_, rule_] := 
    ((Replace @@ 
        ({expr, rule} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplace[expr_, rule_, levelspec_] := 
    ((Replace @@ 
        Append[({expr, rule} 
                  /. NCReplaceFlatRules),
               levelspec])
        /. NCReplaceReverseFlatRules);
        
  NCReplaceAll[expr_, rule_] := 
    ((ReplaceAll @@ 
        ({expr, rule} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplaceRepeated[expr_, rule_] := 
    ((ReplaceRepeated @@ 
        ({expr, rule} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplaceList[expr_, rule_] := 
    ((ReplaceList @@ 
        ({expr, rule} 
           /. NCReplaceFlatRules))
        /. NCReplaceReverseFlatRules);

  NCReplaceList[expr_, rule_, n_] := 
    ((ReplaceList @@ 
        Append[({expr, rule} 
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
  
        
End[];

EndPackage[];

