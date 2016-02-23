(* :Title: 	NCDoTeX.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Robert Obarr (obarr)
		Mark Stankus (mstankus). 
*)

(* :Context: 	TeXStuff` *)

(* :Summary:	A program to output mathematica expressions in TeX.
		See the file DoTeX.install for installation instructions.       *)

(* :Alias: 	ExprToTexFile ::= ExpressionToTexFile *)

(* :History: 
   :6/30/92	Packaged. (mstankus)
   :8/16/92     Repackaged under TeXStuff` Context. (dhurst)
   :7/12/93     Minor packaging changes. (yoshinob)
*)

BeginPackage["TeXStuff`","System`","Global`", "NonCommutativeMultiply`"];

DoTeX ::usage = 
     "DoTeX[] is an interactive TeX outputter. The program will ask you \
     what expressions or comments you would like to have put into \
     a file for LaTeXing.  Alias:  none.";

dotex::usage = 
     "The commands is DoTeX[]";

OpenTeXFile ::usage = 
     "OpenTeXFile[\"filename.tex\"] opens file \"filename.tex\" for \
     TeX output.\n     OpenTeXFile[] opens file \"file.tex\" for TeX \
     output.  Alias:  none.";

CloseTeXFile ::usage = 
     "CloseTeXFile[\"filename.tex\"] closes the file \"filename.tex\". \n
     CloseTeXFile[] closes the file \"file.tex\".  Alias:  none.";

ExpressionToTeXFile ::usage = 
     "ExpressionToTeXFile[\"filename.tex\", expr] outputs an expression \
     as a \"displayed equation\" (TeX terminology -- i.e., double dollar \
     sign mode) to a TeXFile. ExpressionToTeXFile[expr] outputs expression \
     to the default \"file.tex\".  Alias:  ExprToTeXFile.";

StartParagraphTeXFile ::usage = 
     "StartParagraph[\"filename.tex\"] outputs the TeX macro to start a \
     paragraph in the TeX file \"filename\".  StartParagraph[] outputs \
     the TeX macro to start a paragraph in the default TeX file \
     \"file.tex\".  Alias:  none.";

CommentToTeXFile ::usage = 
     "CommentToTeXFile[\"filename.tex\", comment] outputs a comment \
     to the TeX file \"filename.tex\". See StartParagraph.\n
     CommentToTeXFile[comment] outputs a comment to the default TeX \
     file \"file.tex\".  Alias:  none.";

InLineExpressionToTeXFile ::usage = 
     "InLineExpressionToTeXFile[\"filename.tex\", expression] outputs \
     an expression as a \"inline equation\" (TeX terminology -- i.e., \
     single dollar sign mode) to the \"filename.tex\" TeXFile. \n
     InLineExpressionToTeXFile[expression] outputs an expression as a \
     \"inline equation\" (TeX terminology -- i.e., single dollar sign \
     mode) to the default \"file.tex\" TeXFile.  Alias:  none.";

EqualityToTeXFile ::usage = 
     "EqualityToTeXFile[\"filename.tex\", expr1, expr2] calls \
     LongExpressionToTeXFile[\"filename.tex\", expr1, \"=\", expr2].\n
     EqualityToTeXFile[expr1, expr2] defaults to \"file.tex\".  \
     Alias:  none.";

LongExpressionToTeXFile ::usage = 
     "LongExpressionToTeXFile[ \"filename.tex\", Expressions___] \
     outputs an expression to the TeXFile as a displayed equation. If \
     the expression is long, then the expression is split between \
     different lines.  Alias:  none.";

AddSplitsTeX ::usage = 
     "AddSplitsTeX[thing_] used by LongExpressionToTeXFile.  Alias:  none.";

AddSplitsTeXText ::usage =
     "AddSplitsTeXText[\"Plus\"] = \"+\" used by \
     LongExpressionToTeXFile. Right now an equation can be split \
     between lines if there is an intervening \"+\". One would alter \
     AddSplitsTeXText and SplittingTeXHeads to split on something \
     other than \"+\".  Alias:  none.";

