# More Advanced Commands {#MoreAdvancedCommands}

In this chapter we describe some more advance features and
commands. Most of these were introduced in **Version 5**.

## Matrices

Starting at **Version 5** the operators `**` and `inv` apply also to
matrices. However, in order for `**` and `inv` to continue to work as
full fledged operators, the result of multiplications or inverses of
matrices is held unevaluated until the user calls
[`NCMatrixExpand`](#NCMatrixExpand). This is in the the same spirit as
good old fashion commutative operations in Mathematica.

For example, with

	m1 = {{a, b}, {c, d}}
	m2 = {{d, 2}, {e, 3}}
	
the call

	m1**m2

results in 

	{{a, b}, {c, d}}**{{d, 2}, {e, 3}}

Upon calling

	m1**m2 // NCMatrixExpand

evaluation takes place returning

	{{a**d + b**e, 2a + 3b}, {c**d + d**e, 2c + 3d}}
	
which is what would have been by calling `NCDot[m1,m2]`[^matmult]. Likewise

	inv[m1]

results in

	inv[{{a, b}, {c, d}}]

and

	inv[m1] // NCMatrixExpand
	
returns the evaluated result

	{{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
	 {-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}

[^matmult]: Formerly `MatMult[m1,m2]`.

A less trivial example is

	m3 = m1**inv[IdentityMatrix[2] + m1] - inv[IdentityMatrix[2] + m1]**m1

that returns 

	-inv[{{1 + a, b}, {c, 1 + d}}]**{{a, b}, {c, d}} + 
	    {{a, b}, {c, d}}**inv[{{1 + a, b}, {c, 1 + d}}]

Expanding

	NCMatrixExpand[m3]

results in

	{{b**inv[b - (1 + a)**inv[c]**(1 + d)] - inv[c]**(1 + (1 + d)**inv[b - 
	    (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c])**c - a**inv[c]**(1 + d)**inv[b - 
	    (1 + a)**inv[c]**(1 + d)] + inv[c]**(1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**a, 
	  a**inv[c]**(1 + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c]) - 
	    inv[c]**(1 + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c])**d - 
		b**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c] + inv[c]**(1 + d)**inv[b - 
		(1 + a)**inv[c]**(1 + d)]** b}, 
	 {d**inv[b - (1 + a)**inv[c]**(1 + d)] - (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)] - 
	    inv[b - (1 + a)**inv[c]**(1 + d)]**a + inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a), 
	  1 - inv[b - (1 + a)**inv[c]**(1 + d)]**b - d**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + 
	    a)**inv[c] + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c] + 
		inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c]**d}}
	
and finally 

	NCMatrixExpand[m3] // NCSimplifyRational	
	
returns

	{{0, 0}, {0, 0}}
	
as expected.

**WARNING:** Mathematica's choice of treating lists and matrix
indistinctively can cause much trouble when mixing `**` with `Plus`
(`+`) operator. For example, the expression

	m1**m2 + m2**m1
	
results in

	{{a, b}, {c, d}}**{{d, 2}, {e, 3}} + {{d, 2}, {e, 3}}**{{a, b}, {c, d}}
	
and 
	
	m1**m2 + m2**m1 // NCMatrixExpand
	
produces the expected result

	{{2 c + a**d + b**e + d**a, 2 a + 3 b + 2 d + d**b}, 
	 {3 c + c**d + d**e + e**a, 2 c + 6 d + e**b}}
 
However, because `**` is held unevaluated, the expression

	m1**m2 + m2 // NCMatrixExpand
	
returns the "wrong" result

	{{{{d + a**d + b**e, 2 a + 3 b + d}, {d + c**d + d**e, 2 c + 4 d}},
	 {{2 + a**d + b**e, 2 + 2 a + 3 b}, {2 + c**d + d**e, 2 + 2 c + 3 d}}}, 
	 {{{e + a**d + b**e, 2 a + 3 b + e}, {e + c**d + d**e, 2 c + 3 d + e}}, 
	 {{3 + a**d + b**e, 3 + 2 a + 3 b}, {3 + c**d + d**e, 3 + 2 c + 3 d}}}}

which is different than the "correct" result

	{{d + a**d + b**e, 2 + 2 a + 3 b}, 
	 {e + c**d + d**e, 3 + 2 c + 3 d}}

which is returned by either

	NCMatrixExpand[m1**m2] + m2
	
or

	NCDot[m1, m2] + m2

