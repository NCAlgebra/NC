
$NCGB$CurrentSession=Null;
Clear[StartNCGBSession];
Clear[ReStartNCGBSession];
Clear[CloseNCGBSession];
Clear[AddFileToNCGBSession];
Clear[AddCommandToNCGBSession];
Clear[AddEntryToNCGBSession];
Clear[TeXNCGBSession];
(* Private *)
Clear[TeXEntryNCGBSession];
(* Private *)
Clear[AddEntryToNCGBSession]; 

StartNCGBSession::usage = "StartNCGBSession";
ReStartNCGBSession::usage = "ReStartNCGBSession";
CloseNCGBSession::usage = "CloseNCGBSession";
AddFileToNCGBSession::usage = "AddFileToNCGBSession";
AddCommandToNCGBSession::usage = "AddCommandToNCGBSession";
TeXNCGBSession::usage = "TeXNCGBSession";

StartNCGBSession[] := 
Module[{},
  If[$NCGB$CurrentSession===Null
    , $NCGB$CurrentSession = Unique["NCGBSession"];
      $NCGB$CurrentSession["number"] = 0;
      AddEntryToNCGBSession[NCGBComment[StringJoin["Start",ToString[Date[]]]]];
    , Print["You must close all previous NCGBSessions before starting one."];
  ];
];

ReStartNCGBSession[s_Symbol] := 
Module[{},
  If[$NCGB$CurrentSession===Null
    , $NCGB$CurrentSession = s;
      AddEntryToNCGBSession[NCGBComment[StringJoin["ReStart",ToString[Date[]]]]];
    , Print["You must close all previous NCGBSessions before restarting one."];
  ];
];

CloseNCGBSession[] := 
Module[{x},
  AddEntryToNCGBSession[NCGBComment[StringJoin["Close",ToString[Date[]]]]];
  x = $NCGB$CurrentSession;
  $NCGB$CurrentSession = Null;
  Return[x];
];

AddFileToNCGBSession[x_String] := 
Module[{},
  AddEntryToNCGBSession[NCGBFile[x]];
  Get[x];
];

AddCommandToNCGBSession[x_String] := 
Module[{out},
  out = ToExpression[x];
  AddEntryToNCGBSession[{NCGBCommand[x],ToString[Format[out,InputForm]]}];
  Return[out];
];

AddEntryToNCGBSession[x_] := 
  (
    If[$NCGB$CurrentSession===Null
      , Print["No NCGB session is open."];
      ,	$NCGB$CurrentSession["number"] = $NCGB$CurrentSession["number"] + 1;
        $NCGB$CurrentSession[$NCGB$CurrentSession["number"]]= x;
    ];
  );

TeXNCGBSession[x_Symbol,fileName_String] := 
Module[{i},
  WriteString[fileName,"\\documentclass{article}\n"];
  WriteString[fileName,"\\begin{document}\n"];
  n = x["number"];
  Do[ TeXEntryNCGBSession[x[i],fileName];
  ,{i,1,n}];
  WriteString[fileName,"\\end{document}\n"];
  WriteString[fileName,"\\end\n"];
];

TeXEntryNCGBSession[NCGBComment[x_String],fileName_String] := 
Module[{},
  WriteString[fileName,"%  Comment:",x,"\n"];
];

TeXEntryNCGBSession[NCGBFile[x_String],fileName_String] :=
Module[{L},
  Print ["x:",x];
  L = ReadFile[x,String];
  Print["L:",L];
  WriteString[fileName,"\\begin{verbatim}\n"];
  Map[WriteString[fileName,#]&,L];
  WriteString[fileName,"\\end{verbatim}\n"];
];

TeXEntryNCGBSession[{NCGBCommand[x_String],y_String},fileName_String] :=
Module[{},
  WriteString[fileName,x,"\n\n \centerline{gives} \n\n ",y,"\n\n"];
];
