# MatrixDecompositions {#PackageMatrixDecompositions}

**MatrixDecompositions** is a package that implements various linear algebra algorithms, such as *LU Decomposition* with *partial* and *complete pivoting*, and *LDL Decomposition*. The algorithms have been written with correctness and easy of customization rather efficiency as the main goals. They were originally developed to serve as the noncommutative linear algebra algorithms for [NCAlgebra](http://math.ucsd.edu/~ncalg).

Members are:

* Decompositions
    * [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting)
    * [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting)
    * [LDLDecomposition](#LDLDecomposition)
* Solvers
    * [LowerTriangularSolve](#LowerTriangularSolve)
    * [UpperTriangularSolve](#UpperTriangularSolve)
    * [LUInverse](#LUInverse)
* Utilities
    * [GetLUMatrices](#GetLUMatrices)
    * [GetLDUMatrices](#GetLDUMatrices)
    * [LUPartialPivoting](#LUPartialPivoting)
    * [LUCompletePivoting](#LUCompletePivoting)

## LUDecompositionWithPartialPivoting {#LUDecompositionWithPartialPivoting}

`LUDecompositionWithPartialPivoting[m]` generates a representation of the LU decomposition of the rectangular matrix `m`.

`LUDecompositionWithPartialPivoting[m, options]` uses `options`.

`LUDecompositionWithPartialPivoting` returns a list of two elements:

- the first element is a combination of upper- and lower-triangular matrices;
- the second element is a vector specifying rows used for pivoting.

`LUDecompositionWithPartialPivoting` is similar in functionality with the built-in `LUDecomposition`. It implements a *partial pivoting* strategy in which the sorting can be configured using the options listed below. It also applies to general rectangular matrices as well as square matrices.

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `Divide` (`Divide`): function used to divide a vector by an entry;
- `Dot` (`Dot`): function used to multiply vectors and matrices;
- `Pivoting` (`LUPartialPivoting`): function used to sort rows for pivoting;

See also:
[LUDecomposition](#LUDecomposition), [GetLUMatrices](#GetLUMatrices), [LUPartialPivoting](#LUPartialPivoting), [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting).

## LUDecompositionWithCompletePivoting {#LUDecompositionWithCompletePivoting}

`LUDecompositionWithCompletePivoting[m]` generates a representation of the LU decomposition of the rectangular matrix `m`.

`LUDecompositionWithCompletePivoting[m, options]` uses `options`.

`LUDecompositionWithCompletePivoting` returns a list of four elements:

- the first element is a combination of upper- and lower-triangular matrices;
- the second element is a vector specifying rows used for pivoting.
- the third element is a vector specifying columns used for pivoting.
- the fourth element is the rank of the matrix.

`LUDecompositionWithCompletePivoting` implements a *complete pivoting* strategy in which the sorting can be configured using the options listed below. It also applies to general rectangular matrices as well as square matrices.

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `Divide` (`Divide`): function used to divide a vector by an entry;
- `Dot` (`Dot`): function used to multiply vectors and matrices;
- `Pivoting` (`LUCompletePivoting`): function used to sort rows for pivoting;

See also:
[LUDecomposition](#LUDecomposition), [GetLUMatrices](#GetLUMatrices), [LUCompletePivoting](#LUCompletePivoting), [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting).

## LDLDecomposition {#LDLDecomposition}

## GetLUMatrices {#GetLUMatrices}

## GetLDUMatrices {#GetLDUMatrices}

## UpperTriangularSolve {#UpperTriangularSolve}

## LowerTriangularSolve {#LowerTriangularSolve}

## LUInverse {#LUInverse}

## LUPartialPivoting {#LUPartialPivoting}

## LUCompletePivoting {#LUCompletePivoting}
