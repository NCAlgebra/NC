NCGBLoad["NCGBPlatformSpecific.m"];
Clear[OpenWriteForTeX];
Clear[OpenWriteTeXFile];
Clear[CloseTeXFile];
Clear[InitTeXStringReplace];
Clear[TeXStringReplace];
Clear[TeXDefinition];
Clear[Dvi];
Clear[Latex];

Options[OpenWriteForTeX]:={Font->"normalsize",
                           Columns->1};

OpenWriteTeXFile[x___]:= OpenWriteForTeX[x];

OpenWriteForTeX[s_String,opts___Rule]:=
Module[{file=s,font,columns,stream,baselineskip
  (* MAURICIO - BEGIN *)
       },
  (*
     ,latexclass = LaTeXStyleOrClass[]},
  If[Head[latexclass]===LaTeXStyleOrClass
    , latexclass = "style";
  ];
  *)
  (* MAURICIO - END *)
  font=Font/.{opts}/.Options[OpenWriteForTeX];
  columns=Columns/.{opts}/.Options[OpenWriteForTeX];
  If[StringLength[file] < 4
    ,file=file<>".tex";
  ];
  If[Not[StringTake[file,-4]===".tex"]
    ,file=file<>".tex";
  ];
  Switch[font
    ,"normalsize"
    ,baselineskip = "12pt"
    ,"small"
    ,baselineskip = "9pt"
    ,_
    ,Print["FontSize ",font," not supported."];
     font = "normalsize";
     baselineskip = "12pt";
  ];
  stream=OpenWrite[file];
  Print["Outputting results to the stream ",Format[stream,InputForm]];
  If[columns===2
    (* MAURICIO - BEGIN *)
    (*
    ,WriteString[stream,"\\document",latexclass,"[proc]{article}\n",
    *)
    (* MAURICIO - END *)
    ,WriteString[stream,"\\documentclass[proc]{article}\n",
		        "\\usepackage{amsmath,amsfonts}\n",
                        "\\textheight      25.0000cm\n",
                        "\\textwidth         17.27cm\n",
                        "\\topmargin       -3.0000cm\n",
                        "\\oddsidemargin   -0.3462cm\n",
                        "\\evensidemargin  -0.3462cm\n",
                        "\\arraycolsep        2.5pt\n"];
    (* MAURICIO - BEGIN *)
    (*
    ,WriteString[stream,"\\document",latexclass,"[rep10,leqno]{report}\n",
    *)
    (* MAURICIO - END *)
    ,WriteString[stream,"\\documentclass[rep10,leqno]{report}\n",
		        "\\usepackage{amsmath,amsfonts}\n",
                        "\\voffset = -1in\n",
                        "\\evensidemargin 0.1in\n",
                        "\\oddsidemargin 0.1in\n",
                        "\\textheight 9in\n",
                        "\\textwidth 6in\n"];
  ];
  WriteString[stream,"\\begin{document}\n",
                     "\\",font,"\n",
                     "\\baselineskip=",baselineskip,"\n",
                     "\\noindent\n"];
  Return[stream];
];

CloseTeXFile[] := CloseTeXFile["file.tex"];

CloseTeXFile[stream_]:=
Module[{},
  WriteString[stream,"\\end{document}\n\\end"];
  Print["Done outputting results to the stream ",Format[stream,InputForm]];
  Close[stream];
  Return[];
];

InitTeXStringReplace[rules___Rule]:=
  TeXStringReplace[st_String]:=StringReplace[st,{rules}];

InitTeXStringReplace[rules_List]:=
  TeXStringReplace[st_]:=StringReplace[ToString[st],rules];

ClearTeXStringReplace[]:=InitTeXStringReplace[{}];

InitTeXStringReplace[{}];

TeXDefinition[x_]:=
Module[{result,columnwidth},
  columnwidth="6in";
  result="\\begin{minipage}{"<>columnwidth<>"}\n"<>
         ToString[Unevaluated[x]]<>" =\n$\n"<>
         ToStringForTeX[x]<>
         "\n$\n\\end{minipage}\\medskip\\\\\n";
  Return[result]
];

SetAttributes[TeXDefinition,HoldFirst];

Dvi[s_String]:=
Module[{file=s},
  If[StringLength[file] < 4
    ,file=file<>".dvi";
  ];
  If[Not[StringTake[file,-4]===".dvi"]
       ,file=file<>".dvi";
  ];
  Run["xdvi "<>file<>" &"];
];

Latex[s_String]:=
Module[{file=s},
  If[StringLength[file] < 4
    ,file=file<>".tex";
  ];
  If[Not[StringTake[file,-4]===".tex"]
       ,file=file<>".tex";
  ];
  Run[StringJoin[NCGBGetLatexCommand[]," ",file]];
];
