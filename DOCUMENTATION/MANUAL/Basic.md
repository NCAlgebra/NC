# Most Basic Commands {#MostBasicCommands}

This chapter provides a gentle introduction to some of the commands
available in `NCAlgebra`. 

If you want a living version of this chapter just run the notebook
`NC/DEMOS/1_MostBasicCommands.nb`.

Before you can use `NCAlgebra` you first load it with the following
commands:

    << NC`
    << NCAlgebra`

## To Commute Or Not To Commute?

In `NCAlgebra`, the operator `**` denotes *noncommutative
multiplication*. At present, single-letter lower case variables are
noncommutative by default and all others are commutative by
default. For example:

    a**b-b**a
	
results in

    a**b-b**a

while 

    A**B-B**A
    A**b-b**A

both result in `0`.

One of Bill's favorite commands is `CommuteEverything`, which
temporarily makes all noncommutative symbols appearing in a given
expression to behave as if they were commutative and returns the
resulting commutative expression. For example:

    CommuteEverything[a**b-b**a]
	
results in `0`. The command

	EndCommuteEverything[]
	
restores the original noncommutative behavior.

One can make any symbol behave as noncommutative
using `SetNonCommutative`. For example:

    SetNonCommutative[A,B]
    A**B-B**A
	
results in:
	
    A**B-B**A
	
Likewise, symbols can be made commutative using `SetCommutative`. For example:

	SetNonCommutative[A] 
	SetCommutative[B]
    A**B-B**A

results in `0`. `SNC` is an alias for `SetNonCommutative`. So, `SNC`
can be typed rather than the longer `SetNonCommutative`:

    SNC[A];
    A**a-a**A

results in:

    -a**A+A**a

One can check whether a given symbol is commutative or not using
`CommutativeQ` or `NonCommutativeQ`. For example:

	CommutativeQ[B]
	NonCommutativeQ[a]
	
both return `True`.

## Inverses, Transposes and Adjoints

The multiplicative identity is denoted `Id` in the program. At the
present time, `Id` is set to 1.

A symbol `a` may have an inverse, which will be denoted by
`inv[a]`. `inv` operates as expected in most cases.

For example:

    inv[a]**a
    inv[a**b]**a**b
	
both lead to `Id = 1` and
	
	a**b**inv[b]
	
results in `a`.

**Version 5:** `inv` no longer automatically distributes over
noncommutative products. If this more aggressive behavior is desired
use `SetOptions[inv, Distribute -> True]`. For example

	SetOptions[inv, Distribute -> True]
	inv[a**b]

returns `inv[b]**inv[a]`. Conversely

	SetOptions[inv, Distribute -> False]
	inv[a**b]
	
returns `inv[a**b]`.

`tp[x]` denotes the transpose of symbol `x` and `aj[x]` denotes the
adjoint of symbol `x`. Like `inv`, the properties of transposes and
adjoints that everyone uses constantly are built-in. For example:

    tp[a**b]
	
leads to 

    tp[b]**tp[a]
	
and

    tp[a+b]

returns

	tp[a]+tp[b]

Likewise `tp[tp[a]] == a` and `tp` for anything for which
`CommutativeQ` returns `True` is simply the identity. For example
`tp[5] == 5`, `tp[2 + 3I] == 2 + 3 I`, and `tp[B] == B`.

Similar properties hold to `aj`. Moreover

	aj[tp[a]]
	tp[aj[a]]
	
return `co[a]` where `co` stands for complex-conjugate. 

**Version 5:** transposes (`tp`), adjoints (`aj`), complex conjugates
(`co`), and inverses (`inv`) in a notebook environment render as
$x^T$, $x^*$, $\bar{x}$, and $x^{-1}$. `tp` and `aj` can also be input
directly as `x^T` and `x^*`. For this reason the symbol `T` is now
protected in `NCAlgebra`.

## Replace

A key feature of symbolic computation is the ability to perform
substitutions. The Mathematica substitute commands, e.g. `ReplaceAll`
(`/.`) and `ReplaceRepeated` (`//.`), are not reliable in `NCAlgebra`,
so you must use our `NC` versions of these commands. For example:

    NCReplaceAll[x**a**b,a**b->c]
	
