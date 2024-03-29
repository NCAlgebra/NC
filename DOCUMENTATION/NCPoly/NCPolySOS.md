## NCPolySOS {#PackageNCPolySOS}

Members are:

* [NCPolySOS](#NCPolySOS)
* [NCPolySOSToSDP](#NCPolySOSToSDP)

### NCPolySOS {#NCPolySOS}

`NCPolySOS[degree, var]` returns an `NCPoly` with symbolic
coefficients on the variable `var` corresponding to a possible Gram
representation of an noncommutative SOS polynomial of degree `degree`
and its corresponding Gram matrix.

`NCPolySOS[poly, var]` uses
[NCPolyQuadraticChipset](#NCPolyQuadraticChipset) to generate a sparse
Gram representation of the noncommutative polynomial `poly`.

`NCPolySOS[degree]` and `NCPolySOS[p]` returns the answer in terms of
a newly created unique symbol.

For example,

    {q,Q,x} = NCPolySOS[4];

returns the symbolic SOS `NCPoly` `q` and its Gram matrix `Q`
expressed in terms of the variable `x`, and

    {q,Q,x,chipset} = NCPolySOS[poly];

returns the symbolic NCPoly `q` and its Gram matrix `Q` corresponding
to terms in the quadratic `chipset` expressed in terms of the variable
`x`.

See also:
[NCPolySOSToSDP](#NCPolySOSToSDP),
[NCPolyQuadraticChipset](#NCPolyQuadraticChipset)

### NCPolySOSToSDP {#NCPolySOSToSDP}

`{sdp, vars, sol, solQ} = NCPolySOSToSDP[ps, Qs, var]` returns a
semidefinite constraint `sdp` in the variables `vars` and the rules
`sol` and `solQ` that can be used to solve for variables in the list
of SOS NCPoly `ps` and the list of Gram matrices `Qs`.

For example,

   {q, Q, $, chipset} = NCPolySOS[poly, q];
   {sdp, vars, sol, solQ} = NCPolySOSToSDP[{poly - q}, {Q}, z];

generate the semidefinite constraints `spd` in the variables `vars`
which are feasible if and only if the `NCPoly` `poly` is SOS.

See also:
[NCPolySOS](#NCPolySOS).
