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
NCSymmetricQ::usage = 
"NCSymmetricQ[exp] returns true if exp is symmetric, \
i.e. if tp[exp] == exp.";

NCSymmetricQ::SymmetricVariables =
"The variable(s) `1` was(were) assumed symmetric";
    
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

  (* NCSymmetricQ *)
  
  Clear[NCSymmetricQAux];
  NCSymmetricQAux[exp_, diff_, zero_] := Module[
      {vars, tpVars, tpDiffVars, symVars, symRule},
      
      (* easy return *)
      If[ diff === zero, Return[True] ];

      (* check for possible symmetric variables *)
      vars = NCGrabSymbols[exp];
      tpVars = NCGrabSymbols[exp, tp];
      tpDiffVars = NCGrabSymbols[diff, tp];
      symVars = Map[tp,Complement[tpDiffVars, tpVars]];

      (*
      Print["----"];
      Print[exp];
      Print[diff];
      Print[vars];
      Print[tpVars];
      Print[tpDiffVars];
      Print[symVars];
      *)

      If[symVars === {}, 
         (* There are no potentially symmetric variables *)
         Return[False]
      ];
      
      symRule =  Thread[Map[tp,symVars] -> symVars];

      (* Print[symRule]; *)
      
      If [ (diff /. symRule) =!= zero,
         (* Expression is not symmetric *)
         Return[False]
      ];
      
      (* Warm user of symmetric assumptions *)
      Message[NCSymmetricQ::SymmetricVariables, 
              ToString[First[symVars]] <>
                StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];
      
      Return[True];
  ];
  
  NCSymmetricQ[exp_] := 
    (ExpandNonCommutativeMultiply[exp - tp[exp]] === 0);

  NCSymmetricQ[exp_, False] :=
     NCSymmetricQAux[exp, ExpandNonCommutativeMultiply[exp - tp[exp]], 0];
     
End[]

EndPackage[]
