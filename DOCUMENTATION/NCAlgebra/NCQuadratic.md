# NCQuadratic {#PackageNCQuadratic}

**NCQuadratic** is a package that provides functionality to handle quadratic polynomials in NC variables.

Members are:

* [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric)
* [NCMatrixOfQuadratic](#NCMatrixOfQuadratic)
* [NCQuadratic](#NCQuadratic)
* [NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial)

## NCQuadratic {#NCQuadratic}
`NCQuadratic[p]` gives an expanded representation for the quadratic `NCPolynomial` `p`.

`NCQuadratic` returns a list with four elements:

* the first element is the independent term;
* the second represents the linear part as in [`NCSylvester`](#NCSylvester);
* the third element is a list of left NC symbols;
* the fourth element is a numeric `SparseArray`;
* the fifth element is a list of right NC symbols.

Example:

    exp = d + x + x**x + x**a**x + x**e**x + x**b**y**d + d**y**c**y**d;
    vars = {x,y};
    p = NCToNCPolynomial[exp, vars];
    {p0,sylv,left,middle,right} = NCQuadratic[p];

produces

    p0 = d
	sylv = <|x->{{1},{1},SparseArray[{{1}}]}, y->{{},{},{}}|>
    left =  {x,d**y}
	middle = SparseArray[{{1+a+e,b},{0,c}}]
	right = {x,y**d}

See also:
[NCSylvester](#NCSylvester),[NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial),[NCPolynomial](#NCPolynomial).

## NCQuadraticMakeSymmetric {#NCQuadraticMakeSymmetric}

`NCQuadraticMakeSymmetric[{p0, sylv, left, middle, right}]` takes the output of [`NCQuadratic`](#NCQuadratic) and produces, if possible, an equivalent symmetric representation in which `Map[tp, left] = right` and `middle` is a symmetric matrix.

See also:
[NCQuadratic](#NCQuadratic).

## NCMatrixOfQuadratic {#NCMatrixOfQuadratic}

`NCMatrixOfQuadratic[p, vars]` gives a factorization of the symmetric quadratic	function `p` in noncommutative variables `vars` and their transposes.

`NCMatrixOfQuadratic` checks for symmetry and automatically sets variables to be symmetric if possible.

Internally it uses [NCQuadratic](#NCQuadratic) and [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

It returns a list of three elements:

- the first is the left border row vector;
- the second is the middle matrix;
- the third is the right border column vector.

For example:

	expr = x**y**x + z**x**x**z;
    {left,middle,right}=NCMatrixOfQuadratics[expr, {x}];
	
returns:

    left={x, z**x}
	middle=SparseArray[{{y,0},{0,1}}]
	right={x,x**z}

The answer from `NCMatrixOfQuadratics` always satisfies `p =
MatMult[left,middle,right]`.

See also:
[NCQuadratic](#NCQuadratic), [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

## NCQuadraticToNCPolynomial {#NCQuadraticToNCPolynomial}

`NCQuadraticToNCPolynomial[rep]` takes the list `rep` produced by `NCQuadratic` and converts it back to an `NCPolynomial`.

`NCQuadraticToNCPolynomial[rep,options]` uses options.

The following options can be given:

- `Collect` (*True*): controls whether the coefficients of the resulting `NCPolynomial` are collected to produce the minimal possible number of terms.

See also:
[NCQuadratic](#NCQuadratic), [NCPolynomial](#NCPolynomial).
