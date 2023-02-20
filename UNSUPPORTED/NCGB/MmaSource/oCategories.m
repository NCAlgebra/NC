(* oCreateCategories.m *)

(* History 

	:9/1/1999:  Changed CreateCategories[] to support NCProcess option  UserUnknowns.
		  Introduced "knownGrade" (dell)  
*)

(*  This is the main file which deals with categories *)

Clear[CreateCategories];

CreateCategories::usage =
     "CreateCategories[aListOfRelations,x] stores aListOfRelations \
      in the array associated to the function associated to the \
      symbol x in terms of the notion of categories.";

Clear[GetCategories];

GetCategories::usage=
     "GetCategories[aListOfVars,x] returns the category corresponding \
      to the list aListOfVars. Code assumes that
      CreateCategories[x,aListOfRelations] was called in the past
      for some list of relations aListOfRelations.";

Clear[GetCategory];

GetCategory::usage=
     "GetCategory is an alias for GetCategories.";

Options[CreateCategories] = {OutputToFile->False,KnownGrading->1};

(* CreateCats *) 
CreateCategories[x:GBMarker[_Integer,"factcontrol"],
                 relations_Symbol] :=
Module[{ints},
  ints = WhatAreGBNumbers[];
  ints = sendMarkerList["integers",ints];
  CreateCategories[x,ints,relations];
  Global`DestroyMarker[ints];
];

CreateCategories[x:GBMarker[_Integer,"factcontrol"],  
                 y:GBMarker[_Integer,"integers"],
                 relations_Symbol] :=
Module[{mark},
  mark = Global`CPPCreateCategories[y,x];
  regularOutput[mark];
  DestoryMarker[mark];
];

CreateCategories[x:GBMarker[_Integer,"categoryFactories"],
                 relations_Symbol] :=
