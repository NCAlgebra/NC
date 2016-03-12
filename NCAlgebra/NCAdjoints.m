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

aj::usage = 
"aj[x] is the adjoint of x. aj is a conjugate linear involution. \
See also tp.";

Clear[NCSelfAdjointQ];
NCSelfAdjointQ::usage = 
"NCSelfAdjointQ[exp] returns true if exp is self-adjoint, \
i.e. if tp[exp] == exp.";

NCSelfAdjointQ::SelfAdjointVariables =
"The variable(s) `1` was(were) assumed adjoint";

Clear[NCSelfAdjointTest];
NCSelfAdjointTest::usage = "\
NCSelfAdjointTest[exp] attempts to establish whether exp is \
self-adjoint by assuming that some of its variables are \
self-adjoint or symmetric.
NCSelfAdjointTest[exp, options] uses options.

NCSelfAdjointTest returns a list of three elements:
\tthe first element is True or False if it succeded to prove exp \
self-adjoint.
\tthe second element is a list of the variables that were made \
self-adjoint.
\tthe third element is a list of the variables that were made \
symmetric.

The following options can be given:
\tSelfAdjointVariables: list of variables that should be \
considered self-adjoint; use All to make all variables \
self-adjoint;
\tSymmetricVariables: list of variables that should be \
considered symmetric; use All to make all variables symmetric;
\tExcludeVariables: list of variables that should not be \
considered symmetric; use All to exclude all variables.

See NCSelfAdjointQ";

Options[NCSelfAdjointTest] = {
  SelfAdjointVariables -> {},
  SymmetricVariables -> {},
  ExcludeVariables -> {}
};

Begin[ "`Private`" ]

  (* aj is NonCommutative *)
  SetNonCommutative[aj];

  (* aj is Conjugate Linear *)
  aj[a_ + b_] := aj[a] + aj[b];
  aj[c_?NumberQ] := Conjugate[c];
  aj[a_?CommutativeQ]:= Conjugate[a];

  (* aj is Idempotent *)
  aj[aj[a_]] := a;

  (* aj threads over Times *)
  aj[a_Times] := aj /@ a;

  (* aj reverse threads over NonCommutativeMultiply *)
  aj[NonCommutativeMultiply[a__]] := 
     (NonCommutativeMultiply @@ (aj /@ Reverse[{a}]));

  (* aj[inv[]] = inv[aj[]] *)
  aj[inv[a_]] := inv[aj[a]];

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
