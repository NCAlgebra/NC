(* :Title: 	NCPolynomial.m *)

(* :Authors: 	mauricio *)

(* :Context: 	NCPolynomial` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCPolynomial`",
	      "NonCommutativeMultiply`" ];

Clear[NCPolynomial];
NCPolynomial::usage = "\
NCPolynomial[rules, vars] is an expanded representation of an \
nc polynomial which is better suited for computation.
    
The Association rules stores monomials in the following format:
\t{mon1, ..., monN} -> {scalar, term1, ..., termN+1}
where:
\tmon1, ..., monN: are nc monomials in vars;
\tscalar: contains all commutative factors; and 
\tterm1, ..., termN+1: are nc monomomials on variables other than \
the ones in vars.
 
For example:
\ta**x**b - 2 x**y 
is stored as:
\tNCPolynomial[<|{x}->{1,a,b},{x**y}->{2,1,1}|>, {x,y}]
   
NCPolynomial specific functions are prefixed with NCP, e.g. NCPDegree.
   
See NCToNCPolynomial, NCPolynomialToNC.";
NCPolynomial::NotPolynomial = "Expression is not a polynomial";

Clear[NCToNCPolynomial];
NCToNCPolynomial::usage = "\
NCToNCPolynomial[p, vars] generates a representation of the \
noncommutative polynomial p which is better suited for computation.

See NCPolynomial, NCPolynomialToNC.";

Clear[NCPolynomialToNC];
NCPolynomialToNC::usage = "\
NCPolynomialToNC[p] converts the NCPolynomial p back into a regular \
nc polynomial.

See NCPolynomial, NCToNCPolynomial.";

Clear[NCPDegree];
NCPDegree::usage = "\
NCPDegree[p] gives the degree of the NCPolynomial p.

See NCMonoomialDegree.";

Clear[NCPMonomialDegree];
NCPMonomialDegree::usage = "\
NCPDegree[p] gives the degree of all monomials in the NCPolynomial p.

See NCDegree.";

Clear[NCPLinearQ];
NCPLinearQ::usage = "\
NCPLinearQ[p] gives True if the NCPolynomial p is linear.   

See NCPQuadraticQ.";

Clear[NCPQuadraticQ];
NCPQuadraticQ::usage = "\
NCPQuadraticQ[p] gives True if the NCPolynomial p is quadratic.

See NCPLinearQ.";

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
  NCSplitMonomialAux[m_Symbol, vars_List] := {1,1,m,1};
  NCSplitMonomialAux[a_?CommutativeQ m_Symbol, vars_List] := {a,1,m,1};
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
      
      If[ m0 =!= 0 || p === <||>,
          p = Merge[{p,<|{} -> {{m0}}|>}, Flatten[#,1]&];
      ];

      (* Print["p4 = ", p]; *)

      Return[NCPolynomial[p, vars]];
      
  ];

  (* NCPolynomialToNC *)

  NCPolynomialToNCAux[m_, coeffs_] := 
    Map[Prepend[Riffle[Rest[#1],m], First[#1]]&, coeffs];
  
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
