(*  NCPoly.m                                                               *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: July 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPoly`" ];

(* 
   These functions are not implemented here. 
   They are meant to be overload by your favorite implementation 
*)

Clear[NCPoly];
NCPoly::usage="NCPoly[c, monomials, var] constructs a noncommutative polynomial object in variables var where the monomials have coefficient c. Monomials are specified in terms of the symbols in the list var. For example, NCPoly[{-1,2}, {{x,y,x},{z}}, {x, y, z}] constructs an object associated with the noncommutative polynomial 2 z - x y x in variables x, y and z. The internal representation is so that the terms are sorted according to a degree-lexicographic order in vars. In the above example, x < y < z.";

Clear[NCPolyOrderType];
Clear[NCPolyLexDeg,NCPolyDegLex,NCPolyDegLexGraded];
NCPolyOrderType::usage="NCPolyOrderType[p] returns the type of monomial order in which the noncommutative polynomial p is stored. Order can be NCPolyLexDeg or NCPolyDegLex.";

Clear[NCPolyDisplay];
NCPolyDisplay::usage="NCPolyDisplay[p] prints the noncommutative polynomial p using symbols x1,...,xn. NCPolyDisplay[p, vars] uses the symbols in the list vars.";

Clear[NCPolyDisplayOrder];
NCPolyDisplayOrder::usage="NCPolyDisplayOrder[vars] prints the order implied by the list vars";

Clear[NCPolyConstant];
NCPolyConstant::usage="NCPolyConstant[value, var] constructs a noncommutative monomial object in variables var representing value. For example, NCPolyMonomial[3, {x, y, z}] constructs an object associated with the noncommutative monomial 3 in variables x, y and z. See NCPoly for more details.";

Clear[NCPolyMonomial];
NCPolyMonomial::usage="NCPolyMonomial[monomial, var] constructs a noncommutative monomial object in variables var. Monomials are specified in terms of the symbols in the list var. For example, NCPolyMonomial[{x,y,x}, {x, y, z}] constructs an object associated with the noncommutative monomial x y x in variables x, y and z. See NCPoly for more details.";

Clear[NCPolyMonomialQ];
NCPolyMonomialQ::usage="NCPolyMonomialQ[p] returns True if p is a NCPoly monomial.";

Clear[NCPolyDegree];
NCPolyDegree::usage="NCPolyDegree[p] returns the degree of the NCPoly p.";

Clear[NCPolyLeadingTerm];
NCPolyLeadingTerm::usage="NCPolyLeadingTerm[p] returns a rule {a, b} -> c associated with leading term of the NCPoly p. c is the coefficient of the monomial, a is the degree and b is the integer associated with the monomial. See NCIntegerDigits and NCFromDigits for details on b.";

Clear[NCPolyLeadingMonomial];
NCPolyLeadingMonomial::usage="NCPolyLeadingMonomial[p] returns a NCPoly representation of the leading term of the NCPoly p.";

Clear[NCPolyGetCoefficients];
NCPolyGetCoefficients::usage="NCPolyGetCoefficients[p] returns a list with the coefficients of the terms in the NCPoly p.";

Clear[NCPolyGetDigits];
NCPolyGetDigits::usage="NCPolyGetIntegers[p] returns a list with the base n digits that encode the degree of the terms in the NCPoly p. See NCIntegerDigits and NCFromDigits.";

Clear[NCPolyGetIntegers];
NCPolyGetIntegers::usage="NCPolyGetIntegers[p] returns a list with the integers that encode the degree of the terms in the NCPoly p.";

Clear[NCPolyNumberOfVariables];
NCPolyNumberOfVariables::usage="NCPolyNumberOfVariables[p] returns the number of variables of the NCPoly p.";

Clear[NCPolySum];
NCPolySum::usage="NCPolySum[f,g] returns a NCPoly that is the sum of the NCPoly's f and g.";

Clear[NCPolyProduct];
NCPolyProduct::usage="NCPolyProduct[f,g] returns a NCPoly that is the product of the NCPoly's f and g.";

Clear[NCPolyReduce];
NCPolyReduce::usage="NCPolyReduce[f,g] returns the left-right quotients and the remainder of the division of the NCPoly f by the leading term of the NCPoly g.\nIn the form NCPolyReduce[f,g,comp] the function NCPolyReduce completely reduces all terms of f, and not only the leading term when comp is True (default is False).\nNCPolyReduce[f,{g1,...gn},comp] successively (and completely, if the optional paramter comp is True) reduces the NCPoly f by the list of NCPolys {g1,...,gn}.\nNCPolyReduce[{g1,...gn},comp] attempts to reduce the list of NCPolys {g1,...,gn} potentially eliminating redundant elements. It works by reducing each NCPoly gi, i = 1,...,n, against the remaining elements in the list one at a time.\nSee also NCPolyFullReduce and NCPolyQuotientExpand.";

Clear[NCPolyToRule];
NCPolyReduce::usage="NCPolyToRule[f] returns a Rule associated with polynomial f. If f = lead + rest, where lead is the leading term in the current order, then NCPolyToRule[f] returns the rule 'lead -> -rest' where the coefficient of the leading term has been normalized to 1.";

Clear[NCPolyFullReduce];
NCPolyFullReduce::usage="NCPolyFullReduce[f,g] applies NCPolyReduce successively until the remainder does not change.\nSee also NCPolyReduce and NCPolyQuotientExpand.";

Clear[NCPolyQuotientExpand];
NCPolyQuotientExpand::usage="NCPolyQuotientExpand[q,g] returns a NCPoly that is the left-right product of the quotient as returned by NCPolyReduce by the NCPoly g. It also works when g is a list.";

Clear[NCPolyNormalize];
NCPolyNormalize::usage="NCPolyNormalize[p] makes the coefficient of the leading term of p to unit. It also works when p is a list.";


(* The following generic functions are implemented here *)

Clear[NCFromDigits];
NCFromDigits::usage="NCFromDigits[list] constructs an integer from the list of its decimal digits.\nNCFromDigits[list,b] takes the digits to be given in base b.";

Clear[NCIntegerDigits];
NCIntegerDigits::usage="NCIntegerDigits[n] gives a list of the decimal digits in the integer n.\nNCIntegerDigits[n,b] gives a list of the base-b digits in the integer n.\nNCIntegerDigits[n,b,len] pads the list on the left with zeros to give a list of length len.";

Clear[NCPadAndMatch];
NCPadAndMatch::usage="When list a is longer than list b, NCPadAndMatch[a,b] returns the minimum number of elements from list a that should be added to the left and right of list b so that a = l b r.\nWhen list b is longer than list a, return the opposite match. NCPadAndMatch returns all possible matches with the minimum number of elements.";

Clear[NCPolyDivideDigits];
NCPolyDivideDigits::usage="NCPolyDivideDigits[F,G] returns the result of the division of the leading digits lf and lg.";

Clear[NCPolyDivideLeading];
NCPolyDivideLeading::usage="NCPolyDivideLeading[lF,lG,base] returns the result of the division of the leading Rules lf and lg as returned by NCGetLeadingTerm.";


Begin["`Private`"];

(* Some facilities are implemented here. ATTENTION: the main driver function are not implemented. *)

(* Constant Constructor *)

NCPolyConstant[value_, n_] := 
  NCPolyMonomial[Rule[{0,0}, value], n];

(* Operators *)

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
NCPoly /: NonCommutativeMultiply[r_NCPoly, s_NCPoly] := NCPolyProduct[r, s];

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

(* OLD CODE
NCFromDigits[p_List, {base__Integer}] := 
  Reverse[
    Map[ NCFromDigits[#, (Plus @@ {base}) + 1]&
        ,
         Map[ SelectDigits[(p + 1), #]&
             ,
              Partition[Prepend[Accumulate[{base}], 0], 2, 1]
         ]
    ]
  ];
*)

NCFromDigits[{}, {base__}] := 
  Table[0, {i, Length[{base}] + 1}];

NCFromDigits[{}, base_] := 
  Table[0, {i, 2}];

NCFromDigits[{p__List}, base_] := 
  Map[NCFromDigits[#, base]&, {p}];

NCFromDigits[p_List, {base__Integer}] := 
  Append[ Reverse[ BinCounts[p, {Prepend[Accumulate[{base}], 0]}] ], FromDigits[p, Plus @@ {base}] ];

(* DEG Ordered *)
NCFromDigits[p_List, base_Integer:10] := 
  {Length[p], FromDigits[p, base]};

(* IntegerDigits *)

(* OLD CODE
NCIntegerDigits[{p__List}, {base__Integer}] := 
  (Plus @@ 
     Map[ NCIntegerDigits[#, (Plus @@ {base}) + 1, Max[Part[{p}, All, 1]]]& 
       ,{p} ]) - 1 /; Depth[{p}] === 3;

NCIntegerDigits[{p__List}, {base__Integer}] := 
  Map[NCIntegerDigits[#, {base}]&, {p}] /; Depth[{p}] === 4;
 *)

(* DEG Ordered *)
NCIntegerDigits[{d_Integer, n_Integer}, base_Integer:10] := 
  IntegerDigits[n, base, d];

NCIntegerDigits[{d_Integer, n_Integer}, base_Integer:10, len_Integer] := 
  IntegerDigits[n, base, len];

NCIntegerDigits[{d__Integer, n_Integer}, {base__Integer}] := 
  IntegerDigits[n, Plus @@ {base}, Plus @@ {d}];

NCIntegerDigits[{d__Integer, n_Integer}, {base__Integer}, len_Integer] := 
  IntegerDigits[n, Plus @@ {base}, len];

NCIntegerDigits[dn_List, base_Integer] :=
  Map[NCIntegerDigits[#, base]&, dn] /; Depth[dn] === 3;

NCIntegerDigits[dn_List, base_Integer, len_Integer] :=
  Map[NCIntegerDigits[#, base, len]&, dn] /; Depth[dn] === 3;

NCIntegerDigits[dn_List, {base__Integer}] :=
  Map[NCIntegerDigits[#, {base}]&, dn] /; Depth[dn] === 3;

NCIntegerDigits[dn_List, {base__Integer}, len_Integer] :=
  Map[NCIntegerDigits[#, {base}, len]&, dn] /; Depth[dn] === 3;

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

  (* OLD CODE
     While[ i < Length[g2],

         ( *
           Print[ "ShiftPattern[g2, i] = ", ShiftPattern[g2, i] ];
         * )
         result = Join[result, Flatten[Map[ReplaceList[g1, #] &, ShiftPattern[g2, i]], 1]];
         i++;
     ];
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
Sort[{l__NCPoly}] := Part[{l}, Ordering[Map[NCPolyLeadingTerm, {l}]]];
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

End[]
EndPackage[]
