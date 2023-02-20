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

BeginPackage["NonCommutativeMultiply`",
	     {
	       "NCUtil`"
	     }
];

Clear[aj, tp, rt, inv, co,
      CommutativeQ, NonCommutativeQ, 
      NCNonCommutativeSymbolOrSubscriptQ,
      NCPowerQ,
      SetCommutative, SetNonCommutative,
      SetCommutativeFunction,
      SetNonCommutativeFunction,
      SetNonCommutativeHold,
      SetCommutingOperators,
      UnsetCommutingOperators,
      CommutingOperatorsQ,
      ExpandNonCommutativeMultiply,
      NCExpandExponents,
      BeginCommuteEverything, EndCommuteEverything, 
      CommuteEverything, Commutative,
      SNC, NCExpand, NCE,
      NCValueQ, NCToList];

CommutativeQ::Commutative = "Tried to set the `1` \"`2`\" to be commutative.";
CommutativeQ::NonCommutative = "Tried to set the `1` \"`2`\" to be noncommutative.";

CommutativeQ::CommutativeSubscript = "Tried to set the subscript \"`2`\" of symbol \"`1`\" to be commutative. Please set the symbol \"`1`\" to be commutative instead.";
CommutativeQ::NonCommutativeSubscript = "Tried to set the subscript \"`2`\" of symbol \"`1`\" to be noncommutative. Please set the symbol \"`1`\" to be noncommutative instead.";

CommuteEverything::Warning = "Commute everything set the variable(s) \
`1` to be commutative. Use EndCommuteEverything[] to set them back as \
noncommutative.";

TDefined::Warning = "Symbol T has definitions associated with it \
that will be cleared by NCAlgebra.";

SetNonCommutative::Protected = "WARNING: Symbol `1` was set as non commutative but it is protected. You should seriously consider not setting it as noncommutative.";

SetCommutative::Protected = "WARNING: Symbol `1` was set as commutative but it is protected. You should seriously consider not setting it as commutative.";

SetCommutingOperators::AlreadyDefined = "Symbols `1` and `2` were already defined commutative. Replacing existing rule.";

Get["NonCommutativeMultiply.usage", CharacterEncoding->"UTF8"];

