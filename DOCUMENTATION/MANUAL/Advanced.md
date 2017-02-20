# More Advanced Commands {#MoreAdvancedCommands}

## Matrices

Starting at **Version 5** the operators `**` and `inv` apply also to
matrices. However, in order for `**` and `inv` to continue to work as
full fledged operators, the result of multiplications or inverses of
matrices is held unevaluated until the user calls
[`NCMatrixExpand`](#NCMatrixExpand).

For example, with

	m1 = {{a, b}, {c, d}}
	m2 = {{d, 2}, {e, 3}}
	
the call

	m1**m2

results in 

	{{a, b}, {c, d}}**{{d, 2}, {e, 3}}

Upon calling

	m1**m2 // NCMatrixExpand

evaluation takes place returning

	{{a**d + b**e, 2a + 3b}, {c**d + d**e, 2c + 3d}}
	
which is what would have been by calling `NCDot[m1,m2]`. Likewise

	inv[m1]

results in

	inv[{{a, b}, {c, d}}]

and

	inv[m1] // NCMatrixExpand
	
returns the evaluated result

	{{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
	 {-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}

A less trivial example is

	m3 = m1**inv[IdentityMatrix[2] + m1] - inv[IdentityMatrix[2] + m1]**m1

that returns 

	-inv[{{1 + a, b}, {c, 1 + d}}]**{{a, b}, {c, d}} + 
	    {{a, b}, {c, d}}**inv[{{1 + a, b}, {c, 1 + d}}]

Expanding

	NCMatrixExpand[m3]

results in

	{{b**inv[b - (1 + a)**inv[c]**(1 + d)] - inv[c]**(1 + (1 + d)**inv[b - 
	    (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c])**c - a**inv[c]**(1 + d)**inv[b - 
	    (1 + a)**inv[c]**(1 + d)] + inv[c]**(1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**a, 
	  a**inv[c]**(1 + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c]) - 
	    inv[c]**(1 + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c])**d - 
		b**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c] + inv[c]**(1 + d)**inv[b - 
		(1 + a)**inv[c]**(1 + d)]** b}, 
	 {d**inv[b - (1 + a)**inv[c]**(1 + d)] - (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)] - 
	    inv[b - (1 + a)**inv[c]**(1 + d)]**a + inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a), 
	  1 - inv[b - (1 + a)**inv[c]**(1 + d)]**b - d**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + 
	    a)**inv[c] + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c] + 
		inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c]**d}}
	
and finally 

	NCMatrixExpand[m3] // NCSimplifyRational	
	
returns

	{{0, 0}, {0, 0}}
	
as expected.

**WARNING:** Mathematica's choice of treating lists and matrix
indistinctively can cause much trouble when mixing `**` with `Plus`
(`+`) operator. For example, the expression

	m1**m2 + m2**m1
	
results in

	{{a, b}, {c, d}}**{{d, 2}, {e, 3}} + {{d, 2}, {e, 3}}**{{a, b}, {c, d}}
	
and 
	
	m1**m2 + m2**m1 // NCMatrixExpand
	
produces the expected result

	{{2 c + a ** d + b ** e + d ** a, 2 a + 3 b + 2 d + d ** b}, 
	 {3 c + c ** d + d ** e + e ** a, 2 c + 6 d + e ** b}}
 
However, because `**` is held unevaluated, the expression

	m1**m2 + m2 // NCMatrixExpand
	
returns the "wrong" result

	{{{{d + a ** d + b ** e, 2 a + 3 b + d}, {d + c ** d + d ** e, 2 c + 4 d}},
	 {{2 + a ** d + b ** e, 2 + 2 a + 3 b}, {2 + c ** d + d ** e, 2 + 2 c + 3 d}}}, 
	 {{{e + a ** d + b ** e, 2 a + 3 b + e}, {e + c ** d + d ** e, 2 c + 3 d + e}}, 
	 {{3 + a ** d + b ** e, 3 + 2 a + 3 b}, {3 + c ** d + d ** e, 3 + 2 c + 3 d}}}}

which is different than the "correct" result

	{{d + a**d + b**e, 2 + 2 a + 3 b}, 
	 {e + c**d + d**e, 3 + 2 c + 3 d}}

which is returned by either

	NCMatrixExpand[m1**m2] + m2
	
or

	NCDot[m1, m2] + m2

The reason for this behavior is that `m1**m2` is essentially treated
as a *scalar* (it does not have *head* `List`) and therefore gets
added entrywise to `m2` *before* `NCMatrixExpand` has a chance to
evaluate the `**` product. There are no easy fixes for this problem,
which affects not only `NCAlgebra` but any similar type of matrix
product evaluation in Mathematica. With `NCAlgebra`, a better option
is to use [`NCMatrixReplaceAll`](#NCMatrixReplaceAll) or
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated).

[`NCMatrixReplaceAll`](#NCMatrixReplaceAll) and
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated) are special
versions of [`NCReplaceAll`](#NCReplaceAll) and
[`NCReplaceRepeated`](#NCReplaceRepeated) that take extra steps to
preserve matrix consistency when replacing expressions with nc
matrices. For example

	NCMatrixReplaceAll[x ** y + y, {x -> m1, y -> m2}]
	
does produce the "correct" result

	{{d + a**d + b**e, 2 + 2 a + 3 b}, 
	 {e + c**d + d**e, 3 + 2 c + 3 d}}

[`NCMatrixReplaceAll`](#NCMatrixReplaceAll) and
[`NCMatrixReplaceRepeated`](#NCMatrixReplaceRepeated) also work with
block matrices. For example

	rule = {x -> m1, y -> m2, id -> IdentityMatrix[2], z -> {{id,x},{x,id}}}
	NCMatrixReplaceRepeated[inv[z], rule]

coincides with the result of

	NCInverse[ArrayFlatten[{{IdentityMatrix[2], m1}, {m1, IdentityMatrix[2]}}]]

## Polynomials with noncommutative coefficients

## Quadratics with noncommutative coefficients

## Linear functions with noncommutative coefficients

## Polynomials with commutative coefficients

## Algorithms
