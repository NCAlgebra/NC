## NCMatMult {#PackageNCMatMult}

Members are:

* [tpMat](#tpMat)
* [ajMat](#ajMat)
* [coMat](#coMat)
* [MatMult](#MatMult)
* [NCInverse](#NCInverse)
* [NCMatrixExpand](#NCMatrixExpand)

### tpMat {#tpMat}

`tpMat[mat]` gives the transpose of matrix `mat` using `tp`.

See also:
[ajMat](#tpMat), [coMat](#coMat), [MatMult](#MatMult).

### ajMat {#ajMat}

`ajMat[mat]` gives the adjoint transpose of matrix `mat` using `aj` instead of `ConjugateTranspose`.

See also:
[tpMat](#tpMat), [coMat](#coMat), [MatMult](#MatMult).

### coMat {#coMat}

`coMat[mat]` gives the conjugate of matrix `mat` using `co` instead of `Conjugate`.

See also:
[tpMat](#tpMat), [ajMat](#coMat), [MatMult](#MatMult).

### MatMult {#MatMult}

`MatMult[mat1, mat2, ...]` gives the matrix multiplication of `mat1`, `mat2`, ... using `NonCommutativeMultiply` rather than `Times`.

See also:
[tpMat](#tpMat), [ajMat](#coMat), [coMat](#coMat).

**Notes:**

The experienced matrix analyst should always remember that the Mathematica convention for handling vectors is tricky.

- `{{1,2,4}}` is a 1x3 *matrix* or a *row vector*;
- `{{1},{2},{4}}` is a 3x1 *matrix* or a *column vector*;
- `{1,2,4}` is a *vector* but **not** a *matrix*. Indeed whether it is a row or column vector depends on the context. We advise not to use *vectors*.

### NCInverse {#NCInverse}

`NCInverse[mat]` gives the nc inverse of the square matrix `mat`. `NCInverse` uses partial pivoting to find a nonzero pivot.

`NCInverse` is primarily used symbolically. Usually the elements of the inverse matrix are huge expressions.
We recommend using `NCSimplifyRational` to improve the results.

See also:
[tpMat](#tpMat), [ajMat](#coMat), [coMat](#coMat).

### NCMatrixExpand {#NCMatrixExpand}

`NCMatrixExpand[expr]` expands `inv` and `**` of matrices appearing in nc expression `expr`. It effectively substitutes `inv` for `NCInverse` and `**` by `MatMult`.

See also:
[NCInverse](#NCInverse), [MatMult](#MatMult).
