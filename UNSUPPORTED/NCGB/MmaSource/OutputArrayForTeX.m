(* OutputArrayForTeX.m                    *)
(* Author: unknown (packaged by Mauricio) *)
(*   Date: June 2009                      *)

(* History :
	Who knows ???
	Pre-1996 effort.
    :9/9/99: Added category weighting stuff, 
                function (individualCatWeight) (dell)
    
    :10/18/99: Fixed Infinity bug (dell)
*)

BeginPackage[ "OutputArrayForTeX`",
              "MoraAlg`",
              "NCTeXForm`",
              "Grabs`",
	      "NonCommutativeMultiply`",
              "Global`" ];

Clear[OutputArrayForTeX];
OutputArrayForTeX::usage = "";

Clear[WeightCats, WeightsAre];
Options[OutputArrayForTeX] = {
  WeightCats -> True,
  WeightsAre -> { 
    Variable ->1, tp ->.1, Tp -> .1, Co -> .1, Aj -> .1, Inv -> .3, UnusualFunction -> .7 
  }
};


Begin["`Private`"];

Clear[TeXBanner];
TeXBanner[stream_, s1_String] := 
  WriteString[stream, "\\break\\noindent\n",
  		      "\\rule[2pt]{\\textwidth}{4pt}\\hfil\\break\n",
                      "\\rule[2pt]{.5in}{4pt}\n",
                      "\\hfil\\ ", s1, "\\ \\hfil\n",
                      "\\rule[2pt]{.5in}{4pt}\\break\n",
                      "\\rule[2pt]{\\textwidth}{4pt}\\hfil\\break\n"];

TeXBanner[stream_, s1_String, s2_String] := 
  WriteString[stream, "\\break\\noindent\n",
  		      "\\rule[2pt]{\\textwidth}{4pt}\\hfil\\break\n",
                      "\\rule[2pt]{.5in}{4pt}\n",
                      "\\hfil\\ ", s1, "\\ \\hfil\n",
                      "\\rule[2pt]{.5in}{4pt}\\break\n",
                      "\\rule[2pt]{.5in}{4pt}\n",
                      "\\hfil\\ ", s2, "\\ \\hfil\n",
                      "\\rule[2pt]{.5in}{4pt}\\break\n",
                      "\\rule[2pt]{\\textwidth}{4pt}\\hfil\\break\n"];


Clear[OutputASingleTeXCategory];
(* MAURICIO - BEGIN *)
(* Replaced by an optional argument *)
(* Options[ OutputASingleTeXCategory ]:= { CatWeight->-1 }; *)
(* MAURICIO - END *)

(* TeX output for a single category - 
   Gets used over and over again in the construction of a spreadsheet *)
OutputASingleTeXCategory[ aMono_, anArray_, stream_,
                          nccpolys_, userselects_,
                          (* MAURICIO - BEGIN *)
			  (* ,ColumnWidth_, opts___Rule *)
                          (* MAURICIO - END *)
                          weight_:(-1) ] := Module[
  {knowns,k,str,rules,item,additionalFunction},

  rules = unmarkerAndDestroy[GetCategory[aMono,anArray]];
  (* MAURICIO - BEGIN *)
  (* Replaced by an optional argument *)
  (* weight = CatWeight /. {opts} /. Options[OutputASingleTeXCategory]; *)
  (* MAURICIO - END *)
  
  additionalFunction = anArray["additionalFunction"];
  If[ And[Not[Head[additionalFunction]===aMono],
          Not[additionalFunction==={}]],
      rules = additionalFunction[rules,anArray];
  ];
  knowns = Complement[GrabIndeterminants[rules], aMono];

  WriteString[stream,"\\rule[3pt]{\\textwidth}{.7pt}\\\\\n"];

  (* Print the category weight *)
  If[ weight != -1,
     WriteString[stream, "$" ];
     WriteString[stream, If[ IntegerQ[ weight ], ToString[ weight ] <> ".0", weight ]];
     WriteString[stream, "$ "];
  ]; 

  WriteString[stream,"The expressions with unknown variables "];
  (* MAURICIO - BEGIN *)
  (* 
  WriteString[stream, ToStringForTeXList[aMono]];
  *) 
  WriteString[stream, "$", NCTeXForm[aMono], "$"];
  (* MAURICIO - END *)
  WriteString[stream,"\\\\\n"];

  WriteString[stream,"and knowns "];
  (* MAURICIO - BEGIN *)
  (*
  WriteString[stream, ToStringForTeXList[knowns],"\\smallskip\\\\\n"];
  *)
  WriteString[stream, "$", NCTeXForm[knowns], "$\\smallskip\\\\\n"];
  (* MAURICIO - END *)

  Do[ item = rules[[k]];

      (* MAURICIO - BEGIN *)
      (*
      WriteString[stream,"\\begin{minipage}{",ColumnWidth,"in}\n$\n"];

      If[ MemberQ[userselects,item]
         ,WriteString[stream,"\\Uparrow\\ \n"];
      ];

      If[ Head[nccpolys[item]]===String
         ,WriteString[stream,ToStringForTeX[nccpolys[item]]];
         ,WriteString[stream,ToStringForTeX[item]];
         If[ Not[Head[item]===Rule]
           ,WriteString[stream,"==0"];
        ];
      ];

      If[ Not[k==Length[rules]]
         ,WriteString[stream,"\n$\n\\end{minipage}\\medskip \\\\\n"];
         ,WriteString[stream,"\n$\n\\end{minipage}\\\\\n"];
      ];
      *)

      WriteString[stream, "$"];

      If[ MemberQ[userselects, item]
         ,WriteString[stream, "\\Uparrow\\ \n"];
      ];

      If[ Head[nccpolys[item]]===String
         ,WriteString[stream, NCTeXForm[nccpolys[item]]];
         ,WriteString[stream, NCTeXForm[item]];
          If[ Not[Head[item]===Rule]
             ,WriteString[stream,"==0"];
          ];
      ];

      WriteString[stream,"$\\\\\n"];

      (* MAURICIO - END *)

     ,{k,1,Length[rules]}
  ];

];   
(* END OutputASingleTeXCategory *)

