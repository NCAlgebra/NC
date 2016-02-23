
(* :Title:      smallMoraData // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)
 
(* :Context: 	MoraData` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :01/31/94: Removed SimpleConvert2 from BeginPackage statement. (mstankus)
*)

smallMoraDataArgs = 
{
"MoraData`", 
"NCGBConvert`",
"Inequalities`",
"ArrayManager`",
"preTransform`",
"NCMonomial`",
"ManipulatePower`",
"SimplePower`",
"NonCommutativeMultiply`",
"Global`",
"Errors`"
};

If[runningGeneral,  
       smallMoraDataArgs = Join[smallMoraDataArgs,{
                                    "Lazy`",
                                    "Tuples`",
                                    "Inequalities`"
                                                  }];
];

Apply[BeginPackage,smallMoraDataArgs];

Clear[SetMoraNumbers];

SetMoraNumbers::usage =
     "SetMoraNumbers";

Clear[ClearDataBase];

ClearDataBase::usage = 
     "ClearDataBase[] empties the data base. The data base holds \
      all occurances of ruletuples (or rules) and they are referred \
      to by number by the use of DataElement and a positive integer. \
      See AddToDataBase.";

Clear[AddToDataBase];

AddToDataBase::usage = 
     "AddToDataBase[data] returns a number (or list of numbers if data \
      is a list) associated with the data. If the data is not already \
      in the data base, then it is added. \
      WhatIsDataBase[Flatten[{AddToDataBase[data]}]] \
      is the same as Flatten[{data}]";

Clear[WhatIsDataBase];

WhatIsDataBase::usage = 
     "WhatIsDataBase[] returns a list of all of the numbers of \
      elements in the data base. WhatIsDataBase[aListOfNumbers] (where \
      aListOfNumbers is a list of numbers) returns the data associated \
      with these numbers. See DataElement.";

Clear[DataElement];

DataElement::usage = 
     "DataElement[aNumber] (where aNumber is a positive integer) returns \
      the aNumber-th element of the data base.";

Clear[RuleElement];

RuleElement::usage =
     "RuleElement[aNumber] is the same as DataElement[aNumber] if \
      DataElement[aNumber] is a rule and is DataElement[aNumber][[1]] \
      otherwise.";

Clear[ConditionElement];

ConditionElement::usage =
     "ConditionElement[aNumber] is  {} if \
      DataElement[aNumber] is a rule and is DataElement[aNumber][[2]] \
      otherwise.";

Clear[ParameterElement];

ParameterElement::usage =
     "ParameterElement[aNumber] is  {} if \
      DataElement[aNumber] is a rule and is DataElement[aNumber][[3]] \
      otherwise.";

Clear[AddaMatch];

AddaMatch::usage = 
    "AddaMatch[x] takes the match x, creates the spolynomial and \
     reduces it by the rules which we are allowed to reduce by and \
     if the result is nonzero, then the new polynomial will be stored
     as part of the basis.";

Clear[ClearSPolynomial];

ClearSPolynomial::usage =
     "After ClearSPolynomial[] is executed and before any matches, \
      are processed WhatAreSPolynomial[] returns {}. Used in MoraAlg.m";

Clear[WhatAreSPolynomial];

WhatAreSPolynomial::usage = 
     "WhatAreSPolynomial[] returns a list which reflects previous \
      calls to ClearSPolynomial[] and AddaMatch[...]. \
      Used in MoraAlg.m.";

Clear[NonTrivialMoraData];

NonTrivialMoraData::usage =
     "NonTrivialMoraData[aRule] returns False if aRule is 0->0 and True \
      otherwise. \
      NonTrivialMoraData[aRuleTuple] is the same as \
      NonTrivialMoraData[aRuleTuple[[1]]]. \
      NonTrivialMoraData[aNumber] is the same as \ 
      NonTrivialMoraData[RuleElement[aNumber]].";

Clear[MoraDataDebug];

MoraDataDebug::usage = 
     "MoraDataDebug";

Clear[MoraDataNoDebug];

MoraDataNoDebug::usage = 
     "MoraDataNoDebug";

Clear[ClearToReduceBy];

ClearToReduceBy::usage = 
     "If one omits the reference of what is used to reduce a certain \
     data by, then Reduction uses a user-defined default. \
     ClearToReduceBy[] empties the user-defined default.";

Clear[ReductionRule];

ReductionRule::usage = 
     "ReductionRule[n] computes the reduction rule associated with the \
      n-th piece of data in the data base. ReductionRule remembers the \
      results of every time it is called and so one can not recalculate \
      a reduction rule (without some effort, that is).";

Clear[Reduction];

Reduction::usage = 
     "Reduction";

Clear[SetToReduceBy];

SetToReduceBy::usage =
     "SetToReduceBy[aList] sets the user-defined default mentioned in \
      ClearToReduceBy . See also AppendToReduceBy.";

Clear[AppendToReduceBy];

AppendToReduceBy::usage =
     "AppendToReduceBy[x] appends x to the user-defined default mentioned \
      in ClearToReduceBy. See also AppendToReduceBy.";

Clear[ResolveInequalities];

ResolveInequalities::usage =
     "ResolveInequalities";

Clear[ExtendCases];

ExtendCases::usage =
     "ExtendCases";

Clear[SetPropogateReduction];

SetPropogateReduction::usage=
     "SetPropogateReduction";

Clear[WhatIsPropogateReduction];

WhatIsPropogateReduction::usage =
     "WhatIsPropogateReduction";

Clear[MoraPropogate];

MoraPropogate::usage=
     "MoraPropogate[aListOfRuleTuples] applies the function \
      Propogate to aListOfRuleTuples, and returns aListOfRuleTuples \
      with all rules, that can be propogated, replaced by the more general\
      rules generated by Propogate.";

GBFirstLetter::usage =
     "GBFirstLetter";

Clear[UsePackageReduction];

UsePackageReduction::usage =
     "UsePackageReduction";

Clear[SetPackageReductionName];

SetPackageReductionName::usage =
     "SetPackageReductionName";

Clear[PolynomialAsAList];

PolynomialAsAList::usage =
     "PolynomialAsAList";

Clear[TermAsAList];

TermAsAList::usage =
     "TermAsAList";

Clear[WhatIsHistory];
 
WhatIsHistory::usage =
     "WhatIsHistory";

Clear[WhatIsDataBaseAndHistory];

WhatIsDataBaseAndHistory::usage =
     "WhatIsDataBaseAndHistory";

Begin["`Private`"];

Clear[hashTable];
Clear[hashKey];
Clear[hashfirst];
Clear[SimpleSPolynomial];
Clear[LeadingCoefficient];
Clear[NotaList];
Clear[DummyReduction];
Clear[RuleOf] ;
Clear[wasPropogated] ;
Clear[ruleOf] ;
Clear[Aux];
Clear[ReductionOnOne];
Clear[reductionOnOne];
Clear[RecordReductions];
Clear[SimpleReduce];
Clear[SimpleReduceAux];
Clear[ResolveInequalities];
Clear[ExtendCases];
Clear[ExtendCasesAux];
Clear[extendCasesAux];

MoraDataDebug[] := debugMoraData = True;

MoraDataDebug[x___] := BadCall["MoraDataDebug",x];

MoraDataNoDebug[] := debugMoraData = False;
 
MoraDataNoDebug[x___] := BadCall["MoraDataNoDebug",x];

MoraDataNoDebug[];

SetMoraNumbers[numbers:{_?NumberQ,_?NumberQ}] := TheNumbers = numbers;

SetMoraNumbers[x___] := BadCall["SetMoraNumbers",x];

ClearDataBase[] := 
   ( 
     InitializeArray[RuleData];
     ClearReductionRules[];
     Clear[RecordHistory];
     Clear[ReductionNumbers];
     ReductionNumbers[_] := {};
   );

ClearDataBase[x___] := BadCall["ClearDataBase",x];

hashTable[x_List] = {};

hashTable[x___] := BadCall["hashTable",x];

If[Global`runningGeneral
           ,
    hashKey[x_RuleTuple] := 
    Module[{data,result},
      data = x[[1,1]];
      If[Head[data]===NonCommutativeMultiply
           , data = Apply[List,data];
           , data = {data};
      ];
      result = Union[Map[TheBase,data]];
      Return[result];
    ];
           ,
    hashKey[x_Rule] := {hashfirst[x[[1]]]};
    hashfirst[x_NonCommutativeMultiply] := x[[1]];
    hashfirst[x_] := x;
    hashfirst[x___] := BadCall["hashfirst",x];
];

hashKey[x___] := BadCall["hashKey",x];

AddToDataBase[x_] := 
Module[{temp},
     temp = x;
     If[Global`runningGeneral
          , temp = CollapsePower[temp];
     ];
     temp = ExpandNonCommutativeMultiply[temp];
     temp = NCGBConvert[temp];
     temp = Flatten[{temp}];
     Return[Union[Map[AddToDataBaseAux,temp]]];
];

