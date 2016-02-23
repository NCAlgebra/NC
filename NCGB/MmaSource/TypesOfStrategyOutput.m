(* TypesOfStrategyOutput.m  *)

(* History:
	Came from pre-1996 effort.

     :9/9/99:   Puty in category weight stuff (dell)
     :11/22/99: Put in overflow checking support stuff 
                 see GetErrors[] below

*)	

Get["SmallBasis.m"];
Get["OutputArrayForTeX.m"];
(* MAURICIO - BEGIN *)
(* Get["TeXFile.m"]; *)
(* MAURICIO - END *)

shrinkIdealIterOne = 3;
shrinkIdealIterTwo = 3;
shrinkIter = 2;
shrinkIdealMult = 3;

Clear[ShrinkOutput];
Clear[RegularOutput];
Clear[ShrinkIdealOutput];

(*****************)
ShrinkOutput[aList_List,str_String] := 
Module[{temp},
   temp = SmallBasisByCategory[aList,shrinkIter];
   Print["ShrinkOutput:first computation result:",temp];
   Return[RegularOutput[temp,str]];
];

ShrinkOutput[x___] := BadCall["ShrinkOutput",x];


(**** REGULAR OUTPUT ******************)

Options[RegularOutput]:={NCCPolynomials->{},TeX->True,Xdvi->True,
                         Latex->True,Subscripts->True,TeXReplace->{},
                         TeXFont->"normalsize",Columns->1,
                         Comments->"",CategoryCutoff->Infinity,
                         Matricies->{},Time->{},NCMakeGBTime->{},
                         AfterComments->{},NCGBRunTimes->{},
			 WeightCats->True,
                         WeightsAre->{ Variable -> 1,
                            tp -> .1, Tp -> .1, Co -> .1,Aj-> .1,Inv->.3,
                            UnusualFunction -> .7 } };

RegularOutput[anArg:(_List|_Symbol),str_String,opts___Rule] :=
                          RegularOutput[anArg,str,"Mma",opts];

(*****  C++ RegularOutput NOT USED *******)
RegularOutput[aList_List,str_String,"C++"] :=
Module[{mark,fc,ints},
  NCMakeGB[aList,0,ReturnRelations->False];
  RegularOutput[str,"C++"];
];

