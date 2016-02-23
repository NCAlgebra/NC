(* :Title: 	Kronecker.m *)

(* :Author: 	Mauricio C. de Oliveira *)

(* :Context: 	Kronecker` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "Kronecker`" ]

Clear[Kronecker];
Kronecker::usage = "Computes the Kronecker product of two matrices.";
Kronecker::FailedToLinkCCode = "Failed to link fast C code for Kronecker product evaluation. Using Mathematica version instead. WARNING: THIS IS REALLY SLOW!";

Clear[MKronecker];
MKronecker::usage = "Computes the Kronecker product of two matrices (Mathematica version).";

Clear[KroneckerDiagonal];
KroneckerDiagonal::usage = "Computes the diagonal of the Kronecker product of two matrices.";
KroneckerDiagonal::FailedToLinkCCode = "Failed to link fast C code for KroneckerDiagonal evaluation. Using Mathematica version instead.";

Clear[MKroneckerDiagonal];
MKroneckerDiagonal::usage = "Computes the diagonal of the Kronecker product of two matrices (Mathematica version).";

Clear[ToMatrix];
ToMatrix::usage = "ToMatrix[v] converts the vector v into a square matrix.
ToMatrix[v,m] converts the vector v into a rectangular matrix with column size m";

Clear[ToSymmetricMatrix];
ToMatrix::usage = "ToMatrix[v] converts the vector v into a square symmetric matrix.";

Clear[ToVector];
ToVector::usage = "ToVector[M] converts the matrix M into a column vector.";

Clear[SymmetricToVector];
SymmetricToVector::usage = "ToVector[M] converts the lower triangular part of the symmetric matrix M into a column vector.";

Clear[TransposePermutation];
TransposePermutation::usage = "TransposePermutation[m,n] ...";

Clear[LowerTriangularProjection];
LowerTriangularProjection::usage = "";

Clear[UpperTriangularProjection];
UpperTriangularProjection::usage = "";

Clear[DiagonalProjection];
DiagonalProjection::usage = "";

Clear[IdK];
IdK::usage = "Yet to come.";

Clear[KroneckerTranspose];
KroneckerTranspose::usage = "Kronecker for coefficients of transposed variables"

Clear[KroneckerDimensions];
KroneckerDimensions::usage = "";

Begin[ "`Private`" ]

InstallCKron = False;
InstallCKronDiag = False;

KMatrixQ[m_] := MatrixQ[m, NumberQ];

(* to vector operator *)
ToVector[a_?MatrixQ] := Flatten[Transpose[a]];
ToVector[a_?NumberQ] := a;

ToVector[a_?MatrixQ, ToMatrix] := Transpose[{Flatten[Transpose[a]]}];

SymmetricToVector[a_?MatrixQ, 2] := 
  Part[Flatten[a + Transpose[a] - DiagonalMatrix[Tr[a,List]]], LowerTriangularProjection @@ Dimensions[a]];

SymmetricToVector[a_?MatrixQ, _:1] := 
  Part[Flatten[a], LowerTriangularProjection @@ Dimensions[a]];

(* to matrix operator *)
ToMatrix[a_SparseArray, m_Integer] := Transpose[Partition[a, m]] /; (Depth[a] == 2);
ToMatrix[a_?VectorQ, m_Integer] := Transpose[Partition[a, m]];
ToMatrix[a_?VectorQ] := ToMatrix[a, Sqrt[Part[Dimensions[a],1]]];

ToSymmetricMatrix[a_?VectorQ, m_Integer] := Module[
  { tmp = ConstantArray[0, {m*m}] },

  Part[tmp, LowerTriangularProjection[m,m]] = a;
  tmp = ToMatrix[tmp, m];

  Return[ tmp + Transpose[tmp] - DiagonalMatrix[Diagonal[tmp]] ];

];
ToSymmetricMatrix[a_?VectorQ] := 
  ToSymmetricMatrix[a, Sqrt[Part[Dimensions[a],1]]];

(* Kronecker Mathematica versions *)
MKronecker[a_?KMatrixQ,b_?KMatrixQ] := 
  ArrayFlatten[Array[Part[Outer[Times,a,b],#1,#2]&,Dimensions[a]]];

(* Install C versions of Kronecker *)
Kronecker[a_?KMatrixQ,b_?KMatrixQ] := MKronecker[a,b];
If[ InstallCKron,
  If[ Install["CKron"] === $Failed, 
    Message[ Kronecker::FailedToLinkCCode ];
    ,
    Kronecker[a_?KMatrixQ,b_?KMatrixQ] := Kronecker`CKron[a,b];
  ];
];

(* 

  KroneckerDiagonal[a,b] 

  Computes the diagonal entries of the matrix 
    AB = Kronecker[a,b],
  i.e., 
    KroneckerDiagonal[a,b] = Tr[AB,List].

  We have:
    AB ToVector[ H ] = ToVector[ B H A^T ]

  Dimensions:    
          A: mA x nA,
          B: mB x nB,
          H: nB x nA,
    B H A^T: mB x mA,
         AB: mA mB x nA nB.

  The diagonal entry (k,k) of AB is 
    E_k^T AB e_k,  k = 1..Min[mA mB, nA nB]
  where 
    e_k = ToVector[e_i e_j^T],  i = 1..nB, j = 1..nA. 
    E_k = ToVector[e_r e_s^T],  r = 1..mB, s = 1..mA.

    (k - 1) = (j - 1) * nB + (i - 1) = (s - 1) * mB + (r - 1)

  Since, 
    AB e_k = ToVector[ B e_i e_j^T A^T ], 
           = ToVector[ B_i A_j^T ],      i = 1..nB, j = 1..nA.

    E_k^T AB e_k = ToVector[e_r e_s^T]^T ToVector[ B_i A_j^T ]
                 = Trace[ e_s e_r^T B_i A_j^T ]
                 = Trace[ e_r^T B_i A_j^T e_s ]
                 = e_r^T B_i A_j^T e_s
                 = B_ri A_sj

  Particular case: 
    mB = nB => r = i, s = j

*)

MKroneckerDiagonal[a_?KMatrixQ,b_?KMatrixQ] :=
  Distribute[ f[ Tr[a, List], Tr[b, List] ], List, f, List, Times] /; Part[ Dimensions[b], 1 ] === Part[ Dimensions[b], 2 ]

MKroneckerDiagonal[a_?KMatrixQ,b_?KMatrixQ] := Module[
  { dim, mA, mB, nA, nB, si, sj },

  {mA, nA} = Dimensions[a];
  {mB, nB} = Dimensions[b];

  dim = Min[ mA * mB, nA * nB ]; 

  ri = Table[{Mod[k - 1, mB] + 1, Mod[k - 1, nB] + 1}, {k, dim}];
  sj = Table[{Quotient[k - 1, mB] + 1, Quotient[k - 1, nB] + 1}, {k, dim}];

  Return [
    Apply[Part[a, #1, #2]&, sj, 1] * Apply[Part[b, #1, #2]&, ri, 1]
  ]

];

(*

  KroneckerDiagonal[a,b,Transpose] 

  Computes the diagonal entries of the matrix 
    ABT = Kronecker[a,b,Transpose],
  i.e., 
    KroneckerDiagonal[a,b,Transpose] = Tr[ABT,List].

  We have:
    ABT ToVector[ H ] = ToVector[ B H^T A^T ]

  Dimensions:    
            A: mA x nA,
            B: mB x nB,
            H: nA x nB,
    B H^T A^T: mB x mA,
          ABT: mA mB x nA nB.

  The diagonal entry (k,k) of AB is 
    E_k^T ABT e_k,  k = 1..Min[mA mB, nA nB]
  where 
    e_k = ToVector[e_j e_i^T],  i = 1..nA, j = 1..nB. 
    E_k = ToVector[e_r e_s^T],  r = 1..mB, s = 1..mA.

    (k - 1) = (j - 1) * nA + (i - 1) = (s - 1) * mB + (r - 1)

  Since, 
    AB e_k = ToVector[ B e_j e_i^T A^T ], 
           = ToVector[ B_j A_i^T ],      i = 1..nA, j = 1..nB.

    E_k^T AB e_k = ToVector[e_r e_s^T]^T ToVector[ B_j A_i^T ]
                 = Trace[ e_s e_r^T B_j A_i^T ]
                 = Trace[ e_r^T B_j A_i^T e_s ]
                 = e_r^T B_j A_i^T e_s
                 = B_rj A_si

*)

MKroneckerDiagonal[a_?KMatrixQ,b_?KMatrixQ,Transpose] := Module[
  { dim, mA, mB, nA, nB, rj, si },

  {mA, nA} = Dimensions[a];
  {mB, nB} = Dimensions[b];

  dim = Min[ mA * mB, nA * nB ]; 

  rj = Table[{Mod[k - 1, mB] + 1, Quotient[k - 1, nA] + 1}, {k, dim}];
  si = Table[{Quotient[k - 1, mB] + 1, Mod[k - 1, nA] + 1}, {k, dim}];

  Return [
    Apply[Part[a, #1, #2]&, si, 1] * Apply[Part[b, #1, #2]&, rj, 1]
  ]

];

KroneckerDiagonal[a_?KMatrixQ,b_?KMatrixQ] := MKroneckerDiagonal[a,b];
KroneckerDiagonal[a_?KMatrixQ,b_?KMatrixQ,Transpose] := MKroneckerDiagonal[a,b,Transpose];
If[ InstallCKronDiag,
  If[ Install["CKronDiag"] === $Failed, 
    Message[ KroneckerDiagonal::FailedToLinkCCode ];
    ,
    KroneckerDiagonal[a_?KMatrixQ,b_?KMatrixQ] := Kronecker`CKronDiag[a,b];
  ];
];

(* Transpose permutation *)
TransposePermutation[m_Integer, n_Integer] :=
  Flatten[ Transpose[Partition[ Range[1, m * n], m]] ]

(* Lower triangular projection *)
LowerTriangularProjection[m_Integer, n_Integer] := 
  Flatten[
    MapIndexed[
      Drop[#1, Min[#2[[1]] - 1, m]]&
     ,Partition[ Range[1, m*n], m]
    ]
  ];

(* Upper triangular projection *)
UpperTriangularProjection[m_Integer, n_Integer] := 
  Flatten[
    MapIndexed[
      Drop[#1, Min[#2[[1]] - 1, n]]&
     ,Transpose[Partition[ Range[1, m*n], m]]
    ]
  ];

(* Diagonal projection *)
DiagonalProjection[m_Integer, n_Integer] := 
  Table[(i - 1) m + i, {i, Min[m, n]}];

(* Kronecker Transpose *)
Unprotect[KroneckerProduct];
KroneckerProduct[a_?KMatrixQ,b_?KMatrixQ,Transpose] := 
  Part[
    KroneckerProduct[a,b],
    All,
    TransposePermutation[Part[Dimensions[b],2], Part[Dimensions[a],2]]
 ];
Protect[KroneckerProduct];


(* Kronecker Transpose *)
KroneckerDimensions[x_?MatrixQ,m_] := Part[Dimensions[x], m];

KroneckerTranspose[0] := 0;
KroneckerTranspose[a_KroneckerProduct] := 
  KroneckerTranspose[a, KroneckerDimensions[a[[1]],2], KroneckerDimensions[a[[2]],2] ];

KroneckerTranspose[a_KroneckerProduct + b__] := 
  KroneckerTranspose[a + b, KroneckerDimensions[a[[1]],2], KroneckerDimensions[a[[2]],2] ];

KroneckerTranspose[a_?KMatrixQ, m_Integer, n_Integer] := 
  Part[
    a,
    All,
    TransposePermutation[m, n]
 ];

End[]

EndPackage[]
