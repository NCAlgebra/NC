## NCMatrixDecompositions {#PackageNCMatrixDecompositions}

`NCMatrixDecompositions` provide noncommutative versions of the linear algebra algorithms in the package [MatrixDecompositions](#PackageMatrixDecompositions).

See the documentation for the package
[MatrixDecompositions](#PackageMatrixDecompositions) for details on
the algorithms and options.

Members are:

* Decompositions
    * [NCLUDecompositionWithPartialPivoting](#NCLUDecompositionWithPartialPivoting)
    * [NCLUDecompositionWithCompletePivoting](#NCLUDecompositionWithCompletePivoting)
    * [NCLDLDecomposition](#NCLDLDecomposition)
* Solvers
    * [NCLowerTriangularSolve](#NCLowerTriangularSolve)
    * [NCUpperTriangularSolve](#NCUpperTriangularSolve)
    * [NCLUInverse](#NCLUInverse)
* Utilities
    * [NCLUCompletePivoting](#NCLUCompletePivoting)
    * [NCLUPartialPivoting](#NCLUPartialPivoting)
    * [NCLeftDivide](#NCLeftDivide)
    * [NCRightDivide](#NCRightDivide)

### NCLUDecompositionWithPartialPivoting {#NCLUDecompositionWithPartialPivoting}

`NCLUDecompositionWithPartialPivoting` is a noncommutative version of
[NCLUDecompositionWithPartialPivoting](#NCLUDecompositionWithPartialPivoting).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` ([NCRightDivide](#NCRightDivide)): function used to divide a vector by an entry;
- `Dot` ([NCDot](#NCDot)): function used to multiply vectors and matrices;
- `Pivoting` ([NCLUPartialPivoting](#NCLUPartialPivoting)): function used to sort rows for pivoting;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting).

### NCLUDecompositionWithCompletePivoting {#NCLUDecompositionWithCompletePivoting}

`NCLUDecompositionWithCompletePivoting` is a noncommutative version of
[NCLUDecompositionWithCompletePivoting](#NCLUDecompositionWithCompletePivoting).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` ([NCRightDivide](#NCRightDivide)): function used to divide a vector by an entry;
- `Dot` ([NCDot](#NCDot)): function used to multiply vectors and matrices;
- `Pivoting` ([NCLUCompletePivoting](#NCLUCompletePivoting)): function used to sort rows for pivoting;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting).

### NCLDLDecomposition {#NCLDLDecomposition}

`NCLDLDecomposition` is a noncommutative version of [LDLDecomposition](#LDLDecomposition).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` ([NCRightDivide](#NCRightDivide)): function used to divide a vector by an entry on the right;
- `LeftDivide` ([NCLeftDivide](#NCLeftDivide)): function used to divide a vector by an entry on the left;
- `Dot` (`NCDot`): function used to multiply vectors and matrices;
- `CompletePivoting` ([NCLUCompletePivoting](#NCLUCompletePivoting)): function used to sort rows for complete pivoting;
- `PartialPivoting` ([NCLUPartialPivoting](#NCLUPartialPivoting)): function used to sort matrices for complete pivoting;
- `Inverse` ([NCLUInverse](#NCLUInverse)): function used to invert 2x2 diagonal blocks;
- `SelfAdjointMatrixQ` ([NCSelfAdjointQ](#NCSelfAdjointQ)): function to test if matrix is self-adjoint;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting).

### NCUpperTriangularSolve {#NCUpperTriangularSolve}

`NCUpperTriangularSolve` is a noncommutative version of [UpperTriangularSolve](#UpperTriangularSolve).

See also: [UpperTriangularSolve](#UpperTriangularSolve).

### NCLowerTriangularSolve {#NCLowerTriangularSolve}

`NCLowerTriangularSolve` is a noncommutative version of [LowerTriangularSolve](#LowerTriangularSolve).

See also: [LowerTriangularSolve](#LowerTriangularSolve).

### NCLUInverse {#NCLUInverse}

`NCLUInverse` is a noncommutative version of [LUInverse](#LUInverse).

See also: [LUInverse](#LUInverse).

### NCLUPartialPivoting {#NCLUPartialPivoting}

`NCLUPartialPivoting` is a noncommutative version of [LUPartialPivoting](#LUPartialPivoting).

See also: [LUPartialPivoting](#LUPartialPivoting).

### NCLUCompletePivoting {#NCLUCompletePivoting}

`NCLUCompletePivoting` is a noncommutative version of [LUCompletePivoting](#LUCompletePivoting).

See also: [LUCompletePivoting](#LUCompletePivoting).

### NCLeftDivide {#NCLeftDivide}

`NCLeftDivide[x,y]` divides each entry of the list `y` by `x` on the left.

For example:

    NCLeftDivide[x, {a,b,c}]
	
returns

	{inv[x]**a, inv[x]**b, inv[x]**c}

See also: [NCRightDivide](#NCRightDivide).

### NCRightDivide {#NCRightDivide}

`NCRightDivide[x,y]` divides each entry of the list `x` by `y` on the right.

For example:

    NCRightDivide[{a,b,c}, y]
	
returns

	{a**inv[y], b**inv[y], c**inv[y]}

See also: [NCLeftDivide](#NCLeftDivide).


