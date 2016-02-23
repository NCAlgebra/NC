(* :Title:      C++MoraAlg.m // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	MoraAlg` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
Mark disabled deselects in Aug 99. This made  SBByCat work in the new version.
Also did  $NC$MmaDiagnosticPrint[ ]    stuff
*)

(* Before package statement *)

(* MAURICIO - BEGIN *)
(* 
(* Moved to frontend.m *)
IterationNumber[aList_List] := Map[IterationNumber,aList];
Global`GBDirectory = ".";
*)
(* MAURICIO - END *)

(* In the future package this *)
Get["GBMarker.m"];

BeginPackage["MoraAlg`",
             "NCMonomial`",
             "NonCommutativeMultiply`",
             "Grabs`",
             "Global`","Errors`"];

Clear[$GBDirectory];

Clear[UseMarker];

UseMarker::usage =
     "UseMarker is an option for many NCGB functions.";

Clear[NCCleanUpPolys];

NCCleanUpPolys::usage =
     "NCCleanUpPolys";

Clear[NCCleanUpPols];

NCCleanUpPols::usage =
     "NCCleanUpPols";

Clear[CleanUp];

CleanUp::usage =
     "CleanUp";

Clear[MorasAlgorithm];

MorasAlgorithm::usage =
     "Please use NCMakeGB";

Clear[NCMakeRules];

NCMakeRules::usage = 
   "Please use NCMakeGB";

Clear[NCMakeGB];

NCMakeGB::usage = "NCMakeGB[aListOfPolynomials,aInteger]. This function \
calls a C++ implementation of the noncommutative Groebner basis algorithm. \
The algorithm loops at most aNumber of times.";

NCMakeGB::invalidDeselects = "Invalid deselects.";
NCMakeGB::failedCall = "Call to '`1`' failed.";
NCMakeGB::notMember = "The variables '`1`' appear in the relations but are \
not members of the order.";
NCMakeGB::commutativeSymbols = "The variables `1` are commutative. \
This generation of NCGB does not handle commutative symbols efficiently. \
As a workaround, you may want to substitute the commutative symbols \
with a rational number, such as 7, or find an appropriate form of the \
expression where the commutative symbols becomes noncommutative.";
NCMakeGB::degreeCap = "You chose one degree cap but not the other.";

Clear[NCMakeGBSpread];

NCMakeGBSpread::usage = 
   "NCMakeGBSpread[x,y,z,opts] first calls NCMakeGB[x,y,opts] \
    and then creates a TeXed display.";

Clear[WhatIsPartialGB];

WhatIsPartialGB::usage = 
     "WhatIsPartialGB[] returns the last partial basis generated \
by NCMakeRules.";

Clear[WhatAreStartingRelations];

WhatAreStartingRelations::usage =
     "WhatAreStartingRelations";

Clear[FinishedComputingBasisQ];

FinishedComputingBasisQ::usage =
     "FinishedComputingBasisQ";

Clear[SetMonomialOrder];

SetMonomialOrder::usage =
     "SetMonomialOrder[aListOfMonomials, aInteger].  This function \
      sets the order of monomials using the given list of monomials, \
      in increasing order.  The grading is given by aInteger.";

Clear[SetKnowns]

SetKnowns::usage =
     "SetKnowns[a,b,c,...] sets a,b,c,... to be known.";

Clear[SetUnknowns]

SetUnknowns::usage =
     "SetUnknowns[a,b,c,...] sets a,b,c,... to be unknown.";

Clear[ClearMonomialOrderAll];

ClearMonomialOrderAll::usage =
    "ClearMonomialOrderAll";

Clear[ReinstateOrder];

ReinstateOrder::usage =
    "ReinstateOrder";

Clear[PolyToRule];

PolyToRule::usage =
    "PolyToRule[aPolynomial] returns a Groebner Rule \
     according to aPolynomial, assuming the order of monomials is set.";

Clear[PolToRule];

PolToRule::usage =
    "PolToRule[aPolynomial] returns a Groebner Rule \
     according to aPolynomial, assuming the order of monomials is set.";

Clear[RuleToPol];

RuleToPol::usage =
     "RuleToPol[aRule] takes the rule aRule and converts it to a
      polynomial.";

Clear[RuleToPoly];

RuleToPoly::usage =
     "RuleToPoly[aRule] takes the rule aRule and converts it to a
      polynomial.";

Clear[ToGBRule];

ToGBRule::usage =
    "ToGBRule[aPolynomial] returns a Groebner Rule \
     according to aPolynomial, assuming the order of monomials is set.";

Clear[ToGBRules];

ToGBRules::usage =
    "ToGBRules[aPolynomial].  This is an alias for ToGBRule, because \
     it is easy to pluralize by mistake."

Clear[NCSCleanUpRules];

NCSCleanUpRules::usage =
     "NCSCleanUpRules[aList].  This function takes a list of \  
      polynomials and cleans them up as in [HW]."

Clear[CleanUpBasis];

CleanUpBasis::usage =
     "Please use NCSCleanUpRules.";

Clear[WhatIsMultiplicityOfGrading];

WhatIsMultiplicityOfGrading::usage = 
     "WhatIsMultiplicityOfGrading";

