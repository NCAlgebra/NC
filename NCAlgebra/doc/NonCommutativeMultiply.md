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
