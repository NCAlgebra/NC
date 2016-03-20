(* :Title: NCOutput *)

(* :Author: September 1991, by David Hurst (dhurst). *)

(* :Context: NCOutput` *)

(* :History: 
   :9/20/91	Packaged. (dhurst)
   :5/02/92	Debugging, Context problems, etc. (dhurst)
   :5/29/30     Debugging. (dhurst)
   :09/09/04    Major rewritting. (mauricio)
   :11/07/04    Fixed typos,added semicolons, usage note for NCGetOutput. 
                Optimized code slightly.(mstankus)
*)

(* :Comments:
	Reading the usage statement should be enough to get the program 
	going.  There is a demo used when testing this program 
	commented out at the end of this file.  (dhurst) 
*)

(* :Warnings
	When SetOutput[dot->True, ...] and then looking at
	NCOutputlist, you will see Dot->Dot.  That is because NCM is
	being changed into Dot.
*)

(* :Comments:
	Major changes:
        1) No need to establishes anything in the Global`context before the NCOutput` 
           package. Use All and Dot, instead of all and dot
        2) Calls are "standard" NCSetOutput and NCGetOutput.
        3) Rules are no longer appended, but replaced -> more efficient!
        4) Add holds whenever replacing ** by Dot! This can cause much trouble if 
           the rules of Dot and ** were different.
        5) Deleted testing at the end of the file.
*)

BeginPackage[ "NCOutput`", 
              "NonCommutativeMultiply`" ];

Clear[NCSetOutput];
NCSetOutput::usage = 
"NCSetOutput[optionlist, ... ] displays NC-expressions in a 
special format without affecting the internal representation of 
the expression.  Options are set by typing
    
opt -> True, to use the new format.
opt -> False, to return to the default format.
   
options are:  All, Dot, rt, tp, inv, aj.";

Clear[NCGetOutput];
NCGetOutput::usage = 
  "NCGetOutput[] returns the list of rules which is used for preprocessing \
output. See NCSetOutput.";

Clear[NCOutputFunction];
NCOutputFunction::usage = 
  "NCOutputFunction[x] returns the expression which will be displayed to the screen. \
See NCSetOutput.";

Options[NCSetOutput] = {
  Dot -> False,
  rt -> False,
  tp -> False,
  inv -> False,
  aj -> False 
};
             
Begin[ "`Private`" ]

  Clear[NCOutputRules];
  NCOutputRules = {};

  (* NCSetOutput[input__] := NCSetOutput[{input}]; *)

  NCSetOutput[opts___Rule:{}] := 
    Module[
      {options},

      (* Process options *)
      options = Flatten[{opts}];

      (* All *)
      If[ Length[options] == 1 && options[[1,1]] == All,
        options = Map[Rule[#, options[[1,2]]]&, Options[NCSetOutput][[All, 1]]];
      ];

      (*
        Print[options];
        Print[Options[NCSetOutput]];
      *)

      SetOptions[NCSetOutput, Dot -> (Dot /. options /. Options[NCSetOutput])];
      If[Dot /. Options[NCSetOutput]
        , NCOutputRules = Union[NCOutputRules, { Literal[NonCommutativeMultiply[b__]]:>HoldForm[Dot[b]] }];
        , NCOutputRules = Complement[NCOutputRules, { Literal[NonCommutativeMultiply[b__]]:>HoldForm[Dot[b]] }];
      ];

      SetOptions[NCSetOutput, rt -> (rt /. options /. Options[NCSetOutput])];
      If[rt /. Options[NCSetOutput]
        , NCOutputRules = Union[NCOutputRules, { Literal[NonCommutativeMultiply`rt[b_]]:>HoldForm[Power[b,"1/2"]] }];
        , NCOutputRules = Complement[NCOutputRules, { Literal[NonCommutativeMultiply`rt[b_]]:>HoldForm[Power[b,"1/2"]] }];
      ];

      SetOptions[NCSetOutput, tp -> (tp /. options /. Options[NCSetOutput])];
      If[tp /. Options[NCSetOutput]
        , NCOutputRules = Union[NCOutputRules, { Literal[NonCommutativeMultiply`tp[b_]]:>HoldForm[Power[b,"T"]] }];
        , NCOutputRules = Complement[NCOutputRules, { Literal[NonCommutativeMultiply`tp[b_]]:>HoldForm[Power[b,"T"]] }];
      ];

      SetOptions[NCSetOutput, inv -> (inv /. options /. Options[NCSetOutput])];
      If[inv /. Options[NCSetOutput]
        , NCOutputRules = Union[NCOutputRules, { Literal[NonCommutativeMultiply`inv[b_ ]]:> HoldForm[Power[b,"-1"]] }];
        , NCOutputRules = Complement[NCOutputRules, { Literal[NonCommutativeMultiply`inv[b_ ]]:> HoldForm[Power[b,"-1"]] }];
      ];

      SetOptions[NCSetOutput, aj -> (aj /. options /. Options[NCSetOutput])];
      If[aj /. Options[NCSetOutput]
        , NCOutputRules = Union[NCOutputRules, { Literal[NonCommutativeMultiply`aj[b_]]:>HoldForm[Power[b,"*"]] }];
        , NCOutputRules = Complement[NCOutputRules, { Literal[NonCommutativeMultiply`aj[b_]]:>HoldForm[Power[b,"*"]] }];
      ];

      (* Set System`$PrePrint *)
      System`$PrePrint := NCOutputFunction;
  ];

  NCOutputFunction[x_] := x //. NCOutputRules;

  NCGetOutput[] := NCOutputRules;

End[];
EndPackage[]
