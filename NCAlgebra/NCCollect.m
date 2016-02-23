(* :Title: 	NCCollect.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NCCollect` *)

(* :Summary:	NCCollect.m is a collection of functions useful in
		reorganizing expressions with respect to inputted 
		variables.
*)

(* :Alias:	NCDec ::= NCDecompose, NCCom ::= NCCompose,
		decompose ::= NCDecompose, compose ::= NCCompose,
		(*NCComb ::= NCCombine, *) 
                NCC ::= NCCollect,
		NCSC ::= NCStrongCollect, NCCSym ::= NCCollectSymmetric,
*)

(* :Warnings: *)

(* :History: 
   :6/24/91	-  Added commenting and indenting. (mstankus)
   :6/25/91     -  Fixed error checking in NCCollect. 
		-  Commented out the Decomposition OK. (mstankus) 
   :9/3/91      -  Changed NCcollect to NCCollect in Context.
		-  Added new rule to rulesCollect. (dhurst)
   :9/28/91     -  Moved the 'negativerule' to NCStrongCollect. (dhurst)
   :3/24/92     -  Changed == to === in counter and NCStrong-Collect.
		   (dhurst)
   :8/30/92	-  Reformating.
		-  Replaced ToString[Head[...]]=="head" with Head[...]==head.
		-  Replaced Print[]'s with Message[].
		-  (dhurst)
   :11/18/92	-  Restructured negitiverule functioning.(mstankus)
   :7/08/93	-  Added parenthesis so kk:1* became (kk:1)* so that
                   the code will work on Mma2.2.(yoshinob)
   :12/8/93     -  Made it work well with respect to lists. 
   :9/4/02      -  Deleted comma on line 141.
*)

BeginPackage[ "NCCollect`",
              "NonCommutativeMultiply`" ];

NCDecompose::usage = 
     "NCDecompose[poly,a] or NCDecompose[poly,{a,b,c,....}] will \
     produce a list of elements of poly in which elements of the \
     same order of a (or the same order of {a,b,c, ...} ) are \
     collected together.  Alias:  NCDec.";
    
NCCompose::usage =
     "NCCompose[NCDecompose[poly,a]] will reproduce poly.  \
     NCCompose[NCDecompose[poly,{a,b}],{1,0}] will reconstruct the \
     elements of poly which are of order 1 in a and of order 0 in b. \
     Alias:  NCCom.";

NCStrongCollect::usage = 
     "NCStrongCollect[expr,varlist] collects terms of expression \
     expr according to the elements of varlist and attempts to \
     combine them using rulesCollect.  In the noncommutative case \
     the Taylor expansion and so the collect function is not \
     uniquely specified.  This collect function often collects too \
     much and while correct is stronger than you want.  For example, \
     x will factor out of terms where it appears both linearly and \
     quadratically thus mixing orders.  Alias:  NCSC.";        

NCCollect::usage = 
     "NCCollect[expr,varlist] collects terms of expression expr \
     according to the elements of varlist and attempts to combine\ 
     them using rulesCollect.  It is weaker than the above in that \
     first order and second orderterms are not collected togther. \
     It basically is NCDecompose-> NCStrongCollect-> NCCompose.  \
     Alias:  NCC.";

NCCollectSymmetric::usage = 
     "NCCollectSymmetric[expr, var] allows one to collect on the \
     variables and their transposes without writing out the \
     transposes.  Alias:  NCCSym.";  

TermApplyRules::usage =
     "...";

NCCollect::notsum =
     "Harmless warning: Expression is not a sum of terms.";

NCDecompose::notsum =
     "Harmless warning: Expression is not a sum of terms.";

NCDecompose::error =
     "MISTAKE.  DO NOT USE ANSWER.";

Begin["`Private`"];

