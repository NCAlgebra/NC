(* :Title: 	NCPolynomial.m *)

(* :Authors: 	mauricio *)

(* :Context: 	NCPolynomial` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCPolynomial`",
              "NCMatMult`",
              "NCUtil`",
              "NCPolyInterface`",
	      "NonCommutativeMultiply`" ];

Clear[NCPolynomial, 
      NCToNCPolynomial, NCPolynomialToNC, NCRationalToNCPolynomial,
      NCPCoefficients,
      NCPTermsOfDegree, NCPTermsOfTotalDegree, 
      NCPTermsToNC, NCPDecompose, NCPSort, 
      NCPCompatibleQ, NCPSameVariablesQ, NCPMatrixQ,
      NCPPlus,
      NCPDegree, NCPMonomialDegree, 
      NCPLinearQ, NCPQuadraticQ,
      NCPNormalize];

Get["NCPolynomial.usage"];

NCPolynomial::NotPolynomial = "Expression is not an nc polynomial.";
NCPolynomial::VarNotSymbol = "All variables must be Symbols.";

Begin[ "`Private`" ]

  (* NCConsecutiveTermss *)
  
  Clear[NCConsecutiveTerms];
  NCConsecutiveTerms[(tp|aj)[x_], (tp|aj)[y_], vars_] := 
    MemberQ[vars, x] == MemberQ[vars, y];
  NCConsecutiveTerms[(tp|aj)[x_], y_, vars_] := 
    MemberQ[vars, x] == MemberQ[vars, y];
  NCConsecutiveTerms[x_, (tp|aj)[y_], vars_] := 
    MemberQ[vars, x] == MemberQ[vars, y];
  NCConsecutiveTerms[x_, y_, vars_] := 
    MemberQ[vars, x] == MemberQ[vars, y];

  (* NCSplitMonomials *)

  Clear[NCSplitMonomialAux];
  NCSplitMonomialAux[m_Symbol, vars_List] := {1,1,m,1};
  NCSplitMonomialAux[a_?CommutativeQ m_Symbol, vars_List] := {a,1,m,1};
  NCSplitMonomialAux[tp[m_Symbol], vars_List] := {1,1,tp[m],1};
  NCSplitMonomialAux[a_?CommutativeQ tp[m_Symbol], vars_List] := {a,1,tp[m],1};
  NCSplitMonomialAux[aj[m_Symbol], vars_List] := {1,1,aj[m],1};
  NCSplitMonomialAux[a_?CommutativeQ aj[m_Symbol], vars_List] := {a,1,aj[m],1};
  NCSplitMonomialAux[m_NonCommutativeMultiply, vars_List] := Module[
    {tmp},

    (* Split knowns from unknowns *)
    tmp = Split[List@@m, NCConsecutiveTerms[#1,#2,vars]&];

    (* Print["tmp1 = ", tmp]; *)
      
    (* Prepend a if first term is unknown *)
    If[ NCConsecutiveTerms[vars[[1]], tmp[[1,1]], vars]
        ,
        PrependTo[tmp, {1}];
        ,
        tmp = Prepend[Rest[tmp], 1 First[tmp]];
    ];

    (* Print["tmp2 = ", tmp]; *)

    (* Append 1 if last term is unknown *)
    If[ NCConsecutiveTerms[vars[[1]], tmp[[-1,1]], vars],
        AppendTo[tmp, {1}];
    ];

    (* Print["tmp = ", tmp]; *)

    tmp = Apply[NonCommutativeMultiply, tmp, {1}];

    (* Print["tmp = ", tmp]; *)

    Return[Prepend[tmp, 1]];
      
  ];
  NCSplitMonomialAux[a_?CommutativeQ m_NonCommutativeMultiply, vars_List] :=
    Prepend[Rest[NCSplitMonomialAux[m, vars]], a];
  NCSplitMonomialAux[__] := (Message[NCPolynomial::NotPolynomial]; {$Failed,$Failed,$Failed,$Failed});
          
  Clear[NCSplitMonomials];
  NCSplitMonomials[m_Plus, vars_List] := 
    Map[NCSplitMonomialAux[#,vars]&, List@@m];
  NCSplitMonomials[m_, vars_List] := {NCSplitMonomialAux[m,vars]};

  (* NCPPlus *)
  
  NCPPlus[pp__NCPolynomial?NCPCompatibleQ] := Block[
    {p = {pp}},
    Return[
      NCPolynomial[Plus @@ p[[All,1]],
                   Merge[p[[All,2]], Flatten[Join[#], 1]&],
                   p[[1,3]] ]];
  ];
  

  (* NCToNCPolynomial *)

  Clear[NCPVectorizeAux];
  NCPVectorizeAux[x_,left_,right_] := 
    ReplacePart[x, {2 -> left x[[2]], Length[x] -> right Last[x]}];
  
  Clear[NCPVectorize];
  NCPVectorize[p_NCPolynomial, {m_, n_}, {i_, j_}] := Module[
    {left, right, tmp},

    (*
    Print["(m, n) = (", m, ",", n, ")"];
    Print["p(", i, ",", j, ") = ", p];
    *)
      
    left = SparseArray[{i,1} -> 1, {m,1}];
    right = SparseArray[{1,j} -> 1, {1,n}];

    (*
    Print["left = ", Normal[left]];
    Print["right = ", Normal[right]];
    *)
    
    Return[NCPolynomial[
               SparseArray[(left p[[1]]) . right],
               Map[Map[(NCPVectorizeAux[#, left, right]&), #, {1}]&, p[[2]]],
               p[[3]] ]];

  ];
  
  NCToNCPolynomial[mat_?MatrixQ, vars_List] := Module[
    {tmp},

    (* Convert entries *)
    tmp = Map[NCToNCPolynomial[#, vars] &, mat, {2}];

    (* Print["tmp = ", tmp]; *)
    
    (* Vectorize polys *)
    {m,n} = Dimensions[mat];
    tmp = MapIndexed[NCPVectorize[#1, {m,n}, #2]&, tmp, {2}];

    (* Print["tmp2 = ", tmp]; *)
      
    Return[NCPPlus @@ Flatten[tmp]];
     
  ];
  
  NCToNCPolynomial[poly_] := 
      NCToNCPolynomial[poly, NCVariables[poly]];

  NCToNCPolynomial[poly_, vars_List] := Module[
      {p, m0},

      (* Make sure vars is a list of Symbols *)
      If [ Not[MatchQ[vars, {___Symbol}]],
          Message[NCPolynomial::VarNotSymbol];
          Return[$Failed];
      ];
      
      (* Independent term is easy *)
      Quiet[
        Check[
          m0 = poly /. Thread[vars -> 0];
          ,
          Message[NCPolynomial::NotPolynomial];
          Return[$Failed];
          ,
          {Power::infy,Infinity::indet}
        ];
        ,
        {Power::infy,Infinity::indet}
      ];
          
      (* What's left? *)
      p = poly - m0;

      (* Expand *)
      p = ExpandNonCommutativeMultiply[p];

      (* Print["p1 = ", p]; *)

      If [PossibleZeroQ[p]
          ,

          p = <||>;

          ,
          
          (* Split monomials *)
          Check[ 
                 p = NCSplitMonomials[p, vars];
                ,
                 Return[$Failed];
                ,
                 NCPolynomial::NotPolynomial
          ];
              
          (* Print["p2 = ", p]; *)

          (* Separate knowns from unknowns *)
          p = Merge[Apply[Rule, 
                          Transpose[{Map[Part[#,3;;;;2]&, p], 
                          Map[Prepend[Part[#,2;;;;2], Part[#,1]]&, p]}],
                              {1}], Join];

      ];
 
      (* Print["p3 = ", p]; *)

      (* Check for rational or other terms *)
      If[ Not[And @@ Map[FreeQ[Values[p], #]&, vars]],
          Message[NCPolynomial::NotPolynomial];
          Return[$Failed];
      ];
      
      Return[NCPolynomial[m0, p, vars]];
      
  ];

  (* NCRationalToNCPolynomial *)

  NCRationalToNCPolynomial[rat_] := 
      NCRationalToNCPolynomial[rat, NCVariables[rat]];

  NCRationalToNCPolynomial[rat_, vars_List] := Module[
      {invs, ratVars, ruleRat, ruleRatRev, poly},
    
      (* Grab inv's *)
      invs = NCGrabFunctions[rat, inv];
      
      (* Print["invs = ", invs]; *)
      
      (* Detect inverses which do not depend on the variables and
         exclude them *)
      invs = invs[[Flatten[Position[Apply[And, 
                           Outer[FreeQ[#1, #2]&, invs, vars], {1}], False]]]];
      
      (* Print["invs = ", invs]; *)

      (* Create one new variable for each inv *)
      ratVars = Table[Unique["rat"], Length[invs]];
      SetNonCommutative[ratVars];

      (* Print["ratVars = ", ratVars]; *)
      
      (* Replace inv's with ratVars *)
      ruleRat = Thread[invs -> ratVars];
      poly = rat //. ruleRat;

      (* Print["ruleRat = ", ruleRat]; *)
      (* Print["poly = ", poly]; *)

      ruleRatRev = Map[Map[Function[x,x//.ruleRat],#,{2}]&, Map[Reverse, ruleRat]];

      (* Print["ruleRatRev = ", ruleRatRev]; *)

      Return[{NCToNCPolynomial[poly, Join[vars, ratVars]], 
              ratVars,
              ruleRatRev}];

  ];
      
  (* NCPCoefficients *)
   
  NCPCoefficients[p_NCPolynomial, m_] := Lookup[p[[2]], Key[m], {}];

  (* NCPTermsToNC *)
  
  Clear[NCPTermsToNCProductAux];
  NCPTermsToNCProductAux[scalar_, left_?MatrixQ, middle_?MatrixQ, right__] := 
    scalar * MatMult[left, middle, right];

  NCPTermsToNCProductAux[scalar_, left_?MatrixQ, middle__, right_] := 
    scalar * MatMult[left, {{NonCommutativeMultiply[middle]}}, right];

  NCPTermsToNCProductAux[scalar_, terms___] := 
    scalar * NonCommutativeMultiply[terms];
    
  Clear[NCPTermsToNCAux];
  NCPTermsToNCAux[m_, coeffs_] := 
    Map[Prepend[Riffle[Rest[#1],m], First[#1]]&, coeffs];

  NCPTermsToNC[terms_] := 
     Total[Apply[NCPTermsToNCProductAux,
          Flatten[KeyValueMap[NCPTermsToNCAux, terms], 1], {1}]];

  (* NCPolynomialToNC *)

  NCPolynomialToNC[p_NCPolynomial] := p[[1]] + NCPTermsToNC[p[[2]]];

  NCPolynomialToNC[p_NCPolynomial] := p[[1]] + 
      ArrayFlatten[NCMatrixExpand[NCPTermsToNC[p[[2]]]]] /; MatrixQ[p[[1]]];
  
  (* NCPDecompose *)
   
  Clear[NCPDecomposeAux];
  NCPDecomposeAux[p_NCPolynomial] := 
    Merge[
      Thread[NCPMonomialDegree[p] -> 
             Apply[Plus, 
                   Apply[NonCommutativeMultiply,
                         KeyValueMap[NCPTermsToNCAux, p[[2]]], {2}], {1}]]
      , Total];

  NCPDecompose[p_NCPolynomial] := Block[
     {tmp = NCPDecomposeAux[p]},
     Return[ If[ p[[1]] === 0, tmp,
             Append[tmp, 
                    ConstantArray[0, Length[p[[3]]]] -> p[[1]]]] ];
  ];
  
  (* NCPSort *)
  
  NCPSort[p_NCPolynomial] := 
     Prepend[Apply[NonCommutativeMultiply, 
                   Flatten[KeyValueMap[NCPTermsToNCAux, p[[2]]], 1],
                   {1}], p[[1]]];
  
  (* NCPDegree *)

  Clear[NCPDegreeAux];
  NCPDegreeAux[m_NonCommutativeMultiply, vars_] := Block[
     {tmp = m /. {tp[x_] -> x, aj[x_] -> x}},
     Map[Count[tmp, #]&, vars]
  ];
  NCPDegreeAux[m_Symbol, vars_] := Exponent[vars, m];
  NCPDegreeAux[(tp|aj)[m_Symbol], vars_] := Exponent[vars, m];
  
  NCPMonomialDegree[p_NCPolynomial] := 
    Map[NCPDegreeAux[#,p[[3]]]&,
        Apply[NonCommutativeMultiply, Keys[p[[2]]], {1}]];

  NCPDegree[p_NCPolynomial] := 
     Max[Apply[Plus, NCPMonomialDegree[p], {1}],0];
    
  
  (* NCPTermsOfDegree *)
  
  NCPTermsOfDegreeAux[ms_, vars_, degree_] :=
    (Plus @@ Map[NCPDegreeAux[#, vars]&, ms]) === degree;
    
  NCPTermsOfDegree[p_NCPolynomial, degree_] :=
    If [degree === ConstantArray[0, Length[p[[3]]]]
        , 
        Association[{} -> {{p[[1]]}}]
        ,
        KeySelect[p[[2]], 
              NCPTermsOfDegreeAux[#, p[[3]], degree]&]
    ];

  (* NCPTermsOfTotalDegree *)
  
  NCPTermsOfTotalDegreeAux[ms_, vars_, degree_] :=
    Total[Plus @@ Map[NCPDegreeAux[#, vars]&, ms]] === degree;
    
  NCPTermsOfTotalDegree[p_NCPolynomial, degree_] :=
    If [degree === 0
        , 
        Association[{} -> {{p[[1]]}}]
        ,
        KeySelect[p[[2]], 
              NCPTermsOfTotalDegreeAux[#, p[[3]], degree]&]
    ];
    
  (* NCPLinearQ *)
    
  NCPLinearQ[p_NCPolynomial] := (NCPDegree[p] <= 1);

  (* NCPQuadraticQ *)
    
  NCPQuadraticQ[p_NCPolynomial] := (NCPDegree[p] <= 2);

  (* NCPCompatibleQ *)
  
  NCPCompatibleQ[pp__NCPolynomial] := Block[
    {p = {pp}},
    Return[And @@ 
           Map[And[#[[3]] === p[[1,3]],
               Dimensions[#[[1]]] === Dimensions[p[[1,1]]]]&, Rest[p]]];
  ];

  (* NCPSameVariableQ *)
  
  NCPSameVariablesQ[pp__NCPolynomial] := Block[
    {p = {pp}},
    Return[And @@ Map[(#[[3]] === p[[1,3]])&, Rest[p]]];
  ];

  (* NCPMatrixQ *)

  NCPMatrixQ[p_NCPolynomial] := MatrixQ[p[[1]]];
  
  (* NCPNormalize *)
  
  Clear[NCPNormalizeAux];
  NCPNormalizeAux[l_] := Module[
      {list, pos, scalars},
      
      pos = Flatten[Position[Rest[l], 
                             __?CommutativeQ _?NonCommutativeQ, {1}]];
      scalars = Cases[Rest[l], 
                      a__?CommutativeQ _?NonCommutativeQ -> a];

      (*
      Print["pos = ", pos];
      Print["scalars = ", scalars];
      *)

      list = l;
      (* Print["list = ", list]; *)
      
      (* divide by scalars *)
      list[[1 + pos]] /= scalars;

      (* multiply scalar term *)
      list[[1]] *= Times @@ scalars;
      
      (* Print["list = ", list]; *)
      
      Return[list];
  ];
   
  NCPNormalize[p_NCPolynomial] := 
     NCPolynomial[p[[1]], Map[NCPNormalizeAux, p[[2]], {2}], p[[3]]];

End[]

EndPackage[]
