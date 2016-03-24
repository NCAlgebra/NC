# NCReplace {#PackageNCReplace}

**NCReplace** is a package containing several functions that are useful in making replacements in noncommutative expressions. It offers replacements to Mathematica's `Replace`, `ReplaceAll`, `ReplaceRepeated`, and `ReplaceList` functions.

Members are:

* [NCReplace](#NCReplace)
* [NCReplaceAll](#NCReplaceAll)
* [NCReplaceList](#NCReplaceList)
* [NCReplaceRepeated](#NCReplaceRepeated)
* [NCMakeRuleSymmetric](#NCMakeRuleSymmetric)
* [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint)

## NCReplace {#NCReplace}

`NCReplace[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform the entire nc expression `expr`.

`NCReplace[expr,rules,levelspec]`	 applies `rules` to parts of `expr` specified by `levelspec`.

See also:
[NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

## NCReplaceAll {#NCReplaceAll}

`NCReplaceAll[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform each part of the nc expression `expr`.

See also:
[NCReplace](#NCReplace), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

## NCReplaceList {#NCReplaceList}

`NCReplace[expr,rules]` attempts to transform the entire nc expression `expr` by applying a rule or list of rules `rules` in all possible ways, and returns a list of the results obtained.

`ReplaceList[expr,rules,n]` gives a list of at most `n` results.

See also:
[NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceRepeated](#NCReplaceRepeated).

## NCReplaceRepeated {#NCReplaceRepeated}

`NCReplaceRepeated[expr,rules]` repeatedly performs replacements using rule or list of rules `rules` until `expr` no longer changes.

See also:
[NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList).

## NCMakeRuleSymmetric {#NCMakeRuleSymmetric}

`NCMakeRuleSymmetric[rules]` add rules to transform the transpose of the left-hand side of `rules` into the transpose of the right-hand side of `rules`.

See also:
[NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint), [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

## NCMakeRuleSelfAdjoint {#NCMakeRuleSelfAdjoint}

`NCMakeRuleSelfAdjoint[rules]` add rules to transform the adjoint of the left-hand side of `rules` into the adjoint of the right-hand side of `rules`.

See also:
[NCMakeRuleSymmetric](#NCMakeRuleSymmetric), [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).
