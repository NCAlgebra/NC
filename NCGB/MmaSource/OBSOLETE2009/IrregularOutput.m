(* This file takes a RegularOutput file and a list of polynomials   *)
(* in any form. The polynomials are converted to rules, and their   *)
(* left hand side is compared to the ones in the RegularOutput file.*)
(* A new file is created with the polynomials inserted directly     *)
(* above the rules to which they correspond.                        *)

(* IrregularOutput["inputfilename",polynomials,"outputfilename"];   *)
(*  "inputfilename" is an existing RegularOutput filename.          *)
(*  polynomials is a list of polynomials in any form. That is, they *)
(*     can be factored or whatever.                                 *)
(*  "outputfilename" is the file that will be created.              *)

Clear[CreateFiles];
Clear[IrregularOutput];

(* Creates a file for each new polynomial. The name of the file is  *)
(* derived from the left hand side of the rule.                     *)

CreateFiles[polynomials_List]:=
Module[{poly,rule,str,filename,lhs},
  Do[
    poly=NCE[polynomials[[i]]]; 
    rule=PolyToRule[poly];
    lhs=rule[[1]];
    str=ToString[lhs]; 
    filename=StringReplace[str,{" "->"","*"->".","["->"_","]"->"_"}];
    Put[polynomials[[i]],filename];
    ,{i,Length[polynomials]}
  ];
  Return[];
];

CreateFiles[x___]:= BadCall["CreateFiles",x];

IrregularOutput[inputfile_String,polys_List,outputfile_String]:=
Module[{goodlist,startpos,blanks,file,line,nextline,newpoly,i,j,pos,newlist},
  CreateFiles[polys];

  (* grab the file up to the digesteds *)
  (* This will have to be changed when RegularOutput changes. *)
  goodlist=ReadList[inputfile,String];
  startpos=Position[goodlist,
         "========= UNDIGESTED RELATIONS APPEAR BELOW ===="][[1,1]];
 
  (* Remove excess blank lines         *)
  goodlist=Drop[goodlist,{startpos-7,startpos-6}];
  blanks=Position[goodlist,""];
  goodlist=Drop[goodlist,{blanks[[2,1]]}];

  (* Start new file. Paste in digesteds.  *)
  Put[OutputForm[ColumnForm[Take[goodlist,startpos]]],outputfile];

  Do[
    line=goodlist[[i]];
    nextline=goodlist[[i+1]];

    (* Remove excess blank lines.   *)
    If[Not[And[line=="",nextline==""]]
      ,PutAppend[OutputForm[line],outputfile];
    ];

    (* Only inspects certain lines to try to match files. *)
    If[And[Or[line=="---------------------------------------",line==""],
           Not[nextline==""],
           Not[StringTake[nextline,5]=="The e"]]
      ,file=nextline;
       j=1;

       (* Keeps adding lines until the string file contains entire lhs*)
       While[StringPosition[file,"-"]=={},
            file=StringJoin[file,goodlist[[i+1+j]]];
            j++;
       ];

       (* Cut off the left hand side. *)
       pos=StringPosition[file,"-",1][[1,1]]; 
       file=StringTake[file,pos-1];

       (* Make string match possible filename. *)
       file=StringReplace[file,{" "->"","*"->".","["->"_","]"->"_"}];

       If[FileType[file]==File
         ,newpoly=ReadList[file,String];
          (* Grab poly from file in string form and destroy file. *)
          DeleteFile[file];
          (* Remove spaces.     *)
          newpoly=Map[StringReplace[#," "->""]&,newpoly];
          (* Make one long string *)
          newpoly=Apply[StringJoin,newpoly];
          newlist={newpoly};
          
          (* Divide into strings of length 37. *)
          While[StringLength[newpoly]>37,
            newlist=Drop[newlist,-1];
            If[newlist=={}
              ,newlist={StringTake[newpoly,37],
                            StringDrop[newpoly,{1,37}]};
              ,newlist=Join[newlist,
                        {StringTake[newpoly,37]},
                        {StringDrop[newpoly,{1,37}]}];
            ];
            newpoly=StringDrop[newpoly,37];

            (* Make sure that indeterminants do not *)
            (* get divided between lines.           *)
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
          (* Were not placed by RegularOutput.             *)
          newlist=Map[StringInsert[#,"> ",1]&,newlist];
          (* Write polynomial and a blank line to the output file. *)
          PutAppend[OutputForm[ColumnForm[newlist]],outputfile];
          PutAppend[OutputForm[""],outputfile];
       ];
    ];
    ,{i,startpos+1,Length[goodlist]-1}
  ];
  Return[];
];

IrregularOutput[x___]:= BadCall["IrregularOutput",x];

