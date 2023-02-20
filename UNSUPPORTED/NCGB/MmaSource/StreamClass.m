(*
WriteStringSet[stream,string]
InitializeStreamClass[stream]
InitializeStreamClass[stream,Option]
WriteStringNewLine[stream]
WriteStringBeginVerbatim[stream]
WriteStringEndVerbatim[stream]
WriteStringFlush[stream] 
WriteStringAppend[stream,string] 
WriteStringAux[stream,x] 
MyNCUnMonomial[x]
*)
Clear[WriteStringSet];
Clear[InitializeStreamClass];
Clear[WriteStringNewLine];
Clear[WriteStringBeginVerbatim];
Clear[WriteStringEndVerbatim];
Clear[WriteStringFlush] ;
Clear[WriteStringAppend] ;
Clear[WriteStringAux] ;
Clear[MyNCUnMonomial];

WriteStringSet[stream_,string_] := 
    (WriteStringFlush[stream];$$WriteString[stream] = string;);

InitializeStreamClass[stream_] := InitializeStreamClass[stream,Ascii];

InitializeStreamClass[stream_,Option_] := 
    ( $$WriteStringOption = Option;
      $$WriteString[stream] = "";
      $$OptionStack = {};);

WriteStringNewLine[stream_] :=
  ( WriteStringFlush[stream]; WriteString[stream,"\n"]);

WriteStringNewLine[x___] := BadCall["WriteStringNewLine",x];


WriteStringBeginVerbatim[stream_] := 
  ( WriteString[stream,"\\begin{verbatim}\n"];
    AppendTo[$$OptionStack,$$WriteStringOption];
    $$WriteStringOption=Ascii;
  );

WriteStringBeginVerbatim[x___] := BadCall["WriteStringBeginVerbatim",x];

WriteStringEndVerbatim[stream_] := 
  ( WriteString[stream,"\\end{verbatim}\n"];
    If[Length[$$OptionStack]==0
       , Print["ERROR in WriteStringEndVerbatim."];
         Print["Mismatched verbatims"];
         BadCall["WriteStringEndVerbatim"];
    ];
    $$WriteStringOption = $$OptionStack[[-1]];
    $$OptionStack = Take[$$OptionStack,{1,-2}];
  );

WriteStringEndVerbatim[x___] := BadCall["WriteStringEndVerbatim",x];

WriteStringFlush[stream_] := 
   If[Not[$$WriteString[stream]===""]
       , WriteString[stream,$$WriteString[stream]];
         $$WriteString[stream]="";
   ];

WriteStringFlush[x___] := BadCall["WriteStringFlush",x];

$$WriteStringMaxLength = 65;

WriteStringAppend[stream_,string_] := 
Module[{str,len},
  str = ToString[string];
  len = StringLength[str];
  If[StringLength[str] > $$WriteStringMaxLength
      , WriteStringNewLine[stream];
        $$WriteString[stream] = str;
        WriteStringNewLine[stream];
      , If[StringLength[$$WriteString[stream]]+len > $$WriteStringMaxLength
         , WriteStringNewLine[stream];
           $$WriteString[stream] = str;
         , $$WriteString[stream] = StringJoin[$$WriteString[stream],str];
        ];
  ];
];

WriteStringAppend[x___] := BadCall["WriteStringAppend",x];

WriteStringAux[stream_,x_Rule] := 
   ( WriteStringAux[stream,x[[1]]];
     If[$$WriteStringOption===TeX
        , WriteStringAppend[stream," \\rightarrow "];
        , WriteStringAppend[stream,"->"];
     ];
     WriteStringAux[stream,x[[2]]];);

WriteStringAux[stream_,x_Plus] := 
Module[{k,plus},
   Do[ WriteStringAux[stream,x[[k]]];
       WriteStringAppend[stream," + "];
   ,{k,1,Length[x]-1}];
   WriteStringAux[stream,x[[-1]]];
];

