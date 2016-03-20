# NonCommutativeMultiply

Members are:

* [aj](#aj)
* [co](#co)
* [Id](#Id)
* [inv](#inv)
* [tp](#tp)
* [rt](#rt)
* [CommutativeQ](#CommutativeQ)
* [NonCommutativeQ](#NonCommutativeQ)
* [SetCommutative](#SetCommutative)
* [SetNonCommutative](#SetNonCommutative)
* [Commutative](#Commutative)
* [CommuteEverything](#CommuteEverything)
* [ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply)
* [NCSelfAdjointQ](#NCSelfAdjointQ)
* [NCSelfAdjointTest](#NCSelfAdjointTest)
* [NCSymmetricQ](#NCSymmetricQ)
* [NCSymmetricTest](#NCSymmetricTest)

<a name="aj">
## aj
</a>

`aj[x]` is the adjoint of `x`. `aj` is a conjugate linear involution. 

See also:
[tp](#tp), [co](#co).

<a name="co">
## co
</a>

`co[x]` is the conjugate of `x`. It is a linear involution.

See also:
[aj](#aj).

<a name="Id">
## Id
</a>

`Id` is noncommutative multiplicative identity. Actually Id is now set equal `1`.

<a name="inv">
## inv
</a>

`inv[x]` is the 2-sided inverse of `x`.

<a name="rt">
## rt
</a>

`rt[x]` is the root of `x`. 

<a name="tp">
## tp
</a>

`tp[x]` is the tranpose of `x`. It is a linear involution.

See also:
[aj](#tp), [co](#co).

<a name="Commutative">
## Commutative
</a>

`Commutative[x]` makes the noncommutative *Symbol* `x` behave as if it were commutative.
         
See also:
[CommuteEverything](#CommuteEverything), [CommutativeQ](#CommutativeQ), [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

<a name="CommutativeQ">
## CommutativeQ
</a>

`CommutativeQ[x]` is *True* if `x` is commutative (the default), and *False* if `x` is noncommutative.
    
See also:
[SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

<a name="NonCommutativeQ">
## NonCommutativeQ
</a>

NonCommutativeQ[x] is equal to Not[CommutativeQ[x]]. 

See CommutativeQ.

<a name="SetCommutative">
## SetCommutative
</a>

`SetCommutative[a,b,c,...]` sets all the *Symbols* `a`, `b`, `c`, ... to be commutative.

See also:
[SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

<a name="SetNonCommutative">
## SetNonCommutative
</a>

`SetNonCommutative[a,b,c,...]` sets all the *Symbols* `a`, `b`, `c`, ... to be noncommutative.

See also:
[SetCommutative](#SetCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

<a name="CommuteEverything">
## CommuteEverything
</a>

`CommuteEverything` answers the question "what does it sound like?".

`CommuteEverything[expr]` replaces all noncommutative symbols in  `expr` by its commutative self using `Commutative` so that the resulting expression contains only commutative products or inverses.

See also:
[Commutative](#Commutative).

<a name="ExpandNonCommutativeMultiply">
## ExpandNonCommutativeMultiply
</a>

`ExpandNonCommutativeMultiply[expr]` expands out `**`s in `expr`.

For example

    ExpandNonCommutativeMultiply[a**(b+c)]
    
returns

    a**b+a**c.

Its aliases are `NCE`, and `NCExpand`.

<a name="NCSelfAdjointQ">
## NCSelfAdjointQ
</a>

`NCSelfAdjointQ[expr]` returns true if `expr` is self-adjoint, i.e. if `aj[exp] == exp`.

See also:
[NCSymmetricQ](#NCSymmetricQ), [NCSelfAdjointTest](#NCSelfAdjointTest).

<a name="NCSelfAdjointTest">
## NCSelfAdjointTest
</a>

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

<a name="NCSymmetricQ">
## NCSymmetricQ
</a>

`NCSymmetricQ[expr]` returns *True* if `expr` is symmetric, i.e. if `tp[exp] == exp`.

`NCSymmetricQ` attempts to detect symmetric variables using `NCSymmetricTest`.

See also:
[NCSelfAdjointQ](#NCSelfAdjointQ), [NCSymmetricTest](#NCSymmetricTest).

<a name="NCSymmetricTest">
## NCSymmetricTest
</a>

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