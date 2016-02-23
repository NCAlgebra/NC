(* :Title: 	smallTuples // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	Tuples` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :01/31/93: Removed SimpleConvert2 from BeginPackage statement. (mstankus)
*)

BeginPackage["Tuples`",
         "Inequalities`","Global`","Grabs`","NCGBConvert`",
         "Errors`"];

Clear[ToRuleTuple];

ToRuleTuple::usage =
     "ToRuleTuple";

Clear[CleanUpTuple];

CleanUpTuple::usage = 
     "CleanUpTuple[aTuple] (where aTuple is a polynomial tuple \
      or a rule tuple) replaces aTuple with an equivalent \
      tuple which is considered simpler. The means of  \
      simplification involve changing the inequalities \
      to standard form and removing extraneous variables \
      from the third position. CleanUpTuple is Listable.";

Clear[SmartTupleUnion];

SmartTupleUnion::usage = 
     "SmartTupleUnion[aListOfPolynomialTuples] or \
      SmartTupleUnion[aListOfRuleTuples].";

Clear[TupleDebug];

TupleDebug::usage = 
     "TupleDebug";

Clear[TupleNoDebug];

TupleNoDebug::usage = 
     "TupleNoDebug";

Begin["`Private`"];

TupleDebug[] := debugTuple = True;

TupleDebug[x___] := BadCall["TupleDebug",x];

TupleNoDebug[] := debugTuple = False;

TupleNoDebug[x___] := BadCall["TupleNoDebug",x];
 
TupleNoDebug[];

ToRuleTuple[x_List] := Map[ToRuleTuple,x];

ToRuleTuple[x_Global`RuleTuple] := {x};

ToRuleTuple[x_Global`PolynomialTuple] :=
Module[{data},
     data = x/.Global`PolynomialTuple->Global`RuleTuple;
     Return[{NCGBConvert[data]}];
];

ToRuleTuple[x_] := {Global`RuleTuple[x,{},{}]};

ToRuleTuple[x___] := BadCall["ToRuleTuple",x];

SetAttributes[CleanUpTuple,Listable];

CleanUpTuple[Global`RuleTuple[x_,{},y_]] := Global`RuleTuple[x,{},y];

CleanUpTuple[Global`RuleTuple[x_,y_,{}]] := Global`RuleTuple[x,y,{}];

CleanUpTuple[aTuple_Global`RuleTuple] := 
     Apply[Global`RuleTuple,
           FixedPoint[CleanCode,Apply[List,aTuple],5]
          ];

CleanUpTuple[x___] := BadCall["CleanUpTuple",x];

CleanCode[x_] := 
Module[{insides,temp},
    insides = x;
    temp = Select[insides[[2]],(Head[#] === Equal)&];
    If[Not[temp==={}],
       insides = removeEqual[insides,temp];
       If[MemberQ[insides[[2]],False], Return[{0->0,{},{}}]; ];
    ];
    insides[[2]] = Inequalities`InequalityToStandardForm[insides[[2]]];
    If[MemberQ[insides[[2]],False], Return[{0->0,{},{}}]; ];
    insides[[2]] = Complement[insides[[2]],{True}];
    temp = Select[insides[[2]],(Head[#] === Equal)&];
    insides = removeEqual[insides,temp];
    insides[[3]] = Union[insides[[3]]];
    If[MemberQ[insides[[3]],_?CleanCodeAux],
                   temp = Select[insides[[3]],CleanCodeAux];
                   Print["The following were found in the third \
                          component of a ",Head[x]," and they are \
                          not symbols. They will be removed."];
                   Print[temp];
                   insides[[3]] = Complement[insides[[3]],temp];
    ];
    insides[[2]] = Complement[insides[[2]],{True}];
    temp = Sort[Grabs`GrabVariables[Take[insides,{1,2}]]];
    temp2 = Sort[Complement[insides[[3]],temp]];
    insides[[3]] = Complement[insides[[3]],temp2];
    Return[insides]
];

CleanCode[x___] := BadCall["CleanCode in Tuples`"];

CleanCodeAux[_Symbol] := False;

CleanCodeAux[_] := True;

CleanCodeAux[x___] := BadCall["CleanCodeAux in Tuples`"];

removeEqual[{x_,y_,z_},{}] := {x,y,z};

removeEqual[{x_,y_,z_},{firstrule_,otherrules___}] := 
Module[{temp,newrules,cond,result,rule},
     rule = Flatten[{Global`linearConvert[firstrule]}];
     rule = rule[[1]];
     If[MemberQ[z,rule[[1]]], 
              temp = x//.rule;
              cond = y//.rule;
              If[MemberQ[rule[[2]],rule[[1]]], 
                     Print["Serious error in removeEqual :-( "];
                     Print[{x,y,z}];
                     Print[aList];
                     Abort[];
              ];
              result = {temp,cond,Complement[z,{firstrule[[1]]}]};
                          ,
              result = {x,y,z};
     ];
     result = removeEqual[result,{otherrules}//.rule];
     Return[result];
];

removeEqual[x___] := BadCall["removeEqual in Tuples`"];

SmartTupleUnion[x_List] := Union[Map[SmartTupleUnion,x]];

SmartTupleUnion[x_Global`RuleTuple] := SmartTupleUnionAux[x,""];

SmartTupleUnion[x_Global`RuleTuple,j_] := SmartTupleUnionAux[x,j];

SmartTupleUnion[x_Rule] := x;

SmartTupleUnion[x_Rule,str_] := x;

SmartTupleUnion[x___] := BadCall["SmartTupleUnion",x];

SmartTupleUnionAux[x_,w_] := 
Module[{firstandsecondpart,usedvars,len,j,standardvars,result},
     firstandsecondpart = {x[[1]],x[[2]]};
     usedvars = Select[x[[3]],Not[FreeQ[firstandsecondpart,#]]&];
     len = Length[usedvars];
     standardvars = Table[usedvars[[j]]->newvar[j],{j,1,len}];
     result = x;
     result[[3]] = usedvars;
     result[[2]] = Complement[result[[2]],{True}];
     result = result/.standardvars;
     standardvars = Table[newvar[j]->smartvariable[j,w],{j,1,len}];
     result = result/.standardvars;
     Return[result]
];

SmartTupleUnion[x___] := BadCall["SmartTupleUnion",x];
SmartTupleUnionAux[x___] := BadCall["SmartTupleUnionAux in Tuples`",x];

smartvariable[j_,w_] := smartvariable[j,w] =
    Global`UniqueMonomial[StringJoin["SmartTupleUnion",w,"$$"]];

smartvariable[x___] := BadCall["smartvariable",x];

newvar[j_] := newvar[j] = Global`UniqueMonomial["Unique$$"];

newvar[x___] := BadCall["newvar in Tuples`",x];

End[];
EndPackage[]
