(* :Title: 	NCTest *)

(* :Author: 	mauricio *)

(* :Context: 	NCTest` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCTest`" ];

Clear[NCTest, 
      NCTestCheck,
      NCTestRun, 
      NCTestSummarize];
      
Get["NCTest.usage"];

Begin[ "`Private`" ]

  NCTestResults = Association[];
  NCTestCounter = 0;

  NCTestCheck[expr_, messages_] := Block[
    {result,pass},
    pass = False;
    Quiet[
      Check[ result = Evaluate[expr];
            ,
             pass = True;
            ,
             messages
      ];
     ,
      messages
    ];
    NCTest[pass, True];
  ];
  
  NCTestCheck[expr_, answer_, messages_] := Block[
    {result,pass},
    pass = False;
    Quiet[
      Check[ result = Evaluate[expr];
            ,
             pass = True;
            ,
             messages
      ];
     ,
      messages
    ];
    NCTest[pass, True];
    NCTest[result, answer];
  ];

  NCTestCheck[expr_, answer_, checkMessages_, quietMessages_] := Block[
    {result,pass},
    pass = False;
    Quiet[
      Check[ result = Evaluate[expr];
            ,
             pass = True;
            ,
             checkMessages
      ];
     ,
      quietMessages
    ];
    NCTest[pass, True];
    NCTest[result, answer];
  ];

  SetAttributes[NCTestCheck, HoldAll];

  NCTest[result_, answer_:True] := Block[
    {pass},
    NCTestCounter ++;
    pass = (result === answer);
    Sow[pass];
    If[!pass, 
      Print["\n* Test #" <> 
            ToString[NCTestCounter] <> 
            " failed. Result:"];
      Print["    ", ToString[result] ];
      Print["  differs from correct answer:" ];
      Print["    ", ToString[answer] ];
    ];
  ];

  (* NCRunTest is private *)
  NCRunTest[Null] := Null;

  NCRunTest[file_] := Block[
    {keys, results, fail, t}, 
    NCTestCounter = 0;
    WriteString["stdout", "\n> '" <> file <> "'...\n* "];
    {t, results} = Reap[Timing[Get[file <> ".NCTest"]][[1]]];
    NCTestResults = 
      Append[NCTestResults, 
             MapThread[({file, #1} -> #2)&, 
                       {Range[1,Length[results[[1]]]], 
                        results[[1]]} ]];
    keys = Select[Keys[NCTestResults], (#[[1]] == file)&];
    results = Map[NCTestResults[#]&, keys];
    fail = Length[Select[# =!= True &][results]];
    WriteString["stdout",
      ToString[Length[keys]] <> 
      " tests completed in " <> 
      ToString[Round[1000*t]/1000.] <> 
      " seconds.\n* " <>
      ToString[Length[keys] - fail] <>
      " succeeded.\n* " <>
      ToString[fail] <> " failed.\n"
    ];
    Return[{file, Length[keys], fail, t}];
  ];
  
  (* NCTestRun is public *)
  NCTestRun[tests_List] := Map[NCRunTest, tests];

  NCTestSummarize[Results_] := Block[
    {nbrOfFiles, nbrOfTests, totalFail, totalTime},

    (* Remove Null's *)
    results = DeleteCases[Results, Null];

    nbrOfFiles = Length[results];
    nbrOfTests = Total[results[[All,2]]];
    totalFail = Total[results[[All,3]]];
    totalTime = Total[results[[All,4]]];

    WriteString["stdout", 
                "\n\n> SUMMARY OF TESTS\n\n" <>
                "* " <> ToString[nbrOfFiles] <> 
                        " files tested.\n" <>
                "* " <> ToString[nbrOfTests] <>
                        " tests completed in " <> 
                        ToString[totalTime] <> " seconds.\n" <>
                "* " <> ToString[nbrOfTests - totalFail] <> " succeeded.\n" <>
                "* " <> ToString[totalFail] <> " failed.\n"];
  ];

End[]

EndPackage[]
