(* :Title: 	NCAdjoints *)

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
              "NCUtil`" ]

Clear[NCSelfAdjointQ, NCSelfAdjointTest];
      
NCSelfAdjointQ::SelfAdjointVariables =
"The variable(s) `1` was(were) assumed adjoint";

Options[NCSelfAdjointTest] = {
  SelfAdjointVariables -> {},
  SymmetricVariables -> {},
  ExcludeVariables -> {}
};

Begin[ "`Private`" ]

  (* NCSelfAdjointQ *)
  
  Clear[NCSelfAdjointTestAux];
  NCSelfAdjointTestAux[exp_, diff_, zero_, opts:OptionsPattern[{}]] := Module[
      {vars, ajVars, ajDiffVars, selfAdjVars, selfAdjRule, ajCoVars, symVars, 
       options, symmetricVars, excludeVars},
      
      (* process options *)

      options = Flatten[{opts}];

      selfAdjointVars = SelfAdjointVariables 
 	    /. options
	    /. Options[NCSelfAdjointTest, SelfAdjointVariables];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCSelfAdjointTest, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCSelfAdjointTest, ExcludeVariables];

      (* Print["-----"]; *)
      
      (* easy return *)
      If[ diff === zero, Return[{True, {}, {}}] ];

      (* check for possible self-adjoint variables *)
      vars = NCGrabSymbols[exp];
      
      (* exclude all vars? *)
      excludeVars = If [excludeVars === All
                        , 
                        vars
                        ,
                        Flatten[List[excludeVars]]
                       ];
          
      (* all variables SelfAdjoint? *)
      (* SelfAdjoint vars have priority *)
      If [selfAdjointVars === All
          ,  
          selfAdjointVars = vars;
          symmetricVars = {};
          excludeVars = {};
          ,
          selfAdjointVars = Flatten[List[selfAdjointVars]];
          excludeVars = Complement[excludeVars, selfAdjointVars];
      ];

      (* all variables symmetric? *)
      (* symmetric vars have priority *)
      If [symmetricVars === All
          ,  
          symmetricVars = Complement[vars, selfAdjointVars];
          excludeVars = {};
          ,
          symmetricVars = Complement[Flatten[List[symmetricVars]], 
                                     selfAdjointVars];
          excludeVars = Complement[excludeVars, symmetricVars];
      ];

      (*
      Print["ExcludeVariables = ", excludeVars];
      Print["SelfAdjointVariables = ", selfAdjointVars];
      Print["SymmetricVariables = ", symmetricVars];
      *)

      ajVars = Map[aj,NCGrabSymbols[exp, aj]];
      ajDiffVars = Map[aj,NCGrabSymbols[diff, aj]];
      selfAdjVars = Join[Complement[ajDiffVars, ajVars, excludeVars],
                     selfAdjointVars];

      (*
      Print["exp = ", exp];
      Print["diff = ", diff];
      Print["vars = ", vars];
      Print["ajVars = ", ajVars];
      Print["ajDiffVars = ", ajDiffVars];
      Print["selfAdjVars = ", selfAdjVars];
      *)

      (* There are no potentially self-adjoint variables *)
      If[selfAdjVars === {}, Return[{False, {}, {}}]];
      
      selfAdjRule = Thread[Map[aj,selfAdjVars] -> selfAdjVars];

      (* Print["selfAdjRule = ", selfAdjRule]; *)
      
      If [ (diff /. selfAdjRule) =!= zero,

        (* Try real assumptions *)
        ajCoVars = Union[NCGrabSymbols[exp, aj|co] /. (aj|co)[x_]->x];
        symVars = Join[Complement[Map[tp,NCGrabSymbols[exp, tp]], 
                                  ajCoVars, excludeVars], 
                       symmetricVars];
      
        (*
        Print["ajCoVars = ", ajCoVars];
        Print["symVars = ", symVars];
        *)
      
        If[symVars === {},
           (* There are no potentially symmetric variables *)
           Return[{False, {}, {}}]
        ];
      
        selfAdjVars = Complement[selfAdjVars, symVars];
      
        (* Print["selfAdjVars = ", selfAdjVars]; *)

        selfAdjRule = Join[Thread[Map[aj,selfAdjVars] -> selfAdjVars],
                           Thread[Map[aj,symVars] -> Map[tp,symVars]],
                           Thread[Map[co,symVars] -> symVars]];
      
        (* Print[selfAdjRule]; *)

        If [ (diff /. selfAdjRule) =!= zero,
           (* Expression is not adjoint *)
           Return[{False, {}, {}}]
        ];

        (* Warm user of symmetric assumptions *)
        Message[NCSymmetricQ::SymmetricVariables, 
                ToString[First[symVars]] <>
                  StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];

      ];

      If [selfAdjVars =!= {},

         (* Warm user of adjoint assumptions *)
         Message[NCSelfAdjointQ::SelfAdjointVariables, 
                 ToString[First[selfAdjVars]] <>
                   StringJoin @@ Map[(", "<>ToString[#])&, Rest[selfAdjVars]]];
      ];

      Return[{True, selfAdjVars, symVars}];
  ];

  NCSelfAdjointTest[exp_, opts:OptionsPattern[{}]] :=
    NCSelfAdjointTestAux[exp, 
                       ExpandNonCommutativeMultiply[exp - aj[exp]],
                       0, opts];

  (* NCSelfAdjointQ *)
 
  NCSelfAdjointQ[exp_, opts:OptionsPattern[{}]] := 
     First[NCSelfAdjointTest[exp, opts]];
  
End[]

EndPackage[]
