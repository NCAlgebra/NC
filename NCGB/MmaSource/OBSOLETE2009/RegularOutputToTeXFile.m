<<TeXRules.m;

Print["@ RegularOutputToTeXFile"];

NCGBLoad["NCGBPlatformSpecific.m"];

Clear[RegularOutputToTeXFile];

Options[RegularOutputToTeXFile]:=
        {Subscripts->True,Xdvi->True,
         VariableReplace->{},TeXReplace->{},AutoTeXReplace->True};

RegularOutputToTeXFile[oldfile_String,opts___Rule]:=
           RegularOutputToTeXFile[oldfile<>".tex",oldfile,opts];

RegularOutputToTeXFile[newfile_String,oldfile_String,opts___Rule]:=
Module[{oldfilelist,i,newfilearray,nextline,stream,pos,
        texreplace,xdvi,subscripts},

  subscripts=Subscripts/.{opts}/.Options[RegularOutputToTeXFile];
  texreplace=TeXReplace/.{opts}/.Options[RegularOutputToTeXFile];
  autotexreplace=AutoTeXReplace/.{opts}/.Options[RegularOutputToTeXFile];
  variablereplace=VariableReplace/.{opts}/.Options[RegularOutputToTeXFile];
  xdvi=Xdvi/.{opts}/.Options[RegularOutputToTeXFile];

  Clear[newfilearray];
  oldfilelist=ReadList[oldfile,String];
  texreplace=Join[texreplace,{"{"->"\{","}"->"\}","**"->"\\,",
         "->"->"\\rightarrow ",">"->"\\bullet\\ ","+  -"->"-",
         "is a user select"->"\\mbox{\\ \\ \\ is a user select}",
         "================================================"->
            "\\rule[2pt]{4.4in}{4pt}",
         "The expressions with unknown variables "->
            "\\mbox{The expressions with unknown variables }",
         "and knowns "->"\\mbox{and knowns }",
         "---------------------------------------"->
            "\\rule[3pt]{4.4in}{.7pt}",
         "THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR:"->
            "\\mbox{THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR: }",
         "THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:"->
            "\\mbox{THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR: }",
         "The corresponding rules are the following:"->
            "\\mbox{The corresponding rules are the following:}",
         "========== YOUR SESSION HAS DIGESTED ==========="->
            "\\rule[2pt]{1.07in}{4pt}\n"<>
            "\\mbox{ YOUR SESSION HAS DIGESTED }\n"<>
            "\\rule[2pt]{1.07in}{4pt}",
         "========== THE FOLLOWING RELATIONS ============="->
            "\\rule[2pt]{1.11in}{4pt}\n"<>
            "\\mbox{ THE FOLLOWING RELATIONS }\n"<>
            "\\rule[2pt]{1.11in}{4pt}",
         "========= SOME RELATIONS WHICH APPEAR BELOW ===="->
            "\\rule[2pt]{.641in}{4pt}\n"<>
            "\\mbox{ SOME RELATIONS WHICH APPEAR BELOW }\n"<>
            "\\rule[2pt]{.641in}{4pt}",
         "================ MAY BE UNDIGESTED ============="->  
            "\\rule[2pt]{1.375in}{4pt}\n"<>
            "\\mbox{ MAY BE UNDIGESTED }\n"<>
            "\\rule[2pt]{1.375in}{4pt}"}];
  If[autotexreplace
    ,texreplace=Join[texreplace,TeXRules[oldfile,
               Subscripts->subscripts,VariableReplace->variablereplace]];
  ];
    

  newfilearray[i_]:=StringReplace[oldfilelist[[i]],texreplace];
  nextline:=oldfilelist[[i+1]];
  pos=Position[oldfilelist,
               "========= USER CREATIONS APPEAR BELOW =========="][[1,1]];
  newfilearray[pos-1]="\\rule[2pt]{4.4in}{1pt}";
  newfilearray[pos]="\\rule[2.5pt]{.92in}{1pt}\n"<>
                     "\\mbox{ USER CREATIONS APPEAR BELOW }\n"<>
                     "\\rule[2.5pt]{.92in}{1pt}";
  newfilearray[pos+1]="\\rule[3pt]{4.4in}{1pt}";
  stream=OpenWrite[newfile];
  Print["Outputting results to the stream ",stream];
  WriteString[stream,"\\input part1Index.tex\n\n\\noindent\n",
                       oldfilelist[[1]],"\n\\hfil\\break\n$\n"];
  Do[WriteString[stream,newfilearray[i],"\\\\\n"];
    ,{i,2,Length[oldfilelist]}
  ];
  WriteString[stream,"$\n\\end{document}\n\\end"];
  Print["Done outputting results to the stream ",stream];
  Close[stream];

  (* CLEAN UP BY MAURICIO JUNE 2009 *)
  (*
  Run[StringJoin[NCGBGetLatexCommand[]," ",newfile]];
  If[xdvi 
    , Run[StringJoin[NCGBGetDviCommand[]," ",StringDrop[newfile,-4]<>".dvi &"]]; 
  ];
  *)

  (* Use new NCTeX facilities *)
  NCRunPDFLaTeX[newfile];
  NCRunPDFViewer[StringReplace[newfile, ".tex" -> ".pdf"]];

  Return[]; 
];

RegularOutputToTeXFile[x___]:= BadCall["RegularOutputToTeXFile",x];
