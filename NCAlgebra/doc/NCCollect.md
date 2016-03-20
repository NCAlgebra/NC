# NCCollect {#PackageNCCollect}

Members are:

* [NCCollect](#NCCollect)
* [NCCollectSelfAdjoint](#NCCollectSelfAdjoint)
* [NCCollectSymmetric](#NCCollectSymmetric)
* [NCCompose](#NCCompose)
* [NCDecompose](#NCDecompose)
* [NCStrongCollect](#NCStrongCollect)
* [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint)
* [NCStrongCollectSymmetric](#NCStrongCollectSymmetric)

## NCCollect {#NCCollect}

`NCCollect[expr,vars]` collects terms of nc expression `expr` according to the elements of `vars` and attempts to combine them. It is weaker than NCStrongCollect in that only same order terms are collected togther. It basically is `NCCompose[NCStrongCollect[NCDecompose]]]`.

See also:
[NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

## NCCollectSelfAdjoint {#NCCollectSelfAdjoint}

`NCCollectSelfAdjoint[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their adjoints without writing out the adjoints.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

## NCCollectSymmetric {#NCCollectSymmetric}

`NCCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

## NCStrongCollect {#NCStrongCollect}

`NCStrongCollect[expr,vars]` collects terms of expression `expr` according to the elements of `vars` and attempts to combine by association. 

In the noncommutative case the Taylor expansion and so the collect function is not uniquely specified. The function `NCStrongCollect` often collects too much and while correct it may be stronger than you want.

For example, a symbol `x` will factor out of terms where it appears both linearly and quadratically thus mixing orders.

See also:
[NCCollect](#NCCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

## NCStrongCollectSelfAdjoint {#NCStrongCollectSelfAdjoint}

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric).

## NCStrongCollectSymmetric {#NCStrongCollectSymmetric}

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

## NCCompose {#NCCompose}

`NCCompose[dec]` will reassemble the terms in `dec` which were decomposed by [`NCDecompose`](#NCDecompose).

`NCCompose[dec, degree]` will reassemble only the terms of degree `degree`.

`NCCompose[NCDecompose[p,vars]]` will reproduce the polynomial `p`.

`NCCompose[NCDecompose[p,vars], degree]` will reproduce only the terms of degree `degree`.

See also:
[NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).

## NCDecompose {#NCDecompose}

`NCDecompose[p,vars]` gives an association of elements of the nc polynomial `p` in variables `vars` in which elements of the same order are collected together.

`NCDecompose` uses [`NCPDecompose`](#NCPDecompose).

See also:
[NCCompose](#NCCompose), [NCPDecompose](#NCPDecompose).
