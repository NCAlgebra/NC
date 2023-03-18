(* NCProcess.m                            *)
(* Author: unknown (packaged by Mauricio) *)
(*   Date: June 2009                      *)

(* History :
	Who knows ?
	Pre-1996 effort 
	:9/9/99:  Added global marker NCPAns to NCProcess 
		so people will have access to categories (dell )

*)

BeginPackage[ "NCProcess`",
	      "OutputArrayForTeX`",
              "NCCollectOnVariables`",
              "NCTeXForm`",
              "NCTeX`",
              "NCTime`",
              "NCXPUtil`",
              "MoraAlg`",
	      "Grabs`",
	      "NonCommutativeMultiply`",
	      "Global`" ];

Clear[NCProcess];
NCProcess::usage = "NCProcess[aListOfPolys or aMarkerOfPolys, iterations, \
filename, UserSelect -> anotherListOfPolys or anotherMarkerOfPolys, \ 
Deselect -> yetanotherListOfPolynomials];";
NCProcess::dropped = "Droped `1` polys for being too long";

Options[NCProcess] = {
  Deselect->{},
  UserSelect->{}, 
  UserUnknowns->{},
  NCShortFormulas->-1,
  NCKnownIndeterminant->{},
  RR->True, 
  RRByCat->False, 
  SBByCat->True, 
  SB->False,
  RRSB->False, 
  RRSBByCat->False,
  DegreeCap->-1, 
  DegreeSumCap->-1,
  DegreeCapSB->-1, 
  DegreeSumCapSB->-1,
  NCGBDebug->False,
  Slow->False,
  SBFlatOrder->False,
  (* BEGIN MAURICIO MAR 2016 *)
  (* NCCollectOnVars is broken beyond repair at this point *)
  (* NCCV->True, *)
  NCCV->False, 
  (* END MAURICIO MAR 2016 *)
  NCGBNag->False,
  AdditionalRegularOutputOptions->{},
  DisplayOptions->True,
  PrintScreenOutput->False,
  NCGBFastRegularOutput->False
};

