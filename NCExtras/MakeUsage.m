BeginPackage["MakeUsage`"];

Clear[MakeUsage];

Begin[ "`Private`" ]

  Clear[MakeUsageAux];
  MakeUsageAux[symbol_, stream_, nameStyle_:"markdown"] := Module[
      {usage},
      
      Switch [nameStyle
              , 
              "markdown"
              ,
              WriteString[stream, "\n## " <> ToString[symbol] <> 
                                  " {#" <> ToString[symbol] <> 
                                  "}\n"];
              ,
              "html"
              ,              
              WriteString[stream, "\n<a name=\"" <> ToString[symbol] <> 
                                  "\">\n"];
              WriteString[stream, "## " <> ToString[symbol] <> "\n"];
              WriteString[stream, "</a>\n\n"];
      ];
      
      usage = ToExpression[ToString[symbol] <> "::usage"];
      WriteString[stream, usage];
      WriteString[stream, "\n"];
  ];

  MakeUsage[context_, filename_:"", nameStyle_:"markdown"] := Module[
    {members, stream},

    stream = If [filename === ""
                 ,
                 $Output
                 ,
                 OpenWrite[filename]];
      
    Switch [nameStyle
            , 
            "markdown"
            ,
            WriteString[stream, "# " <> ToString[context] <> 
                                " {#Package" <> ToString[context] <> 
                                "}\n\n"];
            ,
            "html"
            ,              
            WriteString[stream, "\n<a name=\"Package" <> ToString[context] <> 
                                "\">\n"];
            WriteString[stream, "## " <> ToString[context] <> "\n"];
            WriteString[stream, "</a>\n\n"];
    ];
    
    members = Names[ToString[context] <> "`*"];

    WriteString[stream, "Members are:\n\n"];
      
    Map[WriteString[stream, "* [" <> ToString[#] <> "](#" <> ToString[#] <> ")\n"]&, members];
      
    Map[MakeUsageAux[#,stream,nameStyle]&, members];
      
    If [filename =!= "", Close[stream]];
        
  ];

End[]

EndPackage[]
