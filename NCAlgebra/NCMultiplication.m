(* :Title: 	NCMultiplication // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
   :8/30/99:    ForceCommutativeAllQ set true. (mark - per - dell)
   :9/21/92:    Added two lines of code which used to be in 
                NCUsage.m (mstankus)
   :3/3/16:     Deprecated CommutativeAllQ
*)

BeginPackage[ "NonCommutativeMultiply`" ]

Clear[CommutativeQ];

CommutativeQ::usage = "\
CommutativeQ[x] is True if x is commutative (the default), \
and False if x is non-commutative.
    
See SetCommutative and SetNonCommutative.";
CommutativeQ::Commutative = "Tried to set the `1` \"`2`\" to be commutative";
CommutativeQ::NonCommutative = "Tried to set the `1` \"`2`\" to be noncommutative";

Clear[NonCommutativeQ];

NonCommutativeQ::usage = "\
NonCommutativeQ[x] is equal to Not[CommutativeQ[x]]. 

See CommutativeQ.";
     
Clear[SetCommutative];

SetCommutative::usage = "\
SetCommutative[a, b, c, ...] sets all the symbols a, b, c, ... \
to be commutative.

See SetNonCommutative and CommutativeQ.";

Clear[SetNonCommutative];

SetNonCommutative::usage = "\
SetNonCommutative[a, b, c, ...] sets all the symbols a, b, c, ... \
to be noncommutative.

See SetCommutative and CommutativeQ.";
                  
Clear[ExpandNonCommutativeMultiply];

ExpandNonCommutativeMultiply::usage = "\
ExpandNonCommutativeMultiply[expr] expands out NonCommutativeMultiply's \
in expr. For example, NCE[a**(b+c)] will result in a**b + a**c.

It's aliases are NCE, and NCExpand.";

Clear[CommuteEverything];

CommuteEverything::usage = "\
Answers the question \"what does it sound like?\". \
CommuteEverything[expr] replaces all noncommutative symbols in  \
expr by its commutative self using Commutative so that the \
resulting expression contains no noncommutative products or inverses.

See Commutative.";

Clear[Commutative];                        
Commutative::usage = "\
Commutative[x] makes the noncommutative symbol x behave as \
if it were commutative
         
See CommuteEverything, CommutativeQ, SetCommutative, SetNonCommutative.";
                        
(* MAURICIO: JUNE 2009: THESE DECLARATIONS BECAUSE SOME RULES ARE DEFINED IN THIS FILE BEFORE LOAD NCTRANSPOSE, ETC *)

Clear[aj];
Clear[tp];
Clear[rt];
Clear[inv];
Clear[co]; (* MAURICIO MAR 2016 *)

Begin[ "`Private`" ]

  (* Overide Mathematica's existing NonCommutativeMultiply operator *)
  
  Unprotect[NonCommutativeMultiply];
  ClearAttributes[NonCommutativeMultiply, {OneIdentity, Flat}]


  (* CommutativeQ *)

  CommutativeQ[Slot] = False;
  CommutativeQ[SlotSequence] = False;
  CommutativeQ[Pattern] = False;
  CommutativeQ[Blank] = False;
  CommutativeQ[BlankSequence] = False;
  CommutativeQ[BlankNullSequence] = False;

  (* a commutative functions is commutative if all arguments are 
     also commutative*)
  CommutativeQ[f_?CommutativeQ[x___]] := 
      Apply[And, Map[CommutativeQ,{x}]];

  (* otherwise it is noncommutative *)
  CommutativeQ[f_[x___]] := False;

  (* everything else is commutative *)
  CommutativeQ[_] = True;
  
  (* NonCommutativeQ *)
  
  NonCommutativeQ[x_] := Not[CommutativeQ[x]];


  (*  SetCommutative and SetNonCommutative *)

  Clear[DoSetNonCommutative];
  DoSetNonCommutative[x_Symbol] := CommutativeQ[x] ^= False;
  DoSetNonCommutative[x_List] := SetNonCommutative /@ x;
  DoSetNonCommutative[x_?NumberQ] := 
    Message[CommutativeQ::NonCommutative, "number", x];
  DoSetNonCommutative[x_] := 
    Message[CommutativeQ::NonCommutative, "expression", x];

  SetNonCommutative[a__] := Scan[DoSetNonCommutative, {a}];

  Clear[DoSetCommutative];
  DoSetCommutative[x_Symbol] := CommutativeQ[x] ^= True;
  DoSetCommutative[x_List] := SetCommutative /@ x;
  DoSetCommutative[x_?NumberQ] := 
    Message[CommutativeQ::Commutative, "number", x];
  DoSetCommutative[x_] := 
    Message[CommutativeQ::Commutative, "expression", x];

  SetCommutative[a__] := Scan[DoSetCommutative, {a}];

  SetNonCommutative[NonCommutativeMultiply];

  (* Commutative *)
  
  CommutativeQ[x_Commutative] ^= True;
  Commutative[x_?CommutativeQ] = x;
  
  (* -------------------------------------------- *)
  (*  NonCommutative Muliplication book-keeping   *)
  (* -------------------------------------------- *)
                        
  (* Flatten *)
  NonCommutativeMultiply[a___, NonCommutativeMultiply[b__], c___] :=
    NonCommutativeMultiply[a, b, c];

  (* Pull out commutative factors *)
  NonCommutativeMultiply[a___, b_?CommutativeQ c_, d___] :=
    b NonCommutativeMultiply[a, c, d];
  NonCommutativeMultiply[a___, b_?CommutativeQ, c___] :=
    b NonCommutativeMultiply[a, c]; 
                        
  (* Identity *)
  NonCommutativeMultiply[f_[a_]] := f[a];
  NonCommutativeMultiply[a_Plus] := a;
  NonCommutativeMultiply[a_Symbol] := a;
  NonCommutativeMultiply[] := 1;
                        
  (* ---------------------------------------------------------------- *)
  (*  We added Expand[] outside  the original Eran formula for ENCM,  *)
  (*  this was neccessary to deal with commuting elements.	    *)
  (* ---------------------------------------------------------------- *)

  ExpandNonCommutativeMultiply[expr_] :=
    Expand[expr //. NonCommutativeMultiply[a___, b_Plus, c___] :>
       (NonCommutativeMultiply[a, #, c]& /@ b)];

  (* 05/14/2012 MAURICIO - BEGIN COMMENT *)
  (* Szabolcs Horvát <szhorvat@gmail.com> suggested a rule like:

     ExpandNonCommutativeMultiply[expr_] :=
       Expand[expr //. (HoldPattern[e_NonCommutativeMultiply] :> Distribute[e])];

     But it fails on exp2 = x ** inv[1 + x ** (1 + x)]

  *)
  (* 05/14/2012 MAURICIO - END *)

  (*                        
  CommuteEverything[exp_] := exp //. {
    tp[x_] -> x, 
    aj[x_] -> Conjugate[x], 
    co[x_] -> Conjugate[x], 
    rt[x_] -> x^(1/2),
    inv[x_] -> x^(-1),
    NonCommutativeMultiply -> Times
  };
  *)
  CommuteEverything[exp_] := 
       Replace[exp, x_Symbol :> Commutative[x],
               Infinity];
       
End[]

EndPackage[]
