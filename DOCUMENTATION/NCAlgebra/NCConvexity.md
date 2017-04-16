## NCConvexity {#PackageNCConvexity}

**NCConvexity** is a package that provides functionality to determine whether a rational or polynomial noncommutative function is convex.

Members are:

* [NCIndependent](#NCIndependent)
* [NCConvexityRegion](#NCConvexityRegion)

### NCIndependent {#NCIndependent}

`NCIndependent[list]` attempts to determine whether the nc entries of `list` are independent.

Entries of `NCIndependent` can be nc polynomials or nc rationals.

For example:

    NCIndependent[{x,y,z}]

return *True* while

    NCIndependent[{x,0,z}]
    NCIndependent[{x,y,x}]
    NCIndependent[{x,y,x+y}]
    NCIndependent[{x,y,A x + B y}]
    NCIndependent[{inv[1+x]**inv[x], inv[x], inv[1+x]}]

all return *False*.

See also:
[NCConvexityRegion](#NCConvexityRegion).

### NCConvexityRegion {#NCConvexityRegion}

`NCConvexityRegion[expr,vars]` is a function which can be used to determine whether the nc rational `expr` is convex in `vars` or not.

For example:

    d = NCConvexityRegion[x**x**x, {x}];

returns

    d = {2 x, -2 inv[x]}

from which we conclude that `x**x**x` is not convex in `x` because $x \succ 0$ and $-{x}^{-1} \succ 0$ cannot simultaneously hold.

`NCConvexityRegion` works by factoring the `NCHessian`, essentially calling:

    hes = NCHessian[expr, {x, h}];

then 

    {lt, mq, rt} = NCMatrixOfQuadratic[hes, {h}]

to decompose the Hessian into a product of a left row vector, `lt`, times a middle matrix, `mq`, times a right column vector, `rt`. The middle matrix, `mq`, is factored using the `NCLDLDecomposition`:

    {ldl, p, s, rank} = NCLDLDecomposition[mq];
    {lf, d, rt} = GetLDUMatrices[ldl, s];

from which the output of NCConvexityRegion is the a list with the block-diagonal entries of the matrix `d`.

See also:
[NCHessian](#NCHessian), [NCMatrixOfQuadratic](#NCMatrixOfQuadratic), [NCLDLDecomposition](#NCLDLDecomposition).

