# Changes in Version 6.0 {#Version6_0}

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
4. Tests must now be run as contexts: e.g. ``<< NCCORETEST` `` instead of `<< NCCORETEST`
5. `NonCommutativeMultiply`: new functions
   [NCExpandExponents](#NCExpandExponents) and [NCToList](#NCToList). 
6. `NCReplace`: new functions
   [NCReplacePowerRule](#NCReplacePowerRule); new option
   `ApplyPowerRule`.
7. `NCCollect`: new function [NCCollectExponents](#NCCollectExponents).
8. `MatrixDecompositions`: functions [GetLDUMatrices](#GetLDUMatrices)
   and [GetFullLDUMatrices](#GetFullLDUMatrices) now produces low rank
   matrices. 
9. `NCPoly`: new function
   [NCPolyFromGramMatrixFactors](#NCPolyFromGramMatrixFactors).
   `NCPolyFullReduce`
   renamed [NCPolyReduceRepeated](#NCPolyReduceRepeated).
10. `NCPolyInterface`: new functions [NCToRule](#NCToRule),
   [NCReduce](#NCReduce), and [NCReduceRepeated](#NCReduceRepeated).
11. New functions [SetCommutativeFunction](#SetCommutativeFunction)
    and [SetNonCommutativeFunction](#SetNonCommutativeFunction).
12. The old `C++` version of `NCGB` is no longer compatible with
    `NCAlgebra` *version 6*. Consider using [`NCGBX`](#PackageNCGBX)
    instead.
13. No longer loads the package `Notation` by default. Controlled by
    the new option `UseNotation` in [`NCOptions`](#PackageNCOptions).
14. Streamlined rules for [NCSimplifyRational](#NCSimplifyRational).
