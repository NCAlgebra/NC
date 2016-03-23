# NCUtil {#PackageNCUtil}

**NCUtil** is a package with a collection of utilities used throughout NCAlgebra.

Members are:

* [NCConsistentQ](#NCConsistentQ)
* [NCGrabFunctions](#NCGrabFunctions)
* [NCGrabSymbols](#NCGrabSymbols)

## NCConsistentQ {#NCConsistentQ}

`NCConsistentQ[expr]` returns *True* is `expr` contains no commutative products or inverses involving noncommutative variables.

## NCGrabFunctions {#NCGrabFunctions}

`NCGragFunctions[expr,f]` returns a list with all fragments of `expr` containing the function `f`.

For example:

    NCGrabFunctions[inv[x] + y**inv[1+inv[1+x**y]], inv]

returns

    {inv[1+inv[1+x**y]], inv[1+x**y], inv[x]}

See also:
[NCGrabSymbols](#NCGragSymbols).

## NCGrabSymbols {#NCGrabSymbols}

`NCGragSymbols[expr]` returns a list with all *Symbols* appearing in `expr`.

`NCGragSymbols[expr,f]` returns a list with all *Symbols* appearing in `expr` as the single argument of function `f`.

For example:

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]]]

returns `{x,y}` and

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]], inv]

returns `{inv[x]}`.

See also:
[NCGrabFunctions](#NCGragFunctions).
