# Noncommutative Gröbner Basis {#NCGB}

Gröbner Basis are useful in the study of algebraic relations. The
package `NCGBX` provides an implementation of a noncommutative Gröbner
Basis algorithm.

> Starting with **Version 6**, the old `C++` version of our Groebner
> Basis Algorithm is no longer included.

If you want a living version of this chapter just run the notebook
`NC/DEMOS/3_NCGroebnerBasis.nb`.

In order to load `NCGBX` one types:

	<< NC`
	<< NCAlgebra`
	<< NCGBX`

or simply

	<< NCGBX`

if `NC` and `NCAlgebra` have already been loaded.

## What is a Gröbner Basis?

Most commutative algebra packages contain commands based on Gröbner
Basis and uses of Gröbner Basis. For example, in Mathematica, the
`Solve` command puts collections of equations in a *canonical form*
which, for simple collections, readily yields a solution. Likewise,
the Mathematica `Eliminate` command tries to convert a collection of
$m$ polynomial equations (often called relations)

$$\begin{aligned}
	p_1(x_1,\ldots,x_n) &= 0 \\
	p_2(x_1,\ldots,x_n) &= 0 \\
	\vdots \quad & \quad \, \, \vdots \\
	p_m(x_1,\ldots,x_n) &= 0
\end{aligned}$$
	
in variables $x_1,x_2, \ldots x_n$ to a *triangular* form, that is a
new collection of equations like

$$\begin{aligned}
	q_1(x_1) &= 0 \\
	q_2(x_1,x_2) &= 0 \\
	q_3(x_1,x_2) &= 0 \\
	q_4(x_1,x_2,x_3)&=0 \\
	\vdots \quad & \quad \, \, \vdots \\
	q_{r}(x_1,\ldots,x_n) &= 0.
\end{aligned}$$

Here the polynomials $\{q_j: 1\le j\le k_2\}$ generate the same
*ideal* that the polynomials $\{p_j : 1\le j \le k_1\}$
generate. Therefore, the set of solutions to the collection of
polynomial equations $\{p_j=0: 1\le j\le k_1\}$ equals the set of
solutions to the collection of polynomial equations $\{q_j=0: 1\le
j\le k_2\}$. This canonical form greatly simplifies the task of
solving collections of polynomial equations by facilitating
backsolving for $x_j$ in terms of $x_1,\ldots,x_{j-1}$.

Readers who would like to know more about Gröbner Basis may want to
read [CLS]. The noncommutatative version of the algorithm implemented
by `NCGB` is loosely based on [Mora].

## Solving Equations

Before calculating a Gröbner Basis, one must declare which variables
will be used during the computation and must declare a *monomial
order* which can be done using `SetMonomialOrder` as in:

	SetMonomialOrder[{a, b, c}, x];

The monomial ordering imposes a relationship between the variables
which are used to *sort* the monomials in a polynomial. The ordering
implied by the above command can be visualized using:

	PrintMonomialOrder[]
	
which in this case prints:

$$a < b < c \ll x.$$

