## NCPolyInterface {#PackageNCPolyInterface}

The package `NCPolyInterface` provides a basic interface between
[`NCPoly`](#PackageNCPoly) and `NCAlgebra`. 

> Note that to take full advantage of the speed-up possible with
> `NCPoly` one should not use these functions. It is always faster to
> convert to and manipulate `NCPoly` expressions directly!

Members are:

* [NCToNCPoly](#NCToNCPoly)
* [NCPolyToNC](#NCPolyToNC)
* [NCMonomialOrderQ](#NCMonomialOrderQ)
* [NCMonomialOrder](#NCMonomialOrder)
* [NCRationalToNCPoly](#NCRationalToNCPoly)
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

### NCMonomialOrderQ {#NCMonomialOrderQ}

`NCMonomialOrderQ[list]` returns `True` if the expressions in `list`
represents a valid monomial ordering.

`NCMonomialOrderQ` is used by [NCMonomialOrder](#NCMonomialOrder) to
decided whether a proposed ordering is valid or not. However,
`NCMonomialOrder` is much more forgiving when it comes to the format
of the order.

See also:
[NCMonomialOrder](#NCMonomialOrder),
[NCRationalToNCPoly](#NCRationalToNCPoly).

### NCMonomialOrder {#NCMonomialOrder}

`NCMonomialOrder[var1, var2, ...]` returns an array representing a
monomial order.

For example

	NCMonomialOrder[a,b,c]

returns
```output
{{a},{b},{c}}
```
corresponding to the lex order $a \ll b \ll c$. 

If one uses a list of variables rather than a single variable as one
of the arguments, then multigraded lex order is used. For example

	NCMonomialOrder[{a,b,c}]

returns
```output
{{a,b,c}}
```
corresponding to the graded lex order $a < b < c$. 

Another example:

	NCMonomialOrder[{{a, b}, {c}}]

or

	NCMonomialOrder[{a, b}, c]

both return
```output
{{a,b},{c}}
```
corresponding to the multigraded lex order $a < b \ll c$.

See also:
[NCMonomialOrderQ](#NCMonomialOrderQ),
[NCRationalToNCPoly](#NCRationalToNCPoly),
[SetMonomialOrder](#SetMonomialOrder).

### NCRationalToNCPoly {#NCRationalToNCPoly}

`NCRationalToNCPoly[expr, vars]` generates a representation of the
noncommutative rational expression or list of rational expressions
`expr` in `vars` which has commutative coefficients.

`NCRationalToNCPoly[expr, vars]` generates one or more `NCPoly`s in
which `vars` is used to set a monomial ordering as per
[NCMonomialOrder](#NCMonomialOrder).

`NCRationalToNCPolynomial` creates one variable for each `inv`
expression in `vars` appearing in the rational expression `expr`. It
also created additional relations to encode the inverse. It also
creates additional variables to represent `tp` and `aj`.

It returns a list of four elements:

- the first element is the original expression and any additional
  expressions as `NCPoly`s;
- the second element is the list of variables representing the current
  ordering, including any additional variables created to replace
  `inv`s, `tp`s, and `aj`s;
- the third element is a list of rules that can be used to recover the
  original rational expression;
- the fourth element is a list of labels corresponding to the
  variables in the second element.

For example:

    exp = a+tp[a]-inv[a];
	order = NCMonomialOrder[a,b];
    {rels,vars,rules,labels} = NCRationalToNCPoly[exp, order]

returns

    rels = {
	  NCPoly[{2,1,1},<|{0,0,1,0} -> 1,{0,0,1,1} -> 1,{1,0,0,3} -> -1|>],
	  NCPoly[{2,1,1},<|{0,0,0,0} -> -1,{1,0,1,12} -> 1|>],
	  NCPoly[{2,1,1},<|{0,0,0,0} -> -1,{1,0,1,3} -> 1|>]
    }
	vars = {{a,tp51},{b},{rat50}},
	rules = {rat50 -> inv[a],tp51 -> tp[a]},
	labels = {{a,tp[a]},{b},{inv[a]}}
    
The variable `tp51` was created to represent `tp[a]` and `rat50` was
created to represent `inv[a]`. The additional relations in `rels`
correspond to `a**rat50 - 1` and `rat50**a - 1`, which encode the
rational relation `rat50 - inv[a]`.
	
`NCRationalToPoly` also handles rational expressions, not only
rational variables. For example:

    expr = a ** inv[1 - a] ** a;
    order = NCMonomialOrder[a, inv[1 - a]];
    {p, vars, rules, labels} = NCRationalToNCPoly[expr, order]

See also:
[NCMonomialOrder](#NCMonomialOrder),
[NCMonomialOrderQ](#NCMonomialOrderQ),
[NCPolyToNC](#NCPolyToNC),
[NCPoly](#NCPoly),
[NCRationalToNCPolynomial](#NCRationalToNCPolynomial).

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

`NCReduce[polys, rules, vars, options]` reduces the list of
polynomials in `polys` by the list of polynomials in `rules` in the
variables `vars`. The substitutions implied by `rules` are applied
repeatedly to the polynomials in the `polys` until no further
reduction occurs.

Note that the exact meaning of rules depends on the polynomial
ordering implied by the `vars`. For example, if

    polys = x^3 + x ** y
    rules = x^2 - x ** y

then

    NCReduce[polys, rules, {y, x}]

produces
```output
x ** y + x ** y ** x
```
because `x^2 - x ** y` is interpreted as `x^2 -> x ** y`, while

    NCReduce[polys, rules, {x, y}]

produces
```output
x^2 + x^3
```
because `x^2 - x ** y` is interpreted as `x ** y -> x^2`.

By default, `NCReduce` only reduces the leading monomial in the
current order. Use the optional boolean flag `Complete` to completely
reduce all monomials. For example,

    NCReduce[polys, rules, Complete -> True]
    NCReduce[polys, Complete -> True]

See [NCPolyReduce](#NCPolyReduce) for a complete list of `options`.

`NCReduce[polys, vars, options]` reduces each polynomial in the list
of `NCPoly`s `polys` with respect to the remaining elements of the
list of polyomials `polys`. It traverses the list of polys just
once. Use [NCReduceRepeated](#NCReduceRepeated) to continue applying
`NCReduce` until no further reduction occurs.

`NCReduce` converts `polys` and `rules` to NCPoly polynomials and
apply [NCPolyReduce](#NCPolyReduce).

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
