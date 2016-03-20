# NCSelfAdjoint {#PackageNCSelfAdjoint}

Members are:

* [NCSelfAdjointQ](#NCSelfAdjointQ)
* [NCSelfAdjointTest](#NCSelfAdjointTest)

## NCSelfAdjointQ {#NCSelfAdjointQ}

`NCSelfAdjointQ[expr]` returns true if `expr` is self-adjoint, i.e. if `aj[exp] == exp`.

See also:
[NCSymmetricQ](#NCSymmetricQ), [NCSelfAdjointTest](#NCSelfAdjointTest).

## NCSelfAdjointTest {#NCSelfAdjointTest}

`NCSelfAdjointTest[expr]` attempts to establish whether `expr` is self-adjoint by assuming that some of its variables are self-adjoint or symmetric.
`NCSelfAdjointTest[expr,options]` uses `options`.

`NCSelfAdjointTest` returns a list of three elements:

* the first element is *True* or *False* if it succeded to prove `expr` self-adjoint.
* the second element is a list of variables that were made self-adjoint.
* the third element is a list of variables that were made symmetric.

The following options can be given:

* `SelfAdjointVariables`: list of variables that should be considered self-adjoint; use `All` to make all variables self-adjoint;
* `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
* `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.

See also:
[NCSelfAdjointQ](#NCSelfAdjointQ).
