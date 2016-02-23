(* mauricio jan 2009 
 * Problem 32 and Problem 48 fail on the current NCGB 4.0 version
 * probalbly because of some functionality that is outdated or obsolete
 *)

(* this copy is for the dugout/C++ code for C test files *)

(* << Time.m; *)

$SuperLoop$Path1$ := StringJoin[$NCDir$,"NCGB/Testing/C++TestResults/test."];
$SuperLoop$Path2$ := StringJoin[$NCDir$,"NCGB/Testing/MmaTestFiles/test."];

Clear[Compare];
Clear[superloop];
Clear[GBTest];
Clear[TimedGBTest];
Clear[GBtest];
Clear[DemoCompareFiles];   
Clear[DemoTest]; 
Clear[CategoryTest]; 

Compare[i_?NumberQ]:= 
Module[{check,hi1,hi2,comp1,comp2,answer},
   hi1 =  Get[StringJoin[$SuperLoop$Path1$,ToString[i],".ans"]];
   hi2 =  Get[StringJoin[$SuperLoop$Path2$,ToString[i],".answer"]];
   hi1 = hi1/.Rule->Subtract;
   hi2 = hi2/.Rule->Subtract;
   comp1 = Complement[hi1,Join[hi2,-hi2]];
   comp2 = Complement[hi2,Join[hi1,-hi1]];
If[Or[comp1=!={},comp2=!={}]
  , Print["comp1:",comp1];
    Print["CE[comp1]:",CE[comp1]];
    Print["comp2:",comp2];
    Print["CE[comp2]:",CE[comp2]];
];
(*
   answer = (comp1===comp2);
*)
   answer = (comp1==comp2);
   Return[answer];
];

GetClearAlphabet[] := Get["NCGBClearAlphabet.m"];

superloop[m_,n_] :=
Module[{j,str},
  GetClearAlphabet[];
  Do[ Start[];
      MoraAlg`ClearMonomialOrderAll[];
      Get[StringJoin["test.",ToString[j]]];
      str = Finish[];
      ans = PolynomialsToGBRules[ans];
      Put[ans,StringJoin[$SuperLoop$Path1$,ToString[j],".ans"]];
      Put[str,StringJoin[$SuperLoop$Path1$,ToString[j],".time"]];
      Put[MemoryInUse[],StringJoin[$SuperLoop$Path1$,ToString[j],".mmaM"]];
(*
      Put[CPlusPlusMemoryUsage[],
          StringJoin[$SuperLoop$Path1$,ToString[j],".c++M"]];
*)
(* SetGlobalPtr[];*)
    ,{j,m,n}];
];

GBTest[numbegin_?NumberQ,numend_?NumberQ]:=
Module[{j,oldSubMatch},
(* Commented out by Mark Stankus 9/15/04 
   oldSubMatch = NCGBGetVariablesValues[{NCGBUseSubMatch}][[1]];
   NCGBSetVariablesValues[{NCGBUseSubMatch->True}];
*)
   Do[ superloop[j,j];
       GBtest[j] = Compare[j];
   ,{j,numbegin,numend}];   
   Print["RESULTS::::"];
   Do[ Print["GBtest[",j,"] = ",GBtest[j],
             "  (oldtime=","??",
             " newtime=",
             Get[StringJoin[$SuperLoop$Path1$,ToString[j],".time"]],
             " mmaM:",Get[StringJoin[$SuperLoop$Path1$,ToString[j],".mmaM"]],
(*
             " C++M:",Get[StringJoin[$SuperLoop$Path1$,ToString[j],".c++M"]],
*)
             ")"];
   ,{j,numbegin,numend}];   
(* Commented out by Mark Stankus 9/15/04 
   NCGBSetVariablesValues[{NCGBUseSubMatch->oldSubMatch}];
*)
];

TimedGBTest[numbegin_?NumberQ,numend_?NumberQ] :=
Module[{start,end},
   start = Date[];
   GBTest[numbegin,numend];
   end = Date[];
   Print[ElapsedTime[start,end]];
];

DemoCompareFiles[n_?NumberQ]:=
Module[{files,nowDir,aresame,tester,temp1,temp2},
   files = $NCNotebookVars;
   tester = {};
Print["files ",files];
   Do[ temp1 = Get[StringJoin["Demo",ToString[n],
                              "/this_time/",files[[j]]]];
       temp2 = Get[StringJoin["Demo",ToString[n],
                              "/last_time/",files[[j]]]];
       If[ (Head[temp1]===List)&&(Head[temp2]===List)
           ,aresame = (temp1 === temp2);
            Print[files[[j]]," : ",aresame];
            tester = Append[tester,aresame]; 
            Print[""];
           ,If[ Not[Head[temp1]===List]
                ,Print[files[[j]]," in /Demo",ToString[n],
                       "/this_time/ does not contain a list"];
                 Print[""];
            ];
            If[ Not[Head[temp2]===List]
                ,Print[files[[j]]," in /Demo",ToString[n],
                       "/last_time/ does not contain a list"];
                 Print[""];
            ];
       ];
   ,{j,1,Length[files]}];
   Print["tester :", tester];
   If[Length[tester] > 0
      ,If[Complement[tester,{True}] === {}
          ,Print[""];
           Print["Result::  Test OK"];
          ,Print[""];
           Print["Result::  No Good!!"];
       ];(* if*)
      ,Print["There are no files that contain a list"];
   ]; (* if*)
]; (* ProdTest*)

DemoTest[n_?NumberQ]:=
Module[{},
   Get[StringJoin["Demo",ToString[n],".m"]];
   DemoCompareFiles[n];
];

DemoTest[n_,n_] := DemoTest[n];

DemoTest[n_,m_] :=
Module[{},
  Print["Only run one demo file at a time!!"];
];

CategoryTest[m_,n_] :=
Module[{j},
Do[SetCleanUpBasis[1];
  ClearMonomialOrderAll[];
  Get[StringJoin["test.",ToString[j]]];
  Print["About to do category creation, test."<>ToString[j]];
  Run["date"];
  RegularOutput[ans,"test_category_output_"<>ToString[j],"C++"];
  Run["date"]
  ,{j,m,n}]
]
