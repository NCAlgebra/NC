## NCPolyInterface {#PackageNCPolyInterface}

Members are:

* [NCToNCPoly](#NCToNCPoly)
* [NCPolyToNC](#NCPolyToNC)
* [NCMonomialList](#NCMonomialList)
* [NCCoefficientRules](#NCCoefficientRules)
* [NCCoefficientList](#NCCoefficientList)
* [NCVariables](#NCVariables)

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

### NCVariables {#NCVariables}

`NCVariables[poly]` gives a list of all independent nc variables in the
polynomial `poly`.

For example:

	NCVariables[B + A y ** x ** y - 2 x]

returns

	{x,y}

See also:
[NCMonomialList](#NCMonomialList),
[NCCoefficientRules](#NCCoefficientRules),
[NCVariables](#NCVariables).
