(* ------------------------------------------------------------------ *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)

(* :History: 
   :9/11/07      Replaced the local variable K with LLLLL.  (mauricio)
                 This is a kludge not a fix!
*)

(* ------------------------------------------------------------------ *)
(* NCSimplify2Rational                                                *)
(* ------------------------------------------------------------------ *)

BeginPackage[ "NCSimplify2Rational`", 
"NCTools`", "NonCommutativeMultiply`", "NCSubstitute`" ]

(* ------------------------------------------------------------------ *)
(* Options                                                            *)
(* ------------------------------------------------------------------ *)

Options[ NCSimplify2Rational ] := { NCS2Rdebug->False };
Options[ NCInvExtractor ] := { NCIEdebug->False };
Options[ MakeSimplifyingRule ] := { MSRdebug->False };

(* ------------------------------------------------------------------ *)
(* usage statements                                                   *)
(* ------------------------------------------------------------------ *)

NCInvExtractor::usage =
     "NCInvExtractor[ expression ] returns a list of all the arguments\
     of inv[]'s in the expression.  Alias: NCIE.";

MakeSimplifyingRule::usage =
     "MakeSimplifyingRule[ poly ] returns the list of rules that  \n
     NCS2R uses, based on inv[ poly ].  Alias: MSR.";

NCSimplify2Rational::usage =
     "NCSimplify2Rational[ expression, options ] applies a set of \n
     internal rules to simplify NC-expresssions.  Alias: NCS2R.";

Begin["`Private`"]

(* ------------------------------------------------------------------ *)
(* NCSimplify2Rational                                                *)
(* ------------------------------------------------------------------ *)

NCSimplify2Rational[ input_Symbol ] :=
     Return[input];

NCSimplify2Rational[ input_Times ] :=
     Return[input] /; LeafCount[input]===3;

NCSimplify2Rational[ input_, opts___ ] :=
     Block[ 
          { tmp1a, dummyhead, input1, input2, flag, outputlist, tmp2, 
    	  tmp3, tmp4, newexpression, NCS2Rdebug },
          outputlist = {};
          flag=True;
          input1 = input;

(* input2, because input1 won't survive the 'While' loop. *)

          input2 = input;
          NCS2Rdebug = NCS2Rdebug/.{opts}/.Options[ NCSimplify2Rational ];
	  While[ flag,
	       tmp1a = NCInvExtractor[ input1 ];
	       AppendTo[ outputlist, tmp1a ];
               If[ tmp1a=={}, flag=False, flag=True];
	       input1 = tmp1a; 
          ];
          tmp2 = Union[ Flatten[ outputlist] ];
          tmp3 = Map[ MakeSimplifyingRule, tmp2 ];
          tmp4 = Union[ Flatten[ tmp3 ] ];
          newexpression = Substitute[ input2,tmp4];
          Return[ Expand[newexpression]]
     ];

(* ------------------------------------------------------------------ *)
(* MakeSimplifyingRule                                                *)
(* ------------------------------------------------------------------ *)

MakeSimplifyingRule[ d__, opts___ ]:=
     Block[ 
          {
          e, LLLLLL, X1, tmp1b, removemultiplier, headmono, MSRdebug,
          headmonoparta, headmonopartb, separator 
          },
(* Nov 2015 Mauricio : CommutativeQ pattern issue BEGIN *)
          (* CommutativeQ[LLLLLL] = True; *)
          SetCommutative[LLLLLL];
(* Nov 2015 Mauricio : CommutativeQ pattern issue END *)
          SetNonCommutative[ e, headmono ];
          e = d;

(* eliminate single terms *)

          If[ Length[ ExpandNonCommutativeMultiply[e] ] == 0 ||
               Length[ ExpandNonCommutativeMultiply[e] ] == 1,
               Return[{}]
          ];
	  MSRdebug = MSRdebug/.Options[ MakeSimplifyingRule ];
          headmono = NCHighestDegree[ ExpandNonCommutativeMultiply[e] ];
          separator[LLLLLL_.*X1_] := {LLLLLL,X1};
          tmp1b = separator[ headmono ];
          headmonoparta = tmp1b[[1]];
          headmonopartb = tmp1b[[2]];
	  If[ MSRdebug,  
 	       Print["..................................."];
	       Print["MSR   : headmono : ", headmono];
	       Print["MSR   : headmonoparta : ", headmonoparta];
	       Print["MSR   : headmonopartb : ", headmonopartb]
	  ];
          { 
          LLLLLL_.*inv[e]**headmonopartb -> 
               LLLLLL/headmonoparta - LLLLLL*inv[e]**(e-headmono)/headmonoparta,
          LLLLLL_.*headmonopartb**inv[e]  -> 
               LLLLLL/headmonoparta - LLLLLL*(e-headmono)**inv[e]/headmonoparta,
          inv[e]**headmonopartb -> 
               1/headmonoparta - 1*inv[e]**(e-headmono)/headmonoparta,
          headmonopartb**inv[e]  -> 
               1/headmonoparta - 1*(e-headmono)**inv[e]/headmonoparta
          }
     ];

(* ------------------------------------------------------------------ *)
(* NCInvExtractor                                                     *)
(* ------------------------------------------------------------------ *)

NCInvExtractor[ expres_Symbol ]:=
     Return[{}];

NCInvExtractor[ expres_Equal ]:=
     NCInvExtractor[ expres[[1]]-expres[[2]] ];

NCInvExtractor[ expres_, opts___ ]:=
     Block[ 
          {
          n, tmp1c, tmp2, item, out, j, invaddresses, invpositions, 
	  FoundInvList, NCIEdebug, exprlist, expr1, tmp3
          },
          NCIEdebug = NCIEdebug/.{opts}/.Options[ NCInvExtractor ];
          expr1 = ExpandNonCommutativeMultiply[ Expand[ expres ] ];

(* get a list of the terms of the expres *)

          expr1list = 
          If[ 
               Head[ expr1 ] === Plus,
               Apply[ 
                    List, 
                    ExpandNonCommutativeMultiply[ Expand[ expres ] ]
               ],
               {expr1}
          ];

(* eliminate all terms without inv[]`s *)

          FoundInvList := Select[ expr1list, (!FreeQ[ #, inv ])& ];

(* using inv instead of inv[_] is ok here, because FoundInvList is a 
list and not an expression *)

          invpositions = Position[ FoundInvList, inv];
          invaddresses = Map[ Length, invpositions ];

(* this creates invpositions which points to the arguments of each inv *)

          For[j=1,j<=Length[invpositions],j++,
               invpositions[[ j,invaddresses[[j]] ]] = 
                    1 + invpositions[[ j,invaddresses[[j]] ]] ;
          ];
          out={};

(* this create out which is a list of the arguments within each inv at
all levels of the original expression *)

          For[n=1,n<Length[invpositions]+1,n++,

(* takes an invposition like {2,1} and makes it 'dummyhead[ 2, 1 ]' *)

               tmp1c = Apply[dummyhead,invpositions[[n]]];

(* takes dummyhead[ 2, 1] and makes it 'dummyhead[ FoundInvList, 2, 1] *)

               tmp2 = Prepend[ tmp1c, FoundInvList ];

(* makes FoundInvList[[ 2,1 ]] *)

               item = Apply[Part, tmp2 ];

(* builds up the 'out' list , item by item *)

               AppendTo[out,item];
          ];
 	  If[ NCIEdebug, 
	       Print[ "+++++++++++++++++++++++++++++++++++++++"];
	       Print["NCIE : debug1 : finished another InvExtraction",out ]
	  ];
          Return[out]
     ];

End[ ]

EndPackage[ ]
