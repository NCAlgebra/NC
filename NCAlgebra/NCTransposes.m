(* :Title: 	NCTransposes *)

(* :Author: 	mauricio *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :2/03/16:    Clean up (mauricio)
*)

BeginPackage[ "NonCommutativeMultiply`",
              "NCUtil`" ];

Clear[NCSymmetricQ, NCSymmetricTest]
      
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
      
      (* easy return *)
      If[ diff === zero, Return[{True, {}}] ];
      
      (* check for possible symmetric variables *)
      vars = NCGrabSymbols[exp];

      (* Print["----"]; *)

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
      
  (* NCSymmetricQ *)
 
  NCSymmetricQ[exp_, opts:OptionsPattern[{}]] := 
    First[NCSymmetricTest[exp, opts]];
     
End[]

EndPackage[]
