# NonCommutative Gröbner Basis {#NCGB}

The package `NCGBX` provides an implementation of a noncommutative
Gröbner Basis algorithm. Gröbner Basis are useful in the study of
algebraic relations. 

In order to load `NCGB` one types:

	<< NC`
	<< NCGBX`

or simply

	<< NCGBX`

if `NC` and `NCAlgebra` have already been loaded.

?? REVISE ??

A reader who has no explicit interest in Gröbner Bases might want to
skip this section. Readers who lack background in Gröbner Basis may
want to read [CLS].

?? ADD A BRIEF INTRO TO GBs ??


## Gröbner Basis

### Example 1

Before calculating a Gröbner Basis, one must declare which variables
will be used during the computation and must declare a *monomial
order* which can be done using `SetNonCommutative` and
`SetMonomialOrder` as in:

	SetNonCommutative[a, b, c, x];
	SetMonomialOrder[{a, b, c}, x];

The monomial ordering imposes a relationship between the variables
which are used to *sort* the monomials in a polynomial. The ordering
implied by the above command can be visualized using:

	PrintMonomialOrder[];
	
which in this case prints:

$a < b < c \ll x$.

A user does not need to know theoretical background related to
monomials orders. Indeed, as we shall see soon, in many engineering
problems, it suffices to know which variables correspond to quantities
which are *known* and which variables correspond to quantities which
are *unknown*. If one is solving for a variable or desires to prove
that a certain quantity is zero, then one would want to view that
variable as *unknown*. In the above example, the symbol '$\ll$'
separate the *knowns*, $a, b, c$, from the *unknown*, $x$. For more
details on orderings see Section [Orderings](#Ordering).

Our goal is to calculate the Gröbner basis associated with the
following relations:
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

To calculate a Gröbner basis one defines a list of relations

	rels = {a ** x ** a - c, a ** b - 1, b ** a - 1}

and issues the command:
	
	gb = NCMakeGB[rels, 10]

which should produces an output similar to:

	* * * * * * * * * * * * * * * *
	* * *   NCPolyGroebner    * * *
	* * * * * * * * * * * * * * * *
	* Monomial order : a < b < c << x
	* Reduce and normalize initial basis
	> Initial basis could not be reduced
	* Computing initial set of obstructions
	> MAJOR Iteration 1, 4 polys in the basis, 2 obstructions
	> MAJOR Iteration 2, 5 polys in the basis, 2 obstructions
	* Cleaning up basis.
	* Found Groebner basis with 3 relations
	* * * * * * * * * * * * * * * *

The number `10` in the call to `NCMakeGB` is very important because a
finite GB may not exist. It instructs `NCMakeGB` to abort after `10`
iterations if a GB has not been found at that point.

The result of the above calculation is the list of relations:
           
	{x -> b ** c ** b, a ** b -> 1, b ** a -> 1}

Our favorite format for displaying lists of relations is `ColumnForm`.
           
	ColumnForm[gb]
	
which results in 

	x -> b ** c ** b
	a ** b -> 1
	b ** a -> 1

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

### Example 2

For a slightly more challenging example consider the same monomial
order as before:

	SetNonCommutative[a, b, c, x]
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

## Facilitating Natural Notation

### Example 3

Now we turn to a more complicated (though mathematically intuitive)
notation. In our first example above, the letter $b$ was essentially
introduced to represent the inverse of letter $a$. It is possible to
have `NCMakeGB` handle all of that automatically by simply adding
`inv[a]` as a member of the ordering:

	SetMonomialOrder[{a,inv[a],c},x];
	
that is

$a < a^{-1} < c \ll x$

Calling `NCMakeGB` with only one relation:

    gb = NCMakeGB[{a**x**a-c},10]
	
produces the output

    * * * * * * * * * * * * * * * *
	* * *   NCPolyGroebner    * * *
	* * * * * * * * * * * * * * * *
	* Monomial order : a < inv[a] < c <<  x
	* Reduce and normalize initial basis
	> Initial basis could not be reduced
	* Computing initial set of obstructions
	> MAJOR Iteration 1, 5 polys in the basis, 3 obstructions
	> MAJOR Iteration 2, 6 polys in the basis, 3 obstructions
	* Cleaning up basis.
	* Found Groebner basis with 3 relations
	* * * * * * * * * * * * * * * *

The resulting Gröbner basis is:

	gb = {x -> inv[a]**c**inv[a]}

which is what one would expect. Internally, an extra variable has been
created and extra relations encoding that $a$ were invertible were
appended to the list of relations before running `NCMakeGB`.

?? DO WE WANT TO SUPPORT pinv, linv and rinv? ??

### Example 4 

One can use Gröbner basis to *simplify* polynomial or rational
expressions. 

Consider for instance the order 

$$ y \ll y^{-1} \ll (1-y)^{-1} $$

implied by the command:

	SetMonomialOrder[y, inv[y], inv[1-y]]

This ordering encodes the following precise idea of what we mean by
*simple* versus *complicated*: it formally corresponds to specifying
that $y$ is simpler than $y^{-1}$ that is simpler than $(1-y)^{-1}$,
which might sits well with one's intuition.

Of course, there may be many other orders that are mathematically
correct but might not serve well if simplification is the main
goal. For example, perhaps the order

$$y^{-1} \ll y \ll (1-y)^{-1}$$

does not simplify as much as the previous one, since, if possible, it
would be preferable to express an answer in terms of $y$, rather than
$y^{-1}$.


As an example of simplification, we simplify the two expressions
$x**x$ and $x+Inv[y]**Inv[1-y]$ assuming that $y$ satisfies $resol$
and $x**x=a$.  The following command computes a Gröbner Basis for the
union of $resol$ and $\{x^2-a\}$ and simplifies the expressions $x**x$
and $x+Inv[y]**Inv[1-y]$ using the Gröbner Basis.  Experts will note
that since we are using an iterative Gröbner Basis algorithm which may
not terminate, we must set a limit on how many iterations we permit;
here we specify *at most* 3 iterations.

	NCSimplifyAll[{x**x,x+Inv[y]**Inv[1-y]},Join[{x**x-a},resol],3]

	{a, x + Inv[1 - y] + Inv[y]}

We name the variable $Inv[y]$, because this has more meaning
to the user than would using a single letter.
$Inv[y]$ has the same status as a single letter with regard to 
all of the commands which we have demonstrated.

Next we illustrate an extremely valuable simplification command. The
following example performs the same computation as the previous
command, although one does not have to type in $resol$
explicitly. More generally one does not have to type in relations
involving the definition of inverse explicitly.  Beware,
`NCSimplifyRationalX1` picks its own order on variables and completely
ignores any order that you might have set.

	<< NCSRX1.m
	NCSimplifyRationalX1[{x**x**x,x+Inv[z]**Inv[1-z]},{x**x-a},3]
	{a ** x, x + Inv[1 - z] + inv[z]}

WARNING: Never use inv[ \ ] with NCGB since it has special properties
given to it in NCAlgebra and these are not recognized by the C++ code
behind NCGB



## Interlude: ordering on variables and monomials {#Orderings}

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

	{y -> -b**a+a**b**x**x, a**x -> 1, x**a -> 1}

after two iterations.

Now, we change the order to 

	SetMonomialOrder[y,x,b,a];

and do the same `NCMakeGB` as above:

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4];
	ColumnForm[%]
	
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
	    > b**a**y**b**x**x+a**b**x**b**x**x**b**x**x

which is not a Gröbner basis since the algorithm was interrupted at 4
iterations. Note the presence of the rule

	a**b**x**x -> y + b**a
	
which shows that the order is not set up to solve for $y$ in terms of
the other variables in the sense that $y$ is not on the left hand side
of this rule (but a human could easily solve for $y$ using this rule).
Also the algorithm created a number of other relations which involved
$y$. See [CoxLittleOShea].
 
### Graded lex ordering: A non-elimination order 

To impose graded lexicographic order, say $a< b< x< y$ on $a$,
$b$, $x$ and $y$, one types

	SetMonomialOrder[{a,b,x,y}];

This ordering puts high degree monomials high in the order. Thus it
tries to decrease the total degree of expressions. A call to 

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4];
	ColumnForm[%]

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
	    > b**a**b**a**y+b**a**y**b**a+y**b**a**b**a+b**a**b**a**b**a
	b**x**x**b**x**b**x**x -> x**b**y**y+x**b**b**a**y+x**b**y**b**a
	    > +x**b**b**a**b**a+x**y**b**x**b**x**x
	a**b**x**b**x**b**x**b**x**x -> y**y**y**y+b**a**y**y**y+
	    > y**b**a**y**y+y**y**b**a**y+y**y**y**b**a+b**a**b**a**y**y+
		> b**a**y**b**a**y+b**a**y**y**b**a+y**b**a**b**a**y+
		> y**b**a**y**b**a+y**y**b**a**b**a+b**a**b**a**b**a**y+
		> b**a**b**a**y**b**a+b**a**y**b**a**b**a+y**b**a**b**a**b**a+
		> b**a**b**a**b**a**b**a

which again fails to be a Gröbner basis and does not eliminate
$y$. Instead, it tries to decrease the total degree of expressions
involving $a$, $b$, $x$, and $y$.

### Multigraded lex ordering : a variety of elimination orders 

There are other useful monomial orders which one can use other than
graded lex and lex.  Another type of order is what we call multigraded
lex and is a mixture of graded lex and lex order. To impose
multi-graded lexicographic order, say $a< b< x\ll y$ on $a$, $b$, $x$
and $y$, one types

	SetMonomialOrder[{a,b,x},y];

which separates $y$ from the remaining variables. This time, a call to

	NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4];
	ColumnForm[%]

yields

	y -> -b**a+a**b**x**x
	a**x -> 1
	x**a -> 1

which not only eliminates $y$ but is also Gröbner basis, calculated
after 2 iterations. 

For an intuitive idea of why multigraded lex is helpful, we think of
$a$, $b$, and $x$ as corresponding to variables in some engineering
problem which represent quantities which are known and $y$ to be
unknown.  The fact that $a$, $b$ and $x$ are in the top level
indicates that we are very interested in solving for $y$ in terms of
$a$, $b$, and $x$, but are not willing to solve for, say $x$, in terms
of expressions involving $y$.

This situation is so common that we provide the commands `SetKnowns`
and `SetUnknowns`. The above ordering would be obtained after setting

	SetKnowns[a,b,x];
	SetUnknowns[y];

## Reducing a polynomial by a GB

Now we  reduce a polynomial or ListOfPolynomials  by a GB or by any
ListofPolynomials2.  First we convert ListOfPolynomials2 to rules
subordinate to the monomial order which is currently in force 
in our session.

For example,  let us continue the session above with

	ListOfRules2 = PolyToRule[ourGB]
	
results in 

	{x**x->a,b->a,y**x->a,a**x->a,x**a->a,y**a->a, a**a->a} 

To reduce ListOfPolynomials by ListOfRules2 use the command

    Reduction[ ListofPolynomials, ListofRules2]
          
For example, to reduce the polynomial

	poly = a**x**y**x**x + x**a**x**y + x**x**y**y

in our session type

	Reduction[ { poly }, ListOfRules2 ]

## Simplifying Expressions

Suppose we want to simplify the expression $a^3 b^3 -c $ assuming that
we know $a b =1$ and $b a = b$.

First NCAlgebra requires us to declare the variables to be noncommutative.

	SetNonCommutative[a,b,c]

Now we must set an order on the variables $a$, $b$ and $c$.

	SetMonomialOrder[{a,b,c}]

Later we explain what this does, in the context of a more complicated
example where the command really matters. Here any order will do. We
now simplify the expression $a^3 b^3 -c$ by typing

	NCSimplifyAll[{a**a**a**b**b**b -c}, {a**b-1,b**a- b}, 3]

you get the answer as the following Mathematica output

	{1 - c} 

The number 3 indicates how hard you want to try (how long you can
stand to wait) to simplify your expression. 

The way the previously described command `NCSimplifyAll` works is

	NCSimplifyAll[ ListofPolynomials, ListofPolynomials2] =
                 Reduction[ ListofPolynomials, 
                          PolyToRule[NCMakeGB[ListofPolynomials2,10]]]

## NCGB Facilitates Natural Notation

Now we turn to a more complicated (though mathematically intuitive)
notation.  Also we give some more examples of Simplification and GB
manufacture.  We shall use the variables 

	y, Inv[y], Inv[1-y], a {\rm\ and\ } x.

In NCAlgebra, lower case letters are noncommutative by default, and
functions of noncommutative variables are noncommutative, so the
`SetNonCommutative` command, while harmless, is not necessary.  

Using $Inv[]$ has the advantage that our TeX display commands
recognize it and treat it wisely.  Also later we see that the command
`NCMakeRelations` generates defining relations for $Inv[]$
automatically.

### A Simplification example

We want to simplify a polynomial in the variables of 

We begin by setting the variables noncommutative with the following
command.

	SetNonCommutative[y, Inv[y], Inv[1-y], a, x]

Next we must give the computer a precise idea of what we mean by
``simple" versus ``complicated". This formally corresponds to
specifying an order on the indeterminates. If $Inv[y]$ and $Inv[1-y]$
are going to stand for the inverses of $y$ and $1-y$ respectively, as
the notation suggests, then the order $$y< Inv[y] < Inv[1-y] < a < x$$
sits well with intuition, since the matrix $y$ is ``simpler" than
$(1-y)^{-1}$.

There are many orders which ``sit well with intuition".  Perhaps the
order $Inv[y] < y < Inv[1-y] < a < x$ does not set well, since, if
possible, it would be preferable to express an answer in terms of
$y$,rather than $y^{-1}$.}  To set this order input \footnote{This
sets a graded lexicographic on the monic monomials involving the
variables $y$, $Inv[y]$, $Inv[1-y]$, $a$ and $x$ with $y< Inv[y] <
Inv[1-y] < a < x$.

	SetMonomialOrder[{ y, Inv[y], Inv[1-y], a, x}]

Suppose that we want to connect the Mathematica variables $Inv[y]$
with the mathematical idea of the inverse of $y$ and $Inv[1-y]$ with
the mathematical idea of the inverse of $1-y$. Then just type in the
defining relations for the inverses involved.

	resol = {y ** Inv[y] == 1,   Inv[y] ** y == 1, 
            (1 - y) ** Inv[1 - y] == 1,   Inv[1 - y] ** (1 - y) == 1}

	{y ** Inv[y] == 1, Inv[y] ** y == 1, 
       (1 - y) ** Inv[1 - y] == 1, Inv[1 - y] ** (1 - y) == 1}

As an example of simplification, we simplify the two expressions
$x**x$ and $x+Inv[y]**Inv[1-y]$ assuming that $y$ satisfies $resol$
and $x**x=a$.  The following command computes a Gröbner Basis for the
union of $resol$ and $\{x^2-a\}$ and simplifies the expressions $x**x$
and $x+Inv[y]**Inv[1-y]$ using the Gröbner Basis.  Experts will note
that since we are using an iterative Gröbner Basis algorithm which may
not terminate, we must set a limit on how many iterations we permit;
here we specify *at most* 3 iterations.

	NCSimplifyAll[{x**x,x+Inv[y]**Inv[1-y]},Join[{x**x-a},resol],3]

	{a, x + Inv[1 - y] + Inv[y]}

We name the variable $Inv[y]$, because this has more meaning
to the user than would using a single letter.
$Inv[y]$ has the same status as a single letter with regard to 
all of the commands which we have demonstrated.

Next we illustrate an extremely valuable simplification command. The
following example performs the same computation as the previous
command, although one does not have to type in $resol$
explicitly. More generally one does not have to type in relations
involving the definition of inverse explicitly.  Beware,
`NCSimplifyRationalX1` picks its own order on variables and completely
ignores any order that you might have set.

	<< NCSRX1.m
	NCSimplifyRationalX1[{x**x**x,x+Inv[z]**Inv[1-z]},{x**x-a},3]
	{a ** x, x + Inv[1 - z] + inv[z]}

WARNING: Never use inv[ \ ] with NCGB since it has special properties
given to it in NCAlgebra and these are not recognized by the C++ code
behind NCGB

## MakingGB's and Inv[], Tp[]

Here is another GB example. This time we use the fancy `Inv[]`
notation.

	<< NCGB.m
	SetNonCommutative[y, Inv[y], Inv[1-y], a, x]
	SetMonomialOrder[{ y, Inv[y], Inv[1-y], a, x}]
	resol = {y ** Inv[y] == 1,   Inv[y] ** y == 1,
             (1 - y) ** Inv[1 - y] == 1,   Inv[1 - y] **
			 (1 - y) == 1}

The following commands makes a Gröbner Basis for $resol$ with respect
to the monomial order which has been set.

	NCMakeGB[resol,3]
	{1 - Inv[1 - y] + y ** Inv[1 - y], -1 + y ** Inv[y],
	>    1 - Inv[1 - y] + Inv[1 - y] ** y, -1 + Inv[y] ** y,
	>    -Inv[1 - y] - Inv[y] + Inv[y] ** Inv[1 - y],
	>    -Inv[1 - y] - Inv[y] + Inv[1 - y] ** Inv[y]}

## Simplification and GB's revisited

### Changing polynomials to rules

The following command converts a list of relations to a list of rules
subordinate to the monomial order specified above.

	PolyToRule[%]
	{y ** Inv[1 - y] -> -1 + Inv[1 - y], y ** Inv[y] -> 1,
	>    Inv[1 - y] ** y -> -1 + Inv[1 - y], Inv[y] ** y -> 1,
	>    Inv[y] ** Inv[1 - y] -> Inv[1 - y] + Inv[y],
	>    Inv[1 - y] ** Inv[y] -> Inv[1 - y] + Inv[y]}

### Changing rules to polynomials

The following command converts a list of rules to
a list of relations.

	PolyToRule[%]
	{1 - Inv[1 - y] + y ** Inv[1 - y], -1 + y ** Inv[y],
	>    1 - Inv[1 - y] + Inv[1 - y] ** y, -1 + Inv[y] ** y,
	>    -Inv[1 - y] - Inv[y] + Inv[y] ** Inv[1 - y],
	>    -Inv[1 - y] - Inv[y] + Inv[1 - y] ** Inv[y]}


### Simplifying using a GB revisited

We can apply the rules in \S \ref{section:polynomials:rules}
repeatedly to an expression to put it into ``canonical form." Often
the canonical form is simpler than what we started with.

	Reduction[{Inv[y]**Inv[1-y] - Inv[y]}, Out[9]]
	{Inv[1 - y]}

## Saving lots of time when typing

One can save time in inputting various types of starting relations
easily by using the command `NCMakeRelations`.

	<< NCMakeRelations.m             
	NCMakeRelations[{Inv,y,1-y}]
	{y ** Inv[y] == 1, Inv[y] ** y == 1, (1 - y) ** Inv[1 -	y] == 1,
    Inv[1 - y] ** (1 - y) == 1}

It is traditional in mathematics to use only single characters
for indeterminates (e.g., $x$, $y$ and $\alpha$). 
However,
we allow these indeterminate names as well as
more complicated constructs such as
$$
Inv[x], Inv[y], Inv[1-x**y] \mbox{\rm\ and\ } Rt[x] \, .
$$
In fact, we allow $f[expr]$ to be an indeterminate if $expr$
is an expression and $f$ is a Mathematica symbol which has no
Mathematica code associated to it (e.g., $f= Dummy$ or $f=Joe$,
but NOT $f=List$ or $f=Plus$).
Also
one should never use $inv[m]$ to represent $m^{-1}$ in the input of
any of the commands explained within this document, because
NCAlgebra has already assigned a meaning to
$inv[m]$.
It knows that $inv[m]**m$ is $1$ which will
transform your starting set of data prematurely.

Besides $Inv$ many more functions are facilitated by NCMakeRelations,
see Section \ref{command:NCMakeRelations}.

### Saving time working in algebras with involution: NCAddTranspose, NCAddAdjoint

One can save time when working in an algebra with transposes or adjoints
by using the command NCAddTranpose[ ] or NCAddAdjoint[ ].
These commands ``symmetrize" a set of relations by applying tp[ ] 
or aj[ ] to the relations and returning
a list with the new expressions appended to the old ones.
This saves the user the trouble of typing both $a = b$ and
$tp[a] = tp[b]$.
	
	NCAddTranspose[ { a + b , tp[b] == c + a } ]

returns

	{ a + b , tp[b] == c + a, b == tp[c] + tp[a], tp[a] + tp[b] }

### Saving time when setting orders: NCAutomaticOrder

One can save time in setting the monomial order by not including all 
of the indeterminants found in a set of relations,  only
the variables which they are made of.
$NCAutomaticOrder[ aMonomialOrder,$ $ aListOfPolynomials ]$ 
inserts all of the indeterminants found in 
$aListOfPolynomials$ into $aMonomialOrder$ and sets this order.   
NCAutomaticOrder[ $aListOfPolynomials ]$ inserts all of the
indeterminants found in $aListOfPolynomials$ into the ambient monomial
order.  If x is an indeterminant found in $aMonomialOrder$ then any
indeterminant whose symbolic representation is a function of x will
appear next to x.

	NCAutomaticOrder[{{a},{b}},  { a**Inv[a]**tp[a] + tp[b]}]

would set the order to be $a < tp[a] < Inv[a] \ll b < tp[b]$.













