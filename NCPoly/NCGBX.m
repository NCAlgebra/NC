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
      NCProcess];

Get["NCGBX.usage", CharacterEncoding->"UTF8"];

Clear[ReturnRules];
Options[NCMakeGB] = {
  ReturnRules -> True,
  ReturnGraph -> False,
  ReduceBasis -> True
};

Options[NCProcess] = {
  MaxDigest -> 2,
  InfiniteDigest -> True,
  PrintReport -> True,
  GridOptions -> {
      Alignment -> {{Right, Left}}, 
      Background -> {None, {{LightGray, LightYellow}} }
  }
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
  CheckOrderAux[(_?NCSymbolOrSubscriptQ|Power[_,-1]|(tp|aj)[_?NCSymbolOrSubscriptQ])..] := True;
  CheckOrderAux[___] := False;

  Clear[CheckOrder];
  CheckOrder[order___] := And @@ Apply[CheckOrderAux, order, {1}];
  
  SetMonomialOrder[m_List, level_Integer] := (
    $NCPolyInterfaceSetKnowns = False;
    $NCPolyInterfaceMonomialOrder = 
      AddElementToList[$NCPolyInterfaceMonomialOrder, level, Flatten[m]]
  );

  SetMonomialOrder[m___] := (
    $NCPolyInterfaceSetKnowns = False;
    $NCPolyInterfaceMonomialOrder = NCMonomialOrder[m]
  );

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
    {polys, vars, symbols, basis, graph, rules, labels,
     invs, 
     ratVars, ruleRat, newRels, ruleRev,
     relInvs, ii, varInvs,
     relRatVars, relNewRels, relRuleRat, relRuleRatRev,
     tps, tpVars, ruleTp, ruleTpRev,
     returnGraph, returnRules, reduceBasis},

    (* Options *)
    {returnGraph, returnRules, reduceBasis} =
     {ReturnGraph, ReturnRules, ReduceBasis} /. {opts} /. Options[NCMakeGB];
      
    (* Initializa polys and vars *)
    polys = Replace[p, a_Rule | a_Equal :> Subtract @@ a, {1}];
    vars = $NCPolyInterfaceMonomialOrder;

    (*
    Print["polys = ", polys];
    Print["vars = ", vars];
    *)
    
    (* Convert rational to NCPoly *)
    Check[
      {polys, vars, ruleRev, labels} = NCRationalToNCPoly[polys, vars];
     ,
      Return[$Failed];
     ,
      {
	NCRationalToNCPoly::MissingSymbol,
	NCRationalToNCPoly::CommutativeSymbols,
	NCRationalToNCPoly::UnknownFunction
      }
    ];
    
    (* Calculate GB *)
    {basis,graph} = NCPolyGroebner[polys, iter, opts, Labels -> labels];

    (* Reduce Basis? *)
    (* TODO: THIS WILL INVALIDATE THE GRAPH! *)
    If[ reduceBasis,
        If[ returnGraph,
            Message["THIS WILL INVALIDATE GRAPH!"];
        ];
        basis = Sort[NCPolyReduce[basis, Complete->True]];
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
    If[ Not[returnRules],
        polys = polys /. Rule -> Subtract
    ];

    Return[
      If[ returnGraph
         ,
          {polys,graph}
         ,
          polys
      ]
    ];

  ];

  NCMakeGB[p_, iter_Integer:4, opts___Rule] := 
    NCMakeGB[{p}, iter, opts];

  (* NCProcess *)

  PrintEntry[n_] := Map[ToString[#] <> "." &, Range[n]];
  
  PrintDigestAux[index_, gb_, unsolved_] := (

    (* Header *)
    If[ index =!= {},
        Print["+ in unknowns ", index, ":"];
    ];

    (* Print relations *)
    Print[Grid[Transpose[{PrintEntry[Length[unsolved[index]]], 
                          Part[gb, unsolved[index]]}],
               Sequence @@ (GridOptions /. Options[NCProcess, GridOptions])]];
  );

  PrintDigest[digest_, gb_, unsolved_, i_] := (

    (* Quick Return *)
    If[ digest[i] === {}, Return[] ];
      
    (* Header *)
    Print["> The following relations involve " 
          <> ToString[i] <> " unknown" <> If[i > 1, "s:", ":"]];
      
    (* Digest per group *)
    Map[PrintDigestAux[#, gb, unsolved]&, digest[i]];
                   
  );
  
  NCProcess[p_List, iter_Integer:4, opts___Rule] := Module[
    {gb, order, knowns, unknowns,
     solved, unsolved, count, digest,
     printReport, maxDigest, infiniteDigest, gridOptions,
     notSolved
     },
      
    (* NCProcessOptions *)
    printReport = PrintReport /. {opts} /. Options[NCProcess, PrintReport];
    maxDigest = MaxDigest /. {opts} /. Options[NCProcess, MaxDigest];
    infiniteDigest = InfiniteDigest /. {opts} /. Options[NCProcess, InfiniteDigest];
    gridOptions = Sequence @@ (GridOptions /. {opts} /. Options[NCProcess, GridOptions]);
      
    (* Call NCMakeGB *)
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
    solved = Cases[gb, Except[Rule[s_NonCommutativeMultiply, a_]]];
    gb = Complement[gb, solved];

    (* Equations involving unknowns *)
    unsolved = Map[Union[Cases[#, Alternatives @@ unknowns, 
                               {0, Infinity}]]&, gb];
    unsolved = KeySort[Merge[MapIndexed[Rule[#1, #2[[1]]]&, unsolved], Join]];
    count = Map[Length, Keys[unsolved]];

    (* Digest up to maxDigest *)
    digest = <|Table[i -> Pick[Keys[unsolved], count, i], {i,0,maxDigest}]|>;
    
    (* Digest up to Infinity *)
    If[ infiniteDigest, 
        AppendTo[digest, 
                 <| Infinity -> Pick[Keys[unsolved], 
                                     count, _?(#>maxDigest&)] |>];
    ];

    (*
    Print["gb = ", gb];
    Print["unsolved = ", unsolved];
    Print["count = ", count];
    Print["digest = ", digest];
    *)

    If[ printReport, 
        Print["* * * * * * * * * * * * * * * *"];
        Print["*      NCProcess  Report      *"];
        Print["* * * * * * * * * * * * * * * *"];
        Print["> Current order:"];
        Print[PrintMonomialOrder[]];
        
        (* Solved variables *)
        If[ solved =!= {},
            Print["> The following variables have been solved for:"];
            Print[Grid[Transpose[{PrintEntry[Length[solved]], 
                                  solved}],
                       gridOptions,
                       Alignment -> {{Right, Left}}]];
        ];
        
        (* Unsolved variables *)
        notSolved = Complement[Flatten[order], Map[First, solved]];
        If[ notSolved =!= {},
            Print["> The following variables have not been solved for:"];
            Print[Row[notSolved, ","]];
        ];
        
        (* No unknowns *)
        If[ digest[0] =!= {},
            Print["> The following relations do not involve any unknowns:"];
            Map[PrintDigestAux[#, gb, unsolved]&, digest[0]];
        ]
        
        (* Less than MaxDigest *)
        Table[PrintDigest[digest, gb, unsolved, i], {i,1,maxDigest}];
        
        (* Nore than MaxDigest *)
        If[ infiniteDigest && digest[Infinity] =!= {},
            Print["> The following relations involve more than ",
                  maxDigest, " unknowns:"];
            Map[PrintDigestAux[#, gb, unsolved]&, digest[Infinity]];
        ];
    ];
      
      
    (* digest *)
    Return[
      Join[<|"Solved" -> solved |>,
           Map[AssociationMap[gb[[unsolved[#]]]&, #]&, digest] ]
    ];
      
  ];
                              
  NCProcess[p_, iter_Integer:4, opts___Rule] := 
    NCProcess[{p}, iter, opts];
    
  (* NCGBSimplifyRational *)
                              
  NCGBSimplifyRational[expr_, iter_Integer:5, opts___Rule] := Module[
    {symbols, rats, rules},
      
    (* TODO Add custom invertibility *)
      
    symbols = NCGrabNCSymbols[expr];
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

     
End[]
EndPackage[]
