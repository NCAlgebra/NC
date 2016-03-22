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
*)

(* :Warnings
*)

(* :Comments:
*)

BeginPackage[ "NCOutput`", 
              "NonCommutativeMultiply`" ];

Clear[NCSetOutput, NCOutputFunction];

Get["NCOutput.usage"];

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

End[];
  
EndPackage[]
