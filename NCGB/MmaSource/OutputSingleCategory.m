(* OutputSingleCategory.m *)

(* :History :
	Who knows ?    Pre-=1996 effort 

	:9/9/99: Added category weight option to 
                           OutputASingleCategory[] (dell)

*)

Clear[OutputASingleCategory];
(* MAURICIO - BEGIN *)
(* Moved to OutputArrayForTeX *)
(* Clear[OutputASingleTeXCategory]; *)
(* MAURICIO - END *)

(* OUTPUT A SINGLE CATEGORY *)
(* Not used as far as we can tell *)
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
      If[Head[nccpolys[item]]===String
       , WriteStringNewLine[stream];
         WriteStringAux[stream,nccpolys[item]];
      ];
      If[Not[k==Length[rules]],WriteStringNewLine[stream]];
  ,{k,1,Length[rules]}];
];  (* END OutputASingleCategory *)

OutputASingleCategory[x___] := BadCall["OutputASingleTeXCategory",x];


(*******  MAIN FUNCTION IS HERE *********)

(* MAURICIO - BEGIN *)
(* Moved to OutputArrayForTeX *)
(* 
Options[ OutputASingleTeXCategory ]:= { CatWeight->-1 };

(* TeX output for a single category - Gets used over and over again
in the construction of a spreadsheet *)
OutputASingleTeXCategory[aMono_,anArray_,stream_,
                         nccpolys_,userselects_,ColumnWidth_, opts___Rule ]:=
Module[{knowns,k,str,rules,item,additionalFunction},

  rules = unmarkerAndDestroy[GetCategory[aMono,anArray]];

  weight = CatWeight/.{opts}/.Options[OutputASingleTeXCategory];
  
  additionalFunction = anArray["additionalFunction"];
  If[And[Not[Head[additionalFunction]===aMono],
         Not[additionalFunction==={}]],
     rules = additionalFunction[rules,anArray];
  ];
  knowns = Complement[GrabIndeterminants[rules],aMono];

  WriteString[stream,"\\rule[3pt]{",ColumnWidth,"in}{.7pt}\\\\\n"];

  (* Print the category weight *)
  If[ weight != -1,
     WriteString[stream, "$" ];
     If[ IntegerQ[ weight ],
	 weight = ToString[ weight ] <> ".0"
	 ];
     
     WriteString[stream, weight ];
     WriteString[stream, "$  "  ];
	 ]; 

  WriteString[stream,"The expressions with unknown variables "];
  (* MAURICIO - BEGIN *)
  (* 
  WriteString[stream, ToStringForTeXList[aMono]];
  *) 
  WriteString[stream, "$", NCTeXForm[aMono], "$"];
  (* MAURICIO - END *)
  WriteString[stream,"\\\\\n"];

  WriteString[stream,"and knowns "];
  (* MAURICIO - BEGIN *)
  (*
  WriteString[stream, ToStringForTeXList[knowns],"\\smallskip\\\\\n"];
  *)
  WriteString[stream, "$", NCTeXForm[knowns], "$\\smallskip\\\\\n"];
  (* MAURICIO - END *)

  Do[item = rules[[k]];

     (* MAURICIO - BEGIN *)
     (*
     WriteString[stream,"\\begin{minipage}{",ColumnWidth,"in}\n$\n"];
     *)
     WriteString[stream,"$"];
     (* MAURICIO - END *)

     If[MemberQ[userselects,item]
       ,WriteString[stream,"\\Uparrow\\ \n"];
     ];

     (* MAURICIO - BEGIN *)
     (*
     If[Head[nccpolys[item]]===String
       ,WriteString[stream,ToStringForTeX[nccpolys[item]]];
       ,WriteString[stream,ToStringForTeX[item]];
        If[Not[Head[item]===Rule]
          ,WriteString[stream,"==0"];
        ];
     ];
     *)
     If[Head[nccpolys[item]]===String
       ,WriteString[stream, NCTeXForm[nccpolys[item]]];
       ,WriteString[stream, NCTeXForm[item]];
        If[Not[Head[item]===Rule]
          ,WriteString[stream,"==0"];
        ];
     ];
     (* MAURICIO - END *)

     (* MAURICIO - BEGIN *)
     (*
     If[Not[k==Length[rules]]
       ,WriteString[stream,"\n$\n\\end{minipage}\\medskip \\\\\n"];
       ,WriteString[stream,"\n$\n\\end{minipage}\\\\\n"];
     ];
     *)
     WriteString[stream,"$\\\\\n"];
     (* MAURICIO - END *)

  ,{k,1,Length[rules]}];
];   (* END OutputASingleTeXCategory *)

OutputASingleTeXCategory[x___] := 
    BadCall["OutputASingleTeXCategory",x];
*)
(* MAURICIO - END *)