(* OutputASingleTeXCategory[x___] := BadCall["OutputASingleTeXCategory",x]; *)


Clear[OutputANumberCategoryForTeX];
OutputANumberCategoryForTeX[ anArray_Symbol, stream_, n_Integer,
                             nccpolys_Symbol, userselects_List
                             (* MAURICIO - BEGIN *)
			     (* , ColumnWidth_ *)
                             (* MAURICIO - END *)
			     ] := Module[
  {aMono, shouldOutput, monomials, j, outputedHeader, singleRules, thecat},

  outputedHeader = False;
  monomials = anArray[n];

  (* MXS  singleRules = GetCategory["singleRules",anArray]; *)
  Do[ aMono = monomials[[j]];
      shouldOutput = True;
      (* MXS
        thecat= GetCategory[aMono,anArray];
        If[Length[GetCategory[aMono,anArray]]===1
          , If[MemberQ[GetCategory["singleRules",anArray],
                       GetCateganArray[aMono][[1]]]
              , shouldOutput = False;
            ];
        ];
      *)

      If[ shouldOutput,
          OutputASingleTeXCategory[ aMono, anArray, stream,
                                    nccpolys, userselects 
                                    (* MAURICIO - BEGIN *)
                                    (* , ColumnWidth *)
                                    (* MAURICIO - END *)
          ];
      ];
      ,{j,1,Length[monomials]}
  ];
];

