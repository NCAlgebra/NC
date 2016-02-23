(* :Title: 	MakePackage.m // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). 
*)

(* :Context: 	MakePackage` *)

(* :Summary:	A program to output code to make an SimplifyRational
                program from a given set of relations.
*)

(* :Alias: 	
*)

(* :History: 
*)

BeginPackage["MakePackage`",
      "Global`","Errors`"];

Clear[OpenActiveFile];

OpenActiveFile::usage = 
     "OpenActiveFile[] := OpenWrite[ActiveFile, FormatType -> InputForm];\
      See SetActiveFile.";

Clear[MakeBeginPackage];

MakeBeginPackage::usage = 
     "MakeBeginPackage[aList] outputs a BeginPackage statements with \
      the Contexts described by aList in it.";

Clear[MakeUsageStatements];

MakeUsageStatements::usage = 
      "MakeUsageStatements[aListOfStrings] outputs a list of Clear \
       and generic usage statements. MakeUsageStatements[aString] does \
       the same for a single function name.";

Clear[MakeBeginPrivate];

MakeBeginPrivate::usage = 
      "MakeBeginPrivate[] outputs the Begin Private statment to the \
       active file. See SetActiveFile.";  

Clear[MakeEndPackage];

MakeEndPackage::usage = 
      "MakeEndPackage[] puts the End[] and EndPackage[] statements at \
       the end of the file and closes it. See SetActiveFile.";

Clear[SetActiveFile];

SetActiveFile::usage = 
       "SetActiveFile[x] sets ActiveFile to be x. ActiveFile is a \
        variable local to the package which is used in all of the \
        other MakePackage functions.";

Clear[WhatIsActiveFile];

WhatIsActiveFile::usage = 
       "WhatIsActiveFile[] returns x where the last call to \
        SetActive file is SetActiveFile[x].";

Begin["`Private`"];
 
SetActiveFile[x_] := ActiveFile = x;

WhatIsActiveFile[] := ActiveFile;

OpenActiveFile[] := OpenWrite[ActiveFile, FormatType -> InputForm];

OpenActiveFile[x___] := BadCall["OpenActiveFile",x];

MakeBeginPackage[list_List] :=  
Module[{j},
    OpenActiveFile[];
    If[Length[list]==1,WriteString[ActiveFile,
                                   "BeginPackage[\"",
                                   list[[1]],
                                   "`\"];\n\n"
                                  ];,
(* ELSE *)             WriteString[ActiveFile,"BeginPackage[\"",list[[1]],"`\",\n"];
                       Do[WriteString[ActiveFile,
                                      "             \"",
                                      list[[j]],
                                      "`\",\n"];
                       ,{j,2,Length[list]-1}];
                       WriteString[ActiveFile,
                                   "             \"",
                                   list[[-1]],"`\"];\n\n"];
    ];
];

MakeBeginPackage[x___] := BadCall["MakeBeginPackage",x];

MakeUsageStatements[list_List] := Map[MakeUsageStatements,list];

MakeUsageStatements[func_String] := 
Block[{},
    WriteString[ActiveFile,"Clear[",func,"];\n\n"];
    WriteString[ActiveFile,func,
                          "::usage = \"",
                          func,
                          "[...] usage note not yet written.\";\n\n"
               ];
    Return[func]
];

MakeUsageStatements[x___] := BadCall["MakeUsageStatements",x];

MakeBeginPrivate[] := WriteString[ActiveFile,"Begin[\"`Private`\"];\n\n"];

MakeBeginPrivate[x__] := BadCall["MakeBeginPrivate",x];

MakeEndPackage[]:= Block[{},
     WriteString[ActiveFile, "\nEnd[];\n"]; 
     WriteString[ActiveFile, "EndPackage[]\n"]; 
     Close[ActiveFile];
     Return[ActiveFile]
];

MakeEndPackage[x__]:= BadCall["MakeEndPackage",x];

End[];
EndPackage[]
