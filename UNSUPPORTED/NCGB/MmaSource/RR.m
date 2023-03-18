Print["Do not load RR.m"];
Print["Do not load RR.m"];
Print["Do not load RR.m"];
Print["Do not load RR.m"];
Print["Do not load RR.m"];
Exit[];
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
     "RemoveRedundent";

Clear[RedListToArray];

RedListToArray::usage = 
     "RedListToArray";

Clear[RemoveRedundentUseNumbers];

RemoveRedundentUseNumbers::usage =
     "RemoveRedundentUseNumbers is an option for RemoveRedundent";

Clear[RemoveRedundentProtected];

RemoveRedundentProtected::usage =
     "RemoveRedundentProtected is an option for RemoveRedundent";

Begin["`Private`"];

Clear[AskParents];
Clear[AskParentsAux];

RedListToArray[history_List,parents_Symbol,
               data_Symbol,reversedata_Symbol] :=
Module[{len,i,num,item},
   len = Length[history];
   Clear[parents];
   Clear[data];
   Do[ item = MoraAlg`RuleToPoly[history[[i]]];
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
   Do[ item = MoraAlg`RuleToPoly[history[[i]]];
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

Options[RemoveRedundent] = {
     RemoveRedundentUseNumbers -> False,
     RemoveRedundentProtected->{}};

RemoveRedundent[] :=
   RemoveRedundent[MoraAlg`WhatIsPartialGB[Global`WhatAreGBNumbers[]],
                   MoraAlg`WhatIsHistory[Global`WhatAreNumbers[]]];

(* 
   actualdata can be either a list of polynomials or 
   a list of numbers based upon whether RemoveRedundentUseNumbers->True
   or RemoveRedundentUseNumbers->False
*)
RemoveRedundent[actualdata_List,history_List,opts___Rule] :=
Module[{nums,data,par,rdata,ans,ansnums,oldnums,protect},
Print["The arguments to RemoveRedundent are:"];
Print[{actualdata,history,opts}];
   nums = RemoveRedundentUseNumbers/.{opts}/.Options[RemoveRedundent]; 
   If[nums
     , RedListToArray[history,par]; 
       oldnums = actualdata;
       ans = RemoveRedundentAux[oldnums,par,data,rdata,history];
       Clear[par];
     , RedListToArray[history,par,data,rdata]; 
       oldnums = Union[Map[data,MoraAlg`RuleToPoly[actualdata]]];
       ansnums = RemoveRedundentAux[oldnums,par,data,rdata,history];
       ans = Map[rdata,ansnums];
       ans=MoraAlg`RuleToPoly[ans];
       Clear[data];
       Clear[rdata];
       Clear[par];
   ];
   Return[ans];
];

RemoveRedundent[x___] := BadCall["RemoveRedundent",x];

RemoveRedundentAux[numberData:{___?NumberQ},
                   par_,data_,rdata_,history_List] :=
Module[{len,i,result,aNumber,flag},
  len = Length[numberData];
  result = {};
  For[i=1,i<=len,i=i+1,
    aNumber = numberData[[i]];
    flag = AskParents[aNumber,par,numberData];
    If[flag
       , (* Can eliminate !!!! Do nothing *)
       , (* Can not eliminate *)
         AppendTo[result,aNumber];
    ];
  ];
  Return[result];
];

RemoveRedundentAux[x___] := BadCall["RemoveRedundentAux",x];

End[];
EndPackage[]
