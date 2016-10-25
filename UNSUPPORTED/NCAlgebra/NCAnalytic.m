(* :Title: 	NCAnalytic // Mathematica 2.0 *)

(* :Author: 	Mark Stankus *)

(* :Context: 	NCAnalytic` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:    
*)
BeginPackage[ "NCAnalytic`",
       "NonCommutativeMultiply`","NCSubstitute`","Errors`"];

Clear[AnalyticQ];

AnalyticQ::usage = 
     "AnalyticQ[x,vars] is True if x is analytic \
     and False if x is notanalytic.  See SetAnalytic, \
     SetNonAnalytic and AnalyticQ.";

Clear[SetAnalytic];

SetAnalytic::usage = 
     "SetAnalytic[a, b, c, ...] sets all the symbols a, b, c, ... \
      to be analytic. See SetNonSetAnalytic and AnalyticQ.";

Clear[SetNonAnalytic];

SetNonAnalytic::usage = 
     "SetNonAnalytic[a, b, c, ...] sets all the symbols a, b, c, ... \
      to be not analytic. See SetAnalytic and AnalyticQ.";

Clear[AnalyticAllQ];

AnalyticAllQ::usage = 
     "AnalyticAllQ[expr,vars] is True if expr is obviously \ 
      analytic based on the values of AnalyticQ  \
       and False otherwise. See AnalyticQ.";

Clear[AnalyticPolynomialAllQ];

AnalyticPolynomialQ::usage =
     "AnalyticPolynomialAllQ[expr,vars] tries to determine if \
      expr is a polynomial in vars.";

Clear[SetAnalyticFunction];

SetAnalyticFunction::usage =
     "SetAnalyticFunction[expr] .";
 
Clear[WhatIsAnalyticFunction];

WhatIsAnalyticFunction::usage =
     "WhatIsAnalyticFunction[expr] ."; 

Begin[ "`Private`" ]

AnalyticAllQ[expr_,aList_List] :=
Module[{len,theRules,newVars,newexpr},
     len = Length[aList];
     newVars = Table[ToExpression[StringJoin["AnalyticVariable",
                                             ToString[j]
                                            ]
                                 ]
                     ,{j,1,len}];
     theRules = Table[aList[[j]]->newVars[[j]],{j,1,len}];
     Apply[SetNonCommutative,newVars];
     newexpr = Transform[expr,theRules];
     theRules = Map[(#[[2]]->#[[1]])&,theRules];
Print[newexpr];
Print[newVars];
     Return[{AnalyticallQ[newexpr,newVars],aList}];
];

AnalyticallQ[f_[x___],vars_List] := 
Module[{hflag,aListOfPairs,flags,result},
     hflag = AnalyticQ[f,vars];
     If[hflag, aListOfPairs = Map[AnalyticAllQ[#,vars]&,{x}];
               flags = Map[First,aListOfPairs];
               If[Apply[And,flags], result = Map[#[[2]]&,aListOfPairs];
                                    result = Apply[f,result];
                                    flags = True;
                                  , result = Null;
                                    flags = False;
               ];
             , flags = False;
               result = Null;
             , Print["f:",f];
               Print["{x}:",{x}];
               Print["vars:",vars];
               Abort[];
     ];
     SetAnalyticFunction[result];
     Return[{flags,result}];
];

AnalyticallQ[aSymbol_Symbol,aList_List] := 
Module[{index,result},
     index = Position[aList,aSymbol];
     flag = Not[index === {}];
     If[flag,  result = ToExpression[
                       StringJoin["AnalyticVar",
                                  ToString[index[[1,1]]]
                                 ]  ];
             , result = Null;
     ];
     SetAnalyticFunction[result];
     Return[{flag,result}];
];

AnalyticallQ[c_?NumberQ,_] := {True, SetAnalyticFunction[c]};

AnalyticallQ[x___]:= BadCall["AnalyticAllQ",x];
 
AnalyticQ[aSymbol_Symbol,aList_] := MemberQ[aList,aSymbol];

AnalyticQ[c_?NumberQ,_] := True;

AnalyticQ[_,_] := False;

AnalyticQ[x___] := BadCall["AnalyticQ",x];

SetAnalyticFunction[x_] := AnalyticFunction = x;

SetAnalyticFunction[x___] := BadCall["SetAnalyticFunction",x];

WhatIsAnalyticFunction[] := AnalyticFunction;

WhatIsAnalyticFunction[x___] := BadCall["WhatIsAnalyticFunction",x];

SetNonAnalytic[a__] := (Function[x, AnalyticQ[x,_] := False] /@ {a});

SetNonAnalytic[x___] := BadCall["SetNonAnalytic",x];

SetAnalytic[a__] := (Function[x, AnalyticQ[x,_] := True] /@ {a});

SetAnalytic[x___] := BadCall["SetAnalytic",x]; 

AnalyticPolynomialAllQ[expr_Plus,var_] := 
Module[{newvar,len,newvars,newrules,newexpr,result},
     newvar = Flatten[{var}];
     len = Length[newvar];
     newvars = Table[StringJoin["NCAnalytic",ToString[j]],{j,1,len}];
     newrules = Table[newvar[[j]]->newvars[[j]],{j,1,len}];
     newexpr = Transform[expr,newrules];
     aListOfPairs = Map[AnalyticPolynomialQ[#,newvars]&,Apply[List,newexpr]];
     flags = Apply[And,Map[First,aListOfPairs]];
     If[flags, other = Apply[Plus,Map[#[[2]]&,aListOfPairs]];
             , other = Null;
             , Print["expr:",expr];
               Print["result:",result];
               Abort[];
     ];
     Return[result]
];

AnalyticPolynomialAllQ[_,_] := False;

AnalyticPolynomialAllQ[x___] := BadCall["AnalyticPolynomialAllQ",x];

AnalyticPolynomialQ[expr_NonCommutativeMultiply,var_] :=
    Complement[Union[Apply[List,expr]],var] === {};

AnalyticPolynomialQ[x___] := BadCall["AnalyticPolynomialQ",x];

End[];
EndPackage[];

SetAnalytic[Plus,Times,NonCommutativeMultiply,Sin,Cos,Inv,inv];
