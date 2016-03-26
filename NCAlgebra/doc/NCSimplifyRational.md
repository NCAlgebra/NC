# NCSimplifyRational {#PackageNCSimplifyRational}

**NCSimplifyRational** is a package with function that simplifies noncommutative expressions and certain functions of their inverses.

`NCSimplifyRational` simplifies rational noncommutative expressions by repeatedly applying a set of reduction rules to the expression. `NCSimplifyRationalSinglePass` does only a single pass.

For each `inv` found in expression, a custom set of rules is constructed based on its associated nc Groebner basis.

For example, if

    inv[mon1 + ... + K lead]

where `lead` is the monomial with the highest degree then the following rules are generated:

| Original | Transformed |
| --- | --- |
| inv[mon1 + ... + lead] lead | (1 - inv[mon1 + ... + lead] (mon1 + ...))/K |
| lead inv[mon1 + ... + lead] | (1 - (mon1 + ...) inv[mon1 + ... + lead])/K |

Finally the following pattern based rules are applied:

| Original | Transformed |
| --- | --- |
| inv[a] inv[1 + K a b]  | inv[a] - K b inv[1 + K a b] |
| inv[a] inv[1 + K a]    | inv[a] - K inv[1 + K a]     |
| inv[1 + K a b] inv[b]  | inv[b] - K inv[1 + K a b] a |
| inv[1 + K a] inv[a]    | inv[a] - K inv[1 + K a]     |
| inv[1 + K a b] a       | a inv[1 + K b a]      |

`NCPreSimplifyRational` only applies pattern based rules. In addition to the above rules the following two rules are applied repeatdly:

| Original | Transformed |
| --- | --- |
| inv[1 + K a b] a b | (1 - inv[1 + K a b])/K |
| inv[1 + K a] a     | (1 - inv[1 + K a])/K   |
| a b inv[1 + K a b] | (1 - inv[1 + K a b])/K |
| a inv[1 + K a]     | (1 - inv[1 + K a])/K   |

`NCPreSimplifyRationalSinglePass` does only a single pass.

Members are:

* [NCNormalizeInverse](#NCNormalizeInverse)
* [NCSimplifyRational](#NCSimplifyRational)
* [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass)
* [NCPreSimplifyRational](#NCPreSimplifyRational)
* [NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass)

## NCNormalizeInverse {#NCNormalizeInverse}

`NCNormalizeInverse[expr]` transforms all rational nc expressions of the form `inv[K + b]` into `inv[1 + (1/K) b]/K` if `A` is commutative.

See also:
[NCSimplifyRational](#NCSimplifyRational), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

## NCSimplifyRational {#NCSimplifyRational}

`NCSimplifyRational[expr]` repeatedly applies `NCSimplifyRationalSinglePass` in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

## NCSimplifyRationalSinglePass {#NCSimplifyRationalSinglePass}

`NCSimplifyRationalSinglePass[expr]` applies a series of custom rules in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCSimplifyRational](#NCSimplifyRational).

## NCPreSimplifyRational {#NCPreSimplifyRational}

`NCPreSimplifyRational[expr]` repeatedly applies `NCPreSimplifyRationalSinglePass` in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass).

## NCPreSimplifyRationalSinglePass {#NCPreSimplifyRationalSinglePass}

`NCPreSimplifyRationalSinglePass[expr]` applies a series of custom rules in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse),
[NCPreSimplifyRational](#NCPreSimplifyRational).
