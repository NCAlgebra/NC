(* :Title: 	smallMoraAlg // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	MoraAlg` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :01/31/94: Removed SimpleConvert2 from BeginPackage statement.(mstankus)
*)
BeginPackage["MoraAlg`",
     "Tuples`","NCGBConvert`","NCGBMax`",
     "MoraData`","MatchImplementation`",
     "ArrayManager`","preTransform`","NCMonomial`","NCMtools`",
     "ManipulatePower`","NCMakeGreater`",
     "NonCommutativeMultiply`","Global`","Grabs`","Errors`"];

Clear[MorasAlgorithm];

MorasAlgorithm::usage =
     "Please use NCMakeRules";

Clear[NCMakeRules];

NCMakeRules::usage = 
       "NCMakeRules[aListOfPolynomials,aNumber,opts] with or without \
        opts. NCMakeRules converts the polynomials \
        to rules. NCMakeRules calls MoraOneStep \
        iteratively at most aNumber times or until a Groebner basis \
        is found. \n \ 
        THIS ROUTINE MAY RUN FOREVER *THEORETICALLY*!!! \n\n \
        opts can any combination of the following in any order: \n\n \
        (1) NCSCleanUpRules->aFlag \n aFlag is either True or False. \
        If aFlag is True, then the NCSCleanUpRules algorithm will be \
        called after each call to MoraOneStep. \n \
        (2) Batch->aFlag \n  aFlag is either True or False. \
        If aFlag is False, then the user will be prompted before \
        each iteration. \n \
        (3) MorasAlgOutputPartialResult->aFlag \n \
        aFlag is either True or False. If aFlag is True, then
        NCMakeRules 
        (4) GroebnerPolynomials->aList \n \
        aList is a list of rules or rule tuples.
        See MoraOneStep,NCSCleanUpRules,FindMatches.";

Clear[MoraMany];

MoraMany::usage = 
     "MoraMany loops through MoraOneStep many times.";

Clear[WhatIsPartialBasis];

WhatIsPartialBasis::usage = 
     "WhatIsPartialBasis[] returns the last partial basis generated \
      by NCMakeRules.";

Clear[WhatIsLeftToMatchAgainst];

WhatIsLeftToMatchAgainst::usage = 
     "WhatIsLeftToMatchAgainst[] returns the last set of rules\
      to still be matched against. If this returns an empty list, then \
      the result from WhatIsPartialBasis[] is a Groebner basis.";

Clear[MoraOneStep];

MoraOneStep::usage = 
      "MorasOneStep[aListOfNumbers,anotherListOfNumbers] \
       implemenents a step of Moras Algorithm \
       via a rule database.";

Clear[CleanUpBasis];

CleanUpBasis::usage =
    "Please use NCSCleanUpRules instead of CleanUpBasis.";

Clear[NCSCleanUpRules];

NCSCleanUpRules::usage = 
    "NCSCleanUpRules has two applications. It is an option for \
     NCMakeRules and it is also a routine which can be \
     invoked by the command NCSCleanUpRules[aListOfNumbers]. \n \
     See NCMakeRules.";

Clear[ReadOnlyData];

ReadOnlyData::usage = 
     "ReadOnlyData";

Clear[Batch];

Batch::usage = 
     "Batch is an option for NCMakeRules. \
      NCMakeRules may run infinitely long. If the \
      option Batch->True is added, then the user is prompted each \
      iteration of NCMakeRules and asked if he wishes \
      to continue. The default is False.";

Clear[MoraAlgOutputPartialResult];

MoraAlgOutputPartialResult::usage =
     "MoraAlgOutputPartialResult is an option for Moras algorithm";

Clear[GroebnerSimplify];

GroebnerSimplify::usage = 
     "Please use NCSimplifyAll instead of GroebnerSimplify";

Clear[NCSimplifyAll];

NCSimplifyAll::usage = 
     "NCSimplifyAll";