AddToDataBase[x___] := BadCall["AddToDataBase",x];

AddToDataBaseAux[x_] := 
Module[{len,i,j,theKey,theTable,result},
     result = -1;
     theKey = hashKey[x];
     theTable = hashTable[theKey];
     len = Length[theTable];
     For[i=1,(i<=len)&&(result==-1),i++,
          j = theTable[[i]];
         If[x===DataElement[j], result = j;];
     ];
     If[result===-1
         , AppendToArray[RuleData,x];
           result = LengthArray[RuleData];
           firstLetter[result] = theKey;
           AppendTo[hashTable[theKey],result];
           RecordHistory[result] = TheNumbers;
     ];
     Return[result];
];

AddToDataBaseAux[x___] := BadCall["AddToDataBaseAux",x];

GBFirstLetter[x_] := firstLetter[x];

GBFirstLetter[x___] := BadCall["GBFirstLetter",x];

firstLetter[x___] := BadCall["firstLetter",x];

WhatIsDataBase[] := Range[1,LengthArray[RuleData]];

WhatIsDataBase[aList:{___?NumberQ}] := Map[RuleData,aList];

WhatIsDataBase[x___] := BadCall["WhatIsDataBase",x];

DataElement[aNumber_?NumberQ] := RuleData[aNumber];

