(* :Title: NCLmi.m *)

(* :Author: Mauricio C. de Oliveira *)

(* :Context: NCLmi` *)

(* :Sumary: *)

(* :Alias: *)

(* :Warnings: *)

(* :History:
   :06/20/2004: First Version
*)

BeginPackage[ 
	        "NCLmi`",
	        "NCMatrix`",
	        "Matrix`",
		"NCCollect`",
                "NonCommutativeMultiply`"
];

Clear[NCLmi]

NCLmi::usage = "Auxiliary routines for LMI manipulation.";


Clear[MatrixAffineFactor]

MatrixAffineFactor::notmatrix = "MatrixAffineFactor[] only works on Matrix arguments! If the result of the expression is indeed a Matrix, call NCExpand first.";

MatrixAffineFactor::usage = "Factor matrix into product of affine terms.";

Clear[MatCollect]

MatCollect::usage = "Collects sums of products of matrices in matrix products.";


Clear[NormalMatrixQ]

NormalMatrixQ::usage = "NormalMatrixQ[m] returns True if first term of the first entry of Matrix m different from zero is an atom but not a negative number";


Clear[NormalizeMatrixProduct]

NormalizeMatrixProduct::usage = "Rearrange products of matrices so as that all matrices return True to NormalMatrixQ.";


Clear[CollectSymmetric]

CollectSymmetric::usage = "CollectSymmetric[exp, symvars] put symmetric terms in exp in the same form. Symvars contains a list of symmetric symbols."


Clear[MatrixAffineFactorCoefficients];

MatrixAffineFactorCoefficients::usage = "MatrixAffineFactorCoefficients[exp,K,symvars] returns a list {A,B,C} if `exp == A + B ** K ** C + tp[C] ** tp[K] ** tp[B]' and $Failed otherwise."


Begin["`Private`"]; 


(* Affine functional in factored form A ** X ** B *)

Clear[AffineFunctional];

AffineFunctional::notaffine = "Expression is not affine on the variables!";

HoldPattern[tp[AffineFunctional[a_, b_, c_]]] := AffineFunctional[tp[c], tp[b], tp[a]];
HoldPattern[a___ ** AffineFunctional[b_, c_, d_] ** e___] := AffineFunctional[a ** b, c, d ** e];
AffineFunctional[a_, b_, c_] := (Message[AffineFunctional::notaffine]; $Failed ) /; ! FreeQ[{a, b, c}, AffineFunctional]


(* Replace variables by affine functional *)

