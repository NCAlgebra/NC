(* TEMPORARY *)

Clear[StartExperiment];

StartExperiment::usage =
     "StartExperiment";

Clear[ContinueExperiment];

ContinueExperiment::usage =
     "ContinueExperiment";

Clear[PauseExperiment];

PauseExperiment::usage =
     "PauseExperiment";

Clear[EndExperiment];

EndExperiment::usage =
     "EndExperiment";

Clear[CreateATranscript];

CreateATranscript::usage =
     "CreateATranscript";


Clear[RecordUserCommand];

RecordUserCommand::usage =
     "RecordUserCommand";

Clear[RecordProgramResponse];

RecordProgramResponse::usage =
     "RecordProgramResponse";

StartExperiment[] := StartExperiment[ToString[Unique["experiment"]]];

StartExperiment[str_String] :=
Module[{flag},
  $GB$ExperimentName = str;
  $GB$Recording = True;
  $GB$Counter = 1;
  Off[FileDate::nffil];
  flag = FileDate[str]===$Failed;
  On[FileDate::nffil];
  If[Not[flag]
    , Print["The directory ",str," already exists."];
      Print["The code will now abort."];
      Abort[];
    , Run["mkdir "<> str];
  ];
];

ContinueExperiment[] :=
Module[{},
    $GB$Recording = True;
];

PauseExperiment[] :=
Module[{},
    $GB$Recording = False;
];

EndExperiment[] := 
Module[{},
  $GB$Recording = False;
  $GB$Counter = 0;
];

RecordUserCommand[str_] :=
Module[{channel},
  If[$GB$Recording
      , 
(*
         channel = OpenWrite[$GB$ExperimentName<>
                              "/UserCommand"<>
                              ToString[$GB$Counter]];
Print[channel];
        WriteString[str<>"\n",channel];
*)
        Put[str,$GB$ExperimentName<>
                "/UserCommand"<>
                ToString[$GB$Counter]];
        $GB$Counter = $GB$Counter + 1;
      , (* Do nothing *)
      , Print["$GB$Recording has the value ",$GB$Recording,
              " which is neither 'True' nor 'False'."];
  ];
];

RecordProgramResponse[expr_] :=
Module[{channel},
  If[$GB$Recording
      , Put[expr,$GB$ExperimentName<>"/ProgramResponse"<>ToString[$GB$Counter]];
        $GB$Counter = $GB$Counter + 1;
      , (* Do nothing *)
      , Print["$GB$Recording has the value ",$GB$Recording,
              " which is neither 'True' nor 'False'."];
  ];
];

CreateATranscript[] := CreateATranscript[$GB$ExperimentName];

CreateATranscript[str_String] :=
Module[{shouldLoop,i},
   shouldLoop = True;
   i = 1;
   While[shouldLoop
      , (* Is there a User command file corresponding to i *)
        Off[FileDate::nffil];
        shouldLoop = Not[FileDate[
                           $GB$ExperimentName<>"/UserCommand"<>ToString[i]
                                 ]===$Failed];
        On[FileDate::nffil];
        If[shouldLoop
           , Print["THE USER TYPED"];
             Run["cat "<>$GB$ExperimentName<>"/UserCommand"<>ToString[i]];
        ];
        If[Not[shouldLoop]
           ,  Off[FileDate::nffil];
              shouldLoop = Not[FileDate[
                           $GB$ExperimentName<>"/ProgramResponse"<>ToString[i]
                                      ]===$Failed];
              On[FileDate::nffil];
              If[shouldLoop
                , Print["THE PROGRAM GAVE"];
                  Run["cat "<>
                        $GB$ExperimentName<>"/ProgramResponse"<>ToString[i]
                      ];
              ];
        ];
        Print[""];
       i = i + 1;
   ];
];