WriteStringAux[stream_,poly_String] := 
Module[{newpoly,newlist},
  newpoly=poly;
          
  (* newlist is a list of strings. Each one is about 62 characters *)
  newlist={newpoly};
          
  (* Divide into strings of length 62. *)
  While[StringLength[newpoly]>62,
    newlist=Drop[newlist,-1];
    If[newlist=={}
      ,newlist={StringTake[newpoly,62],
                    StringDrop[newpoly,{1,62}]};
      ,newlist=Join[newlist,
                {StringTake[newpoly,62]},
                {StringDrop[newpoly,{1,62}]}];
    ];
    newpoly=StringDrop[newpoly,62];

    (* Make sure that indeterminants do not *)
    (* get divided between lines.           *)
    If[StringTake[newlist[[-2]],{-1}]=="("
      ,newlist[[-2]]=StringDrop[newlist[[-2]],-1];
       newlist[[-1]]=StringInsert[newlist[[-1]],"(",1];
       newpoly=StringInsert[newpoly,"(",1];
      ];
    If[StringTake[newlist[[-1]],{1}]==">"
      ,newlist[[-2]]=StringInsert[newlist[[-2]],">",-1];
       newlist[[-1]]=StringDrop[newlist[[-1]],1];
       newpoly=StringDrop[newpoly,1];
      ];
    While[Not[Or[StringTake[newlist[[-2]],{-1}]=="+",
                 StringTake[newlist[[-2]],{-1}]=="-",
                 StringTake[newlist[[-2]],{-2,-1}]=="**",
                 StringTake[newlist[[-1]],{1}]=="+",
                 StringTake[newlist[[-1]],{1}]=="-",
                 StringTake[newlist[[-1]],{1,2}]=="**"
                ]
             ]
              ,newlist[[-2]]=StringJoin[newlist[[-2]],
                        StringTake[newlist[[-1]],{1}]];
       newlist[[-1]]=StringDrop[newlist[[-1]],1];
       newpoly=StringDrop[newpoly,1];
    ];
  ]; 
  (* Insert a marker to denote the new polynomials *)
  (*      were not placed by RegularOutput.        *)
  newlist=Map[StringInsert[#,"> ",1]&,newlist];
  newlist=Map[StringInsert[#,"\n",-1]&,newlist];
  Apply[WriteString,Join[{stream},newlist]];
  Return[];
];

WriteStringAux[stream_,x_List] := 
Module[{k},
  If[$$WriteStringOption===TeX
    , WriteStringAppend[stream," \\{ "];
    , WriteStringAppend[stream,"{"];
  ];
  Do[ WriteStringAux[stream,x[[k]]];
      WriteStringAppend[stream,","];
      If[$$WriteStringOption==TeX, WriteStringNewLine[stream]];
  ,{k,1,Length[x]-1}];
  If[Length[x]>0, WriteStringAux[stream,x[[-1]]];];
  If[$$WriteStringOption===TeX
    , WriteStringAppend[stream," \\} "];
    , WriteStringAppend[stream,"}"];
  ];
];

WriteStringAux[stream_,x_Times] := 
Module[{i},
  If[x[[1]] == -1
      , WriteStringAppend[stream," -"];
      , WriteStringAux[stream,x[[1]]];
  ];
  Do[ WriteStringAux[stream,x[[i]]];
      If[$$WriteStringOption===TeX
           , WriteStringAppend[stream," \, "];
           , WriteStringAppend[stream,"  "];
      ];
  ,{i,2,Length[x]}];
];

WriteStringAux[stream_,x_NonCommutativeMultiply] := 
Module[{y,k},
   y = MyNCUnMonomial[x];
   Do[ WriteStringAux[stream,y[[k]]];
       If[$$WriteStringOption===TeX
          , WriteStringAppend[stream," \, "];
          , WriteStringAppend[stream,"**"];
       ];
   ,{k,1,Length[y]-1}];
   WriteStringAux[stream,y[[-1]]];
];

MyNCUnMonomial[x_NonCommutativeMultiply] :=
Module[{tempb,tempp,result,i,j},
  tempb[1] = x[[1]];
  tempp[1] = 1;
  j = 1;
  Do[ If[x[[i]]===tempb[j]
         , tempp[j] = tempp[j]+1;
         , j = j+1;
           tempb[j] = x[[i]];
           tempp[j] = 1;
      ];
  ,{i,2,Length[x]}];
  result = Table[tempb[i]^tempp[i],{i,1,j}];
  Return[result];
];

MyNCUnMonomial[x___] := BadCall["MyNCUnMonomial",x];

WriteStringAux[stream_,x_?(Length[#]>0)&] := 
Module[{k},
   WriteStringAux[stream,Head[x]];
   WriteStringAppend[stream,"["];
   Do[ WriteStringAux[stream,x[[k]]];
       WriteStringAppend[stream,","];
   ,{k,1,Length[x]-1}];
   WriteStringAux[stream,x[[-1]]];
   WriteStringAppend[stream,"]"];
];


WriteStringAux[stream_,x_] := 
    If[$$WriteStringOption===TeX
        ,WriteStringAppend[stream,ToString[Format[x,TeXForm]]];
        ,WriteStringAppend[stream,ToString[Format[x,InputForm]]];
    ];

WriteStringAux[x___] := BadCall["WriteStringAux",x];

BeginHeader[stream_] := Null;
EndHeader[stream_] := Null;
BeginHeader[stream,TeX] := WriteStringBeginVerbatim[stream];
EndHeader[stream,TeX] := WriteStringEndVerbatim[stream];
