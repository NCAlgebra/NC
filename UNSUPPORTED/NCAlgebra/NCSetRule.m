(* :Title: 	NCSetRule // Mathematica 2.0 *)

(* :Author: 	Mark Stankus. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:    
*)

(* :Alias:
*)

(* :Warnings:   
*)

(* :History: 
   :3/7/93:   Wrote package. (mstankus)
*)


BeginPackage["NonCommutativeMultiply`"];
  
Clear[Trigger];

Trigger::usage = 
     "Trigger is an option for NCSetRule which allows for \
      the use of Downvalues. For example, \n \
      NCSetRule[inv[x_]**x_,1] defines \n \
      Literal[NonCommutativeMultiply[anything1___,inv[x_],x_, \
                                           anything2___] \n \
      and NCSetRule[inv[x_]**x_,1,Trigger->inv] defines \n \
      inv/:Literal[NonCommutativeMultiply[anything1___,inv[x_],x_, \
                                           anything2___] ";

Clear[NCSetRule];

NCSetRule::usage = 
     "NCSetRule[LHS,RHS] or \
      NCSetRule[LHS,RHS,Trigger->whatever] \
      are used. As an example, \n \
      NCSetRule[pinv[x_]**x_**pinv[x_],x] defines \n \
      Literal[NonCommutativeMultiply[anything1___,
                                     pinv[x_],x_,pinv[x_] \
                                     anything2___] \n \
      NCSetRule[pinv[x_]**x_**pinv[x_],x,Trigger->pinv] defines \n \
      pinv/:Literal[NonCommutativeMultiply[anything1___,
                                     pinv[x_],x_,pinv[x_] \
                                     anything2___] ";


Begin["`Private`"];

Options[NCSetRule] := {Trigger->none};

NCSetRule[LHS_NonCommutativeMultiply,RHS_,opts___] := 
Block[{trigger,left,leftString,right,str},
    trigger = Trigger/. {opts} /. Options[NCSetRule];
    left = Apply[List,LHS];
    leftString = ToString[Format[left,InputForm]];
    leftString = StringTake[leftString,{2,StringLength[leftString]-1}];
    right = anything1**RHS**anything2; 
    str = StringJoin["Literal[NonCommutativeMultiply[",
                     "NonCommutativeMultiply`Private`anything1___,",
                     leftString,
                     ",NonCommutativeMultiply`Private`anything2___",
                     "]] :=",
                     ToString[Format[right,InputForm]]
                     ];
    If[Not[trigger === none], str = StringJoin[ToString[trigger], "/:",
                                               str];
    ];
    ToExpression[str];
    Return[str]
];

End[];
EndPackage[]
