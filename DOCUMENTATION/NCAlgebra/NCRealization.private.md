Private members are:

* [RJRTDecomposition](#RJRTDecomposition)
* [BlockDiagonalMatrix](#BlockDiagonalMatrix)
* [CGBMatrixToBigCGB](#CGBMatrixToBigCGB)
* [CGBToPencil](#CGBToPencil)
* [MatMultFromLeft](#MatMultFromLeft)
* [MatMultFromRight](#MatMultFromRight)
* [NCFindPencil](#NCFindPencil)
* [NCFormControllabilityColumns](#NCFormControllabilityColumns)
* [NCFormLettersFromPencil](#NCFormLettersFromPencil)
* [NCLinearQ](#NCLinearQ)
* [NCLinearPart](#NCLinearPart)
* [NCNonLinearPart](#NCNonLinearPart)
* [NCListToPencil](#NCListToPencil)
* [NCPencilToList](#NCPencilToList)
* [NCMakeMonic](#NCMakeMonic)

### RJRTDecomposition {#RJRTDecomposition}

`RJRTDecomposition[SymmetricMatrix_,opts___]`. Returns `{R,J}` such that `SymmetricMatrix == R.J.Transpose[R]` and `J` is a signature matrix. Returns the answer in floating point unless the optional argument `UseFloatingPoint->False` is used. Floating point is necessary except for small examples because eigenvectors and eigenvalues are calculated in the algorithm.

### BlockDiagonalMatrix {#BlockDiagonalMatrix}

`BlockDiagonalMatrix[ListOfMatrices]` returns the block diagonal
 matrix with the matrices in `ListOfMatrix` on the diagonal. Each
 matrix in `ListOfMatrices` can be arbitrary size. i.e. the output
 matrix doesn't have to be square.

### CGBMatrixToBigCGB {#CGBMatrixToBigCGB}
`CGBMatrixToBigCGB[MatrixOfCGB]` returns a list of 3 matrices `{C, G, B}` such
 that `MatMult[C, NCInverse[G], B]` is the original matrix that the `MatrixOfCGB` was derived from.

### CGBToPencil {#CGBToPencil}
`CGBToPencil[CGB]` takes the list of 3 matrices returned by `NCDescriptorRealization` and returns a matrix with linear entries which has a Schur Complement equivalent to the rational expression that the CGB realization represents.

### MatMultFromLeft {#MatMultFromLeft}
`MatMultFromLeft[A,B,C,...]` is the default of `MatMult`. If you want the matrix
 multiplications to start on the left. This is most efficient, for example, if the first matrix is a vector (1-by-n) and the rest are square matrices (n-by-n).

### MatMultFromRight {#MatMultFromRight}
`MatMultFromRight[A,B,C,...]`. It's often more efficient to perform multiplication of several matrices starting from the right. For example, if the last matrix is a vector (n-by-1) and the rest are square matrices (n-by-n).

### NCFindPencil {#NCFindPencil}
`NCFindPencil[Expression,Unknowns]` returns a matrix with linear entries in the
 `Unknowns` (Linear Pencil) such that a Schur Complement of the matrix is the original Expression. Expression can be a rational function or a matrix with rational function entries.

### NCFormControllabilityColumns {#NCFormControllabilityColumns}
`NCFormControllabilityColumns[A_List,B_,opts___]`. Given the realization `MatMult[C, NCInverse[I-A], B]`, this returns a matrix such that the columns of its transpose span the controllability space.

With optional argument `ReturnWordList->False`, the output is `{Matrix,ListOfWords}` where `ListOfWords` is a list of the words used to make the spaning vectors. i.e. The output `ListOfWords == {{},{1},{3,1}}` would correspond to the vectors `{B, A[[1]].B, A[[3]].A[[1]].B}`

Optional argument `Verbose->True`, prints information as it's working.

### NCFormLettersFromPencil {#NCFormLettersFromPencil}
`NCFormLettersFromPencil[A_List,B_]`. Given a realization $C.A^{-1}.B$,
 where `A = A0 + A1*x1 + A2*x2 +...+An*xn`, this returns the list `{ inv[A0].A1, inv[A0].A2,...,inv[A0].An,inv[A0].B}`. These are the letters that are used when finding the controllability and observability spaces.

### NCLinearPart {#NCLinearPart}
`NCLinearPart[RationalExpression,UnknownVariables]` returns the part of `RationalExpression` that is linear in (a list of) `UnknownVariables`.

`RationalExpression` is NOT expanded, so in effect what gets returned is a sum of monomial terms each of which is linear. `NCLinearPart[(inv[x] + A) ** x, {x}] returns (inv[x] + A) ** x` which is actually linear (`NCLinearQ == True`). But, `NCLinearPart[(x + inv[x]) ** x, {x}]` returns `0` since `(x + inv[x]) ** x` is not ENTIRELY linear. `NCLinearPart + NCNonLinearPart == RationalExpression`.

### NCLinearQ {#NCLinearQ}
`NCLinearQ[RationalExpression, UnknownVariables]` returns `True` if `RationalExpression` is linear in (a list of) `UnknownVariables`, `False` otherwise. `NCLinearQ` expands expressions using `NCExpand` first, then determines linearity, so `(inv[x]+A)**x` is actually linear in `x`.

### NCListToPencil {#NCListToPencil}

`NCListToPencil[ListOfMatrices,Unknowns]` creates a linear pencil.

For example, `NCListToPencil[{A0,A1,A2},{1,x,y}]` is `A0 + A1**x + A2**y`.

### NCMakeMonic {#NCMakeMonic}

`NCMakeMonic[{CC_,Pencil_,BB_},Unknowns_]` returns a descriptor realization `{C2,Pencil2,B2}` that is monic. For this to be possible, the realization must represent a rational function that's not zero at the origin.

### NCNonLinearPart {#NCNonLinearPart}

`NCNonLinearPart[RationalExpression,UnknownVariables]` returns the part of `RationalExpression` that is not linear in (a list of) `UnknownVariables`. `RationalExpression` is NOT expanded, SO in effect what gets returned is a sum of monomial terms each of which is not linear (`NCLinearQ = False`). `NCNonLinearPart[(inv[x] + A) ** x, {x}]` returns 0 since `(inv[x] + A) ** x` is actually linear. `NCNonLinearPart[ y + (x + inv[x]) ** x, {x,y}]` returns `(x + inv[x]) ** x` since `(x + inv[x]) ** x` is nonlinear as a whole (but `y` isn't). `NCLinearPart + NCNonLinearPart == RationalExpression`.

### NCPencilToList {#NCPencilToList}

`NCPencilToList[Pencil,Unknowns]` takes a matrix `Pencil` (linear in the `Unknowns`) and returns a list of matrices `{A0,A1,A2,...}` such that `Pencil == A0 + A1*Unknowns[[1]] + A2*Unkowns[[2]] + ...`
