Get["NCDoTeX.m"];
Get["Extra.TeXForm"];

BeginPackage["TexUtilities`","TeXStuff`","Errors`"];

Clear[SeeTeX];

SeeTeX::usage = 
     "SeeTeX[N] starts the creation of TeX files and \
      displays them. If N=0, then the TeX files are not\
      created. If N>0, then the files are TeXed and displayed.\
      If the user has not used SeeTeX in the session up\
      to this point, then SeeTeX[] is the same as SeeTeX[5].\
      If the user has used SeeTeX in this session, then\
      the user can use SeeTeX[] to restart the creation of TeX\
      files (see NoTeX) and this does not reset the number of windows.";

Clear[NoTeX];

NoTeX::usage = 
    "NoTeX[] (temporarily) stops the creation of TeX files. See SeeTeX.";

Clear[KillTeX];

KillTeX::usage = "KillTeX[] removes all of the TeX files
    created via SeeTeX. See SeeTeX";

Clear[SaveTeX];

SaveTeX::usage = 
    "SaveTeX[\"directoryName\"] creates a directory with\
     the name directoryName and copies the TeX files into it.";

Clear[See];

See::usage =
   "See[aList] creates a TeX file which has multiple equations in\
    it. More documentation needed here.";

Clear[Keep];

Keep::usage =
   "Keep[aNumber] indicates the TeX display corresponding\
    to Out[aNumber] should not be automatically removed.\
    See SeeTeX.";

Clear[Kill];

Kill::usage = 
   "Kill[aNumber] removes the window corresponding to Out[aNumber]";

Clear[SetDvi];

SetDvi::usage = "SetDvi[callingSequence]";

Begin["`Private`"];

Clear[DviIt];

SetDvi[x_] := xdviString = x;

SetDvi["xdvi -keep -topmargin 5cm -geometry 1000x200 "];

DviIt[fileName_] := 
  Run[xdviString<>" "<>fileName<>" & "];

Clear[KillWindow];
Clear[KillDvi];
Clear[KillLogAndAux];
Clear[TeXTheFile];

TeXRecording = False;
TeXFirstTime = True;
directoryName = "TeXSession";
MaxDviOnScreen = 1;
DviOnScreen = {};

SeeTeX[] := 
Module[{},
   If[TeXFirstTime, DviOnScreen = {};
                    SeeTeX[5];
                    TeXFirstTime = False;
                  , TeXRecording = True;
                    $Post = DoForPost;
   ];
];

SeeTeX[N_?IntegerQ] := 
   ($Post = DoForPost;
    If[FileInformation[directoryName]==={}
      , CreateDirectory[directoryName];
    ];
    TeXRecording = True;
    MaxDviOnScreen = N;
   );

SeeTeX[x___] := BadCall["SeeTeX",x];

NoTeX[] := (TeXRecording = False;Clear[$Post];);

NoTeX[x___] := BadCall["NoTeX",x];

KillTeX[] :=
Module[{},
  If[MemberQ[FileNames[],directoryName]
    , DeleteDirectory[directoryName,DeleteContents->True];
  ];
  CreateDirectory[directoryName];
];

KillTeX[x___] := BadCall["KillTeX",x];

SaveTeX[file_String] :=
  ( CreateDirectory[file];
    Run["cp -R " <> directoryName<>" "<>file<>"/"];
  );

SaveTeX[x___] := BadCall["SaveTeX",x];

See[aList:{___?IntegerQ}]:= 
    If[TeXRecording
      , SeeAListOfOutputs[aList];
      , BadCall["See",x];
    ];

See[x___]:= BadCall["See",x];
 
Keep[aNumber_?IntegerQ] :=
Module[{aList},
  If[TeXRecording
   , aList = Flatten[Position[DviOnScreen,aNumber]];
     If[Length[aList]===1
       , DviOnScreen = Delete[DviOnScreen,aList[[1]]];
     ];
   , BadCall["Keep",aNumber];
  ];
];

Keep[x___]:= BadCall["Keep",x];
 
Kill[aNumber_?IntegerQ] :=
Module[{},
  If[TeXRecording
   , Keep[aNumber];
     KillWindow[aNumber];
     KillDvi[aNumber];
   , BadCall["Kill",x];
  ];
];

Kill[x___] := BadCall["Kill",x];