Clear[WhatIsSetOfIndeterminants];

WhatIsSetOfIndeterminants::usage =
     "WhatIsSetOfIndeterminants";

Clear[SortMonomials];

SortMonomials::usage = 
     "SortMonomials";

Clear[SortRelations];

SortRelations::usage =
     "SortRelations";

Clear[KHistory];

KHistory::usage =
     "KHistory";

Clear[WhatIsKlugeHistory];

WhatIsKlugeHistory::usage =
     "WhatIsKlugeHistory";

Clear[WhatIsHistory];

WhatIsHistory::usage =
     "WhatIsHistory";

Clear[GroebnerSimplify];

GroebnerSimplify::usage =
     "GroebnerSimplify";

Clear[NCSimplifyAll];

NCSimplifyAll::usage =
     "NCSimplifyAll";

Clear[NCGroebnerSimplify];

NCGroebnerSimplify::usage =
     "NCGroebnerSimplify";

Clear[SetMonomialOrderSymmetric];

SetMonomialOrderSymmetric::usage =
     "SetMonomialOrderSymmetric";

Clear[ReturnRelations];

ReturnRelations::usage =
      "ReturnRelations";

Clear[ReorderInput];

ReorderInput::usage =
     "ReorderInput";

Clear[SupressCOutput];

SupressCOutput::usage =
     "SupressCOutput";

Clear[SupressAllCOutput];

SupressAllCOutput::usage =
     "SupressAllCOutput";

Clear[ChangeNCMakeGBOptions];

ChangeNCMakeGBOptions::usage = 
     "ChangeNCMakeGBOptions"

Clear[MultipleTrips];

MultipleTrips::usage =
     "MultipleTrips";

Clear[UserSelect];

UserSelect::usage =
     "UserSelect";

Clear[Deselect];

Deselect::usage =
     "Deselect";

Clear[NumbersFromHistory];

NumbersFromHistory::usage =
     "NumbersFromHistory";

Clear[SetStartingRelations];

SetStartingRelations::usage
   "Do not use this function.";

Clear[RR];

RR::usage =
     "RR";

Clear[RRByCat];

RRByCat::usage =
     "RRByCat";

Clear[SBByCat];
SBByCat::usage =
     "SBByCat";

Clear[SB];
SB::usage =
     "SB";

Clear[RRSB];

RRSB::usage =
     "RRSB";

Clear[RRSBByCat];

RRSBByCat::usage =
     "RRSBByCat";

Clear[RelationUnion];

RelationUnion::usage =
     "RelationUnion";

Clear[ReduceAndRetainNonZero];

ReduceAndRetainNonZero::usage =
     "ReduceAndRetainNonZero";

Clear[testCode];

testCode::usage =
     "testCode";

Clear[testCode2];

testCode2::usage =
     "testCode2";

Clear[NCContinueMakeGB];

NCContinueMakeGB::usage = 
     "NCContinueMakeGB";

Clear[DegreeCap];

DegreeCap::usage =
    "DegreeCap"

Clear[DegreeSumCap];

DegreeSumCap::usage =
     "DegreeSumCap";

CreateFactControl::usage = 
     "CreateFactControl";

NCGBCppTeX::usage = 
      "NCGBCppTeX is a mathematica variable. If NCGBCppTeX is True,\
then the TeX for the variables for SetMonomialOrder are sent \
automatically to C++. The default is false.\n";

(* * * *  Begin  * * * *)

Begin["`Private`"];

$GBDirectory = ".";

Clear[$order];
Clear[$orderMax];

NCGBCppTeX = false; (* Should we send the TeX to C++ ? *)

Clear[sortRelations];
Clear[ProcessDeselects];
Clear[CheckVariables];
Clear[GatherUnknowns];
Clear[SpellCheckOptions];

Clear[oldCalls];
oldCallNumber = 0;

MorasAlgorithm[x___] :=
Module[{},
   Print["Please use NCMakeGB rather than MorasAlgorithm in the future."];
   Return[NCMakeGB[x]];
];

NCMakeRules[x___] :=
Module[{},
   Print["Please use NCMakeGB rather than NCMakeRules in the future."];
   Return[NCMakeGB[x]];
];

Clear[ProcessDeselects];
Clear[ProcessSelects];

