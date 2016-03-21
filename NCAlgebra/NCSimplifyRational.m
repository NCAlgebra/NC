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
              "NCSimplify1Rational`", 
              "NCSimplify2Rational`",
              "NonCommutativeMultiply`" ]
 

NCSimplifyRational::usage =
     "NCSimplifyRational[ 'expression' ] applies NCSimplify2Rational and 
     NCSimplify1Rational to an expression in order to simplify the
     expression.";

NCNormalizeInverse::usage = "";

Begin["`Private`"]

  Clear[ninv];
  NCNormalizeInverse[expr__] :=
    (((expr //. inv[x_] -> ninv[0, x]) 
            //. (ninv[a_, b__?CommutativeQ + c_] -> 
                       ninv[1, c/(a+Times[b])]/(a+Times[b])))
            //. ninv[a_, x_] -> inv[a + x])

  NCSimplifyRational[ expr__ ] :=
       Module[{r,s},
            r = ExpandNonCommutativeMultiply[
                   NCSimplify1Rational[
                        NCSimplify2Rational[
                             ExpandNonCommutativeMultiply[
                                  expr
                           ]
                      ]
                 ]
            ];
  (* If NCSimplify2Rational changes the new expression, then reapply
  simplification rules. i.e NCS1R, repeat. *)
          While[(s=NCSimplify2Rational[r])=!=r,
                 r = ExpandNonCommutativeMultiply[
                         NCSimplify1Rational[s] ];
            ]; 
            Return[r]           
       ]

End[ ]

EndPackage[ ]
