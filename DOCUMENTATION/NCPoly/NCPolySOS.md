## NCPolySOS {#PackageNCPolySOS}

Members are:

* [NCPolySOS](#NCPolySOS)
* [NCPolySOSToSDP] (#NCPolySOSToSDP)

### NCPolySOS {#NCPolySOS}

`NCPolySOS[p, var]` returns an `NCPoly` with symbolic coefficients on
the variable `var` corresponding to a possible Gram representation of
the polynomial `p`.

`NCPolySOS` uses [NCPolyQuadraticChipset](#NCPolyQuadraticChipset) to
generate a sparse Gram representation.

`NCPolySOS[p]` uses `q` as default symbol.

See also:
[NCPolySOSToSDP](#NCPolySOSToSDP),
[NCPolyQuadraticChipset](#NCPolyQuadraticChipset)

### NCPolySOSToSDP {#NCPolySOSToSDP}

`NCPolySOSToSDP[G, options]`

See also:
[NCPolySOS](#NCPolySOS).

