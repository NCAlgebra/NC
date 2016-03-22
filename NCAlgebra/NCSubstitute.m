(* :Title: 	NCSubstitute *)

(* :Author: 	mauricio *)

(* :Context: 	NCSubstitute` *)

(* :Summary:
		NCSubstitute is a package containing several functions that 
		are useful in making replacements in noncommutative expressions.
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCSubstitute`", 
              "NonCommutativeMultiply`" ];

Clear[NCReplace, NCReplaceAll, 
      NCReplaceRepeated, NCReplaceList,
      NCMakeRuleSymmetric, NCMakeRuleSelfAdjoint];

Begin["`Private`"]

  Clear[FlatNCMultiply];
  SetAttributes[FlatNCMultiply, {Flat, OneIdentity}];

  NCReplace[expr_, rule_] := 
    ((Replace @@ 
        ({expr, rule} 
           /. NonCommutativeMultiply -> FlatNCMultiply))
        /. FlatNCMultiply -> NonCommutativeMultiply);

  NCReplace[expr_, rule_, levelspec_] := 
    ((Replace @@ 
        Append[({expr, rule} 
                  /. NonCommutativeMultiply -> FlatNCMultiply),
               levelspec])
        /. FlatNCMultiply -> NonCommutativeMultiply);
        
  NCReplaceAll[expr_, rule_] := 
    ((ReplaceAll @@ 
        ({expr, rule} 
           /. NonCommutativeMultiply -> FlatNCMultiply))
        /. FlatNCMultiply -> NonCommutativeMultiply);

  NCReplaceRepeated[expr_, rule_] := 
    ((ReplaceRepeated @@ 
        ({expr, rule} 
           /. NonCommutativeMultiply -> FlatNCMultiply))
        /. FlatNCMultiply -> NonCommutativeMultiply);

  NCReplaceList[expr_, rule_] := 
    ((ReplaceList @@ 
        ({expr, rule} 
           /. NonCommutativeMultiply -> FlatNCMultiply))
        /. FlatNCMultiply -> NonCommutativeMultiply);

  NCReplaceList[expr_, rule_, n_] := 
    ((ReplaceList @@ 
        Append[({expr, rule} 
                  /. NonCommutativeMultiply -> FlatNCMultiply),
                n])
        /. FlatNCMultiply -> NonCommutativeMultiply);

        
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

