(* :Title: 	NCSelfAdjoint *)

(* :Author: 	mauricio *)

(* :Context: 	NCSelfAdjoint` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCSelfAdjoint`",
              "NCOptions`",
              "NonCommutativeMultiply`",
              "NCDot`",
              "NCUtil`" ]

Clear[NCSymmetricQ, NCSymmetricTest, NCSymmetricPart,
      NCSelfAdjointQ, NCSelfAdjointTest];
      
Get["NCSelfAdjoint.usage"];

NCSymmetricQ::SymmetricVariables =
"The variable(s) `1` was(were) assumed symmetric";
NCSymmetricPart::notSymmetric = "Expression is not symmetric";

NCSelfAdjointQ::SelfAdjointVariables =
"The variable(s) `1` was(were) assumed self-adjoint";

Options[NCSymmetricTest] = {
  SymmetricVariables -> {},
  ExcludeVariables -> {},
  Strict -> True
};

Options[NCSelfAdjointTest] = {
  SelfAdjointVariables -> {},
  SymmetricVariables -> {},
  ExcludeVariables -> {},
  Strict -> True
};

Begin[ "`Private`" ]

  (* NCSymmetricTest *)
  Clear[AuxPossibleZeroQ];
  AuxPossibleZeroQ[exp_?VectorQ] := VectorQ[exp,PossibleZeroQ];
  AuxPossibleZeroQ[exp_?MatrixQ] := MatrixQ[exp,PossibleZeroQ];
  AuxPossibleZeroQ[exp_] := PossibleZeroQ[exp];
  
  Clear[NCSymmetricTestAux];
  NCSymmetricTestAux[exp_, diff_, opts:OptionsPattern[{}]] := Module[
      {vars, tpVars, tpDiffVars, symVars, symRule, 
       options, symmetricVars, excludeVars, strict},
      
      (* process options *)

      options = Flatten[{opts}];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCSymmetricTest, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCSymmetricTest, ExcludeVariables];

      strict = Strict 
 	    /. options
	    /. Options[NCSymmetricTest, Strict];

      (*
      Print["----"];
      Print["options = ", options];
      Print["diff = ", Normal[diff]];
      Print["symmetricVars = ", symmetricVars];
      Print["excludeVars = ", excludeVars];
      *)

      (* easy return *)
      If[ AuxPossibleZeroQ[diff], Return[{True, {}}] ];
      
      (* check for possible symmetric variables *)
      vars = NCGrabSymbols[exp];

      (* Print["vars = ", vars]; *)

      (* exclude all vars? *)
      excludeVars = If [excludeVars === All
                        , 
                        vars
                        ,
                        Flatten[List[excludeVars]]
                       ];
          
      (* all variables symmetric? *)
      (* symmetric vars have priority *)
      If [symmetricVars === All
          ,  
          symmetricVars = vars;
          excludeVars = {};
          ,
          symmetricVars = Flatten[List[symmetricVars]];
          excludeVars = Complement[excludeVars, symmetricVars];
      ];

      (*
      Print["ExcludeVariables = ", excludeVars];
      Print["SymmetricVariables = ", symmetricVars];
      *)

      tpVars = Map[tp,NCGrabSymbols[exp, tp]];
      tpDiffVars = Map[tp,NCGrabSymbols[diff, tp]];
      symVars = Union[
        If[ strict
            , 
            Complement[tpDiffVars, tpVars, excludeVars]
            ,
            Complement[tpDiffVars, excludeVars]
        ],
        symmetricVars];

      (*
      Print["exp = ", exp];
      Print["diff = ", Normal[diff]];
      Print["vars = ", vars];
      Print["tpVars = ", tpVars];
      Print["tpDiffVars = ", tpDiffVars];
      Print["symVars = ", symVars];
      *)

      (* There are no potentially symmetric variables left *)
      If[symVars === {}, Return[{False, {}}] ];
      
      symRule =  Thread[Map[tp,symVars] -> symVars];

      (* Print[symRule]; *)
      
      If [ !AuxPossibleZeroQ[(diff /. symRule)],
         (* Expression is not symmetric *)
         Return[{False, {}}]
      ];
      
      (* Warn user of symmetric assumptions *)
      Message[NCSymmetricQ::SymmetricVariables, 
              ToString[First[symVars]] <>
                StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];
      
      Return[{True, symVars}];
  ];
  
  NCSymmetricTest[exp_, opts:OptionsPattern[{}]] :=
    NCSymmetricTestAux[exp, 
                       ExpandNonCommutativeMultiply[exp - tp[exp]],
                       opts];
      
  NCSymmetricTest[mat_SparseArray, opts:OptionsPattern[{}]] := 
    NCSymmetricTest[Normal[mat], opts];

  NCSymmetricTest[mat_?MatrixQ, opts:OptionsPattern[{}]] := 
    NCSymmetricTestAux[
        mat, 
        ExpandNonCommutativeMultiply[mat - tpMat[mat]], 
        opts];

  (* NCSymmetricQ *)
 
  NCSymmetricQ[exp_, opts:OptionsPattern[{}]] := 
    First[NCSymmetricTest[exp, opts]];

  (* NCSymmetricPart *)
  Clear[CanonizeEntry];
  CanonizeEntry[exp_, symRule_] := Module[
    {tmp},
      
    tmp = tp[exp] /. symRule;
    Return[If[OrderedQ[{exp, tmp}], exp, tmp]];
  ];

  Clear[NCSymmetricPartAux];
  NCSymmetricPartAux[exp_?MatrixQ, symRule_] := Module[
     {diag, low},
      
     (* Diagonal *)
     diag = Map[NCSymmetricPartAux[#, symRule]&, Tr[exp, List]];

     (* Lower triangular part *)
     low = exp SparseArray[{i_,j_} /; j < i -> 1, Dimensions[exp]];
     
     Return[DiagonalMatrix[diag] + 2 low];
  ];

  NCSymmetricPartAux[exp_Plus, symRule_] := Module[
    {list},
    
    (* make into list *)
    list = Map[CanonizeEntry[#,symRule]&, List @@ exp];
    (* Print["list = ", list]; *)
      
    Return[Plus @@ list];
  ];
  NCSymmetricPartAux[exp_, symRule_] := exp;
  
  NCSymmetricPart[exp_, opts:OptionsPattern[{}]] := Module[
      {options, 
       symmetricVars, excludeVars,
       isSymmetric, symVars,
       tmp},
      
      (* process options *)

      options = Flatten[{opts}];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCSymmetricTest, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCSymmetricTest, ExcludeVariables];
      
      (* is Symmetric *)
      {isSymmetric, symVars} = NCSymmetricTest[exp, opts];
      If[ !isSymmetric, 
          Message[NCSymmetricPart::notSymmetric];
          Return[{$Failed, {}}];
      ];
      
      (* Auxiliary rules *)
      symRule = Map[tp[#] -> # &, symVars];
      
      Return[{NCSymmetricPartAux[exp, symRule], symVars}];
      
  ];

  (* NCSelfAdjointQ *)
  
  Clear[NCSelfAdjointTestAux];
  NCSelfAdjointTestAux[exp_, diff_, opts:OptionsPattern[{}]] := Module[
      {vars, ajVars, ajDiffVars, selfAdjVars, selfAdjRule, ajCoVars, symVars, 
       options, symmetricVars, excludeVars, strict},
      
      (* process options *)

      options = Flatten[{opts}];

      selfAdjointVars = SelfAdjointVariables 
 	    /. options
	    /. Options[NCSelfAdjointTest, SelfAdjointVariables];

      symmetricVars = SymmetricVariables 
 	    /. options
	    /. Options[NCSelfAdjointTest, SymmetricVariables];

      excludeVars = ExcludeVariables 
 	    /. options
	    /. Options[NCSelfAdjointTest, ExcludeVariables];

      strict = Strict 
 	    /. options
	    /. Options[NCSelfAdjointTest, Strict];

      (*
      Print["-----"];
      Print["options = ", options];
      Print["diff = ", diff];
      Print["selfAdjointVars = ", selfAdjointVars];
      Print["symmetricVars = ", symmetricVars];
      Print["excludeVars = ", excludeVars];
      *)
      
      (* easy return *)
      If[ AuxPossibleZeroQ[diff], Return[{True, {}, {}}] ];

      (* check for possible self-adjoint variables *)
      vars = NCGrabSymbols[exp];
      
      (* exclude all vars? *)
      excludeVars = If [excludeVars === All
                        , 
                        vars
                        ,
                        Flatten[List[excludeVars]]
                       ];
          
      (* all variables SelfAdjoint? *)
      (* SelfAdjoint vars have priority *)
      If [selfAdjointVars === All
          ,  
          selfAdjointVars = vars;
          symmetricVars = {};
          excludeVars = {};
          ,
          selfAdjointVars = Flatten[List[selfAdjointVars]];
          excludeVars = Complement[excludeVars, selfAdjointVars];
      ];

      (* all variables symmetric? *)
      (* symmetric vars have priority *)
      If [symmetricVars === All
          ,  
          symmetricVars = Complement[vars, selfAdjointVars];
          excludeVars = {};
          ,
          symmetricVars = Complement[Flatten[List[symmetricVars]], 
                                     selfAdjointVars];
          excludeVars = Complement[excludeVars, symmetricVars];
      ];

      (*
      Print["ExcludeVariables = ", excludeVars];
      Print["SelfAdjointVariables = ", selfAdjointVars];
      Print["SymmetricVariables = ", symmetricVars];
      *)

      ajVars = Map[aj,NCGrabSymbols[exp, aj]];
      ajDiffVars = Map[aj,NCGrabSymbols[diff, aj]];
      selfAdjVars = Union[
        If[ strict
            , 
            Complement[ajDiffVars, ajVars, excludeVars]
            ,
            Complement[ajDiffVars, excludeVars]
        ],
        selfAdjointVars];

      (*
      Print["exp = ", exp];
      Print["diff = ", diff];
      Print["vars = ", vars];
      Print["ajVars = ", ajVars];
      Print["ajDiffVars = ", ajDiffVars];
      Print["selfAdjVars = ", selfAdjVars];
      *)

      (* There are no potentially self-adjoint variables *)
      If[selfAdjVars === {}, Return[{False, {}, {}}]];
      
      selfAdjRule = Thread[Map[aj,selfAdjVars] -> selfAdjVars];

      (* Print["selfAdjRule = ", selfAdjRule]; *)
      
      If [ !AuxPossibleZeroQ[(diff /. selfAdjRule)],

        (* Try real assumptions *)
        ajCoVars = Union[NCGrabSymbols[exp, aj|co] /. (aj|co)[x_]->x];
        symVars = Join[Complement[Map[tp,NCGrabSymbols[exp, tp]], 
                                  ajCoVars, excludeVars], 
                       symmetricVars];
      
        (*
        Print["ajCoVars = ", ajCoVars];
        Print["symVars = ", symVars];
        *)
      
        If[symVars === {},
           (* There are no potentially symmetric variables *)
           Return[{False, {}, {}}]
        ];
      
        selfAdjVars = Complement[selfAdjVars, symVars];
      
        (* Print["selfAdjVars = ", selfAdjVars]; *)

        selfAdjRule = Join[Thread[Map[aj,selfAdjVars] -> selfAdjVars],
                           Thread[Map[aj,symVars] -> Map[tp,symVars]],
                           Thread[Map[co,symVars] -> symVars]];
      
        (* Print[selfAdjRule]; *)

        If [ !AuxPossibleZeroQ[(diff /. selfAdjRule)],
           (* Expression is not adjoint *)
           Return[{False, {}, {}}]
        ];

        (* Warn user of symmetric assumptions *)
        Message[NCSymmetricQ::SymmetricVariables, 
                ToString[First[symVars]] <>
                  StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];

      ];

      If [selfAdjVars =!= {},

         (* Warn user of adjoint assumptions *)
         Message[NCSelfAdjointQ::SelfAdjointVariables, 
                 ToString[First[selfAdjVars]] <>
                   StringJoin @@ Map[(", "<>ToString[#])&, Rest[selfAdjVars]]];
      ];

      Return[{True, selfAdjVars, symVars}];
  ];

  NCSelfAdjointTest[exp_, opts:OptionsPattern[{}]] :=
    NCSelfAdjointTestAux[exp, 
                         ExpandNonCommutativeMultiply[exp - aj[exp]],
                         opts];

  NCSelfAdjointTest[mat_SparseArray, opts:OptionsPattern[{}]] := 
    NCSelfAdjointTest[Normal[mat], opts];

  NCSelfAdjointTest[mat_?MatrixQ, opts:OptionsPattern[{}]] := 
    NCSelfAdjointTestAux[
        mat, 
        ExpandNonCommutativeMultiply[mat - ajMat[mat]], 
        opts];

  (* NCSelfAdjointQ *)
 
  NCSelfAdjointQ[exp_, opts:OptionsPattern[{}]] := 
     First[NCSelfAdjointTest[exp, opts]];
  
End[]

EndPackage[]
