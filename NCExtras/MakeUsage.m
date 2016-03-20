BeginPackage["MakeUsage`"];

Clear[MakeUsage];

Begin[ "`Private`" ]

  Clear[MakeUsageAux];
  MakeUsageAux[symbol_, stream_] := Module[
      {usage},
      
      WriteString[stream, "\n<a name=\"" <> ToString[symbol] <> "\">\n"];
      WriteString[stream, "## " <> ToString[symbol] <> "\n"];
      WriteString[stream, "</a>\n\n"];
      
      usage = ToExpression[ToString[symbol] <> "::usage"];
      WriteString[stream, usage];
      WriteString[stream, "\n"];
  ];

  MakeUsage[context_, filename_:""] := Module[
    {members, stream},

    stream = If [filename === ""
                 ,
                 $Output
                 ,
                 OpenWrite[filename]];
      
    WriteString[stream, "# " <> ToString[context] <> "\n\n"];
    
    members = Names[ToString[context] <> "`*"];

    WriteString[stream, "Members are:\n\n"];
      
    Map[WriteString[stream, "* [" <> ToString[#] <> "](#" <> ToString[#] <> ")\n"]&, members];
      
    Map[MakeUsageAux[#,stream]&, members];
      
    Close[stream];
        
  ];

End[]

EndPackage[]
