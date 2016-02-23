(* The HTML code is highly system dependent. *)
(* It uses the following external commands.  *)
(*                                           *)
(* latex                                     *)
(* dvips                                     *)
(* pstogif                                   *)
(* giftrans                                  *)

$GifDirectory = "symbols";
   (* There are two different uses for $GifDirectory.       *)
   (* First of all, it is the directory in which            *)
   (*        the gif images will be placed.                 *)
   (* Second, it is the relative path in the HTML output.   *)
   (* There is no reason to believe that these two          *)
   (*        directories should actually be the same.       *)
   (* For simplicity they remain the same, perhaps the      *)
   (*        use of the html BASE tag should be mentioned.  *)

Clear[HTML];
Clear[ToHTMLString];
Clear[HTMLAux];
Clear[HTMLAux2];
Clear[HTMLAux3];
Clear[HTMLList];
Clear[MakeGif];
Clear[MakeTheGif];
Clear[WidthAndHeight];
Get["HTMLHardWired.m"];
Clear[LinkSymbols];

ToHTMLString[x___]:=HTML[x];

HTML[x_String] := x;
HTML[x_GBMarker] := HTML[RetrieveMarker[x]];
HTML[x_Plus] := HTMLAux3[x];
HTML[x_Equal] := HTMLAux[x,
     "<IMG SRC=\"../"<>$GifDirectory<>"/equal.gif\" VSPACE=9 WIDTH=36 HEIGHT=6>\n"];
HTML[x_Rule] := HTMLAux[x,
     "<IMG SRC=\"../"<>$GifDirectory<>"/rightarrow.gif\" VSPACE=8 WIDTH=23 HEIGHT=10>\n"];
HTML[Times[-1,x__]] := 
     "<IMG SRC=\"../"<>$GifDirectory<>"/minus.gif\" VSPACE=11 WIDTH=15 HEIGHT=2>\n"<>
     HTML[Times[x]];
HTML[x_Times] := HTMLAux2[x,""];
HTML[x_NonCommutativeMultiply] := HTMLAux2[x,""];
HTML[x_List] := HTMLList[x];

HTML[tp[x_]]      := HTML[Tp[x]]     ;
HTML[inv[x_]]     := HTML[Inv[x]]    ;
HTML[Tp[inv[x_]]] := HTML[Tp[Inv[x]]];
HTML[Inv[tp[x_]]] := HTML[Inv[Tp[x]]];

HTMLAux[x_,s_String] := 
Module[{aList,j,ans},
  aList = Map[HTML,Apply[List,x]];
  ans = Apply[StringJoin,
              Table[aList[[j]]<>s,{j,1,Length[aList]-1}]];
  ans = ans <> aList[[-1]];  
  Return[ans];
]; 

HTMLAux[x___] := BadCall["HTMLAux",x];

HTMLAux2[x_,s_String] := 
Module[{aList,ans="",i,item,len},
  aList=Apply[List,x];
  len = Length[aList];
  Do[item=aList[[i]];
     If[Head[item]===Plus
       ,ans = ans <> 
             "<IMG SRC=\"../"<>$GifDirectory<>"/leftparen.gif\" WIDTH=6 HEIGHT=26>\n" <> 
             HTML[aList[[i]]] <> 
             "<IMG SRC=\"../"<>$GifDirectory<>"/rightparen.gif\" WIDTH=6 HEIGHT=26>\n";
       ,ans = ans <> HTML[aList[[i]]];
     ];
     If[Not[i===len] ,ans = ans <> s];
    ,{i,len}
  ];
  Return[ans];
];

HTMLAux2[x___] := BadCall["HTMLAux2",x];

HTMLAux3[x_] := 
Module[{aList,i,ans},
  aList = Apply[List,x];
  ans = HTML[aList[[1]]];
  Do[
    If[Head[x[[i]]]===Times
       ,If[(Head[x[[i,1]]]===Integer || Head[x[[i,1]]]===Rational)
                    && x[[i,1]]<0
          ,ans=ans<>
               "<IMG SRC=\"../"<>$GifDirectory<>"/minus.gif\" VSPACE=11 WIDTH=15 HEIGHT=2>\n"<>
                HTML[-x[[i]]];
          ,ans=ans<>
               "<IMG SRC=\"../"<>$GifDirectory<>"/plus.gif\" VSPACE=3 WIDTH=17 HEIGHT=18>\n"<>
               HTML[x[[i]]];
        ];
       ,ans=ans<>
            "<IMG SRC=\"../"<>$GifDirectory<>"/plus.gif\" VSPACE=3 WIDTH=17 HEIGHT=18>\n"<>
            HTML[x[[i]]];
     ];
    ,{i,2,Length[aList]}
  ];
  Return[ans];
]; 

HTMLAux3[x___] := BadCall["HTMLAux3",x];

HTMLList[vars_List]:=
Module[{result="<IMG SRC=\"../"<>$GifDirectory<>"/leftbrace.gif\" WIDTH=10 HEIGHT=25>\n"},
  If[Not[Length[vars]===0]
    ,Do[result=result<>HTML[vars[[i]]]<>
       "<IMG SRC=\"../"<>$GifDirectory<>"/comma.gif\" WIDTH=3 HEIGHT=8>\n";
      ,{i,Length[vars]-1}
     ];
     result=result<>HTML[vars[[-1]]];
  ];
  result=result<>
         "<IMG SRC=\"../"<>$GifDirectory<>"/rightbrace.gif\" WIDTH=10 HEIGHT=25>\n";
  Return[result]
];

