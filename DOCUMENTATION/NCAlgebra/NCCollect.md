## NCCollect {#PackageNCCollect}

Members are:

* [NCCollect](#NCCollect)
* [NCCollectSelfAdjoint](#NCCollectSelfAdjoint)
* [NCCollectSymmetric](#NCCollectSymmetric)
* [NCStrongCollect](#NCStrongCollect)
* [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint)
* [NCStrongCollectSymmetric](#NCStrongCollectSymmetric)
* [NCCompose](#NCCompose)
* [NCDecompose](#NCDecompose)
* [NCTermsOfDegree](#NCTermsOfDegree)

### NCCollect {#NCCollect}

`NCCollect[expr,vars]` collects terms of nc expression `expr` according to the elements of `vars` and attempts to combine them. It is weaker than NCStrongCollect in that only same order terms are collected togther. It basically is `NCCompose[NCStrongCollect[NCDecompose]]]`.

If `expr` is a rational nc expression then degree correspond to the degree of the polynomial obtained using [NCRationalToNCPolynomial](#NCRationalToNCPolynomial).

`NCCollect` also works with nc expressions instead of *Symbols* in vars. In this case nc expressions are replaced by new variables and `NCCollect` is called using the resulting expression and the newly created *Symbols*.

This command internally converts nc expressions into the special `NCPolynomial` format.

`NCCollect[expr,vars,options]` uses options.

The following option is available:
 
- `ByTotalDegree` (`False`): whether to collect by total or partial degree.

**Notes:**

While `NCCollect[expr, vars]` always returns mathematically correct
expressions, it may not collect `vars` from as many terms as one might
think it should.

See also:
[NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint), [NCRationalToNCPolynomial](#NCRationalToNCPolynomial).

### NCCollectSelfAdjoint {#NCCollectSelfAdjoint}

`NCCollectSelfAdjoint[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their adjoints without writing out the adjoints.

This command internally converts nc expressions into the special `NCPolynomial` format.

`NCCollectSelfAdjoint[expr,vars,options]` uses options.

The following option is available:
 
- `ByTotalDegree` (`False`): whether to collect by total or partial degree.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

### NCCollectSymmetric {#NCCollectSymmetric}

`NCCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

`NCCollectSymmetric[expr,vars,options]` uses options.

The following option is available:
 
- `ByTotalDegree` (`False`): whether to collect by total or partial degree.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

### NCStrongCollect {#NCStrongCollect}

`NCStrongCollect[expr,vars]` collects terms of expression `expr` according to the elements of `vars` and attempts to combine by association.

In the noncommutative case the Taylor expansion and so the collect function is not uniquely specified. The function `NCStrongCollect` often collects too much and while correct it may be stronger than you want.

For example, a symbol `x` will factor out of terms where it appears both linearly and quadratically thus mixing orders.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCCollect](#NCCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

### NCStrongCollectSelfAdjoint {#NCStrongCollectSelfAdjoint}

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric).

### NCStrongCollectSymmetric {#NCStrongCollectSymmetric}

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

### NCCompose {#NCCompose}

`NCCompose[dec]` will reassemble the terms in `dec` which were decomposed by [`NCDecompose`](#NCDecompose).

`NCCompose[dec, degree]` will reassemble only the terms of degree `degree`.

The expression `NCCompose[NCDecompose[p,vars]]` will reproduce the polynomial `p`.

The expression `NCCompose[NCDecompose[p,vars], degree]` will reproduce only the terms of degree `degree`.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).

### NCDecompose {#NCDecompose}

`NCDecompose[p,vars]` gives an association of elements of the nc polynomial `p` in variables `vars` in which elements of the same order are collected together.

`NCDecompose[p]` treats all nc letters in `p` as variables.

This command internally converts nc expressions into the special `NCPolynomial` format.

Internally `NCDecompose` uses [`NCPDecompose`](#NCPDecompose).

See also:
[NCCompose](#NCCompose), [NCPDecompose](#NCPDecompose).

### NCTermsOfDegree {#NCTermsOfDegree}

`NCTermsOfDegree[expr,vars,degrees]` returns an expression such that
each term has degree `degrees` in variables `vars`.

For example,

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {2,1}]

returns `x**y**x - x**x**y`,

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {1,0}]

returns `x**w`,

	NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {0,0}]

returns `z**w`, and

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {0,1}]

returns `0`.

This command internally converts nc expressions into the special
`NCPolynomial` format.

See also:
[NCTermsOfTotalDegree](#NCTermsOfTotalDegree),
[NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).

### NCTermsOfTotalDegree {#NCTermsOfTotalDegree}

`NCTermsOfTotalDegree[expr,vars,degree]` returns an expression such that
each term has total degree `degree` in variables `vars`.

For example,

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 3]

returns `x**y**x - x**x**y`,

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 1]

returns `x**w`,

	NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 0]

returns `z**w`, and

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 2]

returns `0`.

This command internally converts nc expressions into the special
`NCPolynomial` format.

See also:
[NCTermsOfDegree](#NCTermsOfDegree),
[NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).
