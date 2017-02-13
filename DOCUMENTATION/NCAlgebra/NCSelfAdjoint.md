## NCSelfAdjoint {#PackageNCSelfAdjoint}

Members are:

* [NCSymmetricQ](#NCSymmetricQ)
* [NCSymmetricTest](#NCSymmetricTest)
* [NCSymmetricPart](#NCSymmetricPart)
* [NCSelfAdjointQ](#NCSelfAdjointQ)
* [NCSelfAdjointTest](#NCSelfAdjointTest)

### NCSymmetricQ {#NCSymmetricQ}

`NCSymmetricQ[expr]` returns *True* if `expr` is symmetric, i.e. if `tp[exp] == exp`.

`NCSymmetricQ` attempts to detect symmetric variables using `NCSymmetricTest`.

See also:
[NCSelfAdjointQ](#NCSelfAdjointQ), [NCSymmetricTest](#NCSymmetricTest).

### NCSymmetricTest {#NCSymmetricTest}

`NCSymmetricTest[expr]` attempts to establish symmetry of `expr` by assuming symmetry of its variables.

`NCSymmetricTest[exp,options]` uses `options`.

`NCSymmetricTest` returns a list of two elements:

* the first element is *True* or *False* if it succeeded to prove `expr` symmetric.
* the second element is a list of the variables that were made symmetric.

The following options can be given:

* `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
* `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables;
* `Strict`: treats as non-symmetric any variable that appears inside `tp`.

See also:
[NCSymmetricQ](#NCSymmetricQ), [NCNCSelfAdjointTest](#NCSelfAdjointTest).

### NCSymmetricPart {#NCSymmetricPart}

`NCSymmetricPart[expr]` returns the *symmetric part* of `expr`.

`NCSymmetricPart[exp,options]` uses `options`.

`NCSymmetricPart[expr]` returns a list of two elements:

* the first element is the *symmetric part* of `expr`;
* the second element is a list of the variables that were made symmetric.

`NCSymmetricPart[expr]` returns `{$Failed, {}}` if `expr` is not symmetric.

For example:

    {answer, symVars} = NCSymmetricPart[a ** x + x ** tp[a] + 1];
	
returns

    answer = 2 a ** x + 1
	symVars = {x}
	
The following options can be given:

* `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
* `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.
* `Strict`: treats as non-symmetric any variable that appears inside `tp`.

See also:
[NCSymmetricTest](#NCSymmetricTest).


### NCSelfAdjointQ {#NCSelfAdjointQ}

`NCSelfAdjointQ[expr]` returns true if `expr` is self-adjoint, i.e. if `aj[exp] == exp`.

See also:
[NCSymmetricQ](#NCSymmetricQ), [NCSelfAdjointTest](#NCSelfAdjointTest).

### NCSelfAdjointTest {#NCSelfAdjointTest}

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
* `Strict`: treats as non-self-adjoint any variable that appears inside `aj`.

See also:
[NCSelfAdjointQ](#NCSelfAdjointQ).
