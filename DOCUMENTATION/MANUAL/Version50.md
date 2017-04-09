# Changes in Version 5.0

1. Completely rewritten core handling of noncommutative expressions
   with significant speed gains.
2. Completely rewritten noncommutative Gröbner basis algorithm
   without any dependence on compiled code. See chapter
   [Noncommutative Gröbner Basis](#NCGB) in the user guide and the 
   [NCGBX](#PackageNCGBX) package.
3. New algorithms for representing and operating with noncommutative
   polynomials with commutative coefficients. These support the new
   package [NCGBX](#PackageNCGBX). See this section in the chapter
   [More advanced Commands](#PolysWithCommutativeCoefficients) and the
   packages [NCPolyInterface](#PackageNCPolyInterface) and
   [NCPoly](#PackageNCPoly).
4. New algorithms for representing and operating with noncommutative
   polynomials with noncommutative coefficients
   ([NCPolynomial](#PackageNCPolynomial)) with specialized facilities
   for noncommutative quadratic polynomials
   ([NCQuadratic](#PackageNCQuadratica)) and noncommutative linear
   polynomials ([NCSylvester](#PackageNCSylvester)).
5. Commands `Transform`, `Substitute`, `SubstituteSymmetric`, etc,
   have been replaced by the much more reliable commands in the new
   package [NCReplace](#PackageNCReplace).
6. Modified behavior of `CommuteEverything` (see important notes in
   [CommuteEverything](#CommuteEverything)).
7. Improvements and consolidation of NC calculus in the package
   [NCDiff](#PackageNCDiff).
8. Added a complete set of linear algebra solvers in the new package
   [MatrixDecomposition](#PackageMatrixDecomposition) and their
   noncommutative versions in the new package
   [NCMatrixDecomposition](#PackageNCMatrixDecomposition).
9. General improvements on the Semidefinite Programming package
   [NCSDP](#PackageNCSDP).
10. New algorithms for simplification of noncommutative rationals
   ([NCSimplifyRational](#PackageNCSylvester)).
