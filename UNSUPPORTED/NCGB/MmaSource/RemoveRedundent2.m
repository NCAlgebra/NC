(*
Print["This is the experimental file"];
Print["This is the experimental file"];
Print["This is the experimental file"];
Print["This is the experimental file"];
Print["This is the experimental file"];
*)
(* :Title: 	RemoveRedundent // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus) *)

(* :Context: 	RemoveRedundent` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
*)

BeginPackage["RemoveRedundent`","Errors`"];

Clear[RemoveRedundent];

RemoveRedundent::usage = 
     "RemoveRedundent is the old form RemoveRedundant";

Clear[RemoveRedundant];

RemoveRedundant::usage = 
     "RemoveRedundant";

Clear[RemoveRedundentUseNumbers];

RemoveRedundentUseNumbers::usage =
     "RemoveRedundentUseNumbers is an option form of RemoveRedundantUseNumbers";

Clear[RemoveRedundantUseNumbers];

RemoveRedundantUseNumbers::usage =
     "RemoveRedundentUseNumbers is an option for RemoveRedundent";

Clear[RemoveRedundentProtected];

RemoveRedundentProtected::usage =
     "RemoveRedundentProtected is an outdated form of RemoveRedundantProtected";

Clear[RemoveRedundantProtected];

RemoveRedundantProtected::usage =
     "RemoveRedundantProtected is an option for RemoveRedundant";

Begin["`Private`"];

Clear[RedListToArray];
Clear[AskParents];
Clear[AskParentsAux];

RedListToArray[history_List,parents_Symbol,
               data_Symbol,reversedata_Symbol] :=
Module[{len,i,num,item},
   len = Length[history];
   Clear[parents];
   Clear[data];
   Do[ item = history[[i]];
       num = item[[1]];
       parents[num] = Flatten[{item[[3]],item[[4]]}];
       parents[num] = Union[Map[Abs,parents[num]]];
       data[item[[2]]] = num;
       reversedata[num] = item[[2]];
   ,{i,1,len}];
(*
Print["parents:",System`Information[parents]];
Print["data:",System`Information[data]];
Print["reversedata:",System`Information[reversedata]];
*)
   Return[];
];