Clear[GroebnerPolynomials];

GroebnerPolynomials::usage = 
     "GroebnerPolynomials is an option for Moras algorithm";

Clear[MoraAlgDebug];

MoraAlgDebug::usage = 
     "MoraAlgDebug";

Clear[MoraAlgNoDebug];

MoraAlgNoDebug::usage = 
     "MoraAlgNoDebug";

Clear[FindMatches];

FindMatches::usage = 
       "FindMatches[aNumber,anotherNumber] (where \
        aNumber and anotherNumber are numbers) finds all \
        Matches of type 1 or 3 between the two pieces of data\
        DataElement[aNumber] and DataElement[anotherNumber]. \
        FindMatches[aNumber,anotherNumber]  \
        is NOT the same as \
        FindMatches[anotherNumber,aNumber]. \
        This routine does little more than call \
        Match1Implementation and Match3Implementation.";

Clear[AMatchSPoly];

AMatchSPoly::usage = 
     "AMatchSPoly";

Clear[MoraMatchDone];

MoraMatchDone::usage = 
     "MoraMatchDone";

Clear[MoraPermuteOrdering];

MoraPermuteOrdering::usage=
     "MoraPermuteOrdering[aListOfStartingRelations,aListOfSymbols] \
      calls NCMakeRules for every permutation of the ordering of \
      the symbols in aListOfSymbols.  aListOfSymbols is limited to \
      6 symbols.";

Clear[PropogateFlag];

PropogateFlag::usage=
     "PropogateFlag is an option for NCMakeRules."

Clear[PropogateReductionFlag];

PropogateReductionFlag::usage=
     "PropogateReductionFlag is an option for NCMakeRules.";

Clear[IsAGroebnerBasis];

IsAGroebnerBasis::usage =
     "IsAGroebnerBasis is an option for NCMakeRules.";

Clear[LotsOfOutput];

LotsOfOutput::usage =
     "LotsOfOutput is an option for NCMakeRules.";

Clear[SortRelations];

SortRelations::usage =
     "SortRelations";

Clear[OrderBetween];

OrderBetween::usage =
     "OrderBetween";

Clear[WhatAreNumbers];

WhatAreNumbers::usage = 
    "WhatAreNumbers";

Clear[SetStartingRelations];

SetStartingRelations::usage =
     "SetStartingRelations";

Clear[WhatAreStartingRelations];

WhatAreStartingRelations::usage =
     "WhatAreStartingRelations";

Clear[FinishedComputingBasisQ];

FinishedComputingBasisQ::usage =
     "FinishedComputingBasisQ";

Clear[MinimizeOutput];

MinimizeOutput::usage =
   "MinimizeOutput is an option for NCMakeRules";

Clear[FakeKnowns];

FakeKnowns::usage =
   "FakeKnowns";

Clear[UseFakeKnowns];

UseFakeKnowns::usage =
   "UseFakeKnowns";

Begin["`Private`"];

MoraAlgDebug[] := debugMoraAlg = True;

MoraAlgDebug[x___] := BadCall["MoraAlgDebug",x];

MoraAlgNoDebug[] := debugMoraAlg = False;
 
MoraAlgNoDebug[x___] := BadCall["MoraAlgNoDebug",x];

MoraAlgNoDebug[];

GroebnerSimplify[x___] := 
Module[{},
   Print["Please use NCSimplifyAll instead of GroebnerSimplify"];
   Return[NCSimplifyAll[x]];
];

NCSimplifyAll[polys_,aList_List,iter_?NumberQ,opts___] :=
Module[{},
     NCMakeRules[aList,iter,GroebnerPolynomials->Flatten[{polys}],opts];
     If[TheGroebnerPolynomials=={}, 
            TheGroebnerPolynomials = "THE EMPTY SET -- Expressions reduced to zero";
     ];
     Return[TheGroebnerPolynomials];
];

finishedComputingBasisQ = False;

