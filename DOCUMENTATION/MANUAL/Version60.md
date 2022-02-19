# Changes in Version 6.0 {#Version6_0}

## Version 6.0.0 {#Version6_0_0}

1. Changed cannonical representation of noncommutative expressions to
   allow for powers to be present in `NonCommutativeMultiply`.

   **WARNING:** THIS IS A BREAKING CHANGE THAT CAN AFFECT EXISTING
   PROGRAMS USING NCALGEBRA. THE MOST NOTABLE LIKELY CONSTRUCTION THAT
   IS AFFECTED BY THIS CHANGE IS THE APPLICATION OF RULES BASED ON
   PATTERN MATCHING, WHICH NOW NEED TO EXPLICITLY TAKE INTO ACCOUNT
   THE PRESENCE OF EXPONENTS. SEE MANUAL FOR DETAILS ON HOW TO
   MITIGATE THE IMPACT OF THIS CHANGE. ALL NCALGEBRA COMMANDS HAVE
   BEEN REWRITTEN TO ACCOMODATE FOR THIS CHANGE IN REPRESENTATION.

2. Streamlined rules for `NCSimplifyRational`.
3. `NonCommutativeMultiply`: new function `NCExpandExponents`.
4. `NCReplace`: new functions `NCReplacePowerRule`; option `ApplyPowerRule`.