(* :Title: 	NCEliminate // Mathematica 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NCEliminate` *)

(* :Summary:    
*)

(* :Alias's:    None *)

(* :Warnings:   None.  *)

(* :History: 
*)

BeginPackage["NCEliminate`","MoraAlg`","Grabs`","NCMakeGreater`",
             "NCGBConvert`","MoraData`",
             "NCGBMax`","Global`","Errors`"];

Clear[NCEliminate];

NCEliminate::usage =
     "NCEliminate";

Clear[WhatIsNCEliminateKeep];

WhatIsNCEliminateKeep::usage =
     "WhatIsNCEliminateKeep";

Clear[UseNewOrder];

UseNewOrder::usage =
     "UseNewOrder";

Clear[NCEliminateVerbose];

NCEliminateVerbose::usage =
     "NCEliminateVerbose"

Begin["`Private`"];

Options[NCEliminate] = {UseNewOrder->True,NCEliminateVerbose->False};

NCEliminate[Expressions_List,vars_List,opts___Rule] :=
         NCEliminate[Expressions,vars,8,opts];

NCEliminate[Expressions_List,vars_List,aNumber_?NumberQ,opts___Rule] :=
Module[{ans,new,allvars,neworder,empty,size,j,k,
        verb,oldorder,newkeep,shouldLoop,numbers},
   neworder = UseNewOrder/.{opts}/.Options[NCEliminate];
   verb = NCEliminateVerbose/.{opts}/.Options[NCEliminate];
   empty = MonomialOrderQ[] === {};
   If[Not[empty], size = NCMakeGreater`WhatIsMultiplicityOfGradingOld[];
                  oldorder = Table[WhatIsSetOfIndeterminantsOld[j],{j,1,size}];
                , size = 0;
   ];
   If[neworder
      , allvars = GrabIndeterminants[Expressions];
        SetMultiplicityOfGrading[2];
        SetMonomialOrderOld[Complement[allvars,vars],1];
        SetMonomialOrderOld[vars,2];
      , SetMultiplicityOfGrading[size+1];
        Do[ SetMonomialOrderOld[oldorder[[j]],j];
        ,{j,1,size}];
        SetMonomialOrderOld[vars,size+1];
      , BadCall["NCEliminate",Expressions,vars,aNumber,opts];
   ];
   new = Complement[Union[Expressions],{0}];
   new = NCGBConvert[new];
   Clear[ontheside];
   ontheside[_] := {};
   {ans,ontheside[0]} = Global`SaveVars[new,vars];
   If[verb, If[Not[ontheside[0]==={}], 
                   Print["NCEliminate discovered that ",ontheside[0]];
   ]];
   shouldLoop = anyVarsLeft[ans,vars]; 
   For[j=1,And[j<=aNumber,shouldLoop],j++, 
        ans = NCMakeGBOld[ans,1]; 
        numbers = WhatAreNumbers[];
       {ans,ontheside[j]} = Global`SaveVars[ans,vars];
       If[verb, If[Not[ontheside[j]==={}], 
                   Print["NCEliminate discovered that ",ontheside[j]];
       ]];
       shouldLoop = And[Not[FinishedComputingBasisQOld[]],anyVarsLeft[ans,vars]]; 
   ];
   keep = Flatten[Table[ontheside[k],{k,0,aNumber}]];
   numbers = Flatten[Map[AddToDataBase,ans]];
   ans = WhatIsDataBase[CleanUpBasisOld[numbers]];
   If[Not[empty], (* Put order back the way it was *)
                  SetMultiplicityOfGrading[size];
                  Do[ SetMonomialOrderOld[oldorder[[k]],k]; 
                  ,{k,1,size}];
   ]; 
   Clear[newkeep];
   Return[ans];
];

NCEliminate[x___] := BadCall["NCEliminate",x];   


anyVarsLeft[ans_,vars_] := Apply[Or,Map[Not[FreeQ[ans,#]]&,vars]];
   
WhatIsNCEliminateKeep[] := keep;

WhatIsNCEliminateKeep[x___] := BadCall["WhatIsNCEliminateKeep",x];

End[];
EndPackage[]
