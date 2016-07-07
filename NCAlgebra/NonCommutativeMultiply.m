(* :Title: 	NCMultiplication *)

(* :Author: 	Unknown. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage[ "NonCommutativeMultiply`" ];

Clear[aj, tp, rt, inv, co,
      CommutativeQ, NonCommutativeQ, 
      SetCommutative, SetNonCommutative,
      ExpandNonCommutativeMultiply,
      CommuteEverything, Commutative];

CommutativeQ::Commutative = "Tried to set the `1` \"`2`\" to be commutative";
CommutativeQ::NonCommutative = "Tried to set the `1` \"`2`\" to be noncommutative";

Get["NonCommutativeMultiply.usage"];

Begin[ "`Private`" ]

  (* Overide Mathematica's existing NonCommutativeMultiply operator *)
  
  Unprotect[NonCommutativeMultiply];
  ClearAttributes[NonCommutativeMultiply, {OneIdentity, Flat}];

  Clear[NCPatternQ];
  NCPatternQ[Slot] = True;
  NCPatternQ[SlotSequence] = True;
  NCPatternQ[Pattern] = True;
  NCPatternQ[Blank] = True;
  NCPatternQ[BlankSequence] = True;
  NCPatternQ[BlankNullSequence] = True;
  NCPatternQ[_] = False;
  
  (* CommutativeQ *)

  CommutativeQ[Slot] = False;
  CommutativeQ[SlotSequence] = False;
  CommutativeQ[Pattern] = False;
  CommutativeQ[Blank] = False;
  CommutativeQ[BlankSequence] = False;
  CommutativeQ[BlankNullSequence] = False;

  (* a matrix is noncommutative *)
  CommutativeQ[_?MatrixQ] := False;
  
  (* a commutative functions is commutative if all arguments are 
     also commutative *)
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
  (* MAURICIO BUG: 07/07/2016
     The following can be replaced by f_[a__] which triggers some ...
     recursive calls.
  *)
  (*
    NonCommutativeMultiply[f_[a_]] := f[a];
    NonCommutativeMultiply[a_Plus] := a; 
  *)
  NonCommutativeMultiply[f_[a__]] /; !NCPatternQ[f] := f[a];
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
  tp[a_NonCommutativeMultiply] := 
    (NonCommutativeMultiply @@ (tp /@ Reverse[List @@ a]));

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
  aj[a_NonCommutativeMultiply] := 
     (NonCommutativeMultiply @@ (aj /@ Reverse[List @@ a]));

  (* aj[inv[]] = inv[aj[]] *)
  aj[inv[a_]] := inv[aj[a]];


  (* co *)
  
  (* co is NonCommutative *)
  SetNonCommutative[co];

  (* co is Conjugate Linear *)
  co[a_ + b_] := co[a] + co[b];
  co[c_?NumberQ] := Conjugate[c];
  co[a_?CommutativeQ]:= Conjugate[a];

  (* co is Idempotent *)
  co[co[a_]] := a;

  (* co threads over Times *)
  co[a_Times] := co /@ a;

  (* co threads over Times *)
  co[a_Times] := co /@ a;

  (* co threads over NonCommutativeMultiply *)
  co[a_NonCommutativeMultiply] := co /@ a;
  
  (* Relationship with aj and tp *)

  aj[tp[a_]] := co[a];
  tp[aj[a_]] := co[a];

  co[tp[a_]] := aj[a];
  co[aj[a_]] := tp[a];


  (* rt *)
  
  (* rt is noncommutative *)
  SetNonCommutative[rt];

  (* rt commutative *)
  rt[c_?NumberQ] := Sqrt[c];
  rt[a_?CommutativeQ] := Sqrt[a];

  (* rt threads over Times *)
  rt[a_Times] := rt /@ a;

  (* Simplification *)
  NonCommutativeMultiply[n___,rt[m_],rt[m_],l___] :=
    NonCommutativeMultiply[n,m,l] 
 
  (* tp[rt[]] = rt[tp[]] *)
  tp[rt[a_]] := rt[tp[a]];

  (* BEGIN MAURICIO MAR 2016 *)
  (*
    NonCommutativeMultiply[n___,rt[m_],aj[rt[m_]],l___] :=
       NonCommutativeMultiply[n,m,l];
     
    rt/:Literal[NonCommutativeMultiply[n___,rt[Id - aj[m_]** m_],aj[m_],l___]] :=
      NonCommutativeMultiply[n,aj[m],rt[Id -m**aj[m]],l];

    rt/:Literal[NonCommutativeMultiply[n___,rt[Id - m_**aj[m_]], m_,l___]] :=
      NonCommutativeMultiply[n,m,aj[Id -aj[m]**m],l];
  *)
  (* END MAURICIO MAR 2016 *)

  
  (* inv *)
  
  (* inv is NonCommutative *)
  SetNonCommutative[inv];

  (* identity *)
  Id = 1;
  (* NonCommutativeMultiply[a___,Id,c___] := NonCommutativeMultiply[a,c]; *)

  (* commutative inverse *)
  inv[a_?CommutativeQ] := a^(-1);
  inv[a_?NumberQ] := 1/a;

  (* inv is idempotent *)
  inv[inv[a_]] := a;

  (* tp threads over Times *)
  inv[a_Times] := inv /@ a;

  (* inv simplifications *)
  inv/:NonCommutativeMultiply[b___,a_,inv[a_],c___] :=
         NonCommutativeMultiply[b,c];
  inv/:NonCommutativeMultiply[b___,inv[a_],a_,c___] :=
         NonCommutativeMultiply[b,c];
  inv/:NonCommutativeMultiply[b___,a__,
                              inv[NonCommutativeMultiply[a__]],c___] :=
         NonCommutativeMultiply[b,c];
  inv/:NonCommutativeMultiply[b___,
                              inv[NonCommutativeMultiply[a__]],a__,c___] :=
         NonCommutativeMultiply[b,c];

  (* MAURICIO MAR 2016 *)
  (* THESE OLD RULES ARE UNECESSARY *)
  (* 
    inv/:NonCommutativeMultiply[b___,f_[x___],inv[f_[x___]],c___]:=
       NonCommutativeMultiply[b,Id,c]; 
    inv/:Literal[NonCommutativeMultiply[b___,inv[f_[x___]],f_[x___],c___]]:=
       NonCommutativeMultiply[b,Id,c];
  *)
  (*
    inv/:Literal[NonCommutativeMultiply[inv[a_],b_]] :=
                 NonCommutativeMultiply[b,inv[a]] /; 
                   Not[Head[b]==inv] && 
                   NonCommutativeMultiply[a,b] == NonCommutativeMultiply[b,a]

    Literal[inv[NonCommutativeMultiply[a___,b_,c_,d___]]] := 
	NonCommutativeMultiply[inv[NonCommutativeMultiply[c,d]], 
                               inv[NonCommutativeMultiply[a,b]]] /; 
                                                     ExpandQ[inv] == True;

    inv/:Literal[NonCommutativeMultiply[a___,inv[b_],inv[c_],d___]] :=
        NonCommutativeMultiply[a,inv[NonCommutativeMultiply[c,b]],d] /; 
                                                       ExpandQ[inv] == False;

    inv/:Literal[NonCommutativeMultiply[inv[b_],inv[c_]]] :=
  	inv[NonCommutativeMultiply[c,b]] /; ExpandQ[inv] == False;
  *)
  (* MAURICIO THINKS THESE RULES ARE MATHEMATICALLY INCORRECT 
    AND COULD LEAD TO PROGRAMMING MISTAKES *)
  (*
    inv/:Literal[Times[b___,a_,inv[a_],c___]]:=
       Times[b,Id,c];
    inv/:Literal[Times[b___,inv[a_],a_,c___]]:=
       Times[b,Id,c];
    inv/:Literal[Times[b___,f_[x___],inv[f_[x___]],c___]]:=
       Times[b,Id,c]; 
    inv/:Literal[Times[b___,inv[f_[x___]],f_[x___],c___]]:=
       Times[b,Id,c];
  *)
  (* END MAURICIO MAR 2016 *)


  (* Power *)
  
  (* Expand monomial rules *)
  Unprotect[Power];
  Power[b_, c_Integer?Positive] := 
    Apply[NonCommutativeMultiply, Table[b, {c}]] /; !CommutativeQ[b];
  Power[b_, c_Integer?Negative] := 
    inv[Apply[NonCommutativeMultiply, Table[b, {-c}]]] /; !CommutativeQ[b];
  Protect[Power];
  
End[]

EndPackage[]
