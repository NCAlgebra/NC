# Most Basic Commands {#MostBasicCommands}

This chapter provides a gentle introduction to some of the commands
available in `NCAlgebra`. 

If you want a living analog of this chapter just run the notebook
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

> **WARNING:** Prior to **Version 6**, noncommutative monomials would be
> stored in expanded form, without exponents. For example, the monomial
> ```
> a**b**a^2**b
> ```
> would be stored as
> ```
> NonCommutativeMultiply[a, b, a, a, b]
> ```
> The automatic expansion of powers of noncommutative symbols required
> overloading the behavior of the built in `Power` operator, which was
> interfering and causing much trouble when commutative polynomial
> operations were performed inside an `NCAlgebra` session.
>
> Starting with **Version 6**, noncommutative monomials are represented
> with exponents. For instance, the same monomial above is now
> represented as
> ```
> NonCommutativeMultiply[a, b, Power[a, 2], b]
> ```
> Even if you type `a**b**a**a**b`, the repeated symbols get compressed
> to the compact representation with exponents. Exponents are now also
> used to represent the noncommutative inverse. See the notes in the
> next section.

## Inverses

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

> **WARNING:** Starting with **Version 6**, the `inv` operator acts
> mostly as a wrapper for `Power`. For example, `inv[a]` internally
> evaluates to `Power[a, -1]`. However, `inv` is still available and
> used to display the noncommutative inverse of noncommutative
> expressions outside of a notebook environment. Beware that
> `inv[a**a]` now evaluates to `Power[a, -2]`, hence certain patterns
> may no longer work. For example:
> ```
> NCReplace[inv[a ** a], a ** a -> b]
> ```
> would produce `inv[b]` in previous versions of `NCAlgebra` but will
> fail in **Version 6**.

> **WARNING:** Since **Version 5**, `inv` no longer automatically
> distributes over noncommutative products. If this more aggressive
> behavior is desired use `SetOptions[inv, Distribute -> True]`. For
> example
> ```
> SetOptions[inv, Distribute -> True]
> inv[a**b]
> ```
> returns `inv[b]**inv[a]`. Conversely
> ```
> SetOptions[inv, Distribute -> False]
> inv[a**b]
> ```
> returns `inv[a**b]`.

## Transposes and Adjoints

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

> **WARNING:** Since **Version 5** transposes (`tp`), adjoints (`aj`),
> complex conjugates (`co`), and inverses (`inv`) in a notebook
> environment render as $x^T$, $x^*$, $\bar{x}$, and $x^{-1}$. `tp`
> and `aj` can also be input directly as `x^T` and `x^*`. For this
> reason the symbol `T` is now protected in `NCAlgebra`.

A trace like operator, `tr`, was introduced in **v5.0.6**. It is a
commutative operator keeps its list of arguments cyclicly sorted so
that `tr[b ** a]` evaluates to `tr[a ** b]` and that automatically
distribute over sums so that an expression like

    tr[a ** b - b ** a]

always simplifies to zero. Also `b ** a ** tr[b ** a]` simpplifies to 

    tr[a ** b] a ** b

