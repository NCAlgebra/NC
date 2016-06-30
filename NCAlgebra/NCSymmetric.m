(* :Title: 	NCSymmetric *)

(* :Author: 	mauricio *)

(* :Context: 	NCSymmetric` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCSymmetric`",
              "NCOptions`",
              "NonCommutativeMultiply`",
              "NCMatMult`",
              "NCUtil`" ];

Clear[NCSymmetricQ, NCSymmetricTest, NCSymmetricPart];
      
Get["NCSymmetric.usage"];

NCSymmetricQ::SymmetricVariables =
"The variable(s) `1` was(were) assumed symmetric";

Options[NCSymmetricTest] = {
  SymmetricVariables -> {},
  ExcludeVariables -> {}
};

Begin[ "`Private`" ]

  (* NCSymmetricTest *)
  
  Clear[NCSymmetricTestAux];
  NCSymmetricTestAux[exp_, diff_, zero_, opts:OptionsPattern[{}]] := Module[
      {vars, tpVars, tpDiffVars, symVars, symRule, 
       options, symmetricVars, excludeVars},
      
      (* process options *)

      options = Flatten[{opts}];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCSymmetricTest, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCSymmetricTest, ExcludeVariables];

      (*
      Print["----"];
      Print["options = ", options];
      Print["diff = ", diff];
      Print["zero = ", zero];
      Print["symmetricVars = ", symmetricVars];
      Print["excludeVars = ", excludeVars];
      *)

      (* easy return *)
      If[ diff === zero, Return[{True, {}}] ];
      
      (* check for possible symmetric variables *)
      vars = NCGrabSymbols[exp];

      (* Print["vars = ", vars]; *)

      (* exclude all vars? *)
      excludeVars = If [excludeVars === All
                        , 
                        vars
                        ,
                        Flatten[List[excludeVars]]
                       ];
          
      (* all variables symmetric? *)
      (* symmetric vars have priority *)
      If [symmetricVars === All
          ,  
          symmetricVars = vars;
          excludeVars = {};
          ,
          symmetricVars = Flatten[List[symmetricVars]];
          excludeVars = Complement[excludeVars, symmetricVars];
      ];

      (*
      Print["ExcludeVariables = ", excludeVars];
      Print["SymmetricVariables = ", symmetricVars];
      *)

      tpVars = Map[tp,NCGrabSymbols[exp, tp]];
      tpDiffVars = Map[tp,NCGrabSymbols[diff, tp]];
      symVars = Join[Complement[tpDiffVars, tpVars, excludeVars],
                     symmetricVars];

      (*
      Print["exp = ", exp];
      Print["diff = ", diff];
      Print["vars = ", vars];
      Print["tpVars = ", tpVars];
      Print["tpDiffVars = ", tpDiffVars];
      Print["symVars = ", symVars];
      *)

      (* There are no potentially symmetric variables left *)
      If[symVars === {}, Return[{False, {}}] ];
      
      symRule =  Thread[Map[tp,symVars] -> symVars];

      (* Print[symRule]; *)
      
      If [ (diff /. symRule) =!= zero,
         (* Expression is not symmetric *)
         Return[{False, {}}]
      ];
      
      (* Warm user of symmetric assumptions *)
      Message[NCSymmetricQ::SymmetricVariables, 
              ToString[First[symVars]] <>
                StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];
      
      Return[{True, symVars}];
  ];
  
  NCSymmetricTest[exp_, opts:OptionsPattern[{}]] :=
    NCSymmetricTestAux[exp, 
                       ExpandNonCommutativeMultiply[exp - tp[exp]],
                       0, opts];
      
  NCSymmetricTest[mat_?MatrixQ, opts:OptionsPattern[{}]] := 
    NCSymmetricTestAux[
        mat, 
        ExpandNonCommutativeMultiply[mat - tpMat[mat]], 
        ConstantArray[0, Dimensions[mat]], opts];

  (* NCSymmetricQ *)
 
  NCSymmetricQ[exp_, opts:OptionsPattern[{}]] := 
    First[NCSymmetricTest[exp, opts]];

  (* NCSymmetricPart *)
  NCSymmetricPart[exp_, opts:OptionsPattern[{}]] := Module[
      {options, 
       symmetricVars, excludeVars,
       isSymmetric, symVars},
      
      (* process options *)

      options = Flatten[{opts}];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCSymmetricTest, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCSymmetricTest, ExcludeVariables];
      
      (* is Symmetric *)
      {isSymmetric, symVars} = NCSymmetricTest[exp, opts];
      
      Return[{exp, symVars}];
      
  ];
    
    
End[]

EndPackage[]
