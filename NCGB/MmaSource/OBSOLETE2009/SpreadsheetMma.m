(* :Title:      SpreadsheetMma.m // Mathematica 2.2 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	MoraAlg` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage["MoraAlg`",
     "NCMonomial`","NonCommutativeMultiply`","Grabs`",
     "Global`","Errors`"];

Clear[Spreadsheet];

Spreadsheet::usage =
      "Spreadsheet[aListOfPolynomials,iterations,\"filename\",
       UserSelect->anotherListOfPolynomials,\
       Deselect->yetanotherListOfPolynomials];";

Clear[SpreadSheet];

SpreadSheet::usage =
      "SpreadSheet is an alias for Spreadsheet.";

Begin["`Private`"];

SpreadSheet[x___] := Spreadsheet[x];

(* Add more options !!! *) 
Options[Spreadsheet] := {Deselect->{},UserSelect->{},
                         RR->True,RRByCat->False, 
 			 SBByCat->False,SB->False,
 			 RRSB->False,RRSBByCat->False,
                         DegreeCap->-1,DegreeSumCap->-1,
 			 CPlusPlus->False};

(* Account for less parameters *)
Spreadsheet[aListOfPolynomials_List,iterations_Integer,
           fileName_String,opts___Rule] :=
   Spreadsheet[aListOfPolynomials,
               iterations,iterations+1,iterations,iterations+1,
               fileName,opts];

Spreadsheet[aListOfPolynomials_List,
           iterations_Integer,iterations2_Integer,
           fileName_String,opts___Rule] :=
    Spreadsheet[aListOfPolynomials,
               iterations,iterations2,iterations,iterations+1];

Spreadsheet[aListOfPolynomials_List,
           iterations_Integer,iterations2_Integer,iterations3_Integer,
           fileName_String,opts___Rule] :=
    Spreadsheet[aListOfPolynomials,
               iterations,iterations2,iterations3,iterations+1];

(* This is where the work is done. *)
Spreadsheet[aListOfPolynomials_List,
            iterations_Integer,iterations2_Integer,
            iterations3_Integer,iterations4_Integer,
           fileName_String,opts___Rule] :=
Module[{result,deselects,dummy1,dummy2,dummy3,dummy4,dig,GBdigested,
        GBall,rrdig,rr,rrk,userselects,khist,hist2,protected,i,numbers,
        vars,unknowns,hist,rroption,rrbycatoption,sbbycatoption,
        sboption,rrsboption,rrsbbycatoption,dorr,dorrbycat,
        degreecap1,degreecap2,degreesumcap1,degreesumcap2,
        degreecapsb,degreesumcapsb,ccode,slow,
        dosb,dosbbycat,inputForNCMakeGB,reorderOption},
   
  (* Check the validity of the options *)
  SpellCheckOptions[Spreadsheet,{opts}];

slow = False;

  (* We will use this on calls to NCMakeGB and SmallBasis *)
  reorderOption = ReorderInput->True;

  (* Set the options *)
  (* Are we using C++? *)
  ccode = CPlusPlus/.{opts}/.Options[Spreadsheet];
Print["ccode:",ccode];

  (* as is options *)
  deselects = Deselect/.{opts}/.Options[Spreadsheet];
  userselects = UserSelect/.{opts}/.Options[Spreadsheet];
 
  (* see "do" variables below *)
  rroption = RR/.{opts}/.Options[Spreadsheet];
  rrbycatoption = RRByCat/.{opts}/.Options[Spreadsheet];
  sbbycatoption = SBByCat/.{opts}/.Options[Spreadsheet];
  sboption = SB/.{opts}/.Options[Spreadsheet];
  rrsboption = RRSB/.{opts}/.Options[Spreadsheet];
  rrsbbycatoption = RRSBByCat/.{opts}/.Options[Spreadsheet];

  (* The degree cap options. *)
  degreecap1 = DegreeCap/.{opts}/.Options[Spreadsheet];
  degreesumcap1 = DegreeSumCap/.{opts}/.Options[Spreadsheet];
  degreecap2 = DegreeCap/.{opts}/.Options[Spreadsheet];
  degreesumcap2 = DegreeSumCap/.{opts}/.Options[Spreadsheet];

  (* Set the degree caps for SmallBasis *)
  If[degreecap1=-1
     ,degreecapsb=-1
     ,degreecapsb=degreecap1+1
  ];
  If[degreesumcap1=-1
     ,degreesumcapsb=-1
     ,degreesumcapsb=degreesumcap1+1
  ];

  (* Set flags corresponding to actions *)
  dorr = Or[rroption,rrsboption,rrsbbycatoption];
  dorrbycat = And[Not[dorr],rrbycatoption];
  dosb = Or[sboption,rrsboption];
  dosbbycat = And[Not[dosb],Or[sbbycatoption,rrsbbycatoption]];
Print["dorr:",dorr];
Print["dorrbycat:",dorrbycat];
Print["dosb:",dosb];
Print["dosbbycat:",dosbbycat];

  (* 1  Make the userselect things actually selected *)
  If[Length[userselects]>0
     , Print["Setting user selects STEP 1"];
       NCMakeGB[userselects,0,UserSelect->userselects];
  ];
 
  (* Excess output *)
  ReportMemoryDiagnosics[1];

STEP2 := (
     Print["STEP 2"];
     Global`CreateCategories[Union[aListOfPolynomials],dummy1];
If[slow,
     (* Excess output *)
     Put[DownValues[dummy1],Global`GBDirectory<>"/dummy1"];
     Global`RegularOutput[aListOfPolynomials,
                       Global`GBDirectory<>"/originalPolySpreadMXS"];
];
);

