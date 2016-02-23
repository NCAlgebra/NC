(* :Title: 	NC0SimplifyRational.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Bill Helton (helton). *)

(* :Context: 	NC0SimplifyRational` *)

(* :Summary: 	NCSimplify0Rational first applies the function 'NCCombine' 
		to the expression input.  'NCCombine' will group the terms 
		with the same inv[] together.  Then this function
		(NCSimplify0Rational) will look for the pattern inv[] in 
		the expression.  Everything in inv[] will be replaced by a 
		variable. All the variables in the 'everything' will be 
		collected into a list and will be expressed in terms of the 
		variables used to replace them.  Then an 
		ExpandNonCommutativeMultiply is done. The 'NCCombine' 
		function is applied again. Finally, the original expressions 
		are substituted back into the inv[]s.
		
		example: a**inv[a+b]+inv[c+d]**e => 
		 	 Id - b**inv[a+b]+inv[c+d]**e
*)

(* :Alias:	NCS0R ::= NCSimplify0Rational *)

(* :Warnings:	Not well understood. (dhurst)	*)

(* :History: 
   :8/9/90 	algorithm changed by reading the expression together.
		example: a**inv[a+b]+inv[c-a]**(a-c)+inv[c+d]**(c+d+e)
		==> a**inv[a+b] + inv[c+d]**e
   :8/14/90	method of reading the expression is discarded.
		list of replacement rules are applied instead.
		example: inv[a]**(a-b)**inv[b] -> inv[b]-inv[a]
   :8/18/92 	Packaged. (dhurst)
*)

(* :Bugs: 	Tue Aug 18 13:06:44 PDT 1992
		resid =
		inv[1 - a] ** (a - b) ** inv[1 - b] - inv[1 - a] + inv[1 - b]
		NCS0R[resid]
		Part::width: Part 1 of {} does not exist.

*)

BeginPackage[ "NCSimplify0Rational`",
     "NCCollect`", "NonCommutativeMultiply`" ]

NCCombine ::usage = "...";
NCSimplify0Rational ::usage = " ... ";
LHS ::usage = " ... ";
RHS ::usage = " ... ";

Begin[ "`Private`" ]

LHS[equation_] := equation //. a_ == b_ :> a;

RHS[equation_] := equation //. a_ == b_ :> b;

NCCombine[ exp_Symbol ] := Return[exp];

NCCombine[ exp_ ] :=
     Block[
          { i, j, k, l, lenexp, length, notdoneflag, posit, position,
          positionlist, poslist, sortedlist, sortedsublist, sublist,
          temp, temp0, temp1, tempcount, tempelement, tempexp, temppart,
          termlist },
          tempexp = exp;
          sortedlist={};
          sortedsublist={};
          sublist = {};
          temp = {};
          poslist = {};
          termlist = {};
          posit = {};
          position = {};
     
(* get the positions of all the inverses in the expression *)
          posit = Position[exp,inv[_]]; 
          For[i=1,i<=Length[posit],i++,
               If[posit[[i]]!={},
                    AppendTo[position,posit[[i]]]
               ]
          ];
          length = Length[position];
          lenexp = Length[exp];

(* the for loops are used to obtain the expression in the inverses *)
          For[i=1,i<=length,i++,
               AppendTo[poslist,position[[i,1]]];
               AppendTo[termlist,exp[[position[[i,1]]]]];
               temp0 = exp;
               For[j=1,j<=Length[position[[i]]],j++,	
                    temp1 = temp0[[position[[i,j]]]];
                    temp0 = temp1
               ];

(* this stores the expressions inside the inverses as a list for reverse
substituting later *)
               AppendTo[sublist,temp0];  
          ];
          sortedlist={Count[sublist,sublist[[1]]]};
          sortedsublist={sublist[[1]]};

          For[i=2,i<=Length[sublist],i++,
               tempelement=sublist[[i]];
               tempcount = Count[sublist,tempelement];
               j=1;
               notdoneflag=True;
               While[j<=Length[sortedlist]&&notdoneflag,
                    If[tempcount>=sortedlist[[j]],
                         AppendTo[sortedlist,tempcount];
                         AppendTo[sortedsublist,sublist[[i]]];
                         notdoneflag=False
                    ];
                    If[notdoneflag,
                         Join[sortedlist,{tempcount}];
                         Join[sortedsublist,{sublist[[i]]}]
                    ];
                    j++
               ]
          ];
          Return[NCStrongCollect[tempexp,sortedsublist]] 
     ];