TeXTheFile ::usage = 
     "TeXTheFile[\"filename.tex\"], TeXTheFile[] run LaTeX. If no \
     \"filename.tex\" is specified, then the NCTeX.process file in \
     your bin will be executed. If \"filename.tex\" is specified, \
     then just \"LaTeXing\" is done (no renaming, etc.).  \
     Alias:  none.";

dotex ::DoTeX = "The command is DoTeX[]";

LongExpressionToTeXFile ::toolong = "Warning:  Very long expression.";

Begin[ "`Private`" ];

DoTeX/: DoTeX := Block[{go,com,opt},
      OpenTeXFile[];
      go = "y" ;
      While[ go == "y", 
         Print[""];
         Print["      1)  enter expression"];
         Print["      2)  enter comment"]; 
         Print["      3)  quit"]; 
         Print[""];
         opt = Input["Enter Option [1-3]? "];
                         
         If[ opt==1 , ExpressionToTeXFile[Input["Enter expression ? "]]; ];
         If[ opt==2 , 
            Print[""];
            Print["Enter a one line comment for the above expression: "];
            com = InputString[];
            StartParagraphTeXFile[];
            CommentToTeXFile[com];
         ]; 
         If[ opt == 3 , go = "n"];
      ];
      CloseTeXFile[];
      TeXTheFile[];
];

dotex/: dotex:= Message[dotex::DoTeX];

OpenTeXFile[] := OpenTeXFile["file.tex"];

OpenTeXFile[str_]:= Block[{},
     OpenWrite[str, FormatType -> InputForm];
     If[$VersionNumber< 3.0
       , WriteString[str, "\\documentstyle [12pt]{article} \n"];
       , WriteString[str, "\\documentstyle [12pt,notebook]{article} \n"];
     ];
     WriteString[str, "\\begin{document} \n"];
];

CloseTeXFile[] := CloseTeXFile["file.tex"];

CloseTeXFile[str_]:= Block[{},
     WriteString[str, "\\end{document}"]; 
     Close[str];
];

ExprToTeXFile:= ExpressionToTeXFile;

ExpressionToTeXFile[expr_]:= ExpressionToTeXFile["file.tex",expr];

ExpressionToTeXFile[str_,expr_]:= Block[{},
     WriteString[str, "$$ \n"];
     Which[
          $VersionNumber == 1.2, ResetMedium[str, FormatType -> TeXForm],
          $VersionNumber >=2., SetOptions[str, FormatType -> TeXForm]
     ];
     Write[str,expr];
     Which[
          $VersionNumber == 1.2, ResetMedium[str, FormatType -> InputForm],
          $VersionNumber >=2., SetOptions[str, FormatType -> InputForm]
     ];
     WriteString[str, "$$ \n"];
];

StartParagraphTeXFile[] := StartParagraphTeXFile["file.tex"];

StartParagraphTeXFile[str_] := WriteString[str,"\\par \n"];

CommentToTeXFile[com_] := CommentToTeXFile["file.tex",com];

CommentToTeXFile[str_,com_] :=  WriteString[str, com , "\n"];

InLineExpressionToTeXFile[expr_]:= InLineExpressionToTeXFile["file.tex",expr];

InLineExpressionToTeXFile[str_,expr_]:= Block[{},
     WriteString[str,"$ \n"];
     Which[
          $VersionNumber == 1.2, ResetMedium[str, FormatType -> TeXForm],
          $VersionNumber >=2., SetOptions[str, FormatType -> TeXForm]
     ];
     Write[str,expr];
     Which[
          $VersionNumber == 1.2, ResetMedium[str, FormatType -> InputForm],
          $VersionNumber >=2., SetOptions[str, FormatType -> InputForm]
     ];
     WriteString[str,"$ \n"];
];

EqualityToTeXFile[expr1_,expr2_] := EqualityToTeXFile["file.tex",expr1,expr2];

EqualityToTeXFile[str_,expr1_,expr2_] := LongExpressionToTeXFile[str,expr1,"=",expr2];


