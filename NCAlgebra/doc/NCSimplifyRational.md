# NCSimplifyRational {#PackageNCSimplifyRational}

**NCSimplifyRational** simplifies noncommutative expressions and certain functions of their inverses.

NCSimplifyRational simplifies rational noncommutative expressions in `a` and `b` by repeatedly applying the following set of reduction rules to the expression until it stops changing.

The following rules are applied in sequence:

| Rule | Original | Transformed |
| --- | --- | --- |
|1| inv[a] inv[1 + K a b]  | inv[a] - K b inv[1 + K a b] |
|1| inv[a] inv[1 + K a]    | inv[a] - K inv[1 + K a]     |
|2| inv[1 + K a b] inv[b]  | inv[b] - K inv[1 + K a b] a |
|2| inv[1 + K a] inv[a]    | inv[a] - K inv[1 + K a]     |
|3| inv[c + K a b] a b     | [1 - inv[c + K a b] c]/K |
|3| inv[c + K a] a         | [1 - inv[c + K a] c]/K   |
|4| a b inv[c + K a b]     | [1 - c inv[c + K a b]]/K |
|4| a inv[c + K a]         | [1 - c inv[c + K a]]/K   |
|5| inv[1 + K a b] inv[a]  | inv[a] inv[1 + K b a] |
|5| inv[1 + K a] inv[a]    | inv[a] inv[1 + K a]   |
|6| inv[1 + K a b] a       | a inv[1 + K b a]      |
|6| inv[1 + K a] a         | a inv[1 + K a]        |

Members are:

* [NCNormalizeInverse](#NCNormalizeInverse)
* [NCSimplifyRational](#NCSimplifyRational)
* [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass)

## NCNormalizeInverse {#NCNormalizeInverse}

`NCNormalizeInverse[expr]` transforms all rational nc expressions of the form `inv[A + b]` into `inv[1 + b/A]/A` if `A` is commutative.

See also:
[NCSimplifyRational](#NCSimplifyRational), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

## NCSimplifyRational {#NCSimplifyRational}

`NCSimplifyRational[expr]` repeatedly applies a series of rules in an attempt to simplify the rational nc expression `expr` until it stops changing.

See also:
[NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass),
[NCNormalizeInverse](#NCNormalizeInverse).

## NCSimplifyRationalSinglePass {#NCSimplifyRationalSinglePass}

`NCSimplifyRationalSinglePass[expr]` applies a series of rules in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).
