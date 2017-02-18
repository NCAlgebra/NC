# Most Basic Commands {#MostBasicCommands}

This chapter provides a gentle introduction to some of the commands
available in `NCAlgebra`. Before you can use `NCAlgebra` you first
load it with the following commands:

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

**Version 5.0:** transposes (`tp`), adjoints (`aj`) and complex
conjugates (`co`) in a notebook environment render as $x^T$, $x^*$,
and $\bar{x}$.

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

USe [NCMakeRuleSymmetric](#NCMakeRuleSymmetric) and
[NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint) to automatically
create symmetric and self adjoint versions of your rules:

	NCReplaceAll[tp[b**a]+b**a, NCMakeRuleSymmetric[b ** a -> c]]

returns

	c + tp[c]

The difference between `NCReplaceAll` and `NCReplaceRepeated` can be
understood in the example:

	NCReplaceAll[a ** b ** b, a ** b -> a]

that results in

	a ** b

and

	NCReplaceRepeated[a ** b ** b, a ** b -> a]

that results in

	a
	
Beside `NCReplaceAll` and `NCReplaceRepeated` we offer `NCReplace` and
`NCReplaceList`, which are analogous to the standard `ReplaceAll`
(`/.`), `ReplaceRepeated` (`//.`), `Replace` and `ReplaceList`. Note
that one rarely uses `NCReplace` and `NCReplaceList`. 	

**Version 5.0:** the commands `Substitute` and `Transform` have been
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

NCAlgebra provides some commands for noncommutative polynomial
manipulation that are similar to the native Mathematica (commutative)
polynomial commands. For example:

	expr = B + A y ** x ** y - 2 x
	NCVariables[expr]

returns

	{x,y}

and

	NCCoefficientList[expr, vars]
	NCMonomialList[expr, vars]
	NCCoefficientRules[expr, vars]

returns

	{B, -2, A}
	{1, x, y ** x ** y}
	{1 -> B, x -> -2, y ** x ** y -> A}

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
storing and calcuating with NC polynomials. Those packages are

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

**Version 5.0:** introduces experimental support for integration of nc
polynomials. See [`NCIntegrate`](#NCIntegrate).

## Matrices

`NCAlgebra` has many algorithms that handle matrices with
noncommutative entries.

    In[52]:= m1={{a,b},{c,d}}
    Out[52]= {{a,b},{c,d}}
    In[53]:= m2={{d,2},{e,3}}
    Out[53]= {{d,2},{e,3}}
    In[54]:= MatMult[m1,m2]
    Out[54]= {{a**d+b**e,2 a+3 b},{c**d+d**e,2 c+3 d}}

?? ADD NCInverse, and much more ??
