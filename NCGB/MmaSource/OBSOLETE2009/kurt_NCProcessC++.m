Spreadsheet[x___]:=NCProcess[x];
SpreadSheet[x___]:=Spreadsheet[x];

Clear[UseOptions];

UseOptions[opts_List,opt_Symbol]:=
Module[{userselect},
  opt["deselects"] = Deselect/.opts/.Options[NCProcess];
  userselect = UserSelect/.opts/.Options[NCProcess];
  If[Head[userselect]===List
    ,opt["userselect"]=sendMarkerList["polynomials",RuleToPol[userselect]]
    ,opt["userselect"]=CopyMarker[userselect,"polynomials"]
  ];
  opt["rroption"] = RR/.opts/.Options[NCProcess];
  opt["nccv"] = NCCV/.opts/.Options[NCProcess];
  opt["rrbycatoption"] = RRByCat/.opts/.Options[NCProcess];
  opt["sbbycatoption"] = SBByCat/.opts/.Options[NCProcess];
  opt["sboption"] = SB/.opts/.Options[NCProcess];
  opt["rrsboption"] = RRSB/.opts/.Options[NCProcess];
  opt["rrsbbycatoption"] = RRSBByCat/.opts/.Options[NCProcess];
  opt["degreecap"] = DegreeCap/.opts/.Options[NCProcess];
  opt["degreesumcap"] = DegreeSumCap/.opts/.Options[NCProcess];

  opt["dorr"] = And[Not[opt["rrbycatoption"]],
        Or[opt["rroption"],opt["rrsboption"],opt["rrsbbycatoption"]]];
  opt["dorrbycat"] = opt["rrbycatoption"];
  opt["dosb"] = Or[opt["sboption"],opt["rrsboption"]];
  opt["dosbbycat"] = And[Not[opt["dosb"]],
                   Or[opt["sbbycatoption"],opt["rrsbbycatoption"]]];

  opt["slow"] = NCGBDebug/.opts/.Options[NCProcess];
  If[Not[FreeQ[opts,Slow]]
    , Print["Please use the option NCGBDebug next time."];
      opt["slow"] = Slow/.opts/.Options[NCProcess];
  ];

  If[opt["degreecap"]==-1
       ,opt["degreecapsb"]=-1
       ,opt["degreecapsb"]=opt["degreecap"]+1
    ];
  If[opt["degreesumcap"]==-1
       ,opt["degreesumcapsb"]=-1
       ,opt["degreesumcapsb"]=opt["degreesumcap"]+1
    ];

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
  Return[];
];

Clear[Empty];

Empty[markers_List]:=
Module[{i},
   Do[DestroyMarker[markers[[i]]];
   ,{i,Length[markers]}];
   Return[{}];
];

Clear[NCProcess];

NCProcess::usage =
      "NCProcess[aListOfPolys or aMarkerOfPolys,iterations,'filename',
       UserSelect->anotherListOfPolys or anotherMarkerOfPolys,
       Deselect->yetanotherListOfPolynomials];";

(* Add more options !!! *) 
Options[NCProcess] := {Deselect->{},UserSelect->{},
                         RR->True,RRByCat->False, 
 			 SBByCat->False,SB->False,
 			 RRSB->False,RRSBByCat->False,
                         DegreeCap->-1,DegreeSumCap->-1,
                         NCGBDebug->False,
                         Slow->False,NCCV->True};

(* Account for less parameters *)
NCProcess[polys:(_List|_Global`GBMarker),iterations_Integer,
           fileName_String,opts___Rule] :=
   NCProcess[polys,
               iterations,iterations+1,iterations+1,iterations+2,
               fileName,opts];

NCProcess[polys:(_List|_Global`GBMarker),
           iterations_Integer,iterations2_Integer,
           fileName_String,opts___Rule] :=
    NCProcess[polys,
               iterations,iterations2,iterations+1,iterations+2];

NCProcess[polys:(_List|_Global`GBMarker),
           iterations_Integer,iterations2_Integer,iterations3_Integer,
           fileName_String,opts___Rule] :=
    NCProcess[polys,
               iterations,iterations2,iterations3,iterations3+1];

(* This is where the work is done. *)
NCProcess[polys:(_List|_Global`GBMarker),
            iterations_Integer,iterations2_Integer,
            iterations3_Integer,iterations4_Integer,
           fileName_String,opts___Rule] :=