results in

    x**c
	
and

    NCReplaceAll[tp[b**a]+b**a,b**a->c]

results in

    c+tp[a]**tp[b]

Use [NCMakeRuleSymmetric](#NCMakeRuleSymmetric) and
[NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint) to automatically
create symmetric and self adjoint versions of your rules:

	NCReplaceAll[tp[b**a]+b**a, NCMakeRuleSymmetric[b**a -> c]]

returns

	c + tp[c]

The difference between `NCReplaceAll` and `NCReplaceRepeated` can be
understood in the example:

	NCReplaceAll[a**b**b, a**b -> a]

that results in

	a**b

and

	NCReplaceRepeated[a**b**b, a**b -> a]

that results in

	a
	
Beside `NCReplaceAll` and `NCReplaceRepeated` we offer `NCReplace` and
`NCReplaceList`, which are analogous to the standard `ReplaceAll`
(`/.`), `ReplaceRepeated` (`//.`), `Replace` and `ReplaceList`. Note
that one rarely uses `NCReplace` and `NCReplaceList`. 	

See the Section [Advanced Rules and Replacement](#AdvancedReplace) for
a deeper discussion on some issues involved with rules and
replacements in `NCAlgebra`.

**Version 5:** the commands `Substitute` and `Transform` have been
deprecated in favor of the above nc versions of `Replace`.

## Polynomials

The command `NCExpand` expands noncommutative products. For example:

    NCExpand[(a+b)**x]

returns

    a**x+b**x

Conversely, one can collect noncommutative terms involving same powers
of a symbol using `NCCollect`. For example:

    NCCollect[a**x+b**x,x]
	
recovers

    (a+b)**x

`NCCollect` groups terms by degree before collecting and accepts more
than one variable. For example:

	expr = a**x+b**x+y**c+y**d+a**x**y+b**x**y
	NCCollect[expr, {x}]
	
returns

	y**c+y**d+(a+b)**x**(1+y)

and 

	NCCollect[expr, {x, y}]
	
returns

	(a+b)**x+y**(c+d)+(a+b)**x**y

Note that the last term has degree 2 in `x` and `y` and therefore does
not get collected with the first order terms.

The list of variables accepts `tp`, `aj` and
`inv`, and

	NCCollect[tp[x]**a**x+tp[x]**b**x+z,{x,tp[x]}]
	
returns
	
    z+tp[x]**(a+b)**x

Alternatively one could use

	NCCollectSymmetric[tp[x]**a**x+tp[x]**b**x+z,{x}]
	
to obtain the same result. A similar command,
[NCCollectSelfAdjoint](#NCCollectSelfAdjoint), works with self-adjoint
variables.

There is also a stronger version of collect called `NCStrongCollect`.
`NCStrongCollect` does not group terms by degree. For instance:

	NCStrongCollect[expr, {x, y}]
	
produces

	y**(c+d)+(a+b)**x**(1+y)

Keep in mind that `NCStrongCollect` often collects *more* than one
would normally expect.

`NCAlgebra` provides some commands for noncommutative polynomial
manipulation that are similar to the native Mathematica (commutative)
polynomial commands. For example:

	expr = B + A y**x**y - 2 x
	NCVariables[expr]

returns

	{x,y}

and

	NCCoefficientList[expr, vars]
	NCMonomialList[expr, vars]
	NCCoefficientRules[expr, vars]

returns

	{B, -2, A}
	{1, x, y**x**y}
	{1 -> B, x -> -2, y**x**y -> A}

Also for testing

	NCMonomialQ[expr]

will return `False` and

	NCPolynomialQ[expr]

will return `True`.

Another useful command is `NCTermsOfDegree`, which will returns an
expression with terms of a certain degree. For instance:

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {2,1}]

returns `x**y**x - x**x**y`,

	NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {0,0}]

returns `z**w`, and

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {0,1}]

returns `0`.

A similar command is `NCTermsOfTotalDegree`, which works just like
`NCTermsOfDegree` but considers the total degree in all variables. For
example:

