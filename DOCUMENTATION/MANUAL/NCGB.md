# Noncommutative Gröbner Basis {#NCGB}

The package `NCGBX` provides an implementation of a noncommutative
Gröbner Basis algorithm. It is a Mathematica only replacement to the
C++ `NCGB` which is still provided with this distribution. 

If you want a living version of this chapter just run the notebook
`NC/DEMOS/3_NCGroebnerBasis.nb`.

Gröbner Basis are useful in the study of algebraic relations.

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
$$
	\begin{aligned}
	p_1(x_1,\ldots,x_n) &= 0 \\
	p_2(x_1,\ldots,x_n) &= 0 \\
	\vdots \quad & \quad \, \, \vdots \\
	p_m(x_1,\ldots,x_n) &= 0
	\end{aligned}
$$
	
in variables $x_1,x_2, \ldots x_n$ to a *triangular* form, that is a
new collection of equations like

$$
\begin{aligned}
	q_1(x_1) &= 0 \\
	q_2(x_1,x_2) &= 0 \\
	q_3(x_1,x_2) &= 0 \\
	q_4(x_1,x_2,x_3)&=0 \\
	\vdots \quad & \quad \, \, \vdots \\
	q_{r}(x_1,\ldots,x_n) &= 0.
	\end{aligned}
$$
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

## Solving equations

Before calculating a Gröbner Basis, one must declare which variables
will be used during the computation and must declare a *monomial
order* which can be done using `SetMonomialOrder` as in:

	SetMonomialOrder[{a, b, c}, x];

The monomial ordering imposes a relationship between the variables
which are used to *sort* the monomials in a polynomial. The ordering
implied by the above command can be visualized using:

	PrintMonomialOrder[];
	
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
$$
\begin{aligned}
	a \, x \, a &= c, &
	a \, b &= 1, &
	b \, a &= 1.
\end{aligned}
$$
We shall use the word *relation* to mean a polynomial in noncommuting
indeterminates. For example, if an analyst saw the equation $A B = 1$
for matrices $A$ and $B$, then he might say that $A$ and $B$ satisfy
the polynomial equation $a\, b - 1 = 0$. An algebraist would say that
$a\, b - 1$ is a relation.

To calculate a Gröbner basis one defines a list of relations:

	rels = {a ** x ** a - c, a ** b - 1, b ** a - 1}

and issues the command:
	
	gb = NCMakeGB[rels, 10]

which should produces an output similar to:

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

The number `10` in the call to `NCMakeGB` is very important because a
finite GB may not exist. It instructs `NCMakeGB` to abort after `10`
iterations if a GB has not been found at that point.

The result of the above calculation is the list of relations in the
form of a list of rules:
           
	{x -> b ** c ** b, a ** b -> 1, b ** a -> 1}

**Version 5:** For efficiency, `NCMakeGB` returns a list of rules
  instead of a list of polynomials. The left-hand side of the rule is
  the leading monomial in the current order. This is incompatible with
  early versions, which returned a list of polynomials. You can
  recover the old behavior setting the option `ReturnRules ->
  False`. This can be done in the `NCMakeGB` command or globally
  through `SetOptions[ReturnRules -> False]`.

Our favorite format for displaying lists of relations is `ColumnForm`.
           
	ColumnForm[gb]
	
which results in 

	x -> b ** c ** b
	a ** b -> 1
	b ** a -> 1

The *rules* in the output represent the relations in the GB with the
left-hand side of the rule being the leading monomial. Replacing
`Rule` by `Subtract` recovers the relations but one would then loose
the leading monomial as Mathematica alphabetizes the resulting sum.

Someone not familiar with GB's might find it instructive to note this
output GB effectively *solves* the input equation
$$
	a \, x \, a - c = 0
$$
under the assumptions that 
$$
\begin{aligned}
	b \, a - 1 &= 0, &
	a \, b - 1 & =0,
\end{aligned}
$$
that is $a = b^{-1}$ and produces the expected result in the form of
the relation:
$$
	x = b \, c \, b.
$$

## A slightly more challenging example

For a slightly more challenging example consider the same monomial
order as before:

	SetMonomialOrder[{a, b, c}, x];

that is

$a < b < c \ll x$

