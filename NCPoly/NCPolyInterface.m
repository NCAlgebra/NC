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
      NCMonomialList,
      NCCoefficientRules,
      NCCoefficientList,
      NCVariables];

Get["NCNCPoly.usage"];

Begin["`Private`"];

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

  (* NCVariables *)

  NCVariables[expr_] := DeleteCases[NCGrabSymbols[expr], _?CommutativeQ];
  
End[]
EndPackage[]
