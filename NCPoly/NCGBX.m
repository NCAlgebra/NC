(*  NCPolyInterface.m                                                      *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCGBX`",
	      "NCPolyGroebner`",
	      "NCPoly`",
	      "NonCommutativeMultiply`" ];

Clear[NCToPoly];
NCToPoly::usage="NCToPoly[exp, var] constructs a noncommutative polynomial object in variables var from the NC expression exp. For example, NCToPoly[x**y - 2 y**z, {x, y, z}] constructs an object associated with the noncommutative polynomial x y - 2 y z in variables x, y and z. The internal representation is so that the terms are sorted according to a degree-lexicographic order in vars. In the above example, x < y < z.\nIMPORTANT: This command requirest that both NCAlgebra and some implementation of NCPoly be loaded.";

Clear[PolyToNC];
PolyToNC::usage="PolyToNC[exp, vars] constructs an NC expression from the noncommutative polynomial object exp in variables var. Monomials are specified in terms of the symbols in the list var.\nIMPORTANT: This command requirest that both NCAlgebra and some implementation of NCPoly be loaded.";

Clear[SetMonomialOrder];
SetMonomialOrder::usage="";

Clear[GetMonomialOrder];
GetMonomialOrder::usage="";

Clear[SetKnowns];
SetKnowns::usage="";

Clear[SetUnknowns];
SetUnknowns::usage="";

Clear[NCMakeGB];
NCMakeGB::usage="";

Clear[NCReduce];
NCReduce::usage="";

Clear[NCRuleToPoly];
NCRuleToPoly::usage="";

Begin["`Private`"];

  Clear[$NCPolyInterfaceMonomialOrder];
  $NCPolyInterfaceMonomialOrder = {};

  (* NCRuleToPoly *)
  NCRuleToPoly[exp_Rule] := exp[[1]] - exp[[2]];
  NCRuleToPoly[exp_List] := Map[NCRuleToPoly, exp];

  (* NCToPoly *)

  Clear[GrabFactors];
  GrabFactors[Times[a_, exp_NonCommutativeMultiply]] := {a, List @@ exp};
  GrabFactors[exp_NonCommutativeMultiply] := {1, List @@ exp};
  GrabFactors[Times[a_, exp_]] := {a, {exp}};
  GrabFactors[exp_?NumberQ] := {exp, {}};
  GrabFactors[exp_] := {1, {exp}};

  Clear[GrabTerms];
  GrabTerms[x_Plus] := List @@ x;
  GrabTerms[x_] := {x};

  NCToPoly[exp_List, vars_] := 
    Map[NCToPoly[#, vars]&, exp];

  NCToPoly[exp_Rule, vars_] := 
    NCToPoly[exp[[1]] - exp[[2]], vars];

  NCToPoly[exp_Equal, vars_] := 
    NCToPoly[exp[[1]] - exp[[2]], vars];

  NCToPoly[exp_, vars_] := 
    NCPoly @@ Append[Transpose[Map[GrabFactors, GrabTerms[ExpandNonCommutativeMultiply[exp]]]], vars];


  (* PolyToNC *)

  PolyToNC[exp_?NumericQ, vars_] := exp;

  PolyToNC[exp_NCPoly, vars_] := 
    NCPolyDisplay[exp, vars, Plus, Identity] /. Dot -> NonCommutativeMultiply;

  PolyToNC[exp_List, vars_] := 
    Map[PolyToNC[#, vars]&, exp];

  (* NCGB Interface *)

  (* This function erases all elements on current monomial order list *)
  SetKnowns[m___] := $NCPolyInterfaceMonomialOrder = {Flatten[{m}]};

  SetUnknowns[m___] := Module[{},
    (* Erase all elements but first *)
    If [Length[$NCPolyInterfaceMonomialOrder] > 0,
       $NCPolyInterfaceMonomialOrder = {First[$NCPolyInterfaceMonomialOrder]};
    ];
    (* Install unknowns *)
    $NCPolyInterfaceMonomialOrder 
      = Map[Flatten, Join[$NCPolyInterfaceMonomialOrder, Map[List, {m}]]];
  ];

  SetMonomialOrder[m___] := ($NCPolyInterfaceMonomialOrder = Map[Flatten, Map[List, {m}]]);

  GetMonomialOrder[] := $NCPolyInterfaceMonomialOrder;

  NCMakeGB[p_List, iter_Integer, opts___Rule] := Module[
    {polys, basis, rules, labels},

    polys = NCToPoly[p, $NCPolyInterfaceMonomialOrder];
    basis = Sort[ 
              NCPolyReduce[ 
                NCPolyGroebner[polys, iter, opts,
                               Labels -> $NCPolyInterfaceMonomialOrder],
                True]
            ];
    rules = NCPolyToRule[basis];

    Return[Map[PolyToNC[#, $NCPolyInterfaceMonomialOrder]&, rules, {2}]];
  ];

  NCReduce[f_List, g_List, complete_:False] := Module[
    {fpolys, gpolys},

    fpolys = NCToPoly[f, $NCPolyInterfaceMonomialOrder];
    gpolys = NCToPoly[g, $NCPolyInterfaceMonomialOrder];

    rules = NCPolyToRule[NCPolyReduce[fpolys, gpolys, complete]];

    Return[Map[PolyToNC[#, $NCPolyInterfaceMonomialOrder]&, rules, {2}]];

  ];

  NCReduce[g_List, complete_:False] := Module[
    {gpolys},

    gpolys = NCToPoly[g, $NCPolyInterfaceMonomialOrder];

    rules = NCPolyToRule[NCPolyReduce[gpolys, complete]];

    Return[Map[PolyToNC[#, $NCPolyInterfaceMonomialOrder]&, rules, {2}]];

  ];

End[]
EndPackage[]
