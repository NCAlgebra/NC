(* :Title: 	NCPolynomial.m *)

(* :Authors: 	mauricio *)

(* :Context: 	NCPolynomial` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCPolynomial`",
              "NCDot`",
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
      NCPTimes,
      NCPDot,
      NCPDegree, NCPMonomialDegree, 
      NCPLinearQ, NCPQuadraticQ,
      NCPNormalize];

Get["NCPolynomial.usage"];

NCPolynomial::NotRational = "Expression is not an nc rational.";
NCPolynomial::NotPolynomial = "Expression is not an nc polynomial.";
NCPolynomial::VarNotSymbol = "All variables must be Symbols.";
NCPolynomial::InvalidList = "Invalid list of variables.";

Begin[ "`Private`" ]

  (* Operators *)
  
  (* Times *)
  NCPolynomial /: Times[s_?CommutativeQ, p_NCPolynomial] := NCPTimes[s, p];

  (* Plus *)
  NCPolynomial /: Plus[r_?CommutativeQ, p_NCPolynomial] := 
    NCPolynomial[r + p[[1]], p[[2]], p[[3]] ];
    
  NCPolynomial /: Plus[r_NCPolynomial, s_NCPolynomial] := NCPPlus[r, s];

  (* NonCommutativeMultiply *)
  NCPolynomial /: NonCommutativeMultiply[left___, 
                                         r_NCPolynomial, s_NCPolynomial, 
                                         right___] := 
    NonCommutativeMultiply[left, NCPDot[r, s], right];
      
  NCPolynomial /: NonCommutativeMultiply[r_NCPolynomial] := r;
    
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
  NCSplitMonomialAux[m_?NCSymbolOrSubscriptQ, vars_List] := {1,1,m,1};
  NCSplitMonomialAux[a_?CommutativeQ m_?NCSymbolOrSubscriptQ, vars_List] := {a,1,m,1};
  NCSplitMonomialAux[tp[m_?NCSymbolOrSubscriptQ], vars_List] := {1,1,tp[m],1};
  NCSplitMonomialAux[a_?CommutativeQ tp[m_?NCSymbolOrSubscriptQ], vars_List] := {a,1,tp[m],1};
  NCSplitMonomialAux[aj[m_?NCSymbolOrSubscriptQ], vars_List] := {1,1,aj[m],1};
  NCSplitMonomialAux[a_?CommutativeQ aj[m_?NCSymbolOrSubscriptQ], vars_List] := {a,1,aj[m],1};
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
  Clear[SimplifyCoefficients];
  SimplifyCoefficients[{left___, {c_?PossibleZeroQ,values__}, right___}] := 
    SimplifyCoefficients[{left,right}];
  SimplifyCoefficients[{left___, {lc_,coeff__}, middle___, 
                        {rc_,coeff__}, right___}] := 
    If[ PossibleZeroQ[lc+rc], 
        SimplifyCoefficients[{left, middle, right}],
        SimplifyCoefficients[{left, {lc+rc,coeff}, middle, right}]
    ];
  SimplifyCoefficients[coeffs_] := coeffs;
  
  Clear[MergeCoefficients];
  MergeCoefficients[coeffs__] := SimplifyCoefficients[Flatten[Join[coeffs], 1]];
  
  NCPPlus[pp__NCPolynomial?NCPCompatibleQ] := Block[
    (* copy of pp is needed because of Merge *)
    {p = {pp}}, 
    Return[
      NCPolynomial[Plus @@ p[[All,1]],
                   (* Merge[p[[All,2]], Flatten[Join[#], 1]&], *)
                   DeleteCases[
                     Merge[p[[All,2]], 
                           MergeCoefficients],
                     {}
                   ],
                   p[[1,3]] ]];
  ];

  (* NCPTimes *)
  
  NCPTimes[r_?CommutativeQ, p_NCPolynomial] := 
      NCPolynomial[r p[[1]], 
                   Map[MapAt[(r #)&, #, {1}] &, p[[2]], {2}],
                   p[[3]]];

  (* NCPDot *)
  
  Clear[MapAux, ExpandMonomialsAux,MonomialMultiply];
  MapAux[x_, y_] := Map[x -> # &, y];
  ExpandMonomialsAux[p_] := Flatten[KeyValueMap[MapAux, p[[2]]], 1];

  MonomialMultiply[{l1___, l2_} -> {lc_, lval__, 1}, 
                   {r1_, r2___} -> {rc_, 1, rval__}] := 
    {l1, l2 ** r1, r2} -> {lc rc, lval, rval};
    
  MonomialMultiply[{l1___, l2_} -> {lc_, l1val__, l2val_SparseArray}, 
                   {r1_, r2___} -> {rc_, r1val__SparseArray, r2val__}] := 
    Module[
      {tmp = NCDot[l2val, r1val][[1,1]]},

      If[ CommutativeQ[tmp],
          Return[{l1, l2**r1, r2} -> {tmp lc rc, l1val, r2val}];
      ];
      Return[{l1, l2, r1, r2} -> {lc rc, l1val, tmp, r2val}];
    ];
    
  MonomialMultiply[{l__} -> {lc_, l1val__, l2val_}, 
                   {r__} -> {rc_, r1val_, r2val__}] := 
    {l, r} -> {lc rc, l1val, l2val ** r1val, r2val};

   NCPDot[l_NCPolynomial,r_NCPolynomial] := Module[
     {tmp},

     tmp = Map[SimplifyCoefficients,
               Merge[
                 Flatten[
                   Outer[MonomialMultiply, 
                         ExpandMonomialsAux[l], 
                         ExpandMonomialsAux[r]],
                   1], 
                 Join
               ]];

       
     If[ MatrixQ[l[[1]]], 

         (* Matrix coefficients *)

         tmp = NCPolynomial[ - NCDot[l[[1]], r[[1]]], tmp, l[[3]] ];

         tmp += NCPolynomial[ 
                  NCDot[l[[1]], r[[1]]],
                  Map[MapAt[NCDot[l[[1]],#]&, #, 2] &, r[[2]], {2}],
                  r[[3]]
                ];

         tmp += NCPolynomial[ 
                  NCDot[l[[1]], r[[1]]],
                  Map[MapAt[NCDot[#,r[[1]]]&, #, -1] &, l[[2]], {2}],
                  l[[3]]
                ];
         
        ,
         
         (* Scalar coefficients *)

         tmp = NCPolynomial[ - l[[1]] r[[1]], tmp, l[[3]] ];

         If[ !PossibleZeroQ[l[[1]]],
             tmp += l[[1]] r;
         ];
       
         If[ !PossibleZeroQ[r[[1]]],
             tmp += r[[1]] l;
         ];
         
     ];
       
     Return[tmp];
       
  ] /; NCPCompatibleQ[l,r];

  NCPDot[l_NCPolynomial, r_NCPolynomial, rest__NCPolynomial] := 
    NCPDot[NCPDot[l,r], rest];
  
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
  
  NCToNCPolynomial[polys_List] := 
      Map[NCToNCPolynomial, polys];
  
  NCToNCPolynomial[polys_List /; !MatrixQ[polys], vars_List] := 
      Map[NCToNCPolynomial[#, vars]&, polys]; 
      
  NCToNCPolynomial[poly_] := 
      NCToNCPolynomial[poly, NCVariables[poly]];

  NCToNCPolynomial[poly_, var:(_Symbol|Subscript[_Symbol,___])] := 
      NCToNCPolynomial[poly, {var}];
      
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
  
  NCToNCPolynomial[poly_, vars_List] := Module[
      {p, m0},

      (* Make sure vars is a list of Symbols *)
      If [ Not[MatchQ[vars, {___?NCSymbolOrSubscriptQ}]],
          Message[NCPolynomial::VarNotSymbol];
          Return[$Failed];
      ];
      
      (* repeat variables *)
      If[ Length[vars] != Length[Union[vars]],
          Message[NCPolynomial::InvalidList];
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
      
      (* Simplify Coefficients *)
      Return[NCPolynomial[m0, Map[SimplifyCoefficients, p], vars]];
      
  ];

  (* NCRationalToNCPolynomial *)

  NCRationalToNCPolynomial[rat_] := 
      NCRationalToNCPolynomial[rat, NCVariables[rat]];

  NCRationalToNCPolynomial[rat_, vars_List] := Block[
      {invs, ratVars, ruleRat, ruleRatRev, poly, retVal},
    
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

      Quiet[
        retVal = Check[
          {NCToNCPolynomial[poly, Join[vars, ratVars]], 
           ratVars,
           ruleRatRev}
         ,
          Message[NCPolynomial::NotRational];
          {$Failed, {},{}}
          ,
         NCPolynomial::NotPolynomial
        ];
       ,
        NCPolynomial::NotPolynomial
      ];
      
      Return[retVal];

  ];
      
  (* NCPCoefficients *)
   
  NCPCoefficients[p_NCPolynomial, m_] := Lookup[p[[2]], Key[m], {}];

  (* NCPTermsToNC *)
  
  Clear[NCPTermsToNCProductAux];
  NCPTermsToNCProductAux[scalar_, left_?MatrixQ, middle_?MatrixQ, right__] := 
    scalar * NCDot[left, middle, right];

  NCPTermsToNCProductAux[scalar_, left_?MatrixQ, middle__, right_] := 
    scalar * NCDot[left, {{NonCommutativeMultiply[middle]}}, right];

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
  NCPDegreeAux[m_?NCSymbolOrSubscriptQ, vars_] := Exponent[vars, m];
  NCPDegreeAux[(tp|aj)[m_?NCSymbolOrSubscriptQ], vars_] := Exponent[vars, m];
  
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
