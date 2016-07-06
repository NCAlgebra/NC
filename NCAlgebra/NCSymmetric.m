(* :Title: 	NCSymmetric *)

(* :Author: 	mauricio *)

(* :Context: 	NCSymmetric` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCSymmetric`",
              "NCOptions`",
              "NonCommutativeMultiply`",
              "NCMatMult`",
              "NCUtil`" ];

Clear[NCSymmetricQ, NCSymmetricTest, NCSymmetricPart];
      
Get["NCSymmetric.usage"];

NCSymmetricQ::SymmetricVariables =
"The variable(s) `1` was(were) assumed symmetric";
NCSymmetricPart::notSymmetric = "Expression is not symmetric";

Options[NCSymmetricTest] = {
  SymmetricVariables -> {},
  ExcludeVariables -> {},
  Strict -> True
};

Begin[ "`Private`" ]

  (* NCSymmetricTest *)
  
  Clear[NCSymmetricTestAux];
  NCSymmetricTestAux[exp_, diff_, zero_, opts:OptionsPattern[{}]] := Module[
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
      Print["diff = ", diff];
      Print["zero = ", zero];
      Print["symmetricVars = ", symmetricVars];
      Print["excludeVars = ", excludeVars];
      *)

      (* easy return *)
      If[ diff === zero, Return[{True, {}}] ];
      
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
      Print["diff = ", diff];
      Print["vars = ", vars];
      Print["tpVars = ", tpVars];
      Print["tpDiffVars = ", tpDiffVars];
      Print["symVars = ", symVars];
      *)

      (* There are no potentially symmetric variables left *)
      If[symVars === {}, Return[{False, {}}] ];
      
      symRule =  Thread[Map[tp,symVars] -> symVars];

      (* Print[symRule]; *)
      
      If [ (diff /. symRule) =!= zero,
         (* Expression is not symmetric *)
         Return[{False, {}}]
      ];
      
      (* Warm user of symmetric assumptions *)
      Message[NCSymmetricQ::SymmetricVariables, 
              ToString[First[symVars]] <>
                StringJoin @@ Map[(", " <> ToString[#])&, Rest[symVars]]];
      
      Return[{True, symVars}];
  ];
  
  NCSymmetricTest[exp_, opts:OptionsPattern[{}]] :=
    NCSymmetricTestAux[exp, 
                       ExpandNonCommutativeMultiply[exp - tp[exp]],
                       0, opts];
      
  NCSymmetricTest[mat_?MatrixQ, opts:OptionsPattern[{}]] := 
    NCSymmetricTestAux[
        mat, 
        ExpandNonCommutativeMultiply[mat - tpMat[mat]], 
        ConstantArray[0, Dimensions[mat]], opts];

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
    
End[]

EndPackage[]
