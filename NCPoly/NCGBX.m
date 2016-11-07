(*  NCPolyInterface.m                                                      *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCGBX`",
	      "NCPolyGroebner`",
	      "NCPoly`",
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

SetMonomialOrder::InvalidOrder = "Order `1` is invalid."

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

  NCToNCPoly[exp_Rule, vars_] := 
    NCToNCPoly[exp[[1]] - exp[[2]], vars];

  NCToNCPoly[exp_Equal, vars_] := 
    NCToNCPoly[exp[[1]] - exp[[2]], vars];

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

    Print["factors = ", factors];
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
 
  SetMonomialOrder[m_List, level_Integer] := (
    $NCPolyInterfaceSetKnowns = False;
    $NCPolyInterfaceMonomialOrder = 
      AddElementToList[$NCPolyInterfaceMonomialOrder, level, Flatten[m]]
  );

  SetMonomialOrder[m___] := (
    ( $NCPolyInterfaceSetKnowns = False;
      $NCPolyInterfaceMonomialOrder = Map[Flatten, Map[List, {m}]] )
    /; Depth[{m}] <= 3
  );
        
  SetMonomialOrder[m___] := 
    (Message[SetMonomialOrder::InvalidOrder,{m}]; $Failed);
  
  GetMonomialOrder[] := $NCPolyInterfaceMonomialOrder;

  PrintMonomialOrder[] := NCPolyDisplayOrder[$NCPolyInterfaceMonomialOrder];

  ClearMonomialOrder[] := (
    $NCPolyInterfaceSetKnowns = False;
    $NCPolyInterfaceMonomialOrder = {};
  );
  
  NCMakeGB[p_List, iter_Integer, opts___Rule] := Module[
    {polys, basis, rules, labels},

    polys = NCToNCPoly[p, $NCPolyInterfaceMonomialOrder];
    basis = Sort[ 
              NCPolyReduce[ 
                NCPolyGroebner[polys, iter, opts,
                               Labels -> $NCPolyInterfaceMonomialOrder],
                True]
            ];
    rules = NCPolyToRule[basis];

    Return[Map[NCPolyToNC[#, $NCPolyInterfaceMonomialOrder]&, rules, {2}]];
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