For example,

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 3]

returns `x**y**x - x**x**y`, and

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 2]

returns `0`.

The above commands are based on special packages for efficiently
storing and calcuating with nc polynomials. Those packages are

* [`NCPoly`](#PackageNCPoly): which handles polynomials with
  noncommutative coefficients, and
* [`NCPolynomial`](#PackageNCPolynomial): which handles polynomials
  with noncommutative coefficients.

For example:

    1 + y**x**y - A x

is a polynomial with real coefficients in $x$ and $y$, whereas

    a**y**b**x**c**y - A x**d

is a polynomial with nc coefficients in $x$ and $y$, where the letters
$a$, $b$, $c$, and $d$, are the *nc coefficients*. Of course

    1 + y**x**y - A x

is a polynomial with nc coefficients if one considers only $x$ as the
variable of interest.

In order to take full advantage of [`NCPoly`](#PackageNCPoly) and
[`NCPolynomial`](#PackageNCPolynomial) one would need to *convert* an
expression into those special formats. See
[NCPolyInterface](#PackageNCPolyInterface), [NCPoly](#PackageNCPoly),
and [NCPolynomial](#PackageNCPolynomial) for details.

## Rationals and Simplification

One of the great challenges of noncommutative symbolic algebra is the
simplification of rational nc expressions. `NCAlgebra` provides
various algorithms that can be used for simplification and general
manipulation of nc rationals.

One such function is `NCSimplifyRational`, which attempts to simplify
noncommutative rationals using a predefined set of rules. For example:

    expr = 1+inv[d]**c**inv[S-a]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b \
           -inv[d]**c**inv[S-a+b**inv[d]**c]**b**inv[d]**c**inv[S-a]**b
	NCSimplifyRational[expr]
	
leads to `1`. Of course the great challenge here is to reveal well
known identities that can lead to simplification. For example, the two
expressions:

	expr1 = a**inv[1+b**a]
	expr2 = inv[1+a**b]**a
	
and one can use `NCSimplifyRational` to test such equivalence by
evaluating

	NCSimplifyRational[expr1 - expr2]

which results in `0` or 

	NCSimplifyRational[expr1**inv[expr2]]
	
which results in `1`. `NCSimplifyRational` works by transforming nc
rationals. For example, one can verify that

	NCSimplifyRational[expr2] == expr1

`NCAlgebra` has a number of packages that can be used to manipulate
rational nc expressions. The packages:

* [`NCGBX`](#PackageNCGBX) perform calculations with nc rationals
  using Gröbner basis, and
* [`NCRational`](#PackageNCRational) creates state-space
  representations of nc rationals. This package is still experimental.

## Calculus

The package [`NCDiff`](#PackageNCDiff) provide functions for
calculating derivatives and integrals of nc polynomials and nc
rationals.

The main command is [`NCDirectionalD`](#NCDirectionalD) which
calculates directional derivatives in one or many variables. For
example, if:

    expr = a**inv[1+x]**b + x**c**x

then

    NCDirectionalD[expr, {x,h}]

returns

    h**c**x + x**c**h - a**inv[1+x]**h**inv[1+x]**b

In the case of more than one variables
`NCDirectionalD[expr, {x,h}, {y,k}]` takes the directional derivative
of `expr` with respect to `x` in the direction `h` and with respect to
`y` in the direction `k`. For example, if:

    expr = x**q**x - y**x

then

    NCDirectionalD[expr, {x,h}, {y,k}]

returns

	h**q**x + x**q*h - y**h - k**x

The command `NCGrad` calculate nc *gradients*[^grad].

[^grad]: The transpose of the gradient of the nc expression `expr` is the derivative with respect to the direction `h` of the trace of the directional derivative of `expr` in the direction `h`.

For example, if:

    expr = x**a**x**b + x**c**x**d

then its directional derivative in the direction `h` is

    NCDirectionalD[expr, {x,h}]

which returns

    h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d

and

    NCGrad[expr, x]

returns the nc gradient

    a**x**b + b**x**a + c**x**d + d**x**c

For example, if:

    expr = x**a**x**b + x**c**y**d

is a function on variables `x` and `y` then

    NCGrad[expr, x, y]

returns the nc gradient list

    {a**x**b + b**x**a + c**y**d, d**x**c}

**Version 5:** introduces experimental support for integration of nc
polynomials. See [`NCIntegrate`](#NCIntegrate).

## Matrices {#BasicMatrices}

`NCAlgebra` has many commands for manipulating matrices with
noncommutative entries. Think block-matrices. Matrices are
represented in Mathematica using *lists of lists*. For example

	m = {{a, b}, {c, d}}

is a representation for the matrix 

$\begin{bmatrix} a & b \\ c & d \end{bmatrix}$

The Mathematica command `MatrixForm` output pretty
matrices. `MatrixForm[m]` prints `m` in a form similar to the above
matrix.

The experienced matrix analyst should always remember that the
Mathematica convention for handling vectors is tricky.

- `{{1, 2, 4}}` is a 1x3 *matrix* or a *row vector*;
- `{{1}, {2}, {4}}` is a 3x1 *matrix* or a *column vector*;
- `{1, 2, 4}` is a *vector* but **not** a *matrix*. Indeed whether it
  is a row or column vector depends on the context. We advise not to
  use *vectors*.

A useful command is [`NCInverse`](#NCInverse), which is akin to
Mathematica's `Inverse` command and produces a block-matrix inverse
formula[^inv] for an nc matrix. For example

	NCInverse[m]

returns

	{{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
	 {-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}

Note that `a` and `d - c**inv[a]**b` were assumed invertible during the
calculation.

[^inv]: Contrary to what happens with symbolic inversion of matrices
with commutative entries, there exist multiple formulas for the
symbolic inverse of a matrix with noncommutative entries. Furthermore,
it may be possible that none of such formulas is "correct". Indeed, it
is easy to construct a matrix `m` with block structure as shown that
is invertible but for which none of the blocks `a`, `b`, `c`, and `d`
are invertible. In this case no *correct* formula exists for the
calculation of the inverse of `m`.

Similarly, one can multiply matrices using [`NCDot`](#NCDot),
which is similar to Mathematica's `Dot`. For example

	m1 = {{a, b}, {c, d}}
	m2 = {{d, 2}, {e, 3}}
	NCDot[m1, m2]

result in 

	{{a ** d + b ** e, 2 a + 3 b}, {c ** d + d ** e, 2 c + 3 d}}

Note that products of nc symbols appearing in the
matrices are multiplied using `**`. Compare that with the standard
`Dot` (`.`) operator.

**WARNING:** `NCDot` replaces `MatMult`, which is still available for
  backward compatibility but will be deprecated in future releases.

There are many new improvements with **Version 5**. For instance,
operators `tp`, `aj`, and `co` now operate directly over
matrices. That is

	aj[{{a,tp[b]},{co[c],aj[d]}}]
	
returns

	{{aj[a],tp[c]},{co[b],d}}

In previous versions one had to use the special commands `tpMat`,
`ajMat`, and `coMat`. Those are still supported for backward
compatibility.

Behind `NCInverse` there are a host of linear algebra algorithms which
are available in the package:

* [`NCMatrixDecompositions`](#PackageNCMatrixDecompositions):
implements versions of the $LU$ Decomposition with partial and
complete pivoting, as well as $LDL$ Decomposition which are suitable
for calculations with nc matrices. Those functions are based on the
templated algorithms from the package
[`MatrixDecompositions`](#PackageMatrixDecompositions).

For instance the function
[`NCLUDecompositionWithPartialPivoting`](#NCLUDecompositionWithPartialPivoting)
can be used as

	m = {{a, b}, {c, d}}
	{lu, p} = NCLUDecompositionWithPartialPivoting[m]
	
which returns

	lu = {{a, b}, {c**inv[a], d - c**inv[a]**b}}
	p = {1, 2}

The list `p` encodes the sequence of permutations calculated during
the execution of the algorithm. The matrix `lu` contains the factors
$L$ and $U$. These can be recovered using

	{l, u} = GetLUMatrices[lu]
	
resulting in this case in

	l = {{1, 0}, {c**inv[a], 1}}
	u = {{a, b}, {0, d - c**inv[a]**b}}

To verify that $M = L U$ input

	m - NCDot[l, u]
	
which should returns a zero matrix.

**Note:** for efficiency the factors `l` and `u` are returned as
  `SparseArrays`. Use `Normal[u]` and `Normal[l]` to convert the
  `SparseArrays` `l` and `u` to regular matrices if desired.
  
The default pivoting strategy prioritizes simpler expressions. For
instance,

	m = {{a, b}, {1, d}}
	{lu, p} = NCLUDecompositionWithPartialPivoting[m]
	{l, u} = GetLUMatrices[lu]
	
results in the factors

	l = {{1, 0}, {a, 1}}
	u = {{1, d}, {0, b - a**d}}
	
and a permutation list 

	p = {2, 1}
	
which indicates that the number `1`, appearing in the second row, was
used as the pivot rather than the symbol `a` appearing on the first
row. Because of the permutation, to verify that $P M = L U$ input

    m[[p]] - NCDot[l, u]
	
which should return a zero matrix. Note that the permutation matrix
$P$ is never constructed. Instead, the rows of $M$ are permuted using
Mathematica's `Part` (`[[]]`). Likewise

	m = {{a + b, b}, {c, d}}
	{lu, p} = NCLUDecompositionWithPartialPivoting[m]
	{l, u} = GetLUMatrices[lu]

returns

	p = {2, 1}
	l = {{1, 0}, {(a + b)**inv[c], 1}} 
	u = {{c, d}, {0, b - (a + b)**inv[c]**d}}

showing that the *simpler* expression `c` was taken as a pivot instead
of `a + b`.

The function `NCLUDecompositionWithPartialPivoting` is the one that is
used by `NCInverse`.

Another factorization algorithm is
[`NCLUDecompositionWithCompletePivoting`](#NCLUDecompositionWithCompletePivoting),
which can be used to calculate the symbolic rank of nc matrices. For
example

	m = {{2 a, 2 b}, {a, b}}
	{lu, p, q, rank} = NCLUDecompositionWithCompletePivoting[m]
	
returns the *left* and *right* permutation lists

	p = {2, 1}
	q = {1, 2}
	
and `rank` equal to `1`. The $L$ and $U$ factors can be obtained as
before using

	{l, u} = GetLUMatrices[lu]
	
to get

	l = {{1, 0}, {2, 1}}
	u = {{a, b}, {0, 0}}

In this case, to verify that $P M Q = L U$ input

	NCDot[l, u] - m[[p, q]]
	
which should return a zero matrix. As with partial pivoting, the
permutation matrices $P$ and $Q$ are never constructed. Instead we
used `Part` (`[[]]`) to permute both columns and rows.
	
Finally [`NCLDLDecomposition`](#NCLDLDecomposition) computes the
$LDL^T$ decomposition of symmetric symbolic nc matrices. For example

	m = {{a, b}, {b, c}}
	{ldl, p, s, rank} = NCLDLDecomposition[m]
	
returns `ldl`, which contain the factors, and

	p = {1, 2}
	s = {1, 1}
	rank = 2
	
The list `p` encodes left and right permutations, `s` is a list
specifying the size of the diagonal blocks (entries can be either 1 or
2). The factors can be obtained using
[`GetLDUMatrices`](#GetLDUMatrices) as in

	{l, d, u} = GetLDUMatrices[ldl, s]
	
which in this case returns

	l = {{1, 0}, {b**inv[a], 1}}
	d = {{a, 0}, {0, c - b**inv[a]**b}}
	u = {{1, inv[a]**b}, {0, 1}}}

Because $P M P^T = L D L^T$,

	NCDot[l, d, u] - m[[p, p]]

is the zero matrix and $U = L^T$.

`NCLDLDecomposition` works only on symmetric matrices and, whenever
possible, will make assumptions on variables so that it can run
successfully.

**WARNING:** Versions prior to 5 contained a `NCLDUDecomposition` with
a slightly different syntax which, while functional, is being
deprecated in **Version 5**.