KillWindow[aNumber_?IntegerQ] :=
Module[{aList},
  If[TeXRecording
    , aList = ReadList[StringJoin[
        "!ps -auxwww | grep ",directoryName,"/master",
        ToString[aNumber]," | awk '{print $2}'"]];
      Run[StringJoin["!ps -auxwww | grep ",directoryName,"/master",
            ToString[aNumber]]];
      Run[StringJoin["!ps -auxwww | grep ",directoryName]];
      Print[StringJoin[directoryName,"/master",ToString[aNumber]]];
      Map[Run["kill -9 "<> ToString[#]]&,aList];
    , BadCall["KillWindow",aNumber];
  ];
];

KillWindow[x___] := BadCall["KillWindow",x];

KillDvi[aNumber_?NumberQ] :=
  If[TeXRecording
    , Run["rm "<>directoryName<>"/master"<>ToString[aNumber]<>".dvi"];
    , BadCall["KillDvi",aNumber];
  ];

KillDvi[x___] := BadCall["KillDvi",x];

KillLogAndAux[aNumber_?IntegerQ] :=
Module[{str},
  str = "rm "<>directoryName<>"/master"<>ToString[aNumber];
  Run[str<>".log"];
  Run[str<>".aux"];
];

KillLogAndAux[x___] := BadCall["KillLogAndAux",x];

TeXTheFile[n_?IntegerQ] := Run[StringJoin[
    "cd ",directoryName,";latex master",ToString[n],".tex"]]; 

TeXTheFile[x___] := BadCall["TeXTheFile",x];

CreateTeXFront[str_String] :=
Module[{stream},
  stream = OpenWrite[directoryName<>"/"<>str<>".tex",
                     FormatType->InputForm];
  WriteString[stream,"\\documentstyle[12pt]{article}\n"];
  WriteString[stream,"\\begin{document}\n"];
  Return[stream];
];
CreateTeXFront[x___] := BadCall["CreateTeXFront",x];

CreateTeXEnd[stream_] :=
Module[{},  
  WriteString[stream,"\\end{document}\\end\n"];  
  Close[stream];
]; 

CreateTeXEnd[x___] := BadCall["CreateTeXEnd",x];

CreateTeXInput[stream_,str_String] := 
    WriteString[stream,"\\input "<>str<>".tex\n"];

CreateTeXInput[x___] := BadCall["CreateTeXInput",x];

AddConcatenation[stream_,str_String] := Abort[];

AddConcatenation[x___] := BadCall["AddConcatenation",x];

CreateTeXOutFile[x_] :=
Module[{name,done,aList},
  name = directoryName<>"/out"<>ToString[$Line]<>".tex";
  stream = OpenWrite[name];
  WriteString[stream,"Out["];
  WriteString[stream,ToString[$Line]];
  WriteString[stream,"] = \n\n"];
  done= False;
  If[Head[x]===String
    , done = True;
      WriteString[stream,x];
      WriteString[stream,"\n"];
  ];
  If[And[Not[done],MatrixQ[x]]
     , done = True;
       WriteString[stream,"$$\n"];
       WriteString[stream,ToString[Format[Global`OutputAMatrix[x],TeXForm]]];
       WriteString[stream,"$$\n"];
  ];
  If[And[Not[done],Head[x]===SeeAListOfOutputs]
    , done = True;
      aList = Flatten[x[[1]]];
      Map[CreateTeXInput[stream,"out"<>ToString[#]]&,aList];
  ];
  If[Not[done]
    , LongExpressionToTeXFile[stream,x];
  ];
  Close[name];
  Return[name];
];  

CreateTeXOutFile[x___] := BadCall["CreateTeXOutFile",x];

DoForPost[x_] :=
Module[{str,name,aList},
  CreateTeXOutFile[x];
  name = "master"<>ToString[$Line];
  stream = CreateTeXFront[name];
  CreateTeXInput[stream,"out"<>ToString[$Line]];
  CreateTeXEnd[stream];
  DisplayDviFile[$Line];
  Return[x];
];

DoForPost[x___] := BadCall["DoForPost",x];

DisplayDviFile[n_?IntegerQ] :=
Module[{numberOfWindows,numberToKill},
  If[MaxDviOnScreen>0
    , TeXTheFile[n];
      KillLogAndAux[n];
      numberOfWindows = Length[DviOnScreen];
      If[MaxDviOnScreen>numberOfWindows
        , numberOfWindows = numberOfWindows + 1;
        , Print["Have to kill some dvi sessions"];
          numberToKill = DviOnScreen[[1]];
          KillWindow[n];
          DviOnScreen = Delete[DviOnScreen,1];
      ];
      DviIt[directoryName<>"/master"<>ToString[n]];
      AppendTo[DviOnScreen,n]; 
  ];
];

DisplayDviFile[x___] := BadCall["DisplayDviFile",x];

End[];
EndPackage[]
