(* :Title: 	NCGBConvert // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus *)

(* :Context: 	NCGBConvert` *)

(* :Summary:    
*)

(* :Alias's:    None*)

(* :Warnings:   None.  *)

(* :History: 
*)

BeginPackage["NCGBConvert`","NonCommutativeMultiply`",
             "SimplePower`","ManipulatePower`","NCMtools`","NCGBMax`",
             "NCMakeGreater`","Global`","Tuples`",
             "Inequalities`","Errors`"];

Clear[smallConvert];

smallConvert::usage =
     "smallConvert is being replaced by NCGBConvert.";

Clear[NCGBConvert];

NCGBConvert::usage =
     "NCGBConvert";

Clear[MakeAllRuleTuples];

MakeAllRuleTuples::usage =
     "MakeAllRuleTuples";

Clear[MakeRuleTuples];

MakeRuleTuples::usage =
     "MakeRuleTuples";

Clear[FindConditionsAux];

FindConditionsAux::usage =
     "FindConditionsAux";

Clear[FindConditions];

FindConditions::usage =
     "FindConditions";

Clear[SimpleAnd];

SimpleAnd::usage =
     "SimpleAnd";

Clear[ReducedLogicalForm];

ReducedLogicalForm::usage =
     "ReducedLogicalForm";

Begin["`Private`"];

Clear[MakeRuleTuplesGivenCondition];

smallConvert[x___] :=
  ( 
   Print["Please change code "];
   Print["from smallConvert to NCGBConvert."];
   NCGBConvert[x]
  );

NCGBConvert[x_List] := Flatten[Map[NCGBConvert,x]];

NCGBConvert[x_Rule] := 
Module[{temp,newrule,j,k,thetemp},
     temp = MakeAllRuleTuples[Global`RuleTuple[x,{},{}]];
     thetemp = Union[Map[First,temp]];
     Which[Length[temp]===0, newrule = {};
         , Length[temp]===1, newrule = {temp[[1,1]]};
         , Length[thetemp]===1, newrule = thetemp;
         , True,   Print["\n\n\n"];
                   Print["NCGBConvert does not know which"];
                   Print["form to use. Tell me which one."];
                   Print["Type 0 to jump to an editor session"];
                   Print["Input is ", x];
                   Do[Print[j,":", temp[[j]]];
                   ,{j,1,Length[temp]}];
                   k = Null;
                   While[Not[NumberQ[k]],
                       k = Input["Type a number"];
                   ];
                   If[k===0, newrule = Edit[temp]; 
                           , newrule = {temp[[k,1]]};
                   ];
     ];
     Return[newrule];
];

NCGBConvert[x_Global`RuleTuple] := MakeAllRuleTuples[x];

NCGBConvert[x_Equal] := NCGBConvert[x/.Equal->Rule];

NCGBConvert[x_Plus] := NCGBConvert[x->0];

NCGBConvert[True] := {0->0};
NCGBConvert[False] := {False};

NCGBConvert[0] := {0->0};

NCGBConvert[x_] := x->0;

NCGBConvert[x___] := BadCall["NCGBConvert",x];

MakeAllRuleTuples[aRuleTuple_Global`RuleTuple] := 
Module[{poly,result,j,thePositions,theLengths,accumulate,
        theTerms,term,otherterms,lead,temp,pairs},
     poly = ToPolynomial[aRuleTuple[[1]]];
     poly = ExpandNonCommutativeMultiply[poly];
     If[Global`runningGeneral
          , poly = CollapsePower[poly];
     ];
     If[Head[poly]===Plus
          , theTerms =  Apply[List,poly];
            pairs = Select[theTerms,FreeQ[#,Sum]&];
            pairs = Map[{TheDegree[#],#}&,pairs];
            pairs = ComplicatedMax[pairs];
            Do[ term = pairs[[j,2]];
                lead = LeadingCoefficient[term];
                otherterms = Complement[theTerms,{term}];
                term = term/lead;
                otherterms = -otherterms/lead;
                temp = MakeRuleTuples[term,otherterms,
                                      aRuleTuple[[2]],aRuleTuple[[3]]];
                accumulate[j] = Union[temp];
            ,{j,1,Length[pairs]}];
            result = Union[Flatten[Table[accumulate[j]
                                        ,{j,1,Length[pairs]}
                                        ]]];
            Clear[accumulate];
          , result = {Global`RuleTuple[NormalizeCoefficient[poly]->0,
                                aRuleTuple[[2]],
                                aRuleTuple[[3]]]};
     ];
     result = Select[result,Not[MemberQ[#[[2]],False]]&];
     If[Global`runningGeneral
          , If[cleanUp, result = CleanUpTuple[result];];
            result = CollapsePower[result];
     ];
     result = Union[Flatten[result]];
     result = Select[result,Not[(#[[1,1]]-#[[1,2]])===0]&];
     Return[result];
];

MakeAllRuleTuples[x___] := BadCall["MakeAllRuleTuples",x];

MakeRuleTuples[aTerm_,aListOfOtherTerms_List,
               ineqList_List,varList_List] :=
Module[{temp,item,rule,result,j,smallerList},
     smallerList = Select[aListOfOtherTerms,FreeQ[#,Sum]&];
     temp = FindConditions[aTerm,smallerList];
     If[Not[ReducedLogicalForm[temp]],
         Print["The following Boolean statement is not"];
         Print["of the form (1) True, (2) False, or "];
         Print["(3) a simple And or (4) Or of And's"];
         Print["The expression is ",temp];
         Global`junk = temp;
         Abort[];
     ];
     If[And[Global`AssistConvert,Length[temp]>1]
          , Print["About to edit expression. Simplify if you can!"];
            Input["Press return"];
            temp= Edit[temp];
     ];
     rule = aTerm -> Apply[Plus,aListOfOtherTerms];
     result = MakeRuleTuplesGivenCondition[rule,temp,ineqList,varList];
     result = CleanUpTuple[result];
     result = Union[Flatten[{result}]];
     If[And[Global`runningGeneral,Global`expandRuleTuples],
          result = SimplifyInequality[result];
          result = Map[MoraData`ExtendCases[#,#[[3]]]&,result];
          result = Union[Flatten[result]];
     ];
     Return[result];
];

MakeRuleTuples[x___] := BadCall["MakeRuleTuples",x];

ReducedLogicalForm[x_] := 
     Which[SimpleAnd[x], True
          ,Head[x]==Or , Apply[And,Map[AndFree,Apply[List,x]]]
          ,True        , False];

ReducedLogicalForm[x___] := BadCall["ReducedLogicalForm",x];

SimpleAnd[And[___?And[FreeQ[#,And],FreeQ[#,Or]]&]] := True;
SimpleAnd[True] := True;
SimpleAnd[False] := True;
SimpleAnd[x_GreaterEqual] := True;
SimpleAnd[x_Greater] := True;
SimpleAnd[x_LessEqual] := True;
SimpleAnd[x_Less] := True;
SimpleAnd[x_Equal] := True;
SimpleAnd[x_] := False;
SimpleAnd[x___] := BadCall["SimpleAnd",x];

MakeRuleTuplesGivenCondition[rule_Rule,temp_Or,
                             ineqList_List,varList_List] := 
         Map[MakeRuleTuplesGivenCondition[rule,#,ineqList,varList]&,
             Apply[List,temp]];

MakeRuleTuplesGivenCondition[rule_Rule,temp_And,
                             ineqList_List,varList_List] :=
	   SimplifyInequality[Global`RuleTuple[rule,Join[(temp/.And->List),ineqList],varList]];

MakeRuleTuplesGivenCondition[rule_Rule,other_,
                              ineqList_List,varList_List] :=
   SimplifyInequality[Global`RuleTuple[rule,
                                       Flatten[Join[{other},ineqList]],
                                       varList]];

MakeRuleTuplesGivenCondition[x___] := 
      BadCall["MakeRuleTuplesGivenCondition",x];

FindConditions[aTerm_,aListOfOtherTerms_List] :=
Module[{temp,result,j,asaList},
      result = True;
      asaList = NCMToList[aTerm];
      Do[ If[Not[result===False],
                temp = FindConditionsAux[asaList,
                                         NCMToList[aListOfOtherTerms[[j]]]
                                        ];
                result = LogicalExpand[And[result,temp]];
          ];
     ,{j,1,Length[aListOfOtherTerms]}];
     Return[result];
];

FindConditions[x___] := BadCall["FindConditions",x];

FindConditionsAux[aTerm_,anotherTerm_] :=
Module[{equalCondition,result},
   result = True;
   equalCondition = (TheDegree[aTerm] == TheDegree[anotherTerm]);
   If[equalCondition 
           , result = MakeGreater[aTerm,anotherTerm];
           , result = False;
           , result  = LogicalExpand[And[equalCondition,
                                         MakeGreater[aTerm,anotherTerm]
                                        ]
                                    ];
   ];
   result = Or[result,OrderOnNn[TheDegree[aTerm],TheDegree[anotherTerm]]];
   result = LogicalExpand[result];
   Return[result];
];

FindConditionsAux[x___] := BadCall["FindConditionsAux",x];

End[];
EndPackage[]
