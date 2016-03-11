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

tp::usage =
"tp[x] is the tranpose of x. It is a linear involution. \
Note that all commutative expressions are assummed self-adjoint. \
See also aj.";

Clear[NCSymmetricQ];
NCSymmetricQ::usage = "\
NCSymmetricQ[exp] returns true if exp is symmetric, \
i.e. if tp[exp] == exp.
NCSymmetricQ[exp, False] attempts to detect symmetric variables \
using NCMakeSymmetric.

See NCMakeSymmetric";

NCSymmetricQ::SymmetricVariables =
"The variable(s) `1` was(were) assumed symmetric";

Clear[NCMakeSymmetric];
NCMakeSymmetric::usage = "\
NCMakeSymmetricQ[exp] attempts to establish symmetry of exp by \
assuming symmetry of its variables.

NCMakeSymmetricQ returns a list of two elements:
\tthe first element is True or False if it succeded to prove exp \
symmetric.
\tthe second element is a list of the variables that were made \
symmetric.

See NCSymmetricQ";

Options[NCMakeSymmetric] = {
  SymmetricVariables -> {},
  ExcludeVariables -> {}
};

Begin[ "`Private`" ]

  (* tp is NonCommutative *)
  SetNonCommutative[tp];

  (* tp is Linear *)
  tp[a_ + b_] := tp[a] + tp[b];
  tp[c_?NumberQ] := c;
  tp[a_?CommutativeQ] := a;

  (* tp is Idempotent *)
  tp[tp[a_]] := a;

  (* tp threads over Times *)
  tp[a_Times] := tp /@ a;

  (* tp reverse threads over NonCommutativeMultiply *)
  HoldPattern[tp[NonCommutativeMultiply[a__]]] := 
        (NonCommutativeMultiply @@ (tp /@ Reverse[{a}]));

  (* tp[inv[]] = inv[tp[]] *)
  tp[inv[a_]] := inv[tp[a]];

  (* NCMakeSymmetric *)
  Clear[NCMakeSymmetricAux];
  NCMakeSymmetricAux[exp_, diff_, zero_, opts:OptionsPattern[{}]] := Module[
      {vars, tpVars, tpDiffVars, symVars, symRule, 
       options, symmetricVars, excludeVars},
      
      (* process options *)

      options = Flatten[{opts}];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCMakeSymmetric, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCMakeSymmetric, ExcludeVariables];
      
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
  
  NCMakeSymmetric[exp_, opts:OptionsPattern[{}]] :=
    NCMakeSymmetricAux[exp, 
                       ExpandNonCommutativeMultiply[exp - tp[exp]],
                       0, opts];
      
  (* NCSymmetricQ *)
 
  NCSymmetricQ[exp_, opts:OptionsPattern[{}]] := 
    First[NCMakeSymmetric[exp, opts]];
     
End[]

EndPackage[]
