Clear[OutputASingleCategory];
Clear[OutputASingleTeXCategory];

OutputASingleCategory[aMono_,anArray_Symbol,stream_,nccpolys_Symbol] :=
Module[{rules,knowns,k,item},
  rules = unmarkerAndDestroy[GetCategory[aMono,anArray]];
  knowns = Complement[GrabIndeterminants[rules],aMono];
  WriteString[stream,
    "-----------------------------------------------------------\n"];
  WriteStringSet[stream,"The expressions with unknown variables "];
  WriteStringAux[stream,aMono];
  WriteStringNewLine[stream];
  WriteStringAppend[stream,"and knowns "];
  WriteStringAux[stream,knowns];
  WriteStringNewLine[stream];
  WriteStringNewLine[stream];
  Do[ item = rules[[k]];
      WriteStringAux[stream,item];
      WriteStringNewLine[stream];
      If[Head[nccpolys[item]]!=nccpolys
       , WriteStringNewLine[stream];
         WriteStringAux[stream,ToStringForTeX[nccpolys[item]]];
      ];
      If[Not[k==Length[rules]],WriteStringNewLine[stream]];
  ,{k,1,Length[rules]}];
];

OutputASingleCategory[x___] := BadCall["OutputASingleTeXCategory",x];

OutputASingleTeXCategory[aMono_,anArray_,stream_,
                         nccpolys_,userselects_,ColumnWidth_]:=
Module[{knowns,k,str,rules,item,additionalFunction},
  rules = unmarkerAndDestroy[GetCategory[aMono,anArray]];
  additionalFunction = anArray["additionalFunction"];
  If[And[Not[Head[additionalFunction]===aMono],
         Not[additionalFunction==={}]],
     rules = additionalFunction[rules,anArray];
  ];
  knowns = Complement[GrabIndeterminants[rules],aMono];

  WriteString[stream,"\\rule[3pt]{",ColumnWidth,"in}{.7pt}\\\\\n"];
  WriteString[stream,"The expressions with unknown variables "];
  WriteString[stream,ToStringForTeXList[aMono]];
  WriteString[stream,"\\\\\n"];

  WriteString[stream,"and knowns "];
  WriteString[stream,ToStringForTeXList[knowns],"\\smallskip\\\\\n"];

  Do[item = rules[[k]];
     WriteString[stream,"\\begin{minipage}{",ColumnWidth,"in}\n$\n"];
     If[MemberQ[userselects,item]
       ,WriteString[stream,"\\Uparrow\\ \n"];
     ];
     If[Head[nccpolys[item]]===nccpolys
       ,WriteString[stream,ToStringForTeX[item]];
        If[Not[Head[item]===Rule]
          ,WriteString[stream,"==0"];
        ];
       ,WriteString[stream,ToStringForTeX[nccpolys[item]]];
     ];
     If[Not[k==Length[rules]]
       ,WriteString[stream,"\n$\n\\end{minipage}\\medskip \\\\\n"];
       ,WriteString[stream,"\n$\n\\end{minipage}\\\\\n"];
     ];
  ,{k,1,Length[rules]}];
];

OutputASingleTeXCategory[x___] := 
    BadCall["OutputASingleTeXCategory",x];

OutputASingleHTMLCategory[aMono_,anArray_Symbol,
                          stream_,nccpolys_Symbol,n_,j_] :=
Module[{rules,knowns,k,item,CatOutput,Output,catfile,catstream},
  rules = unmarkerAndDestroy[GetCategory[aMono,anArray]];
  knowns = Complement[GrabIndeterminants[rules],aMono];

  Output[x_]:=WriteString[stream,HTML[x]];
  catfile=StringDrop[stream[[1]],-10]<>"Category."<>
               ToString[n]<>"."<>ToString[j]<>".html";
  catstream=OpenWrite[catfile];
  CatOutput[x_]:=WriteString[catstream,HTML[x]];

  CatOutput["<HTML>\n<HEAD>\n<TITLE>Category "<>ToString[j]<>
            " with "<>ToString[n]<>" unkowns"<>
            "</TITLE>\n</HEAD>\n<BODY BGCOLOR=#ffffff>\n"];
  Output["<HR NOSHADE>\n"];
  CatOutput["<HR NOSHADE>\n"];
  Output["<B>The expressions with unknown variables </B>\n"];
  CatOutput["<B>The expressions with unknown variables </B>\n"];
  Output[aMono];
  CatOutput[aMono];
  Output["<BR>\n<B>and knowns </B>\n"];
  CatOutput["<BR>\n<B>and knowns </B>\n"];
  Output[knowns];
  CatOutput[knowns];
  Output["<BR>\n"];
  CatOutput["<BR>\n"];
  Output["<FORM>\n<INPUT TYPE=\"button\" "<>
         "VALUE=\"This category has "<>ToString[Length[rules]]<>
         " equation"<>If[Length[rules]==1,"","s"]<>
         "\" onClick=\"CatWindow('Category."<>
         ToString[n]<>"."<>ToString[j]<>".html','Cat_"<>
         ToString[n]<>"_"<>ToString[j]<>"')\">\n</FORM>"];
  Do[item = rules[[k]];
    If[Head[nccpolys[item]]===nccpolys
     ,CatOutput[item];
     ,CatOutput[nccpolys[item]];
    ];
    If[Not[k==Length[rules]],CatOutput["<P>\n"]];
   ,{k,1,Length[rules]}
  ];
  CatOutput["<HR NOSHADE>\n</BODY>\n</HTML>"];
  Close[catstream];
  Clear[CatOutput];
  Clear[Output];
];

OutputASingleHTMLCategory[x___] := 
    BadCall["OutputASingleHTMLCategory",x];