RegularOutput[str_String,"C++"] :=
Module[{fc,ints,mark,junk3},
  fc = SaveFactControl[];
  ints = WhatAreGBNumbersMarker[fc];
  mark = CPPCreateCategories[ints,fc];
  DestroyMarker[{fc,ints}];
  CreateCategories[mark,junk3];
  regularOutput[mark,str];
  ClearCategoryFactory[junk3]; 
(*
*  Global`internalHalfRegularOutput[str];
*)
];

RegularOutput[symbol_Symbol,str_String] := 
Module[{channel},
  channel = OpenWrite[str];
  OutputArray[symbol, channel];
  Close[str];
];

RegularOutput::integerOverflow="LARGE  INTEGER OVERFLOW INVALIDATED THIS RUN. TRY A SMALLER PROBLEM OR USE THE UNIX VERSION OF NCGB.";

(***  THIS IS USED ( Mathematica version ) **************)
RegularOutput[anArg:(_List|_Symbol),str_String,"Mma",opts___Rule] :=
Module[{symbol,channel,userSelects,polys,file,tex,xdvi,
        latex,subscripts,texreplace,fontsize,columns,comments,
        commentscheck,commentslist,categorycutoff,matricies,times,
        runtimes,ncmakegbtime,aftercomments,savedirname
        (* MAURICIO - BEGIN *)
        (* ,newdirname *)
        (* MAURICIO - END *)
 },
  Start[];
  polys=NCCPolynomials/.{opts}/.Options[RegularOutput];
  tex=TeX/.{opts}/.Options[RegularOutput];
  xdvi=Xdvi/.{opts}/.Options[RegularOutput];
  latex=Latex/.{opts}/.Options[RegularOutput];
  subscripts=Subscripts/.{opts}/.Options[RegularOutput];
  texreplace=TeXReplace/.{opts}/.Options[RegularOutput];
  texfont=ToString[TeXFont/.{opts}/.Options[RegularOutput]];
  columns=Columns/.{opts}/.Options[RegularOutput];
  ncpweightcats = WeightCats/.{opts}/.Options[RegularOutput];
  ncpweightsare = WeightsAre/.{opts}/.Options[RegularOutput];

(*
  comments=Comments/.{opts}/.Options[RegularOutput];
*)

  (**** DELL & BILL 1999 DON't UNDERSTAND ********)
  commentslist = Select[{opts},Not[FreeQ[#,Comments]]&];
  If[commentslist==={}
    , comments = Comments/.Options[RegularOutput];
    , commentscheck =  Union[Map[Head,commentslist]]==={Rule};
      If[Not[TrueQ[commentscheck]]
	, Print["Not all of the Comments options for RegularOutput are rules"];
      ];
      If[commentscheck
	, commentscheck = Union[Map[#[[1]]&,commentslist]]==={Comments};
	  If[Not[commentscheck]
	     , Print["Something is wrong with the 'Comments' options"]
	  ];
      ];
      If[Not[commentscheck]
	, commentslist = Select[commentslist,
	    And[Head[#]===Rule,#[[1]]==Comments]&];
      ];
      commentslist = Map[#[[2]]&,commentslist];
      comments = Apply[StringJoin,commentslist];
  ];
  aftercomments = AfterComments/.{opts}/.Options[RegularOutput];
  categorycutoff=CategoryCutoff/.{opts}/.Options[RegularOutput];
  matricies=Matricies/.{opts}/.Options[RegularOutput];
  times=Time/.{opts}/.Options[RegularOutput];
  runtimes=NCGBRunTimes/.{opts}/.Options[RegularOutput];
  ncmakegbtime=NCMakeGBTime/.{opts}/.Options[RegularOutput];
  If[Not[Head[comments]==String],comments=ToString[comments]];
  savedirname = Directory[];
  (* MAURICIO - BEGIN *)
  (* 
     newdirname = NCGBGetLatexFilePath[];
     If[Not[newdirname===""],SetDirectory[NCGBGetLatexFilePath[]];];
   *)
  (* MAURICIO - END *)
  file=str;
  If[Head[anArg]===List
    ,Clear[symbol];
     CreateCategories[anArg,symbol];
    ,symbol=anArg;
  ];


  (* IF TEX is true  *)
  If[tex,
    (* THEN *)

    (* MAURICIO - BEGIN *)
    (* InitTeXStringReplace[texreplace]; *)
    (* MAURICIO - END *)

     (*****  FIX UP THE FILENAME *****)
     If[StringLength[file] < 4
       , file = file<>".tex";
     ];
     If[Not[StringTake[file,-4]==".tex"]
       ,file=file<>".tex";
     ];
     If[columns===2
       ,texfont="small"
       ,columns=1
     ];

     (* MAURICIO - BEGIN *)

     If[ GetErrors["IntegerOverflow"],
       Message[RegularOutput::integerOverflow];
       Return[];
     ];

     (*
     channel = OpenWriteForTeX[file,Font->texfont,Columns->columns];

     (***** HERE ARE EDITS FOR OVERFLOW PROBLEM *****)
	 GetErrors["IntegerOverflow"] = False;

     If[ GetErrors["IntegerOverflow"],
	WriteString[ channel, "{ \\vspace{1in} \\LARGE  INTEGER OVERFLOW ",
            "INVALIDATED THIS RUN.  \\\\ \n \\vspace{1in} \n ",
            " TRY A SMALLER  PROBLEM OR \\\\",
            "\\vspace{.5in} USE THE UNIX VERSION OF NCGB } " ,
            "\\vspace{1in}" ];   
     
       CloseTeXFile[channel];

       If[latex
         ,DeleteFile[StringJoin[StringDrop[file,-4],".dvi"]];
          Run[StringJoin[NCGBGetLatexCommand[]," ",file]];
          If[xdvi
            ,Run[StringJoin[NCGBGetDviCommand[]," ",StringDrop[file,-4],".dvi &"]];
          ];
       ];

       Return[];
     ];

     (******  END EDITS FOR OVERFLOW PROB  *******)

     *)

     channel = OpenWrite[file];
     Print["Outputting results to the stream ", Format[channel,InputForm]];
     
     WriteString[channel,
       "\\documentclass[10pt,leqno]{report}\n",
       "\\usepackage{amsmath,amsfonts}\n",
       "\\usepackage[margin=1in]{geometry}\n\n",
       "\\begin{document}\n" ]; 

     (* MAURICIO - END *)

     (**** THIS IS THE MAIN FUNCTION WHICH PRODUCES THE .tex DISPLAY **)
     OutputArrayForTeX[ symbol,channel,polys,texfont,columns,
                        comments,categorycutoff,matricies,
			WeightCats -> ncpweightcats,
			WeightsAre -> ncpweightsare ];

     (* The following creates the list of runtimes at the
     end of a spreadsheet *)
     (* MAURICIO - BEGIN *)
     (*
     If[times=!={}
      ,WriteString[channel,"\\vspace{10pt}\n\n\\noindent\n",
          "The time for preliminaries was ",times[[1]],"\\\\\n",
          "The time for NCMakeGB 1 was ",times[[2]],"\\\\\n",
          "The time for Remove Redundant 1 was ",times[[3]],"\\\\\n",
          "The time for the main NCMakeGB was ",times[[4]],"\\\\\n",
          "The time for Remove Redundant 2 was ",times[[5]],"\\\\\n",
          "The time for reducing unknowns was ",times[[6]],"\\\\\n",
          "The time for clean up basis was ",times[[7]],"\\\\\n",
          "The time for SmallBasis was ",times[[8]],"\\\\\n",
          "The time for CreateCategories was ",times[[9]],"\\\\\n",
          "The time for NCCV was ",times[[10]],"\\\\\n",
          "The time for RegularOutput was ",Finish[],"\\\\\n",
          "The time for everything so far was ",Finish["beginning"],"\\\\\n"];
     ];
     *)
     If [ times=!={},
        WriteString[channel,
          "\n\n\\noindent\n",
          "\\rule[3pt]{\\columnwidth}{.7pt}\\\\\n",
          "\\noindent\n",
 	  "TIMING:\n",
          "\\vspace{-\\baselineskip}\n\n",
          "\\hfill\n",
 	  "\\begin{tabular}{rr}",
          "TASK & TIME \\\\\n",
          "preliminaries & ", times[[1]], "\\\\\n",
          "NCMakeGB 1 & ", times[[2]], "\\\\\n",
          "Remove Redundant 1 & ", times[[3]], "\\\\\n",
          "Main NCMakeGB & ", times[[4]], "\\\\\n",
          "Remove Redundant 2 & ", times[[5]], "\\\\\n",
          "Rreducing unknowns & ", times[[6]], "\\\\\n",
          "Clean up basis & ", times[[7]], "\\\\\n",
          "SmallBasis & ", times[[8]], "\\\\\n",
          "CreateCategories & ", times[[9]], "\\\\\n",
          "NCCV & ", times[[10]], "\\\\\n",
          "RegularOutput & ", Finish[], "\\\\\n",
          "TOTAL & ", Finish["beginning"], "\\\\\n",
 	  "\\end{tabular}\n\n" ]
     ];
     (* MAURICIO - END *)

     (* WE DON"T SEE THESE timing statements  *)
     If[runtimes=!={}
       , WriteString[channel,"\\vspace{10pt}\n\n\\noindent\n"];
         Map[WriteString[channel,"The time for ",#[[1]],
                 " was ",#[[2]],"\\\\\n"]&,runtimes];
     ];
     If[ncmakegbtime=!={}
       , WriteString[channel,"\\vspace{10pt}\n\n\\noindent\n"];
         Map[WriteString[channel,#[[1]]&,"The ",#[[2]],
				" time for ",#[[3]]," was ",#[[4]],"\\\\\n"]&,
				ncmakegbtime]; 
     ];

     (* THIS ALLOWS YOU TO MAKE A COMMENT IN SPREADSHEET *)
     If[aftercomments=!={}
       , WriteString[channel,"\\vspace{10pt}\n\n\\noindent\n"];
         Map[WriteString[channel,#]&,aftercomments]; 
     ];
 
     (*  CLOSE AND LATEX FILE *) 

     (* MAURICIO - BEGIN *)
     (*
     CloseTeXFile[channel];
     *)

     WriteString[channel, "\\end{document}\n\\end"];
     Print["Done outputting results to the stream ",Format[channel,InputForm]];
     Close[channel];

     (* MAURICIO - END *)

     (* CLEAN UP BY MAURICIO JUNE 2009 *)
     (*
     If[latex
       ,DeleteFile[StringJoin[StringDrop[file,-4],".dvi"]];
        Run[StringJoin[NCGBGetLatexCommand[]," ",file]];
        If[xdvi
          ,Run[StringJoin[NCGBGetDviCommand[]," ",StringDrop[file,-4],".dvi &"]];
        ];
     ];
     *)

     (* Use new NCTeX facilities *)
     If[latex,
        NCRunPDFLaTeX[file];
        NCRunPDFViewer[StringReplace[file, ".tex" -> ".pdf"]];
     ];

    (* ELSE,  IF TEX is FALSE *)
    ,channel = OpenWrite[file];
     OutputArray[symbol, channel, polys, categorycutoff];
     Close[channel];
  ];
  SetDirectory[savedirname];
  If[Head[anArg]===List
    ,Clear[symbol];
  ];
];   
(**** END OF RegularOutput   ***)


(* THIS IS RegOutput debug stuff *)
RegularOutput[x_] := 
  ( Print["RegularOutput requires 2 arguments, not one"];
    Abort[];);

RegularOutput[] := 
  ( Print["RegularOutput requires 2 arguments, not zero"];
    Abort[];);

RegularOutput[_,_,_,___] := 
  ( Print["RegularOutput requires 2 arguments"];
    Abort[];);

RegularOutput[x_,y_] :=
  ( If[Not[Head[x]===List],
       Print["The first argument of RegularOutput should be a list"];
    ];
    If[Not[Head[y]===String],
       Print["The first argument of RegularOutput should be a string"];
    ];);

RegularOutput[x___] := BadCall["RegularOutput",x];

(* END OF Debug stuff *)



ShrinkIdealOutput[aList_List,str_String]:=
Module[{firststep},
   firststep = SmallBasisByCategory[aList,shrinkIdealIterOne];
Print["firststep:",firststep];
   RegularOutput[
         SmallBasisOnEliminationIdeal[firststep,
                                          shrinkIdealMult,
                                          shrinkIdealIterTwo],str];
];

ShrinkIdealOutput[x___] := BadCall["ShrinkIdealOutput",x];


