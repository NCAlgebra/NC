Clear[MultipleMmaToDoc,MmaToDoc,MmaToDocHelper];
Clear[ProcessStringForTeX,ProcessUsageStatement]; 
Clear[NCSelectBasedOnPriorityHelper,NCSelectBasedOnPriority];

MultipleMmaToDoc::usage = 
  "MultipleMmaToDoc[str] produces Doc*.tex files in the directory \
described by str corresponding to the \
contexts available via $ContextPath except for Global` and System`.\
If str is absent, str is \".\" (the current working directory). \
There is one option Priority. It should be set equal to a list \
of items whose priorities should match.";

MmaToDoc::usage = 
  "MmaToDoc[patt,fileName,theTitle] produces a file with filename  \
with a section with title theTitle and which have names \
satifying patt (e.g., \"Global`*\" or \"*Plot*\". Used via \
MultipleMmaToDoc";

MmaToDocHelper::usage =
  "MmaToDocHelper is an assistant of MmaToDoc";

ProcessStringForTeX::usage = 
  "If x is a string, then ProcessStringForTeX[x] returns the string\
with modification so that TeX will not choke. Otherwise, it returns x.";

ProcessUsageStatement::usage =  
  "If x is a symbol, then ProcessUsageStatement[x] returns a string\
corresponding to a ProcessStringForTeX-ified version of the usage  \
statement.";

NCSelectBasedOnPriorityHelper::usage = 
  "NCSelectBasedOnPriorityHelper is an assistant of NCSelectBasedOnPriority.";

NCSelectBasedOnPriority::usage = 
  "NCSelectBasedOnPriority[L,M] returns a list P such that
x is in P if and only if x is in L and L::priority is in M
or L::priority is not defined"; 

Options[MultipleMmaToDoc] = {Priority->{}};

MultipleMmaToDoc[opts___Rule] := MultipleMmaToDoc[".",opts]; 

MultipleMmaToDoc[suffix_String,opts___Rule] := 
Module[{x,i,prio},
  prio = Priority/.{opts}/.Options[MultipleMmaToDoc];
  x = $ContextPath;
  x = Complement[x,{"Global`","System`"}];
  y = Map[StringTake[#,StringLength[#]-1]&,x];
  Do[ MmaToDoc[StringJoin[x[[i]],"*"],
               StringJoin[suffix,"/Doc",y[[i]],".tex"],
               y[[i]],prio];
  ,{i,1,Length[x]}];
];

MultipleMmaToDoc[x___] := BadCall["MultipleMmaToDoc",x];

NCSelectBasedOnPriorityHelper[x_Symbol,M_List] := 
  Or[Not[Head[x]===String],MemberQ[M,MessageName[x,"priority"]]];

NCSelectBasedOnPriorityHelper[x___] := BadCall["NCSelectBasedOnPriorityHelper",x];

NCSelectBasedOnPriority[L:{___String},M_List] := 
  Select[L,NCSelectBasedOnPriorityHelper[ToExpression[#],M]&];

NCSelectBasedOnPriority[x___] := BadCall["NCSelectBasedOnPriority",x];
  

MmaToDoc[s_String,file_String,title_String,prio_List] := 
Module[{L},
  WriteString[file,"\\section{",title,"}\n\n"];
  L = Names[s];
  L = NCSelectBasedOnPriority[L,prio];
  L = Complement[L,{"dotex","DoTeX"}];
  Map[MmaToDocHelper[#,file]&,L];
];

MmaToDoc[x___] := BadCall["MmaToDoc",x];

ProcessUsageStatement[name_String] := 
Module[{str},
  str = StringJoin["MessageName[",name,",\"usage\"]"];
  str = ToExpression[str];
  Return[ProcessStringForTeX[str]];
];

ProcessUsageStatement[x___] := BadCall["ProcessUsageStatement",x];

ProcessStringForTeX[str_String] := 
Module[{y,z,done},
  y = StringReplace[str,{ "_" -> "\\_",
     "{"->"\\mbox{$\\{$}",
     "}"->"\\mbox{$\\}$}",
     "->"->"\\mbox{$\\rightarrow$}",
     "&"->"\\&",
     "^"->"\\^",
     "$"->"\\$",
     "%"->"\\%"
  }];
  z = Null;
  done = False;
  While[Not[done],
    z = StringReplace[y,{" \n"->"\n","\n\n"->"\n"}];
    done = z===y;
    y = z;
  ];
  Return[y];
];

ProcessStringForTeX[str_] :=  ToString[str];

ProcessStringForTeX[x___] := BadCall["ProcessStringForTeX",x];

MmaToDocHelper[name_String,file_String] := 
Module[{},
  WriteString[file,"\\CommandEntry\n"];
  WriteString[file,"{",name,"}\n"];
  WriteString[file,"{None}\n"];
  WriteString[file,"{",ProcessUsageStatement[name],"}\n"];
  WriteString[file,"{Unknown}\n"];
  WriteString[file,"{Unknown}\n"];
  WriteString[file,"\\labelindex{command:",
                    ProcessStringForTeX[name],"}\n\n"];
];

MmaToDocHelper[x___] := BadCall["MmaToDocHelper",x];