Begin[ "`Private`" ]

  (* Idea from 
     http://mathematica.stackexchange.com/questions/10306/how-to- 
            properly-handle-mutual-imports-of-multiple-packages 
     to take care of mutal import of NCUtil` 
  *)
  (* Needs["NCUtil`"]; *)

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
  CommutativeQ[a_List] := False /; MatrixQ[a];
  CommutativeQ[a_SparseArray] := False /; MatrixQ[a];
  
  (* commutative subscripts depend on symbol *)
  CommutativeQ[Subscript[x_,___]] := CommutativeQ[x];
  
  (* a commutative functions is commutative if all arguments are 
     also commutative; this includes lists which are not matrices *)
  CommutativeQ[f_?CommutativeQ[x___]] := Apply[And, Map[CommutativeQ,{x}]];

  (* otherwise it is noncommutative *)
  CommutativeQ[f_[x___]] := False;

  (* everything else is commutative *)
  CommutativeQ[_] = True;
  
  (* NonCommutativeQ *)
  NonCommutativeQ[x_] := Not[CommutativeQ[x]];

  (* NCNonCommutativeSymbolOrSubscriptQ *)
  NCNonCommutativeSymbolOrSubscriptQ =
    Function[x,
             MatchQ[x, _Symbol|Subscript[_Symbol,__]] && NonCommutativeQ[x]];

  (* NCPowerQ *)
  NCPowerQ =
    Function[x,
      NCNonCommutativeSymbolOrSubscriptQ[x] ||
      MatchQ[x,Power[y_?NCNonCommutativeSymbolOrSubscriptQ, _Integer?Positive]]];

  (*  SetCommutative and SetNonCommutative *)
  Clear[OverwriteWriteProtection];
  OverwriteWriteProtection[message_, x_Symbol, value_] :=
    Quiet[
      Check[
         (x /: HoldPattern[CommutativeQ[x]] = value);
        ,
         Unprotect[x];
         (x /: HoldPattern[CommutativeQ[x]] = value);
         Protect[x];
         Message[message, x];
        , 
         TagSet::write
      ];
     , 
      TagSet::write
    ];
  SetAttributes[OverwriteWriteProtection, HoldFirst];

  Clear[DoSetNonCommutative];
  DoSetNonCommutative[x_Symbol] :=
    OverwriteWriteProtection[SetNonCommutative::Protected, x, False];
  DoSetNonCommutative[x_List] := SetNonCommutative /@ x;
  DoSetNonCommutative[Subscript[x_Symbol, y__]] := 
    Message[CommutativeQ::NonCommutativeSubscript, x, y];
  DoSetNonCommutative[x_?NumberQ] := 
    Message[CommutativeQ::NonCommutative, "number", x];
  DoSetNonCommutative[x_] := 
    Message[CommutativeQ::NonCommutative, "expression", x];
  SetAttributes[DoSetNonCommutative, HoldAll];

  SetNonCommutative[a__] := Scan[DoSetNonCommutative, {a}];
  
  SetNonCommutativeHold[a__] := Scan[DoSetNonCommutative, Unevaluated[{a}]];
  SetAttributes[SetNonCommutativeHold, HoldAll];

  Clear[DoSetCommutative];
  DoSetCommutative[x_Symbol] :=
    OverwriteWriteProtection[SetCommutative::Protected, x, True];
  DoSetCommutative[x_List] := SetCommutative /@ x;
  DoSetCommutative[Subscript[x_Symbol, y__]] := 
    Message[CommutativeQ::CommutativeSubscript, x, y];
  DoSetCommutative[x_?NumberQ] := 
    Message[CommutativeQ::Commutative, "number", x];
  DoSetCommutative[x_] := 
    Message[CommutativeQ::Commutative, "expression", x];
  SetAttributes[DoSetCommutative, HoldAll];

  SetCommutative[a__] := Scan[DoSetCommutative, {a}];

  SetCommutativeHold[a__] := Scan[DoSetCommutative, Unevaluated[{a}]];
  SetAttributes[SetCommutativeHold, HoldAll];

  SetNonCommutative[NonCommutativeMultiply];

  (* SetCommutativeFunction *)
  SetCommutativeFunction[f_Symbol] :=
    Quiet[
      Check[
         f /: HoldPattern[CommutativeQ[f[___]]] = True;
        ,
         Unprotect[f];
         f /: HoldPattern[CommutativeQ[f[___]]] = True;
         Protect[f];
         Message[SetCommutative::Protected, f];
        ,
         TagSet::write
      ];
     ,
      TagSet::write
    ];

  (* SetNonCommutativeFunction *)
  SetNonCommutativeFunction[f_Symbol] :=
    Quiet[
      Check[
         f /: HoldPattern[CommutativeQ[f[___]]] =.;
        ,
         Unprotect[f];
         f /: HoldPattern[CommutativeQ[f[___]]] =.;
         Protect[f];
         Message[SetNonCommutative::Protected, f];
        ,
         TagUnset::write
      ];
     ,
      {TagUnset::write, TagUnset::norep}
    ];

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
                        
  (* Power *)
  NonCommutativeMultiply[a___, b_?NotMatrixQ, d:(b_ ..), c___] := 
    NonCommutativeMultiply[a, Power[b, Length[{d}]+1], c];
  NonCommutativeMultiply[b___,a_?NotMatrixQ^n_.,a_^m_.,c___] :=
    NonCommutativeMultiply[b,Power[a,n+m],c];
  NonCommutativeMultiply[b___,NonCommutativeMultiply[a__]^n_.,a__,c___] :=
    NonCommutativeMultiply[b,Power[NonCommutativeMultiply[a],n+1],c];
  NonCommutativeMultiply[b___,a__,NonCommutativeMultiply[a__]^n_.,c___] :=
    NonCommutativeMultiply[b,Power[NonCommutativeMultiply[a],n+1],c];

  (* Convert noncommutative product into list expanding powers *)
  NCToList[l_NonCommutativeMultiply] :=
    Flatten[(List @@ l) /. Power[x_,n_?Positive] :> Table[x, n]];
  NCToList[Power[x_?NonCommutativeQ, n:_Integer?Positive:1]] :=
    Table[x, n];

  (* Identity *)
  (* MAURICIO BUG: 07/07/2016
     The following can be replaced by f_[a__] which triggers some
     recursive calls.
  *)
  (*
    NonCommutativeMultiply[f_[a_]] := f[a];
    NonCommutativeMultiply[a_Plus] := a; 
  *)
  NonCommutativeMultiply[f_[a__]] /; !NCPatternQ[f] := f[a];
  NonCommutativeMultiply[a_Symbol] := a;
  NonCommutativeMultiply[] := 1;

  NCExpandExponents[expr_] := 
    ReplaceRepeated[expr, 
      (x_?NonCommutativeQ^n_ /; Not[NCSymbolOrSubscriptQ[x]]) :>
         NonCommutativeMultiply @@ Table[x, n]];

  (* ---------------------------------------------------------------- *)
  (*  We added Expand[] outside  the original Eran formula for ENCM,  *)
  (*  this was neccessary to deal with commuting elements.	    *)
  (* ---------------------------------------------------------------- *)

  ExpandNonCommutativeMultiply[expr_] :=
    (* Expand[expr //. NonCommutativeMultiply[a___, b_Plus, c___] :>
	      (NonCommutativeMultiply[a, #, c]& /@ b)]; *)
    ExpandAll[expr //. {
      Power[b_Plus, c_Integer?Positive] :> 
        Plus @@ Apply[NonCommutativeMultiply, 
          Distribute[Table[List @@ b, c], List], {1}],
      Power[b_Plus, c_Integer?((Negative[#] && # < -1) &)] :> 
        Power[Plus @@ Apply[NonCommutativeMultiply, 
          Distribute[Table[List @@ b, -c], List], {1}], -1],
      Power[b_?(Not[NCSymbolOrSubscriptQ[#]] &), c_Integer?Positive] :> 
        NonCommutativeMultiply @@ Table[b, c],
      Power[b_?(Not[NCSymbolOrSubscriptQ[#]] &), c_Integer?((Negative[#] && # < -1) &)] :> 
        Power[NonCommutativeMultiply @@ Table[b, -c], -1],
      NonCommutativeMultiply[a___, b_Plus, c___] :>
        (NonCommutativeMultiply[a, #, c] & /@ b)
    }];

  (* 05/14/2012 MAURICIO - BEGIN COMMENT *)
  (* Szabolcs Horvát <szhorvat@gmail.com> suggested a rule like:

     ExpandNonCommutativeMultiply[expr_] :=
       Expand[expr //. (HoldPattern[e_NonCommutativeMultiply] :> Distribute[e])];

     But it fails on exp2 = x ** inv[1 + x ** (1 + x)]

  *)
  (* 05/14/2012 MAURICIO - END *)

  (* CommuteEverything *)
  Clear[$NCCommuteEverythingSymbols];
  $NCCommuteEverythingSymbols = {};
  BeginCommuteEverything[expr_] := Block[
      {ncvars},
      ncvars = Cases[NCGrabSymbols[expr], Except[_?CommutativeQ]];
      If[ncvars != {},
        Message[CommuteEverything::Warning, 
                ToString[First[ncvars]] <>
                StringJoin @@ Map[(", " <> ToString[#])&, Rest[ncvars]]];
      ];
      $NCCommuteEverythingSymbols = Join[$NCCommuteEverythingSymbols, ncvars];
      SetCommutative[ncvars];
      (* Print["ncvars = ", ncvars]; *)
      (* Return[Replace[expr, x_Symbol :> Commutative[x], Infinity]]; *)
      Return[expr];
  ];
  
  EndCommuteEverything[] := Block[
      {},
      SetNonCommutative[$NCCommuteEverythingSymbols];
      (* Print["ECE = ", $NCCommuteEverythingSymbols]; *)
      $NCCommuteEverythingSymbols = {};
  ];
   
  CommuteEverything[expr_] := BeginCommuteEverything[expr];
      
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
  tp[a_NonCommutativeMultiply] := tp /@ Reverse[a];

  (* tp[inv[]] = inv[tp[]] *)
  (* tp[inv[a_]] := inv[tp[a]]; *)
  tp[a_^n_] := tp[a]^n;

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
  aj[a_NonCommutativeMultiply] := aj /@ Reverse[a];

  (* aj[inv[]] = inv[aj[]] *)
  (* aj[inv[a_]] := inv[aj[a]]; *)
  aj[a_^n_] := aj[a]^n;

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

  aj[co[a_]] := tp[a];
  aj[tp[a_]] := co[a];

  (* rt *)
  
  (* rt is noncommutative *)
  SetNonCommutative[rt];

  (* rt commutative *)
  rt[c_?NumberQ] := Sqrt[c];
  rt[a_?CommutativeQ] := Sqrt[a];

  (* rt threads over Times *)
  rt[a_Times] := rt /@ a;

  (* Simplification *)
  rt /: Power[rt[m_], n_Integer?Positive] := If[EvenQ[n], m^(n/2), m^((n-1)/2) ** rt[m]];

  (* Cannonization *)
  NonCommutativeMultiply[b___, rt[a_], a_, c___] := b ** a ** rt[a] ** c;
 
  (* tp[rt[]] = rt[tp[]] *)
  tp[rt[a_]] := rt[tp[a]];
   (* MAURICIO: FEB 2022: shouldn't we have a similar rule for aj and co? *)

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

  inv[a_ /; !MatrixQ[a]] := Power[a, -1];
  (* MAURICIO: FEB 2022 BEGIN
     most properties of inv now derive from Power *)
  (* 
    ( * commutative inverse * )
    inv[a_?CommutativeQ] := a^(-1);
    inv[a_?NumberQ] := 1/a;

    ( * inv is idempotent * )
    inv[inv[a_]] := a;

    ( * tp threads over Times * )
    inv[a_Times] := inv /@ a;

    ( * inv simplifications * )
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
  *)
  (* MAURICIO: FEB 2022 END *)

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

  (* Option to control distributive property *)
  Clear[$inv];
  Options[$inv] = {Distribute -> False};
  
  inv/:SetOptions[inv, OptionsPattern[$inv]] :=
      If[ OptionValue[Distribute]
         ,
          (* install distributive rule *)
          NonCommutativeMultiply /: Power[NonCommutativeMultiply[a_,b_,c___],-1] := 
              NonCommutativeMultiply[inv[NonCommutativeMultiply[b,c]], 
                                     inv[a]];
          SetOptions[$inv, Distribute -> True];
         ,
          Quiet[
            (* remove distributive rule *)
            NonCommutativeMultiply /: Power[NonCommutativeMultiply[a_,b_,c___],-1] =. ;
            SetOptions[$inv, Distribute -> False];
           ,
            {TagUnset::norep, Unset::norep}  
         ];
      ];

  inv/:Options[inv] := Options[$inv];

  (* pretty tp *)
  If[ValueQ[Global`T], 
     Message[TDefined::Warning];
     Global`T =. 
  ];
  Global`T /: Power[a_?NonCommutativeQ, Global`T] := tp[a];
  Protect[Global`T];

  (* pretty aj *)
  SuperStar[a_] := aj[a];

  (* pretty co *)
  OverBar[a_] := co[a];

  (* NCValueQ *)
  (* BEGIN MAURICIO
      This is needed due to an update on the behavior of ValueQ in v.12.2
     END MAURICIO *)
  If[TrueQ[$VersionNumber >= 12.2],
    NCValueQ[x_] := ValueQ[x, Method->"TrialEvaluation"],
    NCValueQ[x_] := ValueQ[x]
  ];
  SetAttributes[NCValueQ, HoldAll];
   
  (* SetCommutingOperators using upvalues *)
  SetCommutingOperators[a_, b_] := (
    If[ NCValueQ[NonCommutativeMultiply[c___, a, b, d___]]
       ,
        Message[SetCommutingOperators::AlreadyDefined, b, a];
        UnsetCommutingOperators[b, a];
    ];
    (* define commutation rule *)
    (c___ ** b ** a ** d___ ^:= c ** a ** b ** d)
  ) /; a =!= b;
  
  UnsetCommutingOperators[a_,b_] := Block[{},
    If[ NCValueQ[c___ ** a ** b ** d___]
       ,
        a /: c___ ** a ** b ** d___ =. ;
        b /: c___ ** a ** b ** d___ =. ;
       ,
        If[ NCValueQ[c___ ** b ** a ** d___]
           ,
            a /: c___ ** b ** a ** d___ =. ;
            b /: c___ ** b ** a ** d___ =.
        ];
    ];
  ];
  
  CommutingOperatorsQ[a_,a_] := True;
  CommutingOperatorsQ[a_,b_?CommutativeQ] := True;
  CommutingOperatorsQ[a_?CommutativeQ,b_] := True;
  
  CommutingOperatorsQ[a_,b_] := 
    NCValueQ[NonCommutativeMultiply[c___, a, b, d___]] ||
    NCValueQ[NonCommutativeMultiply[c___, b, a, d___]];
  
  (* Aliases *)
  SNC = SetNonCommutative;
  NCExpand = ExpandNonCommutativeMultiply;
  NCE = ExpandNonCommutativeMultiply;
  
End[]

EndPackage[]
