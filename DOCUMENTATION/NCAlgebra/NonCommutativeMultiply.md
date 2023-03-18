## NonCommutativeMultiply {#PackageNonCommutativeMultiply}

`NonCommutativeMultiply` is the main package that provides noncommutative functionality to Mathematica's native `NonCommutativeMultiply` bound to the operator `**`.

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
* [SetCommutativeHold](#SetCommutativeHold)
* [SetNonCommutative](#SetNonCommutative)
* [SetNonCommutativeHold](#SetNonCommutativeHold)
* [SetCommutativeFunction](#SetCommutativeFunction)
* [SetNonCommutativeFunction](#SetNonCommutativeFunction)
* [SetCommutingOperators](#SetCommutingOperators)
* [UnsetCommutingOperators](#UnsetCommutingOperators)
* [CommutingOperatorsQ](#CommutingOperatorsQ)
* [NCNonCommutativeSymbolOrSubscriptQ](#NCNonCommutativeSymbolOrSubscriptQ)
* [NCNonCommutativeSymbolOrSubscriptExtendedQ](#NCNonCommutativeSymbolOrSubscriptExtendedQ)
* [NCPowerQ](#NCPowerQ)
* [Commutative](#Commutative)
* [CommuteEverything](#CommuteEverything)
* [BeginCommuteEverything](#BeginCommuteEverything)
* [EndCommuteEverything](#EndCommuteEverything)
* [ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply)
* [NCExpandExponents](#NCExpandExponents)
* [NCToList](#NCToList)

Aliases are:

* [SNC](#SNC) for [SetNonCommutative](#SetNonCommutative)
* [NCExpand](#NCExpand) for [ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply)
* [NCE](#NCE) for [ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply)

### aj {#aj}

`aj[expr]` is the adjoint of expression `expr`. It is a conjugate linear involution.

See also:
[tp](#tp), [co](#co).

### co {#co}

`co[expr]` is the conjugate of expression `expr`. It is a linear involution.

See also:
[aj](#aj).

### Id {#Id}

`Id` is noncommutative multiplicative identity. Actually Id is now set equal `1`.

### inv {#inv}

`inv[expr]` is the 2-sided inverse of expression `expr`.

If `Options[inv, Distrubute]` is `False` (the default) then 

    inv[a**b]

returns `inv[a**a]`. Conversely, if `Options[inv, Distrubute]` is `True` then it returns `inv[b]**inv[a]`.

### rt {#rt}

`rt[expr]` is the root of expression `expr`.

### tp {#tp}

`tp[expr]` is the tranpose of expression `expr`. It is a linear involution.

See also:
[aj](#tp), [co](#co).

### CommutativeQ {#CommutativeQ}

`CommutativeQ[expr]` is `True` if expression `expr` is commutative (the default), and `False` if `expr` is noncommutative.

See also:
[SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

### NonCommutativeQ {#NonCommutativeQ}

`NonCommutativeQ[expr]` is equal to `Not[CommutativeQ[expr]]`.

See also:
[CommutativeQ](#CommutativeQ).

### SetCommutative {#SetCommutative}

`SetCommutative[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, ... to be commutative.

See also:
[SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

### SetCommutativeHold {#SetCommutativeHold}

`SetCommutativeHold[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, ... to be commutative.

`SetCommutativeHold` has attribute `HoldAll` and can be used to set Symbols which have already been assigned a value.

See also:
[SetNonCommutativeHold](#SetNonCommutativeHold), [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

### SetNonCommutative {#SetNonCommutative}

`SetNonCommutative[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, ... to be noncommutative.

See also:
[SetCommutative](#SetCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

### SetNonCommutativeHold {#SetNonCommutativeHold}

`SetNonCommutativeHold[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, ... to be noncommutative.

`SetNonCommutativeHold` has attribute `HoldAll` and can be used to set Symbols which have already been assigned a value.

See also:
[SetCommutativeHold](#SetCommutativeHold), [SetCommutative](#SetCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

### SetCommutativeFunction {#SetCommutativeFunction}

`SetCommutativeFunction[f]` sets expressions with `Head` `f`, i.e. functions, to be commutative.

By default, expressions in which the `Head` or any of its arguments is noncommutative will be considered noncommutative. For example,

    SetCommutative[trace];
    a ** b ** trace[a ** b]

evaluates to `a ** b ** trace[a ** b]` while

    SetCommutativeFunction[trace];
    a ** b ** trace[a ** b]

evaluates to `trace[a ** b] * a ** b`.

See also:
[SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ), [tr](#tr).

### SetNonCommutativeFunction {#SetNonCommutativeFunction}

`SetNonCommutativeFunction[f]` sets expressions with `Head` `f`, i.e. functions, to be non commutative. This is only necessary if it has been previously set commutative by [SetCommutativeFunction](#SetCommutativeFunction).

See also:
[SetCommutativeFunction](#SetCommutativeFunction), [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ), [tr](#tr).

### SNC {#SNC}

`SNC` is an alias for `SetNonCommutative`.

See also:
[SetNonCommutative](#SetNonCommutative).

### SetCommutingOperators {#SetCommutingOperators}

`SetCommutingOperators[a,b]` will define a rule that substitute any
noncommutative product `b ** a` by `a ** b`, effectively making the
pair `a` and `b` commutative. If you want to create a rule to replace
`a ** b` by `b ** a` use `SetCommutingOperators[b,a]` instead.

See also:
[UnsetCommutingOperators](#UnsetCommutingOperators),
[CommutingOperatorsQ](#CommutingOperatorsQ)

### UnsetCommutingOperators {#UnsetCommutingOperators}

`UnsetCommutingOperators[a,b]` remove any rules previously created by
`SetCommutingOperators[a,b]` or `SetCommutingOperators[b,a]`.

See also:
[SetCommutingOperators](#SetCommutingOperators),
[CommutingOperatorsQ](#CommutingOperatorsQ)

### CommutingOperatorsQ {#CommutingOperatorsQ}

`CommutingOperatorsQ[a,b]` returns `True` if `a` and `b` are commuting operators.

See also:
[SetCommutingOperators](#SetCommutingOperators),
[UnsetCommutingOperators](#UnsetCommutingOperators)

### NCNonCommutativeSymbolOrSubscriptQ {#NCNonCommutativeSymbolOrSubscriptQ}

`NCNonCommutativeSymbolOrSubscriptQ[expr]` returns *True* if `expr` is an noncommutative symbol or a noncommutative symbol subscript.

See also:
[NCNonCommutativeSymbolOrSubscriptExtendedQ](#NCNonCommutativeSymbolOrSubscriptExtendedQ),
[NCSymbolOrSubscriptQ](#NCSymbolOrSubscriptQ),
[NCSymbolOrSubscriptExtendedQ](#NCSymbolOrSubscriptExtendedQ),
[NCPowerQ](#NCPowerQ).

### NCNonCommutativeSymbolOrSubscriptExtendedQ {#NCNonCommutativeSymbolOrSubscriptExtendedQ}

`NCNonCommutativeSymbolOrSubscriptExtendedQ[expr]` returns *True* if
`expr` is an noncommutative symbol, a noncommutative symbol subscript,
or the transpose (`tp`) or adjoint (`aj`) of a noncommutative symbol
or noncommutative symbol subscript.

See also:
[NCNonCommutativeSymbolOrSubscriptQ](#NCNonCommutativeSymbolOrSubscriptQ),
[NCSymbolOrSubscriptQ](#NCSymbolOrSubscriptQ),
[NCSymbolOrSubscriptExtendedQ](#NCSymbolOrSubscriptExtendedQ),
[NCPowerQ](#NCPowerQ).

### NCPowerQ {#NCPowerQ}

`NCPowerQ[expr]` returns *True* if `expr` is an noncommutative symbol or symbol subscript or a positive power of a noncommutative symbol or symbol subscript.

See also:
[NCNonCommutativeSymbolOrSubscriptQ](#NCNonCommutativeSymbolOrSubscriptQ),
[NCSymbolOrSubscriptQ](#NCSymbolOrSubscriptQ).

### Commutative {#Commutative}

`Commutative[symbol]` is commutative even if `symbol` is noncommutative.

See also:
[CommuteEverything](#CommuteEverything), [CommutativeQ](#CommutativeQ), [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

### CommuteEverything {#CommuteEverything}

`CommuteEverything[expr]` is an alias for [BeginCommuteEverything](#BeginCommuteEverything).

See also:
[BeginCommuteEverything](#BeginCommuteEverything), [Commutative](#Commutative).

### BeginCommuteEverything {#BeginCommuteEverything}

`BeginCommuteEverything[expr]` sets all symbols appearing in `expr` as commutative so that the resulting expression contains only commutative products or inverses. It issues messages warning about which symbols have been affected.

`EndCommuteEverything[]` restores the symbols noncommutative behaviour.

`BeginCommuteEverything` answers the question *what does it sound like?*

See also:
[EndCommuteEverything](#EndCommuteEverything), [Commutative](#Commutative).

### EndCommuteEverything {#EndCommuteEverything}

`EndCommuteEverything[expr]` restores noncommutative behaviour to symbols affected by `BeginCommuteEverything`.

See also:
[BeginCommuteEverything](#BeginCommuteEverything), [Commutative](#Commutative).

### ExpandNonCommutativeMultiply {#ExpandNonCommutativeMultiply}

`ExpandNonCommutativeMultiply[expr]` expands out `**`s in `expr`.

For example

    ExpandNonCommutativeMultiply[a**(b+c)]

returns

    a**b + a**c.

See also:
[NCExpand](#NCExpand), [NCE](#NCE).

### NCExpand {#NCExpand}

`NCExpand` is an alias for `ExpandNonCommutativeMultiply`.

See also:
[ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply),
[NCE](#NCE).

### NCE {#NCE}

`NCE` is an alias for `ExpandNonCommutativeMultiply`.

See also:
[ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply),
[NCExpand](#NCExpand).

### NCExpandExponents {#NCExpandExponents}

`NCExpandExponents[expr]` expands out powers of the monomials appearing in `expr`.

For example

    NCExpandExponents[a**(b**c)^2**(c+d)]

returns

    a**b**c**b**c**(c+d).

`NCExpandExponents` only expands powers of monomials. Powers of
symbols or other expressions are not expanded using
`NCExpandExponents`.

See also:
[NCToList](#NCToList)
[ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply),
[NCExpand](#NCExpand), [NCE](#NCE).

### NCToList {#NCToList}

`NCToList[expr]` produces a list with the symbols appearing in
monomial `expr`. If `expr` is not a monomial it remains
unevaluated. Powers of symbols are expanded before the list is
produced.

For example

    NCToList[a**b**a^2]

returns

    {a,b,a,a}

See also:
[NCExpandExponents](#NCExpandExponents),
[ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply),
[NCExpand](#NCExpand), [NCE](#NCE).