LongExpressionToTeXFile[str_,Expressions___] := 
Block[{linesize,ListOfExpressions,newlist,temp,item,text,counter,j,len},
     WriteString[str, "$$ \n"];
     WriteString[str, "\\displaylines{ \n"];
     linesize = 40;
     ListOfExpressions = List[Expressions];
     newlist = {};
     len = Length[ListOfExpressions];
     For[j=1,j<=len,j++,
         temp = ListOfExpressions[[j]];
         If[ToString[Head[temp]]==="String", 
                     newstuff = List[temp],
                     newstuff = AddSplitsTeX[temp];
         ];
         newlist = Join[newlist,newstuff];
     ];
     text = "";
     len = Length[newlist];
     For[j=1,j<=len,j++,
         If[ToString[Head[newlist[[j]]]]==="String",  (* THEN *)
                item = newlist[[j]];
                                                   ,  (* ELSE *)
                item = ToString[Format[newlist[[j]],TeXForm]];
         ];
         If[StringLength[item] > linesize,    (* THEN *)
(* ------------------------------------------------------------------ *)
(*      If the next thing to be typeset is very long, then typeset    *)
(*      what has already being stored in text and then output         *)
(*      the really long expression.                                   *)
(* ------------------------------------------------------------------ *)
	     Message[ LongExpressionToTeXFile::toolong ];	
             If[StringLength[text] > 0, 
                    WriteString[str,text];
                    WriteString[str,"\\cr \n"];
                    text = "";                  
             ];                                       
             WriteString[str,item];        
             WriteString[str," \\cr \n"];
                                ,             (* ELSE *)
            If[StringLength[text]+StringLength[item] > linesize,(* THEN *)
(* ------------------------------------------------------------------ *)
(*      If the line of text being accumulated so far would be too     *)
(*      long if item were added, then output the text accumulated so  *)
(*      far and start accumulation new text.                          *)
(* ------------------------------------------------------------------ *)
                WriteString[str,text];
                WriteString[str," \\cr \n"];
                text = item;
                                              ,                  (* ELSE *)
(* ------------------------------------------------------------------ *)
(*      If the line of text being accumulated so far is short enough  *)
(*      then keep accumulation text.                                  *)
(* ------------------------------------------------------------------ *)
               text = StringJoin[text,item];
            ];
         ]; 
     ];
(* ------------------------------------------------------------------ *)
(*      If we have accoumulated text at this point, then output it.   *)
(* ------------------------------------------------------------------ *)
     If[StringLength[text] > 0, WriteString[str,text];
                                WriteString[str," \\cr \n"];
     ];
     WriteString[str, "} \n$$ \n"];
];

AddSplitsTeX[thing_] := Block[{result,len,thehead,j},
     result = {};
     len = Length[thing];
     thehead = ToString[Head[thing]];
     For[j=1,j<len,j++,
         AppendTo[result,ToString[Format[thing[[j]],TeXForm]]];
         AppendTo[result,AddSplitsTeXText[ToString[thehead]]];
     ];
     AppendTo[result,ToString[Format[temp[[len]],TeXForm]]];
     Return[result]
]   /;               MemberQ[SplittingTeXHeads,ToString[Head[thing]]]

(* ------------------------------------------------------------------ *)
(*   Otherwise                                                        *)
(* ------------------------------------------------------------------ *)
AddSplitsTeX[thing_] := List[thing] /; 
                  Not[MemberQ[SplittingTeXHeads,ToString[Head[thing]]]]

SplittingTeXHeads = {"Plus","Rule","NonCommutativeMultiply"};

AddSplitsTeXText["Plus"] = "+";
AddSplitsTeXText["Rule"] = "->";
AddSplitsTeXText["NonCommutativeMultiply"] = "**";
 

TeXTheFile[str_] := Run[StringJoin["latex ",str,".tex"]];

TeXTheFile[] := Run["NCTeX.process"];

End[ ]

EndPackage[ ]



