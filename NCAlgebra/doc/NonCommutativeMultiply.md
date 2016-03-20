# NonCommutativeMultiply {#PackageNonCommutativeMultiply}

**NonCommutativeMultiply** is the main package that provides noncommutative functionality to Mathematica's native `NonCommutativeMultiply` bound to the operator `**`.

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

## aj {#aj}

`aj[x]` is the adjoint of `x`. `aj` is a conjugate linear involution. 

See also:
[tp](#tp), [co](#co).

## co {#co}

`co[x]` is the conjugate of `x`. It is a linear involution.

See also:
[aj](#aj).

## Id {#Id}

`Id` is noncommutative multiplicative identity. Actually Id is now set equal `1`.

## inv {#inv}

`inv[x]` is the 2-sided inverse of `x`.

## rt {#rt}

`rt[x]` is the root of `x`. 

## tp {#tp}

`tp[x]` is the tranpose of `x`. It is a linear involution.

See also:
[aj](#tp), [co](#co).

## Commutative {#Commutative}

`Commutative[x]` makes the noncommutative *Symbol* `x` behave as if it were commutative.
         
See also:
[CommuteEverything](#CommuteEverything), [CommutativeQ](#CommutativeQ), [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

## CommutativeQ {#CommutativeQ}

`CommutativeQ[x]` is *True* if `x` is commutative (the default), and *False* if `x` is noncommutative.
    
See also:
[SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

## NonCommutativeQ {#NonCommutativeQ}

NonCommutativeQ[x] is equal to Not[CommutativeQ[x]]. 

See CommutativeQ.

## SetCommutative {#SetCommutative}

`SetCommutative[a,b,c,...]` sets all the *Symbols* `a`, `b`, `c`, ... to be commutative.

See also:
[SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

## SetNonCommutative {#SetNonCommutative}

`SetNonCommutative[a,b,c,...]` sets all the *Symbols* `a`, `b`, `c`, ... to be noncommutative.

See also:
[SetCommutative](#SetCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

## CommuteEverything {#CommuteEverything}

`CommuteEverything` answers the question "what does it sound like?".

`CommuteEverything[expr]` replaces all noncommutative symbols in  `expr` by its commutative self using `Commutative` so that the resulting expression contains only commutative products or inverses.

See also:
[Commutative](#Commutative).

## ExpandNonCommutativeMultiply {#ExpandNonCommutativeMultiply}

`ExpandNonCommutativeMultiply[expr]` expands out `**`s in `expr`.

For example

    ExpandNonCommutativeMultiply[a**(b+c)]
    
returns

    a**b+a**c.

Its aliases are `NCE`, and `NCExpand`.