NCGBEmpty[x:{___GBMarker}]:= (Global`DestroyMarker[x]; Return[{}];);
NCGBEmpty[x___]:= BadCall["NCGBEmpty",x];

Options[NCMakeGB] = {
  CleanUp -> 1,
  ReturnRelations -> True,
  SupressCOutput -> False,
  SupressAllCOutput -> False,
  Deselect -> {},
  UserSelect -> {},
  ReorderInput -> False,
  DegreeCap -> -1,
  DegreeSumCap -> -1,
  UseMarker -> False
};

NCMakeGBSpread[x_,y_,z_String,opts___] := 
Module[{ans},
  ans = NCMakeGB[x,y,opts];
  Global`RegularOutput[Global`unmarker[ans],z,"Mma"];
  Return[ans];
];

NCMakeGB[ polys:(_List|
                 Global`GBMarker[_Integer,"polynomials"]|
                 Global`GBMarker[_Integer,"rules"]
                ),
          iter_Integer, opts___] := Module[
   {start,result,i,n,returnrelations,supress,clean,ok,okL,ok2,ok2L,
        deselects, userselect,supressall,reorder,temp,usemarker,POLYS,
        trash={},markerFlag,degcap,degsumcap,degcapon,newuserselect},

   (* process options *)
   SpellCheckOptions[NCMakeGB, {opts}];
   degcap = DegreeCap /. {opts} /. Options[NCMakeGB];
   degsumcap = DegreeSumCap /. {opts} /. Options[NCMakeGB];
   degcapon = And[degcap > 0, degsumcap > 0];
   If[ And[ Not[degcapon], 
            Or[Not[degcap === -1], 
            Not[degmincap == -1]] ],
       Message[NCMakeGB::degreeCap];
       Abort[];
   ];
   reorder = ReorderInput /. {opts} /. Options[NCMakeGB];
   usemarker= UseMarker /. {opts} /. Options[NCMakeGB];
   userselect = UserSelect /. {opts} /. Options[NCMakeGB];
   returnrelations = ReturnRelations /. {opts} /. Options[NCMakeGB];
   supress = SupressCOutput /. {opts} /. Options[NCMakeGB];
   supressall = SupressAllCOutput /. {opts} /. Options[NCMakeGB];
   deselects = Deselect /. {opts} /. Options[NCMakeGB];
   If[ Not[Head[deselects]===List],
       Message[NCMakeGB::invalidDeselects];
       BadCall["NCMakeGB", polys, iter, opts];
   ];
   clean = CleanUp /. {opts} /. Options[NCMakeGB];

   markerFlag = Head[polys]===Global`GBMarker;
   If[ markerFlag,
     POLYS = Global`CopyMarker[polys,"polynomials"];
     Global`PrintMarker[POLYS];
     AppendTo[trash,POLYS];
     , 
     POLYS = NonCommutativeMultiply`ExpandNonCommutativeMultiply[
         RuleToPoly[polys]]
   ];

   If[ Head[userselect]===List,
       userselect = NonCommutativeMultiply`ExpandNonCommutativeMultiply[
            userselect];
   ];

   temp = Global`SetGlobalPtr[];
   If[ temp===$Failed,
       Message[NCMakeGB::failedCall, Global`SetGlobalPtr];
       Abort[];
   ];

   temp = Global`SetCleanUpBasis[clean];
   If[ temp===$Failed,
       Message[NCMakeGB::failedCall, Global`SetCleanUpBasis];
       Abort[];
   ];

   ReinstateOrder[];

   If[supress, 
     temp = Global`supressMoraOutput[1],
     If[ temp===$Failed,
         Message[NCMakeGB::failedCall, Global`supressMoraOutput];
     ];
   ];

   (* error checking *)  
   If[ markerFlag,
       (* MXS: Fix this *)
       ok = {}; ok2 = True;
       , 
       ok = CheckVariables[Union[POLYS, deselects]];
       okL =  Flatten[Table[WhatIsSetOfIndeterminants[i]
                   ,{i,1,WhatIsMultiplicityOfGrading[]}]];
       ok2L = Select[okL, Not[NonCommutativeMultiply`CommutativeQ[#]]&];
       ok2 = NonCommutativeMultiply`NCMPolynomialStrictQ[POLYS,ok2L];
   ];

   If[ Not[ok==={}],
       Message[NCMakeGB::notMember ,ok];
       BadCall["NCMakeGB", POLYS, iter, opts];
   ];

   If[ ok2=!=True,
       Message[NCMakeGB::commutativeSymbols, Complement[okL, ok2L]];
       BadCall["NCMakeGB", POLYS, iter, opts];
   ];

   If[ markerFlag,
       start = Global`CopyMarker[POLYS, "polynomials"];
       SetStartingRelations[start];
       ,
       start = POLYS /. Rule -> Subtract;
       start = start /. Equal -> Subtract;
       start = Flatten[start];
       start = NCMonomial[start];
       start = NonCommutativeMultiply`ExpandNonCommutativeMultiply[start];
       start = InPlaceComplement[start, {0, True}];
       (* This marker is deleted by SetGlobalPtr *)
       start = sendMarkerList["polynomials", start];
       SetStartingRelations[start];
   ];

   temp = Global`SetIterations[iter];
   If[ temp===$Failed,
       Message[NCMakeGB::failedCall, Global`SetIterations];
       Abort[];
   ];

   If[ markerFlag,
       $NC$NCGBMmaDiagnosticPrint[
        "Deselects are not working for the marker version of NCMakeGB"];
       ProcessSelects[userselect];
       ,
       ProcessDeselects[POLYS, deselects];
       ProcessSelects[userselect];
   ];

   temp = Global`SetReorder[reorder];
   If[ temp===$Failed,
       Message[NCMakeGB::failedCall, Global`SetReorder];
       Abort[];
   ];

   If[ degcapon,
       Global`GroebnerCutOffFlag[1];
       Global`GroebnerCutOffMin[degcap];
       Global`GroebnerCutOffSum[degsumcap];
   ];

   temp = Global`MoraRun[];
   If[ temp===$Failed,
       Message[NCMakeGB::failedCall, Global`MoraRun];
       Abort[];
   ];

   If[ returnrelations,
       Return[WhatIsPartialGB[UseMarker->usemarker]];
   ];

   (* MAURICIO - BEGIN *)
   (* Mark, when returnrelations is True NCGBEmpty will not be called. 
      Is that a leak? *)
   (* MAURICIO - END *)

   trash = NCGBEmpty[trash];
   Return[];
];

NCMakeGB[x___] := BadCall["NCMakeGB",x];

ChangeNCMakeGBOptions[option_,newDefault_] := 
Module[{i,done,options,len},
  options = Options[NCMakeGB];
  done = False;
  len = Length[Options[NCMakeGB]];
  For[i=1,i<=len && Not[done], i++,
    If[options[[i,1]]==option
        , options[[i]]= option->newDefault;
          done = True;
    ];
  ];
  If[Not[done], Print[option," is not an option of NCMakeGB!"];];
  Options[NCMakeGB] = options;
];

ChangeNCMakeGBOptions[x___] := BadCall["ChangeNCMakeGBOptions",x];

ProcessSelects[userselect_List] :=
Module[{old,new,n,i,str,polys,userselects,start,startnum,res},
  userselects = PolyToRule[userselect];
  Global`ClearUserSelect[];
  Do[
     Global`UserSelectSet[userselects[[i]]];
  ,{i,1,Length[userselects]}];
];

ProcessSelects[x:GBMarker[_?NumberQ,_String]] :=
Module[{},
  Global`ClearUserSelect[];
  ruleMarker = Global`CopyMarker[x,"rules"];
  Global`UserSelectMarkerSet[ruleMarker];
];  

ProcessSelects[userselect_Global`GBMarker] :=
Module[{temp},
  temp = Global`CopyMarker[userselect,"rules"];
  Global`ClearUserSelect[];
  Global`setUserSelects[temp];
  Global`DestoryMarker[temp];
];

ProcessSelects[x___] := BadCall["ProcessSelects",x];

ProcessDeselects[polys_List,deselects_List] := 
Module[{old,new,n,i,str,other},
  old = Intersection[polys,deselects];
  Do[ n = InternalToNumber[old[[i]]];
      Global`DeselectForSPolynomial[n];
  ,{i,1,Length[old]}];
(*
  Run["echo "];
  Run["echo "];
  Run["echo "];
  Run["echo "];
*)
  $NC$NCGBMmaDiagnosticPrint["Deselecting:",old];
  other = Complement[deselects,old];
  If[Length[other]>0
     ,Print["Selections rejected:",other];
  ];
];

ProcessDeselects[x___] := BadCall["ProcessDeselects",x];

CheckVariables[aList_List] :=
Module[{vars,allVars,i},
   vars = Grabs`GrabIndeterminants[aList];
   allVars = Table[WhatIsSetOfIndeterminants[i]
             ,{i,1,WhatIsMultiplicityOfGrading[]}];
   allVars = Apply[Join,allVars];
   Return[Complement[vars,allVars]];
];

CheckVariables[x___] := BadCall["CheckVariables",x];

(*
*Clear[WhatIsPartialGBAux];
*
*WhatIsPartialGB[aList:{___?NumberQ},opts___Rule] := 
*    Map[WhatIsPartialGBAux,aList];
*
*WhatIsPartialGBAux[n_Integer,opts___Rule] :=
*Module[{result,temp,k,j},
*(*
*  temp = Global`CreateMarker["history",{n}];
*  If[Or[temp===$Failed,temp===$Abort]
*      , Abort[]
*  ];
*  result = Global`RetrieveMarker[temp];
*  If[Or[result===$Failed,result===$Abort]
*      , Abort[]
*  ];
*  result = result[[1,2]];
*  temp = Global`DestroyMarker[temp];
*  If[Or[temp===$Failed,temp===$Abort]
*      , Abort[]
*  ];
**)
*temp = Global`NumberOfTermsInFact[n];
*  If[Or[temp===$Failed,temp===$Abort]
*      , Abort[]
*  ];
*k = Global`polynomialIntoStringBin[];
*  If[Or[k===$Failed,k===$Abort]
*      , Abort[]
*  ];
*  result = 0;
*Do[ temp = ToExpression[Global`entryStringBin[k,j]];
*      result = result + temp;
*,{j,1,Global`NumberInStringBin[k]}];
*  Return[result];
*];
*
*WhatIsPartialGBAux[x___] := BadCall["WhatIsPartialGBAux",x];
**)

