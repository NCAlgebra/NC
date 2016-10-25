(* :Title: 	MakeGBPackage.m // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). 
*)

(* :Context: 	MakeGBPackage` *)

(* :Summary:	A program to output code to make an SimplifyRational
                program from a given set of relations.
*)

(* :Alias: 	
*)

(* :History: 
*)

BeginPackage["MakeGBPackage`",
      "MakePackage`","NonCommutativeMultiply`","Tuples`",
      "Lazy`","Inequalities`","MoraFree`","Grabs`","Verbose`",
      "Global`","Errors`"];

Clear[MakeRuleDelayedBasedPackage];

MakeRuleDelayedBasedPackage::usage =
     "MakeRuleDelayedBasedPackage[str,aListOfRuleTuples] creates a \
      file described by string to generate a function of the same \
      name which will implement these rules as delayed rules and with \
      the help of a dispatch table.";

Clear[MakeDelayedRules];

MakeDelayedRules::usage = 
     "MakeDelayedRules[aListOfRuleTuples] adds elements \
      to the file determined by a call to SetActiveFile. Don't forget \
      to call OpenActiveFile.";

Clear[ComplicatedLeftPatternRule];

ComplicatedLeftPatternRule::usage =  "No usage statement yet.";

Clear[MakeLiteral];
Clear[MakeLiteral2];

MakeLiteral::usage = 
     "MakeLiteral[aListOfRuleTuples] returns a \
      list of rule tuples with _";

MakeLiteral2::usage = 
     "MakeLiteral2[aListOfRuleTuples] returns a \
      list of rule tuples without _";

Clear[SimpleLeftPatternRuleTuple];

SimpleLeftPatternRuleTuple::usage = "No usage statement yet.";

Begin["`Private`"];

