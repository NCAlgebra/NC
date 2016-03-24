(* :Title: 	NCPolynomial.m *)

(* :Authors: 	mauricio *)

(* :Context: 	NCPolynomial` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCPolynomial`",
              "NCUtil`",
	      "NonCommutativeMultiply`" ];

Clear[NCPolynomial, 
      NCToNCPolynomial, NCPolynomialToNC, NCRationalToNCPolynomial,
      NCPCoefficients, NCPTermsOfDegree, NCPTermsOfTotalDegree, 
      NCPTermsToNC, NCPDecompose, NCPSort,
      NCPDegree, NCPMonomialDegree, NCPLinearQ, NCPQuadraticQ,
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

  (* NCToNCPolynomial *)

  NCToNCPolynomial[poly_] := 
      NCToNCPolynomial[poly, Select[NCGrabSymbols[poly], NonCommutativeQ]];

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
      NCRationalToNCPolynomial[rat, Select[NCGrabSymbols[rat], NonCommutativeQ]];

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

      (* Create one new variables for each inv *)
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
  
  Clear[NCPTermsToNCAux];
  NCPTermsToNCAux[m_, coeffs_] := 
    Map[Prepend[Riffle[Rest[#1],m], First[#1]]&, coeffs];
  
  NCPTermsToNC[terms_] := 
    Total[Apply[NonCommutativeMultiply,
                Flatten[Apply[NCPTermsToNCAux, 
                              Normal[terms], {1}], 1], {1}]];
    
  (* NCPolynomialToNC *)

  NCPolynomialToNC[p_NCPolynomial] := p[[1]] + NCPTermsToNC[p[[2]]];

  (* NCPDecompose *)
   
  Clear[NCPDecomposeAux];
  NCPDecomposeAux[p_NCPolynomial] := 
    Merge[
      Thread[NCPMonomialDegree[p] -> 
             Apply[Plus, 
                   Apply[NonCommutativeMultiply,
                         Apply[NCPTermsToNCAux, 
                               Normal[p[[2]]], {1}], {2}], {1}]]
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
                   Flatten[Apply[NCPTermsToNCAux, 
                                 Normal[p[[2]]], {1}]
                          ,1], {1}], p[[1]]];
  
  (* NCPDegree *)

  Clear[NCPDegreeAux];
  NCPDegreeAux[m_NonCommutativeMultiply, vars_] := 
     Map[Count[m, #]&, vars];
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
