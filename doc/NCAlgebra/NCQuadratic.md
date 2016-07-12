# NCQuadratic {#PackageNCQuadratic}

**NCQuadratic** is a package that provides functionality to handle quadratic polynomials.

Members are:

* [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric)
* [NCMatrixOfQuadratic](#NCMatrixOfQuadratic)
* [NCQuadratic](#NCQuadratic)
* [NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial)

## NCQuadratic {#NCQuadratic}
`NCQuadratic[p]` gives an expanded representation for the quadratic `NCPolynomial` `p`.

`NCQuadratic` returns a list with the coefficients of the linear polynomial `p` where

- the first element is a the independent term,
- the remaining elements are lists with four elements:

  - the first element is a list of right nc symbols;
	- the second element is a list of right nc symbols;
	- the third element is a numeric array;
	- the fourth element is a variable.

Example:

    p = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
	  NCQuadratic[exp,x]

produces

    {2, {left1,right1,array1,var1}, {left2,right2,array2,var2}}

where

    left1 = {a,c}
    right1 = {b,d}
    array1 = {{1,0},{0,1}}
    var1 = x

and

    left1 = {1}
    right1 = {1}
    array1 = {{1}}
    var1 = y

See also:
[NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial),[NCPolynomial](#NCPolynomial).

## NCQuadraticMakeSymmetric {#NCQuadraticMakeSymmetric}

`NCQuadraticMakeSymmetric[q]`.

## NCMatrixOfQuadratic {#NCMatrixOfQuadratic}

`NCMatrixOfQuadratic[p, vars]` gives a factorization of the symmetric quadratic	function `p` in noncommutative variables `vars` and their transposes.

`NCMatrixOfQuadratic` checks for symmetry and automatically sets variables to be symmetric if possible.

Internally it uses [NCQuadratic](#NCQuadratic) and [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

See also:
[NCQuadratic](#NCQuadratic), [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

## NCQuadraticToNCPolynomial {#NCQuadraticToNCPolynomial}

`NCQuadraticToNCPolynomial[rep]` takes the list `rep` produced by `NCQuadratic` and converts it back to an `NCPolynomial`.

`NCQuadraticToNCPolynomial[rep,options]` uses options.

The following options can be given:

- `Collect` (*True*): controls whether the coefficients of the resulting `NCPolynomial` are collected to produce the minimal possible number of terms.

See also:
[NCQuadratic](#NCQuadratic), [NCPolynomial](#NCPolynomial).
