Clear[OutputArrayForHTML];

OutputArrayForHTML[anArray_Symbol] := OutputArrayForHTML[anArray,$Output];

OutputArrayForHTML[anArray_Symbol,stream_,NCCPolys_List,
                   categorycutoff_] := 
Module[{i,j,k,singleRuleList,singleVarList,nonsingleVarList,poly,
        monomials,aMono,theNumbers,num,n,w,knowns,shouldOutput,
        aList,nccpolys,str,userselects,Output},

  CreatePolynomialArray[NCCPolys,nccpolys];
  n = WhatIsMultiplicityOfGrading[];
  Print["Outputting results to the stream ",
        Format[stream,InputForm]];
  InitializeStreamClass[stream];
  singleRuleList = GetCategory["singleRules",anArray];
  If[Head[singleRuleList]===GBMarker
    , singleRuleList = RetrieveMarker[singleRuleList];
  ];
  singleVarList = anArray["singleVars"];
  If[Head[singleVarList]===GBMarker
    , singleVarList = RetrieveMarker[singleVarList];
  ];
  nonsingleVarList = anArray["nonsingleVars"];
  If[Head[nonsingleVarList]===GBMarker
    , nonsingleVarList = RetrieveMarker[nonsingleVarList];
  ];

  Output[x_]:=WriteString[stream,HTML[x]];

  Output["<HTML>\n<HEAD>\n<TITLE>"<>StringDrop[stream[[1]],-11]<>
         "</TITLE>\n<SCRIPT LANGUAGE=LiveScript>\n"<>
         "<!--Hiding\nfunction CatWindow(file,winname) {"<>
   "var win=window.open(\"\",winname,\"width=800,height=600\");\n"<>
   "win.location.href=\"file:"<>
   ReadList["!pwd",String][[1]]<>"/"<>
   StringDrop[stream[[1]],-10]<>"\"+file;\n"<>
   "win.document.close();\n}\n//-->\n</SCRIPT>\n"<>
   "</HEAD>\n<BODY BGCOLOR=#ffffff>\n"];

  Output["<B>THE ORDER IS NOW THE FOLLOWING:</B>\n"];
  Do[aList = WhatIsSetOfIndeterminants[j];
    If[Not[aList==={}]
      ,Do[Output[aList[[w]]];
         Output["<IMG SRC=\"../"<>$GifDirectory<>
                 "/lt.gif\" VSPACE=6 WIDTH=15 HEIGHT=15>\n"];
         ,{w,1,Length[aList]-1}
       ];
       Output[aList[[-1]]];
       If[j!=n
         ,Output["<IMG SRC=\"../"<>$GifDirectory<>
                 "/ll.gif\" VSPACE=6 WIDTH=23 HEIGHT=16>\n"];
       ];
    ];
  ,{j,1,n}
  ];

  Output["<CENTER>\n<TABLE WIDTH=100%>\n"<>
         "<TR><TH COLSPAN=3><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH WIDTH=30%><HR NOSHADE SIZE=6>\n"<>
         "<TH WIDTH=40%>YOUR SESSION HAS DIGESTED\n"<>
         "<TH WIDTH=30%><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH WIDTH=30%><HR NOSHADE SIZE=6>\n"<>
         "<TH WIDTH=40%>THE FOLLOWING RELATIONS\n"<>
         "<TH WIDTH=30%><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH COLSPAN=3><HR NOSHADE SIZE=6>\n"<>
         "</TABLE>\n</CENTER>\n"];


  If[singleRuleList != {}
     ,Output["<B>THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR:\n</B>"];
      Output[singleVarList];
      Output["<BR>\n"];
      Output["<B>The corresponding rules are the following:</B><BR>\n"];
      Do[Output[singleRuleList[[i]]];
         Output["<P>\n"];
        ,{i,1,Length[singleRuleList]}
      ];
  ];
  theNumbers = Select[anArray["numbers"],#<categorycutoff&];
  notoutput = Complement[anArray["numbers"],theNumbers];
  userselects = unmarkerAndDestroy[anArray["userSelects"]];
  OutputANumberCategoryForHTML[anArray,stream,0,
                               nccpolys,userselects];

  Output["<CENTER>\n<TABLE WIDTH=100%>\n"<>
         "<TR><TH COLSPAN=3><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH WIDTH=30%><HR NOSHADE SIZE=6>\n"<>
         "<TH WIDTH=40%>USER CREATIONS APPEAR BELOW\n"<>
         "<TH WIDTH=30%><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH COLSPAN=3><HR NOSHADE SIZE=6>\n"<>
         "</TABLE>\n</CENTER>\n"];

  num = anArray["userSelects"];
  Do[ poly = num[[i]];
      Output[poly];
      If[Not[i==Length[num]]
        ,Output["<P>\n"];
      ];
  ,{i,1,Length[num]}
  ];

  Output["<CENTER>\n<TABLE WIDTH=100%>\n"<>
         "<TR><TH WIDTH=25%><TH WIDTH=10%>"<>
         "<TH WIDTH=30%><TH WIDTH=10%><TH WIDTH=25%>\n"<>
         "<TR><TH COLSPAN=5><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH><HR NOSHADE SIZE=6>\n"<>
         "<TH COLSPAN=3>SOME RELATIONS WHICH APPEAR BELOW\n"<>
         "<TH><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH COLSPAN=2><HR NOSHADE SIZE=6>\n"<>
         "<TH>MAY BE UNDIGESTED\n"<>
         "<TH COLSPAN=2><HR NOSHADE SIZE=6>\n"<>
         "<TR><TH COLSPAN=5><HR NOSHADE SIZE=6>\n"<>
         "</TABLE>\n</CENTER>\n"];

  Output["<B>THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\n</B>"];
  Output[nonsingleVarList];
  Do[num = theNumbers[[i]];
   If[Not[num===0]
     ,OutputANumberCategoryForHTML[anArray,stream,num,
                                  nccpolys,anArray["userSelects"]];
   ];
  ,{i,1,Length[theNumbers]}];
  Output["</BODY>\n</HTML>"];
  Print["Done outputting results to the stream ",stream];
  Clear[Output];
];

OutputANumberCategoryForHTML[anArray_Symbol,stream_,n_Integer,
         nccpolys_Symbol,userselects_List] :=
Module[{aMono,shouldOutput,monomials,j},
  monomials = anArray[n];
  Do[
    aMono = monomials[[j]];
    If[Not[outputHeader], 
       WriteString[stream,"<HR NOSHADE>\n"];
       WriteString[stream,"<B>THE EXPRESSIONS WITH ",
              ToString[n]," UNKNOWNS ARE THE FOLLOWING.</B>\n"];
    ];
    OutputASingleHTMLCategory[aMono,anArray,stream,nccpolys,n,j];
  ,{j,1,Length[monomials]}];
];