Clear[firstone];
firstone[ poly_, b_] := 
     Block[{counts, data, piece, ic },
          counts = Map[ counter[#, b]&, poly ];
          data = {};
          Do[ piece=Select[poly, counter[#, b]==ic&];
               If[piece!={}, AppendTo[data, {{ic}, piece}]],
               {ic, 0, Max[counts]}
          ];
          Return[data];
     ];

Clear[nextone];
nextone[poly_, b_]:=
     Block[{len},
          len=Length[poly];
          data={};
          Do[ counts=Map[counter[#, b]&, poly[[il, 2]]];
               Do[ piece=Select[poly[[il, 2]], counter[#, b]==ic&];
                    If[piece!={}, 
                         AppendTo[data, {Append[poly[[il, 1]], ic], piece}]
                    ],
                    {ic, 0, Max[counts]}
               ],
               {il, 1, len}
          ];
          Return[data];
     ];

Clear[NCDecompose];
NCDecompose[expr_, l_]:=
     Block[{temp, i, variablelist, nvar},
(* ------------------------------------------------------------------ *)
(*  This code is repeated below and so the next condition will        *)
(*  always fail when NCDecompose is called from NCCollect.            *)
(* Bill change Feb 4 2003 -commenting out one error message           *)
(* ------------------------------------------------------------------ *)
          If[Head[expr] =!= Plus,
               Message[ NCDecompose::notsum ]
          ];
          temp=Apply[List, expr];
          variablelist = Flatten[ {l} ];
          nvar = Length[ variablelist ];
          temp =firstone[temp, variablelist[[1]]];
          Do[
               temp=nextone[temp, variablelist[[i]]],
               {i, 2, nvar}
          ];
          If[ExpandNonCommutativeMultiply[NCCompose[temp]-expr]=!=0,
               (* NCDecompose OK , bill June 2004 =!= *)
	     (*  Message[ NCDecompose::error ] ,*)
	       Message[ NCDecompose::error ]
          ];
          Return[temp]
     ];

Clear[NCCompose];
NCCompose[poly_]:=
     Apply[Plus, Flatten[Map[#[[2]]&, poly]]];

NCCompose[poly_, pos_]:=
     Apply[Plus, Select[poly, #[[1]]==pos&][[1, 2]]];

(*counter is used in NCDecompose via firstone and nextone *)

Clear[counter];
counter[expr_, b_]:=
     Block[{val, result1, ans, temp},
          val=Head[expr];
          ans=
               Which[
                    val===Head[b],
                         If[expr==b, 1, 0, 0],
                    val===Times,
                         (
                              temp=
                                   Select[
                                        Apply[List, expr], 
                                        Head[#]==NonCommutativeMultiply&
                                   ];
                              result1 = 
                              If[temp!={},
                                   Count[temp[[1]], b],
                                   Count[expr, b],
                                   Count[expr, b]
                              ]; 
                              result1
                         ),
                    val===NonCommutativeMultiply,
                         Count[expr, b],
                    True,
                         0
               ];
          Return[ ans]
     ];


SetNonCommutative[a, e, f, aa, bb, cc, dd, ee, ff];
(* Nov 2015 Mauricio : CommutativeQ pattern issue BEGIN *)
  (* CommutativeQ[ll]=True; *)
SetCommutativeQ[ll];
(* Nov 2015 Mauricio : CommutativeQ pattern issue END *)
rulesCollect = 
     {
          (ll_:1)*ee___**bb+(kk_:1)*ee___**bb**dd___ :> 
               NonCommutativeMultiply[ee] ** bb **
               ( 
                    Times[ll, Id] + 
                    Times[kk, NonCommutativeMultiply[dd]] 
               ),

          (ll_:1)*ee___**bb**aa___+(kk_:1)*ee___**bb :> 
               NonCommutativeMultiply[ee] ** bb **
               ( 
                    Times[ll, NonCommutativeMultiply[aa]] + 
                    Times[kk, Id] 
               ),

          (ll_:1)*aa___**bb**dd___+(kk_:1)*bb**dd___ :> 
               Plus[ 
                    Times[ll, NonCommutativeMultiply[aa]], 
                    Times[kk, Id] 
               ] ** 
	       bb ** NonCommutativeMultiply[dd],

          (ll_:1)*bb**dd___+(kk_:1)*ee___**bb**dd___ :> 
               Plus[ 
                    Times[ll, Id], 
                    Times[kk, NonCommutativeMultiply[ee]] 
               ] ** 
	       bb ** NonCommutativeMultiply[dd],

          (ll_:1)*ee___**bb**aa___+(kk_:1)*ee___**bb**dd___ :> 
               NonCommutativeMultiply[ee] ** bb **
	       ( 
                    Times[ll, NonCommutativeMultiply[aa] ] + 
                    Times[kk, NonCommutativeMultiply[dd]] 
               ),

          (ll_:1)*aa___**bb**dd___+(kk_:1)*ee___**bb**dd___ :> 
               Plus[ 
                    Times[ll, NonCommutativeMultiply[aa] ],
                    Times[kk, NonCommutativeMultiply[ee]]
               ] ** 
	       bb ** NonCommutativeMultiply[dd],

          (ll_:1)*bb+(kk_:1)*bb**dd___ :> 
               bb **
	       (
                    Times[ll, NonCommutativeMultiply[Id]] +
                    Times[kk, NonCommutativeMultiply[dd]]
               ),

          (ll_:1)*bb+(kk_:1)*ee___**bb :> 
               Plus[
                    Times[ll] ** Id,
                    Times[kk, NonCommutativeMultiply[ee]]
               ] ** bb
     };

NCStrongCollect[exp_, var_] :=
(*
Block[{temp, varlist, aa, bb, cc, dd, ee, ff, w, kk, ll},
SetNonCommutative[aa, bb, cc, dd, ee, ff];
CommutativeQ[ll]=True;
*)
     Block[{a, tempvar, temp, temprule}, 
          temp=exp;
          If[Head[var]==List,
               varlist=var,
               varlist={var},
               varlist={var}
          ];
          SetNonCommutative[ a, e, f, tempvar];
          negativerule = {
              (e___) ** (a_Plus?NegativeRuleCondition) ** (f___) :> 
                -(e ** (Expand[-a])) ** f
                         };
          For[jjj=1, jjj<=Length[varlist], jjj++,
               temprules = rulesCollect//.bb->varlist[[jjj]];
               temp = temp //. temprules;
          ];
          temp =  temp/.negativerule;
          Return[temp]
     ];

NegativeRuleCondition[a_] := 
Block[{negativerulecondition},
     negativerulecondition = Which[
(*   a = (-Integer+...) then return -(Integer-...)   *)
            Head[a[[1]]] === Integer && Negative[a[[1]]], 
                                   tempvar = Expand[-a]; True, 
(*   a = (-Real+...) then return -(Real-...)   *)
            Head[a[[1]]] === Real && Negative[a[[1]]], 
                                   tempvar = Expand[-a]; True,
(*   a = (Symbol+...) then return False    *)
            Depth[a[[1]]] < 2,    False, 
(*   a = (-Symbol+...) then return -(Symbol-...)   *)
            Head[a[[1]]] === Times && Negative[a[[1,1]]], 
				   tempvar = Expand[-a]; True, 
(*  otherwise return False  *) 
				   True, False
     ];
     Return[negativerulecondition]
];

TermApplyRules[DEC_, varlist_]:=
     Block[{temp},
          temp=DEC;
(* 
Print["TermApplyRules has to loop ",Length[DEC]," times. Please be patient."];
*)
          Do[ temp[[i, 2]]=
               {
                    NCStrongCollect[
                         Apply[Plus, temp[[i, 2]]],
                         varlist
                    ]
               },
(* 
Print["Finished iteration number ",i];
*)
               {i, 1, Length[DEC]}
          ];
          Return[temp]
     ];
NCCollect[aList_List,varlist_] := Map[NCCollect[#,varlist]&,aList];

NCCollect[expr_, varlist_]:=
     Block[{temp, dec, aprules},
(* ------------------------------------------------------------------ *)
(*      If the user specified just one variable, then it into a list  *)
(* ------------------------------------------------------------------ *)
          If[Head[varlist] =!= List,
               temp={varlist},
               temp=varlist
          ];
(* ------------------------------------------------------------------ *)
(*      Forgive the user if he calls NCCollect on something that      *)
(*      obviously can not be collected on.                            *)
(* ------------------------------------------------------------------ *)
          If[Head[expr] =!= Plus,
               Message[ NCCollect::notsum ]; 
               result = expr,
               dec=NCDecompose[expr, temp]; 
               aprules=TermApplyRules[dec, temp];
               result = NCCompose[aprules]
          ];
          Return[result]
     ];
 
(* ------------------------------------------------------------------ *)
(*    Purpose:   Allows one to collect on the variables and           *)
(*       their transposes without writing out the transposes          *)
(*                                                                    *)
(*    Alias:  NCCSym                                                  *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)

NCCollectSymmetric[expr_, vars_]:=
     Block[{vars1, tpvars, allvars}, 
          vars1=Flatten[{vars}];
          tpvars=Map[tp, vars1];
          allvars=Flatten[{vars, tpvars}];
          temp1=NCCollect[expr, allvars];
          Return[temp1]
     ];

End[]

EndPackage[]