(*
**WhatIsPartialGB[] :=
**Module[{n,i,temp,result},
**  n = Global`NumberPartialBasis[];
**  Print[n," relations to transfer from C++ to Mathematica."];
**  If[Not[n===0]
**    , Do[ temp[i] = ToExpression[Global`PartialBasis[i]];
*         WriteString[$Output,i,","];
**      ,{i,1,n-1}];
**      temp[n] = ToExpression[Global`PartialBasis[n]];
**      WriteString[$Output,n,"\n"];
**  ];
**  result = Table[temp[i],{i,1,n}];
**  Clear[temp];
**  Return[result];
**];
*)

WhatIsPartialGB[aList:{___Integer},opts___Rule] :=
Module[{usemarker,FC,RULES,RULES2,temp,result,trash={}},
  usemarker = UseMarker/.{opts}/.{UseMarker->False};
  FC = Global`SaveFactControl[];
  RULES = Global`CopyMarker[FC,"rules"];
  RULES2 = Global`MarkerTake[RULES,aList];
  temp = Global`CopyMarker[RULES2,"polynomials"];
  If[usemarker
    , result = temp;
    , result = RuleToPol[Global`RetrieveMarker[temp]];
      AppendTo[trash,temp];
  ]; 
  trash = Join[trash,{RULES2,RULES,FC}];
  Global`DestroyMarker[trash];
  Return[result];
];

WhatIsPartialGB[opts___Rule] :=
Module[{usemarker,result,saveresult,n},
  usemarker = UseMarker/.{opts}/.{UseMarker->False};
  result = Global`PartialBasisIntoPolynomialContainer[];
  Global`RecordMarker[result];
  If[usemarker
    , Null; (* Nothing *)
    , saveresult = result;
      n =  Global`numberOfElementsBehindMarker[saveresult];
      $NC$NCGBMmaDiagnosticPrint[n," relations to transfer from C++ to Mathematica."];
      result = Global`returnGBMarkerContents[saveresult];
      Global`DestroyMarker[saveresult];
  ];
  Return[result];
];

