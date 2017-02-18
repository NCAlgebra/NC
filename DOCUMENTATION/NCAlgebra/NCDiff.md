## NCDiff {#PackageNCDiff}

**NCDiff** is a package containing several functions that are used in noncommutative differention of functions and polynomials.

Members are:

* [NCDirectionalD](#NCDirectionalD)
* [NCGrad](#NCGrad)
* [NCHessian](#NCHessian)
* [NCIntegrate](#NCIntegrate)

Members being deprecated:

* [DirectionalD](#DirectionalD)

### NCDirectionalD {#NCDirectionalD}

`NCDirectionalD[expr, {var1, h1}, ...]` takes the directional derivative of expression `expr` with respect to variables `var1`, `var2`, ... successively in the directions `h1`, `h2`, ....

For example, if:

    expr = a**inv[1+x]**b + x**c**x

then

    NCDirectionalD[expr, {x,h}]

returns

    h**c**x + x**c**h - a**inv[1+x]**h**inv[1+x]**b

In the case of more than one variables
`NCDirectionalD[expr, {x,h}, {y,k}]` takes the directional derivative
of `expr` with respect to `x` in the direction `h` and with respect to
`y` in the direction `k`. For example, if:

    expr = x**q**x - y**x

then

    NCDirectionalD[expr, {x,h}, {y,k}]

returns

    h**q**x + x**q*h - y**h - k**x

See also:
[NCGrad](#NCGrad),
[NCHessian](#NCHessian).

### NCGrad {#NCGrad}

`NCGrad[expr, var1, ...]` gives the nc gradient of the expression `expr` with respect to variables `var1`, `var2`, .... If there is more than one variable then `NCGrad` returns the gradient in a list.

The transpose of the gradient of the nc expression `expr` is the derivative with respect to the direction `h` of the trace of the directional derivative of `expr` in the direction `h`.

For example, if:

    expr = x**a**x**b + x**c**x**d

then its directional derivative in the direction `h` is

    NCDirectionalD[expr, {x,h}]

which returns

    h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d

and

    NCGrad[expr, x]

returns the nc gradient

    a**x**b + b**x**a + c**x**d + d**x**c

For example, if:

    expr = x**a**x**b + x**c**y**d

is a function on variables `x` and `y` then

    NCGrad[expr, x, y]

returns the nc gradient list

    {a**x**b + b**x**a + c**y**d, d**x**c}


**IMPORTANT**: The expression returned by NCGrad is the transpose or the adjoint of the standard gradient. This is done so that no assumption on the symbols are needed. The calculated expression is correct even if symbols are self-adjoint or symmetric.

See also:
[NCDirectionalD](#NCDirectionalD).

### NCHessian {#NCHessian}

`NCHessian[expr, {var1, h1}, ...]` takes the second directional derivative of nc expression `expr` with respect to variables `var1`, `var2`, ... successively in the directions `h1`, `h2`, ....

For example, if:

    expr = y**inv[x]**y + x**a**x

then

    NCHessian[expr, {x,h}, {y,s}]

returns

    2 h**a**h + 2 s**inv[x]**s - 2 s**inv[x]**h**inv[x]**y -
    2 y**inv[x]**h**inv[x]**s + 2 y**inv[x]**h**inv[x]**h**inv[x]**y

In the case of more than one variables `NCHessian[expr, {x,h}, {y,k}]`
takes the second directional derivative of `expr` with respect to `x`
in the direction `h` and with respect to `y` in the direction `k`.

See also:
[NCDiretionalD](#NCDirectionalD), [NCGrad](#NCGrad).

### DirectionalD {#DirectionalD}

`DirectionalD[expr,var,h]` takes the directional derivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

**DEPRECATION NOTICE**: This syntax is limited to one variable and is being deprecated in favor of the more general syntax in [NCDirectionalD](#NCDirectionalD).

See also:
[NCDirectionalD](#DirectionalD).

### NCIntegrate {#NCIntegrate}

`NCIntegrate[expr,{var1,h1},...]` attempts to calculate the nc antiderivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

For example:

    NCIntegrate[x**h+h**x, {x,h}]

returns

    x**x

See also:
[NCDirectionalD](#DirectionalD).
