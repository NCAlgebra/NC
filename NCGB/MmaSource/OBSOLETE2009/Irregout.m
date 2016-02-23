  
CreateArray[polynomials_List,function_Symbol]:=
Module[{poly,rule,str,lhs},
  Do[
    poly=NCE[polynomials[[i]]]; 
    rule=PolyToRule[poly];
    str=ToString[rule]; 
    str=StringReplace[str," "->""];
    function[str]=polynomials[[i]];
    ,{i,Length[polynomials]}
  ];
  Return[];
];

CreateArray[x___]:= BadCall["CreateArray",x];

IrregularOutput[inputfile_String,polys_List,outputfile_String]:=
Module[{function,goodlist,startpos,stream,file,line,
        nextline,newpoly,i,j,pos,newlist,print},
  CreateArray[polys,function];
  (* grab the file up to the digesteds *)
  (* This will have to be changed when RegularOutput changes. *)
  goodlist=ReadList[inputfile,String];
  stream=OpenWrite[outputfile];
  print[string___String]:=WriteString[stream,string];
(*
  startpos=Position[goodlist,
         "================ MAY BE UNDIGESTED ============="][[1,1]];
 
*)
  (* Start new file. Paste in digesteds.  *)
  Print["Outputting results to the stream ",stream];
(*
  Apply[print,Map[StringInsert[#,"\n",-1]&,Take[goodlist,startpos+1]]];
*)

  Do[
    line=goodlist[[i]];
    If[i<Length[goodlist]
      ,nextline=goodlist[[i+1]];
    ]; 
    print[line,"\n"];
    (* Only inspects certain lines to try to match polynomials. *)
    If[And[line==="",Not[nexline==="---------------------------------------"]]
      ,lhsstring=nextline;
       j=1;
 
       (* Keeps adding lines until the string file contains entire lhs*)
       While[StringPosition[lhsstring,"-"]=={},
            lhsstring=StringJoin[lhsstring,goodlist[[i+1+j]]];
            j++;
       ];

       (* Cut off string. Keep just the left hand side. *)
       pos=StringPosition[lhsstring,"-",1][[1,1]]; 
       lhsstring=StringTake[lhsstring,pos-1];

       (* Make string match possible polynomial string. *)
       lhsstring=StringReplace[lhsstring," "->""];
       If[And[Head[function[lhsstring]]==String,
              Not[StringPosition[function[lhsstring],"("]=={}]]
         ,newpoly=function[lhsstring];
          
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
          (* Write polynomial and a blank line to the output file. *)
          Apply[print,Map[StringInsert[#,"\n",-1]&,newlist]];
          print["\n"];
       ];
    ];
    ,{i,Length[goodlist]}
  ];
  Close[stream];
  Print["Done outputting results to the stream ",stream];
  Return[];
];

IrregularOutput[x___]:= BadCall["IrregularOutput",x];