Clear[FindAffineFactors];
FindAffineFactors[exp_, vars_List] := exp /. Map[# -> AffineFunctional[1, #, 1] &, vars]


(* Expand matrix entry into product of matrices *)

Clear[EntryToMatrixProduct];

EntryToMatrixProduct[a_, b_, c_, ind_List, dim_List] := Module[
    { left, right },
    If [ dim[[1]] > 1,
	 (* then *)
         left = Matrix[Table[0, {dim[[1]]}, {1}]];
         left[[ ind[[1]], 1 ]] = a,
	 (* else *)
         left = 1;
    ];
    If [ dim[[2]] > 1,
	 (* then *)
         right = Matrix[Table[0, {1}, {dim[[2]]}]];
         right[[ 1, ind[[2]] ]] = c,
	 (* else *)
         right = 1;
    ];
    left ** b ** right
    ]

Clear[MatrixAffineFactorProcess];
MatrixAffineFactorProcess[m_, vars_List] := Module[
  {tmp = m},
  (* Normalize matrices *)
  tmp = NormalizeMatrixProduct[ tmp ];
  (* Matrix Collect *)
  tmp = MatCollect[ tmp, vars ];
  tmp = MatCollect[ tmp, Map[tp,vars] ]
]

(* Factor matrix into product of affine terms *)

MatrixAffineFactor[m_Matrix, vars_List] := Module[
  {tmp, const},
  (* Expand in the form Sum[B_i ** variable_i ** C_i] *)
  tmp = InternalMatrixAffineFactor[ExpandNonCommutativeMultiply[m], vars];
  (* Collect on the variables and its transposes *)
  tmp = NCCollect[ NCCollect[tmp, vars], Map[tp,vars] ];
  (* Process expression *)
  tmp = FixedPoint[MatrixAffineFactorProcess[#, vars]&, tmp];
  (* Determine constant part *)
  const = ExpandNonCommutativeMultiply[m - tmp];
  If[ ZeroQ[const], 
    tmp,
    const + tmp
  ]
]

MatrixAffineFactor[m_, vars_List] := Module[
    {tmp=ExpandNonCommutativeMultiply[m]},
    If[Head[tmp]===Matrix,
       MatrixAffineFactor[tmp, vars],
       Message[MatrixAffineFactor::notmatrix];
       $Failed
    ]
]

Clear[InternalMatrixAffineFactor]

InternalMatrixAffineFactor[m_Matrix, vars_List] := Module[
    {mm = MatrixToList[m]},
    Apply[Plus,Flatten[MapIndexed[InternalMatrixAffineFactor[##, Dimensions[mm]] &,
		     FindAffineFactors[mm, vars], {2}]]]
]

InternalMatrixAffineFactor[a_ + b_, ind_List, dim_List] := 
    InternalMatrixAffineFactor[a, ind, dim] + InternalMatrixAffineFactor[b, ind, dim];

InternalMatrixAffineFactor[AffineFunctional[a_, b_, c_], ind_List, dim_List] := 
    EntryToMatrixProduct[a, b, c, ind, dim];

InternalMatrixAffineFactor[-AffineFunctional[a_, b_, c_], ind_List, 
      dim_List] := -EntryToMatrixProduct[a, b, c, ind, dim];

InternalMatrixAffineFactor[x_, ind_List, dim_List] := 0;


(* Return True if first entry of matrix m is positive (symbolically) *)

PositivePivotQ[exp_?NumberQ] := exp >= 0;

PositivePivotQ[exp_?AtomQ] := True;

PositivePivotQ[exp_] := PositivePivotQ[First[exp]];

NormalMatrixQ[m_Matrix] := 
    PositivePivotQ[ Part[Select[Flatten[MatrixToList[m]], # =!= 0 &, 1], 1] ];

NormalMatrixQ[x] := False;


(* Normalize matrix *)

(*
HoldPattern[NormalizeMatrixProduct[a_ ** b_]] :=
    - (-a) ** b; /; (!NormalMatrixQ[a] && NormalMatrixQ[b])

HoldPattern[NormalizeMatrixProduct[a_ ** b_]] :=
    (-a) ** (-b); /; (!NormalMatrixQ[a] && !NormalMatrixQ[b])

HoldPattern[NormalizeMatrixProduct[a___ ** b_]] :=
    NormalizeMatrixProduct[NonCommutativeMultiply[a]] ** b; /; NormalMatrixQ[b]

HoldPattern[NormalizeMatrixProduct[a___ ** b_]] :=
    - NormalizeMatrixProduct[NonCommutativeMultiply[a]] ** (-b);
*)

HoldPattern[NormalizeMatrixProduct[NonCommutativeMultiply[a___]]] := Module[
    {pos=Position[Map[NormalMatrixQ,List[a]],False]},
    If[EvenQ[Length[pos]], 1, -1] * Apply[NonCommutativeMultiply,MapAt[Minus,List[a],pos]]
]

NormalizeMatrixProduct[m_Matrix] := m;

NormalizeMatrixProduct[exp_AtomQ] := exp;

NormalizeMatrixProduct[exp_] := Map[NormalizeMatrixProduct, exp];


(* Matrix collect -> collects products into matrices *)

MatCollect[m_, vars_List] := Module[
    {tmp = m},
    Do[tmp = MatCollect[tmp, vars[[i]]], {i, Length[vars]}];
    (* Print[tmp]; *)
    tmp //. {
      (s1_:1)*Term[a1_, var1_, b1_] + (s2_:1)*Term[a1_, var1_, b2_] :> Term[a1, var1, s1*b1 + s2*b2],
      (s1_:1)*Term[a1_, var1_, b1_] + (s2_:1)*Term[a2_, var1_, b1_] :> Term[s1*a1 + s2*a2, var1, b1],
      (s1_:1)*Term[a1_, var1_, b1_] + (s2_:1)*Term[a1_, var2_, b2_] :> Term[a1, MatrixFlatten[Matrix[{var1,var2}]], MatrixFlatten[Matrix[{s1*b1},{s2*b2}]]],
      (s1_:1)*Term[a1_, var1_, b1_] + (s2_:1)*Term[a2_, var2_, b1_] :> Term[MatrixFlatten[Matrix[{s1*a1,s2*a2}]], MatrixFlatten[Matrix[{var1},{var2}]], b1]
    } /. Term[a_,b_,c_] -> a ** b ** c
    ]

MatCollect[m_, var_] := m //. { 
  HoldPattern[(s_:1) * a_ ** var ** b_ + c_ ] -> s * Term[a, var, b] + c, 
  HoldPattern[(s_:1) * a_ ** var + c_ ] -> s * Term[a, var, 1] + c, 
  HoldPattern[(s_:1) * var ** b_ + c_ ] -> s * Term[1, var, b] + c,
  HoldPattern[(s_:1) * a_ ** mm_Matrix ** b_ + c_ /; !FreeQ[mm,var] ] -> s * Term[a, mm, b] + c
}


(*
MatCollect[m_] := m //. {
    HoldPattern[(s1_:1) * a_ ** b_ ** c_ + (s2_:1) * a_ ** b_ ** e_] :> 
        NormalizeMatrixProduct[a ** b ** (s1*c + s2*e)],
    HoldPattern[(s1_:1) * a_ ** b_ ** c_ + (s2_:1) * a_ ** d_ ** e_] :> 
        NormalizeMatrixProduct[a ** MatCollect[s1 * b ** c + s2 * d ** e]],
    HoldPattern[(s1_:1) * a_ ** b_ ** c_ + (s2_:1) * d_ ** b_ ** c_] :> 
        NormalizeMatrixProduct[(s1 * a + s2 * d) ** b ** c],
    HoldPattern[(s1_:1) * a_ ** b_ ** c_ + (s2_:1) * d_ ** e_ ** c_] :> 
        NormalizeMatrixProduct[MatCollect[s1 * a ** b + s2 * d ** e] ** c],
    HoldPattern[(s1_:1) * b_ ** c_ + (s2_:1) * d_ ** e_] :> 
        NormalizeMatrixProduct[MatrixFlatten[ExpandNonCommutativeMultiply[Matrix[{b, d}]]] ** MatrixFlatten[ExpandNonCommutativeMultiply[Matrix[{s1*c}, {s2*e}]]]],
    HoldPattern[(s1_:1) * a_ ** b_ + (s2_:1) * d_ ** e_] :> 
        NormalizeMatrixProduct[MatrixFlatten[ExpandNonCommutativeMultiply[Matrix[{s1*a, s2*d}]]] ** MatrixFlatten[ExpandNonCommutativeMultiply[Matrix[{b}, {e}]]]]
}
*)


(*
MatCollect[m_, vars_] := m //. {
      HoldPattern[(s1_:1) * b_ ** c_ + (s2_:1) * d_ ** e_] :> 
          If[(NumberQ[s1] && NumberQ[s2]) && (s1*s2 > 0 && s1 < 0), 
		- MatrixFlatten[Matrix[{b, d}]] ** MatrixFlatten[Matrix[{-s1*c}, {-s2*e}]],
		MatrixFlatten[Matrix[{b, d}]] ** MatrixFlatten[Matrix[{s1*c}, {s2*e}]]
	  ],
      HoldPattern[(s1_:1) * a_ ** b_ + (s2_:1) * d_ ** e_] :> 
          If[(NumberQ[s1] && NumberQ[s2]) && (s1*s2 > 0 && s1 < 0), 
          	-MatrixFlatten[Matrix[{-s1*a, -s2*d}]] ** MatrixFlatten[Matrix[{b}, {e}]],
          	MatrixFlatten[Matrix[{s1*a, s2*d}]] ** MatrixFlatten[Matrix[{b}, {e}]]
	  ],
      HoldPattern[(s1_:1) * a_ ** b_ ** c_ + (s2_:1) * a_ ** d_ ** e_] :> 
          If[(NumberQ[s1] && NumberQ[s2]) && (s1*s2 > 0 && s1 < 0), 
		-a ** MatrixFlatten[Matrix[{b, d}]] ** MatrixFlatten[Matrix[{-s1*c}, {-s2*e}]],
		a ** MatrixFlatten[Matrix[{b, d}]] ** MatrixFlatten[Matrix[{s1*c}, {s2*e}]]
	  ],
      HoldPattern[(s1_:1) * a_ ** b_ ** c_ + (s2_:1) * d_ ** e_ ** c_] :> 
          If[(NumberQ[s1] && NumberQ[s2]) && (s1*s2 > 0 && s1 < 0), 
          	-MatrixFlatten[Matrix[{-s1*a, -s2*d}]] ** MatrixFlatten[Matrix[{b}, {e}]] ** c,
          	MatrixFlatten[Matrix[{s1*a, s2*d}]] ** MatrixFlatten[Matrix[{b}, {e}]] ** c
	  ]
      }
*)


(* CollectSymmetric -> puts symmetric terms in the same form *)

Clear[MatchTranspose];

MatchTranspose[l_List, i_Integer, symrule_] := $Failed /; i > Part[Dimensions[l, 1], 1];
MatchTranspose[l_List, i_Integer, symrule_] := 
	Flatten[Position[Drop[l, i], tp[Part[l, i]] //. symrule]];


Clear[CollectSymmetricList];

CollectSymmetricList[exp_List, symvars_:{}] := Module[
	{ tmp = ExpandNonCommutativeMultiply[exp], 
	  symrule = Map[(tp[#] -> #) &, symvars], 
	  pos, sym = {}, drop = {}, i = 1},
	While[(pos = MatchTranspose[tmp, i, symrule]) =!= $Failed,
		If[ pos =!= {},
			pos = First[pos];
			drop = Append[drop, pos + i];
			sym = Append[sym, i];
		];
		i++;
	];
	Join[
		Delete[exp, drop],
		Map[tp, Part[exp, sym]] //. symrule
	]
    ];

CollectSymmetric[exp_Plus, symvars_:{}] := 
	Replace [
		CollectSymmetricList[Replace[exp, Plus -> List, 1, Heads -> True], symvars],
	List -> Plus, 1, Heads -> True
];

CollectSymmetric[exp_, symvars_:{}] := exp;


(* MatrixAffineFactorCoefficients *)

MatrixAffineFactorCoefficients[exp_Plus, var_, symvars_:{}] := 
  MatrixAffineFactorCoefficientsList[Replace[exp, Plus -> List, 1, Heads -> True], var, 
    symvars]


Clear[GetAffineTerm];

GetAffineTerm[term_, var_, 
      symrule_] := (term /. {a_ ** var ** b_ -> {a, b}, 
            a_ ** tp[var] ** b_ -> {tp[b], tp[a]}}
        ) //. symrule;


Clear[ExtractMatrixAffineFactorCoefficients];

ExtractMatrixAffineFactorCoefficients::notinfinslerform = 
    "Expression is not in Finsler's form.";

ExtractMatrixAffineFactorCoefficients[{x_, y_}, var_, symrule_] := Module[
    {tmp = GetAffineTerm[x, var, symrule]},
    If[tmp === GetAffineTerm[y, var, symrule], tmp, 
      Message[ExtractMatrixAffineFactorCoefficients::notinfinslerform]; $Failed]
    ]

ExtractMatrixAffineFactorCoefficients[exp_, var_, symrule_] := 
	(Message[ExtractMatrixAffineFactorCoefficients::notinfinslerform]; $Failed)


Clear[MatrixAffineFactorCoefficientsList];

MatrixAffineFactorCoefficientsList[exp_List, var_, symvars_] := Module[
    {tmp = 
        ExtractMatrixAffineFactorCoefficients[
          Select[exp, (MemberQ[#, var] || MemberQ[#, tp[var]]) &],
          var, Map[(tp[#] -> #) &, symvars]]
      },
    If[tmp =!= $Failed,
      {
        Apply[Plus, Select[exp, (FreeQ[#, var] && FreeQ[#, tp[var]]) &]], 
        ExtractMatrixAffineFactorCoefficients[
          Select[exp, (MemberQ[#, var] || MemberQ[#, tp[var]]) &],
          var, Map[(tp[#] -> #) &, symvars]]
        },
      $Failed
      ]
    ]

End[];

EndPackage[];
