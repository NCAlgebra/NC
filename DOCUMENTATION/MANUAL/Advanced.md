# More Advanced Commands {#MoreAdvancedCommands}

In this chapter we describe some more advance features and
commands. Most of these were introduced in **Version 5**.

If you want a living version of this chapter just run the notebook
`NC/DEMOS/2_MoreAdvancedCommands.nb`.

## Advanced Rules and Replacements {#AdvancedReplace}

Substitution is a key feature of Symbolic computation. We will now
discuss some issues related to Mathematica's implementation of rules
and replacements that can affect the behavior of `NCAlgebra`
expressions.

### `ReplaceAll` (`/.`) and `ReplaceRepeated` (`//.`) often fail

The first issue is related to how Mathematica performs substitutions,
which is through
[pattern matching](http://reference.wolfram.com/language/guide/RulesAndPatterns.html). For
a rule to be effective if has to match the *structural*
representation of an expression. That representation might be
different than one would normally think based on the usual properties
of mathematical operators. For example, one would expect the rule:

	rule = 1 + x_ -> x

to match all the expressions bellow:

    1 + a
    1 + 2 a
	1 + a + b
	1 + 2 a * b

so that

	expr /. rule

with `expr` taking the above expressions would result in:

	a
	2 a
	a + b
	2 a * b

Indeed, Mathematica's attribute `Flat` does precisely that. Note that
this is still *structural matching*, not *mathematical matching*, since
the pattern `1 + x_` would not match an integer `2`, even though one
could write `2 = 1 + 1`!

Unfortunately, `**`, which is the `NonCommutativeMultiply` operator,
*is not* `Flat`[^notflat]. This is the reason why substitution based
on a simple rule such as:

	rule = a**b -> c

so that

    expr /. rule

will work for some `expr` like

	1 + 2 a**b

resulting in

	1 + 2 c

but will fail to produce the *expected* result in cases like:

	a**b**c
	c**a**b
	c**a**b**d
	1 + 2 a**b**c

That's what the `NCAlgebra` family of replacement functions discussed in the next section are made for.

### The fix is `NCReplace`

Continuing with the example in the previous section, the calls

	NCReplaceAll[a**b**c, rule]
	NCReplaceAll[ c**a**b, rule ]
	NCReplaceAll[c**a**b**d, rule]
	NCReplaceAll[1 + 2 a**b**c, rule ]

produce the results one would expect:

	c**c
	c**c
	c**c**d
	1 + 2 c**c

For this reason, when substituting in `NCAlgebra` it is always safer
to use functions from the [`NCReplace` package](#PackageNCReplace)
rather than the corresponding Mathematica `Replace` family of
functions. Unfortunately, this comes at a the expense of sacrificing
the standard operators `/.` (`ReplaceAll`) and `//.`
(`ReplaceRepeated`), which cannot be safely overloaded, forcing one to
use the full names `NCReplaceAll` and `NCReplaceRepeated`.

On the same vein, the following substitution rule

    NCReplace[2 a**b + c, 2 a -> b]

will return `2 a**b + c` intact since `FullForm[2 a**b]` is indeed

    Times[2, NonCommutativeMuliply[a, b]]

which is not structurally related to `FullForm[2 a]`, which is
`Times[2, a]`. Of course, in this case a simple solution is to use the
alternative rule:

    NCReplace[2 a**b + c, a -> b / 2]

which results in `b**b + c`, as one might expect.

### Matching monomials with powers

Starting with **Version 6**, `NCAlgebra` stores repeated symbols in
noncommutative monomials using powers. This means that

    expr = a**a**a**b**a**a**b**a**b

is internally stored as

    NonCommutativeMultiply[a^3, b, a^2, b, a, b]

so that a replacement such as

    NCReplaceAll[expr, a**b -> c]

will result in

    a^3**b**a^2**b**c

Note how the rule fails to match the `a**b` in the terms `a**b^2` and
`a**b^3`. This situation might be familiar to an experienced
Mathematica user who is a aware of the difference between structural
pattern matching and mathematical matching[^match].

[^match]: One might have encountered this difficulty when trying to
match a product of commutative variables in a commutative monomial
such as `x y^2 /. x y -> z` which fails to match `x y^2` even though
`x y^2` is equal to `(x y) y`.

As a convenience for `NCAlgebra` users, **Version 6** provides the
function [NCReplacePowerRule](#NCReplacePowerRule) that modifies a
user's rule in order to accomplish matching of symbols in `NCAlgebra`
expressions including powers. For example, for the same `expr` above,
the following replacement

    NCReplaceAll[expr, NCReplacePowerRule[a**b -> c]]

will produce

    a^2**c**a^2**b**a**b

after matching `a**b` in the term `a^3**b`, and

    NCReplaceRepeated[expr, NCReplacePowerRule[a**b -> c]]

will produce

    a^2**c**a**c^2

after matching `a**b` in `a^3**b`, `a^2**b`, and `a**b`.

The command `NCReplacePowerRule` works by modifying noncommutative
patterns with symbols appearing at the edges of monomials to account
for the potential presence of `Power` in a noncommutative
monomial. For example,

    NCReplacePowerRule[a**c**b -> d]

produces the modified rule[^power-rule]

    a^n_.**c**b^m_. -> a^(n-1)**d**b^(m-1)
    
which can successfully match powers of the symbols `a` and `b`
appearing in the monomial `a**c**b`.

[^power-rule]: The actual rule in this case is the more complicated
`a^n:_Integer?Positive:1**c**b^m:_Integer?Positive:1 -> a^(n-1)**d**b^(m-1)`
with additional checks that prevent the rule from working with
negative powers.

The application of `NCReplacePowerRule` can also be done by invoking
the option `ApplyPowerRule`, which is available in all functions of
the package [NCReplace](#PackageNCReplace). For example, the command

    NCReplaceRepeated[expr, a**b -> c, ApplyPowerRule -> True]

does the same thing as 

    NCReplaceRepeated[expr, NCReplacePowerRule[a**b -> c]]

This option can also be set globally for all calls to the `NCReplace`
family of functions in a `NCAlgebra` session by calling

    SetOptions[NCReplace, ApplyPowerRule -> True]

After that, all calls to `NCReplace`, `NCReplaceAll`,
`NCReplaceRepeated`, and related function, will be done with the option
`ApplyPowerRule -> True` automatically.

To revert to the default behavior just set

    SetOptions[NCReplace, ApplyPowerRule -> False]

### Trouble with `Block` and `Module`

A second more esoteric issue related to substitution in `NCAlgebra`
does not have a clean solution. It is also one that usually lurks in
hidden pieces of code and can be very difficult to spot. We have been
victim of such "bugs" many times. Luckily it only affect advanced users
that are using `NCAlgebra` inside their own functions using
Mathematica's `Block` and `Module` constructions. It is also not a
real bug, since it follows from some often not well understood issues
with the usage of
[`Block` versus `Module`](http://reference.wolfram.com/language/tutorial/BlocksComparedWithModules.html). Our
goal here is therefore not to *fix* the issue but simply to alert
advanced users of its existence. Start by first revisiting the
following example from the
[Mathematica documentation](http://reference.wolfram.com/language/tutorial/BlocksComparedWithModules.html). Let

	m = i^2

and run

	Block[{i = a}, i + m]

which returns the "expected"

	a + a**a

versus

	Module[{i = a}, i + m]

which returns the "surprising"

	a + i**i

The reason for this behavior is that `Block` effectively evaluates `i`
as a *local variable* and evaluates `m` using whatever values are available
at the time of evaluation, whereas `Module` only evaluates the symbol
`i` which appears *explicitly* in `i + m` and not `m` using the local
value of `i = a`. This can lead to many surprises when using
rules and substitution inside a `Module`. For example:

	Block[{i = a}, i_ -> i]

will return

	i_ -> a

whereas

	Module[{i = a}, i_ -> i]

will return

	i_ -> i

More devastating for `NCAlgebra` is the fact that `Module` will hide
local definitions from rules, which will often lead to disaster if
local variables need to be declared noncommutative. Consider for
example the trivial definitions for `F` and `G` below:

	F[exp_] := Module[
	  {rule, aa, bb},
	  SetNonCommutative[aa, bb];
	  rule = aa_**bb_ -> bb**aa;
	  NCReplaceAll[exp, rule]
	]

	G[exp_] := Block[
	  {rule, aa, bb},
	  SetNonCommutative[aa, bb];
	  rule = aa_**bb_ -> bb**aa;
	  NCReplaceAll[exp, rule]
	]

Their only difference is that one is defined using a `Block` and the
other is defined using a `Module`. The task is to apply a rule that
*flips* the noncommutative product of their arguments, say, `x**y`,
into `y**x`.  The problem is that only one of those definitions work
"as expected." Indeed, verify that

	G[x**y]

returns the "expected"

	y**x

whereas

	F[x**y]

returns

	x y

which completely destroys the noncommutative product. The reason for
the catastrophic failure of the definition of `F`, which is inside a
`Module`, is that the letters `aa` and `bb` appearing in `rule` are
*not treated as the local symbols `aa` and `bb`*[^argh]. For this
reason, the right-hand side of the rule `rule` involves the global
symbols `aa` and `bb`, which are, in the absence of a declaration to
the contrary, commutative. On the other hand, the definition of `G`
inside a `Block` makes sure that `aa` and `bb` are evaluated with
whatever value they might have locally at the time of execution.

The above subtlety often manifests itself partially, sometimes causing
what might be perceived as some kind of *erratic behavior*. Indeed, if
one had used symbols that were already declared globaly noncommutative
by `NCAlgebra`, such as single small cap roman letters as in the
definition:

	H[exp_] := Module[
	  {rule, a, b},
      SetNonCommutative[a, b];
	  rule = a_**b_ -> b**a];
	  NCReplaceAll[exp, rule]
    ]

then calling `H[x**y]` would have worked "as expected," even if for
the wrong reasons!

Another possible "fix" is to use a delayed rule, as in:

	H[exp_] := Module[
	  {rule, aa, bb},
      SetNonCommutative[aa, bb];
	  rule = aa_**bb_ :> bb**aa];
	  NCReplaceAll[exp, rule]
    ]

which would also work as the evaluation of the right-hand side of the
rule is delayed until the time of its application.

[^notflat]: The reason is that making an operator `Flat` is a
convenience that comes with a price: lack of control over execution
and evaluation. Since `NCAlgebra` has to operate at a very low level
this lack of control over evaluation is fatal. Indeed, making
`NonCommutativeMultiply` have an attribute `Flat` will throw
Mathematica into infinite loops in seemingly trivial noncommutative
expressions. Hey, email us if you find a way around that :)

[^argh]: By the way, I find that behavior of Mathematica's `Module`
questionable, since something like

        F[exp_] := Module[{aa, bb},
	      SetNonCommutative[aa, bb];
	      aa**bb
	    ]

    would not fail to treat `aa` and `bb` locally. It is their
    appearance in a rule that triggers the mostly odd behavior.


## Expanding matrix products {#AdvancedMatrices}

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
	
which is what would have arisen from calling `NCDot[m1,m2]`[^matmult]. Likewise

	inv[m1]

results in

	inv[{{a, b}, {c, d}}]

and

	inv[m1] // NCMatrixExpand
	
returns the evaluated result

	{{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
	 {-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}

or, using `MatrixForm`:

$\begin{bmatrix} a^{-1} (1 + b (d - c a^{-1} b)^{-1} c a^{-1}) & -a^{-1} b (d - c a^{-1} b)^{-1} \\ -(d - c a^{-1} b)^{-1} c a^{-1} & (d - c a^{-1} b)^{-1} \end{bmatrix}$

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

### Trouble with `Plus` (`+`) and matrices

Mathematica's choice of treating lists and matrix indistinctively can
cause much trouble when mixing `**` with `Plus` (`+`) operator. The
reason for that is that `Plus` is `Listable`, and an expression like

    z + m1

where `m1` is an array and `z` is not, is automatically expanded into

    {{a + z, b + z}, {c + z, d + z}}

or, using `MatrixForm`:

$\begin{bmatrix} a + z & b + z \\ c + z & d + z \end{bmatrix}$

Because of this "feature", the expression

	m1**m2 + m2 // NCMatrixExpand
	
evaluates to the "wrong" result

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

The reason for the behavior is that `m1**m2` is essentially treated
as a *scalar* (it does not have *head* `List`) and therefore gets
added entrywise to `m2` *before* `NCMatrixExpand` has a chance to
evaluate the `**` product. 

There are no easy fixes for this problem, which affects not only
`NCAlgebra` but any similar type of matrix product evaluation in
Mathematica. With `NCAlgebra`, a better option is to use
[`NCMatrixReplaceAll`](#NCMatrixReplaceAll) or
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated). As seen in the
section [Replace with matrices](#ReplaceWithMatrices), the command

	NCMatrixReplaceAll[x**y + y, {x -> m1, y -> m2}]
	
produces the expected result:

	{{d + a**d + b**e, 2 + 2 a + 3 b}, 
	 {e + c**d + d**e, 3 + 2 c + 3 d}}

Note that the above behavior might be erratic, since in an expression like

	m1**m2 + m2**m1
	
in which `**` is kept unevaluated as in

	{{a, b}, {c, d}}**{{d, 2}, {e, 3}} + {{d, 2}, {e, 3}}**{{a, b}, {c, d}}

the command
	
	m1**m2 + m2**m1 // NCMatrixExpand
	
expands to the expected result

	{{2 c + a**d + b**e + d**a, 2 a + 3 b + 2 d + d**b}, 
	 {3 c + c**d + d**e + e**a, 2 c + 6 d + e**b}}


## Polynomials with commutative coefficients {#PolysWithCommutativeCoefficients}

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

Before getting into details, to see how much more efficient `NCPoly`
is when compared with standard `NCAlgebra` objects try

	Table[Timing[NCExpand[(1 + x)^i]][[1]], {i, 0, 20, 5}]

which would typically return something like

	{0.000088, 0.001074, 0.017322, 0.240704, 3.61492, 52.0254}

whereas the equivalent

    << NCPoly`
	Table[Timing[(1 + NCPolyMonomial[{x}, {x}])^i][[1]], {i, 0, 20, 5}]

would return

	{0.00097, 0.001653, 0.002208, 0.003908, 0.004306, 0.005049}

Beware that `NCPoly` objects have limited functionality and should
still be considered experimental at this point.

The best way to work with `NCPoly` in `NCAlgebra` is by loading the
package [`NCPolyInterface`](#PackageNCPolyInterface):

    << NCPolyInterface`

which provides the commands [`NCToNCPoly`](#NCToNCPoly) and
[`NCPolyToNC`](#NCPolyToNC) to convert nc expressions back and forth
between `NCAlgebra` and `NCPoly`.

For example

    vars = {x, y, z};
	p = NCToNCPoly[1 + x**x - 2 x**y**z, vars]

converts the polynomial `1 + x**x - 2 x**y**z` from the standard
`NCAlgebra` format into an `NCPoly` object. The reason for the braces
in the definition of `vars` will be explained below, when we introduce
*ordering*. See also Section
[Noncommutative Gröbner Basis](#NCGB). The result in this case is the
`NCPoly` object
	
	NCPoly[{1, 1, 1}, <|{0, 0, 0, 0} -> 1, {0, 0, 2, 0} -> 1, {1, 1, 1, 5} -> -2|>]
	
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
equivalent to a constant `1`.

The particular coefficients in the `NCPoly` object depend not only on
the polynomial being represented but also on the *ordering* implied by
the sequence of symbols in the list of variables `vars`. For example:

    vars = {{x}, {y, z}};
	p = NCToNCPoly[1 + x**x - 2 x**y**z, vars]

produces:

	NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {0, 2, 0} -> 1, {2, 1, 5} -> -2|>

The sequence of braces in the list of *variables* encodes the
*ordering* to be used for sorting `NCPoly`s. Orderings specify how
monomials should be ordered, and is discussed in detail in
[Noncommutative Gröbner Basis](#NCGB). We provide the convenience
command [`NCPolyDisplayOrder`](#NCPolyDisplayOrder) that prints the
polynomial ordering implied by a list of symbols. For example

	NCPolyDisplayOrder[{x,y,z}]

prints out 

$x \ll y \ll z$

and 

	NCPolyDisplayOrder[{{x},{y,z}}]

prints out 

$x \ll y < z$

from where you can see that grouping variables inside braces induces a
graded type ordering, as discussed in [Noncommutative Gröbner
Basis](#NCGB). `NCPoly`s constructed from different orderings cannot
be combined.

There is also a special constructor for monomials. For example

	NCPolyMonomial[{y,x}, vars]
	NCPolyMonomial[{x,y}, vars]

return the monomials corresponding to $y x$ and $x y$.

Operations on `NCPoly` objects result in another `NCPoly` object that
is always expanded. For example:

    vars = {{x}, {y, z}};
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

whereas

	NCPolyToNC[p, vars]

would return

	1 + z - 2 x**x + x**x**x

in which the sorting of the monomials has been destroyed by `Plus`.

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
\begin{bmatrix}	0 & 0 \\ 0 & 1 \end{bmatrix}
+
\begin{bmatrix} a \\ 0 \end{bmatrix}
x
\begin{bmatrix}	1 & 0 \end{bmatrix}
+
\begin{bmatrix} 1 \\ 0 \end{bmatrix}
x
\begin{bmatrix} a^T & 0 \end{bmatrix}
+
\begin{bmatrix} -1 \\ 0 \end{bmatrix}
x q x
\begin{bmatrix}	1 & 0 \end{bmatrix}
+ \\ & \qquad \quad
\begin{bmatrix} b \\ 0 \end{bmatrix}
x
\begin{bmatrix} 0 & 1 \end{bmatrix}
+
\begin{bmatrix} 0 \\ 1 \end{bmatrix}
x
\begin{bmatrix} b^T & 0 \end{bmatrix}
+
\begin{bmatrix} c \\ 0 \end{bmatrix}
y
\begin{bmatrix} 1 & 0 \end{bmatrix}
+
\begin{bmatrix} 1 \\ 0 \end{bmatrix}
y^T
\begin{bmatrix} c^T & 0 \end{bmatrix}
\end{aligned}
$$

See section [linear polynomials](#Linear) for more features on
linear polynomial matrices.

## Linear polynomials {#Linear}

Another interesting class of nc polynomials is that of linear
polynomials, which can be factored in the form:
$$
	s(x) = l (F \otimes x) r
$$
where $l$ and $r$ are vectors with symbolic expressions and $F$ is a
numeric matrix. This functionality is in the package

	<< NCSylvester`

Use the command [`NCToNCSylvester`](#NCToNCSylvester) to factor a
linear nc polynomial into the the above form. For example:

	vars = {x, y};
	expr = 1 + a**x + x**tp[a] - x + b**y**d + tp[d]**tp[y]**tp[b];
	{const, lin} = NCToNCSylvester[expr, vars];

which returns

	const = 1

and an `Association` `lin` containing the factorization. For example

	lin[x]
	
returns a list with the left and right vectors `l`
and `r` and the coefficient array `F`. 

	{{1, a}, {1, a^T}, SparseArray[< 2 >, {2, 2}]}

which in this case is the matrix:

$$
\begin{bmatrix}
	-1 & 1\\
	1 & 0
\end{bmatrix}
$$

and 
	
	lin[tp[y]]
	
returns

	{{d^T}, {b^T}, SparseArray[< 1 >, {1, 1}]}

Note that transposes and adjoints are treated as independent
variables.

Perhaps the most useful consequence of the above factorization is the
possibility of producing a linear polynomial which has the smallest
possible number of terms, as explaining in detail in
[@oliveira:SSP:2012]. This is done automatically by
[`NCSylvesterToNC`](#NCSylvesterToNC). For example

	vars = {x, y};
	expr = a**x**c - a**x**d - a**y**c + a**y**d + b**x**c - b**x**d - b**y**c + b**y**d;
	{const, lin} = NCToNCSylvester[expr, vars];
	NCSylvesterToNC[{const, lin}]
	
produces:

	(a + b)**x**(c - d) + (a + b)**y**(-c + d)

This factorization even works with linear matrix polynomials, and is
used by the our semidefinite programming algorithm (see Chapter
[Semidefinite Programming](#SemidefiniteProgramming)) to factor linear
matrix inequalities in the least possible number of terms. For example:

	vars = {x};
	expr = {{a**x + x**tp[a], b**x, tp[c]},
            {x**tp[b], -1, tp[d]},
	        {c, d, -1}};
	{const, lin} = NCToNCSylvester[expr, vars]

result in:

	const = SparseArray[< 6 >, {3, 3}]
	lin = <|x -> {{1, a, b}, {1, tp[a], tp[b]}, SparseArray[< 4 >, {9, 9}]}|>

See [@oliveira:SSP:2012] for details on the structure of the constant
array $F$ in this case.
