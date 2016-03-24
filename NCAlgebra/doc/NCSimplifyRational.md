# NCSimplifyRational {#PackageNCSimplifyRational}

**NCSimplifyRational** simplifies noncommutative expressions and certain functions of their inverses.

NCSimplifyRational simplifies rational noncommutative expressions by applying a set of reduction rules to the expression.

For each `inv` found in expression, a custom set of rules is constructed based on its associated nc Groebner basis.

For example, if

    inv[mon1 + ... + K lead]

where `lead` is the monomial with the highest degree then the following rules are generated:

| Original | Transformed |
| --- | --- |
| inv[mon1 + ... + lead] lead | [1 - inv[mon1 + ... + lead] (mon1 + ...)]/K |
| lead inv[mon1 + ... + lead] | [1 - (mon1 + ...) inv[mon1 + ... + lead]]/K |

Finally the following rules are applied:

| Original | Transformed |
| --- | --- |
| inv[a] inv[1 + K a b]  | inv[a] - K b inv[1 + K a b] |
| inv[a] inv[1 + K a]    | inv[a] - K inv[1 + K a]     |
| inv[1 + K a b] inv[b]  | inv[b] - K inv[1 + K a b] a |
| inv[1 + K a] inv[a]    | inv[a] - K inv[1 + K a]     |
| inv[1 + K a b] a       | a inv[1 + K b a]      |

Members are:

* [NCNormalizeInverse](#NCNormalizeInverse)
* [NCSimplifyRational](#NCSimplifyRational)
* [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass)

## NCNormalizeInverse {#NCNormalizeInverse}

`NCNormalizeInverse[expr]` transforms all rational nc expressions of the form `inv[A + b]` into `inv[1 + b/A]/A` if `A` is commutative.

See also:
[NCSimplifyRational](#NCSimplifyRational), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

## NCSimplifyRational {#NCSimplifyRational}

`NCSimplifyRational[expr]` repeatedly applies `NCSimplifyRationalSinglePass` in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

## NCSimplifyRationalSinglePass {#NCSimplifyRationalSinglePass}

`NCSimplifyRational[expr]` applies a series of rules in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCSimplifyRational](#NCSimplifyRational).
