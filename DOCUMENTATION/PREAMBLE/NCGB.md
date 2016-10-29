# NonCommutative Gröebner Basis {#NCGB}

We shall use the word *relation* to mean a polynomial in noncommuting
indeterminates. If an analyst saw the equation $AB = 1$ for matrices
$A$ and $B$, then he might say that $A$ and $B$ satisfy the polynomial
equation $x\, y - 1 = 0$. An algebraist would say that $x\, y-1$ is a
relation.

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

## Gröbner Basis

A reader who has no explicit interest in Gröbner Bases might want to
skip this section. Readers who lack background in Gröbner Basis may
want to read [CLS].

Before making a Gröbner Basis, one must declare which variables will
be used during the computation and must declare a *monomial order*
which can be done using the commands described in Chapter.

A user does not need to know theoretical background related to
monomials orders. Indeed, as we shall see in Chapter
\ref{chapter:ncprocess:example}, for many engineering problems, it
suffices to know which variables correspond to quantities which are
*known* and which variables correspond to quantities which are
*unknown*.

If one is solving for a variable or desires to prove that a certain
quantity is zero, then one would want to view that variable as
unknown.  For simple mathematical problems, one can take all of the
variables to be known. At this point in the exposition we assume that
we have set a monomial order.

	<< NCGBX`
	SetNonCommutative[a,b,x,y]
	SetMonomialOrder[a,b,x,y]
	gb = NCMakeGB[{y**x - a, y**x - b, x**x - a, x**x**x - b}, 10]

The result is:
           
	{-a+x**x,-a+b,-a+y**x,-a+a**x,-a+x**a,-a+y**a,-a+a**a}
           
Our favorite format for displaying lists of relations is `ColumnForm`.
           
	ColumnForm[gb]
	
which results in 

	-a + x ** x
	-a + b
	-a + y ** x
	-a + a ** x
	-a + x ** a
	-a + y ** a
	-a + a ** a
           
Someone not familiar with GB's might find it instructive to note this
output GB triangularizes the input equations to the extent that we
have a compatibility condition on $a$, namely $a^2 - a = 0$; we can
solve for $b$ in terms of $a$; there is one equation involving only
$y$ and $a$; and there are three equations involving only $x$ and $a$.
Thus if we were in a concrete situation with $a$ and $b$, given
matrices, and $x$ and $y$, unknown matrices we would expect to be able
to solve for large pieces of $x$ and $y$ independently and then plug
them into the remaining equation $y x - a = 0$ to get a compatibility
condition.

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

## Simplification via GB's

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


## Ordering on variables and monomials

One needs to declare a monomial order before making a Grobner Basis.
There are various monomial orders which can be used when computing
Gröbner Basis. The most common are called lexicographic and graded
lexicographic orders. In the previous section, we used only graded
lexicographic orders. See Section ?? for a discussion of
lexicographic orders.

We will be considering *lexicographic*, *graded lexicographic* and
*multi-graded lexicographic* orders. Lexicographic and multi-graded
lexicographic orders are examples of elimination orderings. An
elimination ordering is an ordering which is used for solving for some
of the variables in terms of others.

We now discuss each of these types of orders.

### Lex Order: The simplest elimination order

To impose lexicographic order $a<<b<<x<<y$ on $a$, $b$, $x$ and $y$,
one types

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
-b\, x + x\, y  \, a + x\, b \, a \,  a = 0
$$
$$
x \, a-1=0
$$
$$
a\, x-1=0 \, .
$$

	NCMakeGB[{-b ** x + x ** y ** a + x ** b ** a ** a,x**a-1,a**x-1},4];
	{-1 + a ** x, -1 + x ** a, y + b ** a - a ** b ** x ** x}

If the polynomials above are converted to replacement rules, then a
simple glance at the results allows one to see that $y$ has been
solved for.

	PolyToRule[%]
	{a ** x -> 1, x ** a -> 1, y -> -b ** a + a ** b ** x ** x}

Now, we change the order to 

	SetMonomialOrder[y,x,b,a];

and do the same `NCMakeGB` as above:

	NCMakeGB[{-b ** x + x ** y ** a + x ** b ** a ** a,x**a-1,a**x-1},4];	
	ColumnForm[%];
	a ** x -> 1
	x ** a -> 1
	x ** b ** a -> -x ** y + b ** x ** x
    b ** a ** a -> -y ** a + a ** b ** x
	b ** x ** x ** x -> x ** b + x ** y ** x
	a ** b ** x ** x -> y + b ** a
	x ** b ** b ** a -> 
	    >   -x ** b ** y - x ** y ** b ** x ** x + b ** x ** x ** b ** x ** x
	b ** a ** b ** a -> 
	    >   -y ** y - b ** a ** y - y ** b ** a + a ** b ** x ** b ** x ** x
    x ** b ** b ** b ** a -> 
        >   -x ** b ** b ** y - x ** b ** y ** b ** x ** x - 
        >    x ** y ** b ** x ** x ** b ** x ** x + 
        >    b ** x ** x ** b ** x ** x ** b ** x ** x
	b ** a ** b ** b ** a -> 
        >   -y ** b ** y - b ** a ** b ** y - y ** b ** b ** a - 
        >    y ** y ** b ** x ** x - b ** a ** y ** b ** x ** x + 
        >    a ** b ** x ** b ** x ** x ** b ** x ** x

In this case, it turns out that it produced the rule $a ** b ** x ** x
\rightarrow y + b ** a$ which shows that the order is not set up to
solve for $y$ in terms of the other variables in the sense that $y$ is
not on the left hand side of this rule (but a human could easily solve
for $y$ using this rule).  Also the algorithm created a number of
other relations which involved $y$.  If one uses the lex order
$a<<b<<y<<x$, the `NCMakeGB` call above generates 12 polynomials of
high total degree which do not solve for $y$.

See [CoxLittleOShea].
 
### Graded lex ordering: A non-elimination order 

This is the ordering which was used in all demos appearing before this
section. It puts high degree monomials high in the order. Thus it
tries to decrease the total degree of expressions.

### Multigraded lex ordering : A variety of elimination orders 

There are other useful monomial orders which one can use other than
graded lex and lex.  Another type of order is what we call multigraded
lex and is a mixture of graded lex and lex order. This multigraded
order is set using `SetMonomialOrder`, `SetKnowns` and `SetUnknowns`
which are described in Section.  As an example, suppose that we
execute the following commands:

	SetMonomialOrder[{A,B,C},{a,b,c},{d,e,f}];

We use the notation 
$$
A < B < C << a < b < c << d < e < f \, ,
$$
to denote this order. 

For an intuitive idea of why multigraded lex is helpful, we think of
$A$, $B$ and $C$ as corresponding to variables in some engineering
problem which represent quantities which are known and $a$, $b$, $c$,
$d$, $e$ and $f$ to be unknown.  If one wants to speak *very*
loosely, then we would say that $a$, $b$ and $c$ are unknown and $d$,
$e$ and $f$ are ``very unknown.".  The fact that $d$, $e$ and $f$ are
in the top level indicates that we are very interested in solving for
$d$, $e$ and $f$ in terms of $A$, $B$, $C$, $a$, $b$ and $c$, but are
not willing to solve for $b$ in terms of expressions involving either
$d$, $e$ or $f$.
 
For example,

1. $d > a ** a ** A ** b$
2. $d ** a ** A ** b > a$
3. $e ** d > d ** e$
4. $b ** a > a ** b$
5. $a ** b ** b > b ** a$
6. $a > A ** B ** A ** B ** A ** B$

This order induces an order on monomials in the following way.  One
does the following steps in determining whether a monomial $m$ is
greater in the order than a monomial $n$ or not.

1. First, compute the total degree of $m$ with respect to only the
variables $d$, $e$ and $f$.
2. Second, compute the total degree of $n$ with respect to 
only the variables $d$, $e$ and $f$.
3. If the number from item (2) is smaller than the number from item
(1), then $m$ is smaller than $n$. If the number from item (2) is
bigger than the number from item (1), then $m$ is bigger than $n$. If
the numbers from items (1) and (2) are equal, then proceed to the next item.
4. First, compute the total degree of $m$ with respect to only the
variables $a$, $b$ and $c$. 
5. Second, compute the total degree of $n$ with respect to only the
variables $a$, $b$ and $c$.
6. If the number from item (5) is smaller than the number from item
(4), then $m$ is smaller than $n$. If the number from item (5) is
bigger than the number from item (4), then $m$ is bigger than $n$. If
the numbers from items (4) and (5) are equal, then proceed to the next item.
7. First, compute the total degree of $m$ with respect to only the
variables $A$, $B$ and $C$. 
8. Second, compute the total degree of $n$ with respect to only the
variables $A$, $B$ and $C$. 
9. If the number from item (8) is smaller than the number from item
(7), then $m$ is smaller than $n$. If the number from item (8) is
bigger than the number from item (7), then $m$ is bigger than $n$. If
the numbers from items (7) and (8) are equal, then proceed to the next
item.
10. At this point, say that $m$ is smaller than $n$ if and only if $m$
is smaller than $n$ with respect to the graded lex order $A<B<C<a<b<c<d<e<f$

For more information on multigraded lex orders, consult [HSStrat].











