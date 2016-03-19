# NCAlgebra Reference

## NCPolynomial.m

<a name="NCPolynomial">
### NCPolynomial 
</a>

`NCPolynomial[indep,rules,vars]` is an expanded efficient representation for an nc polynomial in `vars` which can have commutative or noncommutative coefficients.

The *nc expression* `indep` collects all terms that are independent of the letters in `vars`.
    
The *Association* `rules` stores monomials in the following format:

    {mon1, ..., monN} -> {scalar, term1, ..., termN+1}

where:

* `mon1, ..., monN`: are nc monomials in vars;
* `scalar`: contains all commutative coefficients; and 
* `term1, ..., termN+1`: are nc expressions on letters other than
the ones in vars which are typically the noncommutative
coefficients of the polynomial.
 
`vars` is a list of *Symbols*.
 
For example the polynomial
`a**x**b - 2 x**y**c**x + a**c` in variables `x` and `y`
is stored as:

    NCPolynomial[a**c, <|{x}->{1,a,b},{x**y,x}->{2,1,c,1}}|>, {x,y}]
    
NCPolynomial specific functions are prefixed with NCP, e.g. NCPDegree.

See also:
`NCToNCPolynomial`, `NCPolynomialToNC`.

<a name="NCToNCPolynomial">
### NCToNCPolynomial
</a>

`NCToNCPolynomial[p, vars]` generates a representation of the noncommutative polynomial `p` in `vars` which can have commutative or noncommutative coefficients.

See also:
[`NCPolynomial`](#NCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC).

<a name="NCPolynomialToNC">
### NCPolynomialToNC
</a>

`NCPolynomialToNC[p]` converts the NCPolynomial `p` back into a regular nc polynomial.

See also:
`NCPolynomial`, `NCToNCPolynomial`.

### NCPNormalize

`NCPNormalizes[p]` gives a normalized version of NCPolynomial p
where all factors that have free commutative products are 
collectd in the first scalar.

### NCPDecompose

`NCPDecompose[p]` gives an association of elements of the
NCPolynomial `p` in which elements of the same order are collected
together.
   
For example

    NCPDecompose[NCPolynomial[a**x**b+c+d**x**e+a**x**e**x**b+a**x**y, {x,y}]]

will produce the Association

    <|{1,0}->a**x**b + d**x**e, {1,1}->a**x**y, {2,0}->a**x**e**x**b, {0,0}->c|>

See also:
`NCDecompose`, `NCCompose`.

### NCPTermsToNC

### NCPTerms

`NCPTerms[p, m]` gives all terms of the NCPolynomial `p`in the monomial `m`.
   
### NCPTermsOfDegree

### NCPTermsOfTotalDegree

### NCPDegree

`NCPDegree[p]` gives the degree of the NCPolynomial `p`.

See also:
`NCMonoomialDegree`.

### NCPMonomialDegree

`NCPDegree[p]` gives the degree of all monomials in the NCPolynomial `p`.

See also:
`NCDegree`.

### NCPLinearQ

`NCPLinearQ[p]` gives True if the NCPolynomial `p` is linear.   

See also:
`NCPQuadraticQ`.

### NCPQuadraticQ

`NCPQuadraticQ[p]` gives True if the NCPolynomial `p` is quadratic.

See also:
`NCPLinearQ`.