Clear[SummarizeRun];

SummarizeRun[str_List,infile___String]:=
  SummarizeRun[Apply[StringJoin,Map[StringJoin[#,"\n"]&,str]],infile];


SummarizeRun[str_String,infile___String]:=
Module[{outfile,stream,filestrings,infilelist},
  infilelist = {infile};
  outfile = Map[ToString,Date[]];
  outfile = Map[StringJoin[#,"."]&,outfile];
  outfile = Apply[StringJoin,outfile];
  outfile = StringJoin[outfile,"run"];

  stream = OpenWrite[outfile];
  WriteString[stream,ReadList["!date",String][[1]],"\n\n"];
  WriteString[stream,str,"\n\n"];
 
  Do[WriteString[stream,"This is the file ",infilelist[[i]],
        ".\n","---------------------------------------------------------\n"];
    filestrings = ReadList[infilelist[[i]],String];
    filestrings = Map[StringJoin[#,"\n"]&,filestrings];
    filestrings = Join[{stream},filestrings,{"\n\n"}];
    Apply[WriteString,filestrings];
    ,{i,Length[infilelist]}
  ];
  Close[stream];
];