HTMLList[x___] := BadCall["HTMLList",x];

HTML[x_]:=
Module[{stream,gifname,wandh,mag,texfile},
  texfile = Close[OpenTemporary[]];
  gifname=ToString[FullForm[x]];
  gifname=StringReplace[gifname,{" "->"","["->"\\[","]"->"\\]"}];
  If[StringTake[gifname,1]=="-"
    ,gifname = "minus"<>StringDrop[gifname,1];
  ];
  If[Head[x]===Rational
    ,mag = "1500" ;
    ,mag = "2500" ;
  ];
  stream = OpenWrite[texfile<>".tex"];
  WriteString[stream,"\\magnification="<>mag<>"\n"<>
                     "\\nopagenumbers\n"<>
                     "$$\n",ToStringForTeX[x],"\n$$\n\\end"];
  Close[stream];

  MakeTheGif[gifname,texfile];
  wandh = WidthAndHeight[gifname];
  Run["mv "<>gifname<>".gif "<>$GifDirectory<>"/"<>gifname<>".gif"];

  gifname = StringReplace[gifname,"\\"->""];
  stream = OpenAppend["HTMLHardWired.m"];
  WriteString[stream,"\nHTML["<>ToString[FullForm[x]]<>"]:=\n "<>
         "\"<IMG SRC=\\\"../\"<>$GifDirectory<>\"/"<>gifname<>
         ".gif\\\" "<>wandh<>">\\n\";\n"];
  Close[stream];

  HTML[x]:="<IMG SRC=\"../"<>$GifDirectory<>"/"<>gifname<>
                                        ".gif\" "<>wandh<>">\n";
  Return["<IMG SRC=\"../"<>$GifDirectory<>"/"<>gifname<>
                                        ".gif\" "<>wandh<>">\n"];
];

HTML[x___] := BadCall["HTML",x];

(* This is a stand alone function and is not called by HTML *)

Options[MakeGif]:={DisplayFunction->"xv",HTMLOutput->True};

MakeGif[file_String,x_,opts___Rule]:=
Module[{stream,gifname=file,wandh,display,html,texfile},
  texfile = Close[OpenTemporary[]];
  display = DisplayFunction/.{opts}/.Options[MakeGif];
  html = HTMLOutput/.{opts}/.Options[MakeGif];

  If[StringLength[gifname] > 4 && StringTake[gifname,-4] == ".gif"
    ,gifname=StringDrop[gifname,-4];
  ];
  stream = OpenWrite[texfile<>".tex"];
  WriteString[stream,"\\magnification=2500\n"<>
                     "\\nopagenumbers\n"<>
                     "$$\n",ToStringForTeX[x],"\n$$\n\\end"];
  Close[stream];

  MakeTheGif[gifname,texfile];
  If[Not[SameQ[display,Identity]]
    ,Run[display<>" "<>gifname<>".gif &"];
  ];

  If[html
    ,wandh = WidthAndHeight[gifname];
     Return["<IMG SRC=\""<>gifname<>".gif\" "<>wandh<>">\n"];
    ,Return[gifname<>".gif"];
  ];
];

(* This version of MakeGif is called by HTML and by MakeGif[x,y] *)

MakeTheGif[x_String,texfile_String]:=
Module[{},
  Run["cd /tmp; tex "<>texfile<>".tex"];
  Run["dvips -o "<>texfile<>".ps "<>texfile<>".dvi"];
  Run["pstogif "<>texfile];
  Run["giftrans -t#ffffff -o"<>x<>".gif "<>texfile<>".gif"];
  Run["rm "<>texfile<>"*"];
];

MakeTheGif[x__]:= BadCall["MakeTheGif",x];

WidthAndHeight[x_String]:=
Module[{str,width,height,widthblanks,heightblanks,tmpfile},
  tmpfile = Close[OpenTemporary[]];
  Run["giftrans -e "<>tmpfile<>" -L "<>x<>".gif"];
  str = ReadList[tmpfile,String];
  width = str[[3]];
  height = str[[4]];
  widthblanks = StringPosition[width," "];
  heightblanks = StringPosition[height," "];
  width = StringTake[width,{widthblanks[[3,1]]+1,widthblanks[[4,1]]-1}];
  height = StringTake[height,{heightblanks[[3,1]]+1,heightblanks[[4,1]]-1}];
  Run["rm "<>tmpfile];
  Return["WIDTH="<>width<>" HEIGHT="<>height];
];

WidthAndHeight[x__]:= BadCall["WidthAndHeight",x];

LinkSymbols[realdir_String]:=
Module[{tempfile},
  tempfile = Close[OpenTemporary[]];
  Run["ls -1 "<>realdir<>" | awk '{print \"ln -s "<>realdir<>"/\"$1\" \"$1}' > "<>tempfile];
  Run["chmod 700 "<>tempfile];
  Run[tempfile];
  Run["rm "<>tempfile];
];

LinkSymbols[x__]:= BadCall["LinkSymbols",x];
