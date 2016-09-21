# NCSylvester {#PackageNCSylvester}

**NCSylvester** is a package that provides functionality to handle linear polynomials.

Members are:

* [NCSylvester](#NCSylvester)
* [NCSylvesterToNCPolynomial](#NCSylvesterToNCPolynomial)

## NCSylvester {#NCSylvester}

`NCSylvester[p]` gives an expanded representation for the linear `NCPolynomial` `p`.

`NCSylvester` returns a list with two elements:

* the first is a the independent term;
* the second is an association where each key is one of the variables and each value is a list with three elements:

  * the first element is a list of left NC symbols;
  * the second element is a list of right NC symbols;
  * the third element is a numeric `SparseArray`.

Example:

    p = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
    NCSylvester[exp,x]

produces

    {2, <|x->{{a,c},{b,d},SparseArray[{{1,0},{0,1}}]}, 
	      y->{{1},{1},SparseArray[{{1}}]}|>}

See also:
[NCSylvesterToNCPolynomial](#NCSylvesterToNCPolynomial), [NCPolynomial](#NCPolynomial).

## NCSylvesterToNCPolynomial {#NCSylvesterToNCPolynomial}

`NCSylvesterToNCPolynomial[rep]` takes the list `rep` produced by `NCSylvester` and converts it back to an `NCPolynomial`.

`NCSylvesterToNCPolynomial[rep,options]` uses `options`.

The following `options` can be given:
* `Collect` (*True*): controls whether the coefficients of the resulting NCPolynomial are collected to produce the minimal possible number of terms.

See also:
[NCSylvester](#NCSylvester), [NCPolynomial](#NCPolynomial).
