(*  NCGBX.m                                                                *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCGBX`",
              "NCPolyInterface`",
	      "NCPolyGroebner`",
	      "NCPoly`",
              "NCReplace`",
              "NCUtil`",
	      "NonCommutativeMultiply`" ];

Clear[ClearMonomialOrder,
      SetMonomialOrder,
      GetMonomialOrder,
      PrintMonomialOrder,
      SetKnowns,
      SetUnknowns,
      NCMakeGB,
      NCGBSimplifyRational,
      NCProcess,
      NCReduce];

Get["NCGBX.usage"];

SetMonomialOrder::InvalidOrder = "Order `1` is invalid.";
NCMakeGB::AdditionalRelations = "Relations `1` were not found in the current ordering and have been added to the list of relations. Explicitly add them to the monomial order to control their ordering.";
NCMakeGB::MissingSymbol = "Symbols `1` appear in the relations but not on the monomial order.";
NCMakeGB::CommutativeSymbols = "Commutative symbols `1` have been removed from the monomial order.";
NCMakeGB::UnknownFunction = "Functions `1` cannot yet be understood by NCMakeGB.";

Clear[ReturnRules];
Options[NCMakeGB] = {
  ReturnRules -> True
};

Begin["`Private`"];

  Clear[$NCPolyInterfaceMonomialOrder];
  $NCPolyInterfaceMonomialOrder = {};

  Clear[$NCPolyInterfaceSetKnowns];
  $NCPolyInterfaceSetKnowns = False;
  
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
  CheckOrderAux[(_Symbol|Subscript[_Symbol,___]|_inv|tp[_Symbol]|aj[_Symbol])..] := True;
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
     relInvs, ii, varInvs,
     relRatVars, relNewRels, relRuleRat, relRuleRatRev,
     tps, tpVars, ruleTp, ruleTpRev},

    (* Initializa polys and vars *)
    polys = p;
    vars = $NCPolyInterfaceMonomialOrder;
    symbols = DeleteCases[NCGrabSymbols[polys], _?CommutativeQ];
      
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

        (* Insert tp's after corresponding variable *)
        For[ ii = 1, ii <= Length[tpVars], ii++,
             vars = Insert[vars, tps[[ii]], 
                           MapAt[(#+1)&, 
                                 Position[vars, tpVars[[ii]], {2}],
                                 {1,2}]
                   ];
        ];
        
        (*
        Print["vars = ", vars];
        *)
        
    ];
      
    (* setup labels and ruleRev *)
    labels = vars;
    ruleRev = {};

    (* Process monomial order for rationals *)
    invs = NCGrabFunctions[vars, inv];
      
    If[ invs =!= {},
      
        (* Process invs *)
        {ratVars, newRels, ruleRat, ruleRev} = NCMakeGBAux[invs];
        
        (* Replace inv's with ratVars *)
        polys = Join[polys //. ruleRat, newRels //. ruleRat];
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

        (* invs of letters in the order are special *)
        varInvs = DeleteCases[Pick[vars, Map[inv,vars,{2}], 
                              Alternatives @@ relInvs], tp[],{2}];
        If[ Flatten[varInvs] =!= {},
        
            varInvs = Map[inv, varInvs, {2}];
            
            (* Insert inv's after corresponding variable *)
            vars = DeleteCases[Riffle[vars, varInvs], 
                               {}, {1}];
            labels = vars /. ruleRev;
            varInvs = Flatten[varInvs];
            
            (* Warn user *)
            Message[NCMakeGB::AdditionalRelations, varInvs];
            
            (* Process varInvs *)
            {relRatVars, relNewRels, 
             relRuleRat, relRuleRatRev} = NCMakeGBAux[varInvs];

            (* Replace inv's with ratVars *)
            polys = Join[polys //. relRuleRat, relNewRels];
            vars = vars /. relRuleRat;
        
            (* Append to rules *)
            ruleRev = Join[ruleRev, relRuleRatRev];

            (*
            Print["vars = ", vars];
            Print["polys = ", polys];
            Print["labels = ", labels];
            Print["varInvs = ", varInvs];
            Print["relRatVars = ", relRatVars];
            Print["relRuleRat = ", relRuleRat];
            Print["relNewRels = ", relNewRels];
            Print["relRuleRatRev = ", relRuleRatRev];
            *)
        
            (* Repeat for remaining invs in relations *)
            relInvs = NCGrabFunctions[polys, inv];
            
        ];
        
        If[ relInvs =!= {},
            
            (* Warn user *)
            Message[NCMakeGB::AdditionalRelations, 
                    Flatten[relInvs] //. ruleRev];
            
            (* Process varInvs *)
            {relRatVars, relNewRels, 
             relRuleRat, relRuleRatRev} = NCMakeGBAux[relInvs];

            (* Replace inv's with ratVars *)
            polys = Join[polys //. relRuleRat, relNewRels //. relRuleRat];
            vars = Join[vars, {relRatVars}];
            labels = Join[labels, relInvs //. ruleRev];

            (* Append to rules *)
            ruleRev = Join[ruleRev, relRuleRatRev];

            (* *)
            Print["relInvs = ", relInvs];
            Print["relRatVars = ", relRatVars];
            Print["relRuleRat = ", relRuleRat];
            Print["relNewRels = ", relNewRels];
            Print["relRuleRatRev = ", relRuleRatRev];
            (* *)
            
        ];
        
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
      
    (* Any other functions in polys? *)
    symbols = DeleteCases[NCGrabFunctions[polys], _?CommutativeQ];
    If[ symbols =!= {},
        Message[NCMakeGB::UnknownFunction, symbols];
        Return[$Failed];
    ];

    (* Any noncommutative symbols not in vars? *)
    symbols = Complement[DeleteCases[NCGrabSymbols[polys], 
                                     _?CommutativeQ], Flatten[vars]];
    If[ symbols =!= {},
        Message[NCMakeGB::MissingSymbol, symbols];
        Return[$Failed];
    ];

    (* Any commutative symbols in vars? *)
    symbols = DeleteCases[Flatten[vars], _?NonCommutativeQ];
    If[ symbols =!= {},
        vars = DeleteCases[DeleteCases[vars, _?CommutativeQ, {2}], {}];
        Message[NCMakeGB::CommutativeSymbols, symbols];
    ];

    (* Save current monomial order *)
    SetMonomialOrder @@ labels;
      
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
      
    If[ invs =!= {} || varInvs =!= {} || relInvs =!= {} || tps =!= {},
      
        (* Substitute variables *)
        polys = polys //. ruleRev;
        
        (* Delete 1 -> 1 *)
        polys = DeleteCases[polys, 1 -> 1];
        
    ];

    (* Return polys? *)
    If[ Not[ReturnRules /. {opts} /. Options[ReturnRules]],
        polys = polys /. Rule -> Subtract
    ];
      
    Return[polys];
  ];

  NCMakeGB[p_, iter_Integer:4, opts___Rule] := 
    NCMakeGB[{p}, iter, opts];
      
  (* NCProcess *)
  NCProcess[p_List, iter_Integer:4, opts___Rule] := Module[
    {gb, order, knowns, unknowns,
     solved, unsolved, count, digest,
     printReport = True},
      
    gb = NCMakeGB[p, iter, opts];
      
    (* Retrieve order *)
    order = GetMonomialOrder[];
    knowns = First[order];
    unknowns = Flatten[Rest[order]];
     
    (*
    Print["knowns = ", knowns];
    Print["unknowns = ", unknowns];
    *)

    (* Equations solved for *)
    solved = Cases[gb, Rule[s_Symbol, a_] -> (s -> a)];
    gb = Complement[gb, solved];

    (* Equations involving unknowns *)
    unsolved = Map[Union[Cases[#, Alternatives @@ unknowns, 
                               {0, Infinity}]]&, gb];
    count = Map[Length, unsolved];

    (*  
    Print["gb = ", gb];
    Print["unsolved = ", unsolved];
    Print["count = ", count];
    *)
      
    digest ={solved, 
             {0,Pick[gb, count, 0]}, 
             {1,Pick[gb, count, 1]}, 
             {2,Pick[gb, count, 2]},
             {Infinity,Pick[gb, count, _?(# > 2&)]}};

    If[ printReport, 
        Print["* * * * * * * * * * * * * * * *"];
        Print["*      NCProcess  Report      *"];
        Print["* * * * * * * * * * * * * * * *"];
        Print["> Current order:"];
        Print[PrintMonomialOrder[]];
        Print["> The following variables have been solved for:"];
        Print[ColumnForm[digest[[1]]]];
        Print["> The following relations do not involve any unknowns:"];
        Print[ColumnForm[digest[[2,2]]]];
        Print["> The following relations involve 1 unknown:"];
        Print[ColumnForm[digest[[3,2]]]];
        Print["> The following relations involve 2 unknowns:"];
        Print[ColumnForm[digest[[4,2]]]];
        Print["> The following relations involve more than 2 unknowns:"];
        Print[ColumnForm[digest[[5,2]]]];
    ];
      
    Return[digest];
      
  ];
                              
  NCProcess[p_, iter_Integer:4, opts___Rule] := 
    NCProcess[{p}, iter, opts];
    
  (* NCGBSimplifyRational *)
                              
  NCGBSimplifyRational[expr_, iter_Integer:5, opts___Rule] := Module[
    {symbols, rats, rules},
      
    (* TODO Add custom invertibility *)
      
    symbols = DeleteCases[NCGrabSymbols[expr], _?CommutativeQ];
    rats = Join[
        NCGrabFunctions[expr, inv],
        Rationals /. {opts} /. Rationals -> {}
    ];
      
    (*
    Print["rats = ", rats];
    Print["symbols = ", symbols];
    *)
    
    SetMonomialOrder[symbols, rats];
    rules = NCMakeGB[{}, iter, VerboseLevel -> 0, opts];

    (* Print["rules = ", rules]; *)
      
    Return[Simplify[NCReplaceRepeated[expr, rules]]];
      
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