DataElement[x___] := BadCall["DataElement",x];

RuleElement[aNumber_?NumberQ] :=
Module[{temp,result},
     temp = DataElement[aNumber];
     If[Head[temp]===Rule, result = temp;
                         , result = temp[[1]];
     ];
     Return[result];
];

RuleElement[x___] := BadCall["RuleElement",x];

ConditionElement[aNumber_?NumberQ] :=
Module[{temp,result},
     temp = DataElement[aNumber];
     If[Head[temp]===Rule, result = {};
                         , result = temp[[2]];
     ];
     Return[result];
];

ConditionElement[x___] := BadCall["ConditionElement",x];

ParameterElement[aNumber_?NumberQ] :=
Module[{temp,result},
     temp = DataElement[aNumber];
     If[Head[temp]===Rule, result = {};
                         , result = temp[[3]];
     ];
     Return[result];
];

ParameterElement[x___] := BadCall["ParameterElement",x];

AddaMatch[L1_,R1_,L2_,R2_] := AddaMatch[L1,R1,L2,R2,{},{}];

AddaMatch[L1_,R1_,L2_,R2_,newcond_,newparam_] := 
Module[{temp,conddata,paramdata,j,k,thelist},
     temp = SimpleSPolynomial[L1,R1,L2,R2];
     If[temp===0, Return[]];
If[debugMoraData,Print["temp:",temp];];
     If[Global`runningGeneral, 
If[debugMoraData, Print["Starting gen in addamatch"];];
          conddata = Flatten[Map[ConditionElement,TheNumbers]];
          paramdata = Flatten[Map[ParameterElement,TheNumbers]];
          temp = RuleTuple[temp,
                            Join[conddata,newcond],
                            Join[paramdata,newparam]
                          ];
          temp = SimplifyInequality[temp];
          temp = Flatten[{temp}];
          temp = Flatten[CleanUpTuple[temp]];
          If[Global`expandRuleTuples,
             temp = Union[ResolveInequalities[temp]];
          ];
If[debugMoraData, Print["ending gen in addamatch"];
                  Print[ColumnForm[temp]];
                  Input["Type something and then return"];
];
     ];
     If[Global`runningGeneral
          , temp = CollapsePower[temp];
     ];
     temp = NCGBConvert[temp];
     temp = Union[Flatten[{temp}]];
     temp = Select[temp,NonTrivialMoraData];
     temp = Map[AddToDataBase,temp];
     temp = Flatten[{temp}];
     Do[ thelist = Flatten[Reduction[temp[[j]]]];
If[Not[thelist==={}],
If[debugMoraData, 
                  Print["L1:",Format[L1,InputForm]];
                  Print["R1:",Format[R1,InputForm]];
                  Print["L2:",Format[L2,InputForm]];
                  Print["R2:",Format[R2,InputForm]];
                  Print["newcond:",newcond];
                  Print["newparam:",newparam];
                  Print["TheNumbers:",TheNumbers];
                  Print["FirstTuple:",
                        Format[DataElement[TheNumbers[[1]]],InputForm]
                  ];
                  Print["SecondTuple:",
                        Format[DataElement[TheNumbers[[2]]],InputForm]
                  ];
                  Print["thelist:",Format[thelist,InputForm]];

];
];
(*
         If[And[Global`runningGeneral,Global`TalkToMe,Not[thelist=={}]]
              , If[DataElement[thelist[[1]]][[3]]==={}
                     , Print["input:",Format[WhatIsDataBase[
                                                 Flatten[{temp[[j]]}]]
                                             ,InputForm]
                       ];
                       Print["output:",Format[WhatIsDataBase[thelist]
                                              ,InputForm]
                       ];
                       Input[];
                ];
         ];
*)
              
If[debugMoradata,Print["About to add rule tuples"];];
          Do[ AddaRuleTuple[thelist[[k]],{L1,R1,L2,R2}];
(*
           Print["Just processed ",thelist[[k]]];
           Print["Just processed ",Format[DataElement[thelist[[k]]],InputForm]];
           Print["TheNumbers:",TheNumbers];

           Print["DefaultToReduceBy:",DefaultToReduceBy];
*)
(*
           Print["Data Of DefaultToReduceBy:",
                 ColumnForm[
                   Flatten[Map[ReductionRule,DefaultToReduceBy]]
                           ]
           ];
*)
          ,{k,1,Length[thelist]}];
     ,{j,1,Length[temp]}];
     Return[];
];

AddaMatch[x___] := BadCall["AddaMatch",x];

AddaRuleTuple[aNumber_?NumberQ,{L1_,R1_,L2_,R2_}] :=
Module[{aList,theelement,index,k},
     aList = {aNumber};
     Do[ theelement = aList[[k]];
         If[NonTrivialMoraData[theelement],
             index = theelement;
             AppendToArray[SPolynomialArray,index];
             AppendToReduceBy[index];
         ];
     ,{k,1,Length[aList]}];
     Return[]
];

AddaRuleTuple[x___] := BadCall["AddaRuleTuple",x];

ClearSPolynomial[] := InitializeArray[SPolynomialArray];

ClearSPolynomial[x___] := BadCall["ClearSPolynomial",x];

WhatAreSPolynomial[] := ArrayToList[SPolynomialArray];

WhatAreSPolynomial[x___] := BadCall["WhatAreSPolynomial",x];

SimpleSPolynomial[L1_,R1_,L2_,R2_] := 
      ExpandNonCommutativeMultiply[
             NonCommutativeMultiply[
                        L1,
                        RuleElement[TheNumbers[[1]]][[2]],
                        R1] 
              -  
               NonCommutativeMultiply[
                        L2,
                        RuleElement[TheNumbers[[2]]][[2]],
                        R2]
                                  ];

SimpleSPolynomial[x___] := BadCall["SimpleSPolynomial",x];

LeadingCoefficient[x_] := 1;

LeadingCoefficient[stuff_?NumberQ x_] := 
Module[{},
    Print["Warning: Have a non-monic leading coeffiecient"];
    Print[x];
    Print[stuff];
    Return[stuff];
];

LeadingCoefficient[x_NonCommutativeMultiply] := 1;

LeadingCoefficient[stuff_ x_NonCommutativeMultiply] := 
Module[{},
    Print["Warning: Have a non-monic leading coeffiecient"];
    Print[x];
    Print[stuff];
    Return[stuff]
];

LeadingCoefficient[x___] := BadCall["LeadingCoefficient",x];

NonTrivialMoraData[aNumber_?NumberQ] := 
        NonTrivialMoraData[RuleElement[aNumber]];

NonTrivialMoraData[Rule[0,0]] := False;

NonTrivialMoraData[_Rule] := True;

NonTrivialMoraData[x_Global`RuleTuple] := 
     Which[MemberQ[x[[2]],False], True ,
           NonTrivialMoraData[x[[1]]], True,
           True, False
     ];

