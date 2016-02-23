MakeLiteral2[aListOfRuleTuples:{___Global`RuleTuple}] := 
Module[{newruletuples},
    newruletuples = ManipulatePower`PowerRuleTuple[aListOfRuleTuples];
    newruletuples = ManipulatePower`CollapsePower[newruletuples];
    newruletuples = ManipulatePower`FixPowerRuleTuple[newruletuples];
    Return[newruletuples] 
];

MakeLiteral2[x___] := BadCall["MakeLiteral2",x];

MakeLiteral[aListOfRuleTuples:{___Global`RuleTuple}] := 
Module[{newruletuples},
    newruletuples = MakeLiteral2[aListOfRuleTuples];
    newruletuples = Tuples`CleanUpTuple[newruletuples];
    newruletuples = SimpleLeftPatternRuleTuple[newruletuples];
    Return[newruletuples]
];

MakeLiteral[x___] := BadCall["MakeLiteral",x];

SimpleLeftPatternRuleTuple[aListRuleTuples:{___Global`RuleTuple}] := 
      Map[SimpleLeftPatternRuleTuple,aListRuleTuples];

SimpleLeftPatternRuleTuple[aRuleTuple_Global`RuleTuple]:=
Module[{aRule,left,right,freevariables,blankleft,result},
      aRule = aRuleTuple[[1]];
      left  = aRule[[1]];
      right = aRule[[2]];

      freevariables = aRuleTuple[[3]];

      If[Length[freevariables]===0,
(* THEN *)  blankleft = left
(* ELSE *) ,blankleft = left/.Map[blankfunction,freevariables];
      ];
(*
      If[Not[(right/.blankleft->right)===right],
            Print["SimpleLeftPatternRuleTuple :-("];
            Print["The rule ",blankleft->right];
            Print["may lead to an infinite loop."];
            Input["Enter something and hit return to continue"];
      ];
*)
      result = Global`RuleTuple[blankleft->right,
                                aRuleTuple[[2]],
                                aRuleTuple[[3]]
                               ];
      Return[result]
];

SimpleLeftPatternRuleTuple[x___] := BadCall["SimpleLeftPatternRuleTuple",x];

Off[ RuleDelayed::rhs ];  (* Mathematica 2.0 *)
blankfunction[A_]:= A-> A_;
On[ RuleDelayed::rhs ];  (* Mathematica 2.0 *)

blankfunction[x___] := BadCall["blankfunction in MakeGBPackage'",x];


theAux[x_NonCommutativeMultiply] := 
Module[{temp},
    temp = Apply[List,x];
    temp = ToString[Format[temp,InputForm]];
    temp = StringTake[temp,{2,StringLength[temp]-1}];
    Return[temp]
];

theAux[x_] := ToString[Format[x,InputForm]];

theAux[x___] := BadCall["theAux in preTransform`",x];

preTransform[aRuleTuple_Global`RuleTuple] := 
Module[{ruletuples,len,j,result,ans,LHSOfRule,RHSOfRule},
Print["In preTransform"];
    ruletuples = MakeLiteral[{aRuleTuple}];
    len = Length[ruletuples];
    Do[ ans = {};
        LHSOfRule = ToString[Format[aRuleTuple[[1,1]],InputForm]];
        RHSOfRule = ToString[Format[aRuleTuple[[1,2]],InputForm]];
        If[Not[Head[LHSOfRule]===NonComutativeMultiply],
             ans =  {StringJoin[ 
                         LHSOfRule,
                         ":> ",
                         RHSOfRule,
                         " /; Inequalities`InequalityFactQ[",
                         ToString[Format[aRuleTuple[[2]],InputForm]],
                         "]"    
                              ]}
        ];
        AppendTo[ans,
          StringJoin["Literal[NonCommutativeMultiply[front___,",
                     theAux[aRuleTuple[[1,1]]],
                     ",back___]] :> ",
                     "front**(",
                     RHSOfRule,
                     ")**back /; Inequalities`InequalityFactQ[",
                     ToString[Format[aRuleTuple[[2]],InputForm]],
                     "]"
                     ]
        ];
        ans = Map[ToExpression,ans];
        result[j] = ans;
    ,{j,1,len}];
    result = Flatten[Table[result[j],{j,1,len}]];
    Return[result]
];
