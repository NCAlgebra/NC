# NCSymmetric {#PackageNCSymmetric}

Members are:

* [NCSymmetricQ](#NCSymmetricQ)
* [NCSymmetricTest](#NCSymmetricTest)

## NCSymmetricQ {#NCSymmetricQ}

`NCSymmetricQ[expr]` returns *True* if `expr` is symmetric, i.e. if `tp[exp] == exp`.

`NCSymmetricQ` attempts to detect symmetric variables using `NCSymmetricTest`.

See also:
[NCSelfAdjointQ](#NCSelfAdjointQ), [NCSymmetricTest](#NCSymmetricTest).

## NCSymmetricTest {#NCSymmetricTest}

`NCSymmetricTest[expr]` attempts to establish symmetry of `expr` by assuming symmetry of its variables.
`NCSymmetricTest[exp,options]` uses `options`.

`NCSymmetricTest` returns a list of two elements:
* the first element is *True* or *False* if it succeded to prove `expr` symmetric.
* the second element is a list of the variables that were made symmetric.

The following options can be given:

* `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
* `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.

See also: 
[NCSymmetricQ](#NCSymmetricQ), [NCNCSelfAdjointTest](#NCSelfAdjointTest).