(* :Title: 	MatrixDecompositions.m *)

(* :Authors: 	Mauricio C. de Oliveira and Burack Guven *)

(* :Context: 	MatrixDecompositions` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "MatrixDecompositions`" ];

Options[MatrixDecompositions] = {
  ZeroTest -> PossibleZeroQ,
  DivideBy -> DivideBy,
  Dot -> Dot
};

Clear[GetLUMatrices];
GetLUMatrices::usage="";

Clear[LUDecompositionWithPartialPivoting];
LUDecompositionWithPartialPivoting::usage="";

Clear[LUDecompositionWithCompletePivoting];
LUDecompositionWithCompletePivoting::usage="";

Clear[UpperTriangularSolve];
UpperTriangularSolve::usage="";

Clear[LowerTriangularSolve];
LowerTriangularSolve::usage="";

Clear[LUInverse];
LUInverse::usage="";

MatrixDecompositions::WrongDimensions = \
"Righ and left-hand side dimensions DO NOT MATCH.";
MatrixDecompositions::NotSquare = "The input matrix is not SQUARE.";
MatrixDecompositions::Singular = "The input matrix appears to be SINGULAR.";

Clear[LDLDecomposition];
LDLDecomposition::usage="";

Options[LUDecompositionWithPartialPivoting] = {
  Pivoting -> LUPartialPivoting
};

Options[LUDecompositionWithCompletePivoting] = {
  Pivoting -> LUCompletePivoting
};

Begin[ "`Private`" ]

  (* Get LU Matrices *)

  GetLUMatrices[ldu_, p_, q_, rank_] := Module[
    {l,u},

    (* Extract L and U factor *)
    {l,u} = GetLUMatrices[ldu];

    (* Perform permutations and truncate to rank *)
    l = l[[All, 1;;rank]];
    l[[p,All]] = l;
    u = u[[1;;rank, All]];
    u[[All,q]] = u;

    Return[{l,u}];
  ];

  GetLUMatrices[ldu_] := Module[
    {n,m,mats},
    {m,n} = Dimensions[ldu];

    mats = If[n >= m, 
      {
	ldu[[1;;m,1;;m]] SparseArray[{i_,j_} /; j < i -> 1, {m,m}] 
	   + SparseArray[{i_,i_} -> 1, {m,m}],
	ldu SparseArray[{i_,j_} /; j >= i -> 1, {m,n}]
      },
      {
	ldu SparseArray[{i_,j_} /; j < i -> 1, {m,n}]
	   + SparseArray[{i_,i_} -> 1, {m,n}],
	ldu[[1;;n,1;;n]] SparseArray[{i_,j_} /; j >= i -> 1, {n,n}]
      }
    ];

    Return[mats];

  ];

  (* Upper triangular solve (Back substitution) *)
  UpperTriangularSolve[u_, b_?VectorQ, opts:OptionsPattern[{}]] :=
    Flatten[UpperTriangularSolve[u, Transpose[{b}], opts]];

  UpperTriangularSolve[u_, b_?MatrixQ, opts:OptionsPattern[{}]] := Module[
     {options, zeroTest, pivoting, dot,
      U,X,m,n,j},

     (* process options *)

     options = Flatten[{opts}];

     zeroTest = ZeroTest
	    /. options
	    /. Options[MatrixDecompositions, ZeroTest];

     divideBy = DivideBy
	    /. options
	    /. Options[MatrixDecompositions, DivideBy];

     dot = Dot
	    /. options
	    /. Options[MatrixDecompositions, Dot];

     (* Solve *)
      
     U = u;
     {m,n} = Dimensions[U];
     If[m != n, Message[MatrixDecompositions::NotSquare]; Return[]];
      
     (* Initialize solution *)
     X = b;
     {n,$trash} = Dimensions[X];
     If[m != n, Message[MatrixDecompositions::WrongDimensions]; Return[]];

     (*
     Print["m = ", m];
     Print["n = ", n];
     *)

     For [j = m, j >= 2, j--,

       (* Print["j = ", ToString[j]]; *)

       (* If zero diagonal, singular *)
       If[ zeroTest[U[[j,j]]],
	 Message[MatrixDecompositions::Singular];
       ];

       (* Print["X- = ", Normal[X]]; *)

       (* Update matrix *)
       X[[j]] /= U[[j,j]];
       X[[1;;j-1]] -= U[[1;;j-1,{j}]] . {X[[j]]};

       (* Print["X+ = ", Normal[X]]; *)

    ];

    (* If zero diagonal, singular *)
    If[ zeroTest[U[[1,1]]],
      Message[MatrixDecompositions::Singular];
    ];

    X[[1]] /= U[[1,1]];

    Return[X];
  ];

  (* Lower triangular solve (Back substitution) *)
  LowerTriangularSolve[l_, b_?VectorQ, opts:OptionsPattern[{}]] :=
    Flatten[LowerTriangularSolve[l, Transpose[{b}], opts]];

  LowerTriangularSolve[l_, b_?MatrixQ, opts:OptionsPattern[{}]] := Module[
     {options, zeroTest, pivoting, dot,
      L,X,m,n,j},

     (* process options *)

     options = Flatten[{opts}];

     zeroTest = ZeroTest
	    /. options
	    /. Options[MatrixDecompositions, ZeroTest];

     divideBy = DivideBy
	    /. options
	    /. Options[MatrixDecompositions, DivideBy];

     dot = Dot
	    /. options
	    /. Options[MatrixDecompositions, Dot];

     (* Solve *)

     L = l;
     {m,n} = Dimensions[L];
     If[m != n, Message[MatrixDecompositions::NotSquare]; Return[]];

     (* Initialize solution *)
     X = b;
     {n,$trash} = Dimensions[X];
     If[m != n, Message[MatrixDecompositions::WrongDimensions]; Return[]];

     (*
     Print["m = ", m];
     Print["n = ", n];
     *)

     For [j = 1, j <= m - 1, j++,

       (* Print["j = ", ToString[j]]; *)

       (* If zero diagonal, singular *)
       If[ zeroTest[L[[j,j]]],
	 Message[MatrixDecompositions::Singular];
       ];

       (* Print["X- = ", Normal[X]]; *)

       (* Update matrix *)
       X[[j]] /= L[[j,j]];
       X[[j+1;;m]] -= L[[j+1;;m,{j}]] . {X[[j]]};

       (* Print["X+ = ", Normal[X]]; *)

    ];

    (* If zero diagonal, singular *)
    If[ zeroTest[L[[m,m]]],
      Message[MatrixDecompositions::Singular];
    ];

    X[[m]] /= L[[m,m]];

    Return[X];
  ];

  (* LU Inverse *)
  (* 
     L U inv[A] = P A inv[A] = P
     U inv[A] = (L \ P)
     inv[A] = U \ (L \ P)
     
  *)
  
  LUInverse[A_?MatrixQ] := Module[
      {lu,p,l,u,id},

      {m,n} = Dimensions[A];
      id = IdentityMatrix[m];
      If[m != n
         , 
         Message[MatrixDecompositions::NotSquare]; 
         Return[id];
      ];
      
      {lu, p} = LUDecompositionWithPartialPivoting[A];
      {l, u} = GetLUMatrices[lu];

      Return[
        Check[
          UpperTriangularSolve[u, LowerTriangularSolve[l, id[[p]]]]
          ,
          id
          ,
          MatrixDecompositions::Singular
        ]
      ];

  ];

  
  (* LU Decomposition with partial pivoting *)
  (* From Golub and Van Loan, p 112 *)

  Clear[LUPartialPivoting];

  LUPartialPivoting[v_?MatrixQ, f_:Abs] := LUPartialPivoting[v[[All,1]], f];

  LUPartialPivoting[v_List, f_:Abs] := Part[Ordering[f[v],-1], 1];

  LUPartialPivoting[v_SparseArray, f_:Abs] := Module[
    {rules, maxElement},

     (* Get rules *)
     rules = ArrayRules[v];

     (* Pick largest *)
     maxElement = LUPartialPivoting[rules[[All,2]], f];

     (* Return (1,1) element if matrix is zero *)
     If[ maxElement == Length[rules],
	1
       ,
	Part[rules[[maxElement]], 1, 1]
     ]

  ];

  LUDecompositionWithPartialPivoting[AA_?MatrixQ, 
                                     opts:OptionsPattern[{}]] := 
  Module[
    {options, zeroTest, pivoting, dot,
     A, m, n, p, k, N, mu, lambda},

     (* process options *)

     options = Flatten[{opts}];

     zeroTest = ZeroTest
	    /. options
	    /. Options[MatrixDecompositions, ZeroTest];

     pivoting = Pivoting
	    /. options
	    /. Options[LUDecompositionWithPartialPivoting, Pivoting];

     divideBy = DivideBy
	    /. options
	    /. Options[MatrixDecompositions, DivideBy];

     dot = Dot
	    /. options
	    /. Options[MatrixDecompositions, Dot];

     (* start algorithm *)

     A = AA;
     {m,n} = Dimensions[A];
     rank = Min[n,m];
     p = Range[m];
     q = Range[n];
     N = If[n >= m, rank - 1, rank];

     (*
     Print["m = ", m];
     Print["n = ", n];
     Print["N = ", N];
     *)

     For [k = 1, k <= N, k++,

       (* Print["k = ", ToString[k]]; *)

       (* Pivot *)
       mu = pivoting[ A[[k ;; m, k]] ] + k - 1;

       (* Print["mu = ", mu]; *)

       (* Interchange rows *)
       A[[{k,mu}, All]] = A[[{mu,k}, All]];

       (* Store permutations *)
       p[[{k,mu}]] = p[[{mu,k}]];

       (* Print["p = ", p]; *)

       (* If zero pivot, skip *)
       If[ zeroTest[A[[k,k]]],
	 Continue[];
       ];

       (* Print["A- = ", Normal[A]]; *)

       (* Update matrix *)
       If [divideBy === DivideBy
	   ,
	   A[[k+1 ;; m, k]] /= A[[k,k]];
	   ,
	   A[[k+1 ;; m, k]] = divideBy[ A[[k+1 ;; m, k]], A[[k,k]] ];
       ];

       If [k < n
	   ,
	   A[[k+1 ;; m, k+1 ;; n]] -= 
	      dot[A[[k+1 ;; m, {k}]], A[[{k}, k+1 ;; n]]];
       ];

       (* Print["A+ = ", Normal[A]]; *)

    ];

    (* Print["k = ", ToString[k]]; *)

    Return[{A, p}];

  ];


  (* LU Decomposition with complete pivoting *)
  (* From Golub and Van Loan, p 118 *)

  Clear[LUCompletePivoting];

  LUCompletePivoting[A_?MatrixQ, f_:Abs] := Module[
    {maxCol, maxRow},

    maxCol = Flatten[Map[LUPartialPivoting[#, f]&, A]];
    maxRow = LUPartialPivoting[
                Apply[Part[A,##]&, MapIndexed[{Part[#2,1],#1}&, maxCol], 2]
                , f];

    Return[{maxRow, maxCol[[maxRow]]}];

  ];

  LUCompletePivoting[A_SparseArray, f_:Abs] := Module[
    {rules, maxElement},

     (* Get rules *)
     rules = ArrayRules[A];

     (* Pick largest *)
     maxElement = LUPartialPivoting[rules[[All,2]], f];

     (* Return (1,1) element if matrix is zero *)
     If[ maxElement == Length[rules],
	{1,1}
       ,
	Part[rules[[maxElement]], 1]
     ]

  ];

  LUDecompositionWithCompletePivoting[AA_?MatrixQ, opts:OptionsPattern[{}]] := 
  Module[
    {options, zeroTest, pivoting, dot,
     A, m, n, rank, p, q, k, N, mu, lambda},

     (* process options *)

     options = Flatten[{opts}];

     zeroTest = ZeroTest
	    /. options
	    /. Options[MatrixDecompositions, ZeroTest];

     pivoting = Pivoting
	    /. options
	    /. Options[LUDecompositionWithCompletePivoting, Pivoting];

     divideBy = DivideBy
	    /. options
	    /. Options[MatrixDecompositions, DivideBy];

     dot = Dot
	    /. options
	    /. Options[MatrixDecompositions, Dot];

     (* start algorithm *)

     A = AA;
     {m,n} = Dimensions[A];
     rank = Min[n,m];
     p = Range[m];
     q = Range[n];
     N = If[n >= m, rank - 1, rank];

     (*
     Print["m = ", m];
     Print["n = ", n];
     Print["N = ", N];
     *)

     For [k = 1, k <= N, k++,

       (* Print["k = ", ToString[k]]; *)

       (* Pivot *)
       {mu, lambda} = pivoting[ A[[k ;; m, k ;; n]] ] + k - 1;

       (* Print["mu = ", mu, "\nlambda = ", lambda]; *)

       (* Interchange rows *)
       A[[{k,mu}, All]] = A[[{mu,k}, All]];

       (* Interchange columns *)
       A[[All, {k,lambda}]] = A[[All, {lambda,k}]];

       (* Store permutations *)
       p[[{k,mu}]] = p[[{mu,k}]];
       q[[{k,lambda}]] = q[[{lambda,k}]];

       (* Print["p = ", p, "\nq = ", q]; *)

       (* If zero pivot, terminate *)
       If[ zeroTest[A[[k,k]]],
	 rank = k - 1;
	 Break[];
       ];

       (* Print["A- = ", Normal[A]]; *)

       (* Update matrix *)
       If [divideBy === DivideBy
	   ,
	   A[[k+1 ;; m, k]] /= A[[k,k]];
	   ,
	   A[[k+1 ;; m, k]] = divideBy[ A[[k+1 ;; m, k]], A[[k,k]] ];
       ];

       If [k < n
	   ,
	   A[[k+1 ;; m, k+1 ;; n]] -= 
	      dot[A[[k+1 ;; m, {k}]], A[[{k}, k+1 ;; n]]];
       ];

       (* Print["A+ = ", Normal[A]]; *)

    ];

    (* Print["k = ", ToString[k]]; *)

    If[ k > N && n >= m && zeroTest[A[[k,k]]],
       rank--;
    ];

    Return[{A, p, q, rank}];

  ];


  (* LU Decomposition with Bunch-Parlett pivoting *)
  (* From Golub and Van Loan, p 168 *)

  LDLDecomposition[AA_?SymmetricMatrixQ, opts:OptionsPattern[{}]] := 
  Module[
    {options, zeroTest,
     A, E, m, rank, p, k, s, i, j, l, mu0, mu1, alpha = N[(1+Sqrt[17])/8]},

     (* process options *)

     options = Flatten[{opts}];

     zeroTest = ZeroTest
	    /. options
	    /. Options[MatrixDecompositions, ZeroTest];


     (* start algorithm *)

     A = AA;
     {m,m} = Dimensions[A];
     rank = m;
     p = Range[m];
     s = {};
     For [k = 1, k <= m - 1, k++,

       Print["k = ", k];

       (* Bunch-Parlett pivot strategy *)
       {i, j} = LUCompletePivoting[ A[[k ;; m, k ;; m]] ];
       l = Max[Map[Abs, Diagonal[  A[[k ;; m, k ;; m]] ]]];

       mu0 = A[[i + k - 1, j + k - 1]];
       mu1 = A[[l + k - 1, l + k - 1]];

       Print["i = ", i];
       Print["j = ", j];
       Print["l = ", l];
       Print["mu0 = ", mu0];
       Print["mu1 = ", mu1];
       Print["alpha mu0 = ", alpha mu0];

       If[ mu1 >= alpha mu0,

	 (* P1 => s = 1 and |e11| = mu1 *)

	 AppendTo[s, 1];

	 Print["s = ", s];

	 (* Interchange rows *)
	 A[[{k,l}, All]] = A[[{l,k}, All]];

	 (* Interchange columns *)
	 A[[All, {k,l}]] = A[[All, {l,k}]];

	 (* Store permutations *)
	 p[[{k,l}]] = p[[{l,k}]];

	 Print["p = ", p];

	 (* If zero pivot, terminate *)
	 If[ zeroTest[A[[k,k]]],
	   rank = k - 1;
	   Break[];
	 ];

	 (* Print["A- = ", MatrixForm[A]]; *)

	 (* Update matrix *)
	 A[[k+1 ;; m, k]] /= A[[k,k]];
	 A[[k+1 ;; m, k+1 ;; n]] -= A[[k+1 ;; m, {k}]] . A[[{k}, k+1 ;; n]];

	 (* Print["A+ = ", MatrixForm[A]]; *)

	 ,

	 (* P1 => s = 2 and |e21| = mu0 *)

	 AppendTo[s, 2];

	 Print["s = ", s];

	 (* Interchange rows *)
	 A[[{k,i}, All]] = A[[{i,k}, All]];

	 (* Interchange columns *)
	 A[[All, {k,i}]] = A[[All, {i,k}]];

	 (* Interchange rows *)
	 A[[{k+1,j}, All]] = A[[{j,k+1}, All]];

	 (* Interchange columns *)
	 A[[All, {k+1,j}]] = A[[All, {j,k+1}]];

	 (* Store permutations *)
	 p[[{k,i}]] = p[[{i,k}]];
	 p[[{k+1,j}]] = p[[{j,k+1}]];

	 Print["p = ", p];

	 (* If zero pivot, terminate *)
	 If[ zeroTest[A[[k+1,k]]],
	   rank = k - 1;
	   Break[];
	 ];

	 Print["A- = ", MatrixForm[A]];

	 (* Update matrix *)
	 E = A[[ k ;; k + 1, k ;; k + 1]];

	 A[[ k + 2 ;; m, k ;; k + 1]] = A[[ k + 2 ;; m, k ;; k + 1 ]] . Inverse[E];
	 A[[ k + 2 ;; m, k + 2 ;; m]] -= A[[ k + 2;; m, k ;; k + 1 ]] . A[[ k ;; k + 1, k + 2 ;; m ]];

	 A[[ k ;; k + 1, k + 2 ;; m]] = Transpose[A[[ k + 2;; m, k ;; k + 1 ]]];

	 Print["E = ", MatrixForm[E]];
	 Print["A+ = ", MatrixForm[A]];

	 (* Increment k *)
	 k++;

       ];

    ];

    If[ k > m && zeroTest[A[[k,k]]],
       rank--;
    ];

    Return[{A, p, s, rank}];

  ];

End[]

EndPackage[]
