## NCPolynomial {#PackageNCPolynomial}

### Efficient storage of NC polynomials with nc coefficients 

This package contains functionality to convert an nc polynomial expression into an expanded efficient representation that can have commutative or noncommutative coefficients.

For example the polynomial

    exp = a**x**b - 2 x**y**c**x + a**c

in variables `x` and `y` can be converted into an NCPolynomial using

    p = NCToNCPolynomial[exp, {x,y}]

which returns

    p = NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

Members are:


* Constructors
  * [NCPolynomial](#NCPolynomial)
  * [NCToNCPolynomial](#NCToNCPolynomial)
  * [NCPolynomialToNC](#NCPolynomialToNC)
  * [NCRationalToNCPolynomial](#NCRationalToNCPolynomial)
* Access and utilities
  * [NCPCoefficients](#NCPCoefficients)
  * [NCPTermsOfDegree](#NCPTermsOfDegree)
  * [NCPTermsOfTotalDegree](#NCPTermsOfTotalDegree)
  * [NCPTermsToNC](#NCPTermsToNC)
  * [NCPDecompose](#NCPDecompose)
  * [NCPDegree](#NCPDegree)
  * [NCPMonomialDegree](#NCPMonomialDegree)
  * [NCPCompatibleQ](#NCPCompatibleQ)
  * [NCPSameVariablesQ](#NCPSameVariablesQ)
  * [NCPMatrixQ](#NCPMatrixQ)
  * [NCPLinearQ](#NCPLinearQ)
  * [NCPQuadraticQ](#NCPQuadraticQ)
  * [NCPNormalize](#NCPNormalize)
* Arithmetic
  * [NCPTimes](#NCPTimes)
  * [NCPDot](#NCPDot)
  * [NCPPlus](#NCPPlus)
  * [NCPSort](#NCPSort)

### Ways to represent NC polynomials

#### NCPolynomial {#NCPolynomial}

`NCPolynomial[indep,rules,vars]` is an expanded efficient representation for an nc polynomial in `vars` which can have commutative or noncommutative coefficients.

The nc expression `indep` collects all terms that are independent of the letters in `vars`.

The *Association* `rules` stores terms in the following format:

    {mon1, ..., monN} -> {scalar, term1, ..., termN+1}

where:

* `mon1, ..., monN`: are nc monomials in vars;
* `scalar`: contains all commutative coefficients; and
* `term1, ..., termN+1`: are nc expressions on letters other than
the ones in vars which are typically the noncommutative
coefficients of the polynomial.

`vars` is a list of *Symbols*.

For example the polynomial

    a**x**b - 2 x**y**c**x + a**c

in variables `x` and `y` is stored as:

    NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

NCPolynomial specific functions are prefixed with NCP, e.g. NCPDegree.

See also:
[`NCToNCPolynomial`](#NCToNCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC), [`NCPTermsToNC`](#NCPTermsToNC).

#### NCToNCPolynomial {#NCToNCPolynomial}

`NCToNCPolynomial[p, vars]` generates a representation of the noncommutative polynomial `p` in `vars` which can have commutative or noncommutative coefficients.

`NCToNCPolynomial[p]` generates an `NCPolynomial` in all nc variables appearing in `p`.

Example:

    exp = a**x**b - 2 x**y**c**x + a**c
    p = NCToNCPolynomial[exp, {x,y}]

returns

    NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

See also:
[`NCPolynomial`](#NCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC).

#### NCPolynomialToNC {#NCPolynomialToNC}

`NCPolynomialToNC[p]` converts the NCPolynomial `p` back into a regular nc polynomial.

See also:
[`NCPolynomial`](#NCPolynomial), [`NCToNCPolynomial`](#NCToNCPolynomial).

#### NCRationalToNCPolynomial {#NCRationalToNCPolynomial}

`NCRationalToNCPolynomial[r, vars]` generates a representation of the noncommutative rational expression `r` in `vars` which can have commutative or noncommutative coefficients.

`NCRationalToNCPolynomial[r]` generates an `NCPolynomial` in all nc variables appearing in `r`.

`NCRationalToNCPolynomial` creates one variable for each `inv` expression in `vars` appearing in the rational expression `r`. It returns a list of three elements:

- the first element is the `NCPolynomial`;
- the second element is the list of new variables created to replace `inv`s;
- the third element is a list of rules that can be used to recover the original rational expression.

For example:

    exp = a**inv[x]**y**b - 2 x**y**c**x + a**c
    {p,rvars,rules} = NCRationalToNCPolynomial[exp, {x,y}]

returns

    p = NCPolynomial[a**c, <|{rat1**y}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y,rat1}]
    rvars = {rat1}
    rules = {rat1->inv[x]}

See also:
[`NCToNCPolynomial`](#NCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC).

### Grouping terms by degree

#### NCPTermsOfDegree {#NCPTermsOfDegree}

`NCPTermsOfDegree[p,deg]` gives all terms of the NCPolynomial `p` of degree `deg`.

The degree `deg` is a list with the degree of each symbol.

For example:

    p = NCPolynomial[0, <|{x,y}->{{2,a,b,c}},
	                       {x,x}->{{1,a,b,c}},
	                       {x**x}->{{-1,a,b}}|>, {x,y}]
    NCPTermsOfDegree[p, {1,1}]

returns

    <|{x,y}->{{2,a,b,c}}|>

and

    NCPTermsOfDegree[p, {2,0}]

returns

    <|{x,x}->{{1,a,b,c}}, {x**x}->{{-1,a,b}}|>

See also:
[`NCPTermsOfTotalDegree`](#NCPTermsOfTotalDegree),[`NCPTermsToNC`](#NCPTermsToNC).

#### NCPTermsOfTotalDegree {#NCPTermsOfTotalDegree}

`NCPTermsOfDegree[p,deg]` gives all terms of the NCPolynomial `p` of total degree `deg`.

The degree `deg` is the total degree.

For example:

    p = NCPolynomial[0, <|{x,y}->{{2,a,b,c}},
	                       {x,x}->{{1,a,b,c}},
	                       {x**x}->{{-1,a,b}}|>, {x,y}]
    NCPTermsOfDegree[p, 2]

returns

    <|{x,y}->{{2,a,b,c}},{x,x}->{{1,a,b,c}},{x**x}->{{-1,a,b}}|>

See also:
[`NCPTermsOfDegree`](#NCPTermsOfDegree),[`NCPTermsToNC`](#NCPTermsToNC).

#### NCPTermsToNC {#NCPTermsToNC}

`NCPTermsToNC` gives a nc expression corresponding to terms produced by `NCPTermsOfDegree` or `NCPTermsOfTotalDegree`.

For example:

    terms = <|{x,x}->{{1,a,b,c}}, {x**x}->{{-1,a,b}}|>
    NCPTermsToNC[terms]

returns

    a**x**b**c-a**x**b

See also:
[`NCPTermsOfDegree`](#NCPTermsOfDegree),[`NCPTermsOfTotalDegree`](#NCPTermsOfTotalDegree).

### Utilities

#### NCPDegree {#NCPDegree}

`NCPDegree[p]` gives the degree of the NCPolynomial `p`.

See also:
[`NCPMonomialDegree`](#NCPMonomialDegree).

#### NCPMonomialDegree {#NCPMonomialDegree}

`NCPMonomialDegree[p]` gives the degree of each monomial in the NCPolynomial `p`.

See also:
[`NCDegree`](#NCPMonomialDegree).

#### NCPCoefficients {#NCPCoefficients}

`NCPCoefficients[p, m]` gives all coefficients of the NCPolynomial `p` in the monomial `m`.

For example:

    exp = a**x**b - 2 x**y**c**x + a**c + d**x
    p = NCToNCPolynomial[exp, {x, y}]
    NCPCoefficients[p, {x}]

returns

    {{1, d, 1}, {1, a, b}}

and

    NCPCoefficients[p, {x**y, x}]

returns

    {{-2, 1, c, 1}}

See also:
[`NCPTermsToNC`](#NCPTermsToNC).

#### NCPLinearQ {#NCPLinearQ}

`NCPLinearQ[p]` gives True if the NCPolynomial `p` is linear.   

See also:
[`NCPQuadraticQ`](#NCPQuadraticQ).

#### NCPQuadraticQ {#NCPQuadraticQ}

`NCPQuadraticQ[p]` gives True if the NCPolynomial `p` is quadratic.

See also:
[`NCPLinearQ`](#NCPLinearQ).

#### NCPCompatibleQ {#NCPCompatibleQ}

`NCPCompatibleQ[p1,p2,...]` returns *True* if the polynomials `p1`,`p2`,... have the same variables and dimensions.

See also:
[NCPSameVariablesQ](#NCPSameVariablesQ), [NCPMatrixQ](#NCPMatrixQ).

#### NCPSameVariablesQ {#NCPSameVariablesQ}

`NCPSameVariablesQ[p1,p2,...]` returns *True* if the polynomials `p1`,`p2`,... have the same variables.

See also:
[NCPCompatibleQ](#NCPCompatibleQ), [NCPMatrixQ](#NCPMatrixQ).

#### NCPMatrixQ {#NCPMatrixQ}

`NCMatrixQ[p]` returns *True* if the polynomial `p` is a matrix polynomial.

See also:
[NCPCompatibleQ](#NCPCompatibleQ).

#### NCPNormalize {#NCPNormalize}

`NCPNormalizes[p]` gives a normalized version of NCPolynomial p
where all factors that have free commutative products are
collectd in the scalar.

This function is intended to be used mostly by developers.

See also:
[`NCPolynomial`](#NCPolynomial)

### Operations on NC polynomials

#### NCPPlus {#NCPPlus}

`NCPPlus[p1,p2,...]` gives the sum of the nc polynomials `p1`,`p2`,... .

#### NCPTimes {#NCPTimes}

`NCPTimes[s,p]` gives the product of a commutative `s` times the
nc polynomial `p`.

#### NCPDot {#NCPDot}

`NCPDot[p1,p2,...]` gives the product of the nc polynomials `p1`,`p2`,... .

#### NCPSort {#NCPSort}

`NCPSort[p]` gives a list of elements of the NCPolynomial `p` in which monomials are sorted first according to their degree then by Mathematica's implicit ordering.

For example

    NCPSort[NCToNCPolynomial[c + x**x - 2 y, {x,y}]]

will produce the list

    {c, -2 y, x**x}

See also:
[NCPDecompose](#NCPDecompose), [NCDecompose](#NCDecompose), [NCCompose](#NCCompose).

#### NCPDecompose {#NCPDecompose}

`NCPDecompose[p]` gives an association of elements of the NCPolynomial `p` in which elements of the same order are collected together.

For example

    NCPDecompose[NCToNCPolynomial[a**x**b+c+d**x**e+a**x**e**x**b+a**x**y, {x,y}]]

will produce the Association

    <|{1,0}->a**x**b + d**x**e, {1,1}->a**x**y, {2,0}->a**x**e**x**b, {0,0}->c|>

See also:
[NCPSort](#NCPSort), [NCDecompose](#NCDecompose), [NCCompose](#NCCompose).
