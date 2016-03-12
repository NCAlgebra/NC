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

CommutativeQ::usage = 
"CommutativeQ[x] is True if x is commutative (the default), \
and False if x is non-commutative.  See SetCommutative and \
SetNonCommutative.";

Clear[NonCommutativeQ];

NonCommutativeQ::usage = 
"NonCommutativeQ[x] is equal to Not[CommutativeQ[x]]. See CommutativeQ.";
     
Clear[SetCommutative];

SetCommutative::usage = 
     "SetCommutative[a, b, c, ...] sets all the symbols a, b, c, ... \
      to be commutative. See SetNonCommutative and CommutativeQ.";

Clear[SetNonCommutative];

SetNonCommutative::usage = 
     "SetNonCommutative[a, b, c, ...] sets all the symbols a, b, c, ... \
      to be non-commutative. See SetCommutative and CommutativeQ.";

Clear[ExpandNonCommutativeMultiply];

ExpandNonCommutativeMultiply::usage =
     "ExpandNonCommutativeMultiply[expr] expands out \
      NonCommutativeMultiply's in expr. It's aliases are \
      NCE,NCExpand and ExpandNC. For example, NCE[a**(b+c)] \
      will result in a**b + a**c.";

Clear[TimesToNCM];

TimesToNCM::usage =
     "TimesToNCM[expr] returns expr/.Times->NonCommutativeMultiply.";

Clear[CommuteEverything];

CommuteEverything::usage = 
     "Answers the question \"what does it sound like?\". \
      CommuteEverything[expr] returns \
      expr/.NonCommuativeMultiply->Times";

(* MAURICIO: JUNE 2009: THESE DECLARATIONS BECAUSE SOME RULES ARE DEFINED IN THIS FILE BEFORE LOAD NCTRANSPOSE, ETC *)

Clear[aj];
Clear[tp];
Clear[rt];
Clear[inv];
Clear[co]; (* MAURICIO MAR 2016 *)

Begin[ "`Private`" ]

  Unprotect[NonCommutativeMultiply];
  ClearAttributes[NonCommutativeMultiply, {OneIdentity, Flat}]

  NonCommutativeQ[x_] = Not[CommutativeQ[x]];

  (* ---------------------------------------------------------------- *)
  (*  Set all varibles to be commutative by default.                  *)
  (* ---------------------------------------------------------------- *)

  CommutativeQ[_Symbol] = True;
  CommutativeQ[_Integer] = True;
  CommutativeQ[_Real] = True;
  CommutativeQ[_String] = True;

  CommutativeQ[_?NumberQ] = True;

  CommutativeQ[Slot] = False;
  CommutativeQ[SlotSequence] = False;
  CommutativeQ[Pattern] = False;
  CommutativeQ[Blank] = False;
  CommutativeQ[BlankSequence] = False;
  CommutativeQ[BlankNullSequence] = False;

  (* MAURICIO MAR 2016 *)
  (* This rule assumes functions are noncommutative 
     which basically makes all patterns work *)
  (*
    Global`$NC$ForceCommutativeAllQ=True; (* Mark Stankus's choice *)
    If[Global`$NC$ForceCommutativeAllQ===True
      , CommutativeQ[f_[x___]] := 
          If[CommutativeQ[f], Apply[And, Map[CommutativeQ,{x}]]
                            , False
          ];
    ];
  *)
  CommutativeQ[f_?CommutativeQ[x___]] := Apply[And, Map[CommutativeQ,{x}]];
  CommutativeQ[f_[x___]] := False;

  (* Everything else is commutative *)
  CommutativeQ[_] = True;

  (* ---------------------------------------------------------------- *)
  (*  Set commutative and non-commutative commands.                   *)
  (* ---------------------------------------------------------------- *)
  DoSetNonCommutative[x_?NumberQ] := 
    Print["Warning: Tried to set the number ", Format[x,InputForm],
          " to be noncommutative."];

  DoSetNonCommutative[x_Plus] := 
    Print["Warning: Tried to set the expression", Format[x,InputForm],
          " to be noncommutative."];

  DoSetNonCommutative[x_Times] :=
    Print["Warning: Tried to set the expression", Format[x,InputForm],
          " to be noncommutative."];

  DoSetNonCommutative[x_NonCommutativeMultiply] :=
    Print["Warning: Tried to set the expression", Format[x,InputForm],
          " to be noncommutative."];

  DoSetNonCommutative[x_List] := SetNonCommutative /@ x;

  DoSetNonCommutative[x_] := CommutativeQ[x] ^= False;

  SetNonCommutative[a__] := Scan[DoSetNonCommutative, {a}];

  DoSetCommutative[x_] := CommutativeQ[x] ^= True;

  SetCommutative[a__] := Scan[DoSetCommutative, {a}];

  SetNonCommutative[NonCommutativeMultiply];

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
     Expand[expr //. HoldPattern[NonCommutativeMultiply[a___, b_Plus, c___]] :>
       (NonCommutativeMultiply[a, #, c]& /@ b)];

  (* 05/14/2012 MAURICIO - BEGIN COMMENT *)
  (* Szabolcs Horvát <szhorvat@gmail.com> suggested a rule like:

     ExpandNonCommutativeMultiply[expr_] :=
       Expand[expr //. (HoldPattern[e_NonCommutativeMultiply] :> Distribute[e])];

     But it fails on exp2 = x ** inv[1 + x ** (1 + x)]

  *)
  (* 05/14/2012 MAURICIO - END *)

  (* ---------------------------------------------------------------- *)
  (*  This concludes material obtained from ERAN@SLACVM.BITNET at     *)
  (*  Stanford Linear Accelerator                                     *)
  (* ---------------------------------------------------------------- *)

  TimesToNCM[expr_] := expr /. Times->NonCommutativeMultiply;

  (* MAURICIO: JUNE 2009: ADDED HOLDPATTERN TO PROTECT CE *)

  CommuteEverything[v_] := v //. {
    NonCommutativeMultiply -> Times,
    HoldPattern[tp[x_]]->x, 
    HoldPattern[aj[x_]]->Conjugate[x], 
    HoldPattern[co[x_]]->Conjugate[x], 
    HoldPattern[rt[x_]]->x^(1/2),
    HoldPattern[inv[x_]]->x^(-1)
  };

End[]

EndPackage[]