NCSimplify0Rational[expr_] :=	
     Block[
          { aa, condensedexpr, denomalias, denomaliaslist, denominator,
          denominatorlist, expandedexpr, i, j, length, listofalias,
          listofdenoms, niceexpr, partexpr, posit, position,
          replacedenomeqns, replacedenomrules, result, smallerpartexpr,
          strip, var, varlist },

(* initializing variables *)
          varlist = {};	
          denomaliaslist = {};
          listofdenoms = {};
          replacedenomrules = {};
          replacedenomeqns= {};
          var = {};
          posit = {};
          position = {};
          listofalias = {};

          niceexpr=NCCombine[expr];

(* get the positions of all the inverses in the expression *) 
          posit = Position[niceexpr,inv[_]]; 

(*	The following loop cleans up any empty list return by Position *)
          For[i=1,i<=Length[posit],i++,		
               If[posit[[i]]!={},
                    AppendTo[position,posit[[i]]]
               ]
          ];

          length = Length[position];

(* the for loops are used to obtain the expression in the inverses *)
          For[i=1,i<=length,i++,
               partexpr = niceexpr;
               For[j=1,j<=Length[position[[i]]],j++,	
                    smallerpartexpr = partexpr[[position[[i,j]]]];
                    partexpr = smallerpartexpr
               ];

(* this will actually get the expression in the inverse out *)
               onedenominator = partexpr //. inv[aa_] :> aa;  
               If[!MemberQ[listofdenoms,onedenominator],
                    SetNonCommutative[denomalias[i]];
                    AppendTo[listofalias,i];

(* this stores the expressions inside the inverses as a list for 
reverse substituting later *)
                    AppendTo[listofdenoms,onedenominator];  
                    AppendTo[replacedenomrules,onedenominator -> denomalias[i]];
                    AppendTo[replacedenomeqns,onedenominator==denomalias[i]]

(* express the variables inside inverses by the aliases *)
               ];
(* this list contains the variables inside the expression inside the 
inverses. It will be used by the command.  Solve to express these 
variables in terms of the denomalias *)

               varlist = Join[varlist,Variables[onedenominator]]
          ];

(* this eliminates terms that appear more than once in the list *)
          varlist = Union[varlist];

(*          niceexpr = NCStrongCollect[expr,Apply[inv,listofdenoms]];	*)

(* use solve to express the variables inside the inverses by the
variables just substituted in *)
          result = Solve[replacedenomeqns,varlist]; 

          condensedexpr = niceexpr //. replacedenomrules;
          If[Length[result]!=0,
(* express the variables in the expression by the result obtained from solve *)
               condensedexpr = condensedexpr //. result[[1]]	
          ];

          expandedexpr = ExpandNonCommutativeMultiply[condensedexpr];

(* we have obtained the simplest expression however aliases are 
still in denominator there may be some room here for simplifying the 
expression by some fancy commands *)

(* The next replaces aliases with the denominators *)
          expandedexpr = Simplify[expandedexpr];

(* reverse substituting	*)
          For[i=1,i<=Length[listofdenoms],i++, 
               denomalias[listofalias[[i]]] = listofdenoms[[i]]
          ];

(* we are finished except to beautify the expression *)
          Return[NCCombine[Simplify[expandedexpr]]]
     ];

End[ ]

EndPackage[ ]