WhatIsPartialGB[x___] := BadCall["WhatIsPartialGB",x];

SetStartingRelations[GBMarker[numb_Integer,"polynomials"]] := 
Module[{temp},
   temp = Global`registerStartingRelations[numb];
   If[temp===$Failed,Abort[]];
   startingRelations = GBMarker[numb, "polynomials"];
];

(*
*SetStartingRelations[aList_List] := 
*Module[{numb,i,j,str,temp,answer,start,startnum},
*   Clear[InternalToNumber];
*(*
*   numb = Global`CurrentManagerStartPolynomialContainer[];
**)
*   numb = Global`CreateMarker["polynomials"];
*Print["MXS:",numb];
*
*   answer = {};
*   Print[Length[aList]," starting relations to set."];
*   If[Not[aList==={}]
*     , Do[ 
*         WriteString[$Output,j,","];
*         StartToNumber[aList[[j]]] = j;
*         str = Global`PolynomialToString[aList[[j]]];
*         temp = Global`PolynomialStringToPolynomialContainer[numb[[1]],str];
*         InternalToNumber[aList[[j]]] = temp;
*         If[temp===$Failed, Abort[];];
*         AppendTo[answer,temp];
*     ,{j,1,Length[aList]-1}];
*     str = Global`PolynomialToString[aList[[-1]]];
*     temp = Global`PolynomialStringToPolynomialContainer[numb[[1]],str];
*     InternalToNumber[aList[[-1]]] = temp;
*     If[temp===$Failed,Abort[]];
*     AppendTo[answer,temp]; 
*     WriteString[$Output,Length[aList],"\n"];
*   ];
*   Global`registerStartingRelations[numb[[1]]];
*   Print["The starting relations are the following:"];
*   temp = Global`printGBMarker[numb[[1]],"polynomials"];
*   If[temp===$Failed,Abort[]];
*
*   startnum = Global`NumberStartingRelations[];
*   If[startnum===$Failed,Abort[]];
*   start = Table[ToExpression[Global`StartingRelations[i]]
*                 ,{i,1,startnum}];
*   If[MemberQ[start,$Failed],Abort[]];
*   startingRelations = aList;
*   If[Not[start===aList] 
*      , Print["In error"];
*        Print[start," is not the same as ",aList];
*        Print["The value of the variable answer is ",answer];
*        Abort[];
*   ];
*];
*
*SetMonomialOrder[Mono_List, Grading_Integer] :=
*Module[{i,str,temp},
*  temp = Global`ClearMonomialOrderN[Grading];
*  If[temp===$Failed,Abort[]];
*  Do[
*    str = MyToString[Mono[[i]]];
*    temp = Global`MathTreeStringToCPlus[str, Grading];
*    If[temp===$Failed,Abort[]];
*  ,{i,Length[Mono]}];
*  order[Grading] = Mono;
*  If[Grading > $orderMax, $orderMax = Grading];
*];
*)

SetMonomialOrder[Mono_List, Grading_Integer] :=
Module[{i,str,temp},
  If[IntegerQ[Grading]
    , temp = Global`ClearMonomialOrderN[Grading];
  ];
  If[Length[Mono]>0
    , (* THEN *)
(*
      Print["MXS: Going to set the order at the ",Grading," Level to ",
            Mono];
*)
      PrintMonomialOrder[];
      If[temp===$Failed,Abort[]];
      temp = Global`setMonomialOrder[Grading,Mono];
      If[NCGBCppTeX 
        , Global`setTeXString[Map[{#,Global`ToStringForTeX[#]}&,Mono]];
      ];
      (* Perform an optimization for RegularOutput *)
      Map[(Global`NCGBTeXedVariables[#]=ToStringForTeX[#])&,Mono];
  ];
  $order[Grading] = Mono;
  If[Grading > $orderMax, $orderMax = Grading];
];

SetMonomialOrder[x___] :=
Module[{aList,i,temp},
   aList = {x};
   Do[ temp = Global`ClearMonomialOrderN[i];
       If[temp===$Failed,Abort[]];
   ,{i,1,WhatIsMultiplicityOfGrading[]}];
   If[Length[aList]>=1
       , SetMonomialOrder[Flatten[{aList[[1]]}],1];
   ];
   Table[SetMonomialOrder[Flatten[{aList[[i]]}],i]
         ,{i,2,Length[aList]}];
(* MXS 4.17.96
   Table[SetMonomialOrder[Flatten[{aList[[i]]}],(i-1)*10]
         ,{i,2,Length[aList]}];
*)
];

ClearMonomialOrderAll[] :=
Module[{},
  Clear[$order];
  $order[_] := {};
  $orderMax = 0;
  Global`ClearMonomialOrder[];
  Clear[Global`NCGBTeXedVariables];
];

ClearMonomialOrderAll[x___] := BadCall["ClearMonomialOrderAll", x];

ClearMonomialOrderAll[];

ReinstateOrder[] :=
Module[{i},
  Global`ClearMonomialOrder[];
  Do[
    SetMonomialOrder[$order[i], i]
  ,{i, $orderMax}]
];

ReinstateOrder[x___] := BadCall["ReinstateOrder", x];

WhatIsMultiplicityOfGrading[] := $orderMax;

WhatIsMultiplicityOfGrading[x___] := 
           BadCall["WhatIsMultiplicityOfGrading",x];

WhatIsSetOfIndeterminants[x_?NumberQ] := $order[x];

WhatIsSetOfIndeterminants[x___] := 
           BadCall["WhatIsSetOfIndeterminants",x];

PolyToRule[x___] := ToGBRule[x];
PolToRule[x___] := ToGBRule[x];

RuleToPoly[x_] := x/.{Equal->Subtract,Rule->Subtract};

RuleToPoly[x___] := BadCall["RuleToPoly",x];

RuleToPol[x_] := x/.{Equal->Subtract,Rule->Subtract};

RuleToPol[x___] := BadCall["RuleToPol",x];

ToGBRule[aList_List] := 
Module[{temp,temp2,result},
  temp = aList/.{Equal->Subtract,Rule->Subtract};
  temp2 = Union[Map[Head,temp]];
  If[Or[MemberQ[temp2,Integer],
        MemberQ[temp2,List]
       ]
    , result = Map[ToGBRule,temp];
    , result = Global`PolynomialsToGBRules[temp];
  ];
  Return[result];
];

ToGBRule[x_Equal] := ToGBRule[x[[1]] - x[[2]]];
ToGBRule[x_Rule] := ToGBRule[x[[1]] - x[[2]]];

ToGBRule[0] := 0;

ToGBRule[Poly_] := Global`PolynomialToGBRule[Poly];

ToGBRule[x___] := BadCall["ToGBRule",x];

ToGBRules[x___] := ToGBRule[x];

NCCleanUpPolys[x___] := CleanUpBasis[x];

NCCleanUpPols[x___] := CleanUpBasis[x];

CleanUpBasis[x___] :=
Module[{},
  Print["Please use NCSCleanUpRules next time."];
  Return[NCSCleanUpRules[x]];
];

NCSCleanUpRules[aList_List] :=
Module[{},
  Global`SetCleanUpBasis[1];
  Return[NCMakeRules[aList,0]]; 
];

NCSCleanUpRules[x___] := BadCall["NCSCleanUpRules",x];


SetStartingRelations[x___] := BadCall["SetStartingRelations",x];

WhatAreStartingRelations[] := startingRelations;

WhatAreStartingRelations[x___] := BadCall["WhatAreStartingRelations",x];

FinishedComputingBasisQ[] := Global`FoundBasis[];

FinishedComputingBasisQ[x___] := BadCall["FinishedComputingBasisQ",x];

SortRelations[aList:{___Rule}] := 
Module[{result,temp,vars,totalvars,theMax,theRule,aSet,len,relations,j},
   relations[x_] = {};
   theMax = 0;
   totalvars = GatherUnknowns[];
   Do[ theRule = aList[[j]];
       aSet = Union[Intersection[totalvars,
                                 Union[Grabs`GrabIndeterminants[theRule]]]];
       len = Length[aSet];
       If[len>theMax, theMax = len];
       AppendTo[relations[len],theRule];
   ,{j,Length[aList]}];
   result = {};
   Do[temp = sortRelations[relations[j]];
      AppendTo[result,temp];
   ,{j,0,theMax}];
   result = Flatten[result];
   Clear[relations];
   Return[result];
];

