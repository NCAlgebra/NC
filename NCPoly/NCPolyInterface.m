(*  NCPolyInterface.m                                                      *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: February 2017                                                  *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolyInterface`",
              "NCPoly`",
              "NCReplace`",
              "NCUtil`",
	      "NonCommutativeMultiply`" ];

Clear[NCToNCPoly,
      NCPolyToNC,
      NCRuleToPoly,
      NCMonomialList,
      NCCoefficientRules,
      NCCoefficientList,
      NCCoefficientQ,
      NCMonomialQ,
      NCPolynomialQ];

Get["NCPolyInterface.usage"];

Begin["`Private`"];

  (* NCRuleToPoly *)
  NCRuleToPoly[exp_Rule] := exp[[1]] - exp[[2]];
  NCRuleToPoly[exp_List] := Map[NCRuleToPoly, exp];

  (* NCToNCPoly *)

  Clear[GrabFactors];
  GrabFactors[exp_?CommutativeQ] := {exp, {}};
  GrabFactors[a_. exp_NonCommutativeMultiply] := {a, List @@ exp};
  GrabFactors[a_. exp_Symbol] := {a, {exp}};
  GrabFactors[a_. exp:(Subscript[_Symbol,___])] := {a, {exp}};
  GrabFactors[_] := (Message[NCPoly::NotPolynomial]; {0, $Failed});

  Clear[GrabTerms];
  GrabTerms[x_Plus] := List @@ x;
  GrabTerms[x_] := {x};

  NCToNCPoly[exp_List, vars_] := 
    Map[NCToNCPoly[#, vars]&, exp];

  NCToNCPoly[exp_, vars_] := Module[
    {terms, factors},
    
    (* Expand and check *)
    terms = ExpandNonCommutativeMultiply[exp];
    If[ !NCPolynomialQ[terms],
        Message[NCPoly::NotPolynomial];
        Return[$Failed];
    ];
    
    Check[
      factors = Map[GrabFactors, 
                    GrabTerms[terms]];
     ,
      Return[$Failed]
     ,
      {NCPoly::NotPolynomial}
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
  NCMonomialQ[HoldPattern[NonCommutativeMultiply[(_Symbol|Subscript[_Symbol,___])..]]] := True;
  NCMonomialQ[x_Symbol /; NonCommutativeQ[x]] := True;
  NCMonomialQ[Subscript[x_Symbol,___] /; NonCommutativeQ[x]] := True;
  NCMonomialQ[a_?NCCoefficientQ HoldPattern[NonCommutativeMultiply[(_Symbol|Subscript[_Symbol,___])..]]] := True;
  NCMonomialQ[a_?NCCoefficientQ x_Symbol /; NonCommutativeQ[x]] := True;
  NCMonomialQ[a_?NCCoefficientQ Subscript[x_Symbol,___] /; NonCommutativeQ[x]] := True;
  NCMonomialQ[a_?NCCoefficientQ] := True;
  NCMonomialQ[expr_] := False;

  (* NCPolynomialQ *)
  Clear[NCPolynomialQAux];
  NCPolynomialQAux[expr_?NCMonomialQ] := True;
  NCPolynomialQAux[HoldPattern[Plus[__?NCMonomialQ]]] := True;
  NCPolynomialQAux[_] := False;
  
  NCPolynomialQ[expr_?NCPolynomialQAux] := True;
  NCPolynomialQ[expr_] := NCPolynomialQAux[ExpandNonCommutativeMultiply[expr]];

End[]
EndPackage[]