because `tr` is a commutative function. See
[SetCommutativeFunction](#SetCommutativeFunction).

A more interesting example is

    expr = (a ** b - b ** a)^3

for which `NCExpand[tr[expr]]` evaluates to

    3 tr[a^2 ** b^2 ** a ** b] - 3 tr[a^2 ** b ** a ** b^2]

Use [NCMatrixExpand](#NCMatrixExpand) to expand `tr` over matrices
with noncommutative entries. For example,

    NCMatrixExpand[tr[{{a,b},{c,d}}]]

evaluates to

    tr[a] + tr[d]

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

> **WARNING:** The change in internal representation introduced in
> **Version 6**, in which repeated letters in monomials are represented
> as powers, presents a new challenge to pattern matching for
> `NCAlgebra` expressions. For example, the seemingly innocent substitution
> ```
> NCReplaceAll[a**b**b, a**b -> c]
> ```
> which in previous versions returned `c**b` will fail in
> **Version 6**. The reason for the failure is that `a**b**b` is now
> internally represented as `a**Power[b, 2]`, which does not match
> `a**b`. The command [NCReplacePowerRule](#NCReplacePowerRule) can
> be used to make the following replacement
> ```
> NCReplaceAll[a**b**b, NCReplacePowerRule[a**b -> c]]
> ```
> return `c**b` in **Version 6**. An alternative syntax is to call
> `NCReplaceAll` with the option
> ```
> NCReplaceAll[a**b**b, a**b -> c, ApplyPowerRule -> True]
> ```
> with the exact same outcome.

The difference between `NCReplaceAll` and `NCReplaceRepeated` can be
understood in the example:

    NCReplaceAll[a**b**b, a**b -> a, ApplyPowerRule -> True]

that results in

    a**b

and

    NCReplaceRepeated[a**b**b, a**b -> a, ApplyPowerRule -> True]

that results in

    a

Beside `NCReplaceAll` and `NCReplaceRepeated` we offer `NCReplace` and
`NCReplaceList`, which are analogous to the standard `ReplaceAll`
(`/.`), `ReplaceRepeated` (`//.`), `Replace` and `ReplaceList`. Note
that one rarely uses `NCReplace` and `NCReplaceList`.

See the Section [Advanced Rules and Replacement](#AdvancedReplace) for
a deeper discussion on some issues involved with rules and
replacements in `NCAlgebra`.

> **WARNING:** The commands `Substitute` and `Transform` have been
> deprecated in **Version 5** in favor of the above nc versions of
> `Replace`. 

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

* [`NCPolynomial`](#PackageNCPolynomial): which handles polynomials with
  noncommutative coefficients, and
* [`NCPoly`](#PackageNCPoly): which handles polynomials with real coefficients.

For example:

    1 + y**x**y - A x

is a polynomial with commutative coefficients in $x$ and $y$, whereas

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

A further example, if:

    expr = x**a**x**b + x**c**x**d

then its directional derivative in the direction `h` is

    NCDirectionalD[expr, {x,h}]

which returns

    h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d

The command `NCGrad` calculates nc *gradients*[^grad].

[^grad]: The transpose of the gradient of the nc expression `expr` is the derivative with respect to the direction `h` of the trace of the directional derivative of `expr` in the direction `h`.

For example:

    NCGrad[expr, x]

returns the nc gradient

    a**x**b + b**x**a + c**x**d + d**x**c

A further example, if:

    expr = x**a**x**b + x**c**y**d

is a function on variables `x` and `y` then

    NCGrad[expr, x, y]

returns the nc gradient list

    {a**x**b + b**x**a + c**y**d, d**x**c}

**Version 5** introduced experimental support for integration of nc
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
matrix. Beware when copying and pasting parts of an expression rendered by`MatrixForm` because it may not execute correctly. If in doubt, use `FullForm` to reveal the contents of the expression.

The experienced matrix analyst should always remember that the
Mathematica convention for handling vectors is tricky.

- `{{1, 2, 4}}` is a 1x3 *matrix* or a *row vector*;
- `{{1}, {2}, {4}}` is a 3x1 *matrix* or a *column vector*;
- `{1, 2, 4}` is a *vector* but **not** a *matrix*. Indeed whether it
  is a row or column vector depends on the context. We advise not to
  use *vectors*.

### Inverses, products, adjoints, etc {#BasicMatrices:Inverses}

A useful command is [`NCInverse`](#NCInverse), which is akin to
Mathematica's `Inverse` command and produces a block-matrix inverse
formula[^inv] for an nc matrix. For example

    NCInverse[m]

returns

    {{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
     {-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}

or, using `MatrixForm`

```NCInverse[m] // MatrixForm
NCInverse[m] // MatrixForm
```

returns

$\begin{bmatrix} a^{-1} (1 + b (d - c a^{-1} b)^{-1} c a^{-1}) & -a^{-1} b (d - c a^{-1} b)^{-1} \\ -(d - c a^{-1} b)^{-1} c a^{-1} & (d - c a^{-1} b)^{-1} \end{bmatrix}$

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

> **WARNING:** `NCDot` replaces `MatMult`, which is still available for
>  backward compatibility but will be deprecated in future releases.

There are many new improvements with **Version 5**. For instance,
operators `tp`, `aj`, and `co` now operate directly over
matrices. That is

    aj[{{a,tp[b]},{co[c],aj[d]}}]

returns

    {{aj[a],tp[c]},{co[b],d}}

In previous versions one had to use the special commands `tpMat`,
`ajMat`, and `coMat`. Those are still supported for backward
compatibility.

See [advanced matrix commands](#AdvancedMatrices) for other useful matrix manipulation routines, such as [`NCMatrixExpand`](#NCMatrixExpand), [`NCMatrixReplaceAll`](#NCMatrixReplaceAll), [`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated), etc, that allow one to work with matrices with symbolic noncommutative entries.

### LU Decomposition {#BasicMatrices:LUDecomposition}

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

Using `MatrixForm`:
$$\begin{bmatrix} a & b \\ c a^{-1} & d - c a^{-1} b \end{bmatrix}$$
The list `p` encodes the sequence of permutations calculated during
the execution of the algorithm. The matrix `lu` contains the factors
$L$ and $U$ in the way most common to numerical analysts. These factors can be recovered using

    {l, u} = GetFullLUMatrices[lu]

resulting in this case in

    l = {{1, 0}, {c**inv[a], 1}}
    u = {{a, b}, {0, d - c**inv[a]**b}}

Using `MatrixForm`:
$$
L = \begin{bmatrix} 1 & 0 \\ c a^{-1} & 1 \end{bmatrix}, \qquad
U = \begin{bmatrix} a & b \\ 0 & d - c a^{-1} b \end{bmatrix}
$$
To verify that $M = L U$ input

    m - NCDot[l, u]

which should return a zero matrix.

**Note:** if you are looking for efficiency, the function [`GetLUMatrices`](#GetLUMatrices) (also [`GetLDUMatrices`](#GetLDUMatrices)) returns the factors `l` and `u`  as  `SparseArrays`.

The default pivoting strategy prioritizes pivoting on simpler expressions. For
instance,

    m = {{a, b}, {1, d}}
    {lu, p} = NCLUDecompositionWithPartialPivoting[m]
    {l, u} = GetFullLUMatrices[lu]

results in the factors

    l = {{1, 0}, {a, 1}}
    u = {{1, d}, {0, b - a**d}}

and a permutation list 

    p = {2, 1}

which indicates that the number `1`, appearing in the second row, was
used as the pivot rather than the symbol `a` appearing on the first
row. Because of the permutation, to verify that $P M = L U$ input

    m[[p]] - NCDot[l, u]

which should return a zero matrix. Note that in the above example the permutation matrix
$P$ is never constructed. Instead, the rows of $M$ are directly permuted using
Mathematica's `Part` (`[[]]`) command. Of course, if one prefers to work with permutation matrices, they can be easily obtained by permuting the rows of the identity matrix as in the following example

    p = {2, 1, 3}
    IdentityMatrix[3][[p]] // MatrixForm

to produce
$$
\begin{bmatrix} 0 & 1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 1 \end{bmatrix}
$$
Likewise

    m = {{a + b, b}, {c, d}}
    {lu, p} = NCLUDecompositionWithPartialPivoting[m]
    {l, u} = GetFullLUMatrices[lu]

returns

    p = {2, 1}
    l = {{1, 0}, {(a + b)**inv[c], 1}} 
    u = {{c, d}, {0, b - (a + b)**inv[c]**d}}

showing that the *simpler* expression `c` was taken as a pivot instead
of `a + b`.

The function `NCLUDecompositionWithPartialPivoting` is the one that is
used by `NCInverse`.

### LU Decomposition with complete pivoting {#BasicMatrices:LUDecompositionWithCompletePivoting}

Another factorization algorithm is
[`NCLUDecompositionWithCompletePivoting`](#NCLUDecompositionWithCompletePivoting),
which can be used to calculate the symbolic rank of nc matrices. For
example

    m = {{2 a, 2 b}, {a, b}}
    {lu, p, q, rank} = NCLUDecompositionWithCompletePivoting[m]

returns the *left* and *right* permutation lists

    p = {2, 1}
    q = {1, 2}

and `rank` equal to `1`. Note that `p = {2, 1}` and `q = {1,2}` tell us that the element that was pivoted on was the symbol `a`, which is the first entry of the second row, rather then `2 a`, which is the first entry of the first row, because `a` is *simpler* than `2 a` . The $L$ and $U$ factors can be obtained as
before using

    {l, u} = GetFullLUMatrices[lu]

to get

    l = {{1, 0}, {2, 1}}
    u = {{a, b}, {0, 0}}

Using `MatrixForm`:
$$
L = \begin{bmatrix} 1 & 0 \\ 2 & 1 \end{bmatrix}, \qquad
U = \begin{bmatrix} a & b \\ 0 & 0 \end{bmatrix}
$$
In this case, to verify that $P M Q = L U$ input

    NCDot[l, u] - m[[p, q]]

which should return a zero matrix. As with partial pivoting, the
permutation matrices $P$ and $Q$ are never constructed. Instead we
used `Part` (`[[]]`) to permute both rows and columns.

### LDL Decomposition {#BasicMatrices:LDLDecomposition}

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

    {l, d, u} = GetFullLDUMatrices[ldl, s]

which in this case returns

    l = {{1, 0}, {b**inv[a], 1}}
    d = {{a, 0}, {0, c - b**inv[a]**b}}
    u = {{1, inv[a]**b}, {0, 1}}}

Because $P M P^T = L D L^T$,

    NCDot[l, d, u] - m[[p, p]]

is the zero matrix and $U = L^T$.

`NCLDLDecomposition` works only on symmetric matrices and, whenever
possible, will make invertibility and symmetry assumptions on variables so that it can run
successfully. If not possible it will warn the users.

> **WARNING:** Prior versions contained the command `NCLDUDecomposition`
> which was deprecated in **Version 5** as its functionality is now
> provided by [`NCLDLDecomposition`](#NCLDLDecomposition), with a
> slightly different syntax.

### Replace with matrices {#ReplaceWithMatrices}

[`NCMatrixReplaceAll`](#NCMatrixReplaceAll) and
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated) are special
versions of [`NCReplaceAll`](#NCReplaceAll) and
[`NCReplaceRepeated`](#NCReplaceRepeated) that take extra steps to
preserve matrix consistency when replacing expressions with nc
matrices. For example, with

    m1 = {{a, b}, {c, d}}
    m2 = {{d, 2}, {e, 3}}

and

    M = {{a11,a12}}

the call

    NCMatrixReplaceRepeated[M, {a11 -> m1, a12 -> m2}]

produces as a result the matrix 

    {{a, b, d, 2}, {c, d, e, 3}}

or, using `MatrixForm`:
$$
\begin{bmatrix} a & b & d & 2 \\ c & d & e & 3 \end{bmatrix}
$$
Note how the symbols were treated as block-matrices during the substitution. As a second example, with

    M = {{a11, 0}, {0, a22}}

the command

    NCMatrixReplaceRepeated[M, {a11 -> m1, a22 -> m2}]

produces the matrix

    {{a, b, 0, 0}, {c, d, 0, 0}, {0, 0, d, 2}, {0, 0, e, 3}}

or, using `MatrixForm`:

$\begin{bmatrix} a & b & 0 & 0 \\ c & d & 0 & 0 \\ 0 & 0 & d & 2 \\ 0 & 0 & e & 3 \end{bmatrix}$

in which the `0` blocks were automatically expanded to fit the adjacent block matrices.

Another feature of `NCMatrixReplace` and its variants is its ability to withold evaluation until all matrix substitutions have taken place. For example,

    NCMatrixReplaceAll[x**y + y, {x -> m1, y -> m2}]

produces

    {{d + a**d + b**e, 2 + 2 a + 3 b}, 
     {e + c**d + d**e, 3 + 2 c + 3 d}}

Finally, `NCMatrixReplace` substitutes `NCInverse` for `inv` so that, for instance, the result of

    rule = {x -> m1, y -> m2, id -> IdentityMatrix[2], z -> {{id,x},{x,id}}}
    NCMatrixReplaceRepeated[inv[z], rule]

coincides with

    NCInverse[ArrayFlatten[{{IdentityMatrix[2], m1}, {m1, IdentityMatrix[2]}}]]

## Quadratic polynomials, second direction derivatives and convexity {#Quadratic}

The closest related demo to the material in this section is
`NC/DEMOS/NCConvexity.nb`.

When working with nc quadratics it is useful to be able to "factor" the
quadratic into the following form
$$
    q(x) = c + s(x) + l(x) M r(x)
$$
where $s$ is linear $x$ and $l$ and $r$ are vectors and $M$ is a
matrix. Load the package

    << NCQuadratic`

and use the command
[`NCToNCQuadratic`](#NCToNCQuadratic) to factor an nc polynomial into the the above form:

    vars = {x, y};
    expr = tp[x]**a**x**d + tp[x]**b**y + tp[y]**c**y + tp[y]**tp[b]**x**d;
    {const, lin, left, middle, right} = NCToNCQuadratic[expr, vars];

which returns

    left = {tp[x],tp[y]}
    right = {y, x**d}
    middle = {{a,b}, {tp[b],c}}

and zero `const` and `lin`. The format for the linear part `lin` will
be discussed lated in Section [Linear](#Linear). Note that
coefficients of an nc quadratic may also appear on the left and right
vectors, as `d` did in the above example. Conversely,
[`NCQuadraticToNC`](#NCQuadraticToNC) converts a list with factors
back to an nc expression as in:

    NCQuadraticToNC[{const, lin, left, middle, right}]

which results in 

    (tp[x]**b + tp[y]**c)**y + (tp[x]**a + tp[y]**tp[b])**x**d

An interesting application is the verification of the domain in which
an nc rational function is *convex*. This uses the second direction
derivative, called the Hessian. Take for example the quartic

    expr = x**x**x**x;

and calculate its noncommutative directional *Hessian*

    hes = NCHessian[expr, {x, h}]

This command returns

    2 h**h**x**x + 2 h**x**h**x + 2 h**x**x**h + 2 x**h**h**x + 2 x**h**x**h + 2 x**x**h**h

which is quadratic in the direction `h`. The decomposition of the
nc Hessian using `NCToNCQuadratic`

    {const, lin, left, middle, right} = NCToNCQuadratic[hes, {h}];

produces

    left = {h, x**h, x**x**h}
    right = {h**x**x, h**x, h}
    middle = {{2, 2 x, 2 x**x},{0, 2, 2 x},{0, 0, 2}}

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

    sleft = {x**x**h, x**h, h}
    sright = {h**x**x, h**x, h}
    middle = {{0, 0, 2}, {0, 2, 2 x}, {2, 2 x, 2 x**x}}

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
    convex everywhere. See [@camino:MIS:2003] for details.

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

    expr = (x + b**y)**inv[1 - a**x**a + b**y + y**b]**(x + y**b);
    {left, middle, right} = NCMatrixOfQuadratic[NCHessian[expr, {x, h}], {h}];

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

    {2 inv[1 + b**y + y**b - a**x**a], 0}

which correspond to the diagonal entries of the LDL decomposition of
the middle matrix of the nc Hessian.