Begin["`Private`"];

  Clear[FilterOutKnowns];
  FilterOutKnowns[ originalList_List , userUnknowns_List ] := Module[
    {varList, memberList, dropList},

    If[ userUnknowns === {}, 
        Return[ originalList ]; 
    ];

    varList = Map[ GrabVariables[#]& , originalList ];
    memberList = Map[ If[ Intersection[#, userUnknowns] === {}, False, True ]&, varList ];
    dropList = Position[ memberList , False ];

    Return[ Delete[ originalList, dropList ] ];

  ];

  Clear[FilterOutLongStuff];
  FilterOutLongStuff[ longList_List , filterLength_Integer ] := Module[
    {lengthList, longPosn, dropList, dropCount},

    If[ filterLength === -1, 
        Return[ longList ] 
    ];

    lengthList  = Map[ LeafCount , longList ];
    longPosn = Map[#>filterLength&, lengthList ];
    dropList = Position[ longPosn , True ];

    dropCount = Count[ longPosn, True ]; 
    Message[NCProcess::dropped, dropCount];

    Return[ Join[{dropCount}, Delete[ longList, dropList ]] ];

  ];

  Clear[doIt];
  doIt[rules_List, anArray_Symbol] := Map[doIt[#,anArray]&, rules];
  doIt[rule_, anArray_Symbol] := Module[
    {ans},
    (* Print["Before:", rule]; *)
    ans = NCCollectOnVariables[rule];

    (* Print["After:", ans]; *)
    If[ ans===RuleToPoly[rule],
        ans = rule;
    ];

    (* Print["Final:", ans]; *)
    Return[ans];
  ];

  Clear[UseOptions];
  UseOptions[opts_List,opt_Symbol]:=
  Module[{userselect},
    opt["nag"] = NCGBNag /. opts /. Options[NCProcess];
    opt["deselects"] = Deselect /. opts /. Options[NCProcess];
    opt["additionalRegOutOpt"] = 
         AdditionalRegularOutputOptions /. opts /. Options[NCProcess];
    userselect = UserSelect /. opts /. Options[NCProcess];
    If[Head[userselect]===List
      ,opt["userselect"]=sendMarkerList["polynomials",RuleToPol[userselect]]
      ,opt["userselect"]=CopyMarker[userselect,"polynomials"]
    ];
    opt["userunknowns"]= UserUnknowns /. opts /. Options[NCProcess];
    opt["shortformulas"]= NCShortFormulas /. opts /. Options[NCProcess];
    opt["knownIndeterminant"]= NCKnownIndeterminant /. opts /. Options[NCProcess];
    opt["nccv"] = NCCV /. opts /. Options[NCProcess];
    opt["displayoptions"] = DisplayOptions /. opts /. Options[NCProcess];
     opt["createcategories"] = True;
    opt["nice-regular-output"] = True;
    opt["fast-regular-output"] = NCGBFastRegularOutput /. opts /. Options[NCProcess];
    opt["rroption"] = RR /. opts /. Options[NCProcess];
    opt["rrbycatoption"] = RRByCat /. opts /. Options[NCProcess];
    opt["sbbycatoption"] = SBByCat /. opts /. Options[NCProcess];
    opt["sboption"] = SB /. opts /. Options[NCProcess];
    opt["rrsboption"] = RRSB /. opts /. Options[NCProcess];
    opt["rrsbbycatoption"] = RRSBByCat /. opts /. Options[NCProcess];
    opt["degreecap"] = DegreeCap /. opts /. Options[NCProcess];
    opt["degreesumcap"] = DegreeSumCap /. opts /. Options[NCProcess];
    opt["sbflatorder"] = SBFlatOrder /. opts /. Options[NCProcess];

    opt["dorr"] = And[Not[opt["rrbycatoption"]],
          Or[opt["rroption"],opt["rrsboption"],opt["rrsbbycatoption"]]];
    opt["dorrbycat"] = opt["rrbycatoption"];
    opt["dosb"] = Or[opt["sboption"],opt["rrsboption"]];
    opt["dosbbycat"] = And[Not[opt["dosb"]],
                     Or[opt["sbbycatoption"],opt["rrsbbycatoption"]]];

    opt["slow"] = NCGBDebug /. opts /. Options[NCProcess];
    opt["printscreen"] = PrintScreenOutput /. opts /. Options[NCProcess];
    If[Not[FreeQ[opts,Slow]]
      , Print["Please use the option NCGBDebug next time."];
        opt["slow"] = Slow /. opts /. Options[NCProcess];
    ];

    If[opt["degreecap"]==-1
         ,opt["degreecapsb"]=-1
         ,opt["degreecapsb"]=opt["degreecap"]+1
      ];
    If[opt["degreesumcap"]==-1
         ,opt["degreesumcapsb"]=-1
         ,opt["degreesumcapsb"]=opt["degreesumcap"]+1
      ];
    opt["degreecapsb"] = DegreeCapSB /. opts /. {DegreeCapSB->opt["degreecapsb"]};
    opt["degreesumcapsb"] =
                DegreeSumCapSB /. opts /. {DegreeSumCapSB->opt["degreesumcapsb"]};

    opt["NCMakeGB1"]:={Deselect->RuleToPol[opt["deselects"]],
             UseMarker->True,
             UserSelect->opt["userselect"],
             DegreeCap->opt["degreecap"],
             DegreeSumCap->opt["degreesumcap"],
             ReorderInput->True};

    opt["NCMakeGB2"]:= {
             UserSelect->opt["userselect"],
             UseMarker->True,
             SupressCOutput->True,
             DegreeCap->opt["degreecap"],
             DegreeSumCap->opt["degreesumcap"],
             ReorderInput->True};

    opt["SmallBasisByCat"]:={
                     DegreeCap->opt["degreecapsb"],
                     DegreeSumCap->opt["degreesumcapsb"]};
    opt[x___] := BadCall["opt",x];
    Return[];
  ];

  Clear[NCGBEmpty];
  (* Old way *)
  NCGBEmpty[markers_List]:=
  Module[{i},
     Do[DestroyMarker[markers[[i]]];
     ,{i,Length[markers]}];
     Return[{}];
  ];
  (* New way - Ready ??
  NCGBEmpty[markers:{___GBMarker}]:= (DestroyMarker[markers];Return[{}];);
  *)

  NCGBEmpty[x___]:= BadCall["NCGBEmpty",x];


  (* NCProcess *)

  NCProcess[x_,0,s_String,opts___Rule] := NCProcess[x,0,0,0,0,s,opts];
  NCProcess[x_,0,0,s_String,opts___Rule] := NCProcess[x,0,0,0,0,s,opts];
  NCProcess[x_,0,0,0,s_String,opts___Rule] := NCProcess[x,0,0,0,0,s,opts];

  (* Account for less parameters *)
  NCProcess[ polys:(_List|_Global`GBMarker),
             iterations_Integer,
             fileName_String, 
             opts___Rule ] :=
    NCProcess[ polys,
               iterations, iterations + 1, iterations + 1, iterations + 2,
               fileName, opts ];

  NCProcess[ polys:(_List|_Global`GBMarker),
             iterations_Integer,
             iterations2_Integer,
             fileName_String,
             opts___Rule ] :=
    NCProcess[ polys,
               iterations, iterations2, iterations + 1, iterations + 2,
               fileName, opts ];

  NCProcess[ polys:(_List|_Global`GBMarker),
             iterations_Integer,
             iterations2_Integer,
             iterations3_Integer,
             fileName_String,
             opts___Rule ] :=
    NCProcess[ polys,
               iterations, iterations2, iterations3, iterations3 + 1,
               fileName, opts ];

  (* This is where the work is done. *)
  NCProcess[ polys:(_List|_Global`GBMarker),
             iterations_Integer,
             iterations2_Integer,
             iterations3_Integer,
             iterations4_Integer,
             fileName_String,
             opts___Rule ] := Module[
    {result,result1,result2,result3,dummy4,dig,GBdigested,rrdig,rr,
          option,trash={},rrbc,rrbcmarker,comments,knGrade,
          inputForNCMakeGB,gbnums,fc,ints,fc2,bigGB,fc3,gbnums2,
          rrdigpoly,digpolys,startpolys,collectedpolys,
          rr2,rrpolys,rr2numbers,rr2knownrules,knowns,
          prelimstime,NCGB1time,RR1time,bigGBtime,RR2time, start,
          reduceunknownstime,CleanUptime,SBtime,CCtime,nccvtime,
          PRINTSTEP },

    (* MAURICIO - BEGIN *)
    (* Globals are a bad choice! Removed *)
    (* Clear[ NCPAns ]; *)
    (* MAURICIO - END *)

    useDeselect = False; 

    Start["beginning"];

    (* Check the validity of the options *)
    SpellCheckOptions[NCProcess,{opts}];

    UseOptions[{opts},option];
    If[TrueQ[option["printscreen"]]
      (*, PRINTSTEP[x___] := (If[LinkAlive[]=!=True, Exit[];];Print[x];); *)
      , PRINTSTEP[x___] := Print[x];
      , PRINTSTEP[x___] := Null;
    ];

    (* trash is a list containing all of the markers *)
    (* they will destroyed by the function call NCGBEmpty[trash]; *)

    (* MAURICIO - BEGIN *)  
    (*
      If[Head[polys]===List, 
        start = sendMarkerList["polynomials",
                   RuleToPol[ExpandNonCommutativeMultiply[polys]]];
        ,
        start = CopyMarker[polys, "polynomials"];
      ]; 
      AppendTo[trash, start];

      PRINTSTEP["\nStep 0: Set user selects"];
      NCMakeGB[start, 0, UserSelect -> option["userselect"],
                         ReturnRelations -> False];
    *)

    (* Mark, please check if this modification is kosher.
       The idea is that NCMakeGB does some testing and then should be called
       whenever possible. Please make sure that the Marker copies are not generating 
       leaks.
    *)

    PRINTSTEP["\nStep 0: Set user selects"];
    NCMakeGB[polys, 0, UserSelect -> option["userselect"],
                       ReturnRelations -> False];

    (* retrieve and copy starting relations from NCMakeGB *)
    start = CopyMarker[WhatAreStartingRelations[], "polynomials"];
    AppendTo[trash, start];

    (* MAURICIO - END *)  

    fc = SaveFactControl[];
    AppendTo[trash, fc];

    ints = WhatAreGBNumbersMarker[fc];
    AppendTo[trash, ints];

    (* dig is a marker for the digested rules *)
    dig = DigestedRelations[fc, ints];
    AppendTo[trash, dig];

    digpolys = CopyMarker[dig, "polynomials"];
    AppendTo[trash, digpolys];

    startpolys = UnionMarkers[digpolys, option["userselect"]];
    AppendTo[trash, startpolys];

    prelimstime = Finish["beginning"];

    PRINTSTEP["Step 1: Do NCMakeGB on digested relations only"];
    Start[];
    If[useDeselect
      , GBdigested=Apply[ NCMakeGB,
                          Join[{startpolys,iterations2},option["NCMakeGB1"]]];
      , GBdigested = CreateMarker["polynomials"];
    ];
    If[option["slow"]
     , Put[unmarker[GBdigested],$GBDirectory<>"/firstGB"];
    ];
    AppendTo[trash, GBdigested];

    GBrulesmarker=CopyMarker[GBdigested,"rules"];

    (* Print["About to do an acceptable return of rules to Mma"];*)
    (* GBdigestedrules is the first element of the threetuple 
       !!!!!! which is output !!!!! *)
    GBdigestedrules=RetrieveMarker[GBrulesmarker];
    AppendTo[trash, GBrulesmarker];

    NCGB1time=Finish[];

    Start[];
    If[option["dorr"] 
      ,(* THEN *)
       PRINTSTEP["Step 2: RemoveRedundent on partial GB of digested"]; 
       If[option["slow"]
         ,(* Excess output *)
          ReportMemoryDiagnosics[1];
          Put[RetrieveMarker[GBdigested],
                          $GBDirectory<>"/inputOfRROnKnowns"];
       ];

       fc2 = SaveFactControl[];
       AppendTo[trash, fc2];
       (* Print["fc2:",fc2]; *)
       gbnums = WhatAreGBNumbersMarker[fc2];
       rrdig = Global`RemoveRedundentProtect[fc2, gbnums]; 
       AppendTo[trash, gbnums];
      ,(* ELSE *)

       rrdig = CopyMarker[GBdigested, "rules"];

    ];
    (* rrdig is a marker of rules for whatever is left of the first NCMakeGB *)
    AppendTo[trash, rrdig];
    RR1time = Finish[];

    If[ And[option["dorr"], option["slow"]]
      ,(* Excess output *)
       ReportMemoryDiagnosics[2];
       Put[RetrieveMarker[rrdig], $GBDirectory<>"/outputOfRROnKnowns"];
    ];

    rrdigpoly = CopyMarker[rrdig,"polynomials"];
    (* Print["rrdigpoly:",rrdigpoly]; *)
    AppendTo[trash, rrdigpoly];
    If[option["slow"]
      , Put[unmarker[start],$GBDirectory<>"/start"];
        Put[unmarker[rrdigpoly],$GBDirectory<>"/rrdigpoly"];
    ];

    inputForNCMakeGB = UnionMarkers[start, rrdigpoly];
    AppendTo[trash, inputForNCMakeGB];

    If[option["slow"]
      ,(* THEN *)
       Null; 
       (* Print[ "Input for step 3 NCMakeGB is:",
                 RetrieveMarker[inputForNCMakeGB] ]; *)
      ,(* ELSE *)
       PRINTSTEP["Step 3: NCMakeGB on everything"];
    ];

    (*  Print["About to retrieve user selects"];*)
    Start[];
    If[option["slow"]
      , Put[unmarker[inputForNCMakeGB],$GBDirectory<>"/beforeSecondGB"];
    ];
    If[option["nag"]
     , bigGB=Apply[NCMakeGBNag,Join[{inputForNCMakeGB,iterations,
                   fileName<>"Nag",
                   Deselect->RetrieveMarker[GBdigested]},
                   option["NCMakeGB2"]]];
     , bigGB=Apply[NCMakeGB,Join[{inputForNCMakeGB,iterations,
                   Deselect->RetrieveMarker[GBdigested]},
                   option["NCMakeGB2"]]];
    ];
    (* Print["bigGB:",bigGB];*)
    bigGBtime = Finish[];

    If[option["slow"]
      , Put[unmarker[bigGB], $GBDirectory<>"/afterSecondGB"];
    ];

    trash = NCGBEmpty[trash];

    fc3 = SaveFactControl[];
    AppendTo[trash, fc3];
    AppendTo[trash, bigGB];

    Start[];
    If[option["dorr"] 
      ,(* THEN *)
       PRINTSTEP["Step 4: RemoveRedundent on everything"];
       If[option["slow"]
         ,(* Excess output *)
          ReportMemoryDiagnosics[3];
          Put[RetrieveMarker[bigGB],
                          $GBDirectory<>"/inputOfRR"];
       ];

       (* Print["fc3:",fc3];*)
       gbnums2=WhatAreGBNumbersMarker[fc3];
       (* Print["gbnums2:",gbnums2];*)
       rr2=Global`RemoveRedundentProtect[fc3,gbnums2]; 
       (* Print["rr2:",rr2];*)
       AppendTo[trash, gbnums2];
      ,(* ELSE *)
       rr2 = CopyMarker[bigGB,"rules"];
       fc3 = SaveFactControl[];
       AppendTo[trash, fc3];
    ];   
    RR2time=Finish[];  (* end option RemoveRedundant *)

    If[And[option["dorr"],option["slow"]]
      ,(* Excess output *)
       ReportMemoryDiagnosics[4];
       Put[RetrieveMarker[rr2],$GBDirectory<>"/outputOfRR"];
    ];  

    If[option["dorrbycat"]
       ,
       PRINTSTEP["Step 4: RemoveRedundentByCategory on everything"];
       rrbc = RemoveRedundentByCategory[];
       (* RetrieveMarker[bigGB], RetrieveMarker[fc3]; *)
       rrbcmarker = sendMarkerList["polynomials",rrbc];
       AppendTo[trash, rrbcmarker];
       rr2 = CopyMarker[rrbcmarker, "rules"];
    ];
    (* rr2 is a marker of rules for whatever is left of the second NCMakeGB *)
    AppendTo[trash, rr2];

    Start[];

    PRINTSTEP["Step 5: Use the knowns to reduce the unknowns"];
    rrpolys=CopyMarker[rr2,"polynomials"];
    rr2numbers=NumbersFromRuleMarker[fc3,rr2];
    (* Print["rr2numbers :",rr2numbers];*)
    rr2knownrules=knownRelations[fc3,rr2numbers];
    (* Print["rr2knownrules :",rr2knownrules];*)
    rr2knownpolys=CopyMarker[rr2knownrules,"polynomials"];
    (* Print["rr2knownpolys :",rr2knownpolys];*)
    result1 = Reduce`internalReduction[rrpolys,rr2knownrules];
    result2 = UnionMarkers[rr2knownpolys,result1];

    AppendTo[trash, rr2numbers];
    AppendTo[trash, rr2knownrules];
    AppendTo[trash, rr2knownpolys];
    AppendTo[trash, rrpolys];
    AppendTo[trash, result1];

    trash = NCGBEmpty[trash];

    trash = {result2};
    reduceunknownstime=Finish[];

    PRINTSTEP["Step 6: Clean up basis"];
    Start[];
    input=UnionMarkers[result2,option["userselect"]];
    result3 = NCMakeGB[input,0,UserSelect->option["userselect"],UseMarker->True];

    AppendTo[trash, input];
    AppendTo[trash, result3];

    (* Excess output *)
    If[option["slow"]
      ,Put[RetrieveMarker[result3],$GBDirectory<>"/billSreduction.result"];
       ReportMemoryDiagnosics[5];
    ];

    CleanUptime = Finish[];
    (****************************************************)
    Start[];

    (* This is the whole output of the Goebner basis algorithms 
       including UserSelect.   That is, <input> = <result>      *)
    result = RetrieveMarker[result3];


    (* Here is the UserUnknowns option. It eliminates the 
       output which does not concern the variables 
       specified in UserUnknowns *) 
    result = FilterOutKnowns[ result, option["userunknowns"] ];
    result = FilterOutLongStuff[ result, option["shortformulas"] ];
    DropCount = Part[result, 1];
    result = Rest[result];

    If[option["dosbbycat"]
      ,
       PRINTSTEP["Step 7: SmallBasisByCategory"];
       If[option["slow"]
         , Put[result,"SBBC.input"];
           Put[iterations3,"SBBC.iter"];
           Put[iterations4,"SBBC.iter2"];
           Put[option["SmallBasisByCat"],"SBBC.extraOptions"];
       ];

       result = Apply[ Global`SmallBasisByCategory,Join[{result,
                    iterations3,Global`KnownsIter->iterations4},
                    option["SmallBasisByCat"]]];

       (* Excess output *)
       If[option["slow"]
         , Put[result,"SBBC.output"];
           ReportMemoryDiagnosics[6];
           Put[result,$GBDirectory<>"/SmallBasisByCategory.result"];
           ReportMemoryDiagnosics[7];
       ];
    ];

    If[option["dosb"]
      ,
       PRINTSTEP["Step 7: SmallBasis"];
       result = Global`SmallBasis[result,{},iterations3];

       (* Excess output *)
       If[option["slow"]
         ,ReportMemoryDiagnosics[6];
          Put[result,$GBDirectory<>"/SmallBasis.result"];
          ReportMemoryDiagnosics[7];
       ];
    ];

    If[option["sbflatorder"] ,
      result = NCFlatSmallBasis[result,iterations3];

      ]; (* end option sbflatorder *)

    SBtime=Finish[];
    PRINTSTEP["Step 8: Write the file"];
    (*
    Apply[Global`RegularOutput,
          Join[{result,fileName,"C++"},
               opt["additionalRegOutOpt"]]];
    *)

    If[option["displayoptions"],
    (* MAURICIO - BEGIN *)
    (*
     InitTeXStringReplace[TeXReplace /. 
                            option["additionalRegOutOpt"] /. 
                            {TeXReplace->{}}];
       comments="Input = \n$\n"<>ToStringForTeX[polys]<>"\n$\n"<>
         "File Name = "<>fileName<>"\\\\\n"<>
         "NCMakeGB Iterations = "<>ToString[iterations]<>"\\\\\n"<>
         "NCMakeGB on Digested Iterations = "<>ToString[iterations2]<>"\\\\\n"<>
         "SmallBasis Iterations = "<>ToString[iterations3]<>"\\\\\n"<>
         "SmallBasis on Knowns Iterations = "<>ToString[iterations4]<>"\\\\\n"<>
         "Deselect$\\rightarrow "<>
                     ToStringForTeX[option["deselects"]]<>"$\\\\\n"<>
         "UserSelect$\\rightarrow "<>
                     ToStringForTeX[option["userselect"]]<>"$\\\\\n"<>
         "UserUnknowns$\\rightarrow "<>
                     ToStringForTeX[option["userunknowns"]]<>"$\\\\\n"<>
         "NCShortFormulas$\\rightarrow$"<>
                                     ToString[option["shortformulas"]]<>"\\\\\n"<> 
         "RR$\\rightarrow $"<>ToString[option["dorr"]]<>"\\\\\n"<>
         "RRByCat$\\rightarrow $"<>ToString[option["dorrbycat"]]<>"\\\\\n"<>
         "SB$\\rightarrow $"<>ToString[option["dosb"]]<>"\\\\\n"<>
         "SBByCat$\\rightarrow $"<>ToString[option["dosbbycat"]]<>"\\\\\n"<>
         "DegreeCap$\\rightarrow $"<>ToString[option["degreecap"]]<>"\\\\\n"<>
         "DegreeSumCap$\\rightarrow $"<>
                                  ToString[option["degreesumcap"]]<>"\\\\\n"<>
         "DegreeCapSB$\\rightarrow $"<>ToString[option["degreecapsb"]]<>"\\\\\n"<>
         "DegreeSumCapSB$\\rightarrow $"<>
                             ToString[option["degreesumcapsb"]]<>"\\\\\n"<>
         "NCCV$\\rightarrow $"<>ToString[option["nccv"]]<>"\\\\\n";
    *)
       comments="\\noindent\nInput = \n$\n"<>NCTeXForm[polys]<>"\n$\\\\\n"<>
         "File Name = "<>fileName<>"\\\\\n"<>
         "NCMakeGB Iterations = "<>ToString[iterations]<>"\\\\\n"<>
         "NCMakeGB on Digested Iterations = "<>ToString[iterations2]<>"\\\\\n"<>
         "SmallBasis Iterations = "<>ToString[iterations3]<>"\\\\\n"<>
         "SmallBasis on Knowns Iterations = "<>ToString[iterations4]<>"\\\\\n"<>
         "Deselect$\\rightarrow "<>
                     NCTeXForm[option["deselects"]]<>"$\\\\\n"<>
         "UserSelect$\\rightarrow "<>
                     NCTeXForm[RetrieveMarker[option["userselect"]]]<>"$\\\\\n"<>
         "UserUnknowns$\\rightarrow "<>
                     NCTeXForm[option["userunknowns"]]<>"$\\\\\n"<>
         "NCShortFormulas$\\rightarrow$"<>
                                     ToString[option["shortformulas"]]<>"\\\\\n"<> 
         "RR$\\rightarrow $"<>ToString[option["dorr"]]<>"\\\\\n"<>
         "RRByCat$\\rightarrow $"<>ToString[option["dorrbycat"]]<>"\\\\\n"<>
         "SB$\\rightarrow $"<>ToString[option["dosb"]]<>"\\\\\n"<>
         "SBByCat$\\rightarrow $"<>ToString[option["dosbbycat"]]<>"\\\\\n"<>
         "DegreeCap$\\rightarrow $"<>ToString[option["degreecap"]]<>"\\\\\n"<>
         "DegreeSumCap$\\rightarrow $"<>
                                  ToString[option["degreesumcap"]]<>"\\\\\n"<>
         "DegreeCapSB$\\rightarrow $"<>ToString[option["degreecapsb"]]<>"\\\\\n"<>
         "DegreeSumCapSB$\\rightarrow $"<>
                             ToString[option["degreesumcapsb"]]<>"\\\\\n"<>
         "NCCV$\\rightarrow $"<>ToString[option["nccv"]]<>"\\\\\n";
    (* MAURICIO - END *)
      ,comments="";
      ];

    (* Sort the output of small basis by category *)
    Start[];
    If[option["createcategories"],

          (* The knownIndeterminant option allows the user to specify
                the breakpoint between knowns and unknowns *)
          If[ option["knownIndeterminant"] =!= {},
                  For[ j=1,j++, j <= MultiplicityOfGrading &&
                  Not[MemberQ[ option["knownIndeterminant"],
                          WhatIsSetOfIndeterminants[j] ]  ] ];
          knGrade = j;
          Global`CreateCategories[result,dummy4,KnownGrading->knGrade ];,
                  Global`CreateCategories[result,dummy4 ];
          ];
    ];

    CCtime=Finish[];
    (*
    Put[Information[result],"MARK_FILE"];
    *)

    Start[];
    If[option["nccv"]
      ,PRINTSTEP["Starting collection on variables"];

       collectedpolys=NCCollectOnVariables[result];
       PRINTSTEP["Ending collection on variables"];

      ,collectedpolys={}
    ];

    nccvtime=Finish[];   

    If[option["nccv"]
      , dummy4["additionalFunction"] = doIt;
    ];


    If[option["fast-regular-output"]
      , NCMakeGB[result,0];
        Global`TestBuildOutput["tex","spreadsheet"];
        Global`CppTeXTheFile["build_output.tex"];
        Global`ShowTeX["build_output.dvi"];
    ];

    (*  Currently this will call the Mma version of RegularOutput[]  *)
    If[option["nice-regular-output"],
       Apply[Global`RegularOutput,
          Join[{dummy4 (* davesAnswer *),fileName,Comments->comments,
               NCCPolynomials->collectedpolys, DroppedCount->DropCount,
               Time->{prelimstime,NCGB1time,RR1time,bigGBtime,RR2time,
                  reduceunknownstime,CleanUptime,SBtime,CCtime,nccvtime}},
               option["additionalRegOutOpt"]]];
    ];	

    (* MAURICIO - BEGIN *)
    (* Clear[doIt]; *)
    (* MAURICIO - END *)

    PRINTSTEP["Step 9: Create the threetuple for the answer"];

    (* Excess output *)
    If[option["slow"]
      ,ReportMemoryDiagnosics[8];
    ];

    (* Excess output *)
    If[option["slow"]
      ,Put[DownValues[dummy4],$GBDirectory<>"/dummy4"];
    ];

    (*  Notice that the first will be {} since it is a marker,
          the 2nd entry is rules,  and the 3rd entry is just 
          "result" since we're complementing rules *)
    result = {GBdigestedrules,
              Global`GetCategories["digestedRules",dummy4],
              Complement[result,Global`GetCategories["digestedRules",dummy4]]};
    (*
              Global`GetCategories["undigestedRules",dummy4]};
    *)

    (* MAURICIO - BEGIN *)
    (* NCPAns = dummy4; *)
    (* Memory management *)
    (* Mark, does this need to be cleared? *)
    (* Clear[dummy4]; *)
    (* MAURICIO - END *)

   PRINTSTEP["Step 10: Reset the user selects"];
    If[Not[RetrieveMarker[option["userselect"]]=={}] 
      , NCMakeGB[option["userselect"],0,UserSelect->option["userselect"]];
    ];
    AppendTo[trash,option["userselect"]];
    NCGBEmpty[trash];


    (* Excess output *)
    If[option["slow"]
      ,ReportMemoryDiagnosics[9];
    ];
    Clear[option];

    Print["Note: Your TeX and Dvi files are located in the directory ", Directory[]];

    Return[result];

  ];    (* end NCProcess[]  main *)

  NCProcess[x___] := BadCall["NCProcess",x];

End[];
EndPackage[];

(* MAURICIO - BEGIN *)
(* Stuff that does not belong here *)
(*

Get["NCMakeGBNag.m"];

Pull[ f_[x__ ]] := x;

Spreadsheet[x___]:= NCProcess[x];
SpreadSheet[x___]:=Spreadsheet[x];
*)
(* MAURICIO - END *)
