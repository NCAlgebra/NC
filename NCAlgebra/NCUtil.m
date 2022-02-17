(* :Title: 	NCUtil.m *)

(* :Author: 	mauricio *)

(* :Context: 	NCUtil` *)

(* :Summary: 
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage["NCUtil`"];

Clear[NCGrabSymbols,
      NCGrabNCSymbols,
      NCGrabSymbolsInProduct,
      NCGrabFunctions,
      NCGrabIndeterminants,
      NCGrabFirst,
      NCCasesFirst,
      NCVariables,
      NCConsolidateList,
      NCConsistentQ,
      NCSymbolOrSubscriptQ,
      NCNonCommutativeSymbolOrSubscriptQ,
      NCLeafCount,
      NCReplaceData,
      NCToExpression];

Get["NCUtil.usage"];

Begin["`Private`"];

  Needs["NonCommutativeMultiply`"];
             
  NCSymbolOrSubscriptQ[_Symbol|Subscript[_Symbol,__]] := True;
  NCSymbolOrSubscriptQ[_] := False;

  NCNonCommutativeSymbolOrSubscriptQ[x_] := NCSymbolOrSubscriptQ[x] && NonCommutativeQ[x];

  NCGrabFirst[exp_, rule_Rule] := (exp /. rule) /; MatchQ[exp, rule[[1]]];
  NCGrabFirst[exp_, pattern_Pattern] := exp /; MatchQ[exp, pattern];
  NCGrabFirst[exp_, patternOrRule_] := Union[DeleteCases[
    Flatten[NCGrabFirst[#, patternOrRule] & /@ (List @@ exp)], Null]
  ];
  NCGrabFirst[exp_ /; Depth[exp] == 1, rule_Rule] :=
    If[MatchQ[exp, rule[[1]]], exp /. rule, Null];
  NCGrabFirst[exp_ /; Depth[exp] == 1, pattern_Pattern] :=
    If[MatchQ[exp, pattern], exp, Null];

  NCCasesFirst[exp_, rule_Rule] := (exp /. rule) /; MatchQ[exp, rule[[1]]];
  NCCasesFirst[exp_, rule_Rule] := exp[[0]] @@ (NCCasesFirst[#, rule] & /@ (List @@ exp));
  NCCasesFirst[exp_ /; Depth[exp] == 1, rule_Rule] := exp;

  NCGrabSymbols[expr_SparseArray] := NCGrabSymbols[expr["NonzeroValues"]];
  NCGrabSymbols[expr_SparseArray, pattern_] :=
    NCGrabSymbols[expr["NonzeroValues"], pattern];

  (* Free of Subscripts? That's simple *)
  NCGrabSymbols[expr_] :=
    Union[Cases[expr, _Symbol, {0, Infinity}]] /; FreeQ[expr, Subscript];
  
  (* Otherwise need to worry about Subscripts
     Solution here is inspired by the discussion at:
     http://mathematica.stackexchange.com/questions/91256/matching-symbol-or-subscript-but-not-symbol-arguments-of-subscript
  *)
  (* MAURICIO: OCTOBER 2017
     - ##&[] evaluates to -1, hence inv[1 - x_1] throws an error
             and (1 - x_1) ** y gives the wrong error
  NCGrabSymbols[expr_] := 
    Union[Flatten[Reap[NCGrabSymbols[expr /. Subscript[a_Symbol, 
                        b__] :> (Sow[Subscript[a, b]]; ##&[])]]]];
  *)
  NCGrabSymbols[expr_] := 
    Union[Flatten[Reap[NCGrabSymbols[expr /. Subscript[a_Symbol, 
                        b__] :> (Sow[Subscript[a, b]]; Unique[][])]]]];
  
  NCGrabSymbols[expr_, pattern_] := 
    Union[Cases[expr, (pattern)[_?NCSymbolOrSubscriptQ], {0, Infinity}]];

  NCGrabNCSymbols[expr_] :=
    DeleteCases[NCGrabSymbols[expr], _?CommutativeQ];
  NCGrabNCSymbols[expr_, pattern_] :=
    DeleteCases[NCGrabSymbols[expr, pattern], _?CommutativeQ];
    

  (* NCGrabSymbolsInProduct *)
  NCGrabSymbolsInProduct[expr_] :=
    Union[
      Flatten[
        Cases[expr,
          p : (NonCommutativeMultiply[l___, _?NCSymbolOrSubscriptQ, r___]) :>
              Cases[p, _?NCSymbolOrSubscriptQ], {0, Infinity}]
      ]
    ];

  (* Grab functions *)
  NCGrabFunctions[expr_SparseArray] := NCGrabFunctions[expr["NonzeroValues"]];
  NCGrabFunctions[expr_SparseArray, f_] := 
      NCGrabFunctions[expr["NonzeroValues"], f];
    
  NCGrabFunctions[expr_, inv, levelSpec_:{0, Infinity}] :=
    Union[Cases[expr, Power[_, _Integer?Negative], levelSpec]];
  NCGrabFunctions[expr_, f_, levelSpec_:{0, Infinity}] :=
    Union[Cases[expr, (f)[__], levelSpec]];
  NCGrabFunctions[expr_] :=
    Union[Cases[expr, (Except[Plus|Times|NonCommutativeMultiply|List|Subscript])[__], {0, Infinity}]];

  (*
  NCGrabIndeterminants[expr_] := Union[NCGrabSymbols[expr], 
                                       NCGrabFunctions[expr]];
 
  *)
  
  NCGrabIndeterminants[expr_SparseArray] := 
      NCGrabIndeterminants[expr["NonzeroValues"]];
  
  NCGrabIndeterminants[x_Rule] := 
    NCGrabIndeterminants[Apply[List,x]];

  NCGrabIndeterminants[Power[x_,_Integer?Positive]] := NCGrabIndeterminants[x];
  NCGrabIndeterminants[Power[x_,n_Integer?Negative]] := {Power[x, n]};

  NCGrabIndeterminants[x_Equal] := 
    NCGrabIndeterminants[Apply[List,x]];

  NCGrabIndeterminants[x_Plus] := 
    NCGrabIndeterminants[Apply[List,x]];

  NCGrabIndeterminants[x_NonCommutativeMultiply] := 
    NCGrabIndeterminants[Apply[List,x]];

  NCGrabIndeterminants[x_Times] := NCGrabIndeterminants[Apply[List,x]];

  NCGrabIndeterminants[x_List] := Module[
    {asaList},
    asaList = Apply[List,x];
    Return[Apply[Union,Map[NCGrabIndeterminants,asaList]]];
  ];

  NCGrabIndeterminants[c_?NumberQ] := {};

  NCGrabIndeterminants[x_] := {x};

  (* NCVariables *)
  NCVariables[expr_] := Select[NCGrabSymbols[expr], NonCommutativeQ];

  (* NCConsolidateList *)
  
  NCConsolidateList[list_] := Block[
      {basis, index = Range[1, Length[list]]},
      basis = Merge[Thread[list -> index], Identity];
      MapIndexed[(index[[#1]] = #2[[1]])&, Values[basis]];
      Return[{Keys[basis], index}];
  ];
    
  NCConsistentQ[expr_] := 
    Length[Cases[expr, 
            a_?NonCommutativeQ * b_?NonCommutativeQ, {0, Infinity}]] == 0;

  (* NC leaf count *)
  NCLeafCount[x_?PossibleZeroQ] := -Infinity;
  NCLeafCount[x_?NumberQ] := Abs[x];
  NCLeafCount[x_] := -LeafCount[x];
  SetAttributes[NCLeafCount, Listable];

  (* NCReplaceData *)
  NCReplaceData[expr_, data_Rule] := NCReplaceData[expr, {data}];
  NCReplaceData[expr_, {data__Rule}] := ReplaceRepeated[expr, 
    Join[{data}, {tp -> Transpose, 
                  aj -> ConjugateTranspose,
                  Power -> MatrixPower,
                  co -> Conjugate,
                  NonCommutativeMultiply -> Dot}]
  ];
  (* TODO: rt -> *)

  (* NCToExpression *)

  Clear[PlusAux];
  PlusAux[a_?NumberQ, b_?MatrixQ] := 
     a IdentityMatrix[Dimensions[b][[1]]] + b;
  PlusAux[a_?NumberQ, b_?MatrixQ, c__] := 
     PlusAux[a IdentityMatrix[Dimensions[b][[1]]] + b, c];
     
  NCToExpression[expr_, data_] := 
    NCReplaceData[expr /. Plus -> PlusAux, data] /. PlusAux -> Plus;
  
End[];
EndPackage[];
