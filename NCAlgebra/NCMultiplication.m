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

Clear[aj, tp, rt, inv, co,
      CommutativeQ, NonCommutativeQ, 
      SetCommutative, SetNonCommutative,
      ExpandNonCommutativeMultiply,
      CommuteEverything, Commutative];

Get["NonCommutativeMultiply.usage"];

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

      
  (* tp *)
       
  (* tp is NonCommutative *)
  SetNonCommutative[tp];

  (* tp is Linear *)
  tp[a_ + b_] := tp[a] + tp[b];
  tp[c_?NumberQ] := c;
  tp[a_?CommutativeQ] := a;

  (* tp is Idempotent *)
  tp[tp[a_]] := a;

  (* tp threads over Times *)
  tp[a_Times] := tp /@ a;

  (* tp reverse threads over NonCommutativeMultiply *)
  tp[NonCommutativeMultiply[a__]] := 
    (NonCommutativeMultiply @@ (tp /@ Reverse[{a}]));

  (* tp[inv[]] = inv[tp[]] *)
  tp[inv[a_]] := inv[tp[a]];


  (* aj *)

  (* aj is NonCommutative *)
  SetNonCommutative[aj];

  (* aj is Conjugate Linear *)
  aj[a_ + b_] := aj[a] + aj[b];
  aj[c_?NumberQ] := Conjugate[c];
  aj[a_?CommutativeQ]:= Conjugate[a];

  (* aj is Idempotent *)
  aj[aj[a_]] := a;

  (* aj threads over Times *)
  aj[a_Times] := aj /@ a;

  (* aj reverse threads over NonCommutativeMultiply *)
  aj[NonCommutativeMultiply[a__]] := 
     (NonCommutativeMultiply @@ (aj /@ Reverse[{a}]));

  (* aj[inv[]] = inv[aj[]] *)
  aj[inv[a_]] := inv[aj[a]];

End[]

EndPackage[]
