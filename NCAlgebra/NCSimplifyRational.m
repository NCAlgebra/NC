(* :Title: 	NCSimplifyRational *)

(* :Author: 	mauricio. *)

(* :Context: 	NCSimplifyRational` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage[ "NCSimplifyRational`",
              "NCReplace`",
              "NCCollect`",
              "NCPolynomial`",
              "NCUtil`",
              "NonCommutativeMultiply`" ];

Clear[NCNormalizeInverse, 
      NCPreSimplifyRationalSinglePass,
      NCPreSimplifyRational,
      NCSimplifyRationalSinglePass,
      NCSimplifyRational,
      NCSR];

Get["NCSimplifyRational.usage"];

Begin["`Private`"]

  Clear[ninv];
  NCNormalizeInverse[expr__] :=
    (((expr //. inv[x_] -> ninv[0, x]) 
            //. (ninv[a_, b__?CommutativeQ + c_] -> 
                       ninv[1, c/(a+Times[b])]/(a+Times[b])))
            //. ninv[a_, x_] -> inv[a + x])

  Clear[NCSimplifyRationalRules];
  Clear[a,b,A,B];
  SetCommutative[A,B];
  SetNonCommutative[a,b];

  Clear[NCSimplifyRationalOriginalRules];
  NCSimplifyRationalOriginalRules =
  {
      
      (*---------------------------RULE 1---------------------------*) 
      (* rule 1 is as follows:                                      *) 
      (*    inv[a] inv[1 + A a b] -> inv[a] - A b inv[1 + A a b]    *) 
      (*    inv[a] inv[1 + A a] -> inv[a] - A inv[1 + A a]          *)
      (*------------------------------------------------------------*)
      inv[a_]**inv[1 + A_. a_**b_] :> inv[a] - A b**inv[1 + A a**b],
      inv[a_]**inv[1 + A_. a_] :> inv[a] - A inv[1 + A a],

      (*-----------------------RULE 2-------------------------------*) 
      (* rule 2 is as follows:                                      *) 
      (*    inv[1 + A a b] inv[b] -> inv[b] - A inv[1 + A a b] a    *) 
      (*                   -> inv[b] - A a inv[1 + A a b] (rule #6) *) 
      (*    inv[1 + A a] inv[a] -> inv[a] - A inv[1 + A a ]         *) 
      (*------------------------------------------------------------*)
      inv[1 + A_. a_**b_]**inv[b_] :> inv[b] - A a**inv[1 + A a**b],
      inv[1 + A_. a_]**inv[a_] :> inv[a] - A inv[1 + A a],
      
      (*-----------------------RULE 3-------------------------------*) 
      (* rule 3 is as follows:                                      *)
      (*    inv[1 + A a b ] a b -> (1 - inv[1 + A a b])/A           *)
      (*    inv[1 + A a] a -> (1 - inv[1 + A a])/A                  *) 
      (*------------------------------------------------------------*)
      inv[1 + A_. a_**b_]**a_**b_ :> (1/A) - (1/A) inv[1 + A a**b],
      inv[1 + A_. a_]**a_ :> (1/A) - (1/A) inv[1 + A a],
      
      (*-----------------------RULE 4-------------------------------*) 
      (* rule 4 is as follows:                                      *)
      (*    a b inv[1 + A a b ] -> (1 - inv[1 + A a b])/A           *)
      (*    a inv[1 + A a] -> (1 - inv[1 + A a])/A                  *) 
      (*------------------------------------------------------------*)
      a_**b_**inv[1 + A_. a_**b_] :> (1/A) - (1/A) inv[1 + A a**b],
      a_**inv[1 + A_. a_] :> (1/A) - (1/A) inv[1 + A a],

      (*----------------------RULE 5-------------------------------*) 
      (* rule 5 is as follows:                                     *) 
      (*    inv[1 + A a b] inv[a] -> inv[a] inv[1 + A a b]         *)
      (*    inv[1 + A a] inv[a] -> inv[a] inv[1 + A a]             *)
      (*-----------------------------------------------------------*)
      (* RULE 5 IS WRONG! RULE 2 OVERCOMES IT!                     *)
      (*-----------------------------------------------------------*)
      
      (*---------------------------------RULE 6---------------------*) 
      (* rule 6 is as follows:                                      *)
      (*      inv[1 + A a b] a  =  a inv[1 + A b a]                 *) 
      (*------------------------------------------------------------*)
      inv[1 + A_. a_**b_]**a_ :> a**inv[1 + A b**a]
      
  };
  
  Clear[NCSimplifyRationalABRules];
  NCSimplifyRationalABRules =
  {
      
      (*---------------------------RULE 1---------------------------*) 
      (* rule 1 is as follows:                                      *) 
      (*    inv[a] inv[1 + A a b] -> inv[a] - A b inv[1 + A a b]    *) 
      (*    inv[a] inv[1 + A a] -> inv[a] - A inv[1 + A a]          *)
      (*------------------------------------------------------------*)
      inv[a_]**inv[1 + A_. a_**b_] :> inv[a] - A b**inv[1 + A a**b],
      inv[a_]**inv[1 + A_. a_] :> inv[a] - A inv[1 + A a],

      (*-----------------------RULE 2-------------------------------*) 
      (* rule 2 is as follows:                                      *) 
      (*    inv[1 + A a b] inv[b] -> inv[b] - A inv[1 + A a b] a    *) 
      (*                   -> inv[b] - A a inv[1 + A a b] (rule #6) *) 
      (*    inv[1 + A a] inv[a] -> inv[a] - A inv[1 + A a ]         *) 
      (*------------------------------------------------------------*)
      inv[1 + A_. a_**b_]**inv[b_] :> inv[b] - A a**inv[1 + A a**b],
      inv[1 + A_. a_]**inv[a_] :> inv[a] - A inv[1 + A a],
      
      (*---------------------------------RULE 6---------------------*) 
      (* rule 6 is as follows:                                      *)
      (*      inv[1 + A a b] a  =  a inv[1 + A b a]                 *) 
      (*------------------------------------------------------------*)
      inv[1 + A_. a_**b_]**a_ :> a**inv[1 + A b**a],
      
      (*---------------------------------RULE 7---------------------*) 
      (* rule 6 is as follows:                                      *)
      (*   inv[A inv[a] + B b] inv[a]  =  (1/A) inv[1 + (B/A) a b]  *) 
      (*   inv[a] inv[A inv[a] + A b]  =  (1/A) inv[1 + (B/A) b a]  *) 
      (*------------------------------------------------------------*)
      inv[A_. inv[a_] + B_. b_]**inv[a_] :> (1/A)inv[1 + (B/A) a ** b],
      inv[a_]**inv[A_. inv[a_] + B_. b_] :> (1/A)inv[1 + (B/A) b ** a]
      
  };

  Clear[NCPreSimplifyRationalSinglePass];
  NCPreSimplifyRationalSinglePass[expr_] := 
    ExpandAll[ExpandNonCommutativeMultiply[
              NCReplaceRepeated[NCNormalizeInverse[expr], 
                                NCSimplifyRationalOriginalRules]]];

    
  Clear[NCPreSimplifyRational];
  NCPreSimplifyRational[expr_] := 
    FixedPoint[NCPreSimplifyRationalSinglePass, expr];
  
  Clear[NCSimplifyRationalAuxRules];
  NCSimplifyRationalAuxRules[terms_, rat_] := Module[
    {last = Last[terms], rest = (Plus @@ Most[terms]), factor},
      
    (* WATCH OUT FOR POSSIBLE BUG:
       pattern (_NonCommutativeMultiply|_Symbol|_Subscript)
       should be (_NonCommutativeMultiply|_?NCSymbolOrSubscriptQ) ?
    *)
  
    (* Normalize last *)
    factor = Replace[last, 
                {A_?CommutativeQ (_NonCommutativeMultiply|_Symbol|_Subscript) -> A, 
                 (_NonCommutativeMultiply|_Symbol|_Subscript) -> 1 }];
      
    last /= factor;
    rest /= factor;

    (*
    Print["terms = ", terms];
    Print["factor = ", factor];
    Print["last = ", last];
    Print["rest = ", rest];
    *)
      
    Return[{ rat ** last -> ExpandNonCommutativeMultiply[1/factor - rat ** rest],
             last ** rat -> ExpandNonCommutativeMultiply[1/factor - rest ** rat] }];
      
  ];

  NCSimplifyRationalSinglePass[expr_List] := 
     Map[NCSimplifyRationalSinglePass, expr];
  
  NCSimplifyRationalSinglePass[expr_] := Module[
    {poly, rvars, rules, simpRules, tmp},

    (* Pre-simplify *)
    tmp = NCPreSimplifyRationalSinglePass[expr];
      
    (* Convert from rational to polynomial *)
    {poly,rvars,rules} = NCRationalToNCPolynomial[tmp];

    (* 
    Print["expr = ", expr];
    Print["poly = ", poly];
    Print["rvars = ", rvars];
    Print["rules = ", rules];
    Print["P0 = ", Map[FullForm[#[[2,1]]]&, rules]];
    Print["P1 = ", Map[NCToNCPolynomial[#[[2,1]]]&, rules]];
    *)

    (* Not rational? return *)
    If [rvars === {},
        Return[tmp];
    ];
      
    (* Create Rules *)
    simpRules = Reverse[
        Map[NCSimplifyRationalAuxRules[
                NCPSort[NCToNCPolynomial[#[[2,1]]]], 
                #[[1]]]&, 
            rules]];

    (* Print["simpRules = ", simpRules]; *)

    tmp = NCPolynomialToNC[poly];

    (* Print["tmp0 = ", tmp]; *)

    (* Apply rational rules *)
      
    Scan[(tmp = ExpandAll[ExpandNonCommutativeMultiply[
                            NCReplaceAll[tmp, #]]])&, simpRules];
      
    (* Print["tmp1 = ", tmp]; *)

    (* Bring back rational terms *)

    tmp = tmp //. rules;

    (* Print["tmp2 = ", tmp]; *)

    (* Apply AB rules *)
      
    tmp = NCReplaceRepeated[
        ExpandAll[ExpandNonCommutativeMultiply[
              NCReplaceRepeated[tmp, NCSimplifyRationalABRules]]],
        a_. + A_. b_?NonCommutativeQ + B_ b_?NonCommutativeQ -> a+(A+B)b
    ];

    (* Print["tmp = ", tmp]; *)
      
    Return[tmp];
      
  ];

  NCSimplifyRational[expr_] := 
     FixedPoint[NCSimplifyRationalSinglePass, expr];

  (* Alias *)
  NCSR = NCSimplifyRational;
     
End[];

EndPackage[];
