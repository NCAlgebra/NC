(* :Title: 	NCInverses // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings:   With the code as implemented, 
                inv[a]**inv[b] - inv[b]**inv[a] will not turn into 
                zero if a commutes with b. For possible future 
                improvements, see the ideas of ExpandQ and LeftQ. 
*)



(* :History: 
   :7/02/91:  Added extra condition to inv[a] commuting with b 
              statement so as to avoid an infinite loop. (mstankus)
   :4/21/93:  Added inv/: invR/: and invL/: to some commands. (mstankus)
   :9/21/93:  Replaced the code involving Id for efficiency. (mstankus)
              Also commented out redundent inverse code. (mstankus)
   :8/28/02:  Added additional rules in an attempt to improve 
              compatibility with commutative variables.  In particular,
              the command SetNonCommutative[inv, invR, invL] was
              removed, and a few sundry rules were added.  (bkotschw)
   :09/09/04: Added two additional rules to simplify inverses of 
              noncommutative products (mauricio) 
*)


BeginPackage[ "NonCommutativeMultiply`" ]


Clear[invR];

invR::usage =
     "Right inverse -- a**invR[a]=Id. See SetInv,invQ and OverrideInverse.";

Clear[invL];

invL::usage =
     "Left inverse -- invL[a]**a=Id. See SetInv,invQ and OverrideInverse.";

Clear[Id];

Id::usage =
     "Identity element. Actually Id is now set=1.";

(* :Note: inv is Cleared and used in NCMultiplication.m which
          precedes this file.
*)
(* Clear[inv]; *)

inv::usage =
     "inv[x] is a 2-sided identity of x. If invQ is true,then \
      invR[x] and invL[x] will be replaced by inv[x] (unless \
      OverrideInverse is True).";

Clear[OverrideInverse];

OverrideInverse::usage = 
     "When OverrideInverse is set to True, then the replacement of \
      invL and invR by inv when x is invertible is suppressed.\
      The default value is False.";

Clear[NCInverseForward];

NCInverseForward::usage = 
     "NCInverseForward[expr] applies the rules \
      B**inv[Id-A**B] -> inv[Id-B**A]**B and \
      inv[B]**inv[Id-B**A] -> inv[Id-B**A]**inv[A] to expr.";

Clear[NCInverseBackward];

NCInverseBackward::usage = 
     "NCInverseBackward[expr] applies the rules \
     inv[Id-B**A]**B -> B**inv[Id-A**B]  and \
     inv[Id-B**A]**inv[A] -> inv[A]**inv[Id-A**B] to expr.";

Clear[NCExpandInverse];

NCExpandInverse::usage = 
     "See NCAntihomo and ExpandQ. ExpandQ[inv] is the variable to set.";

Clear[SetInverseTp];

SetInverseTp::usage = 
     "Ask for explination of SetCommutingFunctions. The variable to \
      set is LeftQ[inv,tp].";

Clear[SetInvRightTp];

SetInvRightTp::usage = 
     "If SetInvRight Tp is set to True,then the rule \
      tp[invL[a_]]:=invR[tp[a]]; will \
      be executed and if False, then the reverse rule \
      invR[tp[a_]]:=tp[invL[a]]; will be executed.";

Begin[ "`Private`" ]

(* MODIFICATION -- 8/26/02 -- bkotschw 
       Commented out arguments to SNC below
       NOTE: with these commented out [and the rest of the code
       in its antediluvian state] the substitution
              inv[inv[a]] := a 
       isn't made--apparently, a  commutative inv[] renders
       SetIdempotent[] impotent.
*)