NonTrivialMoraData[x___] := BadCall["NonTrivialMoraData",x];

ClearReductionRules[] := 
Module[{down},
     down = System`DownValues[ReductionRule];
     down = Map[(#[[1,1,1]])&,down];
     down = Select[down,(Head[#]===Integer)&];
     Map[(ReductionRule[#]=.)&,down];
     Return[];
];

ClearReductionRules[x___] := BadCall["ClearReductionRules",x];

If[Global`runningGeneral, 
     Which[
         Global`generalReduction==="smallNonSymbolicReduction.m"
       , ReductionRule[n_] := ReductionRule[n] = 
            Flatten[{preTransform[NCMonomial[RuleElement[n]]]}];
       , Global`generalReduction==="smallSymbolicReduction.m"
       , ReductionRule[n_] := 
         Module[{result},
             Print["Computing ",n];
             result = RuleOf[n];
             ReductionRule[n] = result;
             Print["Done Computing " , n]; 
             Return[result];
          ];
       , True , Print["Aborting within runningGeneral smallMoraData.m"];
                Abort[];
     ];
                 ,
     ReductionRule[n_] := ReductionRule[n] = 
             preTransform[NCMonomial[RuleElement[n]]];
]; 

Reduction[x_] := Reduction[x,DefaultToReduceBy];