and the relations:
$$
\begin{aligned}
  a \, x - c &= 0, \\
  a \, b \, a - a &= 0, \\
  b \, a \, b - b &= 0,
\end{aligned}
$$
from which one can recognize the problem of solving the linear
equation $a \, x = c$ in terms of the *pseudo-inverse* $b =
a^\dag$. The
calculation:

	gb = NCMakeGB[{a ** x - c, a ** b ** a - a, b ** a ** b - b}, 10];

finds the Gröbner basis:

	a ** x -> c
	a ** b ** c -> c
	a ** b ** a -> a 
	b ** a ** b -> b

In this case the Gröbner basis cannot quite *solve* the equations but
it remarkably produces the necessary condition for existence of
solutions:
$$ 
	0 = a \, b \, c - c = a \, a^\dag c - c 
$$ 
that can be interpreted as $c$ being in the range-space of $a$.

## Simplifying polynomial expresions

Our goal now is to verify if it is possible to *simplify* the following
expression:
$$
b \, b \, a \, a - a \, a \, b \, b + a \, b \, a
$$
if we know that
$$
a \, b \, a = b
$$
using Gröbner basis. With that in mind we set the order:

	SetMonomialOrder[a,b];

and calculate the GB associated with the constraint:

	rels = {a ** b ** a - b};
	rules = NCMakeGB[rels, 10];

which produces the output

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

and the associated GB

	a ** b ** a -> b
	b ** b ** a -> a ** b ** b

The GB revealed another relationship that must hold true if $a \, b \,
a = b$. One can use these relationships to simplify the original
expression using `NCReplaceRepeated` as in
 
	expr = b ** b ** a ** a - a ** a ** b ** b + a ** b ** a
	simp = NCReplaceRepeated[expr, rules]

which results in 

	simp = b

## Simplifying rational expresions

It is often desirable to simplify expressions involving inverses of
noncommutative expressions. One challenge is to recognize identities
implied by the existence of certain inverses. For example, that the
expression
$$
	x (1 - x)^{-1} - (1 - x)^{-1} x
$$
is equivalent to $0$. One can use a nc Gröbner basis for that task.
Consider for instance the order

$$ x \ll (1-x)^{-1} $$

implied by the command:

	SetMonomialOrder[x, inv[1-x]]

This ordering encodes the following precise idea of what we mean by
*simple* versus *complicated*: it formally corresponds to specifying
that $x$ is simpler than $(1-x)^{-1}$, which might sits well with
one's intuition.

Now consider the following command:

	rules = NCMakeGB[{}, 3]

which produces the output

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

and results in the rules:

	x ** inv[1 - x] -> -1 + inv[1 - x],
	inv[1-x] ** x -> -1 + inv[1-x],

As in the previous example, the GB revealed new relationships that
must hold true if $1- x$ is invertible, and one can use this
relationship to \emph{simplify} the original expression using
`NCReplaceRepeated` as in:

	NCReplaceRepeated[x ** inv[1 - x] - inv[1 - x] ** x, rules]

The above command results in `0`, as one would hope.