RedListToArray[history_List,parents_Symbol] :=
Module[{len,i,num,item},
   len = Length[history];
   Clear[parents];
   Do[ item = history[[i]];
       num = item[[1]];
       parents[num] = Flatten[{item[[3]],item[[4]]}];
       parents[num] = Union[Map[Abs,parents[num]]];
   ,{i,1,len}];
(*
Print["parents:",System`Information[parents]];
*)
   Return[];
];

RedListToArray[x___] := BadCall["RedListToArray",x];

AskParents[aNumber_?NumberQ,parents_Symbol,desiredNumbers_List] :=
Module[{result},
  result = True;
  children = parents[aNumber];
  If[Head[children]===parents
     , Print["A full history was not given!!!"];
       Print["Perhaps you used WhatAreGBNumbers rather than"];
       Print["WhatAreNumbers????"];
       BadCall["AskParents",aNumber,parents,desiredNumbers];
  ];
  children = Union[Map[Abs,children]];
  len = Length[children];
  For[i=1,i<=len && result===True,i++,
     result = AskParentsAux[children[[i]],parents,desiredNumbers];
  ];
(*
Print["AskParents:",aNumber,":",parents,":",desiredNumbers,"::",
      result,":::",children];
*)
  Return[result];
];

AskParentsAux[aNumber_?NumberQ,parents_Symbol,desiredNumbers_List] :=
Module[{children,result,len,i},
  Which[aNumber==0, result = False;
      , MemberQ[desiredNumbers,aNumber], result = True;
      , True, 
          result = True;
          children = parents[aNumber]; 
  If[Head[children]===parents
     , Print["A full history was not given!!!"];
       Print["Perhaps you used WhatAreGBNumbers rather than"];
       Print["WhatAreNumbers????"];
       BadCall["AskParents",aNumber,parents,desiredNumbers];
  ];
          children = Union[Map[Abs,children]]; 
          len = Length[children];
          For[i=1,i<=len && result===True,i++,   
             result = AskParentsAux[children[[i]],parents,
                                    desiredNumbers];
          ];
  ];
(*
Print["AskParentsAux:",aNumber,":",parents,":",desiredNumbers,"::",
      result,":::",children];
*)
  Return[result];
];
      
AskParents[x___] := BadCall["AskParents",x];

RemoveRedundent[x___] := RemoveRedundant[x];

Options[RemoveRedundant] = {
     Testing->False,
     RemoveRedundentUseNumbers -> False,
     RemoveRedundantUseNumbers -> False,
     RemoveRedundentProtected->{},
     RemoveRedundantProtected->{}
   };

Options[RemoveRedundent] = Options[RemoveRedundant];

RemoveRedundant[] :=
Module[{fullhist,hist,polys},
  fullhist = MoraAlg`WhatIsHistory[Global`WhatAreNumbers[]];
  hist = MoraAlg`WhatIsHistory[Global`WhatAreGBNumbers[]];
  polys = Map[(#[[2]])&,fullhist];
  Return[RemoveRedundant[polys,fullhist]];
];

(* 
   actualdata can be either a list of polynomials or 
   a list of numbers based upon whether RemoveRedundentUseNumbers->True
   or RemoveRedundentUseNumbers->False
*)
RemoveRedundant[GBMarker[m_,"history"]] :=
    Global`internalMarkerRemoveRedundent[m];

RemoveRedundent[actualdata_List,history_List,opts___Rule] :=
Module[{checkHistory,nums,data,par,rdata,ans,ans1,
        ansnums,oldnums,protect,test},

   (* Set the Testing option *)
   test = Testing/.{opts}/.Options[RemoveRedundant];

   (* Set the RemoveRedundantUseNumbers option *)
   nums = RemoveRedundantUseNumbers/.{opts}/.Options[RemoveRedundant]; 
   If[Not[FreeQ[{opts},RemoveRedundentUseNumbers]]
     , Print["RemoveRedundentUseNumbers is an outdated form of RemoveRedundantUseNumbers"];
       nums = RemoveRedundentUseNumbers/.{opts}/.Options[RemoveRedundant];
   ];

   (* Set the RemoveRedundentProtected option *)
   protect = RemoveRedundentProtected/.{opts}/. Options[RemoveRedundent];
   If[Not[FreeQ[{opts},RemoveRedundentProtected]]
     , Print["RemoveRedundentProtected is an outdated form of RemoveRedundantProtected"]; 
       protect = RemoveRedundentProtected/.{opts}/.Options[RemoveRedundant];
   ];

   (* The main loop *)
   If[nums
     , If[test
         , Print["Computing the first way!"];
           RedListToArray[history,par]; 
           oldnums = actualdata;
           ans1 = RemoveRedundantAux[oldnums,par,data,rdata,history];
           Clear[par];
           Print["Computing the second way!"];
       ];
       Print["Using C++ RemoveRedundant"];
       ans = Global`internalRemoveRedundent[actualdata,protect];
       If[test
         , If[Not[Sort[ans1]===Sort[ans]], 
             checkHistory = MoraAlg`WhatIsHistory[
                               Global`WhatAreNumbers[]
                                                 ];
             Print["Ahhh........"];
             If[Not[checkHistory===history]
               , Print["The history and current history do not agree"]; 
                 Print[Complement[history,checkHistory]];
                 Print[Complement[checkHistory,history]];
                 Exit[];
             ];
             Print["(mma)ans1 is ",ans1];
             Print["(c++)ans is ",ans];
             Put[history,"history.rr"];
             Exit[];
          ];
       ];
     , (* The non-numbers way *)
       If[Not[protect=={}]
        , Print[
            "RemoveRedundentProtected can't be used with equations"];
          Abort[];
       ];
       RedListToArray[history,par,data,rdata]; 
       oldnums = Union[Map[data,MoraAlg`ToGBRule[actualdata]]];
       ansnums = RemoveRedundantAux[oldnums,par,data,rdata,history];
       ans = Map[rdata,ansnums];
       ans=ans/.Rule->Subtract;
       Clear[data];
       Clear[rdata];
       Clear[par];
   ];
   Return[ans];
];

RemoveRedundant[x___] := BadCall["RemoveRedundant",x];

RemoveRedundantAux[numberData:{___?NumberQ},
                   par_,data_,rdata_,history_List] :=
Module[{len,i,result,aNumber,flag},
  len = Length[numberData];
  result = {};
  For[i=1,i<=len,i=i+1,
    aNumber = numberData[[i]];
    flag = AskParents[aNumber,par,numberData];
    If[flag
       , Null; (* Can eliminate !!!! Do nothing *)
       , (* Can not eliminate *)
         AppendTo[result,aNumber];
    ];
  ];
  Return[result];
];

RemoveRedundantAux[x___] := BadCall["RemoveRedundantAux",x];


End[];
EndPackage[]
