## NCPolyInterface {#PackageNCPolyInterface}

The package `NCPolyInterface` provides a basic interface between
[`NCPoly`](#PackageNCPoly) and `NCAlgebra`. Note that to take full
advantage of the speed-up possible with `NCPoly` one should always
convert and manipulate `NCPoly` expressions before converting back to
`NCAlgebra`.

Members are:

* [NCToNCPoly](#NCToNCPoly)
* [NCPolyToNC](#NCPolyToNC)
* [NCRuleToPoly](#NCRuleToPoly)
* [NCToRule](#NCToRule)
* [NCReduce](#NCReduce)
* [NCReduceRepeated](#NCReduceRepeated)
* [NCMonomialList](#NCMonomialList)
* [NCCoefficientRules](#NCCoefficientRules)
* [NCCoefficientList](#NCCoefficientList)
* [NCCoefficientQ](#NCCoefficientQ)
* [NCMonomialQ](#NCMonomialQ)
* [NCPolynomialQ](#NCPolynomialQ)

### NCToNCPoly {#NCToNCPoly}

`NCToNCPoly[expr, var]` constructs a noncommutative polynomial object in
variables `var` from the nc expression `expr`. 

For example

    NCToNCPoly[x**y - 2 y**z, {x, y, z}] 
	
constructs an object associated with the noncommutative polynomial $x
y - 2 y z$ in variables `x`, `y` and `z`. The internal representation is so
that the terms are sorted according to a degree-lexicographic order in
`vars`. In the above example, $x < y < z$.  

### NCPolyToNC {#NCPolyToNC}

`NCPolyToNC[poly, vars]` constructs an nc expression from the
noncommutative polynomial object `poly` in variables `vars`. Monomials are
specified in terms of the symbols in the list `var`.

For example

    poly = NCToNCPoly[x**y - 2 y**z, {x, y, z}];
	expr = NCPolyToNC[poly, {x, y, z}];

returns

	expr = x**y - 2 y**z
	
See also:
[NCPolyToNC](#NCPolyToNC),
[NCPoly](#NCPoly).

### NCRuleToPoly {#NCRuleToPoly}

`NCRuleToPoly[a -> b]` converts the rule `a -> b` into the relation `a - b`.

For instance:

    NCRuleToPoly[x**y**y -> x**y - 1]

returns

    x**y**y - x**y + 1

### NCToRule {#NCToRule}

`NCToRule[exp, vars]` converts the NC polynomial `exp` into a rule `a
-> b` in which `a` is the leading monomial according to the ordering
implied by `vars`.

For instance:

    NCToRule[x**y**y - x**y + 1, {x,y}]

returns

    x**y**y -> x**y - 1

NOTE: This command is not efficient. If you need to sort polynomials
you should consider using NCPoly directly.

See also:
[NCToNCPoly](#NCToNCPoly)

### NCReduce {#NCReduce}

`NCReduce[polys, rules, vars, options]` reduces the list of `polys` by
the list of `rules` in the variables `vars`. The substitutions implied
by `rules` are applied repeatedly to the polynomials in the `polys`
until no further reduction occurs.

`NCReduce[polys, vars, options]` reduces each polynomial in the list
of `NCPoly`s `polys` with respect to the remaining elements of the
list of polyomials `polys`. It traverses the list of polys just
once. Use [NCReduceRepeated](#NCReduceRepeated) to continue applying
`NCReduce` until no further reduction occurs.

`NCReduce` converts `polys` and `rules` to NCPoly polynomials and
apply [NCPolyReduce](#NCPolyReduce). See [NCPolyReduce](#NCPolyReduce)
for the possible `options`.

See also:
[NCReduceRepeated](#NCReduceRepeated), [NCPolyReduce](#NCPolyReduce).

### NCReduceRepeated {#NCReduceRepeated}

`NCReduceRepeated[polys]` applies `NCReduce` successively to the
list of `polys` until the remainder does not change.

See also:
[NCReduce](#NCReduce),
[NCPolyReduceRepeated](#NCPolyReduceRepeated).

### NCMonomialList {#NCMonomialList}

`NCMonomialList[poly]` gives the list of all monomials in the
polynomial `poly`.

For example:

    vars = {x, y}
	expr = B + A y ** x ** y - 2 x
	NCMonomialList[expr, vars]

returns

	{1, x, y ** x ** y}

See also:
[NCCoefficientRules](#NCCoefficientRules),
[NCCoefficientList](#NCCoefficientList),
[NCVariables](#NCVariables).

### NCCoefficientRules {#NCCoefficientRules}

`NCCoefficientRules[poly]` gives a list of rules between all the monomials
polynomial `poly`.

For example:

    vars = {x, y}
	expr = B + A y ** x ** y - 2 x
	NCCoefficientRules[expr, vars]

returns

	{1 -> B, x -> -2, y ** x ** y -> A}

See also:
[NCMonomialList](#NCMonomialList),
[NCCoefficientRules](#NCCoefficientRules),
[NCVariables](#NCVariables).


### NCCoefficientList {#NCCoefficientList}

`NCCoefficientList[poly]` gives the list of all coefficients in the
polynomial `poly`.

For example:

    vars = {x, y}
	expr = B + A y ** x ** y - 2 x
	NCCoefficientList[expr, vars]

returns

	{B, -2, A}

See also:
[NCMonomialList](#NCMonomialList),
[NCCoefficientRules](#NCCoefficientRules),
[NCVariables](#NCVariables).

### NCCoefficientQ {#NCCoefficientQ}

`NCCoefficientQ[expr]` returns True if `expr` is a valid polynomial
coefficient.

For example:

	SetCommutative[A]
    NCCoefficientQ[1]
	NCCoefficientQ[A]
	NCCoefficientQ[2 A]

all return `True` and

	SetNonCommutative[x]
	NCCoefficientQ[x]
	NCCoefficientQ[x**x]
	NCCoefficientQ[Exp[x]]

all return `False`.

**IMPORTANT**: `NCCoefficientQ[expr]` does not expand `expr`. This
means that `NCCoefficientQ[2 (A + 1)]` will return `False`.

See also:
[NCMonomialQ](#NCMonomialQ),
[NCPolynomialQ](#NCPolynomialQ)

### NCMonomialQ {#NCMonomialQ}

`NCCoefficientQ[expr]` returns True if `expr` is an nc monomial.

For example:

	SetCommutative[A]
    NCMonomialQ[1]
	NCMonomialQ[x]
	NCMonomialQ[A x ** y]
	NCMonomialQ[2 A x ** y ** x]

all return `True` and

	NCMonomialQ[x + x ** y]

returns `False`.

**IMPORTANT**: `NCMonomialQ[expr]` does not expand `expr`. This
means that `NCMonomialQ[2 (A + 1) x**x]` will return `False`.

See also:
[NCCoefficientQ](#NCCoefficientQ),
[NCPolynomialQ](#NCPolynomialQ)

### NCPolynomialQ {#NCPolynomialQ}

`NCPolynomialQ[expr]` returns True if `expr` is an nc polynomial with
commutative coefficients.

For example:

	NCPolynomialQ[A x ** y]

all return `True` and

	NCMonomialQ[x + x ** y]

returns `False`.

**IMPORTANT**: `NCPolynomialQ[expr]` does expand `expr`. This
means that `NCPolynomialQ[(x + y)^3]` will return `True`.

See also:
[NCCoefficientQ](#NCCoefficientQ),
[NCMonomialQ](#NCMonomialQ)