For a more challenging example consider the identity:
$$
\left (1 - x - y (1 - x)^{-1} y \right )^{-1} = \frac{1}{2} (1 - x - y)^{-1} + \frac{1}{2} (1 - x + y)^{-1}
$$
One can verify that the rule based command
[NCSimplifyRational](#NCSimplifyRational) fails to simplify the
expression:

	expr = inv[1 - x - y ** inv[1 - x] ** y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
	NCSimplifyRational[expr]

We set the monomial order and calculate the Gröbner basis

	SetMonomialOrder[x, y, inv[1-x], inv[1-x+y], inv[1-x-y], inv[1-x-y**inv[1-x]**y]];
	rules = NCMakeGB[{}, 3];

based on the rational involved in the original expression. The result
is the nc GB:

	inv[1-x-y**inv[1-x]**y] -> (1/2)inv[1-x-y]+(1/2)inv[1-x+y]
	x**inv[1-x] -> -1+inv[1-x]
	y**inv[1-x+y] -> 1-inv[1-x+y]+x**inv[1-x+y]
	y**inv[1-x-y] -> -1+inv[1-x-y]-x**inv[1-x-y]
	inv[1-x]**x -> -1+inv[1-x]
	inv[1-x+y]**y -> 1-inv[1-x+y]+inv[1-x+y]**x
	inv[1-x-y]**y -> -1+inv[1-x-y]-inv[1-x-y]**x
	inv[1-x+y]**x**inv[1-x-y] -> -(1/2)inv[1-x-y]-(1/2)inv[1-x+y]+inv[1-x+y]**inv[1-x-y]
	inv[1-x-y]**x**inv[1-x+y] -> -(1/2)inv[1-x-y]-(1/2)inv[1-x+y]+inv[1-x-y]**inv[1-x+y]

which succesfully simplifyes the original expression using:

	expr = inv[1 - x - y ** inv[1 - x] ** y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
	NCReplaceRepeated[expr, rules] // NCExpand

resulting in `0`.

## Simplification with NCGBSimplifyRational

The simplification process described above is automated in the
function [NCGBSimplifyRational](#NCGBSimplifyRational). 

For example, calls to

	expr = x ** inv[1 - x] - inv[1 - x] ** x
	NCGBSimplifyRational[expr]

or

	expr = inv[1 - x - y ** inv[1 - x] ** y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
	NCGBSimplifyRational[expr]

both result in `0`.

## Ordering on variables and monomials {#Orderings}

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

This order is useful for attempting to solve for $y$ in terms of $a$,
$b$ and $x$, since the highest priority of the GB algorithm is to
produce polynomials which do not contain $y$. If producing high order
polynomials is a consequence of this fanaticism so be it. Unlike
graded orders, lex orders pay little attention to the degree of terms.
Likewise its second highest priority is to eliminate $x$.

Once this order is set, one can use all of the commands in the
preceeding section in exactly the same form.

We now give a simple example how one can solve for 
$y$ given that $a$,$b$,$x$ and $y$
satisfy the equations:
$$
\begin{aligned}
-b\, x + x\, y  \, a + x\, b \, a \,  a &= 0 \\
x \, a-1&=0 \\
a\, x-1&=0
\end{aligned}
$$

The command

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4]

produces the Gröbner basis:

	y -> -b**a + a**b**x**x
	a**x -> 1 
	x**a -> 1

after one iteration.

Now, we change the order to 

	SetMonomialOrder[y,x,b,a];

and run the same `NCMakeGB` as above:

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4]
	
which, this time, results in
	
	x**a -> 1
	a**x -> 1
	x**b**a -> -x**y+b**x**x
	b**a**a -> -y**a+a**b**x
	x**b**b**a -> -x**b**y-x**y**b**x**x+b**x**x**b**x**x
	b**x**x**x -> x**b+x**y**x
	b**a**b**a -> -y**y-b**a**y-y**b**a+a**b**x**b**x**x
	a**b**x**x -> y+b**a
	b**a**b**b**a -> -y**b**y-b**a**b**y-y**b**b**a-y**y**b**x**x-
	                 b**a**y**b**x**x+a**b**x**b**x**x**b**x**x

which is not a Gröbner basis since the algorithm was interrupted at 4
iterations. Note the presence of the rule

	a**b**x**x -> y+b**a
	
which shows that the order is not set up to solve for $y$ in terms of
the other variables in the sense that $y$ is not on the left hand side
of this rule (but a human could easily solve for $y$ using this rule).
Also the algorithm created a number of other relations which involved
$y$.
 
### Graded lex ordering: a non-elimination order 

To impose graded lexicographic order, say $a< b< x< y$ on $a$,
$b$, $x$ and $y$, one types

	SetMonomialOrder[{a,b,x,y}];

This ordering puts high degree monomials high in the order. Thus it
tries to decrease the total degree of expressions. A call to 

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4]

now produces

	a**x -> 1
	x**a -> 1
	b**a**a -> -y**a+a**b**x
	x**b**a -> -x**y+b**x**x
	a**b**x**x -> y+b**a
	b**x**x**x -> x**b+x**y**x
	a**b**x**b**x**x -> y**y+b**a**y+y**b**a+b**a**b**a
	b**x**x**b**x**x -> x**b**y+x**b**b**a+x**y**b**x**x
	a**b**x**b**x**b**x**x -> y**y**y+b**a**y**y+y**b**a**y+y**y**b**a+
	                          b**a**b**a**y+b**a**y**b**a+y**b**a**b**a+
                              b**a**b**a**b**a
    b**x**x**b**x**b**x**x -> x**b**y**y+x**b**b**a**y+x**b**y**b**a+
       						  x**b**b**a**b**a+x**y**b**x**b**x**x

which again fails to be a Gröbner basis and does not eliminate
$y$. Instead, it tries to decrease the total degree of expressions
involving $a$, $b$, $x$, and $y$.

### Multigraded lex ordering: a variety of elimination orders 

There are other useful monomial orders which one can use other than
graded lex and lex.  Another type of order is what we call multigraded
lex and is a mixture of graded lex and lex order. To impose
multi-graded lexicographic order, say $a< b< x\ll y$ on $a$, $b$, $x$
and $y$, one types

	SetMonomialOrder[{a,b,x},y];

which separates $y$ from the remaining variables. This time, a call to

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4]

yields once again

	y -> -b**a+a**b**x**x
	a**x -> 1
	x**a -> 1

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

## A complete example: the partially prescribed matrix inverse problem

This is a type of problem known as a *matrix completion problem*. This
particular one was suggested by Hugo Woerdeman. We are grateful to
him for discussions.

**Problem:** *Given matrices $a$, $b$, $c$, and $d$, we wish to
  determine under what conditions there exists matrices x, y, z, and w
  such that the block matrices*
$$  
  \begin{bmatrix} a & x \\ y & b \end{bmatrix}
  \qquad 
  \begin{bmatrix} w & c \\ d & z \end{bmatrix}
$$
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

Note that the graded ordedring of the unknowns means that we care more
about solving for $x$, $y$ and $w$ than for $z$.

Then we define the relations we are interested in, which are obtained
after multiplying the two block matrices on both sides and equating to
identity

	A = {{a, x}, {y, b}}
	B = {{w, c}, {d, z}}

	rels = {
      MatMult[A, B] - IdentityMatrix[2],
      MatMult[B, A] - IdentityMatrix[2]
    } // Flatten

We use `Flatten` to reduce the matrix relations to a simple list of
relations. The resulting relations in this case are:

	rel = {-1+a**w+x**d, a**c+x**z, b**d+y**w, -1+b**z+y**c,
           -1+c**y+w**a, c**b+w**x, d**a+z**y, -1+d**x+z**b}

After running

	NCMakeGB[rels, 8]

we obtain the Gröbner basis:

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

after seven iterations. The first four relations
$$
\begin{aligned}
	x &= d^{-1}-d^{-1} \, z \, b \\
	y &= c^{-1}-b \, z \, c^{-1} \\
	w &= a^{-1} \, d^{-1}  \, z \, b \, d \\
	z \, b \, z &= z + d \, a \, c
\end{aligned}
$$	
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

	NCMakeGB[rels, 8]

produces the Gröbner basis:

	z -> inv[b]-inv[b]**y**c
	w -> inv[a]-c**y**inv[a]
	x -> a**c**y**inv[a]**inv[d]
	y**c**y -> y+b**d**a
	c**y**inv[a]**inv[d]**inv[b] -> inv[a]**inv[d]**inv[b]**y**c
	d**a**c**y**inv[a] -> inv[b]**y**c**b**d
	inv[d]**inv[b]**y**c**b -> a**c**y**inv[a]**inv[d]
	y**c**b**d**a -> b**d**a**c**y
	y**inv[a]**inv[d]**inv[b]**y**c -> 1+y**inv[a]**inv[d]**inv[b]

after five iterations. Once again, the first four relations
$$
\begin{aligned}
	z &= b^{-1}-b^{-1} \, y \, c \\
	w &= a^{-1}-c \, y \, a^{-1} \\
	x &= a \, c \, y \, a^{-1} \, d^{-1} \\
	y \, c \, y &= y+b \, d \, a
\end{aligned}
$$	
provide formulas, this time for $z$, $w$, and $z$ in terms of $y$
satisfying $y \, c \, y = y+b \, d \, a$. Note that these formulas do
not involve $c^{-1}$ since $c$ is no longer assumed invertible.
