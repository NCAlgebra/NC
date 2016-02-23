(* CHANGED BY MARK *)
(* :Title: 	NCSubstitute // Mathematica 1.2 and 2.0 *)

(* :Author: 	David Hurst (dhurst). *)

(* :Context: 	NCSubstitute` *)

(* :Summary:
		NCSubstitute is a package containing several functions that 
		are useful in making replacements in noncommutative expressions.
*)

(* :Alias:
		FORules ::= FunctionOnRules, Sub ::= Substitute, 
		SubSym ::= SubstituteSymmetric, 
		SubRev ::= SubR ::= SubstituteReverse, 
		SubRevSym ::= SubRSym ::= SubstituteReverseSymmetric, 
		SubSingleRep ::= SubstituteSingleReplace, 
		SubAll ::= SubstituteAll, SaveR ::= SaveRules, 
		SaveRQ ::= SaveRulesQ
*)

(* :Warnings: 
		Currently, there is no provision for returning rules from 
		the Rules.temp file.  Also, all commands with Reverse in 
		their names, reverse the order of the original list of 
		rules and exchanges lhs for rhs in each rule.  
		When this package loads, it does not
                turn on the SaveRules feature, 
		to turn it on, type ' SaveRules[ On ] .
*)

(* :History: 
   :9/91	Packaged. (dhurst)
   :5/1/92	Made compatible for math 2.0. (dhurst)
   :5/20/92	Removed vestigial code from pSubstitute. (dhurst)
   :7/5/92	Used Thread to make p3 in Transform for speed. (dhurst)
   :7/29/92	Faster Transform using "dummy" for "**". (dhurst)
*)

(* :Comments:

# indicates an External function

#   1.		Substitute
    2.		pSubstitute
#   3.		Transform
#   4.		SubstituteReverse
    5.		pSubstituteReverse
#   6.		SubstituteSymmetric
#   7.		SubstituteReverseSymmetric
#   8.		SubstituteSingleReplace
#   9.		SubstituteAll
#  10.		FunctionOnRules
   11.		pFunctionOnRules
#  12.		RulesComplement
#  13.		ShowRules[]
#  14.		SaveRules[]
#  15.		SaveRulesQ[]
#  16.		date
*)

(* ------------------------------------------------------------------ *)
(* openRULES -this establishes a Global Context for $openRULES        *)
(* ------------------------------------------------------------------ *)
$openRULES;
Unprotect[ $openRULES ];
$openRULES = Off;     (*Bill turned off sept 2004*)
Protect[ $openRULES ];

BeginPackage[ "NCSubstitute`", 
"NonCommutativeMultiply`" ];

(* ------------------------------------------------------------------ *)
(* USAGE statements                                                   *)
(* ------------------------------------------------------------------ *)
RulesComplement::usage=
"RulesComplement[ rules ] creates a list of rules a -> b and\n
ExpandNonCommutativeMultiply[ -a ] -> b.  This function is called on all\n
NCSubstitute commands except Transform.";

Unprotect[ date ];
date::usage =
"date[ ] returns the current system date and time.";

FunctionOnRules::usage =
"FunctionOnRules[ rules, function1, function2, 'optional On' ] \n
applies function1 to the lhs and function2 to the rhs of each member \n
of a set of rules, thereby making new rules.  A third positional option \n
of 'On' records rules into a file called Rules.temp.  If not used this \n
option defaults as 'Off'.  Alias: FORules.";

Substitute::usage =
"Substitute[ expr, rules, 'optional On' ] allows the repeated replacement\n 
of rules into noncommutative expressions.  A third positional option of \n
'On' records rules into a file called Rules.temp.  If not used this option\n 
defaults as 'Off'.  Alias: Sub.";

Transform::usage =
"Transform[ expr, rules, 'optional On' ] allows the repeated replacement\n
of rules into noncommutative expressions.  Transform does not use the\n 
Rules.temp file nor does it alter the rules.";

SubstituteSymmetric::usage =
"SubstituteSymmetric[ expression, rules, 'optional On' ] replaces \n
the lhs's of rules with the rhs's and matching transposes of the lhs's \n
with the transposes of the rhs's.  A third positional option of 'On' \n
records rules into a file called Rules.temp.  If not used this option \n
defaults as 'Off'.  Alias:  SubSym.";

SubstituteReverse::usage =
"SubstituteReverse[ expression, rules, 'optional On' ], if used with a \n
set of rules previously used, will return the expression to its original \n
state with respect to that set of rules only.  A third positional option \n
of 'On' records rules into a file called Rules.temp.  If not used this \n
option defaults as 'Off'.  Alias: SubRev, SubR.";

SubstituteReverseSymmetric::usage =
"SubstituteReverseSymmetric[ expression, rules, 'optional On' ] attempts \n
to reverse the effects of a previous SubstituteSymmetric using the same \n
rules.  A third positional option of 'On' records rules into a file called \n
Rules.temp.  If not used this option defaults as 'Off'.  Alias:  SubRevSym, \n
SubRSym.";

SubstituteSingleReplace::usage =
"SubstituteSingleReplace[ expression, rules, 'optional On' ] uses /. to make\n
noncommutative replacements.  Allows a -> f[a] without causing a loop.\n
A third positional option of 'On' records rules into a file called \n
Rules.temp.  If not used this option defaults as 'Off'. \n 
Alias:  SubSingleRep.";

SubstituteAll::usage =
"SubstituteAll[ expression, rules, 'optional On' ] substitutes a set \n
of rules into the original expression, then Maps the tp, rt, and inv \n
functions, each in turn, onto the set of rules. A third positional option \n
of 'On' records rules into a file called Rules.temp.  If not used this \n
option defaults as 'Off'.  Alias:  SubAll.";

ShowRules::usage =
"ShowRules[ ] displays the Rules.temp file using the UNIX 'more' filter.";

Options[ SaveRules ] := {tag->"tag"};
SaveRules::usage =
"SaveRules[ expression, optional tag->'message' ] opens and records \n
expressions and optional explanatory tags in a file called Rules.temp.\n
SaveRules[ On ] makes a continuous record of substitution rules and \n
over-rides use of 'Off' as an individual substitute command option.\n
SaveRules[ Off ] stops making a continuous record of substitution rules,\n
but individual substitute commands can still use the 'On' argument\n
option.  Alias:  SaveR.";

SaveRulesQ::usage =
"SaveRulesQ[ ] returns the open or closed status of the Rules.temp \n
file as True or False.  The Rules.temp remains in the user's directory \n
after the session is terminated.  Alias:  SaveRQ.";

Begin["`Private`"]

(* ------------------------------------------------------------------ *)
(* Program Messages                                                   *)
(* ------------------------------------------------------------------ *)
FunctionOnRules::BadInput = 
"Acceptable inputs are a single rule or a list of rules only.";

SaveRulesQ::On = 
"The Rules.temp file is recording substitution rules.";

SaveRulesQ::Off = 
"The Rules.temp file is not recording substitution rules.";

(* 1 *)
(* ------------------------------------------------------------------ *)
(* Substitute                                                         *)
(* ------------------------------------------------------------------ *)
Substitute[expr__, rules_, RULES_:Off ] := 
   Block[ {front, back, p0, p1, p2, p3, hold, f, g, rule, n, out}, 

(*  sets front and back portions to be NC.  *)
	SetNonCommutative[front, back]; 

(*  wraps front___ & back___ around lhs of rule. *)
	f[rule_] := ((front___) ** rule[[1]]) ** (back___); 

(*  wraps front & back around rhs of rule.  *)
	g[rule_] := (front ** rule[[2]]) ** back; 

(*  rename the 'rules' variable.  *)
	hold = rules;

(*  makes every rule a list.  *)
	p0 = RulesComplement[ Flatten[{hold}] ]; 

(*  makes a list of all of the lhs's of the rules with front___ &
    back___ wrapped around each.  *)
	p1 = f /@ p0; 

(*  makes a list of all of the rhs's of the rules with front & back 
    wrapped around each.  *)
	p2 = g /@ p0; 

(*  initializes a new list of the same length.  *)
	p3 = p1;

(*  reforms the list (p3), matching lhs's and rhs's into new rule list.  *)
	For[n=1, n<Length[p1]+1,n++, p3[[n]]=p1[[n]]->p2[[n]]];

(*  assigns to 'out' the result of substituting the new list (p3) and
    the original (p0) list into the original expression (expr).  Some
    'simple expressions and/or subexpressions that escape p3 don't escape p0. *)
	out = expr //. Join[p3,p0]; 

(*  save rules code.                                                  *)
	If[ Global`$openRULES == On && RULES ==On, 
	SaveRules[ Flatten[{hold}], tag->"Substitute" ] 
	  ];

	Return[out]
];

 
(* 2 *)
(* ------------------------------------------------------------------ *)
(* pSubstitute                                                        *)
(* ------------------------------------------------------------------ *)
pSubstitute[expr__, rules_ ] := 
   Block[ {front, back, p0, p1, p2, p3, hold, f, g, rule, n, out}, 

(*  sets front and back portions to be NC.  *)
	SetNonCommutative[front, back]; 

(*  wraps front___ & back___ around lhs of rule. *)
	f[rule_] := ((front___) ** rule[[1]]) ** (back___); 

(*  wraps front & back around rhs of rule.  *)
	g[rule_] := (front ** rule[[2]]) ** back; 

(*  rename the 'rules' variable.  *)
	hold = rules;

(*  makes every rule a list.  *)
	p0 = RulesComplement[ Flatten[{hold}] ]; 

(*  makes a list of all of the lhs's of the rules with front___ &
    back___ wrapped around each.  *)
	p1 = f /@ p0; 

(*  makes a list of all of the rhs's of the rules with front & back 
    wrapped around each.  *)
	p2 = g /@ p0; 

(*  initializes a new list of the same length.  *)
	p3 = p1;

(*  reforms the list (p3), matching lhs's and rhs's into new rule list.  *)
	For[n=1, n<Length[p1]+1,n++, p3[[n]]=p1[[n]]->p2[[n]]];

(*  assigns to 'out' the result of substituting the new list (p3) and
    the original (p0) list into the original expression (expr).  Some
    'simple expressions and/or subexpressions that escape p3 don't escape p0. *)
	out = expr //. Join[p3,p0]; 

	Return[out]
];

(* 3 *)
(* ------------------------------------------------------------------ *)
(* Transform                                                          *)
(* ------------------------------------------------------------------ *)
Transform[expr_,0->0] := expr;

Transform[expr__, rules_ ] := 
   Block[ {front, back, dummy, rules2, p0, p1, p2 }, 

	SetNonCommutative[front, back]; 

(*  makes every rule a list.  *)
	p0 = Flatten[{rules}]; 

(*  makes the list (p3), matching lhs's and rhs's into new rule list.  *)
	p1 = Thread[ 
	          Rule[
	               (((front___) ** #[[1]]) ** (back___))& /@ p0,
		       ((front ** #[[2]]) ** back)& /@ p0
    		  ] 
	    ];

	p2 = expr //. NonCommutativeMultiply->dummy;

	rules2 = Join[p1,p0]//.NonCommutativeMultiply->dummy;

	Return[	p2 //. rules2 //. dummy -> NonCommutativeMultiply ]
     ];

(* 4 *)
(* ------------------------------------------------------------------ *)
(* SubstituteReverse                                                  *)
(* ------------------------------------------------------------------ *)
SubstituteReverse[ expr_, rules_, RULES_:Off ] := 
     Block[ {hold, exp, out},
          hold = rules;
          exp = expr;
          out = expr; 
          If[ 
               (*Single rule condition*) 
                    TrueQ[ Head[ hold ] == Rule ] || 
	            TrueQ[ Head[ hold ] == RuleDelayed ],
	                 out = pSubstitute[ exp, hold[[ 2 ]] -> hold[[ 1 ]] ],
               (*List of rules condition*) 
                    out = pSubstitute[ exp, 
     		               Map[ ( #[[2]] -> #[[1]] )&, Reverse[hold] ] 
                               ]
          ];
          If[ Global`$openRULES == On && RULES == On, 
	       	SaveRules[ Flatten[{rules}], tag->"SubstituteReverse" ] 
	  ];
          Return[ out ]
     ];

(* 5 *)
(* ------------------------------------------------------------------ *)
(* pSubstituteReverse                                                 *)
(* ------------------------------------------------------------------ *)
pSubstituteReverse[ expr_, rules_] := 
     Block[ {hold, exp, out},
          hold = rules;
          exp = expr;
          out = expr; 
          If[ 
               (*Single rule condition*) 
                    TrueQ[ Head[ hold ] == Rule ] || 
	            TrueQ[ Head[ hold ] == RuleDelayed ],
	                 out = pSubstitute[ exp, hold[[ 2 ]] -> hold[[ 1 ]] ],
               (*List of rules condition*) 
                    out = pSubstitute[ exp, 
     		               Map[ ( #[[2]] -> #[[1]] )&, Reverse[hold] ] 
                               ]
          ];         
          Return[ out ]
     ];

(* 6 *)
(* ------------------------------------------------------------------ *)
(* SubstituteSymmetric                                                *)
(* ------------------------------------------------------------------ *)
SubstituteSymmetric[ expr_, rules_, RULES_:Off ] := 
     Block[ {exp, ex, hold, out}, 
	  exp = expr;
	  hold = rules;
          ex = pSubstitute[ exp, hold ];
          out = pSubstitute[ ex, 
	             pFunctionOnRules[hold, NonCommutativeMultiply`tp, 
                          NonCommutativeMultiply`tp]
		];
          If[ Global`$openRULES == On && RULES == On, 
	       SaveRules[ Flatten[{rules}], tag->"SubstituteSymmetric" ] 
	  ];
          Return[ out ]
     ];

(* 7 *)
(* ------------------------------------------------------------------ *)
(* SubstituteReverseSymmetric                                         *)
(* ------------------------------------------------------------------ *)
SubstituteReverseSymmetric[ expr_, rules_, RULES_:Off ] := 
     Block[ {exp, len, hold, out, exp1},
          exp = expr;
          hold = rules;
          out = expr;
          exp1 = pSubstituteReverse[ exp, 
	              pFunctionOnRules[ hold, NonCommutativeMultiply`tp, 
                           NonCommutativeMultiply`tp ]
	 	 ];
          out = pSubstituteReverse[ exp1, hold ]; 
          If[ Global`$openRULES == On && RULES == On, 
	       SaveRules[ Flatten[{rules}], tag->"SubstituteReverseSymmetric" ] 
	  ];
          Return[ out ]
     ];

(* 8 *)
(* ------------------------------------------------------------------ *)
(* SubstituteSingleReplace                                            *)
(*                                                                    *)
(* There is no pSubstituteSingleReplace, because no current module    *)
(* makes calls to this program.                                       *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)
SubstituteSingleReplace[ expr_, rules_, RULES_:Off ] := 
     Block[ {n, out, p0, p1, p2, p3}, 
          SetNonCommutative[ front, back ]; 
	  hold = rules;
          f[ rule_ ] := (front___) ** rule[[1]] ** (back___); 
          g[ rule_ ] := front ** rule[[2]] ** back; 
          p0 = RulesComplement[ Flatten[ {hold} ] ]; 
          p1 = f /@ p0; 
          p2 = g /@ p0; 
	  p3 = p1;
   	  For[n=1, n < Length[p1] + 1, n++, 
               p3[[ n ]] = p1[[ n ]] -> p2[[ n ]]
          ];
               out = expr /. Join[p3, p0]; 
          If[ Global`$openRULES == On && RULES == On, 
	       SaveRules[ Flatten[{rules}], tag->"SubstituteSingleReplace" ] 
	  ];
          Return[ out ]
     ];

(* 9 *)
(* ------------------------------------------------------------------ *)
(* SubstituteAll                                                      *)
(* ------------------------------------------------------------------ *)
SubstituteAll[ expr_, rules_, RULES_:Off ] :=
     Block[ {exp, exp1, exp2, exp3, out, len, hold},
          exp = expr;
          out = expr;
          hold = rules;
          exp1 = pSubstitute[ exp, hold ];
          exp2 = pSubstitute[ exp1, 
		      pFunctionOnRules[ hold, NonCommutativeMultiply`tp, 
		           NonCommutativeMultiply`tp ]
		 ];
          exp3 = pSubstitute[ exp2, 
		      pFunctionOnRules[ hold, NonCommutativeMultiply`inv, 
			   NonCommutativeMultiply`inv ]
	 	 ];
          out = pSubstitute[ exp3, 
		     pFunctionOnRules[ hold, 
  		          NonCommutativeMultiply`rt, 
			  NonCommutativeMultiply`rt ]
		 ];
          If[ Global`$openRULES == On && RULES ==On, 
	       SaveRules[ Flatten[{rules}], tag->"SubstituteAll" ] 
	  ];
          Return[ out ]
     ]; 

(* 10 *)
(* ------------------------------------------------------------------ *)
(* FunctionOnRules                                                    *)
(* ------------------------------------------------------------------ *)
FunctionOnRules[ rules_, functionL_, functionR_, RULES_:Off ] :=
     Block[ {len, hold},
          hold = rules;
	  len = Length[ rules ];
          f[ x_ ] := Rule[ functionL[ x[[ 1 ]] ], functionR[ x[[ 2 ]] ]  ];
          Which[ 
               (*Single rule condition*) 
                    TrueQ[ Head[ hold ] == Rule ] ||
                    TrueQ[ Head[ hold ] == RuleDelayed ],      
	                 hold = f[ hold ],
               (*List of rules condition*) 
                    TrueQ[ Head[ hold ] == List ], 
	                 For[ i=1, i < len + 1, ++i,
		              hold[[ i ]] = f[ hold[[i]] ]
                         ],
               (*Default condition *) 
	            True, 
                         Message[ FunctionOnRules::BadInput ] 
          ];         
          If[ Global`$openRULES == On && RULES == On, 
	       SaveRules[ Flatten[{rules}], tag->"FunctionOnRules" ] 
          ];
          Return[ hold ]
     ];

(* 11 *)
(* ------------------------------------------------------------------ *)
(* pFunctionOnRules                                                   *)
(* ------------------------------------------------------------------ *)
pFunctionOnRules[ rules_, functionL_, functionR_ ] :=
     Block[ {len, hold},
          hold = rules;
	  len = Length[ rules ];
          f[ x_ ] := Rule[ functionL[ x[[ 1 ]] ], functionR[ x[[ 2 ]] ]  ];
          Which[ 
               (*Single rule condition*) 
                    TrueQ[ Head[ hold ] == Rule ] ||
                    TrueQ[ Head[ hold ] == RuleDelayed ],      
	                 hold = f[ hold ],
               (*List of rules condition*) 
                    TrueQ[ Head[ hold ] == List ], 
	                 For[ i=1, i < len + 1, ++i,
		              hold[[ i ]] = f[ hold[[i]] ]
                         ],
               (*Default condition *) 
	            True, 
                         Message[ FunctionOnRules::BadInput ] 
          ];
          Return[ hold ]
     ];

(* 12 *)
(* ------------------------------------------------------------------ *)
(* RulesComplement                                                    *)
(*                                                                    *)
(* inputs a list, removes non-Rule-like objects,                      *)
(* returns NCE[-a] -> -b, for every a ->b.                            *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)
RulesComplement[ X_ ] :=
     Block[ {tmp1, Y, allrulelist, complementlist, out},
	  Off[ Pattern::rhs ];
	  tmp1 = Flatten[ {X} ];
          allrulelist =
               Select[ tmp1,
                    If[ Head[#1] === Rule ||
	 	         Head[#1] === RuleDelayed,
		         True
	            ] &
               ];
               complementlist =
                    Map[
                         Which[
                              Head[#] === Rule,
        	                   ExpandNonCommutativeMultiply[ -#[[1]] ] -> 
				   -#[[2]],
                              Head[#] === RuleDelayed,
		         	   ExpandNonCommutativeMultiply[ -#[[1]] ] -> 
				   -#[[2]]
                         ]& ,
	                 allrulelist
		    ];
               out = Flatten[ Append[ allrulelist, complementlist ] ];
	       On[ Pattern::rhs ];
	       Return[ out ] 
      ];

(* 13 *)
(* ------------------------------------------------------------------ *)
(* ShowRules                                                          *)
(* ------------------------------------------------------------------ *)
ShowRules[ ] := Run["more Rules.temp"];

(* 14 *)
(* ------------------------------------------------------------------ *)
(* SaveRules                                                          *)
(* ------------------------------------------------------------------ *)
SaveRules[ entry_, opts___ ] :=
     Block[ { },
	  tag2 = tag/.{opts}/.Options[SaveRules];
	  Unprotect[ Global`$openRULES ];
          Which[
               entry === On, Global`$openRULES = On,
               entry === Off, Global`$openRULES = Off,
	       True,
                    OpenAppend[ "Rules.temp" ];
                    Write[ "Rules.temp", date[], "     ", tag2];
		    Write[ "Rules.temp", entry ];
		    Write[ "Rules.temp", "------" ];
                    Close[ "Rules.temp" ]
          ];
	  Protect[ Global`$openRULES ];
     ];

(* 15 *)
(* ------------------------------------------------------------------ *)
(* SaveRulesQ                                                         *)
(* ------------------------------------------------------------------ *)
SaveRulesQ[ ] :=
    Block[{ },
          If[ TrueQ[ Global`$openRULES == On ], 
               Message[ SaveRulesQ::On ]; True,
               Message[ SaveRulesQ::Off ]; False 
	  ]
    ];

(* 16 *)
(* ------------------------------------------------------------------ *)
(* date                                                               *)
(* ------------------------------------------------------------------ *)

(*
*     Block[ { process,result },
*	  If[ TrueQ[ Global`$$OperatingSystem == "UNIX" ],
*		(* then *)
*		process = OpenRead[ "!date" ];
*		result = Read[ process, String ];
*		If[  result === EndofFile, Return[] ];
*		Close[ process ]; 
*		Return[ result ]
*	 ]
*     ];
*)

(*--------------------------------------------------------------------*)

End[ ]

EndPackage[ ]