A user does not need to know theoretical background related to
monomials orders. Indeed, as we shall see soon, in many engineering
problems, it suffices to know which variables correspond to quantities
which are *known* and which variables correspond to quantities which
are *unknown*. If one is solving for a variable or desires to prove
that a certain quantity is zero, then one would want to view that
variable as *unknown*. In the above example, the symbol '$\ll$'
separate the *knowns*, $a, b, c$, from the *unknown*, $x$. For more
details on orderings see Section [Orderings](#Orderings).

Our goal is to calculate the Gröbner basis associated with the
following relations (i.e. a list of polynomials):

$$\begin{aligned}
	a \, x \, a &= c, &
	a \, b &= 1, &
	b \, a &= 1.
\end{aligned}$$

We shall use the word *relation* to mean a polynomial in noncommuting
indeterminates. For example, if an analyst saw the equation $A B = 1$
for matrices $A$ and $B$, then he might say that $A$ and $B$ satisfy
the polynomial equation $a\, b - 1 = 0$. An algebraist would say that
$a\, b - 1$ is a relation.

To calculate a Gröbner basis one defines a list of relations:

	rels = {a**x**a - c, a**b - 1, b**a - 1}

and issues the command:
	
	gb = NCMakeGB[rels, 10]

which should produce an output similar to:
```output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: a < b < c << x
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 4 polys in the basis, 2 obstructions
> MAJOR Iteration 2, 5 polys in the basis, 2 obstructions
* Cleaning up...
* Found Groebner basis with 3 polynomials
* * * * * * * * * * * * * * * *
```
The number `10` in the call to `NCMakeGB` is very important because a
finite GB may not exist. It instructs `NCMakeGB` to abort after `10`
iterations if a GB has not been found at that point.

The result of the above calculation is the list of relations in the
form of a list of rules:
```output           
{x -> b**c**b, a**b -> 1, b**a -> 1}
```
> **Version 5:** For efficiency, `NCMakeGB` returns a list of rules
> instead of a list of polynomials. The left-hand side of the rule is
> the leading monomial in the current order. This is incompatible with
> early versions, which returned a list of polynomials. You can
> recover the old behavior setting the option `ReturnRules ->
> False`. This can be done in the `NCMakeGB` command or globally
> through `SetOptions[ReturnRules -> False]`.

Our favorite format for displaying lists of relations is `ColumnForm`.
           
	ColumnForm[gb]
	
which results in 
```output
x -> b**c**b
a**b -> 1
b**a -> 1
```
The *rules* in the output represent the relations in the GB with the
left-hand side of the rule being the leading monomial. Replacing
`Rule` by `Subtract` recovers the relations but one would then loose
the leading monomial as Mathematica alphabetizes the resulting sum.

Someone not familiar with GB's might find it instructive to note this
output GB effectively *solves* the input equation

$$a \, x \, a - c = 0$$

under the assumptions that 

$$\begin{aligned}
	b \, a - 1 &= 0, &
	a \, b - 1 & =0,
\end{aligned}$$

that is $a = b^{-1}$ and produces the expected result in the form of
the relation:

$$ x = b \, c \, b. $$

## A Slightly more Challenging Example

For a slightly more challenging example consider the same monomial
order as before:

	SetMonomialOrder[{a, b, c}, x];

that is

$a < b < c \ll x$

and the relations:

$$\begin{aligned}
  a \, x - c &= 0, \\
  a \, b \, a - a &= 0, \\
  b \, a \, b - b &= 0,
\end{aligned}$$

from which one can recognize the problem of solving the linear
equation $a \, x = c$ in terms of the *pseudo-inverse* $b =
a^\dag$. The calculation:

	gb = NCMakeGB[{a**x - c, a**b**a - a, b**a**b - b}, 10];
	ColumnForm[gb]

finds the Gröbner basis:
```output
a**x -> c
a**b**c -> c
a**b**a -> a 
b**a**b -> b
```
In this case the Gröbner basis cannot quite *solve* the equations but
it remarkably produces the necessary condition for existence of
solutions:

$$ 0 = a \, b \, c - c = a \, a^\dag c - c $$ 

that can be interpreted as $c$ being in the range-space of $a$.

## Simplifying Polynomial Expressions

Our goal now is to verify if it is possible to *simplify* the following
expression:

	expr = b^2**a^2 - a^2**b^2 + a**b**a

knowing that

$$ a \, b \, a = b $$

using Gröbner basis. With that in mind we set the ordering:

	SetMonomialOrder[a,b];

and calculate the GB associated with the constraint:

	rels = {a**b**a - b};
	rules = NCMakeGB[rels, 10];
	ColumnForm[rules]

which produces the output
```output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: a << b
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 2 polys in the basis, 1 obstructions
* Cleaning up...
* Found Groebner basis with 2 polynomials
* * * * * * * * * * * * * * * *
```
and the associated GB
```output
a**b**a -> b
b^2**a -> a**b^2
```
The GB revealed another relationship that must hold true if $a \, b \,
a = b$. One can use these relationships to simplify the original
expression using `NCReplaceRepeated` as in
 
	NCReplaceRepeated[expr, rules, ApplyPowerRule -> True]

which simplifies `expr` into `b`.

An alternative, since we are working with polynomials, is to use
[`NCReduce`](#NCReduce) as in

	vars = GetMonomialOrder[];
	NCReduce[expr, NCRuleToPoly[rules], vars]

Note that `NCReduce` needs a list of variables to be used as the
desired ordering, which we obtain from the current ordering using
[`GetMonomialOrder`](#GetMonomialOrder), and that the rules in `rules`
need to be converted to polynomials, which we do using
[`NCRuleToPoly`](NCRuleToPoly).

## Polynomials and Rules {#PolynomialsAndRules}

Having seen how polynomial relations can be interpreted as rules,
consider the expression

	expr = b^2**a^2 + a^2**b^3 + a**b**a

and the polynomial relations

	rels = {a**b**a - b , b^2 - a + b}

With respect to the monomial ordering

	SetMonomialOrder[a, b];

we can interpret these relations as the rules

	vars = GetMonomialOrder[];
	(rules = NCToRule[rels, vars]) // ColumnForm
	
that is
```output
a**b**a -> b
b^2 -> a - b
```

Note how we used [`GetMonomialOrder`](#GetMonomialOrder) to obtain the
list of variables `vars` corresponding to the ordering

$$ a \ll b$$

and [`NCToRule`](#NCToRule) to convert the polynomial relations into
rules.

We can then apply these rules by using one of the `NCReplace`
functions, for example

	NCExpandReplaceRepeated[expr, rules, ApplyPowerRule -> True]

which produces
```output
b + a^2**b + a^3**b - b**a^2
```
Note that we have made use of the new function
[`NCExpandReplaceRepeated`](#NCExpandReplaceRepeated), to automate
the tedious cycles of expansion and substitution.

Alternatively, one can use [`NCReduce`](#NCReduce) to perform the same
substitution. `NCReduce` takes in polynomial, instead of rules, and a
list of variables. For example,

    NCReduce[expr, rels, vars]

produces
```output
a^2**b + a^3**b - b**a^2 + a**b**a
```
which is the result of applying the rules only to the leading monomial
of `expr`. If you want substitutions to be applied to all monomials
then set the option `Complete` to `True`, as in

    NCReduce[expr, rels, vars, Complete -> True]

This produces
```output
b + a^2**b + a^3**b - b**a^2
```
which is the same result as above.

But, of course, by now one should wonder whether the above polynomial
relations could imply other simplifications, which we seek to find out
by running our Gröbner basis algorithm:

	rules = NCMakeGB[rels, 4];
	ColumnForm[rules]

that discovers the following additional relations
```output
b^2 -> a - b
b**a -> a**b
a^2**b -> b
a^3 -> a
```
When used for simplification,
  
	NCExpandReplaceRepeated[expr, rules, ApplyPowerRule -> True]

reduces the original expression to the even simpler form
```output
b + a**b
```
As before, rule substitution could also be performed by
[`NCReduce`](#NCReduce) as in

	NCReduce[expr, NCRuleToPoly[rules], vars]

that, in this case, leads to the same result as above without the need
to recourse to the `Complete` flag.

## Minimal versus Reduced Gröbner Basis

The algorithm implemented by `NCGB` always produces a Gröbner Basis
with the *minimal* possible number of polynomials. However, such
polynomials are not necessarily the "simplest" possible polynomials;
called the *reduced* Gröbner Basis. The *reduced* Gröbner Basis is
unique given the relations and the monomial ordering. Consider for
example the following monomial ordering

    SetMonomialOrder[x, y]
	
and the relations

    rels = {x^3 - 2 x**y, x^2**y - 2 y^2 + x}
	
for which

    NCMakeGB[rels] // ColumnForm
	
produces the *minimal* Gröbner Basis
```output
x^2->0
x**y->x^3/2
y**x->x**y
y^2->x/2+x^2**y/2
```
but 

    NCMakeGB[rels, ReduceBasis -> True] // ColumnForm

returns the *reduced* Gröbner Basis
```output
x^2->0
x**y->0
y**x->0
y^2->x/2
```
in which not only the leading monomials but also all lower-order
monomials have been reduced by the basis' leading monomials.

## Simplifying Rational Expressions {#SimplifyingRationalExpressions}

It is often desirable to simplify expressions involving inverses of
noncommutative expressions. One challenge is to recognize identities
implied by the existence of certain inverses. For example, that the
expression

    expr = x**inv[1 - x] - inv[1 - x]**x

is equivalent to $0$. One can use a nc Gröbner basis for that task.
Consider for instance the ordering

$$ x \ll (1-x)^{-1} $$

implied by the command:

	SetMonomialOrder[x, inv[1-x]]

This ordering encodes the following precise idea of what we mean by
*simple* versus *complicated*: it formally corresponds to specifying
that $x$ is simpler than $(1-x)^{-1}$, which might sits well with
one's intuition.

Now consider the following command:

	(rules = NCMakeGB[{}, 3]) // ColumnForm

which produces the output
```output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: x <<  inv[x] << inv[1 - x]
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 6 polys in the basis, 6 obstructions
* Cleaning up...
* Found Groebner basis with 6 polynomials
* * * * * * * * * * * * * * * *
```
and results in the rules:
```output
x**inv[1 - x] -> -1 + inv[1 - x],
inv[1-x]**x -> -1 + inv[1-x],
```
As in the previous example, the GB revealed new relationships that
must hold true if $1- x$ is invertible, and one can use this
relationship to *simplify* the original expression using
`NCReplaceRepeated` as in:

	NCReplaceRepeated[expr, rules, ApplyPowerRule -> True]

The above command results in `0`, as one would hope.

For a more challenging example consider the identity:

$$\left (1 - x - y (1 - x)^{-1} y \right )^{-1} = \frac{1}{2} (1 - x - y)^{-1} + \frac{1}{2} (1 - x + y)^{-1}$$

One can verify that the rule based command
[NCSimplifyRational](#NCSimplifyRational) fails to simplify the
expression:

	expr = inv[1 - x - y**inv[1 - x]**y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
	NCSimplifyRational[expr]

We set the monomial ordering and calculate the Gröbner basis

	SetMonomialOrder[x, y, inv[1-x], inv[1-x+y], inv[1-x-y], inv[1-x-y**inv[1-x]**y]];
	(rules = NCMakeGB[{}, 3]) // ColumnForm

based on the rational involved in the original expression. The result
is the nc GB:
```output
inv[1-x-y**inv[1-x]**y] -> (1/2)inv[1-x-y]+(1/2)inv[1-x+y]
x**inv[1-x] -> -1+inv[1-x]
y**inv[1-x+y] -> 1-inv[1-x+y]+x**inv[1-x+y]
y**inv[1-x-y] -> -1+inv[1-x-y]-x**inv[1-x-y]
inv[1-x]**x -> -1+inv[1-x]
inv[1-x+y]**y -> 1-inv[1-x+y]+inv[1-x+y]**x
inv[1-x-y]**y -> -1+inv[1-x-y]-inv[1-x-y]**x
inv[1-x+y]**x**inv[1-x-y] -> -(1/2)inv[1-x-y]-(1/2)inv[1-x+y]+inv[1-x+y]**inv[1-x-y]
inv[1-x-y]**x**inv[1-x+y] -> -(1/2)inv[1-x-y]-(1/2)inv[1-x+y]+inv[1-x-y]**inv[1-x+y]
```
which successfully simplifies the original expression using:

	NCReplaceRepeated[expr, rules, ApplyPowerRule -> True] // NCExpand
	NCReplaceRepeated[%, rules, ApplyPowerRule -> True]

resulting in `0`.

See also [Advanced Processing of Rational
Expressions](#AdvancedProcessingOfRationalExpressions) for more
details on the lower level handling of rational expressions.

## Simplification with NCGBSimplifyRational

The simplification process described above is automated in the
function [NCGBSimplifyRational](#NCGBSimplifyRational). 

For example, calls to

	expr = x**inv[1 - x] - inv[1 - x]**x
	NCGBSimplifyRational[expr]

or

	expr = inv[1 - x - y**inv[1 - x]**y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
	NCGBSimplifyRational[expr]

both result in `0`.

## Ordering on Variables and Monomials {#Orderings}

As seen above, one needs to declare a *monomial order* before making a
Gröbner Basis.  There are various monomial orders which can be used
when computing Gröbner Basis. The most common are *lexicographic* and
*graded lexicographic* orders. We consider also *multi-graded
lexicographic* orders. 

Lexicographic and multi-graded lexicographic orders are examples of
elimination orderings. An elimination ordering is an ordering which is
used for solving for some of the variables in terms of others.

We now discuss each of these types of orders.

### Lex Order: the simplest elimination order

To impose lexicographic order, say $a\ll b\ll x\ll y$ on $a$, $b$, $x$
and $y$, one types

	SetMonomialOrder[a,b,x,y];

or, equivalently

	SetMonomialOrder[{a},{b},{x},{y}];

This order is useful for attempting to solve for $y$ in terms of $a$,
$b$ and $x$, since the highest priority of the GB algorithm is to
produce polynomials which do not contain $y$. If producing high order
polynomials is a consequence of this fanaticism so be it. Unlike
graded orders, lex orders pay little attention to the degree of terms.
Likewise its second highest priority is to eliminate $x$.

Once this order is set, one can use all of the commands in the
preceding section in exactly the same form.

We now give a simple example how one can solve for 
$y$ given that $a$,$b$,$x$ and $y$
satisfy the equations:

$$\begin{aligned}
-b\, x + x\, y  \, a + x\, b \, a \,  a &= 0 \\
x \, a-1&=0 \\
a\, x-1&=0
\end{aligned}$$

The command

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4] // ColumnForm

produces the Gröbner basis:
```output
y -> -b**a + a**b**x^2
a**x -> 1 
x**a -> 1
```
after one iteration.

Now, we change the ordering to 

	SetMonomialOrder[y,x,b,a];

and run the same `NCMakeGB` as above:

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4] // ColumnForm
	
which, this time, results in
```output	
b**x^3 -> x**b+x**y**x
x**a -> 1
a**x -> 1
x**b**a -> b**x^2 - x**y
a**b**x^2 -> y+b**a
x**b^2**a -> -x**b**y+b**x^2**b**x^2 - 
    x**y**b**x^2
b**a^2 -> -y**a+a**b**x
b**a**b**a -> -y^2 - b**a**y - y**b**a+
    a**b**x**b**x^2
b**a**b^2**a -> -y**b**y - y**b^2**a - 
    y^2**b**x^2 - b**a**b**y - b**a**y**b**x^2+
    a**b**x**b**x^2**b**x^2
```
which is not a Gröbner basis since the algorithm was interrupted at 4
iterations. Note the presence of the rule
```output
a**b**x**x -> y+b**a
```	
which shows that the ordering is not set up to solve for $y$ in terms of
the other variables in the sense that $y$ is not on the left hand side
of this rule (but a human could easily solve for $y$ using this rule).
Also the algorithm created a number of other relations which involved
$y$.
 
### Graded Lex Ordering: a non-elimination order 

To impose graded lexicographic order, say $a< b< x< y$ on $a$,
$b$, $x$ and $y$, one types

	SetMonomialOrder[{a,b,x,y}];

This ordering puts high degree monomials high in the ordering. Thus it
tries to decrease the total degree of expressions. A call to 

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4,ReduceBasis->True] // ColumnForm

now produces
```output
a**x -> 1,
x**a -> 1,
b**a^2 -> -y**a+a**b**x,
x**b**a -> b**x^2 - x**y,
a**b**x^2 -> y+b**a,
b**x^3 -> x**b+x**y**x,
a**b**x**b**x^2 -> y^2+b**a**y+y**b**a+b**a**b**a,
b**x^2**b**x^2 -> x**b**y+x**b^2**a+x**y**b**x^2,
a**b**x**b**x**b**x^2 -> y^3+b**a**y^2+y^2**b**a+y**b**a**y+
                         b**a**b**a**y+b**a**y**b**a+
                         y**b**a**b**a+b**a**b**a**b**a,
b**x^2**b**x**b**x^2 -> x**b**y^2+x**b^2**a**y+x**b**y**b**a+
                        x**b^2**a**b**a+x**y**b**x**b**x^2
```
which again fails to be a Gröbner basis and does not eliminate
$y$. Instead, it tries to decrease the total degree of expressions
involving $a$, $b$, $x$, and $y$.

### Multigraded Lex Ordering: a variety of elimination orders 

There are other useful monomial orders which one can use other than
graded lex and lex.  Another type of order is what we call multigraded
lex and is a mixture of graded lex and lex order. To impose
multi-graded lexicographic order, say $a< b< x\ll y$ on $a$, $b$, $x$
and $y$, one types

	SetMonomialOrder[{a,b,x},y];

which separates $y$ from the remaining variables. This time, a call to

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4,ReduceBasis->True] // ColumnForm

yields once again
```output
y -> -b**a+a**b**x^2
a**x -> 1
x**a -> 1
```
which not only eliminates $y$ but is also Gröbner basis, calculated
after one iteration. 

For an intuitive idea of why multigraded lex is helpful, we think of
$a$, $b$, and $x$ as corresponding to variables in some engineering
problem which represent quantities which are *known* and $y$ to be
*unknown*.  The fact that $a$, $b$ and $x$ are in the top level
indicates that we are very interested in solving for $y$ in terms of
$a$, $b$, and $x$, but are not willing to solve for, say $x$, in terms
of expressions involving $y$.

This situation is so common that we provide the commands `SetKnowns`
and `SetUnknowns`. The above ordering would be obtained after setting

	SetKnowns[a,b,x];
	SetUnknowns[y];

## A Complete Example: the partially prescribed matrix inverse problem

This is a type of problem known as a *matrix completion problem*. This
particular one was suggested by Hugo Woerdeman. We are grateful to
him for discussions.

**Problem:** *Given matrices $a$, $b$, $c$, and $d$, we wish to
  determine under what conditions there exists matrices x, y, z, and w
  such that the block matrices*

$$\begin{bmatrix} a & x \\ y & b \end{bmatrix}
  \qquad 
  \begin{bmatrix} w & c \\ d & z \end{bmatrix}$$

*are inverses of each other. Also, we wish to find formulas for $x$, $y$,
  $z$, and $w$.*

This problem was solved in a paper by W.W. Barrett, C.R. Johnson,
M. E. Lundquist and H. Woerderman [BJLW] where they showed it splits
into several cases depending upon which of $a$, $b$, $c$ and $d$ are
invertible. In our example, we assume that $a$, $b$, $c$ and $d$ are
invertible and discover the result which they obtain in this case.

First we set the matrices $a$, $b$, $c$, and $d$ and their inverses as
*knowns* and $x$, $y$, $w$, and $z$ as unknowns:

	SetKnowns[a, inv[a], b, inv[b], c, inv[c], d, inv[d]];
	SetUnknowns[{z}, {x, y, w}];

Note that the graded ordering of the unknowns means that we care more
about solving for $x$, $y$ and $w$ than for $z$.

Then we define the relations we are interested in, which are obtained
after multiplying the two block matrices on both sides and equating to
identity

	A = {{a, x}, {y, b}}
	B = {{w, c}, {d, z}}

	rels = {
      NCDot[A, B] - IdentityMatrix[2],
      NCDot[B, A] - IdentityMatrix[2]
    } // Flatten

We use `Flatten` to reduce the matrix relations to a simple list of
relations. The resulting relations in this case are:
```output
rels = {-1+a**w+x**d, a**c+x**z, b**d+y**w, -1+b**z+y**c,
        -1+c**y+w**a, c**b+w**x, d**a+z**y, -1+d**x+z**b}
```
After running

	NCMakeGB[rels, 8] // ColumnForm

we obtain the Gröbner basis:
```output
x -> inv[d]-inv[d]**z**b
y -> inv[c]-b**z**inv[c]
w -> inv[a]**inv[d]**z**b**d
z**b**z -> z+d**a**c
c**b**z**inv[c]**inv[a] -> inv[a]**inv[d]**z**b**d
inv[c]**inv[a]**inv[d]**z**b -> b**z**inv[c]**inv[a]**inv[d]
inv[d]**z**b**d**a -> a**c**b**z**inv[c]
z**b**d**a**c -> d**a**c**b**z
z**inv[c]**inv[a]**inv[d]**inv[b] -> inv[b]**inv[c]**inv[a]**inv[d]**z
z**inv[c]**inv[a]**inv[d]**z -> inv[b]+inv[b]**inv[c]**inv[a]**inv[d]**z
d**a**c**b**z**inv[c] -> z**b**d**a
```
after seven iterations. The first four relations

$$\begin{aligned}
	x &= d^{-1}-d^{-1} \, z \, b \\
	y &= c^{-1}-b \, z \, c^{-1} \\
	w &= a^{-1} \, d^{-1}  \, z \, b \, d \\
	z \, b \, z &= z + d \, a \, c
\end{aligned}$$	

are the solutions we are looking for, which states that one can find
$x$, $y$, $z$, and $w$ such that the matrices above are inverses of
each other if and only if $z \, b \, z = z + d \, a \, c$. The first
three relations gives formulas for $x$, $y$ and $w$ in terms of $z$.

A variety of scenarios can be quickly investigated under different
assumptions. For example, say that $c$ is not invertible. Is it still
possible to solve the problem? One solution is obtained with the
ordering implied by

	SetKnowns[a, inv[a], b, inv[b], c, d, inv[d]];
	SetUnknowns[{y}, {z, w, x}];

In this case

	NCMakeGB[rels, 8] // ColumnForm

produces the Gröbner basis:
```output
z -> inv[b]-inv[b]**y**c
w -> inv[a]-c**y**inv[a]
x -> a**c**y**inv[a]**inv[d]
y**c**y -> y+b**d**a
c**y**inv[a]**inv[d]**inv[b] -> inv[a]**inv[d]**inv[b]**y**c
d**a**c**y**inv[a] -> inv[b]**y**c**b**d
inv[d]**inv[b]**y**c**b -> a**c**y**inv[a]**inv[d]
y**c**b**d**a -> b**d**a**c**y
y**inv[a]**inv[d]**inv[b]**y**c -> 1+y**inv[a]**inv[d]**inv[b]
```
after five iterations. Once again, the first four relations

$$\begin{aligned}
	z &= b^{-1}-b^{-1} \, y \, c \\
	w &= a^{-1}-c \, y \, a^{-1} \\
	x &= a \, c \, y \, a^{-1} \, d^{-1} \\
	y \, c \, y &= y+b \, d \, a
\end{aligned}$$	

provide formulas, this time for $z$, $w$, and $z$ in terms of $y$
satisfying $y \, c \, y = y+b \, d \, a$. Note that these formulas do
not involve $c^{-1}$ since $c$ is no longer assumed invertible.

## Advanced Processing of Rational Expressions {#AdvancedProcessingOfRationalExpressions}

Consider once again the task of simplifying the nc rational expression

    expr = inv[1 - x - y**inv[1 - x]**y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])

considered before in [Simplifying Rational
Expressions](#SimplifyingRationalExpressions). We will use this
expression to illustrate how nc rational expressions can be
manipulated at a lower level, giving advanced users more control of
the conversion process to and from the internal [NCPoly](#NCPoly)
representation.

The key functionality is provided by the functions
[NCMonomialOrder](#NCMonomialOrder) and
[NCRationalToNCPoly](#NCRationalToNCPoly). [NCMonomialOrder](#NCMonomialOrder)
provides the same functionality as
[SetMonomialOrder](#SetMonomialOrder), but instead of setting the
ordering globally, it returns an array representing the ordering. For
example,

    order = NCMonomialOrder[x, y]

produces the array

    {{x},{y}}

which represents the ordering $x \ll y$. 

With a (preliminary) ordering in hand one can invoke
[NCRationalToNCPoly](#NCRationalToNCPoly) as in

    {rels, vars, rules, labels} = NCRationalToNCPoly[expr, order];

This function produces four lists as outputs:

- The first, `rels`, is a list of `NCPoly` objects representing the
  original expression and some additional relations that were
  automatically generated. We will inspect `rels` later.
- The second, `vars`, is a list of variables that represent the
  ordering used in the construction of the polynomials in `rel`. In
  this example,
  ```output
  vars = {{x}, {y}, {rat135, rat136, rat137, rat138}}
  ```
  which corresponds to the ordering $x \ll y \ll rat135 < rat136 <
  rat137 < rat138$. In this case, the variables `rat135`, `rat136`,
  `rat137`, `rat138` were automatically created and assigned an
  ordering by `NCRationalToNCPoly`.
- The third is a list of rules relating the new variables with
  rational terms appearing in the original expression `expr`. In this
  example
  ```output
  rules = {rat135 -> inv[1-x], rat136 -> inv[1-x-y],
           rat137 -> inv[1-x+y], rat138 -> inv[1-x-y**rat135**y]}
  ```
- Finally, the fourth is a list of labels that is used for
  printing or displaying
  ```output
  labesl = {{x}, {y}, 
            {inv[1-x], inv[1-x-y], inv[1-x+y], inv[1-x-y**inv[1-x]**y]}}
  ```
  by `NCMakeGB` and `NCPolyDisplay`.

The relations in `rels` can be visualized by using `NCPolyToNC`. For
example,
  
    NCPolyToNC[#, vars] & /@ rels // ColumnForm

produces
```output
rat138 - rat136/2 - rat137/2 
-1 + rat135 - rat135 ** x
-1 + rat135 - x ** rat135
-1 + rat136 - rat136 ** x - rat136 ** y
-1 + rat136 - x ** rat136 - y ** rat136
-1 + rat137 - rat137 ** x + rat137 ** y
-1 + rat137 - x ** rat137 + y ** rat137
-1 + rat138 - rat138 ** x - rat138 ** y ** rat135 ** y
-1 + rat138 - x ** rat138 - y ** rat135 ** y ** rat138
```
The first entry is simply the original `expr` in which every rational
expression has been substituted by a new variable. The same could be 
obtained by applying reverse `rules` and applying it repeatedly

    NCReplaceRepeated[expr, Reverse /@ rules, ApplyPowerRule -> True]

The remaining entries are polynomials encoding the rational
expressions that have been substituted by new variables. For example,
the first two additional relations,
```output
-1 + rat135 - rat135 ** x
-1 + rat135 - x ** rat135
```
correspond to the assertion that `rat153 == inv[1-x]`, and so on.

Equipped with a set of polynomial relations encoding the rational
expression `expr` on can seek for a Gröebner basis by calling the
low-level implementation [NCPolyGroebner](#NCPolyGroebner) to try to
discover additional implications of the defining relations. In this
example, calling

	{basis, tree} = NCPolyGroebner[Rest[rels], 4, Labels -> labels];

produces an output
```output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: x<<y<<inv[1-x]<inv[1-x-y]<inv[1-x+y]<inv[1-x-y**inv[1-x]**y]
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 10 polys in the basis, 12 obstructions
> MAJOR Iteration 2, 10 polys in the basis, 6 obstructions
>  Found Groebner basis with 9 polynomials
* * * * * * * * * * * * * * * * 
``` 
Note the use of `labels` to pretty print the monomial ordering. 

The resulting basis can be visualized once again using the `labels`

    NCPolyToNC[#, labels] & /@ basis // ColumnForm

which produces
```output
1-inv[1-x]+inv[1-x]**x,
1-inv[1-x]+x**inv[1-x],
1-inv[1-x-y]+inv[1-x-y]**x+inv[1-x-y]**y,
1-inv[1-x-y]+x**inv[1-x-y]+y**inv[1-x-y],
-1+inv[1-x+y]-inv[1-x+y]**x+inv[1-x+y]**y,
-1+inv[1-x+y]-x**inv[1-x+y]+y**inv[1-x+y],
1/2 inv[1-x-y]+1/2 inv[1-x+y]-inv[1-x+y]**inv[1-x-y]+
   inv[1-x+y]**x**inv[1-x-y],
1/2 inv[1-x-y]+1/2 inv[1-x+y]-inv[1-x-y]**inv[1-x+y]+
   inv[1-x-y]**x**inv[1-x+y]},
-1/2 inv[1-x-y]-1/2 inv[1-x+y]+inv[1-x-y**inv[1-x]**y]
```
The original expression `expr` can then be *reduced* by the above
basis by calling

    NCPolyReduce[rels[[1]], basis]

which produces `0`, as expected.

The above process is automated by [NCMakeGB](#NCMakeGB), but advanced
users might want to take advantage of the increased speed of
directly processing `NCPoly`s by manually performing the conversion
from a rational statement to a polynomial statement.