Module[{result,result1,result2,result3,dummy4,dig,GBdigested,rrdig,rr,
        option,trash,rrbc,rrbcmarker,
        inputForNCMakeGB,gbnums,fc,ints,fc2,bigGB,fc3,gbnums2,
        rrdigpoly,digpolys,startpolys,collectedpolys,
        rr2,rrpolys,rr2numbers,rr2knownrules,knowns},
   
  (* Check the validity of the options *)
  SpellCheckOptions[NCProcess,{opts}];

  UseOptions[{opts},option];

  trash={};
  (* trash is a list containing all of the markers *)
  (* they will destroyed by the function call Empty[trash]; *)

  If[Head[polys]===List
    ,start=sendMarkerList["polynomials",RuleToPol[polys]]
    ,start=CopyMarker[polys,"polynomials"]
  ];
  AppendTo[trash,start];
  Print["Step 0: Set user selects"];
  NCMakeGB[RetrieveMarker[start],0,UserSelect->option["userselect"],
                           ReturnRelations->False];
  fc=SaveFactControl[];
  ints=WhatAreGBNumbersMarker[fc];
  dig=DigestedRelations[fc,ints];
  (* dig is a marker for the digested rules *)
  digpolys=CopyMarker[dig,"polynomials"];
  startpolys=UnionMarkers[digpolys,option["userselect"]];
  
  trash=Join[trash,{fc,ints,dig,digpolys,startpolys}];

  Print["Step 1: Do NCMakeGB on digested relations only"];

  GBdigested=Apply[NCMakeGB,Join[{RetrieveMarker[startpolys],iterations2},option["NCMakeGB1"]]];
  GBrulesmarker=CopyMarker[GBdigested,"rules"];
  Print["About to do an acceptable return of rules to Mma"];
  GBdigestedrules=RetrieveMarker[GBrulesmarker];
    (* GBdigestedrules is the first element of the threetuple *)
  trash=Join[trash,{GBdigested,GBrulesmarker}];

  If[option["dorr"] 
    ,(* THEN *)
     Print["Step 2: RemoveRedundent on partial GB of digested"];
     If[option["slow"]
       ,(* Excess output *)
        ReportMemoryDiagnosics[1];
        Put[RetrieveMarker[GBdigested],
                        Global`GBDirectory<>"/inputOfRROnKnowns"];
     ];

     fc2 = SaveFactControl[];
     Print["fc2:",fc2];
     gbnums=WhatAreGBNumbersMarker[fc2];
     rrdig=Global`RemoveRedundentProtect[fc2,gbnums]; 
     trash=Join[trash,{fc2,gbnums}];
    ,(* ELSE *)
     rrdig = CopyMarker[GBdigested,"rules"];
  ];
  (* rrdig is a marker of rules for whatever is left of the first NCMakeGB *)
  AppendTo[trash,rrdig];

  If[And[option["dorr"],option["slow"]]
    ,(* Excess output *)
     ReportMemoryDiagnosics[2];
     Put[RetrieveMarker[rrdig],Global`GBDirectory<>"/outputOfRROnKnowns"];
  ];
  rrdigpoly = CopyMarker[rrdig,"polynomials"];
  Print["rrdigpoly:",rrdigpoly];
  AppendTo[trash,rrdigpoly];
  inputForNCMakeGB = UnionMarkers[start,rrdigpoly];
  Print["inputForNCMakeGB:",inputForNCMakeGB];
  AppendTo[trash,inputForNCMakeGB];
  If[option["slow"]
    ,(* THEN *)
     Print["Input for step 3 NCMakeGB is:",RetrieveMarker[inputForNCMakeGB]];
    ,(* ELSE *)
     Print["Step 3: NCMakeGB on everything"];
  ];
  Print["About to retrieve user selects"];
  bigGB=Apply[NCMakeGB,Join[{RetrieveMarker[inputForNCMakeGB],iterations,
              Deselect->RetrieveMarker[GBdigested]},
              option["NCMakeGB2"]]];
  Print["bigGB:",bigGB];
  trash=Empty[trash];
  fc3 = SaveFactControl[];
  trash=Join[trash,{fc3,bigGB}];

  If[option["dorr"] 
    ,(* THEN *)
     Print["Step 4: RemoveRedundent on everything"];
     If[option["slow"]
       ,(* Excess output *)
        ReportMemoryDiagnosics[3];
        Put[RetrieveMarker[bigGB],
                        Global`GBDirectory<>"/inputOfRR"];
     ];

     Print["fc3:",fc3];
     gbnums2=WhatAreGBNumbersMarker[fc3];
     Print["gbnums2:",gbnums2];
     rr2=Global`RemoveRedundentProtect[fc3,gbnums2]; 
     Print["rr2:",rr2];
     trash=Join[trash,{gbnums2}];
    ,(* ELSE *)
     rr2 = CopyMarker[bigGB,"rules"];
     fc3 = SaveFactControl[];
     trash=Join[trash,{fc3}];
  ];

  If[And[option["dorr"],option["slow"]]
    ,(* Excess output *)
     ReportMemoryDiagnosics[4];
     Put[RetrieveMarker[rr2],Global`GBDirectory<>"/outputOfRR"];
  ];

  If[option["dorrbycat"]
     ,Print["Step 4: RemoveRedundentByCatagory on everything"];
     rrbc=RemoveRedundentByCategory[];
(*RetrieveMarker[bigGB],RetrieveMarker[fc3]];*)
     rrbcmarker=sendMarkerList["polynomials",rrbc];
     AppendTo[trash,rrbcmarker];
     rr2=CopyMarker[rrbcmarker,"rules"];
  ];
  (* rr2 is a marker of rules for whatever is left of the second NCMakeGB *)
  AppendTo[trash,rr2];

  Print["Step 5: Use the knowns to reduce the unknowns"];
  rrpolys=CopyMarker[rr2,"polynomials"];
  rr2numbers=NumbersFromRuleMarker[fc3,rr2];
