## NCRealization {#PackageNCRealization}

**WARNING: OBSOLETE PACKAGE WILL BE REPLACED BY NCRational**

The package **NCRealization** implements an algorithm due to N. Slinglend for producing minimal
realizations of nc rational functions in many nc variables. See "Toward Making LMIs Automatically".

It actually computes formulas similar to those used in the paper "Noncommutative Convexity Arises From Linear Matrix Inequalities" by J William Helton, Scott A. McCullough, and Victor Vinnikov. In particular, there are functions for calculating (symmetric) minimal descriptor realizations of nc (symmetric) rational functions, and determinantal representations of polynomials.

Members are:

* Drivers:
    * [NCDescriptorRealization](#NCDescriptorRealization)
    * [NCMatrixDescriptorRealization](#NCMatrixDescriptorRealization)
    * [NCMinimalDescriptorRealization](#NCMinimalDescriptorRealization)
    * [NCDeterminantalRepresentationReciprocal](#NCDeterminantalRepresentationReciprocal)
    * [NCSymmetrizeMinimalDescriptorRealization](#NCSymmetrizeMinimalDescriptorRealization)
    * [NCSymmetricDescriptorRealization](#NCSymmetricDescriptorRealization)
    * [NCSymmetricDeterminantalRepresentationDirect](#NCSymmetricDeterminantalRepresentationDirect)
    * [NCSymmetricDeterminantalRepresentationReciprocal](#NCSymmetricDeterminantalRepresentationReciprocal)
    * [NonCommutativeLift](#NonCommutativeLift)

* Auxiliary:
    * [PinnedQ](#PinnedQ)
    * [PinningSpace](#PinningSpace)
    * [TestDescriptorRealization](#TestDescriptorRealization)
    * [SignatureOfAffineTerm](#SignatureOfAffineTerm)

### NCDescriptorRealization {#NCDescriptorRealization}

`NCDescriptorRealization[RationalExpression,UnknownVariables]` returns a list of 3 matrices `{C,G,B}` such that $C G^{-1} B$ is the given `RationalExpression`. i.e. `NCDot[C,NCInverse[G],B] === RationalExpression`.

`C` and `B` do not contain any `UnknownsVariables` and `G` has linear entries
in the `UnknownVariables`.

### NCDeterminantalRepresentationReciprocal {#NCDeterminantalRepresentationReciprocal}

`NCDeterminantalRepresentationReciprocal[Polynomial,Unknowns]` returns a linear pencil matrix whose determinant
 equals `Constant * CommuteEverything[Polynomial]`. This uses the reciprocal algorithm: find a minimal descriptor realization of `inv[Polynomial]`, so `Polynomial` must be nonzero at the origin.

### NCMatrixDescriptorRealization {#NCMatrixDescriptorRealization}

`NCMatrixDescriptorRealization[RationalMatrix,UnknownVariables]` is similar to `NCDescriptorRealization` except it takes a *Matrix* with rational function entries and returns a matrix of lists of the vectors/matrix `{C,G,B}`. A different `{C,G,B}` for each entry.

### NCMinimalDescriptorRealization {#NCMinimalDescriptorRealization}

`NCMinimalDescriptorRealization[RationalFunction,UnknownVariables]` returns `{C,G,B}` where `NCDot[C,NCInverse[G],B] == RationalFunction`, `G` is linear in the `UnknownVariables`, and the realization is minimal (may be pinned).

### NCSymmetricDescriptorRealization {#NCSymmetricDescriptorRealization}

`NCSymmetricDescriptorRealization[RationalSymmetricFunction, Unknowns]` combines two steps: `NCSymmetrizeMinimalDescriptorRealization[NCMinimalDescriptorRealization[RationalSymmetricFunction, Unknowns]]`.

### NCSymmetricDeterminantalRepresentationDirect {#NCSymmetricDeterminantalRepresentationDirect}

`NCSymmetricDeterminantalRepresentationDirect[SymmetricPolynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[SymmetricPolynomial]`. This uses the direct algorithm: Find a realization of 1 - NCSymmetricPolynomial,...

### NCSymmetricDeterminantalRepresentationReciprocal {#NCSymmetricDeterminantalRepresentationReciprocal}

`NCSymmetricDeterminantalRepresentationReciprocal[SymmetricPolynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[NCSymmetricPolynomial]`. This uses the reciprocal algorithm: find a symmetric minimal descriptor realization of `inv[NCSymmetricPolynomial]`, so NCSymmetricPolynomial must be nonzero at the origin.

### NCSymmetrizeMinimalDescriptorRealization {#NCSymmetrizeMinimalDescriptorRealization}

`NCSymmetrizeMinimalDescriptorRealization[{C,G,B},Unknowns]` symmetrizes the minimal realization `{C,G,B}` (such as output from `NCMinimalRealization`) and outputs `{Ctilda,Gtilda}` corresponding to the realization `{Ctilda, Gtilda,Transpose[Ctilda]}`.

**WARNING:** May produces errors if the realization doesn't correspond to a symmetric rational function.

### NonCommutativeLift {#NonCommutativeLift}

`NonCommutativeLift[Rational]` returns a noncommutative symmetric lift of `Rational`.

### SignatureOfAffineTerm {#SignatureOfAffineTerm}

`SignatureOfAffineTerm[Pencil,Unknowns]` returns a list of the number of positive, negative and zero eigenvalues in the affine part of `Pencil`.

### TestDescriptorRealization {#TestDescriptorRealization}

`TestDescriptorRealization[Rat,{C,G,B},Unknowns]` checks if `Rat` equals $C G^{-1} B$ by substituting random 2-by-2 matrices in for the unknowns. `TestDescriptorRealization[Rat,{C,G,B},Unknowns,NumberOfTests]` can be used to specify the `NumberOfTests`, the default being 5.

### PinnedQ {#PinnedQ}

`PinnedQ[Pencil_,Unknowns_]` is True or False.

### PinningSpace {#PinningSpace}

`PinningSpace[Pencil_,Unknowns_]` returns a matrix whose columns span the pinning space of `Pencil`. Generally, either an empty matrix or a d-by-1 matrix (vector).


