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
      SetNonCommutativeHold,
      SetCommutingOperators,
      UnsetCommutingOperators,
      CommutingOperatorsQ,
      ExpandNonCommutativeMultiply,
      BeginCommuteEverything, EndCommuteEverything, 
      CommuteEverything, Commutative,
      SNC, NCExpand, NCE];

CommutativeQ::Commutative = "Tried to set the `1` \"`2`\" to be commutative.";
CommutativeQ::NonCommutative = "Tried to set the `1` \"`2`\" to be noncommutative.";

CommutativeQ::CommutativeSubscript = "Tried to set the subscript \"`2`\" of symbol \"`1`\" to be commutative. Please set the symbol \"`1`\" to be commutative instead.";
CommutativeQ::NonCommutativeSubscript = "Tried to set the subscript \"`2`\" of symbol \"`1`\" to be noncommutative. Please set the symbol \"`1`\" to be noncommutative instead.";

CommuteEverything::Warning = "Commute everything set the variable(s) \
`1` to be commutative. Use EndCommuteEverything[] to set them back as \
noncommutative.";

TDefined::Warning = "Symbol T has definitions associated with it \
that will be cleared by NCAlgebra."

SetCommutingOperators::AlreadyDefined = "Symbols `1` and `2` were already defined commutative. Replacing existing rule."

Get["NonCommutativeMultiply.usage"];

Begin[ "`Private`" ]

  (* Idea from 
     http://mathematica.stackexchange.com/questions/10306/how-to- 
            properly-handle-mutual-imports-of-multiple-packages 
     to take care of mutal import of NCUtil` 
  *)
  Needs["NCUtil`"];

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
  DoSetNonCommutative[x_Symbol] := (x /: HoldPattern[CommutativeQ[x]] = False);
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
  DoSetCommutative[x_Symbol] := CommutativeQ[x] ^= True;
  DoSetCommutative[x_List] := SetCommutative /@ x;
  DoSetCommutative[Subscript[x_Symbol, y__]] := 
    Message[CommutativeQ::CommutativeSubscript, x, y];
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
  aj[a_NonCommutativeMultiply] := aj /@ Reverse[a];

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

  (* Option to control distributive property *)
  Clear[$inv];
  Options[$inv] = {Distribute -> False};
  
  inv/:SetOptions[inv, OptionsPattern[$inv]] :=
      If[ OptionValue[Distribute]
         ,
          (* install distributive rule *)
          inv/:inv[NonCommutativeMultiply[a_,b_,c___]] := 
              NonCommutativeMultiply[inv[NonCommutativeMultiply[b,c]], 
                                     inv[a]];
          SetOptions[$inv, Distribute -> True];
         ,
          Quiet[
            (* remove distributive rule *)
            inv/:inv[NonCommutativeMultiply[a_,b_,c___]] =. ;
            SetOptions[$inv, Distribute -> False];
           ,
            {TagUnset::norep, Unset::norep}  
         ];
      ];

  inv/:Options[inv] := Options[$inv];
      
  (* Power *)
  
  (* Expand monomial rules *)
  Unprotect[Power];
  
  Power[b_?NonCommutativeQ, 1/2] := rt[b];

  Power[b_?NonCommutativeQ, c_Integer?Positive] := 
    Apply[NonCommutativeMultiply, Table[b, {c}]];

  Power[b_?NonCommutativeQ, c_Integer?Negative] := 
    inv[Apply[NonCommutativeMultiply, Table[b, {-c}]]];

  (* pretty tp *)
  If[ValueQ[Global`T], 
     Message[TDefined::Warning];
     Global`T =. 
  ];
  Protect[Global`T];
  Power[a_, Global`T] := tp[a];

  Protect[Power];

  (* pretty aj *)
  SuperStar[a_] := aj[a];

  (* pretty inv *)
  Superscript[a_, -1] := inv[a];

  (* pretty co *)
  OverBar[a_] := co[a];

  (* SetCommutingOperators using upvalues *)
  SetCommutingOperators[a_, b_] := (
    If[ ValueQ[NonCommutativeMultiply[c___, a, b, d___]]
       ,
        Message[SetCommutingOperators::AlreadyDefined, b, a];
        UnsetCommutingOperators[b, a];
    ];
    (* define commutation rule *)
    (c___ ** b ** a ** d___ ^:= c ** a ** b ** d)
  ) /; a =!= b;
  
  UnsetCommutingOperators[a_,b_] := Block[{},
    If[ ValueQ[c___ ** a ** b ** d___]
       ,
        a /: c___ ** a ** b ** d___ =. ;
        b /: c___ ** a ** b ** d___ =. ;
       ,
        If[ ValueQ[c___ ** b ** a ** d___]
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
    ValueQ[NonCommutativeMultiply[c___, a, b, d___]] ||
    ValueQ[NonCommutativeMultiply[c___, b, a, d___]];
  
  (* Aliases *)
  SNC = SetNonCommutative;
  NCExpand = ExpandNonCommutativeMultiply;
  NCE = ExpandNonCommutativeMultiply;
  
End[]

EndPackage[]
