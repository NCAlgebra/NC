# NCCollect

Members are:

* [NCCollect](#NCCollect)
* [NCCollectSelfAdjoint](#NCCollectSelfAdjoint)
* [NCCollectSymmetric](#NCCollectSymmetric)
* [NCCompose](#NCCompose)
* [NCDecompose](#NCDecompose)
* [NCStrongCollect](#NCStrongCollect)
* [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint)
* [NCStrongCollectSymmetric](#NCStrongCollectSymmetric)

<a name="NCCollect">
## NCCollect
</a>

`NCCollect[expr,vars]` collects terms of nc expression `expr` according to the elements of `vars` and attempts to combine them. It is weaker than NCStrongCollect in that only same order terms are collected togther. It basically is `NCCompose[NCStrongCollect[NCDecompose]]]`.

See also:
[NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

<a name="NCCollectSelfAdjoint">
## NCCollectSelfAdjoint
</a>

`NCCollectSelfAdjoint[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their adjoints without writing out the adjoints.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

<a name="NCCollectSymmetric">
## NCCollectSymmetric
</a>

`NCCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

<a name="NCStrongCollect">
## NCStrongCollect
</a>

`NCStrongCollect[expr,vars]` collects terms of expression `expr` according to the elements of `vars` and attempts to combine by association. 

In the noncommutative case the Taylor expansion and so the collect function is not uniquely specified. The function `NCStrongCollect` often collects too much and while correct it may be stronger than you want.

For example, a symbol `x` will factor out of terms where it appears both linearly and quadratically thus mixing orders.

See also:
[NCCollect](#NCCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

<a name="NCStrongCollectSelfAdjoint">
## NCStrongCollectSelfAdjoint
</a>

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric).

<a name="NCStrongCollectSymmetric">
## NCStrongCollectSymmetric
</a>

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

See also:
[NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

<a name="NCCompose">
## NCCompose
</a>

`NCCompose[dec]` will reassemble the terms in `dec` which were decomposed by [`NCDecompose`](#NCDecompose).

`NCCompose[dec, degree]` will reassemble only the terms of degree `degree`.

`NCCompose[NCDecompose[p,vars]]` will reproduce the polynomial `p`.

`NCCompose[NCDecompose[p,vars], degree]` will reproduce only the terms of degree `degree`.

See also:
[NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).

<a name="NCDecompose">
## NCDecompose
</a>

`NCDecompose[p,vars]` gives an association of elements of the nc polynomial `p` in variables `vars` in which elements of the same order are collected together.

`NCDecompose` uses [`NCPDecompose`](#NCPDecompose).

See also:
[NCCompose](#NCCompose), [NCPDecompose](#NCPDecompose).
