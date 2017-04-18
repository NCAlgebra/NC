(*  NCPoly.m                                                               *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPoly`",
              "MatrixDecompositions`"];

(* 
   These functions are not implemented here. 
   They are meant to be overload by your favorite implementation 
*)

Clear[NCPoly,
      NCPolyMonomial,
      NCPolyMonomialQ,
      NCPolyConvert,
      NCPolyLinearQ,
      NCPolyLexDeg,NCPolyDegLex,NCPolyDegLexGraded,
      NCPolyDisplayOrder,
      NCPolyConstant,
      NCPolyDegree,
      NCPolyLeadingTerm,
      NCPolyLeadingMonomial,
      NCPolyGetCoefficients,
      NCPolyCoefficient,
      NCPolyCoefficientArray,
      NCPolyFromCoefficientArray,
      NCPolyGetDigits,
      NCPolyGetIntegers,
      NCPolyNumberOfVariables,
      NCPolyTogether,
      NCPolyPack,
      NCPolySum,
      NCPolyProduct,
      NCPolyReduce,
      NCPolyToRule,
      NCPolyFullReduce,
      NCPolyQuotientExpand,
      NCPolyNormalize];

Clear[NCPolyHankelMatrix,
      NCPolyRealization];

(* The following generic functions are implemented here *)

Clear[NCFromDigits,
      NCIntegerDigits,
      NCDigitsToIndex,
      NCMonomialToDigits,
      NCPadAndMatch,
      NCPolyDivideDigits,
      NCPolyDivideLeading,
      NCPolyDisplay,
      NCPolyOrderType];

Get["NCPoly.usage"];

NCPoly::NotPolynomial = "Expression is not a simple nc polynomial.";
NCPoly::SizeMismatch = "Number of monomials and coefficients do not match.";
NCPoly::InvalidList = "Invalid list of variables.";
NCMonomialToDigits::InvalidSymbol = "Monomial contain symbol not present in variable list";
NCPolyCoefficientArray::InvalidDegree = "Provided degree has to be greater or equal to the polynomial degree.";
NCPolyFromCoefficientArray::InvalidDegree = "Array size does not match an integer degree.";

Begin["`Private`"];

  (* Some facilities are implemented here. 
     ATTENTION: the main driver function are not implemented. *)

  (* NCPoly Order type *)
  NCPolyOrderType[p_NCPoly] := 
    If[ Head[p[[1]]] === List
       ,
        NCPolyDegLexGraded
       ,
        NCPolyDegLex ];
     
  (* Constant Constructor *)

  NCPolyConstant[value_, n_] := 
    NCPolyMonomial[Rule[{0,0}, value], n];

  (* Operators *)

  NCPolyLinearQ[p_NCPoly] := (NCPolyDegree[p] <= 1);

  NCPolyDegree[x_] := 0;

  NCPoly /: Times[0, s_NCPoly] := 0;

  NCPoly /: Plus[r_, s_NCPoly] := 
    NCPolySum[NCPolyConstant[r, s[[1]]], s];

  NCPoly /: Plus[r_NCPoly, s_NCPoly] := NCPolySum[r, s];

  (* NonCommutativeMultiply *)
  NCPolyProduct[r_, s_NCPoly] := Times[r, s];
  NCPolyProduct[r_NCPoly, s_] := Times[s, r];

  NCPolyProduct[r_, s_, t__] := 
    NCPolyProduct[NCPolyProduct[r,s], t];

  (* NonCommutativeMultiply *)
  NCPoly /: NonCommutativeMultiply[left___, 
                                   r_NCPoly, s_NCPoly, 
                                   right___] := 
    NonCommutativeMultiply[left, NCPolyProduct[r, s], right];
    
  NCPoly /: NonCommutativeMultiply[r_NCPoly] := r;

  (* Power *)
  NCPoly /: Power[b_NCPoly, c_Integer?Positive] := 
    Apply[NCPolyProduct, Table[b, {c}]];

  NCPoly /: Power[b_NCPoly, c_Integer?Negative] := 
    inv[Apply[NCPolyProduct, Table[b, {-c}]]];
  
  Clear[QuotientExpand];
  QuotientExpand[ {c_, l_NCPoly, r_NCPoly}, g_NCPoly ] := c * NCPolyProduct[l, g, r];
  QuotientExpand[ {c_, l_,       r_NCPoly}, g_NCPoly ] := c * l * NCPolyProduct[g, r];
  QuotientExpand[ {c_, l_NCPoly, r_}, g_NCPoly ] := c * r * NCPolyProduct[l, g];
  QuotientExpand[ {c_, l_,       r_}, g_NCPoly ] := c * l * r * g;

  QuotientExpand[ {l_NCPoly, r_NCPoly}, g_NCPoly ] := NCPolyProduct[l, g, r];
  QuotientExpand[ {l_,       r_NCPoly}, g_NCPoly ] := l * NCPolyProduct[g, r];
  QuotientExpand[ {l_NCPoly, r_}, g_NCPoly ] := r * NCPolyProduct[l, g];
  QuotientExpand[ {l_,       r_}, g_NCPoly ] := r * l * g;

  NCPolyQuotientExpand[q_List, g_NCPoly] := 
    Plus @@ Map[ QuotientExpand[#, g]&, q ];

  NCPolyQuotientExpand[q_List, {g__NCPoly}] :=
   Plus @@ Map[ NCPolyQuotientExpand[Part[#,1],{g}[[Part[#,2]]]]&, q];

  NCPolyDivideDigits[{f__Integer}, {g__Integer}] := 
    Flatten[ ReplaceList[{f}, Join[{a___,g,b___}] :> {{a}, {b}}, 1], 1];

  NCPolyDivideLeading[lf_Rule, lg_Rule, base_] := 
    Flatten[
      ReplaceList[
        NCIntegerDigits[lf[[1]], base] 
       ,Join[{a___}, NCIntegerDigits[lg[[1]], base], {b___}] 
          :> { lf[[2]]/lg[[2]], 
               NCPolyMonomial[{a}, base], 
               NCPolyMonomial[{b}, base] }
       ,1
      ],
      1
    ];

  NCPolyFullReduce[{g__NCPoly}, complete_:False, debugLevel_:0] := Block[
    { r = {g}, m, qi, ri, rii, i, modified = False },

    m = Length[r];
    If[ m > 1,
      For [i = 1, i <= m, i++, 
        rii = r[[i]];
        {qi, ri} = NCPolyReduce[rii, Drop[r, {i}], complete, debugLevel];
        If [ ri =!= 0,
             If [ ri =!= rii,
               Part[r, i] = ri;
               modified = True;
             ];
            ,
             r = Delete[r, i];
             i--; m--;
             If[ m <= 1, Break[]; ];
        ];
      ];
    ];

    Return[ If [ modified, NCPolyFullReduce[r, complete, debugLevel], r] ];

  ];

  NCPolyReduce[{f_NCPoly}, {}, args__] := {f};

  NCPolyReduce[{}, args__] := {};

  NCPolyReduce[{f__NCPoly}, {g__NCPoly}, complete_:False, debugLevel_:0] := 
  Block[{ gs = {g}, fs = {f}, m, qi, ri, i },

    m = Length[fs];
    For [i = 1, i <= m, i++, 
      {qi, ri} = NCPolyReduce[fs[[i]], gs, complete, debugLevel];
      If [ ri =!= 0,
           (* If not zero reminder, update *)
           Part[fs, i] = ri;
          ,
           (* If zero reminder, remove *)
           fs = Delete[fs, i];
           i--; m--;
      ];
    ];

    Return[fs];

  ];

  NCPolyReduce[{g__NCPoly}, complete_:False, debugLevel_:0] := Block[
    { r = {g}, m, qi, ri, i },

    m = Length[r];
    If[ m > 1,
      For [i = 1, i <= m, i++, 
        {qi, ri} = NCPolyReduce[r[[i]], Drop[r, {i}], complete, debugLevel];
        If [ ri =!= 0,
             (* If not zero reminder, update *)
             Part[r, i] = ri;
            ,
             (* If zero reminder, remove *)
             r = Delete[r, i];
             i--; m--;
             If[ m <= 1, Break[]; ];
        ];
      ];
    ];

    Return[r];

  ];

  NCPolyReduce[f_NCPoly, {g__NCPoly}, complete_:False, debugLevel_:0] := Block[
    { gs = {g}, m, ff, q, qi, r, i },

    m = Length[gs];
    ff = f;
    q = {};
    i = 1;
    While [i <= m, 
      (* Reduce current dividend *)
      {qi, r} = NCPolyReduce[ff, gs[[i]], complete, debugLevel];
      If [ r =!= ff,
        (* Append to remainder *)
        AppendTo[q, {qi, i} ];
        (* If zero reminder *)
        If[ r === 0,
           (* terminate *)
           If[ debugLevel > 1, Print["no reminder, terminate"]; ];
           Break[];
          ,
           (* update dividend, go back to first term and continue *)
           ff = r;
           i = 1;
           Continue[];
        ];
      ];
      (* continue *)
      i++;
    ];

    Return[{q,r}];

  ];

  (* Auxiliary routines related to degree and integer indexing *)

  SelectDigits[p_List, {min_Integer, max_Integer}] :=
    Replace[ Map[ If[min < # <= max, #, 0]&, p ]
            ,
             {Longest[0...],x___} -> {x}
    ];

  (* From digits *)

  NCFromDigits[{}, {base__}] := 
    Table[0, {i, Length[{base}] + 1}];

  NCFromDigits[{}, base_] := 
    Table[0, {i, 2}];

  NCFromDigits[{p__List}, base_] := 
    Map[NCFromDigits[#, base]&, {p}];

  NCFromDigits[p_List, {base__Integer}] := 
    Append[ Reverse[ BinCounts[p, {Prepend[Accumulate[{base}], 0]}] ], FromDigits[p, Plus @@ {base}] ];

  (* DEG Ordered *)
  NCFromDigits[p_List, base_Integer] := 
    {Length[p], FromDigits[p, base]};

  (* IntegerDigits *)

  (* DEG Ordered *)
  NCIntegerDigits[{d_Integer, n_Integer}, 1] := 
    Table[0, d];

  NCIntegerDigits[{d_Integer, n__Integer}, {1}] := 
    Table[0, d];
              
  NCIntegerDigits[{d_Integer, n_Integer}, base_Integer] := 
    IntegerDigits[n, base, d];

  NCIntegerDigits[{d__Integer, n_Integer}, {base__Integer}] := 
    IntegerDigits[n, Plus @@ {base}, Plus @@ {d}];

  NCIntegerDigits[dn_List, base_Integer] :=
    Map[NCIntegerDigits[#, base]&, dn] /; Depth[dn] === 3;

  NCIntegerDigits[dn_List, {base__Integer}] :=
    Map[NCIntegerDigits[#, {base}]&, dn] /; Depth[dn] === 3;

  (* OCTOBER 2016: These were never used *)
  (*
  NCIntegerDigits[{d_Integer, n_Integer}, base_Integer, len_Integer] := 
    IntegerDigits[n, base, len];
  NCIntegerDigits[{d__Integer, n_Integer}, {base__Integer}, len_Integer] := 
    IntegerDigits[n, Plus @@ {base}, len];
  NCIntegerDigits[dn_List, base_Integer, len_Integer] :=
    Map[NCIntegerDigits[#, base, len]&, dn] /; Depth[dn] === 3;
  NCIntegerDigits[dn_List, {base__Integer}, len_Integer] :=
    Map[NCIntegerDigits[#, {base}, len]&, dn] /; Depth[dn] === 3;
  *)

  (* NCDigitsToIndex *)
    
  NCIntegersToIndexAux[{degree_Integer, i_Integer}, 1] := 
    degree + 1;

  NCIntegersToIndexAux[{degree_Integer, i_Integer}, n_Integer] := 
    (1 - n^degree)/(1-n) + i + 1;

  NCIntegersToIndexAux[{degrees__Integer, i_Integer}, n_Integer] := 
    (1 - n^Total[{degrees}])/(1-n) + i + 1;
              
  NCDigitsToIndex[{digits__List}, base_Integer] := 
    Map[NCDigitsToIndex[#, base]&, {digits}];

  NCDigitsToIndex[{digits__List}, base_List] := 
    Map[NCDigitsToIndex[#, base]&, {digits}];
      
  NCDigitsToIndex[digits_List, base_Integer] := Module[
    {i = NCFromDigits[digits, base]},
    NCIntegersToIndexAux[i, base]
  ];

  NCDigitsToIndex[digits_List, base_List] := Module[
    {i = NCFromDigits[digits, base]},
    NCIntegersToIndexAux[i, Total[base]]
  ];

  (* NCMonomialToDigits *)
              
  Clear[NCMonomialToDigitsAux];
  NCMonomialToDigitsAux[digits_] := 
    Flatten[digits] /; FreeQ[digits, {}];

  NCMonomialToDigitsAux[digits_] := 
    (Message[NCMonomialToDigits::InvalidSymbol]; {$Failed});
    
  NCMonomialToDigits[{}, var_List] := {};

  NCMonomialToDigits[monomial_List, var_List] :=
    NCMonomialToDigitsAux[ 
      Map[Flatten[Position[var, #]-1]&, monomial]
    ];
    
  (* Auxiliary routines for pattern matching of monomials *)

  Clear[ShiftPattern];
  ShiftPattern[g_List, i_Integer] :=
   { Join[Drop[g, i], {r___ : 1}] -> {{Take[g, i], {}}, {{}, {r}}}, 
     Join[{l___ : 1}, Drop[g, -i]] -> {{{}, Take[g, -i]}, {{l}, {}}} };

  NCPadAndMatch[g1_List, g2_List] := Block[
    { i = 1, result = {} },

    (* i = 0 *)

    (*
      Print["NCPadAndMatch"];
      Print["g1 = ", g1];
      Print["g2 = ", g2];
    *)

    result = ReplaceList[g1, Join[{l___}, g2, {r___}] -> {{l}, {r}}];

    (*
      Print["result 1 = ", result]; 
    *)

    If[ result =!= {}
       ,

        If[ Flatten[result] =!= {},

            (* BUG FIXED:
               result = {Join[{{{},{}}}, result]}; 
            *)

            result = Map[Join[{{{},{}}}, {#}]&, result];

            (*
              Print["result 2 = ", result]; 
            *)

            Return[result];
        ];

        (* g1 === g2, continue with NCPadAndMatch *)
        result = {};
        While[ And[result === {}, i < Length[g2]]
              ,
               result = ReplaceList[g1, Part[ShiftPattern[g2, i], 1]];
               i++;
        ];

        (*
          Print["result 3 = ", result];
        *)

        Return[result];
    ];

    (* g1 =!= g2, continue with MCM *)
    (* i >= 1 *)

    (* BUG FIXED: 
         While[ And[result === {}, i < Length[g2]], 
       would generate only first obstruction.
    *)

    result = Join[ result, 
                   Join @@ 
                     Table[ Flatten[Map[ReplaceList[g1, #] &, 
                                        ShiftPattern[g2, i]], 1], 
                            {i,1,Length[g2]-1} ] ];

    (*
      Print["result 4 = ", result];
    *)

    Return[result];

  ] /; Length[g2] <= Length[g1];

  (* Takes care of the case when Length[g2] > Length[g1] *)
  NCPadAndMatch[g1_List, g2_List] := 
    Map[Reverse, NCPadAndMatch[g2, g1], 1];

  (* Sorting *)

  Unprotect[Sort];
  (* Sort[{l__NCPoly}] := Part[{l}, Ordering[Map[NCPolyLeadingTerm, {l}]]]; *)
  Sort[{l__NCPoly}] := Part[{l}, Ordering[Map[NCPolyLeadingMonomial, {l}]]];
  Protect[Sort];

  NCPoly /: Greater[l__NCPoly] := 
    Greater @@ Ordering[List @@ Map[NCPolyLeadingTerm, {l}]];

  NCPoly /: Less[l__NCPoly] := 
    Less @@ Ordering[List @@ Map[NCPolyLeadingTerm, {l}]];

  (* PolyToRule *)
  NCPolyToRule[p_NCPoly] := Block[
    {pN, leadF},

    pN = NCPolyNormalize[p];
    leadF = NCPolyLeadingMonomial[pN];

    Return[leadF -> (leadF - pN)];
  ];

  NCPolyToRule[{p___NCPoly}] := 
    Map[NCPolyToRule, {p}];

  (* Display *)

  NCPolyVariables[p_NCPoly] := 
    Table[Symbol[FromCharacterCode[ToCharacterCode["@"]+i]], 
          {i, NCPolyNumberOfVariables[p]}];    
  
  NCPolyDisplay[{p__NCPoly}] := Map[NCPolyDisplay, {p}];

  NCPolyDisplay[{p__NCPoly}, args__] := 
      Map[NCPolyDisplay[#,args]&, {p}];
      
  NCPolyDisplay[p_NCPoly] := NCPolyDisplay[p, NCPolyVariables[p]];

  NCPolyDisplay[p_NCPoly, vars_List, 
                plus_:List, style_:(Style[#,Bold]&)] := 
    plus @@ 
      Reverse[
        MapThread[
          Times, 
          { NCPolyGetCoefficients[p],
            Apply[style[Dot[##]]&, Map[Part[Flatten[vars],#]&, 
                                       NCPolyGetDigits[p] + 1] /. {} -> 1, 1] }
        ]];

  NCPolyDisplay[p_, vars_List:{}, ___] := p;

  NCPolyDisplay[p___] := $Failed;

  (* NCPolySplitDigits *)
      
  NCPolySplitDigits[digits_List] :=
      Table[{digits[[;;k]], digits[[k+1;;]]}, {k, 0, Length[digits]}];

  (* Hankel *)
      
  NCPolyHankelMatrixAux1[digits_, coeffs_, base_] := Module[
    {index, deg, rules},

    (* construct Hankel matrix *)
      
    index = Map[NCDigitsToIndex[#, base]&, digits, {3}];
      
    rules = Flatten[MapThread[Thread[#1 -> #2]&, 
                              {index, coeffs}]];
      
    Return[{index, rules}];
      
  ];
      
  NCPolyHankelMatrixAux2[H_, mons_, cols_, base_, i_] := Module[
    {index, ncols, Hi = SparseArray[{},Dimensions[H]]},
      
    index = Flatten[Position[mons, {i,___}]];
    ncols = NCDigitsToIndex[Map[Rest, mons[[index]]], base];
      
    (*
    Print["index = ", index];
    Print["cols[[index]] = ", cols[[index]]];
    Print["ncols = ", ncols];
    *)
    
    If[ index =!= {},
        Hi[[All,ncols]] = H[[All,cols[[index]]]];
    ];
      
    Return[Hi];
      
  ];
      
  NCPolyHankelMatrix[p_NCPoly] := Module[
    {digits,sdigits,coeffs,base,
     left,right,index,redIndex},
    
    (* build Hankel matrix *)

    digits = NCPolyGetDigits[p];
    sdigits = Map[NCPolySplitDigits, digits];
      
    base = p[[1]];
    coeffs = NCPolyGetCoefficients[p];
      
    {index, rules} = NCPolyHankelMatrixAux1[sdigits, 
                                            coeffs,
                                            base];

    H = SparseArray[rules];
      
    (* determine unique column monomials *)
      
    {cols,mons} = Transpose[
                    Union[
                      Transpose[{Flatten[index[[All,All,2]],1], 
                                 Flatten[sdigits[[All,All,2]],1]}
                      ]
                    ]
                  ];
      
    (*
    Print["H = ", Normal[H]];
    Print["digits = ", digits];
    Print["sdigits = ", sdigits];
    Print["base = ", base];
    Print["index = ", index];
    Print["rules = ", rules];
    Print["mons = ", mons];
    Print["cols = ", cols];
    *)
    
    (* shift by var *)

    H = Prepend[
          Map[NCPolyHankelMatrixAux2[H, mons, cols, base, #]&, 
              Range[0,NCPolyNumberOfVariables[p]-1]], H];
      
    (* reduced basis index *)

    index = Union[Flatten[index]];
      
    (*
    Print["H = ", Normal /@ H];
    Print["index = ", index];
    *)

    Return[SparseArray[Map[#[[index, index]]&, H]]];
      
  ];


  SimultaneousTriangularization[AA_] := Module[
    {A = AA, 
     n = Dimensions[AA][[2]], ii,
     Astack, v, Q, Qi},
      
    Q = IdentityMatrix[n];
    For[ ii = 1, ii < n, ii++,
         
         (* Null space of [A1; A2; ...] *)
         Astack = ArrayFlatten[Map[List,A[[All,ii;;n,ii;;n]]]];
         v = Transpose[{NullSpace[Astack][[1]]}];
         Qi = SingularValueDecomposition[v][[1]];

         (*
         Print["Astack = ", Normal[Astack]];
         Print["v = ", Normal[v]];
         Print["Qi = ", Normal[Qi]];
         *)
                           
         A[[All,ii;;n,ii;;n]] = Map[(Transpose[Qi].#.Qi)&, 
                                    A[[All,ii;;n,ii;;n]]];
         Q[[ii;;n,ii;;n]] =  Q[[ii;;n,ii;;n]] . Qi;

         If[ ii > 1,
             A[[All,1;;ii-1,ii;;n]] = Map[(#.Qi)&, 
                                          A[[All,1;;ii-1,ii;;n]]];
         ];
                           
         (*
         Print["A = ", Normal[A]];
         Print["Q = ", Normal[Q]];
         *)
                           
    ];

    Return[{A,Q}];
        
  ];
                          
  (* NCPolyRealization *)
  NCPolyRealization[poly_NCPoly] := Module[
    {H, 
     lu,p,q,rank,l,u,
     A,b,c,d,
     T,
     method = "LUDecomposition" },

    (* Print["> Calculate Hankel matrices"]; *)
      
    (* calculate Hankel matrices *)
    H = NCPolyHankelMatrix[poly];
      
    (* remove constant *)
    d = SparseArray[{{H[[1,1,1]]}}];
    H[[1,1,1]] = 0;
    
    (* Print["> Decompose Hankel matrix"]; *)
      
    Switch[ method 

            ,"LUDecomposition",
      
            (* decompose Hankel matrix in full rank factors *)
            {lu, p, q, rank} = LUDecompositionWithCompletePivoting[H[[1]]];
            {l, u} = GetLUMatrices[lu];

            If [rank == 0,
                Return[{SparseArray[{},{Length[H],0,0}],
                        SparseArray[{},{0,1}],
                        SparseArray[{},{1,0}],
                        d}];
            ];

            (* permute rows and columns of l and u *)
            l[[p]] = l;
            u[[All, q]] = u;

            (* reduce dimensions to match rank *)
            l = l[[All, 1 ;; rank]];
            u = u[[1 ;; rank, All]];

            (*
            Print["H = ", Normal /@ H];
            Print["lu = ", Normal[lu]];
            Print["l = ", Normal[l]];
            Print["u = ", Normal[u]];
            *)

            (* calculate b and c *)
            b = u[[All, {1}]];
            c = l[[{1}, All]];

            (* Print["> Calculate Ai's"]; *)

            (* calculate ai's *)
            linv = SparseArray[LinearSolve[Transpose[l].l, Transpose[l]]];
            uinv = SparseArray[Transpose[LinearSolve[u.Transpose[u],u]]];
            A = SparseArray[
                  Prepend[Map[-Dot[linv, #, uinv]&, Rest[H]], 
                          SparseArray[{{i_,i_}->1}, {rank,rank}]]];

            (*
            Print["linv = ", linv];
            Print["uinv = ", uinv];
            *)
      
            ,"QRDecomposition",
            
            (* decompose Hankel matrix in full rank factors *)
            {Q,R} = QRDecomposition[Transpose[H[[1]]]];
            rank = MatrixRank[R];

            If [rank == 0,
                Return[{SparseArray[{},{Length[H],0,0}],
                        SparseArray[{},{0,1}],
                        SparseArray[{},{1,0}],
                        d}];
            ];

            (* calculate b and c *)
            b = Q[[All, {1}]];
            c = {R[[All, 1]]};

            (* Print["> Calculate Ai's"]; *)

            (* calculate ai's *)
            Ri = PseudoInverse[R];
            A = SparseArray[
                  Prepend[Map[-Dot[Transpose[Ri], #, Transpose[Q]]&, Rest[H]], 
                          SparseArray[{{i_,i_}->1}, {rank,rank}]]];

            (*
            Print["Ri = ", Ri];
            *)
        
    ];

    (* Print["> Permutation"]; *)
      
    (* Permute *)
    If[ False, (* rank > 1, *)

        (* Permute B *)
        p = {LUPartialPivoting[b]};
        p = Join[Complement[Range[rank], p], p];

        A[[2;;,All,All]] = A[[2;;,p,p]];
        b = b[[p]];
        c = c[[All,p]];

        (*
        Print["A = ", Normal[A]];
        Print["b = ", Normal[b]];
        Print["c = ", Normal[c]];
        *)

        If[ c[[1,-1]] =!= 0,
            Print["*** WARNING NCPolyRealization Permutation is not enough! ***"];
        ];
        
        If [ rank > 2,
             (* Permute C *)

             p = {LUPartialPivoting[c[[All, 1;;rank-1]]]};
             p = Join[p, Complement[Range[rank-1], p], {rank}];

             A[[2;;,All,All]] = A[[2;;,p,p]];
             b = b[[p]];
             c = c[[All,p]];

             (*
             Print["A = ", Normal[A]];
             Print["b = ", Normal[b]];
             Print["c = ", Normal[c]];
             *)
        ];
        
    ];

    (* Go for upper triangularization *)
    If[ rank > 1,

        (* Print["> Simultaneous Triangularization"]; *)
        
        {A[[2;;]], T} = SimultaneousTriangularization[A[[2;;]]];
        b = Transpose[T] . b;
        c = c. T;
        
    ];
            
    Return[{A,b,c,d}];
      
  ];
      
End[]
      
(* Load NCPolyAssociationGraded *)
Get["NCPolyAssociationGraded`"];
      
EndPackage[]
