# Changes in Version 6.0 {#Version6_0}

## Version 6.0.0 {#Version6_0_0}

1. NCAlgebra is now distributed as a *paclet*!
2. Changed cannonical representation of noncommutative expressions to
   allow for powers to be present in `NonCommutativeMultiply`.

   > **WARNING:** THIS IS A BREAKING CHANGE THAT CAN AFFECT EXISTING
   > PROGRAMS USING NCALGEBRA. THE MOST NOTABLE LIKELY CONSTRUCTION THAT
   > IS AFFECTED BY THIS CHANGE IS THE APPLICATION OF RULES BASED ON
   > PATTERN MATCHING, WHICH NOW NEED TO EXPLICITLY TAKE INTO ACCOUNT
   > THE PRESENCE OF EXPONENTS. SEE MANUAL FOR DETAILS ON HOW TO
   > MITIGATE THE IMPACT OF THIS CHANGE. ALL NCALGEBRA COMMANDS HAVE
   > BEEN REWRITTEN TO ACCOMODATE FOR THIS CHANGE IN REPRESENTATION.

3. Streamlined rules for [NCSimplifyRational](#NCSimplifyRational).
4. `NonCommutativeMultiply`: new functions
   [NCExpandExponents](#NCExpandExponents) and [NCToList](#NCToList). 
5. `NCReplace`: new functions
   [NCReplacePowerRule](#NCReplacePowerRule); new option
   `ApplyPowerRule`.
6. `NCCollect`: new function [NCCollectExponents](#NCCollectExponents).
7. `MatrixDecompositions`: functions [GetLDUMatrices](#GetLDUMatrices)
   and [GetFullLDUMatrices](#GetFullLDUMatrices) now produces low rank
   matrices. 
8. `NCPoly`: new function
   [NCPolyFromGramMatrixFactors](#NCPolyFromGramMatrixFactors).
   `NCPolyFullReduce`
   renamed [NCPolyReduceRepeated](#NCPolyReduceRepeated).
9. `NCPolyInterface`: new functions [NCToRule](#NCToRule),
   [NCReduce](#NCReduce), and [NCReduceRepeated](#NCReduceRepeated).
10. New functions [SetCommutativeFunction](#SetCommutativeFunction)
    and [SetNonCommutativeFunction](#SetNonCommutativeFunction).
11. The old `C++` version of `NCGB` is no longer compatible with
    `NCAlgebra` *version 6*. Consider using [`NCGBX`](#PackageNCGBX)
    instead.
