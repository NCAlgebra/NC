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
NCPolynomial[rules, vars, properties] is an expanded representation \
of an nc polynomial which is better suited for certain computations.
    
The Association rules stores monomials in the following format:
\t{mon1, ..., monN} -> {scalar, term1, ..., termN+1}
where:
\tmon1, ..., monN: are nc monomials in vars;
\tscalar: contains all commutative factors; and 
\tterm1, ..., termN+1: are nc expressions on variables other than \
the ones in vars.
 
For example:
\ta**x**b - 2 x**y**c**x + a**c
is stored as:
\tNCPolynomial[<|{x}->{1,a,b},{x**y,x}->{2,1,c,1},{}->{{a**c}}|>, {x,y}]
Note that independent terms are grouped in the empty monomial {}.

NCPolynomial specific functions are prefixed with NCP, e.g. NCPDegree.
   
See also:
NCToNCPolynomial, NCPolynomialToNC.";
NCPolynomial::NotPolynomial = "Expression is not a polynomial";

Clear[NCPNormalize];
NCPNormalize::usage = "\
NCPNormalizes[p] gives a normalized version of NCPolynomial p \
where all factors that have free commutative products are \
collectd in the first scalar.";
   
Clear[NCToNCPolynomial];
NCToNCPolynomial::usage = "\
NCToNCPolynomial[p, vars] generates a representation of the \
noncommutative polynomial p which is better suited for computation.

See also:
NCPolynomial, NCPolynomialToNC.";

Clear[NCPolynomialToNC];
NCPolynomialToNC::usage = "\
NCPolynomialToNC[p] converts the NCPolynomial p back into a regular \
nc polynomial.

See also:
NCPolynomial, NCToNCPolynomial.";

Clear[NCPDegree];
NCPDegree::usage = "\
NCPDegree[p] gives the degree of the NCPolynomial p.

See also:
NCMonoomialDegree.";

Clear[NCPMonomialDegree];
NCPMonomialDegree::usage = "\
NCPDegree[p] gives the degree of all monomials in the NCPolynomial p.

See also:
NCDegree.";

Clear[NCPLinearQ];
NCPLinearQ::usage = "\
NCPLinearQ[p] gives True if the NCPolynomial p is linear.   

See also:
NCPQuadraticQ.";

Clear[NCPQuadraticQ];
NCPQuadraticQ::usage = "\
NCPQuadraticQ[p] gives True if the NCPolynomial p is quadratic.

See also:
NCPLinearQ.";

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
      
      Return[NCPolynomial[m0, p, vars]];
      
  ];

  (* NCPolynomialToNC *)

  NCPolynomialToNCAux[m_, coeffs_] := 
    Map[Prepend[Riffle[Rest[#1],m], First[#1]]&, coeffs];
  
  NCPolynomialToNC[p_NCPolynomial] := 
    p[[1]] + Plus @@ Apply[NonCommutativeMultiply,
                  Flatten[Apply[NCPolynomialToNCAux, 
                                Normal[p[[2]]], {1}], 1], {1}];

  (* NCPDegree *)

  Clear[NCPDegreeAux];
  NCPDegreeAux[m_NonCommutativeMultiply] := Length[m];
  NCPDegreeAux[m_Symbol] := 1;
  
  NCPMonomialDegree[p_NCPolynomial] := 
    Map[NCPDegreeAux,
        Apply[NonCommutativeMultiply, Keys[p[[2]]], {1}]];

  NCPDegree[p_NCPolynomial] := Max[NCPMonomialDegree[p],0];
    
  (* NCPLinearQ *)
    
  NCPLinearQ[p_NCPolynomial] := (NCPDegree[p] <= 1);

  (* NCPQuadraticQ *)
    
  NCPQuadraticQ[p_NCPolynomial] := (NCPDegree[p] <= 2);

  (* NCPNormalize *)
  
  FactorCommutative[l_] := Module[
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
     NCPolynomial[p[[1]], Map[FactorCommutative, p[[2]], {2}], p[[3]]];
   
End[]

EndPackage[]