Reduction[aNumber_?NumberQ,aListToReduceBy_List] := 
         Reduction[{aNumber},aListToReduceBy];

Reduction[x_?NotaList,aListToReduceBy_List] :=
Module[{temp},
     temp = AddToDataBase[result];
     temp = Flatten[temp];
     result = Reduction[temp,aListToReduceBy];
     Return[result];
];

NotaList[x_List] := False;
NotaList[x_] := True;

(* ----------------------------------------------- *)
(*    Define the following  only if we have the    *)
(*    correct type of reduction.                   *)
(* ----------------------------------------------- *)
If[Not[Global`runningGeneral],

Reduction[someNumbers_List,aListToReduceBy_List] :=
Module[{new,result,j,num,item,numbers},
  ToReduceBy = Map[{Flatten[{ReductionRule[#]}],#}&,
                    aListToReduceBy
                  ];
  Do[ num = someNumbers[[j]];
      item = DataElement[num];
      item = item[[1]] - item[[2]];
      {result[j],numbers[j]} = DummyReduction[item,num]; 
      result[j] = Flatten[Map[(#->0)&,{result[j]}]];
      result[j] = Flatten[AddToDataBase[result[j]]];
      If[Not[result[j]==={}],
        result[j] = result[j][[1]];
        ReductionNumbers[result[j]] = Join[ReductionNumbers[result[j]],
                                           numbers[j] ];
      ];
  ,{j,1,Length[someNumbers]}];
  new = Flatten[Table[result[j],{j,1,Length[someNumbers]}]];
  Return[new];
];

]; (* end if *)

DummyReduction[poly_,number_] :=
Module[{new,shouldLoop,tempnew,j,numbers},
  numbers = {};
  new = poly;
  shouldLoop = True;
  While[shouldLoop, 
    shouldLoop = False;
    Do[ tempnew = new//. ToReduceBy[[j,1]];
        If[Not[tempnew===new]
          , AppendTo[numbers,ToReduceBy[[j,2]]];
            new = ExpandNonCommutativeMultiply[tempnew];
            shouldLoop = True;
        ];
    ,{j,1,Length[ToReduceBy]}];
  ];
  Return[{new,numbers}];
];

DummyReduction[0,number_] := {0,{}};

(* ----------------------------------------------- *)
(*    Define the following  only if we have the    *)
(*    correct type of reduction.                   *)
(* ----------------------------------------------- *)

If[And[Global`runningGeneral,
       Global`generalReduction==="smallNonSymbolicReduction.m"],

Reduction[aList_List,aListToReduceBy:{___?NumberQ}] := 
Module[{ToReduceBy,rule,newrule,newnumbers,data,j},
     ToReduceBy = Flatten[Map[ReductionRule,aListToReduceBy]];
     newnumbers = {};
     Do[ data = DataElement[aList[[j]]];
         rule = NCMonomial[data[[1]]];
         newrule = rule//.ToReduceBy;
         If[Not[rule===newrule], newrule = CollapsePower[newrule];
                                 newrule = NCUnMonomial[newrule];
                                 AppendTo[newnumbers,
                                          {AddToDataBase[
                                            RuleTuple[newrule,
                                                      data[[2]],
                                                      data[[3]]
                                                     ]
                                                        ]}
                                 ];
                               , AppendTo[newnumbers,{aList[[j]]}];
         ];
     ,{j,1,Length[aList]}];
     Return[newnumbers];
];

]; (* end if *)
 


(* ----------------------------------------------- *)
(*    Define the following  only if we have the    *)
(*    correct type of reduction.                   *)
(* ----------------------------------------------- *)

If[And[Global`runningGeneral,
       Global`generalReduction==="smallSymbolicReduction.m"],

RuleOf[n_?NumberQ] := 
Module[{x,result},
     x = DataElement[n];
     Which[ x[[1]]===(0->0), result = {};
          , MemberQ[x[[2]],False], result = {};
          , True, result = ruleOf[x,wasPropogated[n]];
      ];
      Return[result];
];

wasPropogated[_?NumberQ] := False;

wasPropogated[x___] := BadCall["wasPropogated",x];

ruleOf[aRuleTuple_Global`RuleTuple,aFlag_] := 
Module[{ruletuples,len,j,result,
        LHS,RHS,LHSOfRule,RHSOfRule},
    If[aFlag
         , ruletuples = {aRuleTuple};
           ruletuples = SimpleLeftPatternRuleTuple[ruletuples];
         , ruletuples = Flatten[{NCGBConvert[aRuleTuple]}];
           ruletuples = MakeLiteral[ruletuples];
         , BadCall["ruleOf",aRuleTuple,aFlag];
    ];
    ruletuples = PowerToLazyPower[ruletuples];
    ruletuples = Flatten[ruletuples];
    len = Length[ruletuples];
    LHS = aRuleTuple[[1,1]];
    RHS = aRuleTuple[[1,2]];
    LHSOfRule = ToString[Format[LHS,InputForm]];
    RHSOfRule = ToString[Format[RHS,InputForm]];
    Do[result[j] = 
           {
             StringJoin["Literal[NonCommutativeMultiply[front___,",
                     Aux[ruletuples[[j,1,1]]],
                     ",back___]] :> ",
                     "front**(",
                     ToString[Format[ruletuples[[j,1,2]],InputForm]],
                     ")**back /; Inequalities`InequalityFactQ[",
                     ToString[Format[ruletuples[[j,2]],InputForm]],
                     "]"
              ],
             StringJoin["Literal[NonCommutativeMultiply[",
                     Aux[ruletuples[[j,1,1]]],
                     ",back___]] :> ",
                     "(",
                     ToString[Format[ruletuples[[j,1,2]],InputForm]],
                     ")**back /; Inequalities`InequalityFactQ[",
                     ToString[Format[ruletuples[[j,2]],InputForm]],
                     "]"
              ],
             StringJoin["Literal[NonCommutativeMultiply[front___,",
                     Aux[ruletuples[[j,1,1]]],
                     "]] :> ",
                     "front**(",
                     ToString[Format[ruletuples[[j,1,2]],InputForm]],
                     ")/; Inequalities`InequalityFactQ[",
                     ToString[Format[ruletuples[[j,2]],InputForm]],
                     "]"
              ]
             };
        If[Not[Head[LHS]===NonCommutativeMultiply]
             , AppendTo[result[j],
                            StringJoin[
                     Aux[ruletuples[[j,1,1]]],
                     " :> ",
                     ToString[Format[ruletuples[[j,1,2]],InputForm]],
                     " /; Inequalities`InequalityFactQ[",
                     ToString[Format[ruletuples[[j,2]],InputForm]],
                     "]"
                                      ]
                       ];
             , AppendTo[result[j],
             StringJoin["Literal[NonCommutativeMultiply[",
                     Aux[ruletuples[[j,1,1]]],
                     "]] :> ",
                     "(",
                     ToString[Format[ruletuples[[j,1,2]],InputForm]],
                     ")/; Inequalities`InequalityFactQ[",
                     ToString[Format[ruletuples[[j,2]],InputForm]],
                     "]"
              ] ];
        ];
(*
If[debugMoraData, Print["result[",j,"] is ",result[j]];
];
*)
       result[j] = ToExpression[result[j]];
    ,{j,1,len}];
    Return[Flatten[Table[result[j],{j,1,len}]]];
];

RuleOf[x___] := BadCall["RuleOf",x];

Aux[x_] :=
Module[{result},
     If[Head[x]===NonCommutativeMultiply
          , result = Apply[List,x];
            result = ToString[Format[result,InputForm]];
            result = StringTake[result,{2,StringLength[result]-1}];
         ,  result = ToString[Format[x,InputForm]];
    ];
    Return[result];
];

Aux[x___] := BadCall["Aux",x];

Reduction[aList_List,aListToReduceBy:{___?NumberQ}] := 
Module[{result,j,temp,index,elem,k,i,len,p,item},
     If[WhatIsPropogateReduction[]
          , temp = MoraPropogate[aListToReduceBy];
          , temp = aListToReduceBy;
          , BadCall["Reduction",aList,aListToReduceBy];
     ];
     temp = Flatten[temp];
     len = 0;
     Do[ index = temp[[i]];
         item = ReductionRule[index];
         If[Head[item]===List
             , Do[ len = len + 1;
                   elem[len] = {item[[k]],index};
               ,{k,1,Length[item]}];
             , len = len + 1;
               elem[len] = {item,index};
          ];
     ,{i,1,Length[temp]}];
     ToReduceBy = Table[elem[p],{p,1,len}];
     result = Table[
          If[Not[NonTrivialMoraData[aList[[j]]]]
              , {}
              , ReductionOnOne[aList[[j]]]
          ],{j,1,Length[aList]}];
     result = Union[Flatten[result,1]];
     Return[result];
];

ReductionOnOne[aNumber_?NumberQ] :=
Module[{data,result},
     data = DataElement[aNumber];
     result = Union[reductionOnOne[data]];
     result = RecordReductions[aNumber,data,result];
     Return[result];
];

reductionOnOne[data_] :=
Module[{newdata,item,polys,i,j,numbers,newerdata},
     newdata = Union[ResolveInequalities[{data}]];
     newerdata = {};
     Do[ item = newdata[[i]];
         {polys,numbers} = SimpleReduce[item];
         Do[ AppendTo[newerdata,{polys[[j]],numbers}];
         ,{j,1,Length[polys]}];
      ,{i,1,Length[newdata]}];
     newerdata = Select[newerdata,NonTrivialMoraData[#[[1]]]&];
     Return[newerdata];
];

RecordReductions[aNumber_?NumberQ,data_,newdata_] :=
Module[{newdataitem,k,newnumbers,aList,result,temp},
     Do[ {newdataitem,aList} = newdata[[k]];
         If[Not[newdataitem[[1,1]]===data]
             , If[And[Global`LookForBug,Length[newdataitem[[3]]]==1]
                    , If[Not[temp==={}]
                           , Print["data:",data];
                             Print["aNumber:",aNumber];
                             Print["newdata:",newdata];
                             Print["TheNumbers:",TheNumbers];
                      ];
               ];
               newdataitem = CleanUpTuple[newdataitem];
               newnumbers[k] = Flatten[{AddToDataBase[newdataitem]}];
               Map[(ReductionNumbers[#] = Join[ReductionNumbers[#],aList])&,
                   newnumbers[k]];
             , newnumbers[k] = aNumber;
         ];
     ,{k,1,Length[newdata]}];
     result = Table[newnumbers[k],{k,1,Length[newdata]}];
     result = Flatten[result];
     Clear[newnumbers];
     Return[result];
];

ReductionOnOne[x___] := BadCall["ReductionOnOne",x];

SimpleReduce[aRuleTuple_Global`RuleTuple] := 
Module[{temp,result,data,numbers},
     Inequalities`SetInequalityFactBase[aRuleTuple[[2]]];
     data = PowerToLazyPower[aRuleTuple[[1]]];
     data = data[[1]] - data[[2]];
     {temp,numbers} = FixedPoint[SimpleReduceAux,{data,{}},40];
     Inequalities`SetInequalityFactBase[{}];
     temp = LazyPowerToPower[temp];
     result = aRuleTuple;
     result[[1]] = temp;
     result = Union[Flatten[{NCGBConvert[result]}]];
     result = Flatten[{FixPowerRuleTuple[result]}];
     result = Union[Flatten[{NCGBConvert[result]}]];
     result = Select[result,NonTrivialMoraData];
     result = Flatten[result];
     Return[{result,numbers}]
];

SimpleReduce[x___] := BadCall["SimpleReduce",x];

SimpleReduceAux[{apolynomial_,oldnumbers_}] := 
Module[{result,numbers},
If[debugMoraData,Print["Input:",apolynomial];];
     If[PackageReduction, result = Apply[PackageName,{apolynomial}];
                        , {result,numbers} = DummyReduction[apolynomial,0];
                        , Abort[];
     ];
     result = CollapseLazyPower[ExpandNonCommutativeMultiply[result]];
If[debugMoraData,Print["output:",result];];
     Return[{result,Join[oldnumbers,numbers]}];
];

SimpleReduceAux[x___] := BadCall["SimpleReduceAux in Reduction",x];

ResolveInequalities[aList_List] := Flatten[Map[ResolveInequalities,aList]];

ResolveInequalities[aRuleTuple_Global`RuleTuple] := 
     If[MemberQ[aRuleTuple[[2]],False]
          , {}
          , CleanUpTuple[ExtendCases[aRuleTuple,aRuleTuple[[3]]]]
     ];

ResolveInequalities[x___] := BadCall["ResolveInequalities",x];

ExtendCases[aRuleTuple_Global`RuleTuple,{}] := {aRuleTuple};

ExtendCases[aRuleTuple_Global`RuleTuple,{var_,othervars___}] :=
Module[{result}, 
     result = 
     Flatten[Map[ExtendCases[#,{othervars}]&,
                 ExtendCasesAux[aRuleTuple,var]
                ]
           ];
     Return[result];
];

ExtendCasesAux[aRuleTuple_Global`RuleTuple,var_Symbol] :=
Module[{triple,result},
     triple = BoundedTriple[var,aRuleTuple[[2]]];
     If[triple[[1]]
          , result = extendCasesAux[aRuleTuple,var,triple];
          , result = {aRuleTuple};
          , Abort[];
     ];
     Return[result];
];
   
extendCasesAux[aRuleTuple_Global`RuleTuple,var_Symbol,{_,low_,high_}] :=
Module[{values,result},
     values = Range[low,high];
     result = aRuleTuple;
     result[[3]] = Complement[result[[3]],{var}];
     result = Map[(result/.Evaluate[var]->#)&,values]; 
     Return[result];
];

extendCasesAux[x___] := BadCall["extendCasesAux",x];

UsePackageReduction[x_] := PackageReduction = x;

UsePackageReduction[x___] := BadCall["UsePackageReduction",x];

UsePackageReduction[False];

SetPackageReductionName[x_] := PackageName = x;

SetPackageReductionName[x___] := BadCall["SetPackageReductionName",x];

SetPackageReduction[];

]; (* end if *)

Reduction[x___] := BadCall["Reduction",x];

SetToReduceBy[x_] := DefaultToReduceBy = x;

SetToReduceBy[x___] := BadCall["SetToReduceBy",x];

AppendToReduceBy[x_] := AppendTo[DefaultToReduceBy,x];

AppendToReduceBy[x___] := BadCall["AppendToReduceBy",x];

MoraPropogate[aListOfNumbers_List]:=
Module[{propogatelist, unpropogatedlist,thelist,numbers},
If[debugMoraAlg,Print["In MoraPropogate"];];
   numbers=aListOfNumbers;
   propogatelist=Propogate`Propogate[numbers];
   unpropogatedlist=Complement[numbers,propogatelist[[2]]];
   thelist=Union[unpropogatedlist,propogatelist[[1]]];
If[debugMoraAlg,Print["thelist:",thelist];];
   Map[(wasPropogated[#] = True;)&,
       Complement[thelist,aListOfNumbers]
      ];
   Return[thelist];
];

MoraPropogate[x___] := BadCall["MoraPropogate",x];

SetPropogateReduction[x_] := 
     (Print["Setting PROPOGATE REDUCTION to ",x];
      privatePropogateReductionVariable = x
     );

SetPropogateReduction[x___] := BadCall["SetPropogateReduction",x];

WhatIsPropogateReduction[] := privatePropogateReductionVariable;

WhatIsPropogateReduction[x___] := BadCall["WhatIsPropogateReduction",x];

SetPropogateReduction[False];

PolynomialAsAList[x_Plus] := 
Module[{result},
   result = Apply[List,x];
   result = Map[TermAsAList,result];
   Return[result];
];

PolynomialAsAList[x_Times] := {TermAsAList[x]};
PolynomialAsAList[c_. x_NonCommutativeMultiply] := {TermAsAList[x]};
PolynomialAsAList[x_] := {TermAsAList[x]};

PolynomialAsAList[x___] := BadCall["PolynomialAsAList",x];


TermAsAList[c_. x_NonCommutativeMultiply] := Map[TheBase,Apply[List,x]];
TermAsAList[c_?NumberQ x_] := {TheBase[x]};
TermAsAList[x_] := {TheBase[x]};


TermAsAList[x___] := BadCall["TermAsAList",x];

WhatIsHistory[aList_List] := Map[WhatIsHistory,aList];

WhatIsHistory[n_?NumberQ] := {RecordHistory[n],ReductionNumbers[n]};

WhatIsHistory[aRule_Rule] := Apply[WhatIsHistory,AddToDataBase[aRule]];

WhatIsHistory[x___] := BadCall["WhatIsHistory",x];

WhatIsDataBaseAndHistory[aList_List] := Map[WhatIsDataBaseAndHistory,aList];

WhatIsDataBaseAndHistory[n_?NumberQ] := 
        {n,DataElement[n],WhatIsHistory[n]};

WhatIsDataBaseAndHistory[aRule_?NumberQ] := 
        {aRule,WhatIsHistory[aRule]};

WhatIsDataBaseAndHistory[x___] := BadCall["WhatIsDataBaseAndHistory",x];

End[];
EndPackage[]
