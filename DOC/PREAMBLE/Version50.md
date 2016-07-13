# Changes in Version 5.0

1. Completely rewritten core handling of noncommutative expressions.
2. Commands `Substitute`, `SubstituteSymmetric`, etc, have been
   replaced by the much more reliable commands in the new package
   [NCReplace](#PackageNCReplace).
3. Modified behavior of `CommuteEverything` (see important notes in
   [CommuteEverything](#CommuteEverything)).
4. Improvements and consolidation of NC calculus in the package
   [NCDiff](#PackageNCDiff).
5. Added a complete set of linear algebra solvers in the new package
   [MatrixDecomposition](#PackageMatrixDecomposition) and their
   noncommutative versions in the new package
   [NCMatrixDecomposition](#PackageNCMatrixDecomposition).
6. New algorithms for representing and operating with NC polynomials
   ([NCPolynomial](#PackageNCPolynomial)) and NC linear polynomials
   ([NCSylvester](#PackageNCSylvester)).
7. General improvements on the Semidefinite Programming package
   [NCSDP](#PackageNCSDP).
