(* :Title: 	NCPolynomial.m *)

(* :Authors: 	mauricio *)

(* :Context: 	NCPolynomial` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCPolynomial`",
	      "NonCommutativeMultiply`" ];

NCPolynomial::NotPolynomial = "Expression is not a polynomial";

Clear[NCToNCPolynomial];
NCToNCPolynomial::usage = "";

Clear[NCPolynomialToNC];
NCPolynomialToNC::usage = "";

Clear[NCPolynomial];
NCPolynomial::usage = "";

Clear[NCPDegree];
NCPDegree::usage = "";

Clear[NCPMonomialDegree];
NCPMonomialDegree::usage = "";

Clear[NCPLinearQ];
NCPLinearQ::usage = "";

Clear[NCPQuadraticQ];
NCPQuadraticQ::usage = "";

Begin[ "`Private`" ]

  (* NCConsecutiveTerms *)
  
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
  NCSplitMonomialAux[m_Symbol, vars_List] := {1,m,1};
  NCSplitMonomialAux[a_?CommutativeQ m_Symbol, vars_List] := {a,m,1};
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

    Return[tmp];
      
  ];

  NCSplitMonomialAux[a_?CommutativeQ m_NonCommutativeMultiply,
                     vars_List] := Module[
    {tmp = NCSplitMonomialAux[m, vars] },
    Return[ Prepend[Rest[tmp], a First[tmp]] ];
  ];
          
          
  Clear[NCSplitMonomials];
  NCSplitMonomials[m_Plus, vars_List] := 
    Map[NCSplitMonomialAux[#,vars]&, List@@m];
  NCSplitMonomials[m_, vars_List] := {NCSplitMonomialAux[m,vars]};

  (* NCToNCPolynomial *)
  
  NCToNCPolynomial[poly_, vars_List] := Module[
      {p, m0},

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
          p = NCSplitMonomials[p, vars];

          (* Print["p2 = ", p]; *)

          (* Separate knowns from unknowns *)
          p = Merge[Apply[Rule, 
                      Transpose[{Map[Part[#,2;;;;2]&, p], 
                      Map[Part[#,1;;;;2]&, p]}],
                      {1}], Join];

      ];
 
      (* Print["p3 = ", p]; *)

      (* Check for rational or other terms *)
      If[ Not[And @@ Map[FreeQ[Values[p], #]&, vars]],
          Message[NCPolynomial::NotPolynomial];
          Return[$Failed];
      ];
      
      If[ m0 =!= 0 || p === <||>,
          p = Merge[{p,<|{} -> {{m0}}|>}, Flatten[#,1]&];
      ];

      (* Print["p4 = ", p]; *)

      Return[NCPolynomial[p, vars]];
      
  ];

  (* NCPolynomialToNC *)

  NCPolynomialToNCAux[m_, coeffs_] := Map[Riffle[#1,m]&, coeffs];
  
  NCPolynomialToNC[p_NCPolynomial] := 
    Plus @@ Apply[NonCommutativeMultiply,
                  Flatten[Apply[NCPolynomialToNCAux, 
                                Normal[p[[1]]], {1}], 1], {1}];

  (* NCPDegree *)

  Clear[NCPDegreeAux];
  NCPDegreeAux[m_NonCommutativeMultiply] := Length[m];
  NCPDegreeAux[m_Symbol] := 1;
  NCPDegreeAux[m_] := 0;
  
  NCPMonomialDegree[p_NCPolynomial] := 
    Map[NCPDegreeAux,
        Apply[NonCommutativeMultiply, Keys[p[[1]]], {1}]];

  NCPDegree[p_NCPolynomial] := Max[NCPMonomialDegree[p]];
    
  (* NCPLinearQ *)
    
  NCPLinearQ[p_NCPolynomial] := (NCPDegree[p] <= 1);

  (* NCPQuadraticQ *)
    
  NCPQuadraticQ[p_NCPolynomial] := (NCPDegree[p] <= 2);

End[]

EndPackage[]
