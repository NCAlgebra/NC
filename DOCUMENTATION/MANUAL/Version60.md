# Changes in Version 6.0 {#Version6_0}

## Version 6.0.3 {#Version6_0_3}

1. Fixed `NCGrad` for `tr` functions.

## Version 6.0.2 {#Version6_0_2}

1. Fixed bug in `NCPolyMonomial` in lex order.

## Version 6.0.1 {#Version6_0_1}

1. Fixed SparseArray Mathematica bug affecting `NCFromDigits`.
2. `NCGB` has been completely deprecated. Loading `NCGB` loads
   `NCAlgebra` and `NCGBX` instead.
3. Fixed NCRationalToNCPoly bug with expression exponents.


## Version 6.0.0 {#Version6_0_0}

1. NCAlgebra is now distributed as a *paclet*!
2. Changed cannonical representation of noncommutative expressions to
   allow for powers to be present in `NonCommutativeMultiply`.

   > **WARNING:** THIS IS A BREAKING CHANGE THAT CAN AFFECT EXISTING
   > PROGRAMS USING NCALGEBRA. THE MOST NOTABLE LIKELY CONSTRUCTION
   > THAT IS AFFECTED BY THIS CHANGE IS THE APPLICATION OF RULES BASED
   > ON PATTERN MATCHING, WHICH NOW NEED TO EXPLICITLY TAKE INTO
   > ACCOUNT THE PRESENCE OF EXPONENTS. SEE 
   > [NOTES ON MANUAL](#BasicReplace) FOR DETAILS ON HOW TO MITIGATE 
   > THE IMPACT OF THIS CHANGE. ALL NCALGEBRA COMMANDS HAVE BEEN 
   > REWRITTEN TO ACCOMODATE FOR THIS CHANGE IN REPRESENTATION.
3. `NCTEST` renamed `NCCORETEST`
4. Tests must now be run as contexts: e.g. ``<< NCCORETEST` `` instead
   of `<< NCCORETEST`
5. `NonCommutativeMultiply`: new functions
   [NCExpandExponents](#NCExpandExponents) and [NCToList](#NCToList).
6. `NCReplace`: new functions
   [NCReplacePowerRule](#NCReplacePowerRule), 
   [NCExpandReplaceRepeated](#NCExpandReplaceRepeated); 
   [NCExpandReplaceRepeatedSymmetric](#NCExpandReplaceRepeatedSymmetric); 
   [NCExpandReplaceRepeatedSelfAdjoint](#NCExpandReplaceRepeatedSelfAdjoint); 
   new option `ApplyPowerRule`.
7. `NCGBX`: [NCMakeGB](#NCMakeGB) option `ReduceBasis` now defaults to
   `True`.
8. `NCCollect`: new function [NCCollectExponents](#NCCollectExponents).
9. `MatrixDecompositions`: functions [GetLDUMatrices](#GetLDUMatrices)
   and [GetFullLDUMatrices](#GetFullLDUMatrices) now produces low rank
   matrices. 
10. `NCPoly`: new function
   [NCPolyFromGramMatrixFactors](#NCPolyFromGramMatrixFactors).
   `NCPolyFullReduce`
   renamed [NCPolyReduceRepeated](#NCPolyReduceRepeated).
11. `NCPolyInterface`: new functions [NCToRule](#NCToRule),
   [NCReduce](#NCReduce), [NCReduceRepeated](#NCReduceRepeated), 
   [NCRationalToNCPoly](#NCRationalToNCPoly),
   [NCMonomialOrder](#NCMonomialOrder), and
   [NCMonomialOrderQ](#NCMonomialOrderQ).
12. New utility functions
    [SetCommutativeFunction](#SetCommutativeFunction),
    [SetNonCommutativeFunction](#SetNonCommutativeFunction)
    [NCSymbolOrSubscriptExtendedQ](#NCSymbolOrSubscriptExtendedQ), and
    [NCNonCommutativeSymbolOrSubscriptExtendedQ](#NCNonCommutativeSymbolOrSubscriptExtendedQ).
13. The old `C++` version of `NCGB` is no longer compatible with
    `NCAlgebra` *version 6*. Consider using [`NCGBX`](#PackageNCGBX)
    instead.
14. No longer loads the package `Notation` by default. Controlled by
    the new option `UseNotation` in [`NCOptions`](#PackageNCOptions).
15. Streamlined rules for [NCSimplifyRational](#NCSimplifyRational).