Module[{catTuples,len,i,tuple,vars,n,alllengths,allind,
        unk,kn,save,TEMP,totalvars,mark},

save = disabledMarkers;
disabledMarkers = True;

  unk = Flatten[Table[WhatIsSetOfIndeterminants[j]
                     ,{j,2,WhatIsMultiplicityOfGrading[]}
                     ],1];

  kn = WhatIsSetOfIndeterminants[1];
  relations["storage"] = GBMarker;
  relations["userSelects"] = sendMarkerList["rules",UserSelectRules[]];
  relations[_] = {};
  catTuples = Global`RetrieveCategoryMarkers[x];
  len = Length[catTuples];
  alllengths = {};
  allind = {};
  totalvars = {};
  Do[ tuple = catTuples[[i]];
      vars = SortMonomials[tuple[[2]]];
      n = Length[vars];
      AppendTo[alllengths,n];
      AppendTo[relations[n],vars];
      relations[SortMonomials[Intersection[vars,unk]]] = tuple[[3]];
      relations["knowns",vars] = tuple[[1]];
      AppendTo[allind,vars];
      AppendTo[totalvars,tuple[[1]]];
  ,{i,1,len}];
  totalvars = Flatten[Union[{allind,totalvars}]];
  relations["singleRules"] = unmarkerAndDestroy[singleRules[x]];
  relations["singleVars"] = unmarkerAndDestroy[singleVariables[x]];

  alllengths = Union[alllengths];
  relations["numbers"] = alllengths;
  allind = Union[allind];
  relations["AllCategories"] = allind;

  relations["nonsingleVars"] = Complement[Union[unk,kn],
                                          relations["singleVars"]];
  Return[relations];
];

CreateCategories[relations_Symbol] :=
Module[{fc,ints,mark},
  fc = SaveFactControl[];
  ints = WhatAreGBNumbersMarker[fc];
  mark = CPPCreateCategories[ints,fc];
  CreateCategories[mark,relations];
  DestroyMarker[{ mark, fc,ints} ];
disabledMarkers = save;
  Return[relations];
];

CreateCategories[aList_List,relations_Symbol,opts___Rule] :=
Module[{i,len,item,vars,kn,unk,n,alllengths,rules,
        allvars,allind,j,totalvars,outputToFile,fileName},
  Clear[relations];
  Clear[allvars];
  relations["storage"] = List;

  relations[_] := {};
  relations["All"] = aList;
  relations["userSelects"] = UserSelectRules[];
  outputToFile = OutputToFile/.{opts}/.Options[CreateCategories];
  knownGrade = KnownGrading/.{opts}/.Options[CreateCategories]; 
  If[outputToFile
    , fileName = FileName/.{opts};
      If[Head[fileName]===Symbol
          , Print["Specified OutputToFile-> ...  but not FileName-> ..."]; 
            BadCall["CreateCategories",aList,relations,opts];
      ];
    , If[Not[FreeQ[{opts},FileName]]
       , Print["Specified FileName-> ... but not OutputToFile-> ... "]; 
         BadCall["CreateCategories",aList,relations,opts];
      ];
  ];

  unk = Flatten[Table[WhatIsSetOfIndeterminants[j]
                     ,{j,knownGrade+1,WhatIsMultiplicityOfGrading[]}
                     ],1];

  kn = Flatten[Table[WhatIsSetOfIndeterminants[j]
                     ,{j,1,knownGrade}
                     ],1];

  alllengths = {};
  allind = {};
  totalvars = {};
  rules = Union[ExpandNonCommutativeMultiply[aList]];
  rules = PolyToRule[rules];
  rules = Union[rules];
  len   = Length[rules];
  If[Global`wantCreateCategoriesOutput
    , Print["Going to do ",len," iterations."]; 
  ];
  Do[item = rules[[i]];
     If[Global`wantCreateCategoriesOutput
       , Print[" ",i];
     ];
     If[Not[item===0]
       , vars = GrabIndeterminants[item];
         vars = SortMonomials[Intersection[vars,unk]];
         AppendTo[allind,vars];

	(* If the head is NCM it's not a singleton !! *)
         If[Head[item[[1]]]===NonCommutativeMultiply
            , AppendTo[relations[vars],item];
              n = Length[vars];
              AppendTo[relations[n],vars];
              AppendTo[alllengths,n];
              allvars[i] = vars;
            , AppendTo[relations["singleVars"],item[[1]]];
              AppendTo[relations["singleRules"],item];
              allvars[i] = Null;
         ];
         AppendTo[totalvars,vars];
       , allvars[i] = Null;
     ];
  ,{i,1,len}];

  relations["singleVars"] = Union[relations["singleVars"]];
(*
  relations["singleVars"] = Sort[relations["singleVars"],
                               CreateCategoryRightOrder];
*)
  alllengths = Flatten[alllengths];
  Do[ relations[alllengths[[j]]] = Union[relations[alllengths[[j]]]];
  ,{j,1,Length[alllengths]}];
  allind = Union[Flatten[allind]];
  relations["numbers"] = alllengths = Sort[Union[alllengths]];
  relations["AllCategories"] = Table[allvars[i],{i,1,len}];
  relations["AllCategories"] = Complement[relations["AllCategories"],
                                          {Null}];
  relations["AllCategories"] = Union[relations["AllCategories"]];
  len= Length[totalvars];

  Do[ vars = totalvars[[i]];
(*
      relations[vars] = SortRelations[ToGBRule[relations[vars]]];
*)
      relations[vars] = ToGBRule[relations[vars]];

  ,{i,1,len}];

  relations["nonsingleVars"] = Complement[Union[kn,unk],
                                 relations["singleVars"]];
  If[outputToFile
     , Put[Definition[relations],fileName];
  ];

  Return[relations];
];

(*
 * Do create categories with the specified factcontrol.
 *)

CreateCategories[relations_Symbol,
       r:Rule[CategorySource,GBMarker[_Integer,"factcontrol"]]] :=
Module[{fc,ints,mark,trash},
  fc = r[[2]];
  If[Not[fc[[2]]==="factcontrol"]
    , BadCall["CreateCategories",relations,CategorySource->fc];
  ];
  ints = RecordMarkerForDelete[WhatAreGBNumbersMarker[fc],trash];
  mark = RecordMarkerForDelete[CPPCreateCategories[ints,fc],trash];
  CreateCategories[mark,relations];
  DeleteRecordedMarkers[trash];
];

CreateCategories[x___] := BadCall["CreateCategories",x];

CreateCategoryRightOrder[x_,y_] := 
Module[{first,second},
  first = PolyToRule[x][[1]];
  second = PolyToRule[y][[1]];
  Return[PolyToRule[first-second][[1]]===first];
];
(* END  CreateCategories binge *) 


(* Start GetCategory stuff *)
GetCategory[x___] := GetCategories[x];

GetCategories[aList_List,x_Symbol] := 
Module[{result},
  result = x[aList];
  If[result==={}
    , result = x[SortMonomials[aList]];
  ];
  If[result==={}
    , Print["Warning: GetCategory is returning an empty list"];
  ];
  If[Not[x["storage"]===List]
    , result = FixGetCategory[result];
  ];
  result = FixGetCategory2[result];
  Return[result];
];

GetCategories[aString_String,x_Symbol] := 
Module[{temp,listtype,done,result,allVars,vars,i,arr,cnt},
  done = False;
  listtype = x["storage"]===List;
  If[And[Not[done],
         Or[aString==="Undigested",
            aString==="Unknowns",
            aString==="undigestedRules"]
        ]
      , If[listtype
          , Clear[arr]; 
            done = True;
            cnt = 0;
            allVars = x["AllCategories"];
            Do[ vars = allVars[[i]];
                If[Not[vars==={}],
                    cnt = cnt + 1;
                    arr[cnt] = Select[x[vars],
                         (Head[#[[1]]]===NonCommutativeMultiply)&];
            ];
            ,{i,1,Length[allVars]}];
            result = Apply[Union,Table[arr[i],{i,1,cnt}]];
            Clear[arr];
          , BadCall["GetCategories",aString,x];
       ];
  ];
  If[And[Not[done],
         Or[aString=="Digested",aString=="digestedRules"]
        ]
      , If[listtype
          , result = Join[x[{}],x["singleRules"],x["userSelects"]];
          , result = FixGetCategory[x[{}]];
            temp = FixGetCategory[x["singleRules"]];
            AppendMarker[result,temp];
            temp = FixGetCategory[x["userSelects"]];
            AppendMarker[result,temp];
        ];
        done = True;
  ];
  If[And[Not[done],Or[aString=="Knowns",aString=="knownsRules"]]
      , If[listtype
          , result = x[{}];
          , result = FixGetCategory[x[{}]];
        ]; 
        done = True;
  ];
  If[And[Not[done],aString=="digestedLabels"]
      , result = {{}};
        done = True;
  ];
  If[And[Not[done],aString=="knownsLabels"]
      , result = {{}};
        done = True;
  ];
  If[And[Not[done],aString=="singleRules"]
      , If[listtype
          , result = x["singleRules"];
          , result = FixGetCategory[x["singleRules"]];
        ];
        done = True;
  ];
  If[Not[done], 
     result = x[aString];
     If[Not[listtype]
       , result = FixGetCategory[result];
         If[result==={}
           , Print["*** Possible spelling error *** "];
             Print["GetCategories will return the empty list"];
             Print["corresponding to the string: ".aString];
         ];
     ];
  ];
(* THE BIG BUG
*)
  result = FixGetCategory2[result];
  Return[result];
];

GetCategories[x___] := BadCall["GetCategories",x];

(***** END GetCategories  ******)


FixGetCategory[{}] := CreateMarker["rules"];
FixGetCategory[x_GBMarker] := CopyMarker[x,"rules"];
FixGetCategory[x_] := x;

FixGetCategory[x___] := BadCall["FixGetCategory",x];

FixGetCategory2[x_GBMarker] := 
Module[{result,temp},
  result = x;
  If[Head[result]===GBMarker
    , temp = internalSortRelations[result];
      Global`DestroyMarker[result];
      result = temp;
  ];
  Return[result];
];

FixGetCategory2[x_] := x;

FixGetCategory2[x___] := BadCall["FixGetCategory2",x];
  

