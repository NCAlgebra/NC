(*  NCPolyInterface.m                                                      *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCGBX`",
	      "NCPolyGroebner`",
	      "NCPoly`",
              "NCUtil`",
	      "NonCommutativeMultiply`" ];

Clear[NCToNCPoly,
      NCPolyToNC,
      ClearMonomialOrder,
      SetMonomialOrder,
      SetMonomialOrder,
      GetMonomialOrder,
      PrintMonomialOrder,
      SetKnowns,
      SetUnknowns,
      NCMakeGB,
      NCReduce,
      NCRuleToPoly];

Get["NCGBX.usage"];

SetMonomialOrder::InvalidOrder = "Order `1` is invalid.";
NCMakeGB::AdditionalRelations = "Relations `1` were not found in the current ordering and have been added to the list of relations. Explicitly add them to the list of relations to control their ordering.";
NCMakeGB::MissingSymbol = "Symbols `1` appear in the relations that are not on the monomial order.";
NCMakeGB::UnknownFunction = "Functions `1` cannot yet be understood by NCMakeGB.";

Begin["`Private`"];

  Clear[$NCPolyInterfaceMonomialOrder];
  $NCPolyInterfaceMonomialOrder = {};

  Clear[$NCPolyInterfaceSetKnowns];
  $NCPolyInterfaceSetKnowns = False;
  
  (* NCRuleToPoly *)
  NCRuleToPoly[exp_Rule] := exp[[1]] - exp[[2]];
  NCRuleToPoly[exp_List] := Map[NCRuleToPoly, exp];

  (* NCToNCPoly *)

  Clear[GrabFactors];
  GrabFactors[exp_?CommutativeQ] := {exp, {}};
  GrabFactors[a_. exp_NonCommutativeMultiply] := {a, List @@ exp};
  GrabFactors[a_. exp_Symbol] := {a, {exp}};
  GrabFactors[_] := (Message[NCPoly::NotPolynomial]; {0, $Failed});

  Clear[GrabTerms];
  GrabTerms[x_Plus] := List @@ x;
  GrabTerms[x_] := {x};

  NCToNCPoly[exp_List, vars_] := 
    Map[NCToNCPoly[#, vars]&, exp];

  (*
  NCToNCPoly[exp_Rule, vars_] := 
    NCToNCPoly[exp[[1]] - exp[[2]], vars];

  NCToNCPoly[exp_Equal, vars_] := 
    NCToNCPoly[exp[[1]] - exp[[2]], vars];
  *)

  NCToNCPoly[exp_, vars_] := Module[
    {factors},
      
    Check[
      factors = Map[GrabFactors, 
                    GrabTerms[ExpandNonCommutativeMultiply[exp]]];
     ,
      Return[$Failed]
     ,
      {NCPoly::NotPolynomial,
       NCPoly::InvalidList,
       NCPoly::SizeMismatch,
       NCMonomialToDigits::InvalidSymbol}
    ];

    (* Print["factors = ", factors]; *)
      
    Return[NCPoly @@ Append[Transpose[factors], vars]];
      
  ];


  (* NCPolyToNC *)

  NCPolyToNC[exp_?NumericQ, vars_] := exp;

  NCPolyToNC[exp_NCPoly, vars_] := 
    NCPolyDisplay[exp, vars, Plus, Identity] /. Dot -> NonCommutativeMultiply;

  NCPolyToNC[exp_List, vars_] := 
    Map[NCPolyToNC[#, vars]&, exp];

  (* NCGB Interface *)

  (* This function erases all elements on current monomial order list *)
  SetKnowns[m___] := (
    $NCPolyInterfaceSetKnowns = True;
    $NCPolyInterfaceMonomialOrder = {Flatten[{m}]}
  );

  SetUnknowns[m___] := Module[{},
    (* Erase all elements but first *)
    $NCPolyInterfaceMonomialOrder = 
      If[ $NCPolyInterfaceSetKnowns
         ,
          {First[$NCPolyInterfaceMonomialOrder]}
         ,
          {}
      ];
    (* Install unknowns *)
    $NCPolyInterfaceMonomialOrder 
      = Map[Flatten, Join[$NCPolyInterfaceMonomialOrder, Map[List, {m}]]];
  ];
  
  Clear[AddElementToList];
  AddElementToList[list_List, position_Integer, element_] := Module[
    {tmp = Join[list, ConstantArray[0, position - Length@list]]}, 
    tmp[[position]] = element; 
    Return[tmp];
  ];
 
  Clear[CheckOrderAux];
  CheckOrderAux[(_Symbol|_inv|tp[_Symbol]|aj[_Symbol])..] := True;
  CheckOrderAux[___] := False;

  Clear[CheckOrder];
  CheckOrder[order___] := And @@ Apply[CheckOrderAux, order, {1}];
  
  SetMonomialOrder[m_List, level_Integer] := (
    $NCPolyInterfaceSetKnowns = False;
    $NCPolyInterfaceMonomialOrder = 
      AddElementToList[$NCPolyInterfaceMonomialOrder, level, Flatten[m]]
  );

  SetMonomialOrder[m___] := Module[
    {order},
    $NCPolyInterfaceSetKnowns = False;
    order = Map[If[Head[#] === List, #, {#}]&, {m}];
    Return[
      If[ CheckOrder[order],
          $NCPolyInterfaceMonomialOrder = order,
          Message[SetMonomialOrder::InvalidOrder,order];
          $Failed
      ]
    ];
  ];
        
  GetMonomialOrder[] := $NCPolyInterfaceMonomialOrder;

  PrintMonomialOrder[] := NCPolyDisplayOrder[$NCPolyInterfaceMonomialOrder];

  ClearMonomialOrder[] := (
    $NCPolyInterfaceSetKnowns = False;
    $NCPolyInterfaceMonomialOrder = {};
  );

  Clear[NCMakeGBAux];
  NCMakeGBAux[invs_] := Module[
    {ratVars, newRels, ruleRat, ruleRatRev},
  
    (* Create one new variable for each inv *)
    ratVars = Table[Unique["rat"], Length[invs]];
    SetNonCommutative[ratVars];

    (* Create invertibility relations *)
    newRels = Flatten[Join[
                MapThread[{#1 ** inv[#2] - 1, inv[#2] ** #1 - 1}&, 
                          {ratVars, invs}]]];

    (* Forward and reverse rules *)
    ruleRat = Thread[invs -> ratVars];
    ruleRatRev = Map[Map[Function[x,x//.ruleRat],#,{2}]&, 
                 Map[Reverse, ruleRat]];
        
    Return[{ratVars, newRels, ruleRat, ruleRatRev}];
    
  ];
  
  NCMakeGB[p_List, iter_Integer:4, opts___Rule] := Module[
    {polys, vars, symbols, basis, rules, labels,
     invs, 
     ratVars, ruleRat, newRels, ruleRev,
     relinvs,
     relRatVars, relNewRels, relRuleRat, relRuleRatRev,
     tps, tpVars, tpPos, ruleTp, ruleTpRev},

    (* Initializa polys and vars *)
    polys = p;
    vars = $NCPolyInterfaceMonomialOrder;
    symbols = NCGrabSymbols[polys];
      
    (* Look for symbols in polys *)
    If[ Complement[symbols, Flatten[vars]] =!= {},
        Message[NCMakeGB::MissingSymbol, 
                Complement[symbols, Flatten[vars]]];
        Return[$Failed];
    ];
      
    (* Look for tp and aj in relations *)
    tps = NCGrabFunctions[polys, tp|aj];
    tpVars = Complement[tps, Flatten[vars]][[All,1]];

    (*
    Print["tps = ", tps];
    Print["tpVars = ", tpVars];
    *)
      
    If[ tpVars =!= {},

        tpPos = Map[(MapAt[(#+1)&, 
                           Position[vars, #, {2}], {1, 2}])&, tpVars];
        
        (* Insert into vars *)
        MapThread[(vars = Insert[vars, #1, #2]) &, {tps, tpPos}];
      
        (*
        Print["tpPos = ", tpPos];
        Print["vars = ", vars];
        *)
        
    ];
      
    (* setup labels and ruleRev *)
    labels = vars;
    ruleRev = {};

    (* Process monomial order for rationals *)
    invs = NCGrabFunctions[$NCPolyInterfaceMonomialOrder, inv];
      
    If[ invs =!= {},
      
        (* Process invs *)
        {ratVars, newRels, ruleRat, ruleRev} = NCMakeGBAux[invs];
        
        (* Replace inv's with ratVars *)
        polys = Join[polys //. ruleRat, newRels];
        vars = vars //. ruleRat;

        (*
        Print["invs = ", invs];
        Print["ratVars = ", ratVars];
        Print["ruleRat = ", ruleRat];
        Print["newRels = ", newRels];
        Print["polys = ", polys];
        Print["vars = ", vars];
        Print["ruleRev = ", ruleRev];
        *)
        
    ];

    (* Process relations for rationals *)
    relInvs = NCGrabFunctions[polys, inv];
      
    If[ relInvs =!= {},

        (* Warn user *)
        Message[NCMakeGB::AdditionalRelations, relInvs];
        
        (* Process invs *)
        {relRatVars, relNewRels, 
         relRuleRat, relRuleRatRev} = NCMakeGBAux[relInvs];

        (* Replace inv's with ratVars *)
        polys = Join[polys //. relRuleRat, relNewRels];
        vars = Join[vars, {relRatVars}];
        labels = Join[labels, relInvs];
        
        (* Append to rules *)
        ruleRev = Join[ruleRev, relRuleRatRev];

        (*
        Print["relInvs = ", relInvs];
        Print["relRatVars = ", relRatVars];
        Print["relRuleRat = ", relRuleRat];
        Print["relNewRels = ", relNewRels];
        Print["relRuleRatRev = ", relRuleRatRev];
        *)
        
    ];

    (* Look for tp and aj in vars *)
    tps = NCGrabFunctions[vars, tp|aj];
      
    If[ tps =!= {},
         
        (* Create one new variable for each tp *)
        tpVars = Table[Unique["tp"], Length[tps]];
        SetNonCommutative[tpVars];

        (* Forward and reverse rules *)
        ruleTp = Thread[tps -> tpVars];
        ruleTpRev = Map[Reverse, ruleTp];

        (* Replace tp's with tpVars *)
        polys = polys //. ruleTp;
        vars = vars  //. ruleTp;

        (* Append to rules *)
        ruleRev = Join[ruleRev, ruleTpRev];
         
        (*
        Print["tps = ", tps];
        Print["tpVars = ", tpVars];
        Print["ruleTp = ", ruleTp];
        Print["ruleRev = ", ruleRev];
        *)
         
    ];
    
    (* Clean up Rule and Equal *)
    polys = Replace[polys, a_Rule | a_Equal :> Subtract @@ a, {1}];
      
    (* Any other symbol? *)
    symbols = NCGrabFunctions[polys];
    If[ symbols =!= {},
        Message[NCMakeGB::UnknownFunction, symbols];
        Return[$Failed];
    ];
    
    (*
    Print["polys = ", polys];
    Print["vars = ", vars];
    *)

    (* Convert to NCPoly *)
    polys = NCToNCPoly[polys, vars];
      
    (* Print["polys = ", NCPolyDisplay[polys, vars]]; *)
      
    (* Calculate GB *)
    basis = Sort[ 
              NCPolyReduce[ 
                NCPolyGroebner[polys, iter, opts,
                               Labels -> labels],
                True]
            ];

    (* Convert to rules *)
    rules = NCPolyToRule[basis];

    (* Convert to NC *)
    polys = Map[NCPolyToNC[#, vars]&, rules, {2}];
      
    If[ invs =!= {} || relInvs =!= {} || tps =!= {},
      
        (* Substitute variables *)
        polys = polys /. ruleRev;
        
        (* Delete 1 -> 1 *)
        polys = DeleteCases[polys, 1 -> 1];
        
    ];

    Return[polys];
  ];

  NCReduce[f_List, g_List, complete_:False] := Module[
    {fpolys, gpolys},

    fpolys = NCToNCPoly[f, $NCPolyInterfaceMonomialOrder];
    gpolys = NCToNCPoly[g, $NCPolyInterfaceMonomialOrder];

    rules = NCPolyToRule[NCPolyReduce[fpolys, gpolys, complete]];

    Return[Map[NCPolyToNC[#, $NCPolyInterfaceMonomialOrder]&, rules, {2}]];

  ];

  NCReduce[g_List, complete_:False] := Module[
    {gpolys},

    gpolys = NCToNCPoly[g, $NCPolyInterfaceMonomialOrder];

    rules = NCPolyToRule[NCPolyReduce[gpolys, complete]];

    Return[Map[NCPolyToNC[#, $NCPolyInterfaceMonomialOrder]&, rules, {2}]];

  ];

End[]
EndPackage[]