Print["rr2numbers :",rr2numbers];
  rr2knownrules=knownRelations[fc3,rr2numbers];
Print["rr2knownrules :",rr2knownrules];
  rr2knownpolys=CopyMarker[rr2knownrules,"polynomials"];
Print["rr2knownpolys :",rr2knownpolys];
  result1 = Reduce`internalReduction[rrpolys,rr2knownrules];
  result2 = UnionMarkers[rr2knownpolys,result1];
  
  trash=Join[trash,{rr2numbers,rr2knownrules,rr2knownpolys,rrpolys,result1}];

  trash=Empty[trash];
  trash={result2};

  Print["Step 6: Clean up basis"];
  input=UnionMarkers[result2,option["userselect"]];
  result3 = NCMakeGB[input,0,UserSelect->option["userselect"],UseMarker->True];

  trash=Join[trash,{input,result3}];

  (* Excess output *)
  If[option["slow"]
    ,Put[RetieveMarker[result3],Global`GBDirectory<>"/billSreduction.result"];
     ReportMemoryDiagnosics[5];
  ];

(****************************************************)
  result=RetrieveMarker[result3];
  If[option["dosbbycat"]
    ,Print["Step 7: SmallBasisByCategory"];
     result = Apply[Global`SmallBasisByCategory,Join[{result,
                   iterations3,Global`KnownsIter->iterations4},
                   option["SmallBasisByCat"]]];

     (* Excess output *)
     If[option["slow"]
       ,ReportMemoryDiagnosics[6];
        Put[result,Global`GBDirectory<>"/SmallBasisByCategory.result"];
        ReportMemoryDiagnosics[7];
     ];
  ];

  If[option["dosb"]
    ,Print["Step 7: SmallBasis"];
     result = Global`SmallBasis[result,{},iterations3];

     (* Excess output *)
     If[option["slow"]
       ,ReportMemoryDiagnosics[6];
        Put[result,Global`GBDirectory<>"/SmallBasis.result"];
        ReportMemoryDiagnosics[7];
     ];
  ];

Print["result 2: ",result];
  Print["Step 8: Write the file"];
(*
  Global`RegularOutput[result,fileName,"C++"];
*)
  If[option["nccv"]
    ,collectedpolys=NCCollectOnVariables[result];
    ,collectedpolys={}
  ];
  Global`RegularOutput[result,fileName,
              FontSize->small,NCCPolynomials->collectedpolys];

  Print["Step 9: Create the threetuple for the answer"];

  (* Excess output *)
  If[option["slow"]
    ,ReportMemoryDiagnosics[8];
  ];

  (* Sort the output of small basis by category *)
  Global`CreateCategories[result,dummy4];

  (* Excess output *)
  If[option["slow"]
    ,Put[DownValues[dummy4],Global`GBDirectory<>"/dummy4"];
  ];

  result = {GBdigestedrules,
            Global`GetCategories["digestedRules",dummy4],
            Global`GetCategories["undigestedRules",dummy4]};

  (* Memory management *)
  Clear[dummy4];

  Print["Step 10: Reset the user selects"];
  If[Not[RetrieveMarker[option["userselect"]]=={}] 
    , NCMakeGB[option["userselect"],0,UserSelect->option["userselect"]];
  ];
  AppendTo[trash,option["userselect"]];
  Empty[trash];
 
  (* Excess output *)
  If[option["slow"]
    ,ReportMemoryDiagnosics[9];
  ];

  Return[result];

];

NCProcess[x___] := BadCall["NCProcess",x];


