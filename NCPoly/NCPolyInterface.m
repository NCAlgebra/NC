(*  NCPolyInterface.m                                                      *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: February 2017                                                  *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyInterface`",
              "NCPoly`",
              "NCDot`",
              "NCReplace`",
              "NCUtil`",
	      "NonCommutativeMultiply`" ];

Clear[NCToNCPoly,
      NCPolyToNC,
      NCRuleToPoly,
      NCToRule,
      NCReduce,
      NCReduceRepeated,
      NCMonomialList,
      NCCoefficientRules,
      NCCoefficientList,
      NCCoefficientQ,
      NCMonomialQ,
      NCPolynomialQ];

Get["NCPolyInterface.usage", CharacterEncoding->"UTF8"];

Begin["`Private`"];

  (* NCRuleToPoly *)
  NCRuleToPoly[exp_Rule] := exp[[1]] - exp[[2]];
  NCRuleToPoly[exp_List] := Map[NCRuleToPoly, exp];

  (* NCToRule *)
  NCToRule[exp_, vars_] := Map[NCPolyToNC[#, vars]&, NCPolyToRule[NCToNCPoly[exp, vars]]];
  NCToRule[exp_List, vars_] := Map[NCToRule[#, vars]&, exp];

  (* NCToNCPoly *)
  Clear[NonCommutativeMultiplyToList];
  NonCommutativeMultiplyToList[exp_NonCommutativeMultiply] :=
    Flatten[List @@ exp /. Power[x_, n_?Positive] :> Table[x, n]];
  
  Clear[GrabFactors];
  GrabFactors[exp_?CommutativeQ] := {exp, {}};
  GrabFactors[a_. exp_NonCommutativeMultiply] := {a, NonCommutativeMultiplyToList[exp]};
  GrabFactors[a_. Power[x_?NCNonCommutativeSymbolOrSubscriptQ, n_?Positive]] := {a, Table[x,n]};
  GrabFactors[a_. Power[x_?NCNonCommutativeSymbolOrSubscriptQ, n_?Negative]] := (Message[NCPoly::NotPolynomial]; {0, $Failed});
  GrabFactors[a_. exp_?NCNonCommutativeSymbolOrSubscriptQ] := {a, {exp}};
  (* GrabFactors[a_. exp:(Subscript[_Symbol?NonCommutativeQ,___])] := {a, {exp}}; *)
  GrabFactors[_] := (Message[NCPoly::NotPolynomial]; {0, $Failed});

  Clear[GrabTerms];
  GrabTerms[x_Plus] := List @@ x;
  GrabTerms[x_] := {x};

  NCToNCPoly[exp_List, vars_] := 
    Map[NCToNCPoly[#, vars]&, exp];

  NCToNCPoly[expr_, Vars_] := Module[
    {exp = expr, vars = Vars,
     terms, factors, 
     tps, tpVars, ruleTp,
     ajs, ajVars, ruleAj,
     tmp, opts = {}},
    
    (* Grab tp's *)
    tps = NCGrabFunctions[vars, tp];
    If[ tps =!= {}
       ,
        (* Create one new variable for each tp *)
        tpVars = Table[Unique["tp"], Length[tps]];
        SetNonCommutative[tpVars];

        (* Replace tp's with tpVars *)
        tmp = Intersection[Map[tp, tps], Flatten[vars]];
        If[ tmp =!= {},
            AppendTo[opts, 
                     TransposePairs -> 
                       Transpose[{tmp, 
                                  tmp /. Thread[Map[tp, tps] -> tpVars]}]];
        ];
        ruleTp = Thread[tps -> tpVars];
        exp = exp /. ruleTp;
        vars = vars /. ruleTp;
        
        (*
        Print["tpVars = ", tpVars];
        Print["ruleTp = ", ruleTp];
        Print["opts = ", opts];
        *) 
        
    ];
      
    (* Grab aj's *)
    ajs = NCGrabFunctions[vars, aj];
    If[ ajs =!= {}
       ,
        (* Create one new variable for each aj *)
        ajVars = Table[Unique["aj"], Length[ajs]];
        SetNonCommutative[ajVars];

        (* Replace aj's with ajVars *)
        tmp = Intersection[Map[aj, ajs], Flatten[vars]];
        If[ tmp =!= {},
            AppendTo[opts, 
                     SelfAdjointPairs -> 
                       Transpose[{tmp, 
                                  tmp /. Thread[Map[aj, ajs] -> ajVars]}]];
        ];
        ruleAj = Thread[ajs -> ajVars];
        exp = exp /. ruleAj;
        vars = vars /. ruleAj;
        
        (*
        Print["ajVars = ", ajVars];
        Print["ruleAj = ", ruleAj];
        Print["opts = ", opts];
        *) 
        
    ];

    (* Expand and check *)
    terms = ExpandNonCommutativeMultiply[exp];
    If[ !NCPolynomialQ[terms],
        Message[NCPoly::NotPolynomial];
        Return[$Failed];
    ];
    
    (*
    Print["terms = ", GrabTerms[terms]];
    Print["factors = ", Map[GrabFactors, GrabTerms[terms]]];
    *)

    Check[
      factors = Map[GrabFactors, 
                    GrabTerms[terms]];
     ,
      Return[$Failed]
     ,
      {NCPoly::NotPolynomial}
    ];

    (* Check for inverses; by now all remaining powers are negative *)
    If[ !FreeQ[factors[[All,2]], Power],
        Message[NCPoly::NotPolynomial];
        Return[$Failed];
    ];

    (*
    Print["terms = ",  GrabTerms[terms]];
    Print["factors = ", factors]; 
    Print["vars = ", vars]; 
    Print["opts = ", opts];
    *)
      
    Return[NCPoly @@ Join[Transpose[factors], {vars}, opts]];
      
  ];

  (* NCPolyToNC *)

  NCPolyToNC[exp_?NumericQ, vars_] := exp;

  NCPolyToNC[exp_NCPoly, vars_] := 
    NCPolyDisplay[exp, vars, Plus, Identity] /. Dot -> NonCommutativeMultiply;

  NCPolyToNC[exp_List, vars_] := 
    Map[NCPolyToNC[#, vars]&, exp];

  NCPolyToNC[exp_SparseArray?MatrixQ, vars_] :=
    Map[NCPolyToNC[#, vars]&, exp, {2}];

  NCPolyToNC[exp_SparseArray, vars_] :=
    Map[NCPolyToNC[#, vars]&, exp];

  (* NCMonomialList *)
    
  NCMonomialList[expr_, vars_] := Module[
      {poly},
      poly = NCToNCPoly[expr, vars];
      Return[
        Apply[NonCommutativeMultiply, 
              Map[Part[Flatten[vars], #]&, 
                  NCPolyGetDigits[poly] + 1] /. {} -> 1, 1]];
  ];

  (* NCCoefficientList *)
  
  NCCoefficientList[expr_, vars_] := Module[
      {poly},
      poly = NCToNCPoly[expr, vars];
      Return[NCPolyGetCoefficients[poly]];
  ];

  (* NCCoefficientRules *)

  NCCoefficientRules[expr_, vars_] := Module[
      {poly},
      poly = NCToNCPoly[expr, vars];
      Return[
        Thread[
          Rule[
            Apply[NonCommutativeMultiply, 
                  Map[Part[Flatten[vars], #]&, 
                      NCPolyGetDigits[poly] + 1] /. {} -> 1, 1],
            NCPolyGetCoefficients[poly]]]];
  ];

  (* NCCoefficientQ *)
  Clear[NCCoefficientQAux];
  (* NOT NECESSARY: *)
  (*
  NCCoefficientQAux[_?NumericQ] := True;
  NCCoefficientQAux[a_Symbol /; CommutativeQ[a]] := True;
  NCCoefficientQAux[_] := False;
  
  NCCoefficientQ[HoldPattern[Times[__?NCCoefficientQAux]]] := True;
  NCCoefficientQ[_?NCCoefficientQAux] := True;
  NCCoefficientQ[_] := False;
  *)
  NCCoefficientQ[a_] := CommutativeQ[a];

  (* NCMonomialQ *)
  NCMonomialQ[HoldPattern[NonCommutativeMultiply[(Power[_?NCNonCommutativeSymbolOrSubscriptQ, _.])..]]] := True;
  NCMonomialQ[Power[x_?NCSymbolOrSubscriptQ, _Integer?Positive] /; NonCommutativeQ[x]] := True;
  NCMonomialQ[x_?NCSymbolOrSubscriptQ /; NonCommutativeQ[x]] := True;
  (*
  NCMonomialQ[Subscript[x_Symbol,___] /; NonCommutativeQ[x]] := True;
  *)
  NCMonomialQ[a_?NCCoefficientQ b_] := NCMonomialQ[b];
  (*
  NCMonomialQ[a_?NCCoefficientQ HoldPattern[NonCommutativeMultiply[(_Symbol|Subscript[_Symbol,___])..]]] := True;
  NCMonomialQ[a_?NCCoefficientQ x_Symbol /; NonCommutativeQ[x]] := True;
  NCMonomialQ[a_?NCCoefficientQ Subscript[x_Symbol,___] /; NonCommutativeQ[x]] := True;
   *)
  NCMonomialQ[a_?NCCoefficientQ] := True;
  NCMonomialQ[expr_] := False;

  (* NCPolynomialQ *)
  Clear[NCPolynomialQAux];
  NCPolynomialQAux[expr_?NCMonomialQ] := True;
  NCPolynomialQAux[HoldPattern[Plus[__?NCMonomialQ]]] := True;
  NCPolynomialQAux[_] := False;
  
  NCPolynomialQ[expr_?NCPolynomialQAux] := True;
  NCPolynomialQ[expr_] := NCPolynomialQAux[ExpandNonCommutativeMultiply[expr]];

  (* NCReduce *)
  NCReduce[g_, vars_, options:OptionsPattern[NCPolyReduce]] :=
    NCPolyToNC[NCPolyReduce[NCToNCPoly[g, vars], options], vars];
  NCReduce[f_, g_, vars_, options:OptionsPattern[NCPolyReduce]] :=
    NCPolyToNC[NCPolyReduce[NCToNCPoly[f, vars], NCToNCPoly[g, vars], options], vars];

  (* NCReduceRepeated *)
  NCReduceRepeated[g_, vars_, options:OptionsPattern[NCPolyReduce]] :=
    NCPolyToNC[NCPolyReduceRepeated[NCToNCPoly[g, vars], options], vars];

End[]
EndPackage[]
