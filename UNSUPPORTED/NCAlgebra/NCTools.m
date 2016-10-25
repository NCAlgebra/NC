(* :Title: 	NCTools // Mathematica 1.2 and 2.0 *)

(* :Author: 	David Hurst (dhurst). *)

(* :Context: 	NCTools` *)

(* :Summary:
		NCTools is a package that contains functions to be used
		in other contexts.
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :1/92	Packaged. (dhurst)
   :7/11/92     Refined degrees. (dhurst)
   :8/21/92     Changed Package statement for compatibility to 
                NCMono` to NCTools` context changes. (mstankus)
*)

BeginPackage[ "NCTools`", (* "NCMonomial`", *)
     "NonCommutativeMultiply`", "NCReplace`" ]

Options[ NCHighestDegreePosition ] := 
     {NCHDPdebug->False, factorsdebug->False};

Options[ convert ] := {convertdebug->False};

LeftPatternRule::usage = "LeftPatternRule[ rule ] makes the lhs into a\n
      pattern.  Alias: LPR";

factors::usage =" ... ";

assignweights::usage =" ... ";

terms::usage =" ... ";

degrees::usage = " ... ";

convert::usage =" ... ";

Convert::usage =
     "Convert[ expression ] returns a rule based on the expression that\n
      has the Highest Order Term as the lhs and the negative of the \n
      remaining expression as the rhs.";

NCHighestDegreePosition::usage =
     "NCHighestDegreePosition[ expression ] returns the position of \n
      the Highest Order term in an NC-expression.";

NCHighestDegree::usage =
     "NCHighestDegree[ expression ] returns the Highest Order term in an\n
     NC-expression.";

Begin["`Private`"]

(* BEGIN MAURICIO MAR 2016 *)
NCMonomial`NCMonomial = Identity;
(* END MAURICIO MAR 2016 *)

(* ------------------------------------------------------------------ *)
(* Convert                                                            *)
(* ------------------------------------------------------------------ *)

Convert[ entry1___] :=
     Block[{},
          If[
               Head[entry1] === Equal ||
               Head[entry1] === Plus ||
               Head[entry1] === Rule ||
               Head[entry1] === List ||
               Head[entry1] === RuleDelayed,
               convert[entry1],
               Return[entry1->entry1]
          ]
     ];

Convert[] :=Return[];

convert[ expression_NonCommutativeMultiply ] :=
     If[ 
          !FreeQ[expression,Plus], 
          convert[ ExpandNonCommutativeMultiply[ expression ]  ],
          Return[expression]
     ];

convert[ expression_Times ] :=
     If[ 
          !FreeQ[expression,Plus], 
          convert[ Expand[ expression ]  ],
          Return[expression]
     ];

convert[ expression_Rule ] := 
     convert[ expression[[1]] - expression[[2]] == 0 ];

convert[ expression_RuleDelayed ] := 
     convert[ expression[[1]] - expression[[2]] == 0 ];

convert[ expression_Plus ] := 
     convert[ expression == 0 ];

convert[ list_List ] := Map[ Convert, list ];

convert[ entry_Equal, opts___ ]:=
     Block[ 
          { blankfunction, blanket, patternleft, patternright, out, 
	  oldleft, leftvariables, temp, initialmono, right, left,
    	  front, back },

	  convertdebug = convertdebug/.{opts}/.Options[ convert ];

          entry1 = entry[[1]] - entry[[2]];

          Which[
               Not[ FreeQ[ entry1, Power ] ],
               entry2 = NCMonomial`NCMonomial[ entry1 ],
               True, 
               entry2 = entry1
          ];

          temp = NCHighestDegreePosition[ entry2 ];

If[ convertdebug, Print[ "convertdebug: NCHighestDegreePosition ",temp ]];

          If[ Length[ temp ] > 1, temp = { temp[[1]] } ];

          initialmono = temp;
If[ convertdebug, Print[ "convertdebug : initialmono: ",initialmono ]];

          right = Apply[ Plus, -Drop[ terms[ entry2 ], initialmono ] ]; 
          left = entry2[[ initialmono ]];
If[ convertdebug, Print["convertdebug : right: ",right]];
If[ convertdebug, Print["convertdebug : left: ",left]];
(* make left monic *)
          If[ Head[left]==Times,
               (* then *)
               oldleft = left[[1]];
               left = left/oldleft;
               right = right/oldleft
          ];
Return[left->right]
     ];

(* ------------------------------------------------------------------ *)
(* LeftPatternRule                                                    *)
(* ------------------------------------------------------------------ *)

LeftPatternRule[Y_Rule]:=
Block[
          {A, left, right, temp, leftvariables, blankfunction, blankleft,
	  patternleft, patternright,out},
          SetNonCommutative[ front, back ];
          Off[ Pattern::rhs ];      (* Mathematica 1.2 *)
          Off[ RuleDelayed::rhs ];  (* Mathematica 2.0 *)

left=Y[[1]];
right=Y[[2]];
(* defining leftvariables, a list of all the variables on the left.  *)
          temp = Union[ Level[ left, {-1} ] ];
          temp = temp/.{-1->{}};
          temp = temp/.{1->{}};
          temp = Union[ temp ];
          leftvariables = Flatten[ temp ];
     
          blankfunction[ A_]:= A-> A__;
          blankleft = left /. Map[ blankfunction, leftvariables ];
          patternleft = front___ ** blankleft ** back___;
          patternright = ExpandNonCommutativeMultiply[ front ** right ** back ];
          out = patternleft -> patternright;
          On[ Pattern::rhs ];      (* Mathematica 1.2 *)
          On[ RuleDelayed::rhs ];  (* Mathematica 2.0 *)
Return[{out, blankleft->right}]
];

LeftPatternRule[ Y_List ]:= Map[ LeftPatternRule, Y];

(* ------------------------------------------------------------------ *)
(* terms                                                              *)
(* ------------------------------------------------------------------ *)

terms[ input_ ] := Apply[ List, ExpandNonCommutativeMultiply[ input ] ];

(* ------------------------------------------------------------------ *)
(* degrees                                                            *)
(* ------------------------------------------------------------------ *)
degrees[x_] := 
     Block[{dlist},
          dlist = Select[ x, !#===0& ];
          Return[Length[dlist]]
     ];

(* ------------------------------------------------------------------ *)
(* assignweights                                                      *)
(* ------------------------------------------------------------------ *)

(* this big 2 For loop outputs a list where every entry represents a
weight for each term of the expression *)

(* Alist = factorlist, Blist = termlist *)
assignweights[ Alist_, Blist_ ] :=
     Block[ {n, weights, partialweight, m, X2, K1, a, b ,h1, h2, k2  },
(* the block of assignweights[x] tests some expressions that are
occassionally too short, so these error messages are the result of logically
poor organization of test conditions rather the some underlying bug. *)
          Off[ Part::width ];  (* Mathematica 1.2 *) 
          Off[ Part::partw ];  (* Mathematica 2.0 *)

          weights = Blist;
          For[ n=1, n< Length[ Alist ]+1, n++,
               partialweight = 0;
               For[m=1, m< Length[ factorlist[[n]] ] + 1, m++,
(* commutative factors get a 0 *)
                    If[ CommutativeQ[ factorlist[[ n,m ]] ], 
		         partialweight = 0
		    ];
(*
Print["debug insert: CQ ",TrueQ[ CommutativeQ[ factorlist[[ n,m ]] ] == True]
];
*)
(* noncommutative factors get a 1 *)
                    If[ Not[ CommutativeQ[ factorlist[[ n,m ]] ] ],
                         partialweight = 1 
                    ];
                    If[ Length[ factorlist[[ n,m ]] ]==2 && 
                         Not[ CommutativeQ[ factorlist[[ n,m,2 ]] ] ],
                         partialweight = 1 
                    ];
(* inv[commutative]  gets a 2 *)
                    If[ !FreeQ[ factorlist[[ n,m ]], inv[X2_] ] &&
                         CommutativeQ[ factorlist[[ n,m,1 ]] ] && 
                         Length[ factorlist[[ n,m,1 ]] ] <2, 
                         partialweight = 2
                    ];
(* inv[ NonCommutative ] gets a 3 *)
                    If[  Not[ FreeQ[ factorlist[[ n,m ]], inv[X2_] ] ] &&
                         Not[CommutativeQ[ factorlist[[ n,m,1 ]] ]], 
                         (* then *)
                         partialweight = 3
                    ];	
(* -inv[ NonCommutative ] gets a 3 *)
                    If[  Not[ FreeQ[ factorlist[[ n,m ]], inv[X2_] ] ] &&
                         factorlist[[ n,m,1 ]] == -1 &&
                         Not[CommutativeQ[ factorlist[[ n,m,2 ]] ]],
                         partialweight = 3
                    ];	
(* @@@ 2 *)
(* inv[ complicated ] gets a 4 *)
TestQ[X3_]:= CommutativeQ[X3] || NumberQ[X3];
                    h1[ K1_.*inv[K3_?TestQ + K2_.**a_**b___ ]]:=True;
                    If[ TrueQ[ h1[ factorlist[[ n,m ]] ]], 
			 partialweight = 4
		    ];
                    h2[ K1_.*inv[K3_?TestQ + K2_.**a_ ]]:=True;
                    If[ TrueQ[ h2[ factorlist[[ n,m ]] ]], 
			 partialweight = 4
		    ];
                    factorlist[[ n,m ]] = partialweight;
(*
Print["debug insert: factorlist[[n,m]]",factorlist[[n,m]] ];
*)
               ]; (* end innerloop *)

(* this adds the partialweights from factors to get a total weight for the 
nth term *)
               weights[[ n ]] = Apply[ Plus, factorlist[[n]] ];
(*
(* use these to check the partialweights are being assigned *)
               Print[n];	
               Print["weights[[ n ]] :",weights[[ n ]]];
               Print["List of factors[[ n ]] :", factorlist[[ n]]];
*)
          ];
          On[ Part::width ];  (* Mathematica 1.2 *) 
          On[ Part::partw ];  (* Mathematica 2.0 *)
     Return[ weights ]
     ];	

(* ------------------------------------------------------------------ *)
(* factors                                                            *)
(* ------------------------------------------------------------------ *)

factors[ x__, opts___ ] := 
     Block[{ h, B },
          factorsdebug = factorsdebug/.{opts}/.Options[ NCHighestDegreePosition ];
          Which[

(*  DECISIONS:
-	All leading coeffients should be returned signed, for pattern-matching.
*)
(* numbers *)
               (* single numeric commutative factor *)
               (* e.g.,  2,  -2 , 1.2,   2/3        *)
               Head[x]===Integer || Head[x]===Rational || Head[x]===Real, 
If[ factorsdebug,               Print["single C number"]]; 
               Level[ x,{0} ],

(* symbols *)

               (* single symbolic commutative factor *)
	       (* e.g.,  A,  B,  S,  X               *)
               Length[x]===0 && Head[x]===Symbol && CommutativeQ[x], 
               (* Print["single C symbol"];*)
If[ factorsdebug,               Print["single +C symbol"]];
               Level[ x,{0} ],

(*
               (* single -commutative factor *)
	       (* e.g., -A, -B, -S, -X       *)
               Head[x]===Times && LeafCount[x]===3 
               && CommutativeQ[x[[2]] ],
               (* Print["single -C symbol"]; *) 
If[ factorsdebug,               Print["single -C symbol"]]; 
               Level[x,{0} ],
*)
     
               (* single noncommutative factor *)
               (* e.g.,  a, b, c, d            *)
               Head[x]===Symbol && Not[CommutativeQ[x]], 
               (* Print["single NC"]; *)
If[ factorsdebug,               Print["single NC"]]; 
               Level[ x,{0} ],

(* @@@ 1 *)
               (* single function of a noncommutative variable *)
               Not[FreeQ[x,h_[B_]]] && Length[x]===1,
               (* Print["single f[ NC ]"]; *)
If[ factorsdebug,               Print["single f[ NC ]"]]; 
               Level[x, {0}],

               (*scalar * power product involving a function of a noncommutative variable *)
               Not[FreeQ[x,h_[B_]]] && !CommutativeQ[x] && Head[x]===Times,
               (* Print["C x** y** f[ NC ]** z"]; *)
If[ factorsdebug,               Print["C x** y** f[ NC ]** z"]]; 
               Level[x, {1}],



               
               (* single -function of a noncommutative variable *)
               Not[FreeQ[x,-h_[B_]]] && Length[x]===2,
               (* Print["single -f[ NC ]"]; *) 
If[ factorsdebug,               Print["single -f[ NC ]"]]; 
               Level[x, {0}],
               
               (* multi commutative term *)
               Head[x] === Times && FreeQ[ x, NonCommutativeMultiply], 
               (* Print["multi C"]; *) 
If[ factorsdebug,               Print["multi C"]]; 
               Level[ x,{-1} ],
               
Length[x]>2 && Apply[And, (!CommutativeQ[#1] & ) /@ Flatten[{Apply[List, Last[Apply[List, x]]]}]] && CommutativeQ[First[Apply[List,x]]],
If[ factorsdebug,Print["multi C scalars and NC factors"]];
Map[terms, terms[x]],

               (* multi noncommutative 'negative' term *)
               Head[x]=== Times && 
               Not[ FreeQ[x, NonCommutativeMultiply]],
               (* Print["multi -NC"]; *) 
If[ factorsdebug,               Print["multi -NC"]]; 
               Level[x,{2}], 
               
               (* multi noncommutative term *)
               Head[x] === NonCommutativeMultiply, 
               (* Print["multi +NC"];*) 
If[ factorsdebug,               Print["multi +NC"]];
               Level[x, 1],

(* ------------------------------------------------------------- *)

               (* single -noncommutative factor *)
               Head[x]===Times && Length[x]===2 
               && Not[CommutativeQ[x[[2]]] ],
               (* Print["single -NC"];*) 
If[ factorsdebug,               Print["single -NC"]];
               Level[-x,{0} ],
               
               (* scalar * single NC *)
               Length[x]===2 && Head[x[[2]] ] === Symbol 
               && Not[CommutativeQ[x[[2]]]],
               (* Print["scalar * single NC"]; *) 
If[ factorsdebug,               Print["scalar * single NC"]];
               Level[x,{0}],

               (* scalar * single C *)
               Length[x]===2 && Head[x[[2]] ] === Symbol 
               && CommutativeQ[x[[2]]],
               (* Print["scalar * single C"]; *) 
If[ factorsdebug,               Print["scalar * single C"]];
               Level[x,{0}]
                    
          ]
     ];

(* ------------------------------------------------------------------ *)
(* NCHighestDegreePosition                                            *)
(* ------------------------------------------------------------------ *)

NCHighestDegreePosition[ expression_, opts___ ]:=
     Block[
          { maxterms, scorelist, f, degreelist, h1, h2, weightlist, n,
          partialweight, m, factorlist, K1, K2, a, b, X3, expr1, 
          sortedmaxtermlist, termlist, NCHDPdebug, g, maxtermposition },

NCHDPdebug = NCHDPdebug/.{opts}/.Options[NCHighestDegreePosition];
          expr1 = expression;

          SetCommutative[K1,K2];
          SetNonCommutative[ a,b,X3];

(* make a list of all terms *)
          termlist = terms[ expr1 ];

               If[ NCHDPdebug, 
                    Print["-------------------------------------"];
                    Print["NCHDP : debug1: termlist =",termlist];
               ];
(* factorlist is a termlist long list of factors *)
          factorlist = Map[ factors, termlist ];

               If[ NCHDPdebug, Print["NCHDP :debug2: factorlist =",factorlist]];

(* weightlist is a list with each entry representing a term of the expression,
   in which each number represents the sum of weights assigned to different
   kinds factors. *)
         weightlist = assignweights[ termlist, factorlist ];

               If[ NCHDPdebug, Print["NCHDP :debug4: weightlist =",weightlist]];

(* degreelist is a kind of crude degree count for each term *)
          degreelist = Map[ degrees, factorlist ];

               If[ NCHDPdebug, Print["NCHDP :debug5: degreelist =",degreelist]];

(* scorelist adds the 'degree count' to the weights for certain factors
*)
     scorelist = weightlist + degreelist;

          If[ NCHDPdebug, Print["NCHDP : debug6: scorelist =",scorelist]];

(* maxterms is a list of the positions of the highest scoring terms *)
          maxterms = Flatten[ Position[ scorelist, Max[ scorelist ] ] ];
          maxtermlist = termlist[[  maxterms ]];
(*  Print[ "termlist = ",termlist];  *)
(*  Print[ "maxtermlist =",maxtermlist ];  *)

          sortedmaxtermlist = Sort[ maxtermlist ];
(*  Print[ "sortedmaxtermlist = ", sortedmaxtermlist ];  *)
          maxterm = Last[ sortedmaxtermlist ];
(*  Print[ "maxterm = ", maxterm ];  *)
          maxtermposition = Position[ termlist, maxterm ];
(*  Print[ "maxtermposition = ", maxtermposition ];  *)
          Return[ Flatten[ maxtermposition ] ]
     ];

NCHighestDegree[ thing_]:= thing[[ NCHighestDegreePosition[thing] ]];

End[ ]

EndPackage[ ]
