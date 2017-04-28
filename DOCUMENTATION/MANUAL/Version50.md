# Changes in Version 5.0 {#Version5_0}

## Version 5.0.3 {#Version5_0_3}

1. Restored functionality of [SetCommutingOperators](#SetCommutingOperators).

## Version 5.0.2 {#Version5_0_2}

1. `NCCollect` and `NCStrongCollect` can handle commutative variables.
2. Cleaned up initialization files.
3. New function `SetNonCommutativeHold` with `HoldAll` attribute can be used to set Symbols that have been previously assigned values.

## Version 5.0.1 {#Version5_0_1}

1. Introducing `NCWebInstall` and `NCWebUpdate`.
2. Bug fixes.

## Version 5.0.0 {#Version5_0_0}

1. Completely rewritten core handling of noncommutative expressions
   with significant speed gains.
2. Completely rewritten noncommutative Gröbner basis algorithm without
   any dependence on compiled code. See chapter
   [Noncommutative Gröbner Basis](#NCGB) in the user guide and the
   [NCGBX](#PackageNCGBX) package. Some `NCGB` features are not fully
   supported yet, most notably [NCProcess](#NCProcess).
3. New algorithms for representing and operating with noncommutative
   polynomials with commutative coefficients. These support the new
   package [NCGBX](#PackageNCGBX). See this section in the chapter
   [More Advanced Commands](#PolysWithCommutativeCoefficients) and the
   packages [NCPolyInterface](#PackageNCPolyInterface) and
   [NCPoly](#PackageNCPoly).
4. New algorithms for representing and operating with noncommutative
   polynomials with noncommutative coefficients
   ([NCPolynomial](#PackageNCPolynomial)) with specialized facilities
   for noncommutative quadratic polynomials
   ([NCQuadratic](#PackageNCQuadratic)) and noncommutative linear
   polynomials ([NCSylvester](#PackageNCSylvester)).
5. Modified behavior of `CommuteEverything` (see important notes in
   [CommuteEverything](#CommuteEverything)).
6. Improvements and consolidation of noncommutative calculus in the
   package [NCDiff](#PackageNCDiff).
7. Added a complete set of linear algebra algorithms in the new
   package [MatrixDecompositions](#PackageMatrixDecompositions) and
   their noncommutative versions in the new package
   [NCMatrixDecompositions](#PackageNCMatrixDecompositions).
8. General improvements on the Semidefinite Programming package
   [NCSDP](#PackageNCSDP).
9. New algorithms for simplification of noncommutative rationals
   ([NCSimplifyRational](#PackageNCSylvester)).
10. Commands `Transform`, `Substitute`, `SubstituteSymmetric`, etc,
	have been replaced by the much more reliable commands in the new
	package [NCReplace](#PackageNCReplace).
11. Command `MatMult` has been replaced by [NCDot](#NCDot). Alias `MM`
    has been deprecated.
12. Noncommutative power is now supported, with `x^3` expanding to
    `x**x**x`, `x^-1` expanding to `inv[x]`.
13. `x^T` expands to `tp[x]` and `x^*` expands to `aj[x]`. Symbol `T`
    is now protected.
14. Support for subscripted variables in notebooks.
