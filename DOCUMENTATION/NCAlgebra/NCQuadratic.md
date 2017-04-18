## NCQuadratic {#PackageNCQuadratic}

**NCQuadratic** is a package that provides functionality to handle quadratic polynomials in NC variables.

Members are:

* [NCToNCQuadratic](#NCToNCQuadratic)
* [NCPToNCQuadratic](#NCPToNCQuadratic)
* [NCQuadraticToNC](#NCQuadraticToNC)
* [NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial)
* [NCMatrixOfQuadratic](#NCMatrixOfQuadratic)
* [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric)

### NCToNCQuadratic {#NCToNCQuadratic}

`NCToNCQuadratic[p, vars]` is shorthand for

    NCPToNCQuadratic[NCToNCPolynomial[p, vars]]

See also:
[NCToNCQuadratic](#NCToNCQuadratic),[NCToNCPolynomial](#NCToNCPolynomial).

### NCPToNCQuadratic {#NCPToNCQuadratic}

`NCPToNCQuadratic[p]` gives an expanded representation for the quadratic `NCPolynomial` `p`.

`NCPToNCQuadratic` returns a list with four elements:

* the first element is the independent term;
* the second represents the linear part as in [`NCSylvester`](#PackageNCSylvester);
* the third element is a list of left NC symbols;
* the fourth element is a numeric `SparseArray`;
* the fifth element is a list of right NC symbols.

Example:

    exp = d + x + x**x + x**a**x + x**e**x + x**b**y**d + d**y**c**y**d;
    vars = {x,y};
    p = NCToNCPolynomial[exp, vars];
    {p0,sylv,left,middle,right} = NCPToNCQuadratic[p];

produces

    p0 = d
	sylv = <|x->{{1},{1},SparseArray[{{1}}]}, y->{{},{},{}}|>
    left =  {x,d**y}
	middle = SparseArray[{{1+a+e,b},{0,c}}]
	right = {x,y**d}

See also:
[NCSylvester](#PackageNCSylvester),[NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial),[NCPolynomial](#NCPolynomial).

### NCQuadraticToNC {#NCQuadraticToNC}

`NCQuadraticToNC[{const, lin, left, middle, right}]` is shorthand for

    NCPolynomialToNC[NCQuadraticToNCPolynomial[{const, lin, left, middle, right}]]

See also:
[NCQuadraticToNCPolynomial](#NCQuadraticToNC),[NCPolynomialToNC](#NCPolynomialToNC).

### NCQuadraticToNCPolynomial {#NCQuadraticToNCPolynomial}

`NCQuadraticToNCPolynomial[rep]` takes the list `rep` produced by `NCPToNCQuadratic` and converts it back to an `NCPolynomial`.

`NCQuadraticToNCPolynomial[rep,options]` uses options.

The following options can be given:

- `Collect` (*True*): controls whether the coefficients of the resulting `NCPolynomial` are collected to produce the minimal possible number of terms.

See also:
[NCPToNCQuadratic](#NCPToNCQuadratic), [NCPolynomial](#NCPolynomial).

### NCMatrixOfQuadratic {#NCMatrixOfQuadratic}

`NCMatrixOfQuadratic[p, vars]` gives a factorization of the symmetric quadratic	function `p` in noncommutative variables `vars` and their transposes.

`NCMatrixOfQuadratic` checks for symmetry and automatically sets variables to be symmetric if possible.

Internally it uses [NCPToNCQuadratic](#NCPToNCQuadratic) and [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

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
NCDot[left,middle,right]`.

See also:
[NCPToNCQuadratic](#NCPToNCQuadratic), [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

### NCQuadraticMakeSymmetric {#NCQuadraticMakeSymmetric}

`NCQuadraticMakeSymmetric[{p0, sylv, left, middle, right}]` takes the output of [`NCPToNCQuadratic`](#NCPToNCQuadratic) and produces, if possible, an equivalent symmetric representation in which `Map[tp, left] = right` and `middle` is a symmetric matrix.

See also:
[NCPToNCQuadratic](#NCPToNCQuadratic).

