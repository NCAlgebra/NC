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
      NCMatrixExpand,
      NCMatrixReplaceAll, 
      NCMatrixReplaceRepeated,
      NCR, NCRA, NCRR, NCRL,
      NCRSym, NCRASym, NCRRSym, NCRLSym,
      NCRSA, NCRASA, NCRRSA, NCRLSA];

Get["NCReplace.usage", CharacterEncoding->"UTF8"];

Begin["`Private`"]

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

  (* NCMatrixReplaceAll *)
  
  Clear[FlatNCPlus];
  SetAttributes[FlatNCPlus, {Orderless, OneIdentity}];
  FlatNCPlus[x_,y_] := (Plus @@ {x,y} /; 
     And[Not[MatchQ[x, _. (_NonCommutativeMultiply|_FlatNCMultiply|_inv)]],
         Not[MatchQ[y, _. (_NonCommutativeMultiply|_FlatNCMultiply|_inv)]]]);

  Clear[FlatMatrix];
     
  Clear[NCMatrixReplaceReverseFlatPlusRules];
  NCMatrixReplaceReverseFlatPlusRules = {
      inv -> NCInverse,
      FlatNCPlus[x_?MatrixQ,y_?MatrixQ] :> 
        Plus @@ {x,y}
  };
      
  Clear[NCMatrixReplaceFlatRules];
  NCMatrixReplaceFlatRules = {
      NonCommutativeMultiply -> FlatNCMultiply,
      Plus -> FlatNCPlus,
      x_?MatrixQ :> FlatMatrix[x]
  };

  Clear[NCMatrixReplaceReverseFlatRules];
  NCMatrixReplaceReverseFlatRules = {
      FlatNCMultiply -> NonCommutativeMultiply,
      FlatMatrix -> ArrayFlatten
  };


  (* Expand ** between matrices *)
  NCMatrixExpand[expr_] :=
      NCReplaceRepeated[
        (expr //. inv[a_?MatrixQ] :> NCInverse[a])
       ,
        {
         NonCommutativeMultiply[b_?ArrayQ, c__?ArrayQ] :> NCDot[b, c],
         tr[m_?ArrayQ] :> Plus @@ tr /@ Diagonal[m]
        }
(*
      {
          NonCommutativeMultiply[b_List, c__List] :>
               NCDot[b, c],
          NonCommutativeMultiply[b_List, c_] /; Head[c] =!= List :>
               (* Map[NonCommutativeMultiply[#, c]&, b, {2}], *)
               NCDot[b, {{c}}],
          NonCommutativeMultiply[b_, c_List] /; Head[b] =!= List :>
               (* Map[NonCommutativeMultiply[b, #]&, c, {2}] *)
               NCDot[{{b}}, c]
      }
*)
  ];

  NCMatrixReplaceAll[expr_, rule_] := NCMatrixExpand[
      (ReplaceAll @@ 
            ({expr, rule} 
             /. NCMatrixReplaceFlatRules))
               /. NCMatrixReplaceReverseFlatRules] /. FlatNCPlus -> Plus;

  NCMatrixReplaceAll[expr_?MatrixQ, rule_] :=
    ArrayFlatten[Map[NCMatrixReplaceAll[#, rule]&, expr, {2}]];
  
  NCMatrixReplaceRepeated[expr_, rule_] := NCMatrixExpand[
      (ReplaceRepeated @@ 
            ({expr, rule} 
             /. NCMatrixReplaceFlatRules))
               /. NCMatrixReplaceReverseFlatRules] /. FlatNCPlus -> Plus;

  NCMatrixReplaceRepeated[expr_?MatrixQ, rule_] :=
    ArrayFlatten[Map[NCMatrixReplaceRepeated[#, rule]&, expr, {2}]];
    
  (* Convenience methods *)
      
  NCReplaceSymmetric[expr_, rule_, args___] := 
    NCReplaceSymmetric[expr, NCMakeRuleSymmetric[rule], args];
  NCReplaceAllSymmetric[expr_, rule_, args___] := 
    NCReplaceAllSymmetric[expr, NCMakeRuleSymmetric[rule], args];
  NCReplaceRepeatedSymmetric[expr_, rule_, args___] := 
    NCReplaceRepeatedSymmetric[expr, NCMakeRuleSymmetric[rule], args];
  NCReplaceListSymmetric[expr_, rule_, args___] := 
    NCReplaceListSymmetric[expr, NCMakeRuleSymmetric[rule], args];
  
  NCReplaceSelfAdjoint[expr_, rule_, args___] := 
    NCReplaceSelfAdjoint[expr, NCMakeRuleSelfAdjoint[rule], args];
  NCReplaceAllSelfAdjoint[expr_, rule_, args___] := 
    NCReplaceAllSelfAdjoint[expr, NCMakeRuleSelfAdjoint[rule], args];
  NCReplaceRepeatedSelfAdjoint[expr_, rule_, args___] := 
    NCReplaceRepeatedSelfAdjoint[expr, NCMakeRuleSelfAdjoint[rule], args];
  NCReplaceListSelfAdjoint[expr_, rule_, args___] := 
    NCReplaceListSelfAdjoint[expr, NCMakeRuleSelfAdjoint[rule], args];

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
