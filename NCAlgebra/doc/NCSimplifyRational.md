# NCSimplifyRational {#PackageNCSimplifyRational}

**NCSimplifyRational** simplifies noncommutative expressions and certain functions of their inverses.

NCSimplifyRational simplifies noncommutative expressions in `a` and `b`, `inv[a]`, `inv[b]`, and `inv[1 - a b]` by repeatedly applying a set of reduction rules to the polynomial until it stops changing.

The following rules are applied in sequence:

| Rule | Original                  | Transformed                             |
| ---  |---------------------------|-----------------------------------------|
|1     | inv[a] inv[1 + c + K a b] | inv[a] (1 + c) - K b inv[1 + c + K a b] |
|1     | inv[a] (1 + c) inv[1 + c + K a]   | inv[a] (1 + c) - K inv[1 + c + K a]     |
|2     | inv[1 + c + K a b] inv[b] | (1 + c) inv[b] - K inv[1 + c + K a b] a |
|2     | inv[1 + c + K a] inv[a]   | (1 + c) inv[a] - K inv[1 + c + K a]     |
|3     | inv[1 + c + K a b] a b    | [1 - inv[1 + c + K a b] (1 + c)]/K      |
|3     | inv[1 + c + K a] a        | [1 - inv[1 + c + K a] (1 + c)]/K        |
|4     | a b inv[1 + c + K a b]    | [1 - (1 + c) inv[1 + c + K a b]]/K      |
|4     | a inv[1 + c + K a]        | [1 -  (1 + c) inv[1 + c + K a]]/K       |
|5     | inv[1 + K a b] inv[a]     | inv[a] inv[1 + K b a]                   |
|5     | inv[1 + K a] inv[a]       | inv[a] inv[1 + K a]                     |
|6     | inv[1 + K a b] a          | a inv[1 + K b a]                        |
|6     | inv[1 + K a] a            | a inv[1 + K a]                          |

Members are:

* [NCNormalizeInverse](#NCNormalizeInverse)
* [NCSimplifyRational](#NCSimplifyRational)

## NCNormalizeInverse {#NCNormalizeInverse}


## NCSimplifyRational {#NCSimplifyRational}

`NCSimplifyRational[expr]` applies a series of rules in an attempt to simplify the rational nc expression `expr`.

See also:
[NCNormalizeInverse](#NCNormalizeInverse)
