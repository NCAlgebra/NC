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

NCAlgebra comes with special packages for efficiently storing and
calcuating with NC polynomials. Those packages are

* [`NCPoly`](#PackageNCPoly): which handles polynomials with real
  coefficients, and
* [`NCPolynomial`](#PackageNCPolynomial): which handles polynomials
  with noncommutative coefficients.

For example:

    1 + y**x**y - Sqrt[2] x

is a polynomial with real coefficients in $x$ and $y$, whereas

    a**y**b**x**c**y - Sqrt[2] x**d

is a polynomial with nc coefficients in $x$ and $y$, where the letters
$a$, $b$, $c$, and $d$, are the *nc coefficients*. Of course

    1 + y**x**y - Sqrt[2] x

is a polynomial with nc coefficients if one considers only $x$ as the
variable of interest.

In order to take full advantage of [`NCPoly`](#PackageNCPoly) and
[`NCPolynomial`](#PackageNCPolynomial) one would need to *convert* an
expression into those special formats. However, there are several
commands in NCAlgebra that will automatically convert into one of
these special forms without the users having to intervene. One of
those commands is `NCCollect`, which was introduced above. Some
commands are similar to the native Mathematica polynomial
commands. For example:

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

See [NCPolyInterface](#PackageNCPolyInterface) and
[NCPoly](#PackageNCPoly) for detail.s

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

## Calculus

One can calculate directional derivatives with `DirectionalD` and
noncommutative gradients with `NCGrad`.

    In[50]:= DirectionalD[x**x,x,h]
    Out[50]= h**x+x**h
    In[51]:= NCGrad[tp[x]**x+tp[x]**A**x+m**x,x]
    Out[51]= m+tp[x]**A+tp[x]**tp[A]+2 tp[x]

?? ADD INTEGRATE AND HESSIAN ??

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