Clear[ThisMatrixEquals];
ThisMatrixEquals[x_List, listOfRules_List] := Map[ThisMatrixEquals[#,listOfRules]&, x];
ThisMatrixEquals[x_, listOfRules_List] := Module[
  {result,small},
  small = Select[listOfRules,(#[[1]]===x)&];
  result = x/.small;
  If[x===result
   , result = "??";
  ];
  Return[result];
];

(* Computes the weight of a category *)
Clear[individualCatWeight];
individualCatWeight[ indetList_List, ncpweightsare_List ] := Module [ 
  {knowns, catWeight = 0, thingList = {}, numList , varCount },

  Do [ thingList = Append [ thingList ,  Level [indetList, {i} ]   ];
       thingList = Flatten[ thingList ];
      ,{i,1, Depth[ indetList] }
  ];

  knowns = WhatIsSetOfIndeterminants[1];

  varCount = Length[Complement[ Grabs`GrabVariables[indetList], knowns ]]*Variable/.ncpweightsare;

  numList = Map[ Head,  thingList ] /.ncpweightsare ;
  numList = numList/.{Symbol->0,Plus->0,NonCommutativeMultiply->0};

  numList = ReplacePart[ numList, UnusualFunction, Position[Map[ NumberQ, numList ], False]];

  numList = numList/.ncpweightsare ;
  catWeight = Apply[  Plus, numList ]  + varCount ;
  Return[ catWeight ];

];  


(**** MAIN OutputArrayForTeX  ******)

Clear[OutputArrayForTeX];
OutputArrayForTeX[anArray_Symbol] := OutputArrayForTeX[anArray,$Output];

OutputArrayForTeX[ anArray_Symbol, stream_, NCCPolys_List,
                   FontSize_,Columns_, Comments_String, categorycutoff_,
                   Matricies_, opts___Rule ] := Module[
  {i,j,k,singleRuleList,singleVarList,nonsingleVarList,poly,
        monomials,aMono,theNumbers,num,n,w,knowns,shouldOutput,
        aList,nccpolys,str,baselineskip,
        (* MAURICIO - BEGIN *)  
        (* rulewidth, columnwidth, *)
        (* MAURICIO - END *)  
        thismatrix,thismatrixequals,userselects,
	catWeights,posn,allCatsInVars,ncpweightcats,ncpweightsare,
        flatMatricies},

  CreatePolynomialArray[NCCPolys,nccpolys];
  n = WhatIsMultiplicityOfGrading[];
  allvars = Flatten[Table[WhatIsSetOfIndeterminants[i],{i,1,n}]];

  (* MAURICIO - BEGIN *)  
  (* 
  rulewidth = RegOutRule[FontSize,Columns]; 
  If[Columns===1
    ,columnwidth=6;
    ,columnwidth=3.2;
  ];
  *)
  (* MAURICIO - END *)  

  singleRuleList = GetCategory["singleRules",anArray];
  singleVarList = GetCategory["singleVars",anArray];
  nonsingleVarList = GetCategory["nonsingleVars",anArray];

  TeXBanner[stream, "THIS IS NCProcess" ];
  WriteString[stream, Comments];

  (* Output Order *)
  WriteString[stream, "THE ORDER IS NOW THE FOLLOWING:",
                      "\\hfil\\break\n$\n"];

  (* MAURICIO - BEGIN *)
  (*
  Do[aList = WhatIsSetOfIndeterminants[j];
      If[Not[aList==={}]
         ,Do[str=ToStringForTeX[aList[[w]]];
             WriteString[stream,str,"<"];
          ,{w,1,Length[aList]-1}];
          str=ToStringForTeX[aList[[-1]]];
          WriteString[stream,str];
      ];
      If[j==n
        ,WriteString[stream,"\\\\\n$\n"];
        ,WriteString[stream,"\\ll\n"];
      ];
  ,{j,1,n}];
  *)
  Do[ aList = WhatIsSetOfIndeterminants[j];
      If[Not[aList==={}]
         ,Do[str = NCTeXForm[aList[[w]]];
             WriteString[stream,str,"<"];
          ,{w,1,Length[aList]-1}];
          str = NCTeXForm[aList[[-1]]];
          WriteString[stream,str];
      ];
      If[j==n
        ,WriteString[stream,"\\\\\n$\n"];
        ,WriteString[stream,"\\ll\n"];
      ];
  ,{j,1,n}];
  (* MAURICIO - END *)


  (* Output Relations *)

  (* MAURICIO - BEGIN *)
  (*
  WriteString[stream,"\\rule[2pt]{",columnwidth,"in}{4pt}\\hfil\\break\n",
                     "\\rule[2pt]{",rulewidth[[1]],"in}{4pt}\n",
                     "\\ YOUR SESSION HAS DIGESTED\\ \n",
                     "\\rule[2pt]{",rulewidth[[1]],"in}{4pt}\\hfil\\break\n",
                     "\\rule[2pt]{",rulewidth[[2]],"in}{4pt}\n",
                     "\\ THE FOLLOWING RELATIONS\\ \n",
                     "\\rule[2pt]{",rulewidth[[2]],"in}{4pt}\\hfil\\break\n",
                     "\\rule[2pt]{",columnwidth,"in}{4pt}\\hfil\\break\n"];
   *)
  TeXBanner[stream, "YOUR SESSION HAS DIGESTED", "THE FOLLOWING RELATIONS" ];
  (* MAURICIO - END *)

  If[ singleRuleList != {}, 
      WriteString[stream,
        "THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR:\\hfil\\break\n"];

      (* MAURICIO - BEGIN *)
      (*
      WriteString[stream,ToStringForTeXList[singleVarList],
                          "\n\\smallskip\\\\\n"];
      *)
      WriteString[stream, "$", NCTeXForm[singleVarList], "$",
                           "\n\\smallskip\\\\\n"];
      (* MAURICIO - END *)

      WriteString[stream,
         "The corresponding rules are the following:",
         "\\smallskip\\\\\n"];
      flatMatricies = Flatten[Matricies];

      (* MAURICIO - BEGIN *)
      (*
      Do[If[Not[MemberQ[flatMatricies,singleRuleList[[i,1]]]]
           ,WriteString[stream,"\\begin{minipage}{",columnwidth,"in}\n$\n",
             ToStringForTeX[singleRuleList[[i]]]];
             WriteString[stream,"\n$\n\\end{minipage}\\medskip\\\\\n"];
         ];
      ,{i,1,Length[singleRuleList]}];
      Do[thismatrix=Matricies[[i]];
         thismatrixequals=ThisMatrixEquals[thismatrix,singleRuleList];
         WriteString[stream,"\\begin{minipage}{",columnwidth,"in}\n$\n",
                           ToStringForTeX[thismatrix],
                           "\\rightarrow ",
                           ToStringForTeX[thismatrixequals],
                           "\n$\n\\end{minipage}\\medskip\\\\\n"];
      ,{i,Length[Matricies]}];
      *)
      Do[ If[ Not[MemberQ[flatMatricies,singleRuleList[[i,1]]]],
      	   WriteString[stream, 
              "$", NCTeXForm[singleRuleList[[i]]], "$\\\\\n"];
          ];
          , 
          {i,1,Length[singleRuleList]}
      ];
      Do[ thismatrix=Matricies[[i]];
          thismatrixequals=ThisMatrixEquals[thismatrix,singleRuleList];
          WriteString[stream,
             "$", NCTeXForm[thismatrix], 
             "\\rightarrow ", NCTeXForm[thismatrixequals], "$\\\\\n"];
         ,
          {i,Length[Matricies]}
      ];
      (* MAURICIO - END *)

  ];

  theNumbers = Select[GetCategory["numbers",anArray],#<categorycutoff&];
  notoutput = Complement[GetCategory["numbers",anArray],theNumbers];
  userselects = unmarkerAndDestroy[GetCategory["userSelects",anArray]];
  OutputANumberCategoryForTeX[ anArray,stream,0,
                               nccpolys,userselects 
                               (* MAURICIO - BEGIN *)
                               (* ,columnwidth *)
                               (* MAURICIO - END *)
                             ];


  (* Output User Creations *)

  (* MAURICIO - BEGIN *)
  (*
  WriteString[stream,"\\rule[2pt]{",columnwidth,"in}{1pt}\\hfil\\break\n",
                     "\\rule[2.5pt]{",rulewidth[[3]],"in}{1pt}\n",
                     "\\ USER CREATIONS APPEAR BELOW\\ \n",
                     "\\rule[2.5pt]{",rulewidth[[3]],"in}{1pt}\\hfil\\break\n",
                     "\\rule[2pt]{",columnwidth,"in}{1pt}\\hfil\\break\n"];
  *)
  TeXBanner[stream, "USER CREATIONS APPEAR BELOW" ];
  (* MAURICIO - END *)

  num = userselects;

  (* MAURICIO - BEGIN *)
  (*
  Do[poly = num[[i]];
     WriteString[stream,"\\begin{minipage}{",columnwidth,"in}\n$\n",
                 ToStringForTeX[poly]];
     If[Not[i==Length[num]]
       ,WriteString[stream,"\n$\n\\end{minipage}\\medskip\\\\\n"];
       ,WriteString[stream,"\n$\n\\end{minipage}\\smallskip\\\\\n"];
     ];
  ,{i,1,Length[num]}];
  *)
  Do[ poly = num[[i]];
      WriteString[stream,"$", NCTeXForm[poly], "$\\\\\n"];
     ,{i,1,Length[num]}
  ];
  (* MAURICIO - END *)


  (* Output Not Solved *)

  (* MAURICIO - BEGIN *)
  (*
  WriteString[stream,"\\rule[2pt]{",columnwidth,"in}{4pt}\\hfil\\break\n",
                     "\\rule[2pt]{",rulewidth[[4]],"in}{4pt}\n",
                     "\\ SOME RELATIONS WHICH APPEAR BELOW\\ \n",
                     "\\rule[2pt]{",rulewidth[[4]],"in}{4pt}\\hfil\\break\n",
                     "\\rule[2pt]{",rulewidth[[5]],"in}{4pt}\n",
                     "\\ MAY BE UNDIGESTED\\ \n",
                     "\\rule[2pt]{",rulewidth[[5]],"in}{4pt}\\hfil\\break\n",
                     "\\rule[2pt]{",columnwidth,"in}{4pt}\\hfil\\break\n",
           "THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\\hfil\\break\n"];
  *) 
  TeXBanner[ stream, "SOME RELATIONS WHICH APPEAR BELOW", "MAY BE UNDIGESTED" ];
  WriteString[stream, "THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\\hfil\\break\n"];
  (* MAURICIO - END *)

  (* MAURICIO - BEGIN *)
  (*
  WriteString[stream, ToStringForTeXList[nonsingleVarList],
                     "\n\\smallskip\\\\\n"];
  *)
  WriteString[stream, "$", NCTeXForm[nonsingleVarList], "$\\\\\n"];
  (* MAURICIO - END *)


  (* DELL's category weight starts here *)
  ncpweightcats = WeightCats /. {opts} /. Options[OutputArrayForTeX];

  If[ ncpweightcats,

      ncpweightsare = WeightsAre /. {opts} /. Options[OutputArrayForTeX];

      (* Find all the categories *)
      allCatsInVars = {};

      Do[ num = theNumbers[[i]];
          If[ Not[num===0],
	      monomials = anArray[ num ];
              Do[ aMono = monomials[[j]];
                  allCatsInVars  = Append[ allCatsInVars, { aMono} ];
                 ,{j,1,Length[monomials]}];
          ];
         ,{i,1,Length[theNumbers]}
      ];

      (* Find the category weights associated with all cats *)
      catWeights = Map[ individualCatWeight[#,ncpweightsare]&,
                        Flatten[ allCatsInVars, 1 ] ];

      allCatsInVars = Flatten[ allCatsInVars, 1 ] ;

      Do[ posn = Position[ catWeights, Min[ catWeights ] ];

          (* The following fix is due to the fact that Infinity//FullForm
             is really DirectedInfinity[1] 10/18/99 - Dell*)
          posn =  DeleteCases[ posn , {__ , 1 } ];

          OutputASingleTeXCategory[ allCatsInVars[[posn[[1]]]][[1]], anArray, stream,
                                    nccpolys, userselects,
                                    (* MAURICIO - BEGIN *)
                                    (* columnwidth, CatWeight -> Min[ catWeights] *)
                                    (* MAURICIO - END *)
				    Min[ catWeights] ];
	
          catWeights = ReplacePart[ catWeights,  Infinity , {posn[[1]]} ];
	 
         ,{ i, 1, Length[ catWeights ] }
      ];

     , (* ELSE DON'T WEIGHT ORDER CATS *)
       (* Pre - 1999 CODE - spreadsheet in Pre1999 order *)

      Do[ num = theNumbers[[i]];
          If[ Not[num===0],
              OutputANumberCategoryForTeX[ anArray, stream, num,
                                           nccpolys, userselects 
                                           (* MAURICIO - BEGIN *)
					   (* ,columnwidth *)
                                           (* MAURICIO - END *)
                                         ];
          ];
         ,{i,1,Length[theNumbers]}
      ];

      If[ notoutput != {}, 
          WriteString[stream,"\\vspace{.5in}\n\n",
              "\\centerline{\\bf\\Large Each of the following numbers}\n",
              "\\centerline{\\bf\\Large represents a category that was not output.}\n",
              (* MAURICIO - BEGIN *)
              (*
                "\\centerline{",ToStringForTeX[notoutput],"}\n"\];
              *)
              "\\centerline{$",NCTeXForm[notoutput],"$}\n"];
              (* MAURICIO - END *)
      ];

  ];   (* END WEIGHT ORDER CATS *)

  Clear[nccpolys];

];

(*******  END OutputArrayForTeX *****************)

End[];
EndPackage[];

(* MAURICIO - BEGIN *)
(*
<<ToStringForTeX.m;

Clear[RegOutRule];
(* 1999 DELL & BILL DON"T UNDERSTAND ***)
(* Set font size *)
RegOutRule["normalsize", 1] := {1.879, 1.923, 1.701, 1.45, 2.18};
RegOutRule["small", 1] := {1.95, 2, 1.798, 1.56, 2.23};
RegOutRule["small", 2] := {.535,.573,.399,.137,.818};
RegOutRule[x_, 2] := Module[
  {},
  Print["Font size ",x," not supported. Using small."];
  Return[RegOutRule["small",2]]
];

RegOutRule[x_,1] := Module[
  {},
  Print["Font size ",x," not supported. Using normalsize."];
  Return[RegOutRule["normalsize",1]]
];

RegOutRule[x_,y_] := Module[
  {},
  Print[y," columns not supported. Using normalsize with 1 column."];
  Return[RegOutRule["normalsize",1]]
];

RegOutRule[x___] := BadCall["RegOutRule",x];

*)
(* MAURICIO - END *)
