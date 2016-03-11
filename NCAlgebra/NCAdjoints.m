(* :Title: 	NCAdjoints *)

(* :Author: 	mauricio. *)

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

Clear[NCAdjointQ];
NCAdjointQ::usage = 
"NCAdjointQ[exp] returns true if exp is adjoint, \
i.e. if tp[exp] == exp.";

NCAdjointQ::AdjointVariables =
"The variable(s) `1` was(were) assumed adjoint";

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
  HoldPattern[aj[NonCommutativeMultiply[a__]]] := 
        (NonCommutativeMultiply @@ (aj /@ Reverse[{a}]));

  (* aj[inv[]] = inv[aj[]] *)
  aj[inv[a_]] := inv[aj[a]];

  (* NCAdjointQ *)
  
  Clear[NCAdjointQAux];
  NCAdjointQAux[exp_, diff_, zero_] := Module[
      {vars, ajVars, ajDiffVars, adjVars, adjRule, ajCoVars, symVars},
      
      (* easy return *)
      If[ diff === zero, Return[True] ];

      (* check for possible adjoint variables *)
      vars = NCGrabSymbols[exp];
      ajVars = NCGrabSymbols[exp, aj];
      ajDiffVars = NCGrabSymbols[diff, aj];
      adjVars = Map[aj,Complement[ajDiffVars, ajVars]];

      (*
      Print["----"];
      Print["exp = ", exp];
      Print["diff = ", diff];
      Print["vars = ", vars];
      Print["ajVars = ", ajVars];
      Print["ajDiffVars = ", ajDiffVars];
      Print["adjVars = ", adjVars];
      *)

      If[adjVars === {}, 
         (* There are no potentially adjoint variables *)
         Return[False]
      ];
      
      adjRule = Thread[Map[aj,adjVars] -> adjVars];

      (* Print[adjRule]; *)
      
      If [ (diff /. adjRule) =!= zero,

        (* Try real assumptions *)
        ajCoVars = Union[NCGrabSymbols[exp, aj|co] /. (aj|co)[x_]->x];
        symVars = Complement[Map[tp,NCGrabSymbols[exp, tp]], ajCoVars];
      
        (*
        Print["ajCoVars = ", ajCoVars];
        Print["symVars = ", symVars];
        *)
      
        If[symVars === {},
           (* There are no potentially symmetric variables *)
           Return[False]
        ];
      
        adjVars = Complement[adjVars, symVars];
      
        (* Print["adjVars = ", adjVars]; *)

        adjRule = Join[Thread[Map[aj,adjVars] -> adjVars],
                       Thread[Map[aj,symVars] -> Map[tp,symVars]],
                       Thread[Map[co,symVars] -> symVars]];
      
        (* Print[adjRule]; *)

        If [ (diff /. adjRule) =!= zero,
           (* Expression is not adjoint *)
           Return[False]
        ];

        (* Warm user of symmetric assumptions *)
        Message[NCSymmetricQ::SymmetricVariables, 
                ToString[First[symVars]] <>
                  StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];

      ];

      If [adjVars =!= {},

         (* Warm user of adjoint assumptions *)
         Message[NCAdjointQ::AdjointVariables, 
                 ToString[First[adjVars]] <>
                   StringJoin @@ Map[(", "<>ToString[#])&, Rest[adjVars]]];
      ];

      Return[True];
  ];

  NCAdjointQ[exp_] := 
    (ExpandNonCommutativeMultiply[exp - aj[exp]] === 0);

  NCAdjointQ[exp_, False] :=
     NCAdjointQAux[exp, ExpandNonCommutativeMultiply[exp - aj[exp]], 0];

  
  
End[]

EndPackage[]