SetNonCommutative[(*invR,invL,inv,*)Global`Inv];

(* END modification *)

SetNonCommutative[a,b,c,d];

OverrideInverse = False;

(* -----------------------------------------------------------------*)
(*		First we define the identity         	            *)
(* -----------------------------------------------------------------*)
(* Commented out 9/21/93
Literal[NonCommutativeMultiply[a___,b_,Id,c___]]:=
   NonCommutativeMultiply[a,b,c];
Literal[NonCommutativeMultiply[a___,Id,b_,c___]]:=
   NonCommutativeMultiply[a,b,c];
*)
(* Added code 9/21/93 *)
Literal[NonCommutativeMultiply[a___,Id,c___]]:=
   NonCommutativeMultiply[a,c];

Id=1;


(* -----------------------------------------------------------------*)
(*	Rules for inverses                                          *)
(* -----------------------------------------------------------------*)

(* -----------------------------------------------------------------*)
(*     Two-sided inverses                                           *)
(* -----------------------------------------------------------------*)

(* ------ Direct replacement rules (Downvalues) for inv ----------- *)

(* Commented out unnec. code 9/21/93

inv[a_*b___]:=inv[b]/a /; NumberQ[a];

*)

(*ADDITIONS -- 08/27/02 -- bkotschw*)

inv[a_] := a^(-1) /; CommutativeQ[a];

inv[inv[a_]] := a;  (* This was handled previously by the
		       call SetIdempotent[inv] (see below).
		       However, SetIdempotent[] seems to require
		       that inv[] be non-commutative, a condition
		       with which we are currently trying to 
		       dispense.
		     *)
IdempotentQ[inv] := True;
(*END ADDITIONS *)

(*BUG FIX -- 04/25/12 -- BEGIN -- MAURICIO*)

(* inv[a_*b___]:=inv[a]*inv[b] /; CommutativeQ[a]; *)

inv[a_*b_]:=inv[a]*inv[b] /; CommutativeQ[a];

(*BUG FIX -- END -- MAURICIO*)

inv[a_]:=1/a /; NumberQ[a];

inv[-a_] := -inv[a];  (*Redundant?  bkotschw 8/28/02*)

(* --- Rules for expressions containing inv (Upvalues) ------------ *)

inv/:Literal[NonCommutativeMultiply[b___,a_,inv[a_],c___]]:=
   NonCommutativeMultiply[b,Id,c];
inv/:Literal[NonCommutativeMultiply[b___,f_[x___],inv[f_[x___]],c___]]:=
   NonCommutativeMultiply[b,Id,c]; 

inv/:Literal[NonCommutativeMultiply[b___,inv[a_],a_,c___]]:=
   NonCommutativeMultiply[b,Id,c];
inv/:Literal[NonCommutativeMultiply[b___,inv[f_[x___]],f_[x___],c___]]:=
   NonCommutativeMultiply[b,Id,c];

(* MAURICIO -- 04/25/12 -- BEGIN *)
(* MAURICIO THINKS THESE RULES ARE MATHEMATICALLY INCORRECT 
  AND COULD LEAD TO PROGRAMMING MISTAKES *)

inv/:Literal[Times[b___,a_,inv[a_],c___]]:=
   Times[b,Id,c];
inv/:Literal[Times[b___,f_[x___],inv[f_[x___]],c___]]:=
   Times[b,Id,c]; 

inv/:Literal[Times[b___,inv[a_],a_,c___]]:=
   Times[b,Id,c];
inv/:Literal[Times[b___,inv[f_[x___]],f_[x___],c___]]:=
   Times[b,Id,c];

(* MAURICIO -- END *)

(*ADDITIONS -- 09/09/04 -- mauricio *)

inv/:Literal[NonCommutativeMultiply[b___,a__,inv[NonCommutativeMultiply[a__]],c___]]:=
    NonCommutativeMultiply[b,Id,c];
inv/:Literal[NonCommutativeMultiply[b___,inv[NonCommutativeMultiply[a__]],a__,c___]]:=
    NonCommutativeMultiply[b,Id,c];

(*END ADDITIONS *)

(* REMOVAL -- 8/28/02 -- bkotschw *)

(* SetIdempotent[inv]; *)

(* END REMOVAL *)

inv/:Literal[NonCommutativeMultiply[inv[a_],b_]] :=
              NonCommutativeMultiply[b,inv[a]] /; 
                 Not[Head[b]==inv] && 
                 NonCommutativeMultiply[a,b] == NonCommutativeMultiply[b,a]

ExpandQ[inv] := True;

Literal[inv[NonCommutativeMultiply[a___,b_,c_,d___]]] := 
	NonCommutativeMultiply[inv[NonCommutativeMultiply[c,d]], 
                               inv[NonCommutativeMultiply[a,b]]] /; 
                                                     ExpandQ[inv] == True;

inv/:Literal[NonCommutativeMultiply[a___,inv[b_],inv[c_],d___]] :=
	NonCommutativeMultiply[a,inv[NonCommutativeMultiply[c,b]],d] /; 
                                                       ExpandQ[inv] == False;

inv/:Literal[NonCommutativeMultiply[inv[b_],inv[c_]]] :=
	inv[NonCommutativeMultiply[c,b]] /; ExpandQ[inv] == False;


(* -----------------------------------------------------------------*)
(*     Left and right inverses                                      *)
(* -----------------------------------------------------------------*)

(* --- Direct replacements (Downvalues) ---------------------------- *)

invR[-a_] := -invR[a];
invL[-a_] := -invL[a];

(* --- Replacements for expressions containing inv{R,L} (Upvalues)- *)

invR/:Literal[NonCommutativeMultiply[b___,a_,invR[a_],c___]]:=
    NonCommutativeMultiply[b,Id,c] /; Not[OverrideInverse];
invR/:Literal[NonCommutativeMultiply[b___,f_[x___],invR[f_[x___]],c___]]:=
    NonCommutativeMultiply[b,Id,c] /; Not[OverrideInverse];

invL/:Literal[NonCommutativeMultiply[b___,invL[a_],a_,c___]]:=
   NonCommutativeMultiply[b,Id,c] /; Not[OverrideInverse];
invL/:Literal[NonCommutativeMultiply[b___,invL[f_[x___]],f_[x___],c___]]:=
   NonCommutativeMultiply[b,Id,c] /; Not[OverrideInverse];

(* MAURICIO -- 04/25/12 -- BEGIN *)
(* MAURICIO THINKS THESE RULES ARE MATHEMATICALLY INCORRECT 
  AND COULD LEAD TO PROGRAMMING MISTAKES *)

invR/:Literal[Times[b___,a_,invR[a_],c___]]:=
    Times[b,Id,c] /; Not[OverrideInverse];
invR/:Literal[Times[b___,f_[x___],invR[f_[x___]],c___]]:=
    Times[b,Id,c] /; Not[OverrideInverse];

invL/:Literal[Times[b___,invL[a_],a_,c___]]:=
   Times[b,Id,c] /; Not[OverrideInverse];
invL/:Literal[Times[b___,invL[f_[x___]],f_[x___],c___]]:=
   Times[b,Id,c] /; Not[OverrideInverse];

(* MAURICIO -- END *)

(* -----------------------------------------------------------------*)
(*     invQ                                                         *)
(* -----------------------------------------------------------------*)

invQ[___]:=False
invR[a_]:=inv[a] /; invQ[a] && Not[OverrideInverse] 
invL[a_]:=inv[a] /; invQ[a] && Not[OverrideInverse]


(* -----------------------------------------------------------------*)
(*     Miscellania                                                  *)
(* -----------------------------------------------------------------*)


(* --- Rules subsumed by NCSimplifyRational (not used much) ------- *)

NCInverseForward[exp_] :=
     Block[{Faa,Fbb,Fcc,Fdd,Fee,Ftempexp,Frulem,Frulep,Fruleinvp,Fruleinvm},
        SetNonCommutative[Faa,Fbb,Fcc,Fdd,Fee];
        Frulep = Fdd___**Fbb_**inv[Id+Fcc_**Fbb_]**Fee___ :> 
                     Fdd**inv[Id+Fbb**Fcc]**Fbb**Fee;
        Frulem = Fdd___**Fbb_**inv[Id-Fcc_**Fbb_]**Fee___ :> 
                     Fdd**inv[Id-Fbb**Fcc]**Fbb**Fee;
        Fruleinvp = Fdd___**inv[Fcc_]**inv[Id+Fcc_**Fbb_]**Fee___ :> 
                     Fdd**inv[Id+Fbb**Fcc]**inv[Fcc]**Fee;
        Fruleinvm = Fdd___**inv[Fcc_]**inv[Id-Fcc_**Fbb_]**Fee___ :> 
                     Fdd**inv[Id-Fbb**Fcc]**inv[Fcc]**Fee;
        Ftempexp= exp //. {Frulep,Frulem,Fruleinvp,Fruleinvm};
        Return[Ftempexp]
];


NCInverseBackward[exp_] :=
	Block[{Baa,Bbb,Bcc,Bdd,Bee,Btempexp,Brulep,Brulem,Bruleinvp,Bruleinvm},
            SetNonCommutative[Baa,Bbb,Bcc,Bdd,Bee];
            Brulep = Bdd___**inv[Id+Bbb_**Bcc_]**Bbb_**Bee___ :> 
                  Bdd**Bbb**inv[Id+Bcc**Bbb]**Bee;
            Brulem = Bdd___**inv[Id-Bbb_**Bcc_]**Bbb_**Bee___ :> 
                  Bdd**Bbb**inv[Id-Bcc**Bbb]**Bee;
            Bruleinvp = Bdd___**inv[Id+Bbb_**Bcc_]**inv[Bcc_]**Bee___ :> 
                     Bdd**inv[Bcc]**inv[Id+Bcc**Bbb]**Bee;
            Bruleinvm = Bdd___**inv[Id-Bbb_**Bcc_]**inv[Bcc_]**Bee___ :> 
                    Bdd**inv[Bcc]**inv[Id-Bcc**Bbb]**Bee;
            Btempexp= exp //. {Brulep,Brulem,Bruleinvp,Bruleinvm};
	    Return[Btempexp]
];

End[]

EndPackage[]
