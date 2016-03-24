(* :Title: 	NCCollectOnVariables  // Mathematica 3.0 and 4.0  *)

(* :Author:	???????     *)

(* :Context:	NCCollectOnVariables`  *)

(* :Summary:	*)

(* :Alias:	None.    *)

(* :History:	
   :???????:    Written (1995 or 1996)
   :9/9/99: Added CoefficientList, Option[NCCV]->Output->LeftAndRights
   :9/9/99:	Packaged (Dave Glickenstein, Bill Helton , Dell Kronewitter )
   :9/9/99:	Packaged 
   :9/9/04:	Correct some bugs related with Times before NonCommutativeMultiply (mauricio) 
*)


BeginPackage["NCCollectOnVariables`", "NonCommutativeMultiply`","NCCollect`", "MoraAlg`", "Global`"]

Clear[NCCollectOnVariables];

NCCollectOnVariables::usage = 
	"NCCollectOnVariables[aPolynomial_, aListOfVariables_, Options___] 
	takes aPolynomial and collects around maximal length
	products of variables in aListOfVariables.  

	The optional argument Output is defaulted as Output->CollectedTerms, 
	which means the function returns the polynomial in the
	collected form.  The option Output->LeftsAndRights means
	the coefficients of the variables are returned in a list
	of left coefficients and a list of right coefficients.

	If aListOfVariables is not specified, WhatIsSetOfIndeterminants[1] 
	is used, but in this case the Options cannot be specified.";

Clear[NCCoefficientList];

NCCoefficientList::usage = 
  "NCCoefficientList[aPolynomial_, aListOfVariables_] gives a list of 
	the left coefficients of products of the variables in 
	aListOfVariables which are found in aPolynomial and 
	also a list of the right coefficients of the same variables.";

Clear[Output];

Output::usage = 
	"Output can be set to CollectedExpression, in which case
	NCCollectOnVariables returns the expression after
	the collecting has been done, or to LeftsAndRights,
	in which case NCCollectOnVariables returns a list
	of the terms to the left of the variables and a
	list of the terms to the right of the variables.";

Clear[LeftsAndRights];

LeftsAndRights::usage = "See Output options for NCCollectOnVariables";


Begin["`Private`"];


  NCCOV[x___] := NCCollectOnVariables[x];

  SearchForProductsOfKnowns[x___] := 
  Module[{},
    Print["Please call NCCollectOnVariables next time."];
    Return[NCCollectOnVariables[x]];
  ];

  (****************************************************************)

  NCCollectOnVariables[exp_]:=NCCollectOnVariables[exp,
         WhatIsSetOfIndeterminants[1]];

  (* NCCollectOnVariables[aList_List,knowns_List]:=
    Map[NCCollectOnVariables[#,knowns]&,aList];
  *)

  Options[NCCollectOnVariables] = {Output->CollectedExpression};

  NCCollectOnVariables[exp_,knowns_List, options___]:=
  Module[{prods,collectexpr,temp,lengths,max,i,someprods, leftsAndRights, opts, getLeftSideRules, getRightSideRules},


  collectexpr = RuleToPoly[exp];

  (********** Find prods is the different products of knowns about ******)
          (* which it will collect, sorted by length.	   *)
    prods=Reverse[NCCollectOnVariablesAux[{RuleToPoly[collectexpr]},knowns]];
                                  (* Print["prods:",prods]; *)
    lengths = Map[NCLength,prods];
    max = Apply[Max,lengths];
    max = Max[0,max];
                                  (* Print["max:",max];*)
    Do[ someprods = Select[prods,(Length[#]===i)&];
                                  (*Print["someprods:",someprods];*)
                                  (*Print["collectexpr before:",collectexpr];*)
        If[Length[someprods]>0
          , temp = FixedPoint[NCCollect[#,someprods]&,collectexpr];
            collectexpr = temp;
                                  (*Print["collectexpr after:",collectexpr];*)
        ];
    ,{i,max,0,-1}];

          (* collectexpr is the expression after the collecting has been done. *)


  (********** Now get the left and right sides *************)
     (******* Begin Dave's additions 9/8/99        *******)
       (***** Make rules to get left and right sides *****)

  SetNonCommutative[left, middle, right];
  getLeftSideRules = 
          {
            (number1_:1)*left___**middle**right___ :> 
                  NonCommutativeMultiply[left]
          };
  getRightSideRules = 
          {
            (number1_:1)*left___**middle**right___ :> 
                  NonCommutativeMultiply[right]
          };

       (***** Change collectexpr into a list of monomials *****)

  Module[{collectexprmonlist, leftsides={}, rightsides={}},
    Pull[f_[x__]] := x;
    If[Head[collectexpr]===Plus,
          collectexprmonlist = List[Pull[collectexpr]],
          collectexprmonlist = {collectexpr}];
                                  (* Print["collectexprmonlist = ", collectexprmonlist];*)

      (***** Get left and right sides of knowns *****)

  For[i=1, i<=Length[prods], i++,
    Module[{leftIterRules = getLeftSideRules //. middle->prods[[i]]},
      leftsides = Join[leftsides,
          Select[collectexprmonlist, 
          MatchQ[#, leftIterRules[[1]][[1]]]&]//. leftIterRules]]];
  For[i=1, i<=Length[prods], i++,
    Module[{rightIterRules = getRightSideRules //. middle->prods[[i]]},
      rightsides = Join[rightsides,
          Select[collectexprmonlist, 
          MatchQ[#, rightIterRules[[1]][[1]]]&]//. rightIterRules]]];

  leftsAndRights = Join[{Flatten[leftsides]},{Flatten[rightsides]}];
                                  (* Print["Nowprods = ",prods];*)
                                  (* Print["Lefts and Rights = ",
                                     leftsAndRights]; 		*)
    If[((Output/.{options}/.Options[NCCollectOnVariables]) === LeftsAndRights), 
      Return[leftsAndRights],
      Return[collectexpr]];
  ]];

  (******** End of main NCCollectOnVariables program **********)
  (******** End Dave's additions *********)


  NCCollectOnVariables[x___]:= BadCall["NCCollectOnVariables",x];

  (********************************************************************)

  NCLength[x_NonCommutativeMultiply] := Length[x];
  NCLength[x_] := 1;

  NCLength[x___]:= BadCall["NCLength",x];

  (********************************************************************)

  NCCollectOnVariablesAux[aList_List,vars_List] := 
  Module[{result},
     result = Map[NCCollectOnVariablesAux[#,vars]&,aList];
     result = Complement[Union[Flatten[result]],{}]; 
     Return[result];
  ];

  NCCollectOnVariablesAux[aRule_Rule,vars_List] := 
       NCCollectOnVariablesAux[aRule[[1]]-aRule[[2]],vars];

  NCCollectOnVariablesAux[aPolynomial_,vars_] :=
  Module[{asaList,result},
     (* Call Expand first to expand commutative products *)
     asaList=Expand[aPolynomial];
     If[Head[asaList]===Plus
        , asaList = Apply[List,asaList];
        , If[asaList===0
            , asaList = {};
            , asaList = {asaList};
          ];
     ];

          (* Now we have a list of monomials written as lists of 
             their factors 					*)
     asaList = Map[NCMToList,asaList];
     result = Map[knownblocks[#,vars]&,asaList];
     Return[result];
  ];

  NCCollectOnVariablesAux[x___] := BadCall["NCCollectOnVariablesAux",x];

  (*********************************************************************)

  knownblocks[{c_?NumberQ var_,rest___},vars_] := 
  Module[{result},
    If[MemberQ[vars,var]
       , result = kblocks[var,{rest},vars];
       , result = knownblocks[{rest},vars];
    ];
  (*
  If[Length[result]>0
     ,Print["Processing:",{{var,result},vars}," gives ",result];
  ];
  *)
    Return[result];
  ];

  knownblocks[{var_,rest___},vars_] := 
  Module[{result},
    If[MemberQ[vars,var]
       , result = kblocks[var,{rest},vars];
       , result = knownblocks[{rest},vars];
    ];
  (*
  If[Length[result]>0
     ,Print["Processing:",{{var,result},vars}," gives ",result];
  ];
   *)
    Return[result];
  ];


  knownblocks[{},vars_List] := {};

  knownblocks[x___] := BadCall["knownblocks",x];

  (*********************************************************************)

  kblocks[var_,aList_,vars_List] := 
  Module[{total,item,index,j,len,others},
     total = var;
     index = 0;
     len = Length[aList];
     loop = True;
     For[j=1,And[loop,j<=len],j++,
         item = aList[[j]];
         loop = MemberQ[vars,item];
         If[loop
            , total = total**item;
              index = j;
         ];
      ];
      others = knownblocks[Take[aList,{index+1,-1}],vars];
      Return[Join[{total},others]];
  ];

  kblocks[x___] := BadCall["kblocks",x];

  (********************************************************************)

  NCMToList[Times[y_,x_NonCommutativeMultiply]] := Insert[Apply[List,x],y,1];

  NCMToList[x_NonCommutativeMultiply] := Apply[List,x];

  NCMToList[x_List] := Map[NCMToList,x];

  NCMToList[x_] :=
  Module[{lead,result,y},
       lead = LeadingCoefficient[x];
       If[lead===1, result = {x};
                  , result = NCMToList[x/lead];
                    result[[1]] = result[[1]] lead;
       ];  
       Return[result];
  ];

  NCMToList[x___] := BadCall["NCMToList",x];

  (*******************************************************************)


  LeadingCoefficient[c_?NumberQ x_] := c LeadingCoefficient[x];

  LeadingCoefficient[x_/c_?NumberQ] := LeadingCoefficient[x]/c;

  LeadingCoefficient[x_] := 1;

  LeadingCoefficient[x___] := BadCall["LeadingCoefficient",x];


  (*********************************************************************)


  NCCoefficientList[poly_, listofvars_] := NCCollectOnVariables[poly, listofvars, Output->LeftsAndRights];

End[];
EndPackage[]