The reason for this behavior is that `m1**m2` is essentially treated
as a *scalar* (it does not have *head* `List`) and therefore gets
added entrywise to `m2` *before* `NCMatrixExpand` has a chance to
evaluate the `**` product. There are no easy fixes for this problem,
which affects not only `NCAlgebra` but any similar type of matrix
product evaluation in Mathematica. With `NCAlgebra`, a better option
is to use [`NCMatrixReplaceAll`](#NCMatrixReplaceAll) or
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated).

[`NCMatrixReplaceAll`](#NCMatrixReplaceAll) and
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated) are special
versions of [`NCReplaceAll`](#NCReplaceAll) and
[`NCReplaceRepeated`](#NCReplaceRepeated) that take extra steps to
preserve matrix consistency when replacing expressions with nc
matrices. For example

	NCMatrixReplaceAll[x**y + y, {x -> m1, y -> m2}]
	
does produce the "correct" result

	{{d + a**d + b**e, 2 + 2 a + 3 b}, 
	 {e + c**d + d**e, 3 + 2 c + 3 d}}

[`NCMatrixReplaceAll`](#NCMatrixReplaceAll) and
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated) also work with
block matrices. For example

	rule = {x -> m1, y -> m2, id -> IdentityMatrix[2], z -> {{id,x},{x,id}}}
	NCMatrixReplaceRepeated[inv[z], rule]

coincides with the result of

	NCInverse[ArrayFlatten[{{IdentityMatrix[2], m1}, {m1, IdentityMatrix[2]}}]]

## Polynomials with commutative coefficients

The package [`NCPoly`](#PackageNCPoly) provides an efficient structure
for storing and operating with noncommutative polynomials with
commutative coefficients. There are two main goals:

1. *Ordering*: to be able to sort polynomials based on an *ordering*
   specified by the user. See the chapter
   [Noncommutative Gröbner Basis](#NCGB) for more details.
2. *Efficiency*: to efficiently perform polynomial algebra with as
   little overhead as possible.

Those two properties allow for an efficient implementation of
`NCAlgebra`'s noncommutative Gröbner basis algorithm, new in **Version
5**, without the use of auxiliary accelerating `C` code, as in
`NCGB`. See [Noncommutative Gröbner Basis](#NCGB).

The best way to work with `NCPoly` in `NCAlgebra` is by loading the
package [`NCPolyInterface`](#PackageNCPolyInterface):

    << NCPolyInterface`

This package provides the commands [`NCToNCPoly`](#NCToNCPoly) and
[`NCPolyToNC`](#NCPolyToNC) to convert nc expressions back and forth
between `NCAlgebra` and `NCPoly`. For example

    vars = {{x}, {y, z}};
	p = NCToNCPoly[1 + x**x - 2 x**y**z, vars]

converts the polynomial `1 + x**x - 2 x**y**z` from the standard
`NCAlgebra` format into an `NCPoly` object. The result in this case is
the `NCPoly` object
	
	NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {0, 2, 0} -> 1, {2, 1, 5} -> -2|>]
	
Conversely the command [`NCPolyToNC`](#NCPolyToNC) converts an
`NCPoly` back into `NCAlgebra` format. For example

	NCPolyToNC[p, vars]
	
returns

	1 + x**x - 2 x**y**z
	
as expected. Note that an `NCPoly` object does not store symbols, but
rather a representation of the polynomial based on specially encoded
monomials. This is the reason why one should provide `vars` as an
argument to `NCPolyToNC`.

Alternatively, one could construct the same `NCPoly` object by calling
`NCPoly` directly as in

	NCPoly[{1, 1, -2}, {{}, {x, x}, {x, y, z}}, vars]
	
In this syntax the first argument is a list of *coefficients*, the
second argument is a list of *monomials*, and the third is the list of
*variables*. *Monomials* are given as lists, with `{}` being
equivalent to a constant `1`. The sequence of braces in the list of
*variables* encodes the *ordering* to be used for sorting
`NCPoly`s. We provide the convenience command
[`NCPolyDisplayOrder`](#NCPolyDisplayOrder) that prints the polynomial
ordering implied by a list of symbols. In this example

	NCPolyDisplayOrder[vars]

prints out 

$x \ll y < z$

See [Noncommutative Gröbner Basis](#NCGB) for details. 

There is also a special constructor for monomials. For example

	NCPolyMonomial[{y,x}, vars]
	NCPolyMonomial[{x,y}, vars]

return the monomials corresponding to $y x$ and $x y$.

Operations on `NCPoly` objects result on another `NCPoly` object that
is always expanded. For example:

	1 + NCPolyMonomial[{x, y}, vars] - 2 NCPolyMonomial[{y, x}, vars]

returns 

	NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {1, 1, 1} -> 1, {1, 1, 3} -> -2|>]

and

	p = (1 + NCPolyMonomial[{x}, vars]**NCPolyMonomial[{y}, vars])^2

returns
	
	NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {1, 1, 1} -> 2, {2, 2, 10} -> 1|>]

Another convenience function is `NCPolyDisplay` which returns a list
with the monomials appearing in an `NCPoly` object. For example:

    NCPolyDisplay[p, vars]

returns

	{x.y.x.y, 2 x.y, 1}

The reason for displaying an `NCPoly` object as a list is so that the
monomials can appear in the same order as they are stored. Using
`Plus` would revert to Mathematica's default ordering. For example

	p = NCToNCPoly[1 + x**x**x - 2 x**x + z, vars]
	NCPolyDisplay[p, vars]

returns

	{z, x.x.x, -2 x.x, 1}
	
The monomials appear sorted in decreasing order from left to right,
with `z` being the *leading term* in the above example.

With `NCPoly` the Mathematica command `Sort` is modified to sort lists
of polynomials. For example

	polys = NCToNCPoly[{x**x**x, 2 y**x - z, z, y**x - x**x}, vars]
	ColumnForm[NCPolyDisplay[Sort[polys], vars]]

returns

	{x.x.x}
	{z}
	{y.x, -x.x}
	{2 y.x, -z}

`Sort` produces a list of polynomials sorted in *ascending* order
based on their *leading terms*.

To see how much more efficient `NCPoly` is when compared with standard
`NCAlgebra` objects try

	Table[Timing[NCExpand[(1 + x)^i]][[1]], {i, 0, 20, 5}]

which would typically return something like

	{0.000088, 0.001074, 0.017322, 0.240704, 3.61492, 52.0254}

whereas

	Table[Timing[(1 + NCPolyMonomial[{x}, vars])^i][[1]], {i, 0, 20, 5}]

would return

	{0.00097, 0.001653, 0.002208, 0.003908, 0.004306, 0.005049}

On the other hand, `NCPoly` objects have limited functionality and
should still be considered experimental at this point.

## Polynomials with noncommutative coefficients

A larger class of polynomials in noncommutative variables is that of
polynomials with noncommutative coefficients. Think of a polynomial
with commutative coefficients in which certain variables are
considered to be unknown, i.e. *variables*, where others are
considered to be known, i.e. *coefficients*. For example, in many
problems in systems and control the following expression

$p(x) = a x + x a^T - x b x + c$

is often seen as a polynomial in the noncommutative unknown `x` with
known noncommutative coefficients `a`, `b`, and `c`. A typical problem
is the determination of a solution to the equation $p(x) = 0$ or the
inequality $p(x) \succeq 0$.

The package [`NCPolynomial`](#PackageNCPolynomial) handles such
polynomials with noncommutative coefficients. As with
[`NCPoly`](#PackageNCPoly), the package provides the commands
[`NCToNCPolynomial`](#NCToNCPolynomial) and
[`NCPolynomialToNC`](#NCPolynomialToNC) to convert nc expressions back
and forth between `NCAlgebra` and `NCPolynomial`. For example

	vars = {x}
	p = NCToNCPolynomial[a**x + x**tp[a] - x**b**x + c, vars]

converts the polynomial `a**x + x**tp[a] - x**b**x + c` from
the standard `NCAlgebra` format into an `NCPolynomial` object. The
result in this case is the `NCPolynomial` object

	NCPolynomial[c, <|{x} -> {{1, a, 1}, {1, 1, tp[a]}}, {x, x} -> {{-1, 1, b, 1}}|>, {x}]

Conversely the command [`NCPolynomialToNC`](#NCPolynomialToNC)
converts an `NCPolynomial` back into `NCAlgebra` format. For example

	NCPolynomialToNC[p]
	
returns

	c + a**x + x**tp[a] - x**b**x

An `NCPolynomial` does store information about the polynomial symbols
and a list of variables is required only at the time of creation of
the `NCPolynomial` object.

As with `NCPoly`, operations on `NCPolynomial` objects result on
another `NCPolynomial` object that is always expanded. For example:

	vars = {x,y}
	1 + NCToNCPolynomial[x**y, vars] - 2 NCToNCPolynomial[y**x, vars]

returns 

	NCPolynomial[1, <|{y**x} -> {{-2, 1, 1}}, {x**y} -> {{1, 1, 1}}|>, {x, y}]

and

	(1 + NCToNCPolynomial[x, vars]**NCToNCPolynomial[y, vars])^2

returns

	NCPolynomial[1, <|{x**y**x**y} -> {{1, 1, 1}}, {x**y} -> {{2, 1, 1}}|>, {x, y}]

To see how much more efficient `NCPolynomial` is when compared with standard
`NCAlgebra` objects try

	Table[Timing[(NCToNCPolynomial[x, vars])^i][[1]], {i, 0, 20, 5}]

would return

	{0.000493, 0.003345, 0.005974, 0.013479, 0.018575, 0.02896}

As you can see, `NCPolynomial`s are not as efficient as `NCPoly`s but
still much more efficient than `NCAlgebra` polynomials.

`NCPolynomials` do not support *orderings* but we do provide the
`NCPSort` command that produces a list of terms sorted by degree. For
example

	NCPSort[p]

returns

	{c, a**x, x**tp[a], -x**b**x}

A useful feature of `NCPolynomial` is the capability of handling
polynomial matrices. For example

	mat1 = {{a**x + x**tp[a] + c**y + tp[y]**tp[c] - x**q**x, b**x}, 
	        {x**tp[b], 1}};
    p1 = NCToNCPolynomial[mat1, {x, y}];

	mat2 = {{1, x**tp[c]}, {c**x, 1}};
	p2 = NCToNCPolynomial[mat2, {x, y}];

constructs `NCPolynomial` objects representing the polynomial matrices
`mat1` and `mat2`. Verify that 

	NCPolynomialToNC[p1**p2] - NCDot[mat1, mat2] // NCExpand

is zero as expected. Internally `NCPolynomial` represents a polynomial
matrix by constructing matrix factors. For example the representation
of the matrix `mat1` correspond to the factors
$$ 
\begin{aligned}
\begin{bmatrix}
	a x + x a^T + c y + y^T c^T - x q x & b x \\ 
	x b^T & 1
\end{bmatrix} 
&=
\begin{bmatrix}
	0 & 0 \\ 0 & 1
\end{bmatrix}
+
\begin{bmatrix}
	a \\ 0
\end{bmatrix}
x
\begin{bmatrix}
	1 & 0
\end{bmatrix}
+
\begin{bmatrix}
	1 \\ 0
\end{bmatrix}
x
\begin{bmatrix}
	a^T & 0
\end{bmatrix}
+
\begin{bmatrix}
	-1 \\ 0
\end{bmatrix}
x
q 
x
\begin{bmatrix}
	1 & 0
\end{bmatrix}
+ \\
& \qquad \quad
\begin{bmatrix}
	b \\ 0
\end{bmatrix}
x
\begin{bmatrix}
	0 & 1
\end{bmatrix}
+
\begin{bmatrix}
	0 \\ 1
\end{bmatrix}
x
\begin{bmatrix}
	b^T & 0
\end{bmatrix}
+
\begin{bmatrix}
	c \\ 0
\end{bmatrix}
y
\begin{bmatrix}
	1 & 0
\end{bmatrix}
+
\begin{bmatrix}
	1 \\ 0
\end{bmatrix}
y^T
\begin{bmatrix}
	c^T & 0
\end{bmatrix}
\end{aligned}
$$

See section [linear functions](#LinearPolys) for more features on
linear polynomial matrices.

### Quadratic polynomials {#Quadratic}

When working with nc quadratics it is useful to be able to factor the
quadratic into the following form
$$
	q(x) = c + s(x) + l(x) M r(x)
$$
where $s$ is linear $x$ and $l$ and $r$ are vectors and $M$ is a
matrix. Load the package

	<< NCQuadratic`

and use the command
[`NCPToNCQuadratic`](#NCPToNCQuadratic) as in 

	vars = {x, y};
	expr = tp[x] ** a ** x ** d + tp[x] ** b ** y + tp[y] ** c ** y + tp[y] ** tp[b] ** x ** d;
	p = NCToNCPolynomial[expr, vars];
	{const, lin, left, middle, right} = NCPToNCQuadratic[p];

which returns

	left = {tp[x],tp[y]}
	right = {y, x ** d}
	middle = {{a,b}, {tp[b],c}}
	
and zero `const` and `lin`. The format for the linear part `lin` will
be discussed lated in Section [Linear](#Linear). Note that
coefficients of an nc quadratic may also appear on the left and right
vectors, as `d` did in the above example.

An interesting application is the verification of the domain in which
an nc rational is *convex*. Take for example the quartic

	expr = x ** x ** x ** x;

and calculate its noncommutative directional *Hessian*

	hes = NCHessian[expr, {x, h}]
	
This command returns

	2 h**h**x**x + 2 h**x**h**x + 2 h**x**x**h + 2 x**h**h**x + 2 x**h**x**h + 2 x**x**h**h

which is quadratic in the direction `h`. The decomposition of the
nc Hessian using `NCPToNCQuadratic`

	p = NCToNCPolynomial[hes, {h}];
	{const, lin, left, middle, right} = NCPToNCQuadratic[p];

produces

	left = {h, x ** h, x ** x ** h}
	right = {h ** x ** x, h ** x, h}
	middle = {{2, 2 x, 2 x ** x},{0, 2, 2 x},{0, 0, 2}}

Note that the middle matrix
$$
\begin{bmatrix}
2 & 2 x & 2 x^2 \\
0 & 2 & 2 x \\
0 & 0 & 2
\end{bmatrix}
$$
is not *symmetric*, as one might have expected. The command
[`NCQuadraticMakeSymmetric`](#NCQuadraticMakeSymmetric) can fix that
and produce a symmetric decomposition. For the above example

	{const, lin, sleft, smiddle, sright} = 
	  NCQuadraticMakeSymmetric[{const, lin, left, middle, right}, 
	                           SymmetricVariables -> {x, h}]

results in

	sleft = {x ** x ** h, x ** h, h}
	sright = {h ** x ** x, h ** x, h}
	middle = {{0, 0, 2}, {0, 2, 2 x}, {2, 2 x, 2 x ** x}}

in which `middle` is the symmetric matrix
$$
\begin{bmatrix}
0 & 0 & 2 \\
0 & 2 & 2 x \\
2 & 2 x & 2 x^2
\end{bmatrix}
$$
Note the argument `SymmetricVariables -> {x,h}` which tells
`NCQuadraticMakeSymmetric` to consider `x` and `y` as symmetric
variables. Because the `middle` matrix is never positive semidefinite
for any possible value of $x$ the conclusion[^convex] is that the nc quartic
$x^4$ is *not convex*.

[^convex]: This is in contrast with the commutative $x^4$ which is
    convex everywhere. See \cite{heltonconvexity} for details.

The production of such symmetric quadratic decompositions is automated
by the convenience command
[`NCMatrixOfQuadratic`](#NCMatrixOfQuadratic). Verify that

	{sleft, smiddle, sright} = NCMatrixOfQuadratic[hes, {h}]

automatically assumes that both `x` and `h` are symmetric variables
and produces suitable left and right vectors as well as a symmetric
middle matrix. Now we illustrate the application of such command to
checking the convexity region of a noncommutative rational function.

If one is interested in checking convexity of nc rationals the package
[`NCConvexity`](#PackageNCConvexity) has functions that automate the
whole process, including the calculation of the Hessian and the middle
matrix, followed by the diagonalization of the middle matrix as
produced by [`NCLDLDecomposition`](#NCLDLDecomposition).

For example, the commands evaluate the nc Hessian and calculates its
quadratic decomposition

	expr = (x + b ** y) ** inv[1 - a ** x ** a + b ** y + y ** b] ** (x + y ** b);
	{left, middle, right} =	NCMatrixOfQuadratic[NCHessian[expr, {x, h}], {h}];

The resulting middle matrix can be factored using

	{ldl, p, s, rank} = NCLDLDecomposition[middle];
	{ll, dd, uu} = GetLDUMatrices[ldl, s];

which produces the diagonal factors
$$
\begin{bmatrix}
  2 (1 + b y + y b - a x a)^{-1} & 0 & 0 \\
  0 & 0 & 0 \\
  0 & 0 & 0
\end{bmatrix}
$$
which indicates the the original nc rational is convex whenever
$$
(1 + b y + y b - a x a)^{-1} \succeq 0
$$
or, equivalently, whenever
$$
1 + b y + y b - a x a \succeq 0
$$
The above sequence of calculations is automated by the command
[`NCConvexityRegion`](#NCConvexityRegion) as in 

	<< NCConvexity`
	NCConvexityRegion[expr, {x}]

which results in 

	{2 (1 + b ** y + y ** b - a ** x ** a)^-1, 0}

which correspond to the diagonal entries of the LDL decomposition of
the middle matrix of the nc Hessian.

### Linear polynomials {#Linear}

