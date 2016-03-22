(* :Title: 	NCAlias.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	David Hurst (dhurst). *)

(* :Context: 	$Pre` *)

(* :Summary: 	NCAlias[] is the value of $Pre which serves as aliasses
		on the Mathematica command line.
*)

(* :Warnings:   Use aliases only at the Mathematica prompt, not in files. *) 

(* :History: 
   :5/6/92	Created. (dhurst)
   :8/21/92  	Added usage statement, reformatted file. (dhurst)
   :5/2/95      Added Contexts.
   :8/1/99    Added LDU alias (Camino)
   :8/9/99    Changed strong collect to be in context Collect` (dell)
*)

NCAlias ::usage = 
     "NCAlias[] is the value of $Pre (alias) for NCAlgebra."

NCAliasRule = {
    
               (* :NCMultiplication.m  *)
                    NonCommutativeMultiply`NCExpand -> NonCommutativeMultiply`ExpandNonCommutativeMultiply,
                    NonCommutativeMultiply`NCE -> NonCommutativeMultiply`ExpandNonCommutativeMultiply,

               (*
                    CE -> NonCommutativeMultiply`CommuteEverything,
                    CQ -> NonCommutativeMultiply`CommutativeQ,
                    TTNCM -> NonCommutativeMultiply`TimesToNCM,
                    ENCM -> NonCommutativeMultiply`ExpandNonCommutativeMultiply,
               *)
    
               (* :NCCollect.m *)
                    NCDec -> NCCollect`NCDecompose,
                    NCCom -> NCCollect`NCCompose,
                    NCC -> NCCollect`NCCollect,
                    NCSC -> NCCollect`NCStrongCollect,
                    NCCSym -> NCCollect`NCCollectSymmetric,
                        
               (* :NCDiff.m *)
                    DirD -> NCDiff`DirectionalD,
                    NCGradPoly -> NCDiff`NCGrad,
               (*
                    DirDP -> NCDiff`DirectionalDPolynomial,
                    Cri -> NCDiff`CriticalPoint,
                    Crit -> NCDiff`CriticalPoint,
               *)
                    
               (* :NCDoTeX.m: *)
                    ExprToTeXFile -> TeXStuff`ExpressionToTeXFile,

               (* :NCInverse.m *)
               (*
                    NCForward -> NonCommutativeMultiply`NCInverseForward,
                    NCBackward -> NonCommutativeMultiply`NCInverseBackward,
                    NCF -> NonCommutativeMultiply`NCInverseForward,
                    NCB -> NonCommutativeMultiply`NCInverseBackward,
                    NCEI -> NonCommutativeMultiply`NCExpandInverse,
                    NCETP -> NonCommutativeMultiply`NCExpandTranspose,
               *)

               (* :NCMatMult.m *)
                    MM -> NCMatMult`MatMult,
                    tpM -> NCMatMult`tpMat,
               (*
                    NCMTMM -> NCMatMult`NCMToMatMult,
                    GauE -> NCMatMult`GaussElimination,
		    LDU -> NCMatMult`NCLDUDecomposition,
               *)
                    
               (* :NC1SetCommands.m *)
                    SNC -> NonCommutativeMultiply`SetNonCommutative,
                    NCM -> System`NonCommutativeMultiply,
                    SetNC -> NonCommutativeMultiply`SetNonCommutative,
                        
               (* :NC( 012)SimplifyRational.m *)
                    NCSR -> NCSimplifyRational`NCSimplifyRational,
                    NCS1R -> NCSimplify1Rational`NCSimplify1Rational,
                    NCS2R -> NCSimplify2Rational`NCSimplify2Rational,
                    NCIE -> NCSimplify2Rational`NCInvExtractor,
                    MSR -> NCSimplify2Rational`MakeSimplifyingRule,

               (* :NCSolve.m *)
                    NCSolve -> NCSolveLinear1`NCSolveLinear1,

               (* :NCSubstitute.m *)
                    Sub -> NCSubstitute`Substitute,
                    SubR -> NCSubstitute`SubstituteReverse,
                    SubRev -> NCSubstitute`SubstituteReverse,
                    SubSym -> NCSubstitute`SubstituteSymmetric,
                    SubRSym -> NCSubstitute`SubstituteReverseSymmetric,
                    SubRevSym -> NCSubstitute`SubstituteReverseSymmetric,
                    SubSingleRep -> NCSubstitute`SubstituteSingleReplace,
                    SubAll -> NCSubstitute`SubstituteAll,
                    SaveR -> NCSubstitute`SaveRules,
                    SaveRQ -> NCSubstitute`SaveRulesQ,
                    FORules -> NCSubstitute`FunctionOnRules,

               (* :NCTools.m: *)
                    NCHDP -> NCTools`NCHighestDegreePosition,
                    NCHD -> NCTools`NCHighestDegree,
                    LPR -> NCTools`LeftPatternRule,
                         
               (* :SYSHinf1.m: *)
                    LinDGKF -> LinearDGKF
          };

NCAlias[expr_] := Identity[expr/.NCAliasRule];

(* 05/14/2012 MAURICIO - BEGIN *)
(*
  $Pre = NCAlias;
  Map[(#[[1]][x___] := #[[2]][x];)&,NCAliasRule];
*)

(* Define Aliases *)
Set @@@ NCAliasRule;

(* 05/14/2012 MAURICIO - END *)
