## NCGBX {#PackageNCGBX}

Members are:

* [SetMonomialOrder](#SetMonomialOrder)
* [SetKnowns](#SetKnowns)
* [SetUnknowns](#SetUnknowns)
* [ClearMonomialOrder](#ClearMonomialOrder)
* [GetMonomialOrder](#GetMonomialOrder)
* [PrintMonomialOrder](#PrintMonomialOrder)
* [NCMakeGB](#NCMakeGB)
* [NCProcess](#NCProcess)
* [NCGBSimplifyRational](#NCGBSimplifyRational)
* [NCReduce](#NCReduce)

### SetMonomialOrder {#SetMonomialOrder}

`SetMonomialOrder[var1, var2, ...]` sets the current monomial order.

For example

	SetMonomialOrder[a,b,c]

sets the lex order $a \ll b \ll c$. 

If one uses a list of variables rather than a single variable as one
of the arguments, then multigraded lex order is used. For example

	SetMonomialOrder[{a,b,c}]

sets the graded lex order $a < b < c$. 

Another example:

	SetMonomialOrder[{{a, b}, {c}}]

or

	SetMonomialOrder[{a, b}, c]

set the multigraded lex order $a < b \ll c$.

Finally 

	SetMonomialOrder[{a,b}, {c}, {d}]

or

	SetMonomialOrder[{a,b}, c, d]

is equivalent to the following two commands

	SetKnowns[a,b] 
    SetUnknowns[c,d]

There is also an older syntax which is still supported:

	SetMonomialOrder[{a, b, c}, n]
	
sets the order of monomials to be $a < b < c$ and assigns them grading
level `n`. 

	SetMonomialOrder[{a, b, c}, 1]

is equivalent to `SetMonomialOrder[{a, b, c}]`. When using this older
syntax the user is responsible for calling
[ClearMonomialOrder](#ClearMonomialOrder) to make sure that the
current order is empty before starting.
		
See also:
[ClearMonomialOrder](#ClearMonomialOrder),
[GetMonomialOrder](#GetMonomialOrder),
[PrintMonomialOrder](#PrintMonomialOrder),
[SetKnowns](#SetKnowns),
[SetUnknowns](#SetUnknowns).

### SetKnowns {#SetKnowns}

`SetKnowns[var1, var2, ...]` records the variables `var1`, `var2`,
 ... to be corresponding to known quantities.
 
`SetUnknowns` and `Setknowns` prescribe a monomial order with the
 knowns at the the bottom and the unknowns at the top.

For example

	SetKnowns[a,b] 
    SetUnknowns[c,d]
	
is equivalent to 

	SetMonomialOrder[{a,b}, {c}, {d}]
	
which corresponds to the order $a < b \ll c \ll d$ and

	SetKnowns[a,b] 
    SetUnknowns[{c,d}]
	
is equivalent to 

	SetMonomialOrder[{a,b}, {c, d}]
	
which corresponds to the order $a < b \ll c < d$.

Note that `SetKnowns` flattens grading so that 

	SetKnowns[a,b] 

and

	SetKnowns[{a},{b}] 

result both in the order $a < b$. 

Successive calls to `SetUnknowns` and `SetKnowns` overwrite the
previous knowns and unknowns. For example

	SetKnowns[a,b] 
    SetUnknowns[c,d]
    SetKnowns[c,d]
    SetUnknowns[a,b]

results in an ordering $c < d \ll a \ll b$.

See also:
[SetUnknowns](#SetUnknowns),
[SetMonomialOrder](#SetMonomialOrder).

### SetUnknowns {#SetUnknowns}

`SetUnknowns[var1, var2, ...]` records the variables `var1`, `var2`,
...  to be corresponding to unknown quantities.  

`SetUnknowns` and `SetKnowns` prescribe a monomial order with the
 knowns at the the bottom and the unknowns at the top.

For example

	SetKnowns[a,b] 
    SetUnknowns[c,d]
	
is equivalent to 

	SetMonomialOrder[{a,b}, {c}, {d}]
	
which corresponds to the order $a < b \ll c \ll d$ and

	SetKnowns[a,b] 
    SetUnknowns[{c,d}]
	
is equivalent to 

	SetMonomialOrder[{a,b}, {c, d}]
	
which corresponds to the order $a < b \ll c < d$.

Note that `SetKnowns` flattens grading so that 

	SetKnowns[a,b] 

and

	SetKnowns[{a},{b}] 

result both in the order $a < b$. 

Successive calls to `SetUnknowns` and `SetKnowns` overwrite the
previous knowns and unknowns. For example

	SetKnowns[a,b] 
    SetUnknowns[c,d]
    SetKnowns[c,d]
    SetUnknowns[a,b]

results in an ordering $c < d \ll a \ll b$.

See also:
[SetKnowns](#SetKnowns),
[SetMonomialOrder](#SetMonomialOrder).

### ClearMonomialOrder {#ClearMonomialOrder}

`ClearMonomialOrder[]` clear the current monomial ordering.

It is only necessary to use `ClearMonomialOrder` if using the indexed
version of `SetMonomialOrder`.

See also:
[SetKnowns](#SetKnowns),
[SetUnknowns](#SetUnknowns),
[SetMonomialOrder](#SetMonomialOrder),
[ClearMonomialOrder](#ClearMonomialOrder),
[PrintMonomialOrder](#PrintMonomialOrder).

### GetMonomialOrder {#GetMonomialOrder}

`GetMonomialOrder[]` returns the current monomial ordering in the form
of a list.

For example

	SetMonomialOrder[{a,b}, {c}, {d}]
	order = GetMonomialOrder[]
	
returns

	order = {{a,b},{c},{d}}
	
See also:
[SetKnowns](#SetKnowns),
[SetUnknowns](#SetUnknowns),
[SetMonomialOrder](#SetMonomialOrder),
[ClearMonomialOrder](#ClearMonomialOrder),
[PrintMonomialOrder](#PrintMonomialOrder).

### PrintMonomialOrder {#PrintMonomialOrder}

`PrintMonomialOrder[]` prints the current monomial ordering.

For example

	SetMonomialOrder[{a,b}, {c}, {d}]
	PrintMonomialOrder[]
	
print $a < b \ll c \ll d$.

See also:
[SetKnowns](#SetKnowns),
[SetUnknowns](#SetUnknowns),
[SetMonomialOrder](#SetMonomialOrder),
[ClearMonomialOrder](#ClearMonomialOrder),
[PrintMonomialOrder](#PrintMonomialOrder).


### NCMakeGB {#NCMakeGB}

`NCMakeGB[{poly1, poly2, ...}, k]` attempts to produces a nc Gröbner
Basis (GB) associated with the list of nc polynomials `{poly1, poly2,
...}`. The GB algorithm proceeds through *at most* `k` iterations
until a Gröbner basis is found for the given list of polynomials with
respect to the order imposed by [SetMonomialOrder](#SetMonomialOrder).

If `NCMakeGB` terminates before finding a GB the message
`NCMakeGB::Interrupted` is issued.

The output of `NCMakeGB` is a list of rules with left side of the rule
being the *leading* monomial of the polynomials in the GB.

For example:

	SetMonomialOrder[x];
	gb = NCMakeGB[{x^2 - 1, x^3 - 1}, 20]

returns

	gb = {x -> 1}
	
that corresponds to the polynomial $x - 1$, which is the nc Gröbner
basis for the ideal generated by $x^2-1$ and $x^3-1$.

`NCMakeGB[{poly1, poly2, ...}, k, options]` uses `options`.

The following `options` can be given:

- `SimplifyObstructions` (`True`): control whether obstructions are
  simplified before being added to the list of active obstructions;
- `SortObstructions` (`False`): control whether obstructions are
  sorted before being processed;
- `SortBasis` (`False`): control whether initial basis is sorted
  before initiating algorithm;
- `VerboseLevel` (`1`): control level of verbosity from `0` (no
  messages) to `5` (very verbose);
- `PrintBasis` (`False`): if `True` prints current basis at each major
  iteration;
- `PrintObstructions` (`False`): if `True` prints current list of
  obstructions at each major iteration;
- `PrintSPolynomials` (`False`): if `True` prints every S-polynomial
  formed at each minor iteration.
- `ReturnRules` (`True`): if `True` rules representing relations in which the left-hand side is the leading monomial are returned instead of polynomials. Use `False` for backward compatibility. Can be set globally as `SetOptions[NCMakeGB, ReturnRules -> False]`.

`NCMakeGB` makes use of the algorithm `NCPolyGroebner` implemented in
[NCPolyGroebner](#NCPolyGroebner).

See also:
[ClearMonomialOrder](#ClearMonomialOrder),
[GetMonomialOrder](#GetMonomialOrder),
[PrintMonomialOrder](#PrintMonomialOrder),
[SetKnowns](#SetKnowns),
[SetUnknowns](#SetUnknowns),
[NCPolyGroebner](#NCPolyGroebner).

### NCProcess {#NCProcess}

`NCProcess[{poly1, poly2, ...}, k]` finds a new generating set for the
ideal generated by `{poly1, poly2, ...}` using [NCMakeGB](#NCMakeGB)
then produces an summary report on the findings.

Not all features of `NCProcess` in the old `NCGB` C++ version are
supported yet.

See also:
[NCMakeGB](#NCMakeGB).

### NCGBSimplifyRational {#NCGBSimplifyRational}

`NCGBSimplifyRational[expr]` creates a set of relations for each
rational expression and sub-expression found in `expr` which are used
to produce simplification rules using [NCMakeGB](#NCMakeGB) then
replaced using [NCReduce](#NCReduce).

For example:

	expr = x ** inv[1 - x] - inv[1 - x] ** x
	NCGBSimplifyRational[expr]

or

	expr = inv[1 - x - y ** inv[1 - x] ** y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
	NCGBSimplifyRational[expr]

both result in `0`.

See also:
[NCMakeGB](#NCMakeGB),
[NCReduce](#NCReduce).

### NCReduce {#NCReduce}

`NCReduce[polys, rules]` reduces the list of polynomials `polys` with
respect to the list of polyomials `rules`. The substitutions implied
by `rules` are applied repeatedly to the polynomials in the `polys`
until no further reduction occurs.

`NCReduce[polys]` reduces each polynomial in the list of polynomials
`polys` with respect to the remaining elements of the list of
polyomials `polys` until no further reduction occurs.

By default, `NCReduce` only reduces the leading monomial in the
current order. Use the optional boolean flag `complete` to completely
reduce all monomials. For example, `NCReduce[polys, rules, True]` and
`NCReduce[polys, True]`.

See also:
[NCMakeGB](#NCMakeGB),
[NCGBSimplifyRational](#NCGBSimplifyRational).


