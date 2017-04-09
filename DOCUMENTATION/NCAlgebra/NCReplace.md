## NCReplace {#PackageNCReplace}

**NCReplace** is a package containing several functions that are useful in making replacements in noncommutative expressions. It offers replacements to Mathematica's `Replace`, `ReplaceAll`, `ReplaceRepeated`, and `ReplaceList` functions.

Commands in this package replace the old `Substitute` and `Transform` family of command which are been deprecated. The new commands are much more reliable and work faster than the old commands. From the beginning, substitution was always problematic and certain patterns would be missed. We reassure that the call expression that are returned are mathematically correct but some opportunities for substitution may have been missed.

Members are:

* [NCReplace](#NCReplace)
* [NCReplaceAll](#NCReplaceAll)
* [NCReplaceList](#NCReplaceList)
* [NCReplaceRepeated](#NCReplaceRepeated)
* [NCMakeRuleSymmetric](#NCMakeRuleSymmetric)
* [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint)
* [NCReplaceSymmetric](#NCReplaceSymmetric)
* [NCReplaceAllSymmetric](#NCReplaceAllSymmetric)
* [NCReplaceListSymmetric](#NCReplaceListSymmetric)
* [NCReplaceRepeatedSymmetric](#NCReplaceRepeatedSymmetric)
* [NCReplaceSelfAdjoint](#NCReplaceSelfAdjoint)
* [NCReplaceAllSelfAdjoint](#NCReplaceAllSelfAdjoint)
* [NCReplaceListSelfAdjoint](#NCReplaceListSelfAdjoint)
* [NCReplaceRepeatedSelfAdjoint](#NCReplaceRepeatedSelfAdjoint)
* [NCMatrixReplaceAll](#NCMatrixReplaceAll)
* [NCMatrixReplaceRepeated](#NCMatrixReplaceRepeated)

Aliases:

* [NCR](#NCR) for [NCReplace](#NCReplace)
* [NCRA](#NCRA) for [NCReplaceAll](#NCReplaceAll)
* [NCRL](#NCRL) for [NCReplaceList](#NCReplaceList)
* [NCRR](#NCRR) for [NCReplaceRepeated](#NCReplaceRepeated)
* [NCRSym](#NCRSym) for [NCReplaceSymmetric](#NCReplaceSymmetric)
* [NCRASym](#NCRASym) for [NCReplaceAllSymmetric](#NCReplaceAllSymmetric)
* [NCRLSym](#NCRLSym) for [NCReplaceListSymmetric](#NCReplaceListSymmetric)
* [NCRRSym](#NCRRSym) for [NCReplaceRepeatedSymmetric](#NCReplaceRepeatedSymmetric)
* [NCRSA](#NCRSA) for [NCReplaceSelfAdjoint](#NCReplaceSelfAdjoint)
* [NCRASA](#NCRASA) for [NCReplaceAllSelfAdjoint](#NCReplaceAllSelfAdjoint)
* [NCRLSA](#NCRLSA) for [NCReplaceListSelfAdjoint](#NCReplaceListSelfAdjoint)
* [NCRRSA](#NCRRSA) for [NCReplaceRepeatedSelfAdjoint](#NCReplaceRepeatedSelfAdjoint)

### NCReplace {#NCReplace}

`NCReplace[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform the entire nc expression `expr`.

`NCReplace[expr,rules,levelspec]`	 applies `rules` to parts of `expr` specified by `levelspec`.

See also:
[NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

### NCReplaceAll {#NCReplaceAll}

`NCReplaceAll[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform each part of the nc expression `expr`.

See also:
[NCReplace](#NCReplace), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

### NCReplaceList {#NCReplaceList}

`NCReplace[expr,rules]` attempts to transform the entire nc expression `expr` by applying a rule or list of rules `rules` in all possible ways, and returns a list of the results obtained.

`ReplaceList[expr,rules,n]` gives a list of at most `n` results.

See also:
[NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceRepeated](#NCReplaceRepeated).

### NCReplaceRepeated {#NCReplaceRepeated}

`NCReplaceRepeated[expr,rules]` repeatedly performs replacements using rule or list of rules `rules` until `expr` no longer changes.

See also:
[NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList).

### NCR {#NCR}

`NCR` is an alias for `NCReplace`.

See also:
[NCReplace](#NCReplace).

### NCRA {#NCRA}

`NCRA` is an alias for `NCReplaceAll`.

See also:
[NCReplaceAll](#NCReplaceAll).

### NCRR {#NCRR}

`NCRR` is an alias for `NCReplaceRepeated`.

See also:
[NCReplaceRepeated](#NCReplaceRepeated).

### NCRL {#NCRL}

`NCRL` is an alias for `NCReplaceList`.

See also:
[NCReplaceList](#NCReplaceList).

### NCMakeRuleSymmetric {#NCMakeRuleSymmetric}

`NCMakeRuleSymmetric[rules]` add rules to transform the transpose of the left-hand side of `rules` into the transpose of the right-hand side of `rules`.

See also:
[NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint), [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

### NCMakeRuleSelfAdjoint {#NCMakeRuleSelfAdjoint}

`NCMakeRuleSelfAdjoint[rules]` add rules to transform the adjoint of the left-hand side of `rules` into the adjoint of the right-hand side of `rules`.

See also:
[NCMakeRuleSymmetric](#NCMakeRuleSymmetric), [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

### NCReplaceSymmetric {#NCReplaceSymmetric}

`NCReplaceSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to `rules` before calling `NCReplace`.

See also:
[NCReplace](#NCReplace), [NCMakeRuleSymmetric](#NCMakeRuleSymmetric).

### NCReplaceAllSymmetric {#NCReplaceAllSymmetric}

`NCReplaceAllSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to `rules` before calling `NCReplaceAll`.

See also:
[NCReplaceAll](#NCReplaceAll), [NCMakeRuleSymmetric](#NCMakeRuleSymmetric).

### NCReplaceRepeatedSymmetric {#NCReplaceRepeatedSymmetric}

`NCReplaceRepeatedSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to `rules` before calling `NCReplaceRepeated`.

See also:
[NCReplaceRepeated](#NCReplaceRepeated), [NCMakeRuleSymmetric](#NCMakeRuleSymmetric).

### NCReplaceListSymmetric {#NCReplaceListSymmetric}

`NCReplaceListSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to `rules` before calling `NCReplaceList`.

See also:
[NCReplaceList](#NCReplaceList), [NCMakeRuleSymmetric](#NCMakeRuleSymmetric).

### NCRSym {#NCRSym}

`NCRSym` is an alias for `NCReplaceSymmetric`.

See also:
[NCReplaceSymmetric](#NCReplaceSymmetric).

### NCRASym {#NCRASym}

`NCRASym` is an alias for `NCReplaceAllSymmetric`.

See also:
[NCReplaceAllSymmetric](#NCReplaceAllSymmetric).

### NCRRSym {#NCRRSym}

`NCRRSym` is an alias for `NCReplaceRepeatedSymmetric`.

See also:
[NCReplaceRepeatedSymmetric](#NCReplaceRepeatedSymmetric).

### NCRLSym {#NCRLSym}

`NCRLSym` is an alias for `NCReplaceListSymmetric`.

See also:
[NCReplaceListSymmetric](#NCReplaceListSymmetric).

### NCReplaceSelfAdjoint {#NCReplaceSelfAdjoint}

`NCReplaceSelfAdjoint[expr, rules]` applies `NCMakeRuleSelfAdjoint` to `rules` before calling `NCReplace`.

See also:
[NCReplace](#NCReplace), [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint).

### NCReplaceAllSelfAdjoint {#NCReplaceAllSelfAdjoint}

`NCReplaceAllSelfAdjoint[expr, rules]` applies `NCMakeRuleSelfAdjoint` to `rules` before calling `NCReplaceAll`.

See also:
[NCReplaceAll](#NCReplaceAll), [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint).

### NCReplaceRepeatedSelfAdjoint {#NCReplaceRepeatedSelfAdjoint}

`NCReplaceRepeatedSelfAdjoint[expr, rules]` applies `NCMakeRuleSelfAdjoint` to `rules` before calling `NCReplaceRepeated`.

See also:
[NCReplaceRepeated](#NCReplaceRepeated), [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint).

### NCReplaceListSelfAdjoint {#NCReplaceListSelfAdjoint}

`NCReplaceListSelfAdjoint[expr, rules]` applies `NCMakeRuleSelfAdjoint` to `rules` before calling `NCReplaceList`.

See also:
[NCReplaceList](#NCReplaceList), [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint).

### NCRSA {#NCRSA}

`NCRSA` is an alias for `NCReplaceSymmetric`.

See also:
[NCReplaceSymmetric](#NCReplaceSymmetric).

### NCRASA {#NCRASA}

`NCRASA` is an alias for `NCReplaceAllSymmetric`.

See also:
[NCReplaceAllSymmetric](#NCReplaceAllSymmetric).

### NCRRSA {#NCRRSA}

`NCRRSA` is an alias for `NCReplaceRepeatedSymmetric`.

See also:
[NCReplaceRepeatedSymmetric](#NCReplaceRepeatedSymmetric).

### NCRLSA {#NCRLSA}

`NCRLSA` is an alias for `NCReplaceListSymmetric`.

See also:
[NCReplaceListSymmetric](#NCReplaceListSymmetric).

### NCMatrixReplaceAll {#NCMatrixReplaceAll}

`NCMatrixReplaceAll[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform each part of the nc expression `expr`.

`NCMatrixReplaceAll` works as `NCReplaceAll` but takes extra steps to
make sure substitutions work with matrices.

See also:
[NCReplaceAll](#NCReplaceAll), [NCMatrixReplaceRepeated](#NCMatrixReplaceRepeated).

### NCMatrixReplaceRepeated {#NCMatrixReplaceRepeated}

`NCMatrixReplaceRepeated[expr,rules]` repeatedly performs replacements using rule or list of rules `rules` until `expr` no longer changes.

`NCMatrixReplaceRepeated` works as `NCReplaceRepeated` but takes extra steps to
make sure substitutions work with matrices.

See also:
[NCReplaceRepeated](#NCReplaceRepeated), [NCMatrixReplaceAll](#NCMatrixReplaceAll).
