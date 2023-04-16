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

Clear[NCMonomialOrder,
      NCMonomialOrderQ,
      NCToNCPoly,
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
      NCPolynomialQ,
      NCRationalToNCPoly];

Get["NCPolyInterface.usage", CharacterEncoding->"UTF8"];

NCMonomialOrder::InvalidOrder = "Order `1` is invalid.";
NCRationalToNCPoly::AdditionalRelations = "Relations `1` were not found in the current ordering and have been added to the list of relations. Explicitly add them to the monomial order to control their ordering.";
NCRationalToNCPoly::MissingSymbol = "Symbols `1` appear in the relations but not on the monomial order.";
NCRationalToNCPoly::CommutativeSymbols = "Commutative symbols `1` have been removed from the monomial order.";
NCRationalToNCPoly::UnknownFunction = "Functions `1` cannot yet be understood by NCRationalToNCPoly.";

Begin["`Private`"];

  (* NCMonomialOrderQ *)
  Clear[NCMonomialOrderQAux];
  (* OLD VERSION
     NCMonomialOrderQAux[(_?NCSymbolOrSubscriptExtendedQ|Power[_?NonCommutativeQ,-1])..] := True;
     NCMonomialOrderQAux[___] := False;
     NCMonomialOrderQ[order___List] := And @@ Apply[NCMonomialOrderQAux, order, {1}];
     NCMonomialOrderQ[___] := False;
  *)
  
  NCMonomialOrderQAux = Function[x,
      (NCSymbolOrSubscriptExtendedQ[x] ||
       MatchQ[x, Power[_?NonCommutativeQ, -1]])];
  
  NCMonomialOrderQ[order_List] := And @@ Map[VectorQ[#, NCMonomialOrderQAux]&, order];
  NCMonomialOrderQ[___] := False;

  (* NCMonomialOrder *)
  NCMonomialOrder[m___] := Module[
    {order},
    order = Map[If[Head[#] === List, #, {#}]&, {m}];
    Return[
      If[ NCMonomialOrderQ[order],
          order,
          Message[NCMonomialOrder::InvalidOrder, order];
          $Failed
      ]
    ];
  ];

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

  (* NCRationalToNCPoly *)

  Clear[NCRationalToNCPolyAux];
  NCRationalToNCPolyAux[invs_] := Module[
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

  (* NCRationalToNCPoly *)
  NCRationalToNCPoly[Polys_List, Vars_List] := Module[
    {polys=NCExpandExponents[Polys], vars=Vars, m=Length[p], symbols, rules, labels,
     invs, 
     ratVars, ruleRat, newRels, ruleRev,
     relInvs, ii, varInvs,
     relRatVars, relNewRels, relRuleRat, relRuleRatRev,
     tps, tpVars, ruleTp, ruleTpRev},

    (* Initializa polys and vars *)
    symbols = NCGrabNCSymbols[polys];

    (*
    Print["polys = ", polys];
    Print["vars = ", vars];
    Print["symbols = ", symbols];
    *)
      
    (* Look for symbols in polys *)
    If[ Complement[symbols, Flatten[vars]] =!= {},
        Message[NCRationalToNCPoly::MissingSymbol, 
                Complement[symbols, Flatten[vars]]];
        Return[{$Failed, {}, {}, {}}];
    ];
      
    (* Look for tp and aj in relations *)
    tps = Union[NCGrabFunctions[vars, tp|aj],
                NCGrabFunctions[polys, tp|aj]];
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

    (* Process monomial order for rationals in variables *)
    invs = Cases[vars, Power[_,-1], {2}];

    (*
    Print["vars = ", vars];
    Print["invs = ", invs];
    *)
      
    If[ invs =!= {},

        (* Process invs *)
        {ratVars, newRels, ruleRat, ruleRev} = NCRationalToNCPolyAux[invs];
        
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

    (* Process relations for rationals in polys and 
       remaining relations in vars *)
    relInvs = Union[
        DeleteCases[NCGrabFunctions[polys, inv], Power[_?CommutativeQ,_]],
        NCGrabFunctions[vars, inv]
    ];

    (* Print["relInvs = ", relInvs]; *)
      
    If[ relInvs =!= {},
        
        (* invs of letters in the order will be treated last *)
        varInvs = DeleteCases[Pick[vars,
                                   Map[MatchQ[#, If[ Length[relInvs] > 1,
                                                     Alternatives @@ relInvs,
                                                     relInvs[[1]] ]]&, 
                                              Map[inv, vars, {2}]]], tp[], {2}];
        
        If[ Flatten[varInvs] =!= {},
        
            varInvs = Map[inv, varInvs, {2}];
            
            (* Insert inv's after corresponding variable *)
            vars = DeleteCases[Riffle[vars, varInvs], 
                               {}, {1}];
            labels = vars /. ruleRev;
            varInvs = Flatten[varInvs];
            
            (* Warn user *)
            Message[NCRationalToNCPoly::AdditionalRelations, varInvs];
            
            (* Process varInvs *)
            {relRatVars, relNewRels, 
             relRuleRat, relRuleRatRev} = NCRationalToNCPolyAux[varInvs];

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
            Message[NCRationalToNCPoly::AdditionalRelations, 
                    Flatten[relInvs] //. ruleRev];
            
            (* Process varInvs *)
            {relRatVars, relNewRels, 
             relRuleRat, relRuleRatRev} = NCRationalToNCPolyAux[relInvs];

            (* Replace inv's with ratVars *)
            polys = Join[polys //. relRuleRat, relNewRels //. relRuleRat];
            vars = Join[vars, {relRatVars}];
            labels = Join[labels, {relInvs} //. ruleRev];

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
      
    (* Any other functions in polys? *)
    symbols = DeleteCases[NCGrabFunctions[polys], _?CommutativeQ|Power[_?NCNonCommutativeSymbolOrSubscriptQ, n_Integer?Positive]];
    If[ symbols =!= {},
        Message[NCRationalToNCPoly::UnknownFunction, symbols];
        Return[{$Failed, {}, {}, {}}];
    ];

    (* Any noncommutative symbols not in vars? *)
    symbols = Complement[NCGrabNCSymbols[polys], Flatten[vars]];
    If[ symbols =!= {},
        Message[NCRationalToNCPoly::MissingSymbol, symbols];
        Return[{$Failed, {}, {}, {}}];
    ];

    (* Any commutative symbols in vars? *)
    symbols = DeleteCases[Flatten[vars], _?NonCommutativeQ];
    If[ symbols =!= {},
        vars = DeleteCases[DeleteCases[vars, _?CommutativeQ, {2}], {}];
        Message[NCRationalToNCPoly::CommutativeSymbols, symbols];
    ];

    (*
    Print["polys = ", polys];
    Print["vars = ", vars];
    Print["labels = ", labels];
    Print["rulesRev = ", ruleRev];
    Print["ZEROS = ", Replace[p, a_Rule | a_Equal :> Subtract @@ a, {1}] - DeleteCases[polys[[1;;Length[p]]] //. ruleRev, 0]];
    *)
      
    (* Convert to NCPoly *)
    polys = NCToNCPoly[polys, vars];
      
    (*
    Print["polys = ", polys]; 
    Print["polys = ", NCPolyDisplay[polys, vars]]; 
    *)

    Return[{polys, vars, ruleRev, labels}];
  ];

  NCRationalToNCPoly[poly_, vars_List] := NCRationalToNCPoly[{poly}, vars];

End[]
EndPackage[]