STEP3 := (
     (* 3  Get the input digested rules *)
     Print["STEP 3"];
     dig = Global`GetCategories["digestedRules",dummy1];
If[slow,
     (* Excess output *)
     Put[dig,Global`GBDirectory<>"/dig"];
];
     (* Memory management *)
     Clear[dummy1];
     ReportMemoryDiagnosics[1];
);


(* 2  Create categories from input list *)
If[ccode
   , (* C++ *)
     Print["C++ for steps 2 and 3 not implemented yet."];
     Print["Using the Mma way "];
     STEP2;
     STEP3;
   , (* Mma *)
     STEP2;
     STEP3;
];

STEP4 := (
  NCMakeGB[Union[dig,userselects],iterations2,
           Deselect->RuleToPol[deselects],
           ReturnRelations->False,
           UserSelect->userselects,
           DegreeCap->degreecap1,
           DegreeSumCap->degreesumcap1,
           reorderOption];
  GBdigested=WhatIsPartialGB[];
);


(* 4  Creating and sorting the GB for the digested relations *)
Print["STEP 4"];
If[ccode
  , (* C++ *)
    STEP4;
  , (* Mma *)
    STEP4;
];

STEP5 := (
    (* 5 Get history *)
    Print["STEP 5"];
    hist = WhatIsHistory[Global`WhatAreNumbers[]];
);

STEP7 :=  (
   (* 7  RemovingRedundent protecting knowns and digested *)
   Print["STEP 7"];
   rrdig = RemoveRedundent`RemoveRedundent[dummy2[{}],hist];
   rrdig = Union[rrdig,RemoveRedundent`RemoveRedundent[
                          GetCategories["Digested",dummy2],hist]
           ];
   rrdig = Union[rrdig,
                 RemoveRedundent`RemoveRedundent[GBdigested,hist]];
   (* Memory management *)
   Clear[dummy2];
);


If[ccode
  , (* C++ *)
    If[dorr
      , (* THEN *)
If[slow,
        (* Excess output *)
        Put[GBdigested,Global`GBDirectory<>"/inputOfRROnKnowns"];
];
        rrdig=Global`RemoveRedundentProtect[]; 
      , (* ELSE *)
        rrdig = GBdigested;
     ];

     If[dorr
      , (* Excess output *)
If[slow,
        ReportMemoryDiagnosics[2];
        Put[rrdig,Global`GBDirectory<>"/outputOfRROnKnowns"];
];
     ];
   , (* Mma *)
     If[dorr
      , (* THEN *)
        (* Excess output *)
If[slow,
        Put[GBdigested,Global`GBDirectory<>"/inputOfRROnKnowns"];
];
        rrdig=Global`RemoveRedundentProtect[]; 
      , (* ELSE *)
        rrdig = GBdigested;
     ];
];

STEP8 := (
  Print["STEP 8"];
  inputForNCMakeGB = RuleToPol[aListOfPolynomials];
  inputForNCMakeGB = ReduceAndRetainNonZero[inputForNCMakeGB];
  inputForNCMakeGB = Union[inputForNCMakeGB,dig];
);

(* 8  Set the input for the first NCMakeGB *) 
If[ccode
  , (* C++ *)
    STEP8;
  , (* Mma *)
    STEP8;
];
Print["INPUT IS:",inputForNCMakeGB]; 

STEP9 := (
  Print["STEP 9"];
  NCMakeGB[inputForNCMakeGB,iterations,
           Deselect->RuleToPol[GBdigested],
           UserSelect->userselects,
           ReturnRelations->False,
           SupressCOutput->True,
           DegreeCap->degreecap2,
           DegreeSumCap->degreesumcap2,
           reorderOption];
);

(* 9  Creates partial GB for everything *)
If[ccode 
  , (* C++ *)
    STEP9;
  , (* Mma *)
    STEP9;
];

STEP10 := (
  (* 10  Get kludge history to create categories *)
  Print["STEP 10"];
  khist = WhatIsKlugeHistory[Global`WhatAreNumbers[]];
);

STEP11 := (
  (* 11  Create categories for the GB for everything *)
  Print["STEP 11"];
  Global`CreateCategories[Map[(#[[2]])&,khist],dummy3];
);

STEP12 := (
  (* 12  Get the number of known in the GB of everything *)
  Print["STEP 12"];
  numbers = Table[If[MemberQ[dummy3[{}],khist[[i,2]]],khist[[i,1]],{}]
            ,{i,1,Length[khist]}];
  numbers = Flatten[numbers];

If[slow, 
  (* Excess output *)
  Put[DownValues[dummy3],Global`GBDirectory<>"/dummy3"];
  Put[dummy3[{}],Global`GBDirectory<>"/known_KRules"];
  Put[numbers,Global`GBDirectory<>"/known_Numbers"];
  Put[WhatIsPartialGB[numbers],Global`GBDirectory<>"/known_Rules"];
];
 
  (* Memory management *)
  Clear[dummy3];
);

STEP13 := (
(* 13  Remove redundant protecting knowns, unknowns and protected *)
Print["STEP 13"];
      rrk = RemoveRedundent`RemoveRedundent[numbers,khist,
              RemoveRedundent`RemoveRedundentUseNumbers->True];

If[slow, 
      (* Excess output *)
      Put[WhatIsPartialGB[rrk],Global`GBDirectory<>"/RR_known_Rules"];
];
 
      (* Prepare for future enhancement of protected *)
      protected = {};
      rr = Join[rrk,RemoveRedundent`RemoveRedundent[Global`WhatAreGBNumbers[],
                khist,
                RemoveRedundent`RemoveRedundentProtected->protected,
                RemoveRedundent`RemoveRedundentUseNumbers->True]];
 
       (* Memory management *)
       khist=.;
       rrk=.;
);

  If[dorr
    , (* THEN *)
      If[ccode
        , (* C++ *)
          STEP10;
          STEP11;
          STEP12;
          STEP13;
        , (* Mma *)
          rrpolys=Global`RemoveRedundentProtect[];
Print["rrpolys:",rrpolys];
      ];
    , (* ELSE *)
      rr = Global`WhatAreGBNumbers[];
      rrpolys = WhatIsPartialGB[UseMarker->True];
      Print["rrpolys:",rrpolys];
      rrpolys = returnMarkerList[rrpolys];
      rr =.;
  ];


 (* 
  If[dorrbycat
     ,Print["This is where we do RemoveRedundentByCategory"];
  ];
 *)

If[slow,
  (* Excess output *)
  ReportMemoryDiagnosics[3];
];

STEP14 := (
  (* 14 Grab the actual polynomials; so far we have only 
     identified them by number *)
  Print["STEP 14"];
(*
  If[Not[dorr]
   , rrpolys = Union[rrpolys,rrdig];
  ];
*)
  
  (* Memory management *)
  rrdig=.; 

If[slow,
  If[dorr
    , (* Excess output *)
      Put[rrpolys,Global`GBDirectory<>"/removeRedundent.result"];
  ];
];
);

STEP14;

STEP15 := (
(* 15  Use the knowns to reduce the unknowns *)
Print["STEP 15"];
  Global`CreateCategories[rrpolys,dummy5];
  knowns = dummy5[{}];
  result = Reduce`Reduction[rrpolys,knowns];
  result = Join[knowns,result];
  
  (* Memory management *)
  rrpolys=.; 
  Clear[dummy5];
);

STEP15;

STEP16 := (
(* 16  Clean up basis on above with user selects *)
Print["STEP 16"];
  result = NCMakeGB[Join[result,userselects],0,
                    UserSelect->userselects];
);

STEP16;

If[slow,
  (* Excess output *)
  Put[result,Global`GBDirectory<>"/billSreduction.result"];
  ReportMemoryDiagnosics[4];
];

STEP17 := (
(* 17  Do the SmallBasisByCategory. *)
      Print["STEP 17"];
      result = Global`SmallBasisByCategory[result,
                   iterations3,Global`KnownsIter->iterations4,
                   DegreeCap->degreecapsb,DegreeSumCap->degreesumcapsb];
If[slow,
      (* Excess output *)
      ReportMemoryDiagnosics[5];
      Put[result,Global`GBDirectory<>"/smallBasisByCategory.result"];
      ReportMemoryDiagnosics[6];
];
);

If[dosbbycat
   ,STEP17;
];

If[dosb
  , Print["sb is not available"];
];

STEP18 := (
(* 18  Write the file *)
Print["STEP 18"];
(*
  Global`RegularOutput[result,fileName,"C++"];
*)
  Global`RegularOutput[result,fileName];
);

STEP18;

STEP19 := (
  (* 19  Put together the answer!!! *)
  Print["STEP 19"];

  (* Excess output *)
  ReportMemoryDiagnosics[7];

  (* Sort the output of small basis by category *)
  Global`CreateCategories[result,dummy4];

If[slow,
  (* Excess output *)
  Put[DownValues[dummy4],Global`GBDirectory<>"/dummy4"];
];

  result = {GBdigested,
            Global`GetCategories["digestedRules",dummy4],
            Global`GetCategories["undigestedRules",dummy4]};

  (* Memory management *)
  Clear[dummy4];
);

STEP19;

STEP20 := (
(* 20  Reset user selects as chosen *)
Print["STEP 20"];
  If[Length[userselects]>0 
    , NCMakeGB[userselects,0,UserSelect->userselects];
  ];

If[slow, 
  (* Excess output *)
  ReportMemoryDiagnosics[8];
];

  (* The output !!! *)
);

STEP20;

  Return[result];
];

Spreadsheet[x___] := BadCall["Spreadsheet",x];

End[];
EndPackage[]
