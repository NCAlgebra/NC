(* ------------------------------------------------------------------ *)
(* NCSimplifyRational                                                 *)
(* ------------------------------------------------------------------ *)
(* 9/20/91                                                            *)
(* ------------------------------------------------------------------ *)
(*                         Prolog                                     *)
(*                                                                    *)
(*    Purpose:  Simplify expressions involving inv[]'s.               *)
(*                                                                    *)
(*    Alias:  NCSR                                                    *)
(*                                                                    *)
(*    Description:  NCSimplifyRational[ 'expression' ]                *)
(*                  applies NCSimplify2Rational and                   *)
(*                  NCSimplify1Rational to an expression in order     *)
(*                  to simplify the expression.                       *)
(*                                                                    *)
(*    Arguments:  algebraic expressions                               *)
(*                                                                    *)
(*    Comments/Limitations:                                           *)
(*                                                                    *)
(*    -  Can not do equations.                                        *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)
(*                      Change Log                                    *)
(*   Date               ----------                          WHO       *)
(*   ----                                                   ---       *)
(*   9/12	            Packaged.                       dhurst    *)
(*   7/24/2003                                              Shopple   *)
(*       Put a loop in NCSR so that after applying NCS2R              *)
(*     and NCS1R it checks to see if applying NCS2R changes anything. *)
(*     If it does, it tries NCS1R again, and repeats until there are  *)
(*     no more changes. (This may be overkill. Can NCS2R still change *)
(*     anything after NCS2R and NCS1R have been called?)              *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)

BeginPackage[ "NCSimplifyRational`",
              "NCSubstitute`",
              "NonCommutativeMultiply`" ];

Clear[NCNormalizeInverse, 
      NCSimplifyRational, 
      NCSimplifyRationalSinglePass];

Get["NCSimplifyRational.usage"];

Begin["`Private`"]

  Clear[ninv];
  NCNormalizeInverse[expr__] :=
    (((expr //. inv[x_] -> ninv[0, x]) 
            //. (ninv[a_, b__?CommutativeQ + c_] -> 
                       ninv[1, c/(a+Times[b])]/(a+Times[b])))
            //. ninv[a_, x_] -> inv[a + x])

  (* NCSimplifyRational *)
  NCSimplifyRationalSinglePass[exp_] := Module[
      {K, a, b, c, d, e, k, expr = exp, rule},

      SetCommutative[K];
      SetNonCommutative[a,b,c,d,e];

      (*---------------------------RULE 1---------------------------*) 
      (* rule 1 is as follows:                                      *) 
      (*    inv[a] inv[1 + K a b] -> inv[a] - K b inv[1 + K a b]    *) 
      (*    inv[a] inv[1 + K a] -> inv[a] - K inv[1 + K a]          *)
      (*------------------------------------------------------------*)
      rule[1] := {
          d___ ** inv[a__] ** inv[1 + K_. a__ ** b__] ** e___ :> 
              d ** inv[a] ** e - K d ** b ** inv[1 + K a ** b] ** e,
          d___ ** inv[a_] ** inv[1 + K_. a_] ** e___ :> 
              d ** inv[a] ** e - K d ** inv[1 + K a] ** e
      };

      (*-----------------------RULE 2-------------------------------*) 
      (* rule 2 is as follows:                                      *) 
      (*    inv[1 + K a b] inv[b] -> inv[b] - K inv[1 + K a b] a    *) 
      (*    inv[1 + K a] inv[a] -> inv[a] - K inv[1 + K a ]         *) 
      (*------------------------------------------------------------*)
      rule[2] := {
          d___ ** inv[1 + K_. a__ ** b__] ** inv[b__] ** e___ :> 
              d ** inv[b] ** e - K d ** inv[1 + K a ** b] ** a ** e,
          d___ ** inv[1 + K_. a_] ** inv[a_] ** e___ :> 
              d ** inv[a] ** e - K d ** inv[1 + K a] ** e
      };

      (*---------------------------RULE 3'------------------------*) 
      (* inv[1 + c + K a b] a b                                   *)
      (*         -> [1 - inv[1 + c + K a b] (1 + c)]/K            *)
      (* inv[1 + c + K a] a -> [1 - inv[1 + c + K a] (1 + c)]/K   *)
      (*----------------------------------------------------------*)
      rule[3] := {
          d___ ** inv[c_ + K_. a__ ** b__] ** a__ ** b__ ** e___ :> 
              (1/K) d ** e - (1/K) d ** inv[c + K a ** b] ** c ** e,
          d___ ** inv[c_ + K_. a_] ** a_ ** e___ :> 
              (1/K) d ** e - (1/K) d ** inv[c + K a] ** c ** e
      };

      (*---------------------------RULE 4'------------------------*) 
      (* a b inv[1 + c + K a b]                                   *)
      (*         -> [1 - (1 + c) inv[1 + c + K a b]]/K            *)
      (* a inv[1 + c + K a] -> [1 -  (1 + c) inv[1 + c + K a]]/K  *)
      (*----------------------------------------------------------*)
      rule[4] := {
          d___ ** a__ ** b__ ** inv[c_ + K_. a__ ** b__] ** e___ :> 
              (1/K) d ** e - (1/K) d ** c ** inv[c + K a ** b] ** e,
          d___ ** a_ ** inv[c_ + K_. a_] ** e___ :> 
              (1/K) d ** e - (1/K) d ** c ** inv[1 + K a] ** e
      };

      (*---------------------------------RULE 5---------------------*) 
      (* rule 5 is as follows:                                      *) 
      (*     inv[1 + K a b] inv[a] -> inv[a] inv[1 + K b a]         *)
      (*     inv[1 + K a] inv[a] -> inv[a] inv[1 + K a]             *)
      (*------------------------------------------------------------*)
      rule[5] := {
          d___ ** inv[1 + K_. a__ ** b__] ** inv[a__] ** e___ :> 
              d ** inv[a] ** inv[1 + K b ** a] ** e,
          d___ ** inv[1 + K_. a_] ** inv[a_] ** e___ :> 
              d ** inv[a] ** inv[1 + K a] ** e
      };

      (*---------------------------------RULE 6---------------------*) 
      (* rule 6 is as follows:                                      *)
      (*      inv[1 + K a b] a  =  a inv[1 + K b a]                 *) 
      (*------------------------------------------------------------*)
      (* ?? WHY NOT SECOND RULE ?? *)
      rule[6] := {
          d___ ** inv[1 + K_. a__ ** b__] ** a__ ** e___ :> 
              d ** a ** inv[1 + K b ** a] ** e,
          d___ ** inv[1 + K_. a_] ** a_ ** e___ :> 
              d ** a ** inv[1 + K a] ** e
      };

      (* Normalize inverses *)
      expr = NCNormalizeInverse[expr];
      
      For [k = 1, k <= 6, k++,
        expr = NCReplaceRepeated[expr, rule[k]];
      ];

      Return[expr];
  ];

  NCSimplifyRational[expr_] := 
    FixedPoint[
      ExpandAll[
        ExpandNonCommutativeMultiply[
          NCSimplifyRationalSinglePass[#]]]&, expr];
        
End[];

EndPackage[];
