# NCSylvester {#PackageNCSylvester}

**NCSylvester** is a package that provides functionality to handle linear polynomials.

Members are:

* [NCSylvesterRepresentation](#NCSylvesterRepresentation)
* [NCSylvesterRepresentationToNCPolynomial](#NCSylvesterRepresentationToNCPolynomial)

## NCSylvesterRepresentation {#NCSylvesterRepresentation}

`NCSylvesterRepresentation[p]` gives an expanded representation for the linear `NCPolynomial` `p`.

`NCSylvesterRepresentation` returns a list with the coefficients of the linear polynomial `p` where the first element is a the independent term, and the remaining elements are lists with four elements:

* the first element is a list of right nc symbols;
* the second element is a list of right nc symbols;
* the third element is a numeric array;
* the fourth element is a variable.

Example:

    p = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
    NCSylvesterRepresentation[exp,x]

produces

    {2, {left1,right1,array1,var1}, {left2,right2,array2,var2}}

where

    left1 = {a,c}
    right1 = {b,d}
    array1 = {{1,0},{0,1}}
    var1 = x
and

    left2 = {1}
    right2 = {1}
    array2 = {{1}}
    var2 = y

See also:
[NCSylvesterRepresentationToNCPolynomial](#NCSylvesterRepresentationToNCPolynomial), [NCPolynomial](#NCPolynomial).

## NCSylvesterRepresentationToNCPolynomial {#NCSylvesterRepresentationToNCPolynomial}

`NCSylvesterRepresentationToNCPolynomial[args]` takes the list args produced by `NCSylvesterRepresentation` and converts it back to an `NCPolynomial`.

`NCSylvesterRepresentationToNCPolynomial[args,options]` uses `options`.

The following `options` can be given:
* `Collect` (*True*): controls whether the coefficients of the resulting NCPolynomial are collected to produce the minimal possible number of terms.

See also:
[NCSylvesterRepresentation](#NCSylvesterRepresentation), [NCPolynomial](#NCPolynomial).
