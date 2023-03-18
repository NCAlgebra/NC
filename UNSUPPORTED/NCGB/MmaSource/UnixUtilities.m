BeginPackage["UnixUtilities`","Errors`"];

Clear[Diff,DiffListQuick,DiffLists,EGrepList,EGrepListV,FileToStrings,
RecursiveReadList,ExpandDollars,GrabBefore,GrabAfter,QuietDeleteFile,
CatListToFile];

Diff::usage = 
  "Diff[x,y] (where x and y are filenames) returns True if the \
files are the same and a list of the elements of the form \
{m,n,p,q,L,M} where lines m through n of the file x are in the \
list L and lines p through q of the file y are in the list M.\
If one removes the idicated lines from each file, \
then the files are the same.";

DiffListsQuick::usage = "";

DiffLists::usage = "";

EGrepList::usage = "";

EGrepListV::usage = "";

FileToStrings::usage = "";

RecursiveReadList::usage = "";

ExpandDollars::usage = "ExpandDollars";

GrabBefore::usage = "";

GrabAfter::usage = "";

QuietDeleteFile::usage = "";

CatListToFile::usage = "";

Begin["`Private`"];

FileToStrings[x_String] :=
Module[{result={}},
  If[Length[FileNames[x]]>0
     , result = ReadList[x,String];
  ];
  Return[result];
];

FileToStrings[x___] := BadCall["FileToStrings",x];

Diff[x_String,y_String] :=  DiffLists[FileToStrings[x],FileToStrings[y]];

Diff[x___] := BadCall["Diff",x];

DiffListsQuick[L_String,M_String] := L===M;

DiffListsQuick[x___] := BadCall["DiffListsQuick",x];

DiffLists[L_List,M_List] := 
Module[{result = True,X = {},m = Length[L],n = Length[M],sm },
  sm = Min[m,n];
  Do[ If[Not[L[[i]]===M[[i]]]
        , AppendTo[X,{i,i,i,i,{L[[i]]},{M[[i]]}}];
       ];
  ,{i,1,sm}];
  If[Not[X==={}]
    , result = X;
  ];
  Return[result];
];

DiffLists[x___] := BadCall["DiffLists",x];

EGrepList[L:{___String},pa_String]  := Select[L,StringMatchQ[#,pa]&];

EGrepList[x___] := BadCall["EGrepList",x];

EGrepListV[L:{___String},pa_String] := Select[L,Not[StringMatchQ[#,pa]]&];

EGrepListV[x___] := BadCall["EGrepListV",x];

RecursiveReadList[x_String,expander_,fileNameGetter_] := 
Module[{L = FileToStrings[x],result = {},i,item,name},
  Do[item = L[[i]];
    If[expander[item]
      , name = fileNameGetter[item];
        result  = Join[result,RecursiveReadList[name,expander,fileNameGetter]];
      , AppendTo[result,item];
    ];
  ,{i,1,Length[L]}];
  Return[result];
];

RecursiveReadList[x___] := BadCall["RecursiveReadList",x];

SpaceSeperatedToList[x_String] := 
Module[{L = StringPosition[x," "],st=1,en,i,result={}},
  Do[ en = L[[i,1]]-1;
      AppendTo[result,StringTake[x,{st,en}]];
      st = en + 2;
  ,{i,1,Length[L]}];
  st = StringTake[x,{st,StringLength[L]}];
  If[Not[st===""]
    , AppendTo[result,st];
  ];
  Return[result];
];

SpaceSeperatedToList[x___] := BadCall["SpaceSeperatedToList",x];

ExpandDollars[x_String,ru:{___Rule}] := 
Module[{},
  result = FixedPoint[StringReplace[#,ru]&,x];
  Return[result];
];

ExpandDollars[x___] := BadCall["ExpandDollars",x];

GrabBefore[x_String,sub_String] :=
Module[{L = StringPosition[x,sub],result},
  If[L==={}
    , result = x;
    , result = StringTake[x,L[[1,1]]-1];
  ];
  Return[result];
];

GrabBefore[x___] := BadCall["GrabBefore",x];

GrabAfter[x_String,sub_String] :=
Module[{L = StringPosition[x,sub],result},
  If[L==={}
    , result = x;
    , result = StringTake[x,{L[[-1,1]]+1,StringLength[x]}];
  ];
  Return[result];
];

GrabAfter[x___] := BadCall["GrabAfter",x];

QuietDeleteFile[x_String] := 
  With[{val = FileNames[x]},
    If[Length[val]>1
      , Print["Warning: deleting the files ",val];
        Input["Type something here (like a number)"];
    ];
    Map[DeleteFile,val];
  ];

QuietDeleteFile[x___] := BadCall["QuietDeleteFile",x];

CatListToFile[L:{___String},x_String] :=  (
  QuietDeleteFile[x];
  Map[PutAppend[#,x]&,L];
);

CatListToFile[x___] := BadCall["CatListToFile",x];
   
End[];
EndPackage[]
