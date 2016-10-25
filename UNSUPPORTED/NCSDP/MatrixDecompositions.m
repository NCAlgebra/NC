(* :Title: 	MatrixDecompositions.m *)

(* :Authors: 	Mauricio C. de Oliveira and Burack Guven *)

(* :Context: 	MatrixDecompositions` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "MatrixDecompositions`" ];

Options[MatrixDecompositions] = {
  ZeroTest -> PossibleZeroQ
};

Clear[GetLUMatrices];
GetLUMatrices::usage="";

Clear[LUDecompositionWithCompletePivoting];
LUDecompositionWithCompletePivoting::usage="";

Clear[LDLDecomposition];
LDLDecomposition::usage="";

Options[LUDecompositionWithCompletePivoting] = {
  Pivoting -> LUCompletePivoting
};

Begin[ "`Private`" ]

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

(* LU Decomposition with complete pivoting *)
(* From Golub and Van Loan, p 118 *)

Clear[LUCompletePivoting];

LUCompletePivoting[A_SparseArray] := Module[
  {rules, maxElement},

   (* Get rules *)
   rules = ArrayRules[A];

   (* Pick largest *)
   maxElement = Part[Ordering[rules, 1, (Abs[#1[[2]]] > Abs[#2[[2]]]) &], 1];

   (* Return (1,1) element if matrix is zero *)
   If[ maxElement == Length[rules],
      Return[{1,1}]
     ,
      Return[Part[rules[[maxElement]], 1]]
   ]

];

LUCompletePivoting[A_?MatrixQ] := Module[
  {maxCol, maxRow},
  
  maxCol = Flatten[Map[Ordering[Abs[#],-1]&, A]];
  maxRow = Part[Ordering[Abs[Apply[Part[A,##]&, MapIndexed[{Part[#2,1],#1}&, maxCol], 2]],-1],1];

  Return[{maxRow, maxCol[[maxRow]]}];

];

LUDecompositionWithCompletePivoting[AA_?MatrixQ, opts:OptionsPattern[{}]] := 
Module[
  {options, zeroTest,
   A, m, n, rank, p, q, k, N, mu, lambda},

   (* process options *)

   options = Flatten[{opts}];

   zeroTest = ZeroTest
          /. options
	  /. Options[MatrixDecompositions, ZeroTest];


   (* start algorithm *)

   A = AA;
   {m,n} = Dimensions[A];
   rank = Min[n,m];
   p = Range[m];
   q = Range[n];
   N = If[n >= m, rank - 1, rank];
   For [k = 1, k <= N, k++,

     (* Find max pivot *)
     {mu, lambda} = LUCompletePivoting[ A[[k ;; m, k ;; n]] ] + k - 1;

     (*
       Print["mu = ", mu];
       Print["lambda = ", lambda];
     *)

     (* Interchange rows *)
     A[[{k,mu}, All]] = A[[{mu,k}, All]];

     (* Interchange columns *)
     A[[All, {k,lambda}]] = A[[All, {lambda,k}]];

     (* Store permutations *)
     p[[{k,mu}]] = p[[{mu,k}]];
     q[[{k,lambda}]] = q[[{lambda,k}]];

     (*
       Print["p = ", p];
       Print["q = ", q];
     *)

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

  ];

  If[ k > N && zeroTest[A[[k,k]]],
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
