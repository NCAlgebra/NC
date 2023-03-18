(* :Title:      NCShortCuts // Mathematica 1.2 and 2.0 *)

(* :Author:     Dell -  5/21/99 *)

(* :Context:    NCShortCuts` *)

(* :Summary:    NCAddTp[ listOfExpressions] Returns transposed relations

	NCSmartOrder[ listOfIndeterminates, listOfExpressions] 
	inserts the indeterminates found in listOfExpressions
	into the order in an "appropriate" place.
*)

(* :Alias:      None. *)

(* :Warnings:   NCAddTp[]  *)

(* :History:

   :5/5/97 - Created
   :3/11/99 - Put into ncalg source ????? ha

NCSmartOrder:::::::::
   :8/11/99 - Fixed a bug found by Juan (dell)
   :9/1/99  - Fixed another bug found by Juan (dell)
   :9/27/99 - Fixed problem with adding variables not in the order  (dell)
 
*)

BeginPackage[ "NCShortCuts`"]

Clear[NCAddTranspose];
NCAddTranspose::usage = "NCAddTranspose[ exprs_List ] returns 
union of expressions 
and transposed equivalents of expressions ";

Clear[NCAddAdjoint];
NCAddAdjoint::usage = "NCAddAdjoint[ exprs_List ] returns 
union of expressions
and adjointed equivalents of expressions ";

Clear[NCSmartOrder];
NCSmartOrder::usage = "NCSmartOrder[order,relations] sets the
monomial order to include all indeterminants found in the        
expressions in relations.   It takes these indeterminants
and attempts to place them nearest the order found in the 
first argument."; 

Clear[NCAutomaticOrder];
NCAutomaticOrder::usage = "NCAutomaticOrder[order,relations] sets the
monomial order to include all indeterminants found in the
expressions in relations.   It takes these indeterminants
and attempts to place them nearest the order found in the
first argument.";

Begin["`Private`"]

ClearAll[pull];
pull[ x_[y__] ] := y;

ChangeToSub[ x_Equal ] :=  Plus[ {pull[x]}[[1]], 
Times[-1, {pull[x]}[[2]] ]   ] ; 

ChangeToSub[ x__ ] := x;

NCAddTranspose[ list_List ] :=
Module[ {},
newlist = Map[ ChangeToSub[ # ] &, list ];

tpList = Map[ NonCommutativeMultiply`tp, newlist ];

Return[ Union[ tpList , newlist ] ];
];

NCAddAdjoints[ list_List ] :=
Module[ {},
newlist = Map[ ChangeToSub[ # ] &, list ];

tpList = Map[ NonCommutativeMultiply`aj, newlist ];

Return[ Union[ tpList , newlist ] ];
];


NCAutomaticOrder := NCSmartOrder;

NCSmartOrder[ order_List, Rels_List ]:=
	Module[{inds,index,indsLength,newOrder= order, 
	indexVar,indexOrder, posn},
	inds = Union [ Grabs`GrabIndeterminants[ Rels ]];

	indsLength = Length[inds];
	For[index = 1, index <= indsLength,
	     index++,
	If[ ! MemberQ[ Flatten[newOrder] ,inds[[index]] ],

		indexVar = Grabs`GrabVariables[ inds[[index]]];

		(* just take the first variable as the index variable *)
		indexVar = indexVar[[1]]; 
	
	(* Look thru the list for the indexing variable.
	But only look for the variable by itself (beheaded) *)
		
    indexOrder = Map[  Grabs`GrabVariables[#]& , newOrder ];

		If[ ( posn = 
		  Position[indexOrder, indexVar] )
		       != {},  

		   posn = ReplacePart[ posn, posn[[-1,-1]]+1,{-1,-1}];  

           newOrder = Insert[ newOrder, 
                  inds[[index]], posn[[-1]] ];,  
      
           AppendTo[newOrder,{ inds[[index]] } ]; 

          ]; (*end if*)


       ]; (* end if MemberQ *)
    ]; (*end for*) 
    
(*     Print[" Computed monomial order is : ",newOrder];    *)
    MoraAlg`ClearMonomialOrderAll[];
    MoraAlg`SetMonomialOrder[pull[newOrder]];
    Return[ newOrder ];
    ]; (*end module*)


End[];
EndPackage[]