SortRelations[x___] := BadCall["SortRelations",x];

sortRelations[aList_] := 
Module[{result},
   result = Sort[aList,sortRelatiosnAux[#1[[1]],#2[[1]]]&];
   Return[result];
];

sortRelationsAux[x_,y_] := 
Module[{ans,i,X,Y,var,found,tuplex,tupley},
(*
  tuplex = Table[0,{i,1,$orderMax}];
  tupley = Table[0,{i,1,$orderMax}];
  If[Head[x]===NonCommutativeMultiply
         , X = Apply[List,x];
         , X = {x};
  ];
  Do[ found = False;
      var = X[[i]];
      For[j=1,j<= $orderMax && Not[found],j=j+1,
         found = MemberQ[$order[j],var];
         If[found, tuplex[[j]] = tuplex[[j]]+1;];
      ];
  ,{i,1,Length[X]}];
  If[Head[y]===NonCommutativeMultiply
         , Y = Apply[List,y];
         , Y = {y};
  ];
  Do[ found = False;
      var = Y[[i]];
      For[j=1,j<= $orderMax && Not[found],j=j+1,
         found = MemberQ[$order[j],var];
         If[found, tupley[[j]] = tupley[[j]]+1;];
      ];
  ,{i,1,Length[Y]}];
Print["x:",x];
Print["y:",y];
*)
  ans = PolyToRule[x-y]===(x->y);
  Return[ans];
];

sortRelationsAux[x___] := BadCall["sortRelationsAux",x];

sortRelations[x___] := BadCall["sortRelations",x];

SortMonomials[aList_] := 
Module[{},
   Return[Sort[aList,sortRelationsAux]];
];

SortMonomials[x___] := BadCall["SortMonomials",x];

KHistory[aList:{___Integer}] := ToExpression[Global`KludgeHistory[aList]];

KHistory[x___] := BadCall["KHistory",x];

WhatIsKlugeHistory[aList:{___Integer}] :=
      ToExpression[Global`KludgeHistory[aList]];

WhatIsKlugeHistory[x___] := BadCall["WhatIsKlugeHistory",x]; 

WhatIsHistory[x_Global`GBMarker] := Global`RetrieveMarker[x]; 

WhatIsHistory[aList:{___Integer},opts___Rule] := 
Module[{first,poly,result,i,usemarker},
  first = WhatIsKlugeHistory[aList];
  poly = WhatIsPartialGB[aList];
  result = Table[{first[[i,1]],PolyToRule[poly[[i]]],
                  first[[i,3]],first[[i,4]]}
                ,{i,1,Length[aList]}];
  Return[result];
];
(*
  Flatten[Map[ToExpression[Global`pWhatIsHistory[{#}]]&,aList],1];
*)

WhatIsHistory[x___] := BadCall["WhatIsHistory",x];

GroebnerSimplify[aList_List,start_List] := GroebnerSimplify[aList,start,3];

GroebnerSimplify[aList_List,start_List,iter_Integer] := 
    NCGroebnerSimplify[aList,start,iter];

GroebnerSimplify[x___] := GroebnerSimplify[x];

NCGroebnerSimplify[aList_List,start_List,iter_Integer] := 
Module[{basis,result},
  NCMakeRules[start,0,ReturnRelations->False];
  Return[NCContinueGroebnerSimplify[aList,iter]];
];

NCGroebnerSimplify[x___] := NCGroebnerSimplify[x];

NCSimplifyAll[toreduce_,start_,Iter_Integer] :=
Module[{ans,reallyDone,iterCounter},
  NCMakeGB[start,0, 
           ReturnRelations->False,
           ReorderInput->True
          ];
  reallyDone = False;
  ans = toreduce;
  For[iterCounter=1,
      And[iterCounter<=Iter,Not[reallyDone]],
      iterCounter++,
     NCContinueMakeGB[iterCounter];
     ans = Reduce`FastReduction[ans];
     reallyDone = Union[ans]==={0};
  ];
  Return[ans];
];

NCContinueGroebnerSimplify[aList_List,Iter_Integer] :=
Module[{polys,result},
  NCContinueMakeGB[Iter];
  polys = RuleToPoly[aList];
  result = Reduce`FastReduction[polys];
  Return[result];
];


SetMonomialOrderSymmetric[aList_List,n_] :=
Module[{j,temp},
     Map[(WhichSet[#]=.;)&,WhatIsSetOfIndeterminants[j]];
     temp = Table[{#,tp[#]}&,aList];
     temp = Flatten[temp];
     SetMonomialOrder[temp,n];
     Return[];
];

SetMonomialOrderSymmetric[x___] :=
BadCall["SetMonomialOrderSymmetric",x];

trips = {};

MultipleTrips[expr_,m_Integer] :=
Module[{},
  AppendTo[trips,{StartToNumber[expr],m}];
];

ReportMemoryDiagnostics[memoryUsageNumber_Integer] := 
   ( Put[MemoryInUse[],$GBDirectory<>"/usage"<>
             ToString[memoryUsageNumber]];
     PutAppend[Global`CPlusPlusMemoryUsage[],
        $GBDirectory<>"/usage"<>ToString[memoryUsageNumber]];
   );

SetKnowns[x___] := SetMonomialOrder[Flatten[{x}],1];

SetUnknowns[x___] := 
Module[{aList,i},
   aList = {x};
   Do[ Global`ClearMonomialOrderN[i];
   ,{i,2,WhatIsMultiplicityOfGrading[]}];
   Table[SetMonomialOrder[Flatten[{aList[[i]]}],i+1],{i,1,Length[aList]}];
(*
   Table[SetMonomialOrder[Flatten[{aList[[i]]}],i*10],{i,1,Length[aList]}];
*)
];

GatherUnknowns[] := 
  If[WhatIsMultiplicityOfGrading[]===1
         , {}
         , Flatten[Table[SetOfIndeterminants[i]
               ,{i,2,WhatIsMultiplicityOfGrading[]}]]
  ];

SpellCheckOptions[aName_Symbol,aList_List] :=
Module[{temp},
   temp = Complement[Map[First,aList],
                     Map[First,Options[aName]]
                    ];
   If[Not[temp==={}]
     , Print["*** Warning: Spelling error"];
       Print["The following words do not denote options",
             " for ",ToString[aName]];
       Print[temp];
   ];
];

NumbersFromHistory[aPolynomial_,history_] :=
Module[{result,i,x},
  result = {};
  x = RuleToPoly[aPolynomial];
  Do[ If[RuleToPoly[history[[i,2]]]===x,
             AppendTo[result,history[[i,1]]]
        ];
  ,{i,1,Length[history]}];
  Return[result];
];

RelationUnion[aList_List] :=
Module[{result,remain,include,item,i,j,small},
  remain = Union[aList];
  result = {};
  Do[ item = remain[[j]];
      include = True;
      small = Select[result,(Head[#]===Head[item]&&Length[#]===Length[item])&];
      Do[ (* See if small[[j]] and item are nonzero multiples of one
             another -- start with just by -1 *) 
          If[small[[j]]===ExpandNonCommutativeMultiply[-item]
             ,include = False;
          ];
      ,{i,1,length[small]}];
      If[include, AppendTo[result,item]];
  ,{j,1,Length[remain]}];;
  Return[result];
];

RelationUnion[x___] := BadCall["RelationUnion",x];

ReduceAndRetainNonZero[relations_List] :=
Module[{result,reduced},
  (* reduce by above partial gb *)
  
  reduced = Reduce`FastReduction[relations];
  result = {};
  Do[If[Not[reduced[[j]] === 0]
      , $NC$NCGBMmaDiagnosticPrint[relations[[j]],
              " is apparently not a member of the ideal generated by ",
              result];
        result = Append[result,relations[[j]]];
      , $NC$NCGBMmaDiagnosticPrint[relations[[j]],
              " is apparently a member of the ideal generated by ",
              result];
     ]; 
  ,{j,1,Length[reduced]}];
  Return[result];
];
 
ReduceAndRetainNonZero[x___] := BadCall["ReduceAndRetainNonZero",x];

testCode[] :=
Module[{temp},
  temp = MemoryInUse[];
  Print[Global`testFeature[]];
  Return[MemoryInUse[] - temp];
];

testCode2[] :=
Module[{temp},
  temp = MemoryInUse[];
  (* fill in here *)
  Return[MemoryInUse[] - temp];
];

NCContinueMakeGB[Iter_Integer] := 
Module[{temp},
   Global`SetIterations[Iter];
   temp = Global`continueRun[];
(* temp = Global`continueRun[Iter];  bug *)
   If[temp===$Failed,
        Print["The call to the C++ code failed somehow."];
        Print["The call to the C++ code failed somehow."];
        Print["The call to the C++ code failed somehow."];
        Print["The call to the C++ code failed somehow."];
        Print["There may be an indication why above."];
        Abort[];
   ];
   Return[];
];

NCContinueMakeGB[x___] := BadCall["NCContinueMakeGB",x];

InPlaceComplement[aList_List,exclude_List] :=
Module[{result,i},
  result = {};
  Do[ If[Not[MemberQ[exclude,aList[[i]]]]
        , AppendTo[result,aList[[i]]];
      ];
  ,{i,1,Length[aList]}];
  Return[result];
];

(*
  
   This function is a faster and quieter version of 
   NCMakeGB[polys,0];

*)
   
CreateFactControl[polys_List] :=
Module[{temp,start},
  temp = Global`SetGlobalPtr[];
  If[temp===$Failed,
    Print["Call to SetGlobalPtr failed."];
    Abort[];
  ];
  ReinstateOrder[];
  start = polys/.Rule->Subtract;
  start = start/.Equal->Subtract;
  start = Flatten[start];
  start = NCMonomial[start];
  start = NonCommutativeMultiply`ExpandNonCommutativeMultiply[start];
  start = InPlaceComplement[start,{0,True}];
  (* This marker is deleted by SetGlobalPtr *)
  start = sendMarkerList["polynomials",start];
  SetStartingRelations[start];
];

CreateFactControl[x_GBMarker] :=
Module[{temp,start},
  temp = Global`SetGlobalPtr[];
  If[temp===$Failed,
    Print["Call to SetGlobalPtr failed."];
    Abort[];
  ];
  ReinstateOrder[];
  (* This marker is deleted by SetGlobalPtr *)
  start = CopyMarker[x,"rules"];
  SetStartingRelations[start];
];

CreateFactControl[x___] := BadCall["CreateFactControl",x];

End[];
EndPackage[]
