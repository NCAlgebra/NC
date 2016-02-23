(* :Title: 	NCMakeGreater // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus *)

(* :Context: 	NCMakeGreater` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
*)

BeginPackage["NCMakeGreater`","NonCommutativeMultiply`",
             "SimplePower`","NCMtools`","Errors`"];

Clear[MakeGreater];

MakeGreater::usage =
     "MakeGreater";

Clear[ClearMonomialOrder];

ClearMonomialOrder::usage =
     "ClearMonomialOrder";

Clear[SetMonomialOrderSymmetricOld];

SetMonomialOrderSymmetricOld::usage =
     "SetMonomialOrderSymmetricOld";

Clear[SetMonomialOrderOld];

SetMonomialOrderOld::usage =
     "SetMonomialOrderOld";

Clear[MonomialOrderQ];

MonomialOrderQ::usage =
     "MonomialOrderQ";

Clear[AddToMonomialOrderSymmetric];

AddToMonomialOrderSymmetric::usage =
     "AddToMonomialOrderSymmetric";

Clear[AddToMonomialOrder];

AddToMonomialOrder::usage =
     "AddToMonomialOrder";

Clear[SetMultiplicityOfGrading];

SetMultiplicityOfGrading::usage =
     "SetMultiplicityOfGrading";

Clear[WhatIsMultiplicityOfGradingOld];

WhatIsMultiplicityOfGradingOld::usage =
     "WhatIsMultiplicityOfGradingOld";

Clear[WhichSetOfIndeterminants];

WhichSetOfIndeterminants::usage =
     "WhichSetOfIndeterminants";

Clear[WhatIsSetOfIndeterminantsOld];

WhatIsSetOfIndeterminantsOld::usage =
     "WhatIsSetOfIndeterminantsOld";

Clear[KnownQOld];

KnownQOld::usage =
     "KnownQOld";

Clear[UnknownQ];

UnknownQ::usage =
     "UnknownQ";

Clear[WhatAreKnowns];

WhatAreKnowns::usage =
     "WhatAreKnowns";

Clear[WhatAreUnknowns];

WhatAreUnknowns::usage =
     "WhatAreUnknowns";

Clear[EquivalenceClassUsage];

EquivalenceClassUsage::usage =
     "EquivalenceClassUsage";

Clear[PushOrder];

PushOrder::usage =
     "PushOrder";

Clear[PopOrder];

PopOrder::usage =
     "PopOrder";

Clear[SortMonomialsOld];

SortMonomialsOld::usage =
     "SortMonomialsOld";

Clear[OrderToString];

OrderToString::usage =
     "OrderToString";


Begin["`Private`"];

MakeGreater[{},_] := False;
MakeGreater[_,{}] := True;
MakeGreater[{first_,rest_},{first_,REST_}] := MakeGreater[{rest},{REST}];
MakeGreater[aList_,anotherList_] := makeGreater[aList,anotherList];

MakeGreater[x___] := BadCall["MakeGreater",x];

Clear[makeGreater];

If[And[Not[Global`runningGeneral],
       Global`generalReductionOld==="smallNonSymbolicReduction.m"]
         , (* THEN *)
makeGreater[aList_List,anotherList_List] :=
Module[{shouldLoop,j,themin,FIRST,first,BASE,base,result},
     shouldLoop  = True;
     themin = Min[Length[aList],Length[anotherList]];
     For[j=1,j<=themin && shouldLoop,j++,
         FIRST = NormalizeCoefficient[aList[[j]]];
         first = NormalizeCoefficient[anotherList[[j]]];
         BASE = TheBase[FIRST];
         base = TheBase[first];
         If[Not[BASE===base]
             , result = IndeterminantGreater[BASE,base];
               shouldLoop = False;
         ];
     ];
     If[shouldLoop, result = Length[aList] - Length[anotherList] > 0; ];
     Return[result];
];
          , (* ELSE *)
makeGreater[aList_List,anotherList_List] :=
Module[{FIRST,first,REST,rest,BASE,base,simpleEqual,simpleTest,
        POWER,power,newTest,aux,result,thisCase,computed,
        firstCase,secondCase,answer,item,j},
     FIRST = NormalizeCoefficient[aList[[1]]];
     first = NormalizeCoefficient[anotherList[[1]]];
     REST = Take[aList,{2,-1}];
     rest = Take[anotherList,{2,-1}];
     BASE = TheBase[FIRST];
     base = TheBase[first];
     POWER = ThePower[FIRST];
     power = ThePower[first];
     simpleEqual = BASE===base;
     simpleTest = IndeterminantGreater[BASE,base];

(* POWER==power *)
     computed = False;
     thisCase = And[POWER==0,power==0];
     If[thisCase===False 
         , result[1,1] = False;
         , aux[1] = MakeGreater[REST,rest];
           computed = True;
           result[1,1] = LogicalExpand[And[thisCase,aux[1]]];
     ];
     thisCase = And[POWER-power==0,power>=1,POWER>=1];
     If[thisCase===False 
         , result[1,2] = False;
         , If[simpleEqual
                , If[Not[computed], aux[1] = MakeGreater[REST,rest];];
                  result[1,2] = LogicalExpand[And[thisCase,aux[1]]];
                , result[1,2] = And[thisCase,simpleTest];
           ];
     ];

(* POWER==0, power>0 *)
     thisCase = And[POWER==0,power>=1];
     If[thisCase===False
          , result[2] = False;
          , aux[2] = MakeGreater[REST,anotherList];
            result[2] = LogicalExpand[And[thisCase,aux[2]]];
     ];

(* POWER>0, power==0 *)
     thisCase = And[POWER>=1,power==0];
     If[thisCase===False
          , result[3] = False;
          , aux[3] = MakeGreater[aList,rest];
            result[3] = LogicalExpand[And[thisCase,aux[3]]];
     ];

(* 
     POWER>0,power>0,POWER > power  
             AND
     POWER>0,power>0,POWER < power 
 
*)
     result[4] = LogicalExpand[And[POWER>=1,power>=1,simpleTest]];
     result[5] = LogicalExpand[And[POWER>=1,power>=1,
                                   POWER-power>=1,simpleEqual]];
     answer = Or[result[1,1],result[1,2],result[2],
                 result[3],result[4],result[5]];
     answer = LogicalExpand[answer];
     Return[answer];
];

]; (* end of runningGeneral *)
makeGreater[x___] := BadCall["makeGreater",x];

EquivalenceClassUsage[x_] := DontKnowOrder = x;

EquivalenceClassUsage[False];

IndeterminantGreater[x_,y_] := 
Module[{setx,sety,posx,posy,aList,result},
   If[TrueQ[DontKnowOrder]
        , result = x > y;
        , setx = WhichSet[x];
          sety = WhichSet[y]; 
          If[setx===sety 
               , aList= WhatIsSetOfIndeterminantsOld[setx];
                 posx = Place[aList,x];
                 posy = Place[aList,y];
                 result = posx > posy;
               , result = setx > sety;
          ];
   ];
   Return[result];
];

IndeterminantGreater[x___] := BadCall["IndeterminantGreater",x];

Place[aList_List,x_] :=
Module[{result,len,i},
  result = 0;
  len = Length[aList];
  For[i=1,And[i<=len,Not[result===-1]],i++,
      If[aList[[i]]===x, result = i];
  ];
  Return[result];
];

Place[x___] := BadCall["Place",x];

ClearMonomialOrder[] :=  
      SetMultiplicityOfGrading[WhatIsMultiplicityOfGradingOld[]];

ClearMonomialOrder[x___] := BadCall["ClearMonomialOrder",x];

SetMultiplicityOfGrading[n_] :=
Block[{j,k},
    theMultiplicityOfGrading = n;
    zeroTuple = Table[0,{j,1,n}];
    sumTuple = Table[bigNegative,{j,1,n}];
    Clear[SetOfIndeterminants];
    Clear[WhichSet];
    Clear[knownQ];
    Clear[unknownQ];
    knownQ[x_] := False;
    unknownQ[x_] := False;
    WhichSet[x_] := BadCall["WhichSet",x];
    Do[indicator[j] = Table[If[j==k,1,0],{k,1,n}];
    ,{j,1,n}];
    Return[];
];

SetMultiplicityOfGrading[x___] := BadCall["SetMultiplicityOfGrading",x];

SetMultiplicityOfGrading[1];

WhatIsMultiplicityOfGradingOld[] := theMultiplicityOfGrading;

WhatIsMultiplicityOfGradingOld[x___] := BadCall["WhatIsMultiplicityOfGradingOld",x];

WhichSetOfIndeterminants[x_] := WhichSet[x];

WhichSetOfIndeterminants[x___] := BadCall["WhichSetOfIndeterminants",x];

SetMonomialOrderOld[aList_List,aNumber_?NumberQ] :=
Module[{j},
   If[aNumber > theMultiplicityOfGrading,
             BadCall["SetMonomialOrderOld",aList,aNumber];
   ];
   SetOfIndeterminants[aNumber] = aList;
   Do[ WhichSet[aList[[j]]] = aNumber;
   ,{j,1,Length[aList]}];
   If[aNumber===1, Do[knownQ[aList[[j]]] = True;
                   ,{j,1,Length[aList]}];
                 , Do[unknownQ[aList[[j]]] = True;
                   ,{j,1,Length[aList]}];
   ];
   Return[MonomialOrderQ[]];
];

SetMonomialOrderSymmetricOld[aList_List,n_] :=
Module[{j},
     Map[(WhichSet[#]=.;)&,WhatIsSetOfIndeterminantsOld[j]];
     temp = Table[{#,tp[#]}&,aList];
     temp = Flatten[temp];
     SetOfIndeterminants[j] = temp;
     Return[];
];

SetMonomialOrderSymmetricOld[x___] := BadCall["SetMonomialOrderSymmetricOld",x];

WhatIsSetOfIndeterminantsOld[aNumber_?NumberQ]:= SetOfIndeterminants[aNumber];

WhatIsSetOfIndeterminantsOld[x___] := 
        BadCall["WhatIsSetOfIndeterminantsOld",x];

MonomialOrderQ[] :=
    Flatten[Table[SetOfIndeterminants[j]
                  ,{j,1,WhatIsMultiplicityOfGradingOld[]}
                 ]
           ];

MonomialOrderQ[x___] := BadCall["MonomialOrderQ",x];

AddToMonomialOrderSymmetric[x_,n_] :=
    (
     AddToMonomialOrder[x,n];
     AddToMonomialOrder[tp[x],n];
    );

AddToMonomialOrderSymmetric[x___] := BadCall["AddToMonomialOrderSymmetric",x];

AddToMonomialOrder[x_,n_] := 
   (
      AppendTo[SetOfIndeterminants[n],x];
      WhichSet[x] = n;
      If[n===1, knownQ[x] = True;
              , unknown[x] = True;
      ];
  );

AddToMonomialOrder[x___] := BadCall["AddToMonomialOrder",x];

KnownQOld[x_] := knownQ[x];

KnownQOld[x___] := BadCall["KnownQOld",x];

UnknownQ[x_] := unknownQ[x];

UnknownQ[x___] := BadCall["UnknownQ",x];

WhatAreKnowns[] := SetOfIndeterminants[1];

WhatAreKnowns[x___] := BadCall["WhatAreKnowns",x];

WhatAreUnknowns[] := Flatten[Table[SetOfIndeterminants[j]
                                   ,{j,2,theMultiplicityOfGrading}
                                  ],1];

WhatAreUnknowns[x__] := BadCall["WhatAreUnknowns",x];

PushOrder[] := 
Module[{key,size,j},
   key = Unique["OrderStack"];
   size = NCMakeGreater`WhatIsMultiplicityOfGradingOld[];
   stack[key,"multiplicity"] = size;
   Do[ stack[key,j] = WhatIsSetOfIndeterminantsOld[j];
   ,{j,1,size}];
   Return[key];
];

PushOrder[x___] := BadCall["PushOrder",x];

PopOrder[key_Symbol] := 
Module[{},
   size = stack[key,"multiplicity"];
   stack[key,"multiplicity"] = .;
   If[Not[NumberQ[size]], BadCall["PopOrder",key]];
   SetMultiplicityOfGrading[size];
   Do[ SetMonomialOrderOld[stack[key,j],j];
       stack[key,j] = .; (* Clear it to save space *)
   ,{j,1,size}];
   Return[MonomialOrderQ[]];
];

PopOrder[x___] := BadCall["PopOrder",x];

SortMonomialsOld[aList_List] := 
     Sort[aList,FindConditions[#2,{#1}]&];

OrderToString[] := 
Module[{n,j,str,aList,result},
  n = WhatIsMultiplicityOfGradingOld[];
  Do[ aList = WhatIsSetOfIndeterminantsOld[j];
      If[aList==={}
         , str[j] = "";
         , aList = Flatten[Map[{ToString[Format[#,InputForm]]," < "}&,aList]];
           str[j] = StringJoin[StringTake[Apply[StringJoin,aList],{1,-2}],
                               "< "];
      ];
  ,{j,1,n}];
  result = Table[str[j],{j,1,n}];
  result = Apply[StringJoin,result];
  result = StringTake[result,{1,-4}];
  Return[result];
];

End[];
EndPackage[]

Clear[UniqueMonomial];

UniqueMonomial::usage =
     "UniqueMonomial";

UniqueMonomial[str_String] := 
Module[{result},
     result = Unique[str];
     AddToMonomialOrder[result,1];
     Return[result];
];

UniqueMonomial[x___] := BadCall["UniqueMonomial",x];