MorasAlgorithm[x___] :=
Module[{},
   Print["Please use NCMakeRules rather than MorasAlgorithm in the future."];
   Return[NCMakeRules[x]];
];

Options[NCMakeRules] := {NCSCleanUpRules->True,
                            Batch->True,
                            MoraAlgOutputPartialResult->False,
                            PropogateFlag->False,
                            PropogateReductionFlag->False,
                            LotsOfOutput->False,
                            UseFakeKnowns->False,
                            MinimizeOutput->False,
                            GroebnerPolynomials->{}};

NCMakeRules[polys_List,iter_?NumberQ,opts___Rule] := 
Module[{thing,result,groebnerPolynomial,gPoly},
      LocalMoraAnnounce = Not[MinimizeOutput/.{opts}/.Options[NCMakeRules]];
      If[LocalMoraAnnounce,(* True *)
                          ,(* False *)
                          , BadCall["NCMakeRules",polys,iter,opts];
      ];
      finishedComputingBasisQ = False;
      ClearToReduceBy[];
      ClearDataBase[];
      SetMoraNumbers[{0,0}];
      Clear[DidTheMatch];
      DidTheMatch[x_,y_] := False;
      groebnerPolynomial =  GroebnerPolynomials/.{opts}/.
                                      Options[NCMakeRules];
      If[Global`runningGeneral
           , thing = CollapsePower[polys];
             thing = ToRuleTuple[thing];
             thing = SmartTupleUnion[thing];
             thing = NCGBConvert[thing];
           , If[Not[ConstantCoeff[polys]], 
                  Print["The coefficients aren`t numbers"];
                  Abort[];
             ];
             thing = NCMonomial[polys];
             thing = ExpandNonCommutativeMultiply[thing];
             thing = NCGBConvert[thing];
      ];
      thing = Flatten[thing];
      SetStartingRelations[thing];
      thing = AddToDataBase[thing];
      If[Global`runningGeneral
           , gPoly = CollapsePower[groebnerPolynomial];
             gPoly = ToRuleTuple[gPoly];
           , If[Not[ConstantCoeff[groebnerPolynomial]], 
                  Print["The coefficients aren`t numbers"];
                  Abort[];
             ];
             gPoly = NCMonomial[groebnerPolynomial];
             gPoly = ExpandNonCommutativeMultiply[gPoly];
      ];
      gPoly = Flatten[gPoly];
      gPoly = Flatten[Map[AddToDataBase,gPoly]];
      TheGroebnerPolynomials = gPoly;
      result = MoraMany[thing,iter,opts];
      If[Not[groebnerPolynomial==={}],
              Print["The result of the Groebner reduction is"];
              Print[WhatIsDataBase[TheGroebnerPolynomials]];
              Print["which is data items ",TheGroebnerPolynomials];
      ];
(*    Return[{result,WhatIsDataBase[result]}]; *)
      Return[result];
];

NCMakeRules[x___] := BadCall["NCMakeRules",x];

ConstantCoeff[x_RuleTuple] := ConstantCoeff[x[[1]]];

ConstantCoeff[x_Rule] := 
Module[{temp},
     temp = Apply[List,x];
     temp = Map[ConstantCoeff,temp];
     Return[Apply[And,temp]];
];

ConstantCoeff[x_Plus] := 
Module[{temp},
     temp = Apply[List,x];
     temp = Map[ConstantCoeff,temp];
     Return[Apply[And,temp]];
];

ConstantCoeff[x_List] := 
Module[{temp},
     temp = Apply[List,x];
     temp = Map[ConstantCoeff,x];
     Return[Apply[And,temp]];
];

ConstantCoeff[x_?NumberQ] := True;

ConstantCoeff[x_Complex] := True;

ConstantCoeff[c_?NumberQ y_NonCommutativeMultiply] := True;

ConstantCoeff[c_Complex y_NonCommutativeMultiply] := True;