MakeRuleDelayedBasedPackage[func_String,
                            aListOfRuleTuples:{___Tuples`RuleTuple}] :=
Module[{aString,ActiveFile},
    aString = StringJoin[func,".m"];
    MakePackage`SetActiveFile[aString];
    ActiveFile = MakePackage`WhatIsActiveFile[];
    MakeBeginPackage[{func,"Inequalities","Grabs",
                      "NonCommutativeMultiply","Global",
                      "Lazy","Errors"}];
    MakeUsageStatements[func];
    MakeBeginPrivate[];
    MakeDelayedRules[aListOfRuleTuples];
    Print[" About to output the rest :-)"];
    WriteString[ActiveFile,"FactQ[x_] := Inequalities`InequalityFactQ[x];\n\n"];
    WriteString[ActiveFile,func,"[0] := 0;\n\n"];
    WriteString[ActiveFile,func,"[expr_] := expr//.rules;\n\n"];
    WriteString[ActiveFile,func,"[x___] := BadCall[\"",func,"\",x];\n\n"];
    MakeEndPackage[];
    Return[func]
];

MakeRuleDelayedBasedPackage[x___] := BadCall["MakeRuleDelayedBasedPackage",x];

MakeDelayedRules[aListOfRuleTuples:{___Tuples`RuleTuple}] := 
Module[{aListOfRuleTuplesToOutput,ActiveFile},
    aListOfRuleTuplesToOutput = MakeLiteral[aListOfRuleTuples];
    Print["Outputting code :-)"];
    ActiveFile = WhatIsActiveFile[];
    WriteString[ActiveFile,"rules = {\n"];
    len = Length[aListOfRuleTuplesToOutput];
Print["About to output ",len," rules."];
    Map[OutputRuleTupleAndComma,Take[aListOfRuleTuplesToOutput,{1,len-1}]];
    OutputRuleTuple[aListOfRuleTuplesToOutput[[-1]]];
    WriteString[ActiveFile,"};\n\n\n"];
    Return[]
];

MakeDelayedRules[x___] := BadCall["MakeDelayedRules",x];

MakeLiteral2[aListOfRuleTuples:{___Tuples`RuleTuple}] := 
Module[{verbose,newruletuples},
    verbose = VerboseQ[MakeLiteral2];
    If[verbose, Print["Converting Powers to LazyPowers :-)"]; ];
    newruletuples = Lazy`PowerToLazyPower[aListOfRuleTuples];
    If[verbose, Print["Calling LazyPowerRuleTuple :-)"]; ];
    newruletuples = Lazy`LazyPowerRuleTuple[newruletuples];
    If[verbose, Print["Calling CollapseLazyPower :-)"]; ];
    newruletuples = Lazy`CollapseLazyPower[newruletuples];
    If[verbose, Print["Calling FixLazyPowerRuleTuple :-)"]; ];
    newruletuples = Lazy`FixLazyPowerRuleTuple[newruletuples];
    Return[newruletuples] 
];

MakeLiteral2[x___] := BadCall["MakeLiteral2",x];

MakeLiteral[aListOfRuleTuples:{___Tuples`RuleTuple}] := 
Module[{newruletuples},
    newruletuples = MakeLiteral2[aListOfRuleTuples];
    newruletuples = CleanUpTuple[newruletuples];
    If[VerboseQ[MakeLiteral], Print["Calling SimpleLeftPatternRuleTuple :-)"]];
    newruletuples = SimpleLeftPatternRuleTuple[newruletuples];
    Return[newruletuples]
];

MakeLiteral[x___] := BadCall["MakeLiteral",x];

(*
      Apply SimpleLeftPatternRuleTuple to a list of rule tuples or just a     
      single rule tuple. The result of this routine is a list of rules      
      which have _ (underlines) on some of the variables on the       
      left side of the rules.                                         
*)
SimpleLeftPatternRuleTuple[aListRuleTuples:{___Tuples`RuleTuple}] := 
      Map[SimpleLeftPatternRuleTuple,aListRuleTuples];

SimpleLeftPatternRuleTuple[aRuleTuple_Tuples`RuleTuple]:=
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
      result = Tuples`RuleTuple[blankleft->right,
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

WriteASequence[x___] := 
Module[{ActiveFile,aList,j,temp},
     ActiveFile = WhatIsActiveFile[];
     aList = {x};
     Do[temp = StringJoin[aList[[j]],"\\\n"];
        WriteString[ActiveFile,temp];
     ,{j,1,Length[aList]-1}];
     WriteString[ActiveFile,aList[[-1]]];
     Return[]
];

WriteASequenceWithCommas[x___] := 
Module[{aList,j},
     aList = {x};
     Do[WriteASequence[aList[[j]],","];
     ,{j,1,Length[aList] - 1}];
     WriteASequence[aList[[-1]]];
     Return[]
];

OutputRuleTupleAndComma[aRuleTuple_Tuples`RuleTuple] := 
Module[{},
    OutputRuleTuple[aRuleTuple];
    WriteString[WhatIsActiveFile[],",\n"];
    Return[]
];

OutputRuleTupleAndComma[x___] := BadCall["OutputRuleTupleAndComma",x];

OutputRuleTuple[aRuleTuple_Tuples`RuleTuple] := 
Module[{ActiveFile,LHSOfRule,temp,aList},
     ActiveFile = WhatIsActiveFile[];
     LHSOfRule = aRuleTuple[[1,1]];
     temp = ToString[Format[aRuleTuple[[1,2]],InputForm]];
     If[Head[LHSOfRule]===LazyPower,
          WriteASequence[
                   ToString[Format[aRuleTuple[[1,1]],InputForm]],
                   ":> "
                        ];
          WriteASequence["ExpandNonCommutativeMultiply[",temp,"]"];
          WriteASequence[
                   " /; Inequalities`InequalityFactQ[",
                   ToString[Format[aRuleTuple[[2]],InputForm]],
                   "],"
                        ];
     ];
     WriteASequence["Literal[NonCommutativeMultiply[front___,",
                    Aux[aRuleTuple[[1,1]]],
                    ",back___]] :> ",
                    "ExpandNonCommutativeMultiply[front**(",
                    temp,
                    ")**back] /; Inequalities`InequalityFactQ[",
                    ToString[Format[aRuleTuple[[2]],InputForm]],
                    "]"
                   ];
     Return[]
];

OutputRuleTuple[x___] := BadCall["OutputRuleTuple",x];

Aux[x_LazyPower] := ToString[Format[x,InputForm]];

Aux[x_NonCommutativeMultiply] := 
Module[{temp},
    temp = Apply[List,x];
    temp = ToString[Format[temp,InputForm]];
    temp = StringTake[temp,{2,StringLength[temp]-1}];
    Return[temp]
];

Aux[x___] := BadCall["Aux in MakeGBPackage`",x];

End[];
EndPackage[]
