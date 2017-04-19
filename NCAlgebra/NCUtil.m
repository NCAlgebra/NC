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
      NCGrabFunctions,
      NCGrabIndeterminants,
      NCVariables,
      NCConsolidateList,
      NCConsistentQ,
      NCSymbolOrSubscriptQ,
      NCLeafCount,
      NCReplaceData,
      NCToExpression];

Get["NCUtil.usage"];

Begin["`Private`"];

  Needs["NonCommutativeMultiply`"];
             
  NCSymbolOrSubscriptQ[_Symbol] := True;
  NCSymbolOrSubscriptQ[Subscript[_Symbol,__]] := True;
  NCSymbolOrSubscriptQ[_] := False;
  
  NCGrabSymbols[expr_SparseArray] := NCGrabSymbols[expr["NonzeroValues"]];
  NCGrabSymbols[expr_SparseArray, pattern_] := 
      NCGrabSymbols[expr["NonzeroValues"], pattern];

  (* Free of Subscripts? That's simple *)
  NCGrabSymbols[expr_] := Union[Cases[expr, _Symbol, {0, Infinity}]] /; FreeQ[expr, Subscript];
  
  (* Otherwise need to worry about Subscripts
     Solution here is inspired by the discussion at:
     http://mathematica.stackexchange.com/questions/91256/matching-symbol-or-subscript-but-not-symbol-arguments-of-subscript
  *)
  NCGrabSymbols[expr_] := 
    Union[Flatten[Reap[NCGrabSymbols[expr /. Subscript[a_Symbol, b___] :> (Sow[Subscript[a, b]]; ##&[])]]]];
  
  NCGrabSymbols[expr_, pattern_] := 
    Union[Cases[expr, (pattern)[_Symbol|Subscript[_Symbol,___]], {0, Infinity}]];
    
  (* Grab functions *)
  NCGrabFunctions[expr_SparseArray] := NCGrabFunctions[expr["NonzeroValues"]];
  NCGrabFunctions[expr_SparseArray, f_] := 
      NCGrabFunctions[expr["NonzeroValues"], f];
    
  NCGrabFunctions[expr_] :=
    Union[Cases[expr, (Except[Plus|Times|NonCommutativeMultiply|List|Subscript])[__], {0, Infinity}]];
  NCGrabFunctions[expr_, f_] :=
    Union[Cases[expr, (f)[__], {0, Infinity}]];

  (*
  NCGrabIndeterminants[expr_] := Union[NCGrabSymbols[expr], 
                                       NCGrabFunctions[expr]];
 
  *)
  
  NCGrabIndeterminants[expr_SparseArray] := 
      NCGrabIndeterminants[expr["NonzeroValues"]];
  
  NCGrabIndeterminants[x_Rule] := 
    NCGrabIndeterminants[Apply[List,x]];

  NCGrabIndeterminants[x_Power] := NCGrabIndeterminants[x[[1]]];

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
                  inv -> Inverse,
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
