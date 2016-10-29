# NCPoly {#PackageNCPoly}

Members are:

* Constructors
    * [NCPoly](#NCPoly)
    * [NCPolyMonomial](#NCPolyMonomial)
    * [NCPolyConstant](#NCPolyConstant)
* Access
    * [NCPolyMonomialQ](#NCPolyMonomialQ)
    * [NCPolyDegree](#NCPolyDegree)
    * [NCPolyNumberOfVariables](#NCPolyNumberOfVariables)
    * [NCPolyCoefficient](#NCPolyCoefficient)
    * [NCPolyGetCoefficients](#NCPolyGetCoefficients)
    * [NCPolyGetDigits](#NCPolyGetDigits)
    * [NCPolyGetIntegers](#NCPolyGetIntegers)
    * [NCPolyLeadingMonomial](#NCPolyLeadingMonomial)
    * [NCPolyLeadingTerm](#NCPolyLeadingTerm)
    * [NCPolyOrderType](#NCPolyOrderType)
    * [NCPolyToRule](#NCPolyToRule)
* Formatting
    * [NCPolyDisplay](#NCPolyDisplay)
    * [NCPolyDisplayOrder](#NCPolyDisplayOrder)
* Arithmetic
    * [NCPolyDivideDigits](#NCPolyDivideDigits)
    * [NCPolyDivideLeading](#NCPolyDivideLeading)
    * [NCPolyFullReduce](#NCPolyFullReduce)
    * [NCPolyNormalize](#NCPolyNormalize)
    * [NCPolyProduct](#NCPolyProduct)
    * [NCPolyQuotientExpand](#NCPolyQuotientExpand)
    * [NCPolyReduce](#NCPolyReduce)
    * [NCPolySum](#NCPolySum)
* Auxiliary
    * [NCFromDigits](#NCFromDigits)
    * [NCIntegerDigits](#NCIntegerDigits)
    * [NCPadAndMatch](#NCPadAndMatch)

## NCPoly {#NCPoly}

`NCPoly[coeff, monomials, vars]` constructs a noncommutative
polynomial object in variables `vars` where the monomials have
coefficient `coeff`.

Monomials are specified in terms of the symbols in the list `vars` as
in [NCPolyMonomial](#NCPolyMonomial).

For example:

    vars = {x,y,z};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];

constructs an object associated with the noncommutative polynomial
$2 z - x y x$ in variables `x`, `y` and `z`.

The internal representation varies with the implementation but it is
so that the terms are sorted according to a degree-lexicographic order
in `vars`. In the above example, `x < y < z`.

The construction:

    vars = {{x},{y,z}};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];

represents the same polyomial in a graded degree-lexicographic order
in `vars`, in this example, `x << y < z`.

See also:
[NCPolyMonomial](#NCPolyMonomial),
[NCIntegerDigits](#NCIntegerDigits),
[NCFromDigits](#NCFromDigits).


## NCPolyMonomial {#NCPolyMonomial}

`NCPolyMonomial[monomial, vars]` constructs a noncommutative monomial
object in variables `vars`.

Monic monomials are specified in terms of the symbols in the list
`vars`, for example:

	vars = {x,y,z};
    mon = NCPolyMonomial[{x,y,x},vars];

returns an `NCPoly` object encoding the monomial $xyx$ in
noncommutative variables `x`,`y`, and `z`. The actual representation
of `mon` varies with the implementation.

Monomials can also be specified implicitly using indices, for
example:

    mon = NCPolyMonomial[{0,1,0}, 3];

also returns an `NCPoly` object encoding the monomial $xyx$ in
noncommutative variables `x`,`y`, and `z`.

If graded ordering is supported then

	vars = {{x},{y,z}};
    mon = NCPolyMonomial[{x,y,x},vars];

or

    mon = NCPolyMonomial[{0,1,0}, {1,2}];

construct the same monomial $xyx$ in noncommutative variables
`x`,`y`, and `z` this time using a graded order in which `x << y < z`.

There is also an alternative syntax for `NCPolyMonomial` that allows
users to input the monomial along with a coefficient using rules and
the output of [NCFromDigits](#NCFromDigits). For example:

    mon = NCPolyMonomial[{3, 3} -> -2, 3];

or

    mon = NCPolyMonomial[NCFromDigits[{0,1,0}, 3] -> -2, 3];

represent the monomial $-2 xyx$ with has coefficient `-2`.

See also:
[NCPoly](#NCPoly),
[NCIntegerDigits](#NCIntegerDigits),
[NCFromDigits](#NCFromDigits).

## NCPolyConstant {#NCPolyConstant}

`NCPolyConstant[value, vars]` constructs a noncommutative monomial
object in variables `vars` representing the constant `value`.

For example:

	NCPolyConstant[3, {x, y, z}]

constructs an object associated with the constant `3` in variables
`x`, `y` and `z`.

See also:
[NCPoly](#NCPoly),
[NCPolyMonomial](#NCPolyMonomial).

## NCPolyMonomialQ {#NCPolyMonomialQ}

`NCPolyMonomialQ[p]` returns `True` if `p` is a `NCPoly` monomial.

See also:
[NCPoly](#NCPoly),
[NCPolyMonomial](#NCPolyMonomial).

## NCPolyDegree {#NCPolyDegree}

`NCPolyDegree[poly]` returns the degree of the nc polynomial `poly`.

## NCPolyNumberOfVariables {#NCPolyNumberOfVariables}

`NCPolyNumberOfVariables[poly]` returns the number of variables of the
nc polynomial `poly`.

## NCPolyCoefficient {#NCPolyCoefficient}

`NCPolyCoefficient[poly, mon]` returns the coefficient of the monomial
`mon` in the nc polynomial `poly`.

For example, in:

	coeff = {1, 2, 3, -1, -2, -3, 1/2};
	mon = {{}, {x}, {z}, {x, y}, {x, y, x, x}, {z, x}, {z, z, z, z}};
	vars = {x,y,z};
	poly = NCPoly[coeff, mon, vars];

	c = NCPolyCoefficient[poly, NCPolyMonomial[{x,y},vars]];

returns

	c = -1

See also:
[NCPoly](#NCPoly),
[NCPolyMonomial](#NCPolyMonomial).

## NCPolyGetCoefficients {#NCPolyGetCoefficients}

`NCPolyGetCoefficients[poly]` returns a list with the coefficients of
the monomials in the nc polynomial `poly`.

For example:

    vars = {x,y,z};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
	coeffs = NCPolyGetCoefficients[poly];

returns

	coeffs = {2,-1}

The coefficients are returned according to the current graded
degree-lexicographic ordering, in this example `x < y < z`.

See also:
[NCPolyGetDigits](#NCPolyGetDigits),
[NCPolyCoefficient](#NCPolyCoefficient),
[NCPoly](#NCPoly).

## NCPolyGetDigits {#NCPolyGetDigits}

`NCPolyGetDigits[poly]` returns a list with the digits that encode the
monomials in the nc polynomial `poly` as produced by
[NCIntegerDigits](#NCIntegerDigits).

For example:

    vars = {x,y,z};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
	digits = NCPolyGetDigits[poly];

returns

	digits = {{2}, {0,1,0}}

The digits are returned according to the current ordering, in
this example `x < y < z`.

See also:
[NCPolyGetCoefficients](#NCPolyGetCoefficients),
[NCPoly](#NCPoly).

## NCPolyGetIntegers {#NCPolyGetIntegers}

`NCPolyGetIntegers[poly]` returns a list with the digits that encode
the monomials in the nc polynomial `poly` as produced by
[NCFromDigits](#NCFromDigits).

For example:

    vars = {x,y,z};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
	digits = NCPolyGetIntegers[poly];

returns

	digits = {{1,2}, {3,3}}

The digits are returned according to the current ordering, in
this example `x < y < z`.

See also:
[NCPolyGetCoefficients](#NCPolyGetCoefficients),
[NCPoly](#NCPoly).

## NCPolyLeadingMonomial {#NCPolyLeadingMonomial}

`NCPolyLeadingMonomial[poly]` returns an `NCPoly` representing the
leading term of the nc polynomial `poly`.

For example:

    vars = {x,y,z};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
	lead = NCPolyLeadingMonomial[poly];

returns an `NCPoly` representing the monomial $x y x$. The leading
monomial is computed according to the current ordering, in this
example `x < y < z`. The actual representation of `lead` varies with
the implementation.

See also:
[NCPolyLeadingTerm](#NCPolyLeadingTerm),
[NCPolyMonomial](#NCPolyMonomial),
[NCPoly](#NCPoly).

## NCPolyLeadingTerm {#NCPolyLeadingTerm}

`NCPolyLeadingTerm[poly]` returns a rule associated with the leading
term of the nc polynomial `poly` as understood by
[NCPolyMonomial](#NCPolyMonomial).

For example:

    vars = {x,y,z};
	poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
	lead = NCPolyLeadingTerm[poly];

returns

	lead = {3,3} -> -1

representing the monomial $- x y x$. The leading monomial is computed
according to the current ordering, in this example `x < y < z`.

See also:
[NCPolyLeadingMonomial](#NCPolyLeadingMonomial),
[NCPolyMonomial](#NCPolyMonomial),
[NCPoly](#NCPoly).

## NCPolyOrderType {#NCPolyOrderType}

`NCPolyOrderType[poly]` returns the type of monomial order in which
the nc polynomial `poly` is stored. Order can be `NCPolyGradedDegLex`
or `NCPolyDegLex`.

See also:
[NCPoly](#NCPoly),

## NCPolyToRule {#NCPolyToRule}

`NCPolyToRule[poly]` returns a `Rule` associated with polynomial
`poly`. If `poly = lead + rest`, where `lead` is the leading term in
the current order, then `NCPolyToRule[poly]` returns the rule `lead ->
-rest` where the coefficient of the leading term has been normalized
to `1`.

For example:

	vars = {x, y, z};
	poly = NCPoly[{-1, 2, 3}, {{x, y, x}, {z}, {x, y}}, vars];
	rule = NCPolyToRule[poly]

returns the rule `lead -> rest` where `lead` represents is the nc
monomial $x y x$ and `rest` is the nc polynomial $2 z + 3 x y$

See also:
[NCPolyLeadingTerm](#NCPolyLeadingTerm),
[NCPolyLeadingMonomial](#NCPolyLeadingMonomial),
[NCPoly](#NCPoly).

## NCPolyDisplayOrder {#NCPolyDisplayOrder}

`NCPolyDisplayOrder[vars]` prints the order implied by the list of
variables `vars`.

## NCPolyDisplay {#NCPolyDisplay}

`NCPolyDisplay[p]` prints the noncommutative polynomial p using
symbols x1,...,xn. 

`NCPolyDisplay[p, vars]` uses the symbols in the list vars.

## NCPolyDivideDigits {#NCPolyDivideDigits}

`NCPolyDivideDigits[F,G]` returns the result of the division of the
leading digits lf and lg.

## NCPolyDivideLeading {#NCPolyDivideLeading}

`NCPolyDivideLeading[lF,lG,base]` returns the result of the division
of the leading Rules lf and lg as returned by NCGetLeadingTerm.

## NCPolyFullReduce {#NCPolyFullReduce}

`NCPolyFullReduce[f,g]` applies NCPolyReduce successively until the
remainder does not change.  See also NCPolyReduce and
NCPolyQuotientExpand.

## NCPolyNormalize {#NCPolyNormalize}

`NCPolyNormalize[p]` makes the coefficient of the leading term of p to
unit. It also works when p is a list.


## NCPolyProduct {#NCPolyProduct}

`NCPolyProduct[f,g]` returns a NCPoly that is the product of the
NCPoly's f and g.

## NCPolyQuotientExpand {#NCPolyQuotientExpand}

`NCPolyQuotientExpand[q,g]` returns a NCPoly that is the left-right
product of the quotient as returned by NCPolyReduce by the NCPoly
g. It also works when g is a list.

## NCPolyReduce {#NCPolyReduce}

## NCPolySum {#NCPolySum}

`NCPolySum[f,g]` returns a NCPoly that is the sum of the NCPoly's f
and g.

## NCFromDigits {#NCFromDigits}

`NCFromDigits[list, b]` constructs a representation of a monomial in
`b` encoded by the elements of `list` where the digits are in base
`b`.

`NCFromDigits[{list1,list2}, b]` applies `NCFromDigits` to each
`list1`, `list2`, ....

List of integers are used to codify monomials. For example the list
`{0,1}` represents a monomial $xy$ and the list `{1,0}` represents
the monomial $yx$. The call

	NCFromDigits[{0,0,0,1}, 2]

returns

	{4,1}

in which `4` is the degree of the monomial $xxxy$ and `1` is
`0001` in base `2`. Likewise

	NCFromDigits[{0,2,1,1}, 3]

returns

	{4,22}

in which `4` is the degree of the monomial $xzyy$ and `22` is
`0211` in base `3`.

If `b` is a list, then degree is also a list with the partial degrees
of each letters appearing in the monomial. For example:

	NCFromDigits[{0,2,1,1}, {1,2}]

returns

	{3, 1, 22}

in which `3` is the partial degree of the monomial $xzyy$ with
respect to letters `y` and `z`, `1` is the partial degree with respect
to letter `x` and `22` is `0211` in base `3 = 1 + 2`.

This construction is used to represent graded degree-lexicographic
orderings.

See also:
[NCIntergerDigits](#NCIntergerDigits).

## NCIntegerDigits {#NCIntegerDigits}

`NCIntegerDigits[n,b]` is the inverse of the `NCFromDigits`.

`NCIntegerDigits[{list1,list2}, b]` applies `NCIntegerDigits` to each
`list1`, `list2`, ....

For example:

	NCIntegerDigits[{4,1}, 2]

returns

	{0,0,0,1}

in which `4` is the degree of the monomial `x**x**x**y` and `1` is
`0001` in base `2`. Likewise

	NCIntegerDigits[{4,22}, 3]

returns

	{0,2,1,1}


in which `4` is the degree of the monomial `x**z**y**y` and `22` is
`0211` in base `3`.

If `b` is a list, then degree is also a list with the partial degrees
of each letters appearing in the monomial. For example:

	NCIntegerDigits[{3, 1, 22}, {1,2}]

returns

	{0,2,1,1}

in which `3` is the partial degree of the monomial `x**z**y**y` with
respect to letters `y` and `z`, `1` is the partial degree with respect
to letter `x` and `22` is `0211` in base `3 = 1 + 2`.

See also:
[NCFromDigits](#NCFromDigits).


## NCPadAndMatch {#NCPadAndMatch}

When list `a` is longer than list `b`, `NCPadAndMatch[a,b]` returns
the minimum number of elements from list a that should be added to the
left and right of list `b` so that `a = l b r`.  When list `b` is longer
than list `a`, return the opposite match.

`NCPadAndMatch` returns all possible matches with the minimum number
of elements.

