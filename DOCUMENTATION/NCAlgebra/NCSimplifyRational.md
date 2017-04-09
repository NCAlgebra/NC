## NCSimplifyRational {#PackageNCSimplifyRational}

**NCSimplifyRational** is a package with function that simplifies noncommutative expressions and certain functions of their inverses.

`NCSimplifyRational` simplifies rational noncommutative expressions by repeatedly applying a set of reduction rules to the expression. `NCSimplifyRationalSinglePass` does only a single pass.

Rational expressions of the form

    inv[A + terms]

are first normalized to

   inv[1 + terms/A]/A

using `NCNormalizeInverse`. Here `A` is commutative.

For each `inv` found in expression, a custom set of rules is constructed based on its associated NC Groebner basis.

For example, if

    inv[mon1 + ... + K lead]

where `lead` is the leading monomial with the highest degree then the following rules are generated:

| Original | Transformed |
| --- | --- |
| inv[mon1 + ... + K lead] lead | (1 - inv[mon1 + ... + K lead] (mon1 + ...))/K |
| lead inv[mon1 + ... + K lead] | (1 - (mon1 + ...) inv[mon1 + ... + K lead])/K |

Finally the following pattern based rules are applied:

| Original | Transformed |
| --- | --- |
| inv[a] inv[1 + K a b]      | inv[a] - K b inv[1 + K a b] |
| inv[a] inv[1 + K a]        | inv[a] - K inv[1 + K a]     |
| inv[1 + K a b] inv[b]      | inv[b] - K inv[1 + K a b] a |
| inv[1 + K a] inv[a]        | inv[a] - K inv[1 + K a]     |
| inv[1 + K a b] a           | a inv[1 + K b a]            |
| inv[A inv[a] + B b] inv[a] | (1/A) inv[1 + (B/A) a b]    | 
| inv[a] inv[A inv[a] + K b] | (1/A) inv[1 + (B/A) b a]    | 

`NCPreSimplifyRational` only applies pattern based rules from the second table above. In addition, the following two rules are applied:

| Original | Transformed |
| --- | --- |
| inv[1 + K a b] a b | (1 - inv[1 + K a b])/K |
| inv[1 + K a] a     | (1 - inv[1 + K a])/K   |
| a b inv[1 + K a b] | (1 - inv[1 + K a b])/K |
| a inv[1 + K a]     | (1 - inv[1 + K a])/K   |

Rules in `NCSimplifyRational` and `NCPreSimplifyRational` are applied repeatedly.

Rules in `NCSimplifyRationalSinglePass` and `NCPreSimplifyRationalSinglePass` are applied only once.

The particular ordering of monomials used by `NCSimplifyRational` is the one implied by the `NCPolynomial` format. This ordering is a variant of the deg-lex ordering where the lexical ordering is Mathematica's natural ordering.

`NCSimplifyRational` is limited by its rule list and what rules are
best is unknown and might depend on additional assumptions. For example:

    NCSimplifyRational[y ** inv[y + x ** y]]

returns `y ** inv[y + x ** y]` not `inv[1 + x]`, which is what one
would expect if `y` were to be invertible. Indeed,
     
    NCSimplifyRational[inv[y] ** inv[inv[y] + x ** inv[y]]]

does return `inv[1 + x]`, since in this case the appearing of `inv[y]`
trigger rules that implicitely assume `y` is invertible.

Members are:

* [NCNormalizeInverse](#NCNormalizeInverse)
* [NCSimplifyRational](#NCSimplifyRational)
* [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass)
* [NCPreSimplifyRational](#NCPreSimplifyRational)
* [NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass)

Aliases:

* [NCSR](#NCSR) for [NCSimplifyRational](#NCSimplifyRational)


### NCNormalizeInverse {#NCNormalizeInverse}

`NCNormalizeInverse[expr]` transforms all rational NC expressions of the form `inv[K + b]` into `inv[1 + (1/K) b]/K` if `A` is commutative.

See also:
[NCSimplifyRational](#NCSimplifyRational), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

### NCSimplifyRational {#NCSimplifyRational}

`NCSimplifyRational[expr]` repeatedly applies `NCSimplifyRationalSinglePass` in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

### NCSR {#NCSR}

`NCSR` is an alias for `NCSimplifyRational`.

See also:
[NCSimplifyRational](#NCSimplifyRational).

### NCSimplifyRationalSinglePass {#NCSimplifyRationalSinglePass}

`NCSimplifyRationalSinglePass[expr]` applies a series of custom rules only once in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCSimplifyRational](#NCSimplifyRational).

### NCPreSimplifyRational {#NCPreSimplifyRational}

`NCPreSimplifyRational[expr]` repeatedly applies `NCPreSimplifyRationalSinglePass` in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass).

### NCPreSimplifyRationalSinglePass {#NCPreSimplifyRationalSinglePass}

`NCPreSimplifyRationalSinglePass[expr]` applies a series of custom rules only once in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCPreSimplifyRational](#NCPreSimplifyRational).