ConstantCoeff[y_NonCommutativeMultiply] := True;

ConstantCoeff[c_?NumberQ y_Power] := True;

ConstantCoeff[c_Complex y_Power] := True;

ConstantCoeff[y_Power] := True;

ConstantCoeff[c_?NumberQ x_] := True;

ConstantCoeff[c_Complex x_] := True;

ConstantCoeff[x_ y_] := False;

ConstantCoeff[x_] := True;

ConstantCoeff[x___] := BadCall["ConstantCoeff",x];

MoraMany[big:{___?NumberQ},iter_?NumberQ,opts___Rule] :=
Module[{outputResultFlag,NCSCleanUpRulesFlag,batch,
        record,askBatch,result,date,step,temp,theLists,
        response,new,propflag,propredflag,shouldLoop,
        newTheGroebnerPolynomials,groebnerpoly,Clean},
  lotsOfOutput = LotsOfOutput/.{opts}/.Options[NCMakeRules];
  propflag= PropogateFlag/.{opts}/.Options[NCMakeRules];
  If[Not[MemberQ[{True,False},propflag]],
        Print["PropogateFlag must be either True or False."];
        Abort[];
  ];
  propredflag= PropogateReductionFlag/.{opts}/.Options[NCMakeRules];
  If[Not[MemberQ[{True,False},propredflag]],
        Print["PropogateReductionFlag must be either True or False."];
        Abort[];
  ];
  SetPropogateReduction[propredflag];
  outputResultFlag = MoraAlgOutputPartialResult/. {opts} /. Options[ 
                                 NCMakeRules                    ];
  If[Not[MemberQ[{True,False},outputResultFlag]],
        Print["MoraAlgOutputPartialResult must be either True or False."];
        Abort[];
  ];
  UseFakeKnownsFlag = UseFakeKnowns/. {opts} /.Options[NCMakeRules];

  NCSCleanUpRulesFlag = NCSCleanUpRules/. {opts} /. Options[   
                                 NCMakeRules      ];
  If[Not[MemberQ[{True,False},NCSCleanUpRulesFlag]],
        Print["NCSCleanUpRules must be either True or False."];
        Abort[];
  ];
  If[Not[FreeQ[{opts},CleanUpBasis]]
       , Print["Use NCSCleanUpRules instead of CleanUpBasis for options"];
         BadCall["MoraMany",big,iter,opts];
  ];
  batch = Batch/. {opts}/.Options[NCMakeRules];
  If[Not[MemberQ[{True,False},batch]],
        Print["Batch must be either True or False."];
        Abort[];
  ];
  If[Not[FreeQ[{opts},IsAGroebnerBasis]]
       , temp = Select[{opts},(#[[1]]===IsAGroebnerBasis)&];
         theLists = Map[#[[2]]&,temp];
         RegisterTheBasis[theLists,big];
  ];
  record := RecordPartialBasis[result];
  clean := If[NCSCleanUpRulesFlag
                , new = NCSCleanUpRules[result[[1]]];
                  If[Not[Sort[new]===Sort[result[[1]]]]
                      , result = {new,new};
                  ];
           ];
  askBatch := 
      If[Not[batch],Print["If you do not want to proceed,"];
                    Print["type n and RETURN,"];
                    Print["otherwise type anything else and RETURN"];
                    response = InputString[];
                    If[response === "n",Return[result]]
      ];
   If[outputResultFlag, date = TheDate[];
        outputResults := 
                 Put[{WhatIsDataBase[result[[1]]],
                      WhatIsDataBase[result[[2]]]},
                      StringJoin[date,".Answer.",ToString[step-1]]];
   ];
   output := If[outputResultFlag, outputResults;
                                , printIt[result];
             ];

   groebnerpoly := 
       If[Not[TheGroebnerPolynomial==={}], 
          newTheGroebnerPolynomials = 
               Reduction[TheGroebnerPolynomials,result[[1]]];
          If[Not[newTheGroebnerPolynomials===TheGroebnerPolynomials],
              TheGroebnerPolynomials = newTheGroebnerPolynomials;
              If[LocalMoraAnnounce, 
                Print["newTheGroebnerPolynomials: ",
                       Format[WhatIsDataBase[
                              newTheGroebnerPolynomials
                                            ],
                            InputForm]
                     ];
              ];
          ];
      ];
   result = {big,big};
   clean;

If[debugMoraAlg
     , Print["Starting with ",result];
       Print[ColumnForm[WhatIsDataBase[result[[1]]]]];
];
   step = 1;
   shouldLoop = True;
   While[Not[Length[result[[2]]]=== 0] && step<=iter && shouldLoop,
      Print["MoraMany :-) About to execute the ",step,
            "th step"];
      If[propflag,result = Map[MoraPropogate,result]];      
      record;
      If[UseFakeKnownsFlag, FakeKnowns[result[[1]]];];
      result =  Apply[MoraOneStep,result];
      If[step >= iter 
         , clean;
           record; 
           output;
           shouldLoop = False;
         , askBatch;
           step = step + 1;
           clean;
           output;
           groebnerpoly;
      ];
   ];
   clean;
   If[shouldLoop, Print["\n \n"];
                  Print["Finished calculating the basis."];
                  finishedComputingBasisQ = True; 
   ];
   record;
   If[outputResultFlag
        , lastSortedRelations = SortRelations[WhatIsDataBase[result[[1]]]];
   ];
   savedNumbers = result[[1]];
   Return[lastSortedRelations];
];


MoraMany[x___] := BadCall["MoraMany",x];

TheDate[] := 
Module[{temp},
     temp = Date[];
     temp = Map[{#,"."}&,temp];
     temp = Flatten[temp];
     temp = Map[ToString,temp];
     temp = Apply[StringJoin,temp];
     Return[temp];
];

TheDate[x___] := BadCall["TheDate",x];

printIt[{first_,first_}] :=
Module[{},
  lastSortedRelations = SortRelations[WhatIsDataBase[first]];
  Print["\n \n"];
  Print["Basis generated so far (",Length[first]," elements). \n"];
  Print[ColumnForm[Map[Format[#,InputForm]&,
                       lastSortedRelations
                      ]
                  ]
  ];  
  Print["\n \n"];
];

printIt[{first_,second_}] :=
Module[{},
    lastSortedRelations = SortRelations[WhatIsDataBase[first]];
    Print["\n \n"];
    Print["Basis generated so far (",Length[first]," elements). \n"];
    Print[ColumnForm[Map[Format[#,InputForm]&,
                         lastSortedRelations
                        ]
                    ]
    ];  
    If[LocalMoraAnnounce,
      Print["\n\n"];
      Print["Polynomials to be matched (",Length[second]," elements). \n"];
      Print[ColumnForm[Map[Format[#,InputForm]&,
                           SortRelations[WhatIsDataBase[second]]
                          ]
                      ]
      ];
    ];
    Print["\n \n"];
];

RecordPartialBasis[{first_,second_}] := 
    (
     PartialBasis = WhatIsDataBase[first];
     LeftToMatchAgainst = WhatIsDataBase[second];
    );

RecordPartialBasis[x___] := BadCall["RecordPartialBasis",x];

WhatIsPartialBasis[] := PartialBasis;

WhatIsPartialBasis[x___] := BadCall["WhatIsPartialBasis",x];

WhatIsLeftToMatchAgainst[] := LeftToMatchAgainst;

WhatIsLeftToMatchAgainst[x___] := BadCall["WhatIsLeftToMatchAgainst",x];

MoraOneStep[big:{___?NumberQ},small:{___?NumberQ}] :=
Module[{newbig,newsmall,len,smartbig,smartsmall,j,k,temp,perm,len2},
     Print["MoraOneStep :-) Starting"];
     ClearToReduceBy[];
     SetToReduceBy[big];
     ClearSPolynomial[];
     len = Length[big];
     smartbig = Map[SmartTupleUnionNumber[#,"B"]&,big];
     smartsmall = Map[SmartTupleUnionNumber[#,"S"]&,small];
     len2 = Length[smartsmall];
     Print["About to compute ",len," matches."];
     Do[ If[LocalMoraAnnounce, 
              If[j==len
                  , WriteString[$Output,j,"\n"];
                  , WriteString[$Output,j,","];
              ];
         ];
         perm = smartbig[[j]];
If[lotsOfOutput, WriteString[$Output,"\n("];];
         Do[ temp = smartsmall[[k]];
If[lotsOfOutput , WriteString[$Output,k,","];];
             AMatchSPoly[perm,temp];
         ,{k,1,len2}];
If[lotsOfOutput, WriteString[$Output,")"];];
(*
         Map[AMatchSPoly[smartbig[[j]],#]&,smartsmall]; 
*)
     ,{j,1,len}];
     newsmall = WhatAreSPolynomial[];
If[debugMoraAlg,Print["Spolys:",newsmall]];
     newsmall = Select[newsmall,NonTrivialMoraData];

     newbig = Union[newsmall,big];
   
     Print["MoraOneStep :-) Exiting"];
     Return[{newbig,newsmall}] 
];

MoraOneStep[x___] := BadCall["MoraOneStep",x];

CleanUpBasis[x___] := 
Module[{},
   Print["Please use NCSCleanUpRules instead of CleanUpBasis."];
   Return[NCSCleanUpRules[x]];
];

Options[NCSCleanUpRules] = {ReadOnlyData->{}};

(* ReadOnlyData is a list of numbers *)
NCSCleanUpRules[aList_List,opts___Rule] := 
Module[{readonly,unchanged,G,G1,fNumber,f1,theelement,
        result,indexes,data,len,k},
     If[LocalMoraAnnounce, Print["NCSCleanUpRules :-) Entering"];];
     readonly = ReadOnlyData/. {opts} /. Options[NCSCleanUpRules];
     unchanged = False;
     InitializeArray[G];
     Map[AppendToArray[G,#]&,aList];
     While[Not[unchanged], 
           len = G[0];
           If[LocalMoraAnnounce, Print[G[0]," to check :-)"];];
           unchanged = True;
           G1 = {};
           While[G[0]>0, 
               fNumber = G[G[0]];
               G[0] = G[0] - 1;
               If[LocalMoraAnnounce,
                   If[G[0]==0 
                       , WriteString[$Output,len-G[0],"\n"];
                       , WriteString[$Output,len-G[0],","];
                   ];
               ];
               f1 = Reduction[fNumber,
                              Flatten[Union[G1,ArrayToList[G],readonly]]];
               f1 = Flatten[f1];
               Do[ theelement = f1[[k]];
                   If[theelement===fNumber
                        , AppendTo[G1,fNumber];
                        , data = DataElement[theelement];
                          unchanged = False;
                          If[NonTrivialMoraData[data],
                             indexes = AddToDataBase[data];
                             G1 = Join[G1,indexes];
                          ];
                   ];
               ,{k,1,Length[f1]}];
           ];
           Map[AppendToArray[G,#]&,G1];
     ];
     If[LocalMoraAnnounce,Print["NCSCleanUpRules :-) Exiting"];];
     result = ArrayToList[G];
     result = Select[result,NonTrivialMoraData];
     Clear[G];
     Return[result];
];
                               
NCSCleanUpRules[x___] := BadCall["NCSCleanUpRules",x];

FindMatches[aNumber_?NumberQ,anotherNumber_?NumberQ] := 
Module[{leading1,leading2},
       {leading1,leading2} = Map[NCMToList,
                                 FindMatchesAux[aNumber,anotherNumber]
                                ];
       If[And[Not[leading1==={0}],Not[leading2==={0}]],
          Match1Implementation[leading1,leading2];
          Match3Implementation[leading1,leading2];
       ];
       Return[]
];

FindMatches[x___] := BadCall["FindMatches",x];

FindMatchesAux[m_,n_] := 
Module[{},
    SetMoraNumbers[{m,n}]; 
    Return[{RuleElement[m][[1]],RuleElement[n][[1]]}];
];


FindMatchesAux[x___] := BadCall["FindMatchesAux",x];

If[Global`runningGeneral
  ,SmartTupleUnionNumber[m_,str_] := 
   Module[{data,result,temp},
        data = DataElement[m];
        Which[ Not[Head[data]===Global`RuleTuple], result = m;
             , data[[3]]==={} , result = m;
             , True, temp = SmartTupleUnion[data,str];
                     If[temp===data
                          , result = m;
                          , result = Flatten[AddToDataBase[temp]][[1]];
                     ];
        ];
        Return[result];
   ];
  , SmartTupleUnionNumber[m_,_] := m;
];


SmartTupleUnionNumber[x___] := BadCall["SmartTupleUnionNumber",x];

AMatchSPoly[aNumber_,anotherNumber_] :=
     If[Not[DidTheMatch[aNumber,anotherNumber]],
           FindMatches[aNumber,anotherNumber];
           If[Not[anotherNumber===aNumber]
                , FindMatches[anotherNumber,aNumber];
           ];
           MoraMatchDone[aNumber,anotherNumber];
     ];

AMatchSPoly[x___] := BadCall["AMatchSPoly",x];

MoraMatchDone[j_,k_] := DidTheMatch[j,k] = DidTheMatch[k,j] = True;

MoraMatchDone[x___] := BadCall["MoraMatchDone",x];

MoraMatchDones[aListOfNumbers_List] := 
Module[{j,aNumber},
     Do[ aNumber = aListOfNumbers[[j]];
         Map[(DidTheMatch[aNumber,#] = True)&,aListOfNumbers];
     ,{j,1,Length[aListOfNumbers]}];
     Return[]
];

MoraMatchDones[x___] := BadCall["MoraMatchDones",x];

MoraPermuteOrdering[StartingData_List,aListOfSymbols_List] := 
Module[{InternalSymbols,NumberOfSymbols,InternalList,ListOfPermutations,
       NumberOfPermutations,NewData,G,aPerm,theList,i,j,NewData,InputData},
   NumberOfSymbols=Length[aListOfSymbols];
   If[NumberOfSymbols > 6, Print["You can't do that many symbols!"];
                           Abort[];
   ];
   InternalSymbols=Table[ToExpression[StringJoin["internal",ToString[j]]],
                         {j,1,NumberOfSymbols}];
   Apply[SetNonCommutative,InternalSymbols];
   ListOfPermutations=Permutations[InternalSymbols];
   NumberOfPermutations=Length[ListOfPermutations];
   NewData=StartingData;
   Do[
      aPerm=ListOfPermutations[[i]];
      theList=Table[Rule[aListOfSymbols[[j]],aPerm[[j]]],                 
                   {j,1,NumberOfSymbols}]; 
      InputData=NewData/.theList;
      G[i]=NCMakeRules[InputData];
      theList=Table[Rule[aPerm[[j]],aListOfSymbols[[j]]], 
                   {j,1,NumberOfSymbols}];
      G[i]=G[i]/.theList;
   ,{i,NumberOfPermutations}        
   ];
   NewData=Union[Flatten[Table[G[i],{i,NumberOfPermutations}]]];
   Clear[G];
   Return[NewData];
];

MoraPermuteOrdering[x___] := BadCall["MoraPermuteOrdering",x];

RegisterTheBasis[theLists_List,big_List] :=
Module[{aList,k},
     Do[ aList = theLists[[k]];
         aList = SmartTupleUnion[aList];
         aList = Flatten[Map[AddToDataBase,aList]];
         If[Complement[aList,big]==={}
              , Print["The ",k,"th basis is properly registered"];
                MoraMatchDones[aList];
              , Print["RegisterTheBasis error:"];
                Print["Invalid argument IsAGroebnerBasis"];
                Print["The argument will be ignored"];
                Print["The set ",aList," is not a subset of ",big];
                Abort[];
         ];
     ,{k,1,Length[theLists]}];
     Return[];
];

RegisterTheBasis[x___] := BadCall["RegisterTheBasis",x];

SortRelations[aList_] := 
Module[{n,result,vars,thevars,totalvars,theMax,theRule,aSet,len,relations,j},
   relations[x_] = {};
   theMax = 0;
   vars = {};
   n = NCMakeGreater`WhatIsMultiplicityOfGrading[];
   Do[ thevars[j] = Join[vars,WhatIsSetOfIndeterminants[j]];
   ,{j,2,n}];
   totalvars = Flatten[Table[thevars[j],{j,2,n}]];
   Do[ theRule = aList[[j]];
       aSet = Union[Intersection[totalvars,Union[GrabIndeterminants[theRule]]]];
       len = Length[aSet];
       If[len>theMax, theMax = len];
       AppendTo[relations[len],theRule];
   ,{j,Length[aList]}];
   result = Table[sortRelations[relations[j]],{j,0,theMax}];
   result = Flatten[result];
   Clear[relations];
   Return[result];
];

SortRelations[x___] := BadCall["SortRelations",x];

sortRelations[aList_] := 
Module[{},
   If[Global`runningGeneral
       , result = Sort[aList,FindConditions[#2[[1,1]],{#1[[1,1]]}]&];
       , result = Sort[aList,FindConditions[#2[[1]],{#1[[1]]}]&];
   ];
   Return[result];
];

sortRelations[x___] := BadCall["sortRelations",x];

OrderBetween[aList_,low_?NumberQ,high_?NumberQ] := 
Module[{n,vars,temp,j,theRule,aSet,len,result},
   vars = {};
   n = WhatIsMultiplicityOfGrading[];
   Do[ vars = Join[vars,WhatIsSetOfIndeterminants[j]];
   ,{j,1,n}];
   Do[ theRule = aList[[j]];
       aSet = Intersection[vars,Union[GrabIndeterminants[theRule]]];
       len = Length[aSet];
       If[And[len>=low,len<=high], temp[j] = {theRule},temp[j] = {};];
   ,{j,1,Length[aList]}];
   result = Flatten[Table[temp[j],{j,1,Length[aList]}]];
   result = SortRelations[result];
   Clear[temp];
   Return[result];
];

OrderBetween[x___] := BadCall["OrderBetween",x];

WhatAreNumbers[] := savedNumbers;

WhatAreNumbers[x___] := BadCall["WhatAreNumbers",x];

SetStartingRelations[x_] := startingRelations = x;

SetStartingRelations[x___] := BadCall["SetStartingRelations",x];

WhatAreStartingRelations[] := startingRelations;

WhatAreStartingRelations[x___] := BadCall["WhatAreStartingRelations",x];

FinishedComputingBasisQ[] := finishedComputingBasisQ;

FinishedComputingBasisQ[x___] := BadCall["FinishedComputingBasisQ",x];

FakeKnowns[aList_List] :=
Module[{unknowns,knowneqs,k,theList},
   theList = WhatIsDataBase[aList];
   unknowns = WhatAreUnknowns[];
   knowneqs = theList;
   Do[ knowneqs = Select[knowneqs,FreeQ[#,unknowns[[k]]]&];
   ,{k,1,Length[unknowns]}];
   RegisterTheBasis[{knowneqs},aList];
   Return[];
];

FakeKnowns[x___] := BadCall["FakeKnowns",x];

End[];
EndPackage[]

