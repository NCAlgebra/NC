-   [Changes in Version 5.0](#changes-in-version-5.0)
-   [Introduction](#UserGuideIntroduction)
    -   [Running NCAlgebra](#RunningNCAlgebra)
    -   [Now what?](#now-what)
    -   [Testing](#testing)
-   [Most Basic Commands](#MostBasicCommands)
    -   [To Commute Or Not To Commute?](#to-commute-or-not-to-commute)
    -   [Inverses, Transposes and Adjoints](#inverses-transposes-and-adjoints)
    -   [Expand and Collect](#expand-and-collect)
    -   [Replace](#replace)
    -   [Polynomials](#polynomials)
    -   [Rationals and Simplification](#rationals-and-simplification)
    -   [Calculus](#calculus)
    -   [Matrices](#matrices)
-   [Things you can do with NCAlgebra and NCGB](#ThingsYouCanDo)
    -   [Noncommutative Inequalities](#noncommutative-inequalities)
    -   [Linear Systems and Control](#linear-systems-and-control)
    -   [Semidefinite Programming](#semidefinite-programming)
    -   [NonCommutative Groebner Bases](#noncommutative-groebner-bases)
    -   [NCGBX](#ncgbx)
-   [NonCommutative Gröbner Basis](#NCGB)
    -   [Example 1: solving nc equations](#example-1-solving-nc-equations)
    -   [Example 2: a slightly more challenging example](#example-2-a-slightly-more-challenging-example)
    -   [Example 3: simplifying expresions](#example-3-simplifying-expresions)
        -   [Example 3](#example-3)
        -   [Example 4](#example-4)
    -   [Interlude: ordering on variables and monomials](#Orderings)
        -   [Lex Order: the simplest elimination order](#lex-order-the-simplest-elimination-order)
        -   [Graded lex ordering: A non-elimination order](#graded-lex-ordering-a-non-elimination-order)
        -   [Multigraded lex ordering : a variety of elimination orders](#multigraded-lex-ordering-a-variety-of-elimination-orders)
    -   [Reducing a polynomial by a GB](#reducing-a-polynomial-by-a-gb)
    -   [Simplifying Expressions](#simplifying-expressions)
    -   [NCGB Facilitates Natural Notation](#ncgb-facilitates-natural-notation)
        -   [A Simplification example](#a-simplification-example)
    -   [MakingGB's and Inv\[\], Tp\[\]](#makinggbs-and-inv-tp)
    -   [Simplification and GB's revisited](#simplification-and-gbs-revisited)
        -   [Changing polynomials to rules](#changing-polynomials-to-rules)
        -   [Changing rules to polynomials](#changing-rules-to-polynomials)
        -   [Simplifying using a GB revisited](#simplifying-using-a-gb-revisited)
    -   [Saving lots of time when typing](#saving-lots-of-time-when-typing)
        -   [Saving time working in algebras with involution: NCAddTranspose, NCAddAdjoint](#saving-time-working-in-algebras-with-involution-ncaddtranspose-ncaddadjoint)
        -   [Saving time when setting orders: NCAutomaticOrder](#saving-time-when-setting-orders-ncautomaticorder)
-   [Pretty Output with Mathematica Notebooks and TeX](#TeX)
    -   [Pretty Output](#Pretty_Output)
    -   [Using NCTeX](#Using_NCTeX)
        -   [NCTeX Options](#NCTeX_Options)
    -   [Using NCTeXForm](#Using_NCTeXForm)
-   [Semidefinite Programming](#SemidefiniteProgramming)
    -   [Semidefinite Programs in Matrix Variables](#semidefinite-programs-in-matrix-variables)
    -   [Semidefinite Programs in Vector Variables](#semidefinite-programs-in-vector-variables)
-   [Introduction](#ReferenceIntroduction)
-   [NonCommutativeMultiply](#PackageNonCommutativeMultiply)
    -   [aj](#aj)
    -   [co](#co)
    -   [Id](#Id)
    -   [inv](#inv)
    -   [rt](#rt)
    -   [tp](#tp)
    -   [CommutativeQ](#CommutativeQ)
    -   [NonCommutativeQ](#NonCommutativeQ)
    -   [SetCommutative](#SetCommutative)
    -   [SetNonCommutative](#SetNonCommutative)
    -   [Commutative](#Commutative)
    -   [CommuteEverything](#CommuteEverything)
    -   [BeginCommuteEverything](#BeginCommuteEverything)
    -   [EndCommuteEverything](#EndCommuteEverything)
    -   [ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply)
-   [NCCollect](#PackageNCCollect)
    -   [NCCollect](#NCCollect)
        -   [Notes](#notes)
    -   [NCCollectSelfAdjoint](#NCCollectSelfAdjoint)
    -   [NCCollectSymmetric](#NCCollectSymmetric)
    -   [NCStrongCollect](#NCStrongCollect)
    -   [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint)
    -   [NCStrongCollectSymmetric](#NCStrongCollectSymmetric)
    -   [NCCompose](#NCCompose)
    -   [NCDecompose](#NCDecompose)
    -   [NCTermsOfDegree](#NCTermsOfDegree)
-   [NCSimplifyRational](#PackageNCSimplifyRational)
    -   [NCNormalizeInverse](#NCNormalizeInverse)
    -   [NCSimplifyRational](#NCSimplifyRational)
    -   [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass)
    -   [NCPreSimplifyRational](#NCPreSimplifyRational)
    -   [NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass)
-   [NCDiff](#PackageNCDiff)
    -   [NCDirectionalD](#NCDirectionalD)
    -   [NCGrad](#NCGrad)
    -   [NCHessian](#NCHessian)
    -   [DirectionalD](#DirectionalD)
    -   [NCIntegrate](#NCIntegrate)
-   [NCReplace](#PackageNCReplace)
    -   [NCReplace](#NCReplace)
    -   [NCReplaceAll](#NCReplaceAll)
    -   [NCReplaceList](#NCReplaceList)
    -   [NCReplaceRepeated](#NCReplaceRepeated)
    -   [NCMakeRuleSymmetric](#NCMakeRuleSymmetric)
    -   [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint)
-   [NCSelfAdjoint](#PackageNCSelfAdjoint)
    -   [NCSymmetricQ](#NCSymmetricQ)
    -   [NCSymmetricTest](#NCSymmetricTest)
    -   [NCSymmetricPart](#NCSymmetricPart)
    -   [NCSelfAdjointQ](#NCSelfAdjointQ)
    -   [NCSelfAdjointTest](#NCSelfAdjointTest)
-   [NCOutput](#PackageNCOutput)
    -   [NCSetOutput](#NCSetOutput)
-   [NCPolynomial](#PackageNCPolynomial)
    -   [NCPolynomial](#NCPolynomial)
    -   [NCToNCPolynomial](#NCToNCPolynomial)
    -   [NCPolynomialToNC](#NCPolynomialToNC)
    -   [NCRationalToNCPolynomial](#NCRationalToNCPolynomial)
    -   [NCPCoefficients](#NCPCoefficients)
    -   [NCPTermsOfDegree](#NCPTermsOfDegree)
    -   [NCPTermsOfTotalDegree](#NCPTermsOfTotalDegree)
    -   [NCPTermsToNC](#NCPTermsToNC)
    -   [NCPPlus](#NCPPlus)
    -   [NCPSort](#NCPSort)
    -   [NCPDecompose](#NCPDecompose)
    -   [NCPDegree](#NCPDegree)
    -   [NCPMonomialDegree](#NCPMonomialDegree)
    -   [NCPLinearQ](#NCPLinearQ)
    -   [NCPQuadraticQ](#NCPQuadraticQ)
    -   [NCPCompatibleQ](#NCPCompatibleQ)
    -   [NCPSameVariablesQ](#NCPSameVariablesQ)
    -   [NCPMatrixQ](#NCPMatrixQ)
    -   [NCPNormalize](#NCPNormalize)
-   [NCSylvester](#PackageNCSylvester)
    -   [NCPolynomialToNCSylvester](#NCPolynomialToNCSylvester)
    -   [NCSylvesterToNCPolynomial](#NCSylvesterToNCPolynomial)
-   [NCQuadratic](#PackageNCQuadratic)
    -   [NCQuadratic](#NCQuadratic)
    -   [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric)
    -   [NCMatrixOfQuadratic](#NCMatrixOfQuadratic)
    -   [NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial)
-   [NCRational](#PackageNCRational)
    -   [NCRational](#NCRational)
    -   [NCToNCRational](#NCToNCRational)
    -   [NCRationalToNC](#NCRationalToNC)
    -   [NCRationalToCanonical](#NCRationalToCanonical)
    -   [CanonicalToNCRational](#CanonicalToNCRational)
    -   [NCROrder](#NCROrder)
    -   [NCRLinearQ](#NCRLinearQ)
    -   [NCRStrictlyProperQ](#NCRStrictlyProperQ)
    -   [NCRPlus](#NCRPlus)
    -   [NCRTimes](#NCRTimes)
    -   [NCRTranspose](#NCRTranspose)
    -   [NCRInverse](#NCRInverse)
    -   [NCRControllableRealization](#NCRControllableRealization)
    -   [NCRControllableSubspace](#NCRControllableSubspace)
    -   [NCRObservableRealization](#NCRObservableRealization)
    -   [NCRMinimalRealization](#NCRMinimalRealization)
-   [NCMatMult](#PackageNCMatMult)
    -   [tpMat](#tpMat)
    -   [ajMat](#ajMat)
    -   [coMat](#coMat)
    -   [MatMult](#MatMult)
        -   [Notes](#notes-1)
    -   [NCInverse](#NCInverse)
    -   [NCMatrixExpand](#NCMatrixExpand)
-   [NCMatrixDecompositions](#PackageNCMatrixDecompositions)
    -   [NCLDLDecomposition](#NCLDLDecomposition)
    -   [NCLeftDivide](#NCLeftDivide)
    -   [NCLowerTriangularSolve](#NCLowerTriangularSolve)
    -   [NCLUCompletePivoting](#NCLUCompletePivoting)
    -   [NCLUDecompositionWithCompletePivoting](#NCLUDecompositionWithCompletePivoting)
    -   [NCLUDecompositionWithPartialPivoting](#NCLUDecompositionWithPartialPivoting)
    -   [NCLUInverse](#NCLUInverse)
    -   [NCLUPartialPivoting](#NCLUPartialPivoting)
    -   [NCMatrixDecompositions](#NCMatrixDecompositions)
    -   [NCRightDivide](#NCRightDivide)
    -   [NCUpperTriangularSolve](#NCUpperTriangularSolve)
-   [MatrixDecompositions](#PackageMatrixDecompositions)
    -   [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting)
    -   [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting)
    -   [LDLDecomposition](#LDLDecomposition)
    -   [UpperTriangularSolve](#UpperTriangularSolve)
    -   [LowerTriangularSolve](#LowerTriangularSolve)
    -   [LUInverse](#LUInverse)
    -   [GetLUMatrices](#GetLUMatrices)
    -   [GetLDUMatrices](#GetLDUMatrices)
    -   [GetDiagonal](#GetDiagonal)
    -   [LUPartialPivoting](#LUPartialPivoting)
    -   [LUCompletePivoting](#LUCompletePivoting)
-   [NCConvexity](#PackageNCConvexity)
    -   [NCIndependent](#NCIndependent)
    -   [NCConvexityRegion](#NCConvexityRegion)
-   [NCRealization](#PackageNCRealization)
    -   [NCDescriptorRealization](#NCDescriptorRealization)
    -   [NCDeterminantalRepresentationReciprocal](#NCDeterminantalRepresentationReciprocal)
    -   [NCMatrixDescriptorRealization](#NCMatrixDescriptorRealization)
    -   [NCMinimalDescriptorRealization](#NCMinimalDescriptorRealization)
    -   [NCSymmetricDescriptorRealization](#NCSymmetricDescriptorRealization)
    -   [NCSymmetricDeterminantalRepresentationDirect](#NCSymmetricDeterminantalRepresentationDirect)
    -   [NCSymmetricDeterminantalRepresentationReciprocal](#NCSymmetricDeterminantalRepresentationReciprocal)
    -   [NCSymmetrizeMinimalDescriptorRealization](#NCSymmetrizeMinimalDescriptorRealization)
    -   [NonCommutativeLift](#NonCommutativeLift)
    -   [SignatureOfAffineTerm](#SignatureOfAffineTerm)
    -   [TestDescriptorRealization](#TestDescriptorRealization)
    -   [PinnedQ](#PinnedQ)
    -   [PinningSpace](#PinningSpace)
-   [NCUtil](#PackageNCUtil)
    -   [NCConsistentQ](#NCConsistentQ)
    -   [NCGrabFunctions](#NCGrabFunctions)
    -   [NCGrabSymbols](#NCGrabSymbols)
    -   [NCGrabIndeterminants](#NCGrabIndeterminants)
    -   [NCConsolidateList](#NCConsolidateList)
    -   [NCLeafCount](#NCLeafCount)
    -   [NCReplaceData](#NCReplaceData)
    -   [NCToExpression](#NCToExpression)
-   [NCSDP](#PackageNCSDP)
    -   [NCSDP](#NCSDP)
    -   [NCSDPForm](#NCSDPForm)
    -   [NCSDPDual](#NCSDPDual)
    -   [NCSDPDualForm](#NCSDPDualForm)
-   [SDP](#PackageSDP)
    -   [SDPMatrices](#SDPMatrices)
    -   [SDPSolve](#SDPSolve)
    -   [SDPEval](#SDPEval)
    -   [SDPInner](#SDPInner)
    -   [SDPCheckDimensions](#SDPCheckDimensions)
    -   [SDPDualEval](#SDPDualEval)
    -   [SDPFunctions](#SDPFunctions)
    -   [SDPPrimalEval](#SDPPrimalEval)
    -   [SDPScale](#SDPScale)
    -   [SDPSylvesterDiagonalEval](#SDPSylvesterDiagonalEval)
    -   [SDPSylvesterEval](#SDPSylvesterEval)
-   [NCGBX](#PackageNCGBX)
    -   [NCToNCPoly](#NCToNCPoly)
    -   [NCPolyToNC](#NCPolyToNC)
    -   [NCRuleToPoly](#NCRuleToPoly)
    -   [SetMonomialOrder](#SetMonomialOrder)
    -   [SetKnowns](#SetKnowns)
    -   [SetUnknowns](#SetUnknowns)
    -   [ClearMonomialOrder](#ClearMonomialOrder)
    -   [GetMonomialOrder](#GetMonomialOrder)
    -   [PrintMonomialOrder](#PrintMonomialOrder)
    -   [NCMakeGB](#NCMakeGB)
    -   [NCReduce](#NCReduce)
-   [NCPoly](#PackageNCPoly)
    -   [NCPoly](#NCPoly)
    -   [NCPolyMonomial](#NCPolyMonomial)
    -   [NCPolyConstant](#NCPolyConstant)
    -   [NCPolyMonomialQ](#NCPolyMonomialQ)
    -   [NCPolyDegree](#NCPolyDegree)
    -   [NCPolyNumberOfVariables](#NCPolyNumberOfVariables)
    -   [NCPolyCoefficient](#NCPolyCoefficient)
    -   [NCPolyGetCoefficients](#NCPolyGetCoefficients)
    -   [NCPolyGetDigits](#NCPolyGetDigits)
    -   [NCPolyGetIntegers](#NCPolyGetIntegers)
    -   [NCPolyLeadingMonomial](#NCPolyLeadingMonomial)
    -   [NCPolyLeadingTerm](#NCPolyLeadingTerm)
    -   [NCPolyOrderType](#NCPolyOrderType)
    -   [NCPolyToRule](#NCPolyToRule)
    -   [NCPolyDisplayOrder](#NCPolyDisplayOrder)
    -   [NCPolyDisplay](#NCPolyDisplay)
    -   [NCPolyDivideDigits](#NCPolyDivideDigits)
    -   [NCPolyDivideLeading](#NCPolyDivideLeading)
    -   [NCPolyFullReduce](#NCPolyFullReduce)
    -   [NCPolyNormalize](#NCPolyNormalize)
    -   [NCPolyProduct](#NCPolyProduct)
    -   [NCPolyQuotientExpand](#NCPolyQuotientExpand)
    -   [NCPolyReduce](#NCPolyReduce)
    -   [NCPolySum](#NCPolySum)
    -   [NCPolyHankelMatrix](#NCPolyHankelMatrix)
    -   [NCPolyRealization](#NCPolyRealization)
    -   [NCFromDigits](#NCFromDigits)
    -   [NCIntegerDigits](#NCIntegerDigits)
    -   [NCDigitsToIndex](#NCDigitsToIndex)
    -   [NCPadAndMatch](#NCPadAndMatch)
-   [NCPolyGroebner](#PackageNCPolyGroebner)
    -   [NCPolyGroebner](#NCPolyGroebner)
-   [NCTeX](#PackageNCTeX)
    -   [NCTeX](#NCTeX)
    -   [NCRunDVIPS](#NCRunDVIPS)
    -   [NCRunLaTeX](#NCRunLaTeX)
    -   [NCRunPDFLaTeX](#NCRunPDFLaTeX)
    -   [NCRunPDFViewer](#NCRunPDFViewer)
    -   [NCRunPS2PDF](#NCRunPS2PDF)
-   [NCTeXForm](#PackageNCTeXForm)
    -   [NCTeXForm](#NCTeXForm)
    -   [NCTeXFormSetStarStar](#NCTeXFormSetStarStar)
    -   [NCTeXFormSetStar](#NCTeXFormSetStar)
-   [NCRun](#PackageNCRun)
    -   [NCRun](#NCRun)
-   [NCTest](#PackageNCTest)
    -   [NCTest](#NCTest)
    -   [NCTestRun](#NCTestRun)
    -   [NCTestSummarize](#NCTestSummarize)

Copyright 2016: J. William Helton Mauricio C. de Oliveira

BSD License to come

Changes in Version 5.0
======================

1.  Completely rewritten core handling of noncommutative expressions with significant speed gains.
2.  Commands `Transform`, `Substitute`, `SubstituteSymmetric`, etc, have been replaced by the much more reliable commands in the new package [NCReplace](#PackageNCReplace).
3.  Modified behavior of `CommuteEverything` (see important notes in [CommuteEverything](#CommuteEverything)).
4.  Improvements and consolidation of NC calculus in the package [NCDiff](#PackageNCDiff).
5.  Added a complete set of linear algebra solvers in the new package [MatrixDecomposition](#PackageMatrixDecomposition) and their noncommutative versions in the new package [NCMatrixDecomposition](#PackageNCMatrixDecomposition).
6.  New algorithms for representing and operating with NC polynomials ([NCPolynomial](#PackageNCPolynomial)) and NC linear polynomials ([NCSylvester](#PackageNCSylvester)).
7.  General improvements on the Semidefinite Programming package [NCSDP](#PackageNCSDP).
8.  New algorithms for simplification of noncommutative rationals ([NCSimplifyRational](#PackageNCSylvester)).

Introduction
============

This *User Guide* attempts to document the many improvements introduced in `NCAlgebra` Version 5.0. Please be patient, as we move to incorporate the many recent changes into this document.

See [Reference Manual](#ReferenceIntroduction) for a detailed description of the available commands.

Running NCAlgebra
-----------------

In *Mathematica* (notebook or text interface), type

    << NC`

If this step fails, your installation has problems (check out installation instructions on the main page). If your installation is succesful you will see a message like:

    You are using the version of NCAlgebra which is found in:
       /your_home_directory/NC.
    You can now use "<< NCAlgebra`" to load NCAlgebra or "<< NCGB`" to load NCGB.

Just type

    << NCAlgebra`

to load `NCAlgebra`, or

    << NCGB`

to load `NCAlgebra` *and* `NCGB`.

Now what?
---------

Basic documentation is found in the project wiki:

https://github.com/NCAlgebra/NC/wiki

Extensive documentation is found in the directory `DOCUMENTATION`.

You may want to try some of the several demo files in the directory `DEMOS` after installing `NCAlgebra`.

You can also run some tests to see if things are working fine.

Testing
-------

Type

    << NCTEST

to test NCAlgebra. Type

    << NCGBTEST

to test NCGB.

We recommend that you restart the kernel before and after running tests. Each test takes a few minutes to run.

Most Basic Commands
===================

This chapter provides a gentle introduction to some of the commands available in `NCAlgebra`. Before you can use `NCAlgebra` you first load it with the following commands:

    In[1]:= << NC`
    In[2]:= << NCAlgebra`

To Commute Or Not To Commute?
-----------------------------

In `NCAlgebra`, the operator `**` denotes *noncommutative multiplication*. At present, single-letter lower case variables are noncommutative by default and all others are commutative by default. For example:

    a**b-b**a

results in

    a**b-b**a

while

    A**B-B**A
    A**b-b**A

both result in `0`.

One of Bill's favorite commands is `CommuteEverything`, which temporarily makes all noncommutative symbols appearing in a given expression to behave as if they were commutative and returns the resulting commutative expression. For example:

    CommuteEverything[a**b-b**a]

results in `0`. The command

    EndCommuteEverything[]

restores the original noncommutative behavior.

One can make any symbol behave as noncommutative using `SetNonCommutative`. For example:

    SetNonCommutative[A,B]
    A**B-B**A

results in:

    A**B-B**A

Likewise, symbols can be made commutative using `SetCommutative`. For example:

    SetNonCommutative[A] 
    SetCommutative[B]
    A**B-B**A

results in `0`. `SNC` is an alias for `SetNonCommutative`. So, `SNC` can be typed rather than the longer `SetNonCommutative`:

    SNC[A];
    A**a-a**A

results in:

    -a**A+A**a

One can check whether a given symbol is commutative or not using `CommutativeQ` or `NonCommutativeQ`. For example:

    CommutativeQ[B]
    NonCommutativeQ[a]

both return `True`.

Inverses, Transposes and Adjoints
---------------------------------

The multiplicative identity is denoted `Id` in the program. At the present time, `Id` is set to 1.

A symbol `a` may have an inverse, which will be denoted by `inv[a]`. `inv` operates as expected in most cases.

For example:

    inv[a]**a
    inv[a**b]**a**b

both lead to `Id = 1` and

    a**b**inv[b]

results in `a`.

`tp[x]` denotes the transpose of symbol `x` and `aj[x]` denotes the adjoint of symbol `x`. Like `inv`, the properties of transposes and adjoints that everyone uses constantly are built-in. For example:

    tp[a**b]

leads to

    tp[b]**tp[a]

and

    tp[a+b]

returns

    tp[a]+tp[b]

Likewise `tp[tp[a]] == a` and `tp` for anything for which `CommutativeQ` returns `True` is simply the identity. For example `tp[5] == 5`, `tp[2 + 3I] == 2 + 3 I`, and `tp[B] == B`.

Similar properties hold to `aj`. Moreover

    aj[tp[a]]
    tp[aj[a]]

return `co[a]` where `co` stands for complex-conjugate.

**Version 5.0:** transposes (`tp`), adjoints (`aj`) and complex conjugates (`co`) in a notebook environment render as *x*<sup>*T*</sup>, *x*<sup>\*</sup>, and $\\bar{x}$.

Expand and Collect
------------------

The command `NCExpand` expands noncommutative products. For example:

    NCExpand[(a+b)**x]

returns

    a**x+b**x

Conversely, one can collect noncommutative terms involving same powers of a symbol using `NCCollect`. For example:

    NCCollect[a**x+b**x,x]

recovers

    (a+b)**x

`NCCollect` groups terms by degree before collecting and accepts more than one variable. For example:

    expr = a**x+b**x+y**c+y**d+a**x**y+b**x**y
    NCCollect[expr, {x}]

returns

    y**c+y**d+(a+b)**x**(1+y)

and

    NCCollect[expr, {x, y}]

returns

    (a+b)**x+y**(c+d)+(a+b)**x**y

Note that the last term has degree 2 in `x` and `y` and therefore does not get collected with the first order terms.

The list of variables accepts `tp`, `aj` and `inv`, and

    NCCollect[tp[x]**a**x+tp[x]**b**x+z,{x,tp[x]}]

returns

    z+tp[x]**(a+b)**x

Alternatively one could use

    NCCollectSymmetric[tp[x]**a**x+tp[x]**b**x+z,{x}]

to obtain the same result. A similar command, [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), works with self-adjoint variables.

There is also a stronger version of collect called `NCStrongCollect`. `NCStrongCollect` does not group terms by degree. For instance:

    NCStrongCollect[expr, {x, y}]

produces

    y**(c+d)+(a+b)**x**(1+y)

Keep in mind that `NCStrongCollect` often collects *more* than one would normally expect.

Replace
-------

A key feature of symbolic computation is the ability to perform substitutions. The Mathematica substitute commands, e.g. `ReplaceAll` (`/.`) and `ReplaceRepeated` (`//.`), are not reliable in `NCAlgebra`, so you must use our `NC` versions of these commands. For example:

    NCReplaceAll[x**a**b,a**b->c]

results in

    x**c

and

    NCReplaceAll[tp[b**a]+b**a,b**a->c]

results in

    c+tp[a]**tp[b]

USe [NCMakeRuleSymmetric](#NCMakeRuleSymmetric) and [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint) to automatically create symmetric and self adjoint versions of your rules:

    NCReplaceAll[tp[b**a]+b**a, NCMakeRuleSymmetric[b ** a -> c]]

returns

    c + tp[c]

The difference between `NCReplaceAll` and `NCReplaceRepeated` can be understood in the example:

    NCReplaceAll[a ** b ** b, a ** b -> a]

that results in

    a ** b

and

    NCReplaceRepeated[a ** b ** b, a ** b -> a]

that results in

    a

Beside `NCReplaceAll` and `NCReplaceRepeated` we offer `NCReplace` and `NCReplaceList`, which are analogous to the standard `ReplaceAll` (`/.`), `ReplaceRepeated` (`//.`), `Replace` and `ReplaceList`. Note that one rarely uses `NCReplace` and `NCReplaceList`.

**Version 5.0:** the commands `Substitute` and `Transform` have been deprecated in favor of the above nc versions of `Replace`.

Polynomials
-----------

Rationals and Simplification
----------------------------

One of the great challenges of noncommutative symbolic algebra is the simplification of rational nc expressions. `NCAlgebra` provides various algorithms that can be used for simplification and general manipulation of nc rationals.

One such function is `NCSimplifyRational`, which attempts to simplify noncommutative rationals using a predefined set of rules. For example:

    expr = 1+inv[d]**c**inv[S-a]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b \
           -inv[d]**c**inv[S-a+b**inv[d]**c]**b**inv[d]**c**inv[S-a]**b
    NCSimplifyRational[expr]

leads to `1`. Of course the great challenge here is to reveal well known identities that can lead to simplification. For example, the two expressions:

    expr1 = a**inv[1+b**a]
    expr2 = inv[1+a**b]**a

and one can use `NCSimplifyRational` to test such equivalence by evaluating

    NCSimplifyRational[expr1 - expr2]

which results in `0` or

    NCSimplifyRational[expr1**inv[expr2]]

which results in `1`. `NCSimplifyRational` works by transforming nc rationals. For example, one can verify that

    NCSimplifyRational[expr2] == expr1

Calculus
--------

One can calculate directional derivatives with `DirectionalD` and noncommutative gradients with `NCGrad`.

    In[50]:= DirectionalD[x**x,x,h]
    Out[50]= h**x+x**h
    In[51]:= NCGrad[tp[x]**x+tp[x]**A**x+m**x,x]
    Out[51]= m+tp[x]**A+tp[x]**tp[A]+2 tp[x]

?? ADD INTEGRATE AND HESSIAN ??

Matrices
--------

`NCAlgebra` has many algorithms that handle matrices with noncommutative entries.

    In[52]:= m1={{a,b},{c,d}}
    Out[52]= {{a,b},{c,d}}
    In[53]:= m2={{d,2},{e,3}}
    Out[53]= {{d,2},{e,3}}
    In[54]:= MatMult[m1,m2]
    Out[54]= {{a**d+b**e,2 a+3 b},{c**d+d**e,2 c+3 d}}

?? ADD NCInverse, and much more ??

Things you can do with NCAlgebra and NCGB
=========================================

In this page you will find some things that you can do with `NCAlgebra` and `NCGB`.

Noncommutative Inequalities
---------------------------

Is a given noncommutative function *convex*? You type in a function of noncommutative variables; the command `NCConvexityRegion[Function, ListOfVariables]` tells you where the (symbolic) `Function` is *convex* in the Variables. This corresponds to papers of *Camino, Helton and Skelton*.

Linear Systems and Control
--------------------------

`NCAlgebra` integrates with *Mathematica*'s control toolbox (version 8.0 and above) to work on noncommutative block systems, just as a human would do...

Look for NCControl.nb in the `NC/DEMOS` subdirectory.

Semidefinite Programming
------------------------

`NCAlgebra` now comes with a numerical solver that can compute the solution to semidefinite programs, aka linear matrix inequalities.

Look for demos in the `NC/NCSDP/DEMOS` subdirectory.

You can also find examples of systems and control linear matrix inequalities problems being manipulated and numerically solved by NCAlgebra on the UCSD course webpage.

Look for the .nb files, starting with the file sat5.nb at Lecture 8.

NonCommutative Groebner Bases
-----------------------------

`NCGB` Computes NonCommutative Groebner Bases and has extensive sorting and display features and algorithms for automatically discarding *redundant* polynomials, as well as *kludgy* methods for suggesting changes of variables (which work better than one would expect).

`NCGB` runs in conjunction with `NCAlgebra`.

NCGBX
-----

`NCGBX` is a 100% Mathematica version of our NC Groebner Basis Algorithm and does not require C/C++ code compilation.

Look for demos in the `NC/NCPoly/DEMOS` subdirectory of the most current distributions.

**IMPORTANT:** Do not load NCGB and NCGBX simultaneously.

NonCommutative Gröbner Basis
============================

The package `NCGBX` provides an implementation of a noncommutative Gröbner Basis algorithm. Gröbner Basis are useful in the study of algebraic relations.

In order to load `NCGB` one types:

    << NC`
    << NCGBX`

or simply

    << NCGBX`

if `NC` and `NCAlgebra` have already been loaded.

?? REVISE ??

A reader who has no explicit interest in Gröbner Bases might want to skip this section. Readers who lack background in Gröbner Basis may want to read \[CLS\].

?? ADD A BRIEF INTRO TO GBs ??

Example 1: solving nc equations
-------------------------------

Before calculating a Gröbner Basis, one must declare which variables will be used during the computation and must declare a *monomial order* which can be done using `SetMonomialOrder` as in:

    SetMonomialOrder[{a, b, c}, x];

The monomial ordering imposes a relationship between the variables which are used to *sort* the monomials in a polynomial. The ordering implied by the above command can be visualized using:

    PrintMonomialOrder[];

which in this case prints:

*a* &lt; *b* &lt; *c* ≪ *x*.

A user does not need to know theoretical background related to monomials orders. Indeed, as we shall see soon, in many engineering problems, it suffices to know which variables correspond to quantities which are *known* and which variables correspond to quantities which are *unknown*. If one is solving for a variable or desires to prove that a certain quantity is zero, then one would want to view that variable as *unknown*. In the above example, the symbol '≪' separate the *knowns*, *a*, *b*, *c*, from the *unknown*, *x*. For more details on orderings see Section [Orderings](#Ordering).

Our goal is to calculate the Gröbner basis associated with the following relations:
$$
\\begin{aligned}
    a \\, x \\, a &= c, &
    a \\, b &= 1, &
    b \\, a &= 1.
\\end{aligned}
$$
 We shall use the word *relation* to mean a polynomial in noncommuting indeterminates. For example, if an analyst saw the equation *A**B* = 1 for matrices *A* and *B*, then he might say that *A* and *B* satisfy the polynomial equation *a* *b* − 1 = 0. An algebraist would say that *a* *b* − 1 is a relation.

To calculate a Gröbner basis one defines a list of relations

    rels = {a ** x ** a - c, a ** b - 1, b ** a - 1}

and issues the command:

    gb = NCMakeGB[rels, 10]

which should produces an output similar to:

    * * * * * * * * * * * * * * * *
    * * *   NCPolyGroebner    * * *
    * * * * * * * * * * * * * * * *
    * Monomial order : a < b < c << x
    * Reduce and normalize initial basis
    > Initial basis could not be reduced
    * Computing initial set of obstructions
    > MAJOR Iteration 1, 4 polys in the basis, 2 obstructions
    > MAJOR Iteration 2, 5 polys in the basis, 2 obstructions
    * Cleaning up basis.
    * Found Groebner basis with 3 relations
    * * * * * * * * * * * * * * * *

The number `10` in the call to `NCMakeGB` is very important because a finite GB may not exist. It instructs `NCMakeGB` to abort after `10` iterations if a GB has not been found at that point.

The result of the above calculation is the list of relations:

    {x -> b ** c ** b, a ** b -> 1, b ** a -> 1}

Our favorite format for displaying lists of relations is `ColumnForm`.

    ColumnForm[gb]

which results in

    x -> b ** c ** b
    a ** b -> 1
    b ** a -> 1

Someone not familiar with GB's might find it instructive to note this output GB effectively *solves* the input equation
*a* *x* *a* − *c* = 0
 under the assumptions that
$$
\\begin{aligned}
    b \\, a - 1 &= 0, &
    a \\, b - 1 & =0,
\\end{aligned}
$$
 that is *a* = *b*<sup>−1</sup> and produces the expected result in the form of the relation:
*x* = *b* *c* *b*.

Example 2: a slightly more challenging example
----------------------------------------------

For a slightly more challenging example consider the same monomial order as before:

    SetMonomialOrder[{a, b, c}, x];

that is

*a* &lt; *b* &lt; *c* ≪ *x*

and the relations:

$$
\\begin{aligned}
  a \\, x - c &= 0, \\\\
  a \\, b \\, a - a &= 0, \\\\
  b \\, a \\, b - b &= 0,
\\end{aligned}
$$
 from which one can recognize the problem of solving the linear equation *a* *x* = *c* in terms of the *pseudo-inverse* *b* = *a*<sup>†</sup>. The calculation:

    gb = NCMakeGB[{a ** x - c, a ** b ** a - a, b ** a ** b - b}, 10];

finds the Gröbner basis:

    a ** x -> c
    a ** b ** c -> c
    a ** b ** a -> a 
    b ** a ** b -> b

In this case the Gröbner basis cannot quite *solve* the equations but it remarkably produces the necessary condition for existence of solutions:
0 = *a* *b* *c* − *c* = *a* *a*<sup>†</sup>*c* − *c*
 that can be interpreted as *c* being in the range-space of *a*.

Example 3: simplifying expresions
---------------------------------

Our goal now is to verify if it is possible to simplify following expression:
*b**b**a**a* − *a**a**b**b* + *a**b**a*
 if we know that
*a**b**a* = *b*
 using Gröbner basis. With that in mind we set the order:

    SetMonomialOrder[a,b];

and calculate the GB:

    rels = {a ** b ** a - b};
    rules = NCMakeGB[rels, 10];

which produces the output

    * * * * * * * * * * * * * * * *
    * * *   NCPolyGroebner    * * *
    * * * * * * * * * * * * * * * *
    * Monomial order : a \[LessLess]  b
    * Reduce and normalize initial basis
    > Initial basis could not be reduced
    * Computing initial set of obstructions
    > MAJOR Iteration 1, 2 polys in the basis, 1 obstructions
    * Cleaning up basis.
    * Found Groebner basis with 2 relations
    * * * * * * * * * * * * * * * *

and the associated GB

    a ** b ** a -> b
    b ** b ** a -> a ** b ** b

The GB reveals other relationships which must hold true if $a b a = $, that can be used to simplify the original expression using `NCReplaceRepeated` as in

    expr = b ** b ** a ** a - a ** a ** b ** b + a ** b ** a
    simp = NCReplaceRepeated[expr, rules]

which results in

    simp = b

### Example 3

Now we turn to a more complicated (though mathematically intuitive) notation. In Example 1 above, the letter *b* was essentially introduced to represent the inverse of letter *a*. It is possible to have `NCMakeGB` handle all of that automatically by simply adding `inv[a]` as a member of the ordering:

    SetMonomialOrder[{a,inv[a],c},x];

that is

*a* &lt; *a*<sup>−1</sup> &lt; *c* ≪ *x*

Calling `NCMakeGB` with only one relation:

    gb = NCMakeGB[{a**x**a-c},10]

produces the output

    * * * * * * * * * * * * * * * *
    * * *   NCPolyGroebner    * * *
    * * * * * * * * * * * * * * * *
    * Monomial order : a < inv[a] < c <<  x
    * Reduce and normalize initial basis
    > Initial basis could not be reduced
    * Computing initial set of obstructions
    > MAJOR Iteration 1, 5 polys in the basis, 3 obstructions
    > MAJOR Iteration 2, 6 polys in the basis, 3 obstructions
    * Cleaning up basis.
    * Found Groebner basis with 3 relations
    * * * * * * * * * * * * * * * *

The resulting Gröbner basis is:

    gb = {x -> inv[a]**c**inv[a]}

which is what one would expect. Internally, an extra variable has been created and extra relations encoding that *a* were invertible were appended to the list of relations before running `NCMakeGB`.

?? DO WE WANT TO SUPPORT pinv, linv and rinv? ??

### Example 4

One can use Gröbner basis to *simplify* polynomial or rational expressions.

Consider for instance the order

*x* ≪ *x*<sup>−1</sup> ≪ (1 − *x*)<sup>−1</sup>

implied by the command:

    SetMonomialOrder[x, inv[x], inv[1-x]]

This ordering encodes the following precise idea of what we mean by *simple* versus *complicated*: it formally corresponds to specifying that *x* is simpler than *x*<sup>−1</sup> that is simpler than (1 − *x*)<sup>−1</sup>, which might sits well with one's intuition.

Of course, there may be many other orders that are mathematically correct but might not serve well if simplification is the main goal. For example, perhaps the order

*x*<sup>−1</sup> ≪ *x* ≪ (1 − *x*)<sup>−1</sup>

does not simplify as much as the previous one, since, if possible, it would be preferable to express an answer in terms of *x*, rather than *x*<sup>−1</sup>.

Not consider the following command:

    rules = NCMakeGB[{}, 3]

which produces the output

    * * * * * * * * * * * * * * * *
    * * *   NCPolyGroebner    * * *
    * * * * * * * * * * * * * * * *
    * Monomial order : x <<  inv[x] << inv[1 - x]
    * Reduce and normalize initial basis
    > Initial basis could not be reduced
    * Computing initial set of obstructions
    > MAJOR Iteration 1, 6 polys in the basis, 6 obstructions
    * Cleaning up basis.
    * Found Groebner basis with 6 relations
    * * * * * * * * * * * * * * * *

and results in the rules:

    x ** inv[1 - x] -> -1 + inv[1 - x],
    x^-1 ** inv[1-x] -> inv[1-x] + x^-1,
    inv[1-x] ** x -> -1 + inv[1-x],
    inv[1-x] ** x^-1 -> inv[1-x] + x^-1

One might be puzzled by how this output was produced since the initial set of relations was empty (`{}`). Of course the above GB correspond to the invertibility assumptions implied by the presence of *x*<sup>−1</sup> and (1 − *x*)<sup>−1</sup> in the ordering.

By the way, those rules can be used for . Take for example the identity:

*x*(1 − *x*)<sup>−1</sup> = (1 − *x*)<sup>−1</sup>*x*

One can verify this identity by substituting the GB using:

    NCReplaceRepeated[x ** inv[1 - x] - inv[1 - x] ** x, rules]

which in this cases results in `0`, thus verifying the identity.

?? STOPED HERE ??

Next we illustrate an extremely valuable simplification command. The following example performs the same computation as the previous command, although one does not have to type in *r**e**s**o**l* explicitly. More generally one does not have to type in relations involving the definition of inverse explicitly. Beware, `NCSimplifyRationalX1` picks its own order on variables and completely ignores any order that you might have set.

    << NCSRX1.m
    NCSimplifyRationalX1[{x**x**x,x+Inv[z]**Inv[1-z]},{x**x-a},3]
    {a ** x, x + Inv[1 - z] + inv[z]}

WARNING: Never use inv\[  \] with NCGB since it has special properties given to it in NCAlgebra and these are not recognized by the C++ code behind NCGB

Interlude: ordering on variables and monomials
----------------------------------------------

As seen above, one needs to declare a *monomial order* before making a Gröbner Basis. There are various monomial orders which can be used when computing Gröbner Basis. The most common are *lexicographic* and *graded lexicographic* orders. We consider also *multi-graded lexicographic* orders.

Lexicographic and multi-graded lexicographic orders are examples of elimination orderings. An elimination ordering is an ordering which is used for solving for some of the variables in terms of others.

We now discuss each of these types of orders.

### Lex Order: the simplest elimination order

To impose lexicographic order, say *a* ≪ *b* ≪ *x* ≪ *y* on *a*, *b*, *x* and *y*, one types

    SetMonomialOrder[a,b,x,y];

This order is useful for attempting to solve for *y* in terms of *a*, *b* and *x*, since the highest priority of the GB algorithm is to produce polynomials which do not contain *y*. If producing high order polynomials is a consequence of this fanaticism so be it. Unlike graded orders, lex orders pay little attention to the degree of terms. Likewise its second highest priority is to eliminate *x*.

Once this order is set, one can use all of the commands in the preceeding section in exactly the same form.

We now give a simple example how one can solve for *y* given that *a*,*b*,*x* and *y* satisfy the equations:
$$
\\begin{aligned}
-b\\, x + x\\, y  \\, a + x\\, b \\, a \\,  a &= 0 \\\\
x \\, a-1&=0 \\\\
a\\, x-1&=0
\\end{aligned}
$$

The command

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4]

produces the Gröbner basis:

    {y -> -b**a+a**b**x**x, a**x -> 1, x**a -> 1}

after two iterations.

Now, we change the order to

    SetMonomialOrder[y,x,b,a];

and do the same `NCMakeGB` as above:

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4];
    ColumnForm[%]

which, this time, results in

    x**a -> 1
    a**x -> 1
    x**b**a -> -x**y+b**x**x
    b**a**a -> -y**a+a**b**x
    x**b**b**a -> -x**b**y-x**y**b**x**x+b**x**x**b**x**x
    b**x**x**x -> x**b+x**y**x
    b**a**b**a -> -y**y-b**a**y-y**b**a+a**b**x**b**x**x
    a**b**x**x -> y+b**a
    b**a**b**b**a -> -y**b**y-b**a**b**y-y**b**b**a-y**y**b**x**x-
        > b**a**y**b**x**x+a**b**x**b**x**x**b**x**x

which is not a Gröbner basis since the algorithm was interrupted at 4 iterations. Note the presence of the rule

    a**b**x**x -> y + b**a

which shows that the order is not set up to solve for *y* in terms of the other variables in the sense that *y* is not on the left hand side of this rule (but a human could easily solve for *y* using this rule). Also the algorithm created a number of other relations which involved *y*. See \[CoxLittleOShea\].

### Graded lex ordering: A non-elimination order

To impose graded lexicographic order, say *a* &lt; *b* &lt; *x* &lt; *y* on *a*, *b*, *x* and *y*, one types

    SetMonomialOrder[{a,b,x,y}];

This ordering puts high degree monomials high in the order. Thus it tries to decrease the total degree of expressions. A call to

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4];
    ColumnForm[%]

now produces

    a**x -> 1
    x**a -> 1
    b**a**a -> -y**a+a**b**x
    x**b**a -> -x**y+b**x**x
    a**b**x**x -> y+b**a
    b**x**x**x -> x**b+x**y**x
    a**b**x**b**x**x -> y**y+b**a**y+y**b**a+b**a**b**a
    b**x**x**b**x**x -> x**b**y+x**b**b**a+x**y**b**x**x
    a**b**x**b**x**b**x**x -> y**y**y+b**a**y**y+y**b**a**y+y**y**b**a+
        > b**a**b**a**y+b**a**y**b**a+y**b**a**b**a+b**a**b**a**b**a
    b**x**x**b**x**b**x**x -> x**b**y**y+x**b**b**a**y+x**b**y**b**a
        > +x**b**b**a**b**a+x**y**b**x**b**x**x
    a**b**x**b**x**b**x**b**x**x -> y**y**y**y+b**a**y**y**y+
        > y**b**a**y**y+y**y**b**a**y+y**y**y**b**a+b**a**b**a**y**y+
        > b**a**y**b**a**y+b**a**y**y**b**a+y**b**a**b**a**y+
        > y**b**a**y**b**a+y**y**b**a**b**a+b**a**b**a**b**a**y+
        > b**a**b**a**y**b**a+b**a**y**b**a**b**a+y**b**a**b**a**b**a+
        > b**a**b**a**b**a**b**a

which again fails to be a Gröbner basis and does not eliminate *y*. Instead, it tries to decrease the total degree of expressions involving *a*, *b*, *x*, and *y*.

### Multigraded lex ordering : a variety of elimination orders

There are other useful monomial orders which one can use other than graded lex and lex. Another type of order is what we call multigraded lex and is a mixture of graded lex and lex order. To impose multi-graded lexicographic order, say *a* &lt; *b* &lt; *x* ≪ *y* on *a*, *b*, *x* and *y*, one types

    SetMonomialOrder[{a,b,x},y];

which separates *y* from the remaining variables. This time, a call to

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4];
    ColumnForm[%]

yields

    y -> -b**a+a**b**x**x
    a**x -> 1
    x**a -> 1

which not only eliminates *y* but is also Gröbner basis, calculated after 2 iterations.

For an intuitive idea of why multigraded lex is helpful, we think of *a*, *b*, and *x* as corresponding to variables in some engineering problem which represent quantities which are known and *y* to be unknown. The fact that *a*, *b* and *x* are in the top level indicates that we are very interested in solving for *y* in terms of *a*, *b*, and *x*, but are not willing to solve for, say *x*, in terms of expressions involving *y*.

This situation is so common that we provide the commands `SetKnowns` and `SetUnknowns`. The above ordering would be obtained after setting

    SetKnowns[a,b,x];
    SetUnknowns[y];

Reducing a polynomial by a GB
-----------------------------

Now we reduce a polynomial or ListOfPolynomials by a GB or by any ListofPolynomials2. First we convert ListOfPolynomials2 to rules subordinate to the monomial order which is currently in force in our session.

For example, let us continue the session above with

    ListOfRules2 = PolyToRule[ourGB]

results in

    {x**x->a,b->a,y**x->a,a**x->a,x**a->a,y**a->a, a**a->a} 

To reduce ListOfPolynomials by ListOfRules2 use the command

    Reduction[ ListofPolynomials, ListofRules2]
          

For example, to reduce the polynomial

    poly = a**x**y**x**x + x**a**x**y + x**x**y**y

in our session type

    Reduction[ { poly }, ListOfRules2 ]

Simplifying Expressions
-----------------------

Suppose we want to simplify the expression $a^3 b^3 -c $ assuming that we know *a**b* = 1 and *b**a* = *b*.

First NCAlgebra requires us to declare the variables to be noncommutative.

    SetNonCommutative[a,b,c]

Now we must set an order on the variables *a*, *b* and *c*.

    SetMonomialOrder[{a,b,c}]

Later we explain what this does, in the context of a more complicated example where the command really matters. Here any order will do. We now simplify the expression *a*<sup>3</sup>*b*<sup>3</sup> − *c* by typing

    NCSimplifyAll[{a**a**a**b**b**b -c}, {a**b-1,b**a- b}, 3]

you get the answer as the following Mathematica output

    {1 - c} 

The number 3 indicates how hard you want to try (how long you can stand to wait) to simplify your expression.

The way the previously described command `NCSimplifyAll` works is

    NCSimplifyAll[ ListofPolynomials, ListofPolynomials2] =
                 Reduction[ ListofPolynomials, 
                          PolyToRule[NCMakeGB[ListofPolynomials2,10]]]

NCGB Facilitates Natural Notation
---------------------------------

Now we turn to a more complicated (though mathematically intuitive) notation. Also we give some more examples of Simplification and GB manufacture. We shall use the variables

    y, Inv[y], Inv[1-y], a {\rm\ and\ } x.

In NCAlgebra, lower case letters are noncommutative by default, and functions of noncommutative variables are noncommutative, so the `SetNonCommutative` command, while harmless, is not necessary.

Using *I**n**v*\[\] has the advantage that our TeX display commands recognize it and treat it wisely. Also later we see that the command `NCMakeRelations` generates defining relations for *I**n**v*\[\] automatically.

### A Simplification example

We want to simplify a polynomial in the variables of

We begin by setting the variables noncommutative with the following command.

    SetNonCommutative[y, Inv[y], Inv[1-y], a, x]

Next we must give the computer a precise idea of what we mean by `simple" versus`complicated". This formally corresponds to specifying an order on the indeterminates. If *I**n**v*\[*y*\] and *I**n**v*\[1 − *y*\] are going to stand for the inverses of *y* and 1 − *y* respectively, as the notation suggests, then the order
*y* &lt; *I**n**v*\[*y*\]&lt;*I**n**v*\[1 − *y*\]&lt;*a* &lt; *x*
 sits well with intuition, since the matrix *y* is \`\`simpler" than (1 − *y*)<sup>−1</sup>.

There are many orders which \`\`sit well with intuition". Perhaps the order *I**n**v*\[*y*\]&lt;*y* &lt; *I**n**v*\[1 − *y*\]&lt;*a* &lt; *x* does not set well, since, if possible, it would be preferable to express an answer in terms of *y*,rather than *y*<sup>−1</sup>.} To set this order input \\footnote{This sets a graded lexicographic on the monic monomials involving the variables *y*, *I**n**v*\[*y*\], *I**n**v*\[1 − *y*\], *a* and *x* with *y* &lt; *I**n**v*\[*y*\]&lt;*I**n**v*\[1 − *y*\]&lt;*a* &lt; *x*.

    SetMonomialOrder[{ y, Inv[y], Inv[1-y], a, x}]

Suppose that we want to connect the Mathematica variables *I**n**v*\[*y*\] with the mathematical idea of the inverse of *y* and *I**n**v*\[1 − *y*\] with the mathematical idea of the inverse of 1 − *y*. Then just type in the defining relations for the inverses involved.

    resol = {y ** Inv[y] == 1,   Inv[y] ** y == 1, 
            (1 - y) ** Inv[1 - y] == 1,   Inv[1 - y] ** (1 - y) == 1}

    {y ** Inv[y] == 1, Inv[y] ** y == 1, 
       (1 - y) ** Inv[1 - y] == 1, Inv[1 - y] ** (1 - y) == 1}

As an example of simplification, we simplify the two expressions *x* \* \**x* and *x* + *I**n**v*\[*y*\]\* \* *I**n**v*\[1 − *y*\] assuming that *y* satisfies *r**e**s**o**l* and *x* \* \**x* = *a*. The following command computes a Gröbner Basis for the union of *r**e**s**o**l* and {*x*<sup>2</sup> − *a*} and simplifies the expressions *x* \* \**x* and *x* + *I**n**v*\[*y*\]\* \* *I**n**v*\[1 − *y*\] using the Gröbner Basis. Experts will note that since we are using an iterative Gröbner Basis algorithm which may not terminate, we must set a limit on how many iterations we permit; here we specify *at most* 3 iterations.

    NCSimplifyAll[{x**x,x+Inv[y]**Inv[1-y]},Join[{x**x-a},resol],3]

    {a, x + Inv[1 - y] + Inv[y]}

We name the variable *I**n**v*\[*y*\], because this has more meaning to the user than would using a single letter. *I**n**v*\[*y*\] has the same status as a single letter with regard to all of the commands which we have demonstrated.

Next we illustrate an extremely valuable simplification command. The following example performs the same computation as the previous command, although one does not have to type in *r**e**s**o**l* explicitly. More generally one does not have to type in relations involving the definition of inverse explicitly. Beware, `NCSimplifyRationalX1` picks its own order on variables and completely ignores any order that you might have set.

    << NCSRX1.m
    NCSimplifyRationalX1[{x**x**x,x+Inv[z]**Inv[1-z]},{x**x-a},3]
    {a ** x, x + Inv[1 - z] + inv[z]}

WARNING: Never use inv\[  \] with NCGB since it has special properties given to it in NCAlgebra and these are not recognized by the C++ code behind NCGB

MakingGB's and Inv\[\], Tp\[\]
------------------------------

Here is another GB example. This time we use the fancy `Inv[]` notation.

    << NCGB.m
    SetNonCommutative[y, Inv[y], Inv[1-y], a, x]
    SetMonomialOrder[{ y, Inv[y], Inv[1-y], a, x}]
    resol = {y ** Inv[y] == 1,   Inv[y] ** y == 1,
             (1 - y) ** Inv[1 - y] == 1,   Inv[1 - y] **
             (1 - y) == 1}

The following commands makes a Gröbner Basis for *r**e**s**o**l* with respect to the monomial order which has been set.

    NCMakeGB[resol,3]
    {1 - Inv[1 - y] + y ** Inv[1 - y], -1 + y ** Inv[y],
    >    1 - Inv[1 - y] + Inv[1 - y] ** y, -1 + Inv[y] ** y,
    >    -Inv[1 - y] - Inv[y] + Inv[y] ** Inv[1 - y],
    >    -Inv[1 - y] - Inv[y] + Inv[1 - y] ** Inv[y]}

Simplification and GB's revisited
---------------------------------

### Changing polynomials to rules

The following command converts a list of relations to a list of rules subordinate to the monomial order specified above.

    PolyToRule[%]
    {y ** Inv[1 - y] -> -1 + Inv[1 - y], y ** Inv[y] -> 1,
    >    Inv[1 - y] ** y -> -1 + Inv[1 - y], Inv[y] ** y -> 1,
    >    Inv[y] ** Inv[1 - y] -> Inv[1 - y] + Inv[y],
    >    Inv[1 - y] ** Inv[y] -> Inv[1 - y] + Inv[y]}

### Changing rules to polynomials

The following command converts a list of rules to a list of relations.

    PolyToRule[%]
    {1 - Inv[1 - y] + y ** Inv[1 - y], -1 + y ** Inv[y],
    >    1 - Inv[1 - y] + Inv[1 - y] ** y, -1 + Inv[y] ** y,
    >    -Inv[1 - y] - Inv[y] + Inv[y] ** Inv[1 - y],
    >    -Inv[1 - y] - Inv[y] + Inv[1 - y] ** Inv[y]}

### Simplifying using a GB revisited

We can apply the rules in repeatedly to an expression to put it into \`\`canonical form." Often the canonical form is simpler than what we started with.

    Reduction[{Inv[y]**Inv[1-y] - Inv[y]}, Out[9]]
    {Inv[1 - y]}

Saving lots of time when typing
-------------------------------

One can save time in inputting various types of starting relations easily by using the command `NCMakeRelations`.

    << NCMakeRelations.m             
    NCMakeRelations[{Inv,y,1-y}]
    {y ** Inv[y] == 1, Inv[y] ** y == 1, (1 - y) ** Inv[1 - y] == 1,
    Inv[1 - y] ** (1 - y) == 1}

It is traditional in mathematics to use only single characters for indeterminates (e.g., *x*, *y* and *α*). However, we allow these indeterminate names as well as more complicated constructs such as
$$
Inv\[x\], Inv\[y\], Inv\[1-x\*\*y\] \\mbox{\\rm\\ and\\ } Rt\[x\] \\, .
$$
 In fact, we allow *f*\[*e**x**p**r*\] to be an indeterminate if *e**x**p**r* is an expression and *f* is a Mathematica symbol which has no Mathematica code associated to it (e.g., *f* = *D**u**m**m**y* or *f* = *J**o**e*, but NOT *f* = *L**i**s**t* or *f* = *P**l**u**s*). Also one should never use *i**n**v*\[*m*\] to represent *m*<sup>−1</sup> in the input of any of the commands explained within this document, because NCAlgebra has already assigned a meaning to *i**n**v*\[*m*\]. It knows that *i**n**v*\[*m*\]\* \* *m* is 1 which will transform your starting set of data prematurely.

Besides *I**n**v* many more functions are facilitated by NCMakeRelations, see Section .

### Saving time working in algebras with involution: NCAddTranspose, NCAddAdjoint

One can save time when working in an algebra with transposes or adjoints by using the command NCAddTranpose\[ \] or NCAddAdjoint\[ \]. These commands \`\`symmetrize" a set of relations by applying tp\[ \] or aj\[ \] to the relations and returning a list with the new expressions appended to the old ones. This saves the user the trouble of typing both *a* = *b* and *t**p*\[*a*\]=*t**p*\[*b*\].

    NCAddTranspose[ { a + b , tp[b] == c + a } ]

returns

    { a + b , tp[b] == c + a, b == tp[c] + tp[a], tp[a] + tp[b] }

### Saving time when setting orders: NCAutomaticOrder

One can save time in setting the monomial order by not including all of the indeterminants found in a set of relations, only the variables which they are made of. *N**C**A**u**t**o**m**a**t**i**c**O**r**d**e**r*\[*a**M**o**n**o**m**i**a**l**O**r**d**e**r*, $ aListOfPolynomials \]$ inserts all of the indeterminants found in *a**L**i**s**t**O**f**P**o**l**y**n**o**m**i**a**l**s* into *a**M**o**n**o**m**i**a**l**O**r**d**e**r* and sets this order.
NCAutomaticOrder\[ $aListOfPolynomials \]$ inserts all of the indeterminants found in *a**L**i**s**t**O**f**P**o**l**y**n**o**m**i**a**l**s* into the ambient monomial order. If x is an indeterminant found in *a**M**o**n**o**m**i**a**l**O**r**d**e**r* then any indeterminant whose symbolic representation is a function of x will appear next to x.

    NCAutomaticOrder[{{a},{b}},  { a**Inv[a]**tp[a] + tp[b]}]

would set the order to be *a* &lt; *t**p*\[*a*\]&lt;*I**n**v*\[*a*\]≪*b* &lt; *t**p*\[*b*\].

Pretty Output with Mathematica Notebooks and TeX
================================================

`NCAlgebra` comes with several utilities for facilitating formatting of expression in notebooks or using LaTeX.

Pretty Output
-------------

On a Mathematica notebook session the package [NCOutput](#NCOutput) can be used to control how nc expressions are displayed. `NCOutput` does not alter the internal representation of nc expressions, just the way they are displayed on the screen.

The function [NCSetOutput](#NCSetOutput) can be used to set the display options. For example:

    NCSetOutput[tp -> False, inv -> True];

makes the expression

    expr = inv[tp[a] + b]

be displayed as

`(tp[a] + b)`**<sup>−1</sup>

Conversely

    NCSetOutput[tp -> True, inv -> False];

makes `expr` be displayed as

`inv[a`**<sup>`T`</sup> `+ b]`

The default settings are

    NCSetOutput[tp -> True, inv -> True];

which makes `expr` be displayed as

`(a`**<sup>`T`</sup> `+ b)`**<sup>−1</sup>

The complete set of options and their default values are:

-   `NonCommutativeMultiply` (`False`): If `True` `x**y` is displayed as '`x` • `y`';
-   `tp` (`True`): If `True` `tp[x]` is displayed as '`x`**<sup>`T`</sup>';
-   `inv` (`True`): If `True` `inv[x]` is displayed as '`x`**<sup>−1</sup>';
-   `aj` (`True`): If `True` `aj[x]` is displayed as '`x`**<sup>\*</sup>';
-   `co` (`True`): If `True` `co[x]` is displayed as '$\\bar{\\mathtt{x}}$';
-   `rt` (`True`): If `True` `rt[x]` is displayed as '`x`**<sup>1/2</sup>'.

The special symbol `All` can be used to set all options to `True` or `False`, as in

    NCSetOutput[All -> True];

Using NCTeX
-----------

You can load NCTeX using the following command

    << NC` 
    << NCTeX`

`NCTeX` does not need `NCAlgebra` to work. You may want to use it even when not using NCAlgebra. It uses `NCRun`, which is a replacement for Mathematica's Run command to run `pdflatex`, `latex`, `divps`, etc.

**WARNING:** Mathematica does not come with LaTeX, dvips, etc. The package `NCTeX` does not install these programs but rather assumes that they have been previously installed and are available at the user's standard shell. Use the `Verbose` options to troubleshoot installation problems.

With `NCTeX` loaded you simply type `NCTeX[expr]` and your expression will be converted to a PDF image after being processed by `LaTeX`.

For example:

    expr = 1 + Sin[x + (y - z)/Sqrt[2]];
    NCTeX[expr]

produces

$1 + \\sin \\left ( x + \\frac{y - z}{\\sqrt{2}} \\right )$

If `NCAlgebra` is not loaded then `NCTeX` uses the built in `TeXForm` to produce the LaTeX expressions. If `NCAlgebra` is loaded, `NCTeXForm` is used. See [NCTeXForm](#NCTeXForm) for details.

Here is another example:

    expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}};
    NCTeX[expr]

that produces

$\\left( \\begin{array}{cc}  \\sin \\left(x+\\frac{y-z}{\\sqrt{2}}\\right)+1 &  \\frac{x}{y} \\\\  z & \\sqrt{5} n \\\\ \\end{array} \\right)$

In some cases Mathematica will have difficulty displaying certain PDF files. When this happens `NCTeX` will span a PDF viewer so that you can look at the formula. If your PDF viewer does not pop up automatically you can force it by passing the following option to `NCTeX`:

    expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}};
    NCTeX[exp, DisplayPDF -> True]

Here is another example were the current version of Mathematica fails to import the PDF:

    expr = Table[x^i y^(-j) , {i, 0, 10}, {j, 0, 30}];
    NCTeX[expr, DisplayPDF -> True]

You can also suppress Mathematica from importing the PDF altogether as well. This and other options are covered in detail in the next section.

### NCTeX Options

The following command:

    expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}};
    NCTeX[exp, DisplayPDF -> True, ImportPDF -> False]

uses `DisplayPDF -> True` to ensure that the PDF viewer is called and `ImportPDF -> False` to prevent Mathematica from displaying the formula inline. In other words, it displays the formula in the PDF viewer without trying to import the PDF into Mathematica. The default values for these options when using the Mathematica notebook interface are:

1.  `DisplayPDF` (`False`)
2.  `ImportPDF` (`True`)

When `NCTeX` is invoked using the command line interpreter version of Mathematica the defaults are:

1.  `DisplayPDF` (`False`)
2.  `ImportPDF` (`True`)

Other useful options and their default options are:

1.  `Verbose` (`False`),
2.  `BreakEquations` (`True`)
3.  `TeXProcessor` (`NCTeXForm`)

Set `BreakEquations -> True` to use the LaTeX package `beqn` to produce nice displays of long equations. Try the following example:

    expr = Series[Exp[x], {x, 0, 20}]
    NCTeX[expr]

Use `TexProcessor` to select your own `TeX` converter. If `NCAlgebra` is loaded then `NCTeXForm` is the default. Otherwise Mathematica's `TeXForm` is used.

If `Verbose -> True` you can see a detailed display of what is going on behing the scenes. This is very useful for debugging. For example, try:

    expr = BesselJ[2, x]
    NCTeX[exp, Verbose -> True]

to produce an output similar to the following one:

    * NCTeX - LaTeX processor for NCAlgebra - Version 0.1
    > Creating temporary file '/tmp/mNCTeX.tex'...
    > Processing '/tmp/mNCTeX.tex'...
    > Running 'latex -output-directory=/tmp/  /tmp/mNCTeX 1> "/tmp/mNCRun.out" 2> "/tmp/mNCRun.err"'...
    > Running 'dvips -o /tmp/mNCTeX.ps -E /tmp/mNCTeX 1> "/tmp/mNCRun.out" 2> "/tmp/mNCRun.err"'...
    > Running 'epstopdf  /tmp/mNCTeX.ps 1> "/tmp/mNCRun.out" 2> "/tmp/mNCRun.err"'...
    > Importing pdf file '/tmp/mNCTeX.pdf'...

Locate the files with extension .err as indicated by the verbose run of NCTeX to diagnose errors.

The remaining options:

1.  `PDFViewer` (`"open"`),
2.  `LaTeXCommand` (`"latex"`)
3.  `PDFLaTeXCommand` (`Null`)
4.  `DVIPSCommand` (`"dvips"`)
5.  `PS2PDFCommand` (`"epstopdf"`)

let you specify the names and, when appropriate, the path, of the corresponding programs to be used by `NCTeX`. Alternatively, you can also directly implement custom versions of

    NCRunDVIPS
    NCRunLaTeX
    NCRunPDFLaTeX
    NCRunPDFViewer
    NCRunPS2PDF

Those commands are invoked using `NCRun`. Look at the documentation for the package [NCRun](#NCRun) for more details.

Using NCTeXForm
---------------

`NCTeXForm` is a replacement for Mathematica's `TeXForm` that can handle noncommutative expressions. It works just as `TeXForm`. `NCTeXForm` is automatically loaded with `NCAlgebra` and becomes the default processor for `NCTeX`.

Here is an example:

    SetNonCommutative[a, b, c, x, y];
    exp = a ** x ** tp[b] - inv[c ** inv[a + b ** c] ** tp[y] + d]
    NCTeXForm[exp]

produces

    a.x.{b}^T-{\left(d+c.{\left(a+b.c\right)}^{-1}.{y}^T\right)}^{-1}

Note that the LaTeX output contains special code so that the expression looks neat on the screen. You can see the result using `NCTeX` to convert the expression to PDF. Try

    SetOptions[NCTeX, TeXProcessor -> NCTeXForm];
    NCTeX[exp]

to produce

*a*.*x*.*b*<sup>*T*</sup> − (*d*+*c*.(*a*+*b*.*c*)<sup>−1</sup>.*y*<sup>*T*</sup>)<sup>−1</sup>

`NCTeX` represents noncommutative products with a dot (`.`) in order to distinguish it from its commutative cousin. We can see the difference in an expression that has both commutative and noncommutative products:

    exp = 2 a ** b - 3 c ** d
    NCTeX[exp]

produces

2(*a*.*b*) − 3(*c*.*d*)

NCTeXForm handles lists and matrices as well. Here is a list:

    exp = {x, tp[x], x + y, x + tp[y], x + inv[y], x ** x}
    NCTeX[exp]

and its output:

{*x*, *x*<sup>*T*</sup>, *x* + *y*, *x* + *y*<sup>*T*</sup>, *x* + *y*<sup>−1</sup>, *x*.*x*}

and here is a matrix example:

    exp = {{x, y}, {y, z}}
    NCTeX[exp]

and its output:

$\\begin{bmatrix} x & y \\\\ y & z \\end{bmatrix}$

Here are some more examples:

    exp = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}}
    NCTeX[exp]

produces

$\\begin{bmatrix} 1+\\operatorname{sin}{\\left (x+\\frac{1}{\\sqrt{2}} \\left (y-z\\right )\\right )} & x {y}^{-1} \\\\ z & \\sqrt{5} n \\end{bmatrix}$

    exp = {inv[x + y], inv[x + inv[y]]}
    NCTeX[exp]

produces:

{(*x*+*y*)<sup>−1</sup>, (*x*+*y*<sup>−1</sup>)<sup>−1</sup>}

    exp = {Sin[x], x y, Sin[x] y, Sin[x + y], Cos[gamma], 
           Sin[alpha] tp[x] ** (y - tp[y]), (x + tp[x]) (y ** z), -tp[y], 1/2, 
           Sqrt[2] x ** y}
    NCTeX[exp]

produces:

$\\{ \\operatorname{sin}{x}, x y, y \\operatorname{sin}{x}, \\operatorname{sin}{\\left (x+y\\right )}, \\operatorname{cos}{\\gamma}, \\left({x}^T.\\left (y-{y}^T\\right )\\right ) \\operatorname{sin}{\\alpha}, y z \\left (x+{x}^T\\right ), -{y}^T, \\frac{1}{2}, \\sqrt{2} \\left(x.y\\right ) \\}$

    exp = inv[x + tp[inv[y]]]
    NCTeX[exp]

produces:

(*x*+*y*<sup>*T*</sup><sup>−1</sup>)<sup>−1</sup>

`NCTeXForm` does not know as many functions as `TeXForm`. In some cases `TeXForm` will produce better results. Compare:

    exp = BesselJ[2, x]
    NCTeX[exp, TeXProcessor -> NCTeXForm]

output:

BesselJ(2,*x*)

with

    NCTeX[exp, TeXProcessor -> TeXForm]

output:

*J*<sub>2</sub>(*x*)

It should be easy to customize `NCTeXForm` though. Just overload `NCTeXForm`. In this example:

    NCTeXForm[BesselJ[x_, y_]] := Format[BesselJ[x, y], TeXForm]

makes

    NCTeX[exp, TeXProcessor -> NCTeXForm]

produce

*J*<sub>2</sub>(*x*)

Semidefinite Programming
========================

Semidefinite Programs in Matrix Variables
-----------------------------------------

The package [NCSDP](#PackageNCSDP) allows the symbolic manipulation and numeric solution of semidefinite programs.

The package must be loaded using:

    << NCSDP`

Semidefinite programs consist of symbolic noncommutative expressions representing inequalities and a list of rules for data replacement. For example the semidefinite program:
$$
\\begin{aligned}
\\min\_Y \\quad & &lt;I,Y&gt; \\\\
\\text{s.t.} \\quad & A Y + Y A^T + I \\preceq 0 \\\\
            & Y \\succeq 0
\\end{aligned}
$$
 can be solved by defining the noncommutative expressions

    SNC[a, y];
    obj = {-1};
    ineqs = {a ** y + y ** tp[a] + 1, -y};

The inequalities are stored in the list `ineqs` in the form of noncommutative linear polyonomials in the variable `y` and the objective function constains the symbolic coefficients of the inner product, in this case `-1`. The reason for the negative signs in the objective as well as in the second inequality is that semidefinite programs are expected to be cast in the following *canonical form*:
$$
\\begin{aligned} 
  \\max\_y \\quad & &lt;b,y&gt; \\\\ 
  \\text{s.t.} \\quad & f(y) \\preceq 0 
\\end{aligned}
$$
 or, equivalently:
$$
\\begin{aligned} 
  \\max\_y \\quad & &lt;b,y&gt; \\\\ 
  \\text{s.t.} \\quad & f(y) + s = 0, \\quad s \\succeq 0
\\end{aligned}
$$

Semidefinite programs can be visualized using [`NCSDPForm`](#NCSDPForm) as in:

    vars = {y};
    NCSDPForm[ineqs, vars, obj]

The above commands produce a formatted output similar to the ones shown above.

In order to obtaining a numerical solution for an instance of the above semidefinite program one must provide a list of rules for data substitution. For example:

    A = {{0, 1}, {-1, -2}};
    data = {a -> A};

Equipped with the above list of rules representing a problem instance one can load [`SDPSylvester`](#SDPSylvester) and use `NCSDP` to create a problem instance as follows:

    << SDPSylvester`
    {abc, rules} = NCSDP[ineqs, vars, obj, data];

The resulting `abc` and `rules` objects are used for calculating the numerical solution using [`SDPSolve`](#SDPSolve). The command:

    {Y, X, S, flags} = SDPSolve[abc, rules];

produces an output like the folowing:

    Problem data:
    * Dimensions (total):
      - Variables             = 4
      - Inequalities          = 2
    * Dimensions (detail):
      - Variables             = {{2,2}}
      - Inequalities          = {2,2}
    Method:
    * Method                  = PredictorCorrector
    * Search direction        = NT
    Precision:
    * Gap tolerance           = 1.*10^(-9)
    * Feasibility tolerance   = 1.*10^(-6)
    * Rationalize iterates    = False
    Other options:
    * Debug level             = 0

     K     <B, Y>         mu  theta/tau      alpha     |X S|2    |X S|oo  |A* X-B|   |A Y+S-C|
    -------------------------------------------------------------------------------------------
     1  1.638e+00  1.846e-01  2.371e-01  8.299e-01  1.135e+00  9.968e-01  9.868e-16  2.662e-16
     2  1.950e+00  1.971e-02  2.014e-02  8.990e-01  1.512e+00  9.138e-01  2.218e-15  2.937e-16
     3  1.995e+00  1.976e-03  1.980e-03  8.998e-01  1.487e+00  9.091e-01  1.926e-15  3.119e-16
     4  2.000e+00  9.826e-07  9.826e-07  9.995e-01  1.485e+00  9.047e-01  8.581e-15  2.312e-16
     5  2.000e+00  4.913e-10  4.913e-10  9.995e-01  1.485e+00  9.047e-01  1.174e-14  4.786e-16
    -------------------------------------------------------------------------------------------
    * Primal solution is not strictly feasible but is within tolerance
    (0 <= max eig(A* Y - C) = 8.06666*10^-10 < 1.*10^-6 )
    * Dual solution is within tolerance
    (|| A X - B || = 1.96528*10^-9 < 1.*10^-6)
    * Feasibility radius = 0.999998
    (should be less than 1 when feasible)

The output variables `Y` and `S` are the *primal* solutions and `X` is the *dual* solution.

A symbolic dual problem can be calculated easily using [`NCSDPDual`](#NCSDPDual):

    {dIneqs, dVars, dObj} = NCSDPDual[ineqs, vars, obj];

The dual program for the example problem above is:
$$
\\begin{aligned} 
  \\max\_x \\quad & &lt;c,x&gt; \\\\ 
  \\text{s.t.} \\quad & f^\*(x) + b = 0, \\quad x \\succeq 0
\\end{aligned}
$$
 In the case of the above problem the dual program is
$$
\\begin{aligned}
\\max\_{X\_1, X\_2} \\quad & &lt;I,X\_1&gt; \\\\
\\text{s.t.} \\quad & A^T X\_1 + X\_1 A -X\_2 - I = 0 \\\\
            & X\_1 \\succeq 0, \\\\
        & X\_2 \\succeq 0
\\end{aligned}
$$
 which can be visualized using [`NCSDPDualForm`](#NCSDPDualForm) using:

    NCSDPDualForm[dIneqs, dVars, dObj]

Semidefinite Programs in Vector Variables
-----------------------------------------

The package [SDP](#SDP) provides a crude and not very efficient way to define and solve semidefinite programs in standard form, that is vectorized. You do not need to load `NCAlgebra` if you just want to use the semidefinite program solver. But you still need to load `NC` as in:

    << NC`
    << SDP`

Semidefinite programs are optimization problems of the form:
$$
\\begin{aligned}
  \\min\_{y, S} \\quad & b^T y \\\\
  \\text{s.t.} \\quad & A y + c = S \\\\
                    & S \\succeq 0
\\end{aligned}
$$
 where *S* is a symmetric positive semidefinite matrix and *y* is a vector of decision variables.

A user can input the problem data, the triplet (*A*, *b*, *c*), or use the following convenient methods for producing data in the proper format.

For example, problems can be stated as:
$$
\\begin{aligned} 
  \\min\_y \\quad & f(y), \\\\
  \\text{s.t.} \\quad & G(y) &gt;= 0
\\end{aligned}
$$
 where *f*(*y*) and *G*(*y*) are affine functions of the vector of variables *y*.

Here is a simple example:

    y = {y0, y1, y2};
    f = y2;
    G = {y0 - 2, {{y1, y0}, {y0, 1}}, {{y2, y1}, {y1, 1}}};

The list of constraints in `G` is to be interpreted as:
$$
\\begin{aligned} 
  y\_0 - 2 \\geq 0, \\\\
  \\begin{bmatrix} y\_1 & y\_0 \\\\ y\_0 & 1 \\end{bmatrix} \\succeq 0, \\\\
  \\begin{bmatrix} y\_2 & y\_1 \\\\ y\_1 & 1 \\end{bmatrix} \\succeq 0.
\\end{aligned}
$$
 The function [`SDPMatrices`](#SDPMatrices) convert the above symbolic problem into numerical data that can be used to solve an SDP.

    abc = SDPMatrices[f, G, y]

All required data, that is *A*, *b*, and *c*, is stored in the variable `abc` as Mathematica's sparse matrices. Their contents can be revealed using the Mathematica command `Normal`.

    Normal[abc]

The resulting SDP is solved using [`SDPSolve`](#SDPSolve):

    {Y, X, S, flags} = SDPSolve[abc];

The variables `Y` and `S` are the *primal* solutions and `X` is the *dual* solution. Detailed information on the computed solution is found in the variable `flags`.

The package `SDP` is built so as to be easily overloaded with more efficient or more structure functions. See for example [SDPFlat](#SDPFlat) and [SDPSylvester](#SDPSylvester).

Introduction
============

Each following chapter describes a `Package` inside *NCAlgebra*.

Packages are automatically loaded unless otherwise noted.

NonCommutativeMultiply
======================

**NonCommutativeMultiply** is the main package that provides noncommutative functionality to Mathematica's native `NonCommutativeMultiply` bound to the operator `**`.

Members are:

-   [aj](#aj)
-   [co](#co)
-   [Id](#Id)
-   [inv](#inv)
-   [tp](#tp)
-   [rt](#rt)
-   [CommutativeQ](#CommutativeQ)
-   [NonCommutativeQ](#NonCommutativeQ)
-   [SetCommutative](#SetCommutative)
-   [SetNonCommutative](#SetNonCommutative)
-   [Commutative](#Commutative)
-   [CommuteEverything](#CommuteEverything)
-   [BeginCommuteEverything](#BeginCommuteEverything)
-   [EndCommuteEverything](#EndCommuteEverything)
-   [ExpandNonCommutativeMultiply](#ExpandNonCommutativeMultiply)

aj
--

`aj[expr]` is the adjoint of expression `expr`. It is a conjugate linear involution.

See also: [tp](#tp), [co](#co).

co
--

`co[expr]` is the conjugate of expression `expr`. It is a linear involution.

See also: [aj](#aj).

Id
--

`Id` is noncommutative multiplicative identity. Actually Id is now set equal `1`.

inv
---

`inv[expr]` is the 2-sided inverse of expression `expr`.

rt
--

`rt[expr]` is the root of expression `expr`.

tp
--

`tp[expr]` is the tranpose of expression `expr`. It is a linear involution.

See also: [aj](#tp), [co](#co).

CommutativeQ
------------

`CommutativeQ[expr]` is *True* if expression `expr` is commutative (the default), and *False* if `expr` is noncommutative.

See also: [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

NonCommutativeQ
---------------

`NonCommutativeQ[expr]` is equal to `Not[CommutativeQ[expr]]`.

See also: [CommutativeQ](#CommutativeQ).

SetCommutative
--------------

`SetCommutative[a,b,c,...]` sets all the *Symbols* `a`, `b`, `c`, ... to be commutative.

See also: [SetNonCommutative](#SetNonCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

SetNonCommutative
-----------------

`SetNonCommutative[a,b,c,...]` sets all the *Symbols* `a`, `b`, `c`, ... to be noncommutative.

See also: [SetCommutative](#SetCommutative), [CommutativeQ](#CommutativeQ), [NonCommutativeQ](#NonCommutativeQ).

Commutative
-----------

`Commutative[symbol]` is commutative even if `symbol` is noncommutative.

See also: [CommuteEverything](#CommuteEverything), [CommutativeQ](#CommutativeQ), [SetCommutative](#SetCommutative), [SetNonCommutative](#SetNonCommutative).

CommuteEverything
-----------------

`CommuteEverything[expr]` is an alias for [BeginCommuteEverything](#BeginCommuteEverything).

See also: [BeginCommuteEverything](#BeginCommuteEverything), [Commutative](#Commutative).

BeginCommuteEverything
----------------------

`BeginCommuteEverything[expr]` sets all symbols appearing in `expr` as commutative so that the resulting expression contains only commutative products or inverses. It issues messages warning about which symbols have been affected.

`EndCommuteEverything[]` restores the symbols noncommutative behaviour.

`BeginCommuteEverything` answers the question *what does it sound like?*

See also: [EndCommuteEverything](#EndCommuteEverythning), [Commutative](#Commutative).

EndCommuteEverything
--------------------

`EndCommuteEverything[expr]` restores noncommutative behaviour to symbols affected by `BeginCommuteEverything`.

See also: [BeginCommuteEverything](#BeginCommuteEverythning), [Commutative](#Commutative).

ExpandNonCommutativeMultiply
----------------------------

`ExpandNonCommutativeMultiply[expr]` expands out `**`s in `expr`.

For example

    ExpandNonCommutativeMultiply[a**(b+c)]

returns

    a**b+a**c.

Its aliases are `NCE`, and `NCExpand`.

NCCollect
=========

Members are:

-   [NCCollect](#NCCollect)
-   [NCCollectSelfAdjoint](#NCCollectSelfAdjoint)
-   [NCCollectSymmetric](#NCCollectSymmetric)
-   [NCStrongCollect](#NCStrongCollect)
-   [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint)
-   [NCStrongCollectSymmetric](#NCStrongCollectSymmetric)
-   [NCCompose](#NCCompose)
-   [NCDecompose](#NCDecompose)
-   [NCTermsOfDegree](#NCTermsOfDegree)

NCCollect
---------

`NCCollect[expr,vars]` collects terms of nc expression `expr` according to the elements of `vars` and attempts to combine them. It is weaker than NCStrongCollect in that only same order terms are collected togther. It basically is `NCCompose[NCStrongCollect[NCDecompose]]]`.

If `expr` is a rational nc expression then degree correspond to the degree of the polynomial obtained using [NCRationalToNCPolynomial](#NCRationalToNCPolynomial).

`NCCollect` also works with nc expressions instead of *Symbols* in vars. In this case nc expressions are replaced by new variables and `NCCollect` is called using the resulting expression and the newly created *Symbols*.

This command internally converts nc expressions into the special `NCPolynomial` format.

### Notes

While `NCCollect[expr, vars]` always returns mathematically correct expressions, it may not collect `vars` from as many terms as one might think it should.

See also: [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint), [NCRationalToNCPolynomial](#NCRationalToNCPolynomial).

NCCollectSelfAdjoint
--------------------

`NCCollectSelfAdjoint[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their adjoints without writing out the adjoints.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

NCCollectSymmetric
------------------

`NCCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

NCStrongCollect
---------------

`NCStrongCollect[expr,vars]` collects terms of expression `expr` according to the elements of `vars` and attempts to combine by association.

In the noncommutative case the Taylor expansion and so the collect function is not uniquely specified. The function `NCStrongCollect` often collects too much and while correct it may be stronger than you want.

For example, a symbol `x` will factor out of terms where it appears both linearly and quadratically thus mixing orders.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCCollect](#NCCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

NCStrongCollectSelfAdjoint
--------------------------

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSymmetric](#NCStrongCollectSymmetric).

NCStrongCollectSymmetric
------------------------

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCCollect](#NCCollect), [NCStrongCollect](#NCStrongCollect), [NCCollectSymmetric](#NCCollectSymmetric), [NCCollectSelfAdjoint](#NCCollectSelfAdjoint), [NCStrongCollectSelfAdjoint](#NCStrongCollectSelfAdjoint).

NCCompose
---------

`NCCompose[dec]` will reassemble the terms in `dec` which were decomposed by [`NCDecompose`](#NCDecompose).

`NCCompose[dec, degree]` will reassemble only the terms of degree `degree`.

The expression `NCCompose[NCDecompose[p,vars]]` will reproduce the polynomial `p`.

The expression `NCCompose[NCDecompose[p,vars], degree]` will reproduce only the terms of degree `degree`.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).

NCDecompose
-----------

`NCDecompose[p,vars]` gives an association of elements of the nc polynomial `p` in variables `vars` in which elements of the same order are collected together.

`NCDecompose[p]` treats all nc letters in `p` as variables.

This command internally converts nc expressions into the special `NCPolynomial` format.

Internally `NCDecompose` uses [`NCPDecompose`](#NCPDecompose).

See also: [NCCompose](#NCCompose), [NCPDecompose](#NCPDecompose).

NCTermsOfDegree
---------------

`NCTermsOfDegree[expr,vars,indices]` returns an expression such that each term has the right number of factors of the variables in `vars`.

For example,

    NCTermsOfDegree[x**y**x + x**w,{x,y},{2,1}]

returns `x**y**x` and

    NCTermsOfDegree[x**y**x + x**w,{x,y},{1,0}]

return `x**w`. It returns 0 otherwise.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also: [NCDecompose](#NCDecompose), [NCPDecompose](#NCPDecompose).

NCSimplifyRational
==================

**NCSimplifyRational** is a package with function that simplifies noncommutative expressions and certain functions of their inverses.

`NCSimplifyRational` simplifies rational noncommutative expressions by repeatedly applying a set of reduction rules to the expression. `NCSimplifyRationalSinglePass` does only a single pass.

Rational expressions of the form

    inv[A + terms]

are first normalized to

inv\[1 + terms/A\]/A

using `NCNormalizeInverse`.

For each `inv` found in expression, a custom set of rules is constructed based on its associated NC Groebner basis.

For example, if

    inv[mon1 + ... + K lead]

where `lead` is the leading monomial with the highest degree then the following rules are generated:

<table style="width:11%;">
<colgroup>
<col width="5%" />
<col width="5%" />
</colgroup>
<thead>
<tr class="header">
<th>Original</th>
<th>Transformed</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>inv[mon1 + ... + K lead] lead</td>
<td>(1 - inv[mon1 + ... + K lead] (mon1 + ...))/K</td>
</tr>
<tr class="even">
<td>lead inv[mon1 + ... + K lead]</td>
<td>(1 - (mon1 + ...) inv[mon1 + ... + K lead])/K</td>
</tr>
</tbody>
</table>

Finally the following pattern based rules are applied:

| Original                         | Transformed                     |
|----------------------------------|---------------------------------|
| inv\[a\] inv\[1 + K a b\]        | inv\[a\] - K b inv\[1 + K a b\] |
| inv\[a\] inv\[1 + K a\]          | inv\[a\] - K inv\[1 + K a\]     |
| inv\[1 + K a b\] inv\[b\]        | inv\[b\] - K inv\[1 + K a b\] a |
| inv\[1 + K a\] inv\[a\]          | inv\[a\] - K inv\[1 + K a\]     |
| inv\[1 + K a b\] a               | a inv\[1 + K b a\]              |
| inv\[A inv\[a\] + B b\] inv\[a\] | (1/A) inv\[1 + (B/A) a b\]      |
| inv\[a\] inv\[A inv\[a\] + K b\] | (1/A) inv\[1 + (B/A) b a\]      |

`NCPreSimplifyRational` only applies pattern based rules from the second table above. In addition, the following two rules are applied:

| Original             | Transformed              |
|----------------------|--------------------------|
| inv\[1 + K a b\] a b | (1 - inv\[1 + K a b\])/K |
| inv\[1 + K a\] a     | (1 - inv\[1 + K a\])/K   |
| a b inv\[1 + K a b\] | (1 - inv\[1 + K a b\])/K |
| a inv\[1 + K a\]     | (1 - inv\[1 + K a\])/K   |

Rules in `NCSimplifyRational` and `NCPreSimplifyRational` are applied repeatedly.

Rules in `NCSimplifyRationalSinglePass` and `NCPreSimplifyRationalSinglePass` are applied only once.

The particular ordering of monomials used by `NCSimplifyRational` is the one implied by the `NCPolynomial` format. This ordering is a variant of the deg-lex ordering where the lexical ordering is Mathematica's natural ordering.

Members are:

-   [NCNormalizeInverse](#NCNormalizeInverse)
-   [NCSimplifyRational](#NCSimplifyRational)
-   [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass)
-   [NCPreSimplifyRational](#NCPreSimplifyRational)
-   [NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass)

NCNormalizeInverse
------------------

`NCNormalizeInverse[expr]` transforms all rational NC expressions of the form `inv[K + b]` into `inv[1 + (1/K) b]/K` if `A` is commutative.

See also: [NCSimplifyRational](#NCSimplifyRational), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

NCSimplifyRational
------------------

`NCSimplifyRational[expr]` repeatedly applies `NCSimplifyRationalSinglePass` in an attempt to simplify the rational NC expression `expr`.

See also: [NCNormalizeInverse](#NCNormalizeInverse), [NCSimplifyRationalSinglePass](#NCSimplifyRationalSinglePass).

NCSimplifyRationalSinglePass
----------------------------

`NCSimplifyRationalSinglePass[expr]` applies a series of custom rules only once in an attempt to simplify the rational NC expression `expr`.

See also: [NCNormalizeInverse](#NCNormalizeInverse), [NCSimplifyRational](#NCSimplifyRational).

NCPreSimplifyRational
---------------------

`NCPreSimplifyRational[expr]` repeatedly applies `NCPreSimplifyRationalSinglePass` in an attempt to simplify the rational NC expression `expr`.

See also: [NCNormalizeInverse](#NCNormalizeInverse), [NCPreSimplifyRationalSinglePass](#NCPreSimplifyRationalSinglePass).

NCPreSimplifyRationalSinglePass
-------------------------------

`NCPreSimplifyRationalSinglePass[expr]` applies a series of custom rules only once in an attempt to simplify the rational NC expression `expr`.

See also: [NCNormalizeInverse](#NCNormalizeInverse), [NCPreSimplifyRational](#NCPreSimplifyRational).

NCDiff
======

**NCDiff** is a package containing several functions that are used in noncommutative differention of functions and polynomials.

Members are:

-   [NCDirectionalD](#NCDirectionalD)
-   [NCGrad](#NCGrad)
-   [NCHessian](#NCHessian)
-   [NCIntegrate](#NCIntegrate)

Members being deprecated:

-   [DirectionalD](#DirectionalD)

NCDirectionalD
--------------

`NCDirectionalD[expr, {var1, h1}, ...]` takes the directional derivative of expression `expr` with respect to variables `var1`, `var2`, ... successively in the directions `h1`, `h2`, ....

For example, if:

    expr = a**inv[1+x]**b + x**c**x

then

    NCDirectionalD[expr, {x,h}]

returns

    h**c**x + x**c**h - a**inv[1+x]**h**inv[1+x]**b

In the case of more than one variables `NCDirectionalD[expr, {x,h}, {y,k}]` takes the directional derivative of `expr` with respect to `x` in the direction `h` and with respect to `y` in the direction `k`.

See also: [NCGrad](#NCGrad), [NCHessian](#NCHessian).

NCGrad
------

`NCGrad[expr, var1, ...]` gives the nc gradient of the expression `expr` with respect to variables `var1`, `var2`, .... If there is more than one variable then `NCGrad` returns the gradient in a list.

The transpose of the gradient of the nc expression `expr` is the derivative with respect to the direction `h` of the trace of the directional derivative of `expr` in the direction `h`.

For example, if:

    expr = x**a**x**b + x**c**x**d

then its directional derivative in the direction `h` is

    NCDirectionalD[expr, {x,h}]

which returns

    h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d

and

    NCGrad[expr, x]

returns the nc gradient

    a**x**b + b**x**a + c**x**d + d**x**c

For example, if:

    expr = x**a**x**b + x**c**y**d

is a function on variables `x` and `y` then

    NCGrad[expr, x, y]

returns the nc gradient list

    {a**x**b + b**x**a + c**y**d, d**x**c}

**IMPORTANT**: The expression returned by NCGrad is the transpose or the adjoint of the standard gradient. This is done so that no assumption on the symbols are needed. The calculated expression is correct even if symbols are self-adjoint or symmetric.

See also: [NCDirectionalD](#NCDirectionalD).

NCHessian
---------

`NCHessian[expr, {var1, h1}, ...]` takes the second directional derivative of nc expression `expr` with respect to variables `var1`, `var2`, ... successively in the directions `h1`, `h2`, ....

For example, if:

    expr = y**inv[x]**y + x**a**x

then

    NCHessian[expr, {x,h}, {y,s}]

returns

    2 h**a**h + 2 s**inv[x]**s - 2 s**inv[x]**h**inv[x]**y -
    2 y**inv[x]**h**inv[x]**s + 2 y**inv[x]**h**inv[x]**h**inv[x]**y

In the case of more than one variables `NCHessian[expr, {x,h}, {y,k}]` takes the second directional derivative of `expr` with respect to `x` in the direction `h` and with respect to `y` in the direction `k`.

See also: [NCDiretionalD](#NCDirectionalD), [NCGrad](#NCGrad).

DirectionalD
------------

`DirectionalD[expr,var,h]` takes the directional derivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

**DEPRECATION NOTICE**: This syntax is limited to one variable and is being deprecated in favor of the more general syntax in [NCDirectionalD](#NCDirectionalD).

See also: [NCDirectionalD](#DirectionalD).

NCIntegrate
-----------

`NCIntegrate[expr,{var1,h1},...]` attempts to calculate the nc antiderivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

For example:

    NCIntegrate[x**h+h**x, {x,h}]

returns

    x**x

See also: [NCDirectionalD](#DirectionalD).

NCReplace
=========

**NCReplace** is a package containing several functions that are useful in making replacements in noncommutative expressions. It offers replacements to Mathematica's `Replace`, `ReplaceAll`, `ReplaceRepeated`, and `ReplaceList` functions.

Commands in this package replace the old `Substitute` and `Transform` family of command which are been deprecated. The new commands are much more reliable and work faster than the old commands. From the beginning, substitution was always problematic and certain patterns would be missed. We reassure that the call expression that are returned are mathematically correct but some opportunities for substitution may have been missed.

Members are:

-   [NCReplace](#NCReplace)
-   [NCReplaceAll](#NCReplaceAll)
-   [NCReplaceList](#NCReplaceList)
-   [NCReplaceRepeated](#NCReplaceRepeated)
-   [NCMakeRuleSymmetric](#NCMakeRuleSymmetric)
-   [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint)

NCReplace
---------

`NCReplace[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform the entire nc expression `expr`.

`NCReplace[expr,rules,levelspec]` applies `rules` to parts of `expr` specified by `levelspec`.

See also: [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

NCReplaceAll
------------

`NCReplaceAll[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform each part of the nc expression `expr`.

See also: [NCReplace](#NCReplace), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

NCReplaceList
-------------

`NCReplace[expr,rules]` attempts to transform the entire nc expression `expr` by applying a rule or list of rules `rules` in all possible ways, and returns a list of the results obtained.

`ReplaceList[expr,rules,n]` gives a list of at most `n` results.

See also: [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceRepeated](#NCReplaceRepeated).

NCReplaceRepeated
-----------------

`NCReplaceRepeated[expr,rules]` repeatedly performs replacements using rule or list of rules `rules` until `expr` no longer changes.

See also: [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList).

NCMakeRuleSymmetric
-------------------

`NCMakeRuleSymmetric[rules]` add rules to transform the transpose of the left-hand side of `rules` into the transpose of the right-hand side of `rules`.

See also: [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint), [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

NCMakeRuleSelfAdjoint
---------------------

`NCMakeRuleSelfAdjoint[rules]` add rules to transform the adjoint of the left-hand side of `rules` into the adjoint of the right-hand side of `rules`.

See also: [NCMakeRuleSymmetric](#NCMakeRuleSymmetric), [NCReplace](#NCReplace), [NCReplaceAll](#NCReplaceAll), [NCReplaceList](#NCReplaceList), [NCReplaceRepeated](#NCReplaceRepeated).

NCSelfAdjoint
=============

Members are:

-   [NCSymmetricQ](#NCSymmetricQ)
-   [NCSymmetricTest](#NCSymmetricTest)
-   [NCSymmetricPart](#NCSymmetricPart)
-   [NCSelfAdjointQ](#NCSelfAdjointQ)
-   [NCSelfAdjointTest](#NCSelfAdjointTest)

NCSymmetricQ
------------

`NCSymmetricQ[expr]` returns *True* if `expr` is symmetric, i.e. if `tp[exp] == exp`.

`NCSymmetricQ` attempts to detect symmetric variables using `NCSymmetricTest`.

See also: [NCSelfAdjointQ](#NCSelfAdjointQ), [NCSymmetricTest](#NCSymmetricTest).

NCSymmetricTest
---------------

`NCSymmetricTest[expr]` attempts to establish symmetry of `expr` by assuming symmetry of its variables.

`NCSymmetricTest[exp,options]` uses `options`.

`NCSymmetricTest` returns a list of two elements:

-   the first element is *True* or *False* if it succeeded to prove `expr` symmetric.
-   the second element is a list of the variables that were made symmetric.

The following options can be given:

-   `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
-   `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables;
-   `Strict`: treats as non-symmetric any variable that appears inside `tp`.

See also: [NCSymmetricQ](#NCSymmetricQ), [NCNCSelfAdjointTest](#NCSelfAdjointTest).

NCSymmetricPart
---------------

`NCSymmetricPart[expr]` returns the *symmetric part* of `expr`.

`NCSymmetricPart[exp,options]` uses `options`.

`NCSymmetricPart[expr]` returns a list of two elements:

-   the first element is the *symmetric part* of `expr`;
-   the second element is a list of the variables that were made symmetric.

`NCSymmetricPart[expr]` returns `{$Failed, {}}` if `expr` is not symmetric.

For example:

    {answer, symVars} = NCSymmetricPart[a ** x + x ** tp[a] + 1];

returns

    answer = 2 a ** x + 1
    symVars = {x}

The following options can be given:

-   `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
-   `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.
-   `Strict`: treats as non-symmetric any variable that appears inside `tp`.

See also: [NCSymmetricTest](#NCSymmetricTest).

NCSelfAdjointQ
--------------

`NCSelfAdjointQ[expr]` returns true if `expr` is self-adjoint, i.e. if `aj[exp] == exp`.

See also: [NCSymmetricQ](#NCSymmetricQ), [NCSelfAdjointTest](#NCSelfAdjointTest).

NCSelfAdjointTest
-----------------

`NCSelfAdjointTest[expr]` attempts to establish whether `expr` is self-adjoint by assuming that some of its variables are self-adjoint or symmetric. `NCSelfAdjointTest[expr,options]` uses `options`.

`NCSelfAdjointTest` returns a list of three elements:

-   the first element is *True* or *False* if it succeded to prove `expr` self-adjoint.
-   the second element is a list of variables that were made self-adjoint.
-   the third element is a list of variables that were made symmetric.

The following options can be given:

-   `SelfAdjointVariables`: list of variables that should be considered self-adjoint; use `All` to make all variables self-adjoint;
-   `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
-   `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.
-   `Strict`: treats as non-self-adjoint any variable that appears inside `aj`.

See also: [NCSelfAdjointQ](#NCSelfAdjointQ).

NCOutput
========

**NCOutput** is a package that can be used to beautify the display of noncommutative expressions. NCOutput does not alter the internal representation of nc expressions, just the way they are displayed on the screen.

Members are:

-   [NCSetOutput](#NCSetOutput)

NCSetOutput
-----------

`NCSetOutput[options]` controls the display of expressions in a special format without affecting the internal representation of the expression.

The following `options` can be given:

-   `NonCommutativeMultiply` (`False`): If `True` `x**y` is displayed as '`x` • `y`';
-   `tp` (`True`): If `True` `tp[x]` is displayed as '`x`**<sup>`T`</sup>';
-   `inv` (`True`): If `True` `inv[x]` is displayed as '`x`**<sup>−1</sup>';
-   `aj` (`True`): If `True` `aj[x]` is displayed as '`x`**<sup>\*</sup>';
-   `co` (`True`): If `True` `co[x]` is displayed as '$\\bar{\\mathtt{x}}$';
-   `rt` (`True`): If `True` `rt[x]` is displayed as '`x`**<sup>1/2</sup>';
-   `All`: Set all available options to `True` or `False`.

See also: [NCTex](#NCTeX), [NCTexForm](#NCTeXForm).

NCPolynomial
============

This package contains functionality to convert an nc polynomial expression into an expanded efficient representation that can have commutative or noncommutative coefficients.

For example the polynomial

    exp = a**x**b - 2 x**y**c**x + a**c

in variables `x` and `y` can be converted into an NCPolynomial using

    p = NCToNCPolynomial[exp, {x,y}]

which returns

    p = NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

Members are:

-   [NCPolynomial](#NCPolynomial)
-   [NCToNCPolynomial](#NCToNCPolynomial)
-   [NCPolynomialToNC](#NCPolynomialToNC)
-   [NCRationalToNCPolynomial](#NCRationalToNCPolynomial)
-   [NCPCoefficients](#NCPCoefficients)
-   [NCPTermsOfDegree](#NCPTermsOfDegree)
-   [NCPTermsOfTotalDegree](#NCPTermsOfTotalDegree)
-   [NCPTermsToNC](#NCPTermsToNC)
-   [NCPSort](#NCPSort)
-   [NCPDecompose](#NCPDecompose)
-   [NCPDegree](#NCPDegree)
-   [NCPMonomialDegree](#NCPMonomialDegree)
-   [NCPCompatibleQ](#NCPCompatibleQ)
-   [NCPSameVariablesQ](#NCPSameVariablesQ)
-   [NCPMatrixQ](#NCPMatrixQ)
-   [NCPLinearQ](#NCPLinearQ)
-   [NCPQuadraticQ](#NCPQuadraticQ)
-   [NCPNormalize](#NCPNormalize)

NCPolynomial
------------

`NCPolynomial[indep,rules,vars]` is an expanded efficient representation for an nc polynomial in `vars` which can have commutative or noncommutative coefficients.

The nc expression `indep` collects all terms that are independent of the letters in `vars`.

The *Association* `rules` stores terms in the following format:

    {mon1, ..., monN} -> {scalar, term1, ..., termN+1}

where:

-   `mon1, ..., monN`: are nc monomials in vars;
-   `scalar`: contains all commutative coefficients; and
-   `term1, ..., termN+1`: are nc expressions on letters other than the ones in vars which are typically the noncommutative coefficients of the polynomial.

`vars` is a list of *Symbols*.

For example the polynomial

    a**x**b - 2 x**y**c**x + a**c

in variables `x` and `y` is stored as:

    NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

NCPolynomial specific functions are prefixed with NCP, e.g. NCPDegree.

See also: [`NCToNCPolynomial`](#NCToNCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC), [`NCTermsToNC`](#NCTermsToNC).

NCToNCPolynomial
----------------

`NCToNCPolynomial[p, vars]` generates a representation of the noncommutative polynomial `p` in `vars` which can have commutative or noncommutative coefficients.

`NCToNCPolynomial[p]` generates an `NCPolynomial` in all nc variables appearing in `p`.

Example:

    exp = a**x**b - 2 x**y**c**x + a**c
    p = NCToNCPolynomial[exp, {x,y}]

returns

    NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

See also: [`NCPolynomial`](#NCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC).

NCPolynomialToNC
----------------

`NCPolynomialToNC[p]` converts the NCPolynomial `p` back into a regular nc polynomial.

See also: [`NCPolynomial`](#NCPolynomial), [`NCToNCPolynomial`](#NCToNCPolynomial).

NCRationalToNCPolynomial
------------------------

`NCRationalToNCPolynomial[r, vars]` generates a representation of the noncommutative rational expression `r` in `vars` which can have commutative or noncommutative coefficients.

`NCRationalToNCPolynomial[r]` generates an `NCPolynomial` in all nc variables appearing in `r`.

`NCRationalToNCPolynomial` creates one variable for each `inv` expression in `vars` appearing in the rational expression `r`. It returns a list of three elements:

-   the first element is the `NCPolynomial`;
-   the second element is the list of new variables created to replace `inv`s;
-   the third element is a list of rules that can be used to recover the original rational expression.

For example:

    exp = a**inv[x]**y**b - 2 x**y**c**x + a**c
    {p,rvars,rules} = NCRationalToNCPolynomial[exp, {x,y}]

returns

    p = NCPolynomial[a**c, <|{rat1**y}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y,rat1}]
    rvars = {rat1}
    rules = {rat1->inv[x]}

See also: [`NCToNCPolynomial`](#NCPolynomial), [`NCPolynomialToNC`](#NCPolynomialToNC).

NCPCoefficients
---------------

`NCPCoefficients[p, m]` gives all coefficients of the NCPolynomial `p` in the monomial `m`.

For example:

    exp = a**x**b - 2 x**y**c**x + a**c + d**x
    p = NCToNCPolynomial[exp, {x, y}]
    NCPCoefficients[p, {x}]

returns

    {{1, d, 1}, {1, a, b}}

and

    NCPCoefficients[p, {x**y, x}]

returns

    {{-2, 1, c, 1}}

See also: [`NCPTermsToNC`](#NCPTermsToNC).

NCPTermsOfDegree
----------------

`NCPTermsOfDegree[p,deg]` gives all terms of the NCPolynomial `p` of degree `deg`.

The degree `deg` is a list with the degree of each symbol.

For example:

    p = NCPolynomial[0, <|{x,y}->{{2,a,b,c}},
                           {x,x}->{{1,a,b,c}},
                           {x**x}->{{-1,a,b}}|>, {x,y}]
    NCPTermsOfDegree[p, {1,1}]

returns

    <|{x,y}->{{2,a,b,c}}|>

and

    NCPTermsOfDegree[p, {2,0}]

returns

    <|{x,x}->{{1,a,b,c}}, {x**x}->{{-1,a,b}}|>

See also: [`NCPTermsOfTotalDegree`](#NCPTermsOfTotalDegree),[`NCPTermsToNC`](#NCPTermsToNC).

NCPTermsOfTotalDegree
---------------------

`NCPTermsOfDegree[p,deg]` gives all terms of the NCPolynomial `p` of total degree `deg`.

The degree `deg` is the total degree.

For example:

    p = NCPolynomial[0, <|{x,y}->{{2,a,b,c}},
                           {x,x}->{{1,a,b,c}},
                           {x**x}->{{-1,a,b}}|>, {x,y}]
    NCPTermsOfDegree[p, 2]

returns

    <|{x,y}->{{2,a,b,c}},{x,x}->{{1,a,b,c}},{x**x}->{{-1,a,b}}|>

See also: [`NCPTermsOfDegree`](#NCPTermsOfDegree),[`NCPTermsToNC`](#NCPTermsToNC).

NCPTermsToNC
------------

`NCPTermsToNC` gives a nc expression corresponding to terms produced by `NCPTermsOfDegree` or `NCTermsOfTotalDegree`.

For example:

    terms = <|{x,x}->{{1,a,b,c}}, {x**x}->{{-1,a,b}}|>
    NCPTermsToNC[terms]

returns

    a**x**b**c-a**x**b

See also: [`NCPTermsOfDegree`](#NCPTermsOfDegree),[`NCPTermsOfTotalDegree`](#NCPTermsOfTotalDegree).

NCPPlus
-------

`NCPPlus[p1,p2,...]` gives the sum of the nc polynomials `p1`,`p2`,... .

NCPSort
-------

`NCPSort[p]` gives a list of elements of the NCPolynomial `p` in which monomials are sorted first according to their degree then by Mathematica's implicit ordering.

For example

    NCPSort[NCPolynomial[c + x**x - 2 y, {x,y}]]

will produce the list

    {c, -2 y, x**x}

See also: [NCPDecompose](#NCPDecompose), [NCDecompose](#NCDecompose), [NCCompose](#NCCompose).

NCPDecompose
------------

`NCPDecompose[p]` gives an association of elements of the NCPolynomial `p` in which elements of the same order are collected together.

For example

    NCPDecompose[NCPolynomial[a**x**b+c+d**x**e+a**x**e**x**b+a**x**y, {x,y}]]

will produce the Association

    <|{1,0}->a**x**b + d**x**e, {1,1}->a**x**y, {2,0}->a**x**e**x**b, {0,0}->c|>

See also: [NCPSort](#NCPSort), [NCDecompose](#NCDecompose), [NCCompose](#NCCompose).

NCPDegree
---------

`NCPDegree[p]` gives the degree of the NCPolynomial `p`.

See also: [`NCPMonomialDegree`](#NCPMonomialDegree).

NCPMonomialDegree
-----------------

`NCPDegree[p]` gives the degree of each monomial in the NCPolynomial `p`.

See also: [`NCDegree`](#NCPMonomialDegree).

NCPLinearQ
----------

`NCPLinearQ[p]` gives True if the NCPolynomial `p` is linear.

See also: [`NCPQuadraticQ`](#NCPQuadraticQ).

NCPQuadraticQ
-------------

`NCPQuadraticQ[p]` gives True if the NCPolynomial `p` is quadratic.

See also: [`NCPLinearQ`](#NCPLinearQ).

NCPCompatibleQ
--------------

`NCPCompatibleQ[p1,p2,...]` returns *True* if the polynomials `p1`,`p2`,... have the same variables and dimensions.

See also: [NCPSameVariablesQ](#NCPSameVariablesQ), [NCPMatrixQ](#NCPMatrixQ).

NCPSameVariablesQ
-----------------

`NCPSameVariablesQ[p1,p2,...]` returns *True* if the polynomials `p1`,`p2`,... have the same variables.

See also: [NCPCompatibleQ](#NCPCompatibleQ), [NCPMatrixQ](#NCPMatrixQ).

NCPMatrixQ
----------

`NCMatrixQ[p]` returns *True* if the polynomial `p` is a matrix polynomial.

See also: [NCPCompatibleQ](#NCPCompatibleQ).

NCPNormalize
------------

`NCPNormalizes[p]` gives a normalized version of NCPolynomial p where all factors that have free commutative products are collectd in the scalar.

This function is intended to be used mostly by developers.

See also: [`NCPolynomial`](#NCPolynomial)

NCSylvester
===========

**NCSylvester** is a package that provides functionality to handle linear polynomials in NC variables.

Members are:

-   [NCPolynomialToNCSylvester](#NCPolynomialToNCSylvester)
-   [NCSylvesterToNCPolynomial](#NCSylvesterToNCPolynomial)

NCPolynomialToNCSylvester
-------------------------

`NCPolynomialToNCSylvester[p]` gives an expanded representation for the linear `NCPolynomial` `p`.

`NCPolynomialToNCSylvester` returns a list with two elements:

-   the first is a the independent term;
-   the second is an association where each key is one of the variables and each value is a list with three elements:

-   the first element is a list of left NC symbols;
-   the second element is a list of right NC symbols;
-   the third element is a numeric `SparseArray`.

Example:

    p = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
    {p0,sylv} = NCPolynomialToNCSylvester[p,x]

produces

    p0 = 2
    sylv = <|x->{{a,c},{b,d},SparseArray[{{1,0},{0,1}}]}, 
             y->{{1},{1},SparseArray[{{1}}]}|>

See also: [NCSylvesterToNCPolynomial](#NCSylvesterToNCPolynomial), [NCPolynomial](#NCPolynomial).

NCSylvesterToNCPolynomial
-------------------------

`NCSylvesterToNCPolynomial[rep]` takes the list `rep` produced by `NCPolynomialToNCSylvester` and converts it back to an `NCPolynomial`.

`NCSylvesterToNCPolynomial[rep,options]` uses `options`.

The following `options` can be given: \* `Collect` (*True*): controls whether the coefficients of the resulting NCPolynomial are collected to produce the minimal possible number of terms.

See also: [NCPolynomialToNCSylvester](#NCPolynomialToNCSylvester), [NCPolynomial](#NCPolynomial).

NCQuadratic
===========

**NCQuadratic** is a package that provides functionality to handle quadratic polynomials in NC variables.

Members are:

-   [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric)
-   [NCMatrixOfQuadratic](#NCMatrixOfQuadratic)
-   [NCQuadratic](#NCQuadratic)
-   [NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial)

NCQuadratic
-----------

`NCQuadratic[p]` gives an expanded representation for the quadratic `NCPolynomial` `p`.

`NCQuadratic` returns a list with four elements:

-   the first element is the independent term;
-   the second represents the linear part as in [`NCSylvester`](#NCSylvester);
-   the third element is a list of left NC symbols;
-   the fourth element is a numeric `SparseArray`;
-   the fifth element is a list of right NC symbols.

Example:

    exp = d + x + x**x + x**a**x + x**e**x + x**b**y**d + d**y**c**y**d;
    vars = {x,y};
    p = NCToNCPolynomial[exp, vars];
    {p0,sylv,left,middle,right} = NCQuadratic[p];

produces

    p0 = d
    sylv = <|x->{{1},{1},SparseArray[{{1}}]}, y->{{},{},{}}|>
    left =  {x,d**y}
    middle = SparseArray[{{1+a+e,b},{0,c}}]
    right = {x,y**d}

See also: [NCSylvester](#NCSylvester),[NCQuadraticToNCPolynomial](#NCQuadraticToNCPolynomial),[NCPolynomial](#NCPolynomial).

NCQuadraticMakeSymmetric
------------------------

`NCQuadraticMakeSymmetric[{p0, sylv, left, middle, right}]` takes the output of [`NCQuadratic`](#NCQuadratic) and produces, if possible, an equivalent symmetric representation in which `Map[tp, left] = right` and `middle` is a symmetric matrix.

See also: [NCQuadratic](#NCQuadratic).

NCMatrixOfQuadratic
-------------------

`NCMatrixOfQuadratic[p, vars]` gives a factorization of the symmetric quadratic function `p` in noncommutative variables `vars` and their transposes.

`NCMatrixOfQuadratic` checks for symmetry and automatically sets variables to be symmetric if possible.

Internally it uses [NCQuadratic](#NCQuadratic) and [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

It returns a list of three elements:

-   the first is the left border row vector;
-   the second is the middle matrix;
-   the third is the right border column vector.

For example:

    expr = x**y**x + z**x**x**z;
    {left,middle,right}=NCMatrixOfQuadratics[expr, {x}];

returns:

    left={x, z**x}
    middle=SparseArray[{{y,0},{0,1}}]
    right={x,x**z}

The answer from `NCMatrixOfQuadratics` always satisfies `p = MatMult[left,middle,right]`.

See also: [NCQuadratic](#NCQuadratic), [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

NCQuadraticToNCPolynomial
-------------------------

`NCQuadraticToNCPolynomial[rep]` takes the list `rep` produced by `NCQuadratic` and converts it back to an `NCPolynomial`.

`NCQuadraticToNCPolynomial[rep,options]` uses options.

The following options can be given:

-   `Collect` (*True*): controls whether the coefficients of the resulting `NCPolynomial` are collected to produce the minimal possible number of terms.

See also: [NCQuadratic](#NCQuadratic), [NCPolynomial](#NCPolynomial).

NCRational
==========

This package contains functionality to convert an nc rational expression into a descriptor representation.

For example the rational

    exp = 1 + inv[1 + x]

in variables `x` and `y` can be converted into an NCPolynomial using

    p = NCToNCPolynomial[exp, {x,y}]

which returns

    p = NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

Members are:

-   [NCRational](#NCRational)
-   [NCToNCRational](#NCToNCRational)
-   [NCRationalToNC](#NCRationalToNC)
-   [NCRationalToCanonical](#NCRationalToCanonical)
-   [CanonicalToNCRational](#CanonicalToNCRational)

-   [NCROrder](#NCROrder)
-   [NCRLinearQ](#NCRLinearQ)
-   [NCRStrictlyProperQ](#NCRStrictlyProperQ)

-   [NCRPlus](#NCRPlus)
-   [NCRTimes](#NCRTimes)
-   [NCRTranspose](#NCRTranspose)
-   [NCRInverse](#NCRInverse)

-   [NCRControllableSubspace](#NCRControllableSubspace)
-   [NCRControllableRealization](#NCRControllableRealization)
-   [NCRObservableRealization](#NCRObservableRealization)
-   [NCRMinimalRealization](#NCRMinimalRealization)

NCRational
----------

NCRational::usage

NCToNCRational
--------------

NCToNCRational::usage

NCRationalToNC
--------------

NCRationalToNC::usage

NCRationalToCanonical
---------------------

NCRationalToCanonical::usage

CanonicalToNCRational
---------------------

CanonicalToNCRational::usage

NCROrder
--------

NCROrder::usage

NCRLinearQ
----------

NCRLinearQ::usage

NCRStrictlyProperQ
------------------

NCRStrictlyProperQ::usage

NCRPlus
-------

NCRPlus::usage

NCRTimes
--------

NCRTimes::usage

NCRTranspose
------------

NCRTranspose::usage

NCRInverse
----------

NCRInverse::usage

NCRControllableRealization
--------------------------

NCRControllableRealization::usage

NCRControllableSubspace
-----------------------

NCRControllableSubspace::usage

NCRObservableRealization
------------------------

NCRObservableRealization::usage

NCRMinimalRealization
---------------------

NCRMinimalRealization::usage

NCMatMult
=========

Members are:

-   [tpMat](#tpMat)
-   [ajMat](#ajMat)
-   [coMat](#coMat)
-   [MatMult](#MatMult)
-   [NCInverse](#NCInverse)
-   [NCMatrixExpand](#NCMatrixExpand)

tpMat
-----

`tpMat[mat]` gives the transpose of matrix `mat` using `tp`.

See also: [ajMat](#tpMat), [coMat](#coMat), [MatMult](#MatMult).

ajMat
-----

`ajMat[mat]` gives the adjoint transpose of matrix `mat` using `aj` instead of `ConjugateTranspose`.

See also: [tpMat](#tpMat), [coMat](#coMat), [MatMult](#MatMult).

coMat
-----

`coMat[mat]` gives the conjugate of matrix `mat` using `co` instead of `Conjugate`.

See also: [tpMat](#tpMat), [ajMat](#coMat), [MatMult](#MatMult).

MatMult
-------

`MatMult[mat1, mat2, ...]` gives the matrix multiplication of `mat1`, `mat2`, ... using `NonCommutativeMultiply` rather than `Times`.

See also: [tpMat](#tpMat), [ajMat](#coMat), [coMat](#coMat).

### Notes

The experienced matrix analyst should always remember that the Mathematica convention for handling vectors is tricky.

-   `{{1,2,4}}` is a 1x3 *matrix* or a *row vector*;
-   `{{1},{2},{4}}` is a 3x1 *matrix* or a *column vector*;
-   `{1,2,4}` is a *vector* but **not** a *matrix*. Indeed whether it is a row or column vector depends on the context. We advise not to use *vectors*.

NCInverse
---------

`NCInverse[mat]` gives the nc inverse of the square matrix `mat`. `NCInverse` uses partial pivoting to find a nonzero pivot.

`NCInverse` is primarily used symbolically. Usually the elements of the inverse matrix are huge expressions. We recommend using `NCSimplifyRational` to improve the results.

See also: [tpMat](#tpMat), [ajMat](#coMat), [coMat](#coMat).

NCMatrixExpand
--------------

`NCMatrixExpand[expr]` expands `inv` and `**` of matrices appearing in nc expression `expr`. It effectively substitutes `inv` for `NCInverse` and `**` by `MatMult`.

See also: [NCInverse](#NCInverse), [MatMult](#MatMult).

NCMatrixDecompositions
======================

Members are:

-   Decompositions
    -   [NCLUDecompositionWithPartialPivoting](#NCLUDecompositionWithPartialPivoting)
    -   [NCLUDecompositionWithCompletePivoting](#NCLUDecompositionWithCompletePivoting)
    -   [NCLDLDecomposition](#NCLDLDecomposition)
-   Solvers
    -   [NCLowerTriangularSolve](#NCLowerTriangularSolve)
    -   [NCUpperTriangularSolve](#NCUpperTriangularSolve)
    -   [NCLUInverse](#NCLUInverse)
-   Utilities
    -   [NCLUCompletePivoting](#NCLUCompletePivoting)
    -   [NCLUPartialPivoting](#NCLUPartialPivoting)
    -   [NCLeftDivide](#NCLeftDivide)
    -   [NCRightDivide](#NCRightDivide)

NCLDLDecomposition
------------------

NCLeftDivide
------------

NCLowerTriangularSolve
----------------------

NCLUCompletePivoting
--------------------

NCLUDecompositionWithCompletePivoting
-------------------------------------

NCLUDecompositionWithPartialPivoting
------------------------------------

NCLUInverse
-----------

NCLUPartialPivoting
-------------------

NCMatrixDecompositions
----------------------

NCRightDivide
-------------

NCUpperTriangularSolve
----------------------

MatrixDecompositions
====================

**MatrixDecompositions** is a package that implements various linear algebra algorithms, such as *LU Decomposition* with *partial* and *complete pivoting*, and *LDL Decomposition*. The algorithms have been written with correctness and easy of customization rather than efficiency as the main goals. They were originally developed to serve as the core of the noncommutative linear algebra algorithms for [NCAlgebra](http://math.ucsd.edu/~ncalg). See [NCMatrixDecompositions](#NCMatrixDecompositions).

Members are:

-   Decompositions
    -   [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting)
    -   [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting)
    -   [LDLDecomposition](#LDLDecomposition)
-   Solvers
    -   [LowerTriangularSolve](#LowerTriangularSolve)
    -   [UpperTriangularSolve](#UpperTriangularSolve)
    -   [LUInverse](#LUInverse)
-   Utilities
    -   [GetLUMatrices](#GetLUMatrices)
    -   [GetLDUMatrices](#GetLDUMatrices)
    -   [GetDiagonal](#GetDiagonal)
    -   [LUPartialPivoting](#LUPartialPivoting)
    -   [LUCompletePivoting](#LUCompletePivoting)
    -   [LUNoPartialPivoting](#LUNoPartialPivoting)
    -   [LUNoCompletePivoting](#LUNoCompletePivoting)

LUDecompositionWithPartialPivoting
----------------------------------

`LUDecompositionWithPartialPivoting[m]` generates a representation of the LU decomposition of the rectangular matrix `m`.

`LUDecompositionWithPartialPivoting[m, options]` uses `options`.

`LUDecompositionWithPartialPivoting` returns a list of two elements:

-   the first element is a combination of upper- and lower-triangular matrices;
-   the second element is a vector specifying rows used for pivoting.

`LUDecompositionWithPartialPivoting` is similar in functionality with the built-in `LUDecomposition`. It implements a *partial pivoting* strategy in which the sorting can be configured using the options listed below. It also applies to general rectangular matrices as well as square matrices.

The triangular factors are recovered using [GetLUMatrices](#GetLUMatrices).

The following `options` can be given:

-   `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
-   `RightDivide` (`RightDivide`): function used to divide a vector by an entry;
-   `Dot` (`Dot`): function used to multiply vectors and matrices;
-   `Pivoting` (`LUPartialPivoting`): function used to sort rows for pivoting;
-   `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting), [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting), [GetLUMatrices](#GetLUMatrices), [LUPartialPivoting](#LUPartialPivoting).

LUDecompositionWithCompletePivoting
-----------------------------------

`LUDecompositionWithCompletePivoting[m]` generates a representation of the LU decomposition of the rectangular matrix `m`.

`LUDecompositionWithCompletePivoting[m, options]` uses `options`.

`LUDecompositionWithCompletePivoting` returns a list of four elements:

-   the first element is a combination of upper- and lower-triangular matrices;
-   the second element is a vector specifying rows used for pivoting;
-   the third element is a vector specifying columns used for pivoting;
-   the fourth element is the rank of the matrix.

`LUDecompositionWithCompletePivoting` implements a *complete pivoting* strategy in which the sorting can be configured using the options listed below. It also applies to general rectangular matrices as well as square matrices.

The triangular factors are recovered using [GetLUMatrices](#GetLUMatrices).

The following `options` can be given:

-   `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
-   `Divide` (`Divide`): function used to divide a vector by an entry;
-   `Dot` (`Dot`): function used to multiply vectors and matrices;
-   `Pivoting` (`LUCompletePivoting`): function used to sort rows for pivoting;

See also: [LUDecomposition](#LUDecomposition), [GetLUMatrices](#GetLUMatrices), [LUCompletePivoting](#LUCompletePivoting), [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting).

LDLDecomposition
----------------

`LDLDecomposition[m]` generates a representation of the LDL decomposition of the symmetric or self-adjoint matrix `m`.

`LDLDecomposition[m, options]` uses `options`.

`LDLDecomposition` returns a list of four elements:

-   the first element is a combination of upper- and lower-triangular matrices;
-   the second element is a vector specifying rows and columns used for pivoting;
-   the thir element is a vector specifying the size of the diagonal blocks; it can be 1 or 2;
-   the fourth element is the rank of the matrix.

`LUDecompositionWithCompletePivoting` implements a *Bunch-Parlett pivoting* strategy in which the sorting can be configured using the options listed below. It applies only to square symmetric or self-adjoint matrices.

The triangular factors are recovered using [GetLDUMatrices](#GetLDUMatrices).

The following `options` can be given:

-   `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
-   `RightDivide` (`RightDivide`): function used to divide a vector by an entry on the right;
-   `LeftDivide` (`LeftDivide`): function used to divide a vector by an entry on the left;
-   `Dot` (`Dot`): function used to multiply vectors and matrices;
-   `CompletePivoting` (`LUCompletePivoting`): function used to sort rows for complete pivoting;
-   `PartialPivoting` (`LUPartialPivoting`): function used to sort matrices for complete pivoting;
-   `Inverse` (`Inverse`): function used to invert 2x2 diagonal blocks;
-   `SelfAdjointQ` (`SelfAdjointMatrixQ`): function to test if matrix is self-adjoint;
-   `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting), [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting), [GetLUMatrices](#GetLUMatrices), [LUCompletePivoting](#LUCompletePivoting), [LUPartialPivoting](#LUPartialPivoting).

UpperTriangularSolve
--------------------

`UpperTriangularSolve[u, b]` solves the upper-triangular system of equations *u**x* = *b* using back-substitution.

For example:

    x = UpperTriangularSolve[u, b];

returns the solution `x`.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting), [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting), [LDLDecomposition](#LDLDecomposition).

LowerTriangularSolve
--------------------

`LowerTriangularSolve[l, b]` solves the lower-triangular system of equations *l**x* = *b* using forward-substitution.

For example:

    x = LowerTriangularSolve[l, b];

returns the solution `x`.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting), [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting), [LDLDecomposition](#LDLDecomposition).

LUInverse
---------

`LUInverse[a]` calculates the inverse of matrix `a`.

`LUInverse` uses the [LuDecompositionWithPartialPivoting](#LuDecompositionWithPartialPivoting) and the triangular solvers [LowerTriangularSolve](#LowerTriangularSolve) and [UpperTriangularSolve](#UpperTriangularSolve).

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting).

GetLUMatrices
-------------

`GetLUMatrices[m]` extracts lower- and upper-triangular blocks produced by `LDUDecompositionWithPartialPivoting` and `LDUDecompositionWithCompletePivoting`.

For example:

    {lu, p} = LUDecompositionWithPartialPivoting[A];
    {l, u} = GetLUMatrices[lu];

returns the lower-triangular factor `l` and upper-triangular factor `u`.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting), [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting).

GetLDUMatrices
--------------

`GetLDUMatrices[m,s]` extracts lower-, upper-triangular and diagonal blocks produced by `LDLDecomposition`.

For example:

    {ldl, p, s, rank} = LDLDecomposition[A];
    {l,d,u} = GetLDUMatrices[ldl,s];

returns the lower-triangular factor `l`, the upper-triangular factor `u`, and the block-diagonal factor `d`.

See also: [LDLDecomposition](#LDLDecomposition).

GetDiagonal
-----------

`GetDiagonal[m]` extracts the diagonal entries of matrix `m`.

`GetDiagonal[m, s]` extracts the block-diagonal entries of matrix `m` with block size `s`.

For example:

    d = GetDiagonal[{{1,-1,0},{-1,2,0},{0,0,3}}];

returns

    d = {1,2,3}

and

    d = GetDiagonal[{{1,-1,0},{-1,2,0},{0,0,3}}, {2,1}];

returns

    d = {{{1,-1},{-1,2}},3}

See also: [LDLDecomposition](#LDLDecomposition).

LUPartialPivoting
-----------------

`LUPartialPivoting[v]` returns the index of the element with largest absolute value in the vector `v`. If `v` is a matrix, it returns the index of the element with largest absolute value in the first column.

`LUPartialPivoting[v, f]` sorts with respect to the function `f` instead of the absolute value.

See also: [LUDecompositionWithPartialPivoting](#LUDecompositionWithPartialPivoting), [LUCompletePivoting](#LUCompletePivoting).

LUCompletePivoting
------------------

`LUCompletePivoting[m]` returns the row and column index of the element with largest absolute value in the matrix `m`.

`LUCompletePivoting[v, f]` sorts with respect to the function `f` instead of the absolute value.

See also: [LUDecompositionWithCompletePivoting](#LUDecompositionWithCompletePivoting), [LUPartialPivoting](#LUPartialPivoting).

NCConvexity
===========

**NCConvexity** is a package that provides functionality to determine whether a rational or polynomial noncommutative function is convex.

Members are:

-   [NCIndependent](#NCIndependent)
-   [NCConvexityRegion](#NCConvexityRegion)

NCIndependent
-------------

`NCIndependent[list]` attempts to determine whether the nc entries of `list` are independent.

Entries of `NCIndependent` can be nc polynomials or nc rationals.

For example:

    NCIndependent[{x,y,z}]

return *True* while

    NCIndependent[{x,0,z}]
    NCIndependent[{x,y,x}]
    NCIndependent[{x,y,x+y}]
    NCIndependent[{x,y,A x + B y}]
    NCIndependent[{inv[1+x]**inv[x], inv[x], inv[1+x]}]

all return *False*.

See also: [NCConvexity](#NCConvexity).

NCConvexityRegion
-----------------

`NCConvexityRegion[expr,vars]` is a function which can be used to determine whether the nc rational `expr` is convex in `vars` or not.

For example:

    d = NCConvexityRegion[x**x**x, {x}];

returns

    d = {2 x, -2 inv[x]}

from which we conclude that `x**x**x` is not convex in `x` because *x* ≻ 0 and −*x*<sup>−1</sup> ≻ 0 cannot simultaneously hold.

`NCConvexityRegion` works by factoring the `NCHessian`, essentially calling:

    hes = NCHessian[expr, {x, h}];

then

    {lt, mq, rt} = NCMatrixOfQuadratic[hes, {h}]

to decompose the Hessian into a product of a left row vector, `lt`, times a middle matrix, `mq`, times a right column vector, `rt`. The middle matrix, `mq`, is factored using the `NCLDLDecomposition`:

    {ldl, p, s, rank} = NCLDLDecomposition[mq];
    {lf, d, rt} = GetLDUMatrices[ldl, s];

from which the output of NCConvexityRegion is the a list with the block-diagonal entries of the matrix `d`.

See also: [NCHessian](#NCHessian), [NCMatrixOfQuadratic](#NCMatrixOfQuadratic), [NCLDLDecomposition](#NCLDLDecomposition).

NCRealization
=============

The package **NCRealization** implements an algorithm due to N. Slinglend for producing minimal realizations of nc rational functions in many nc variables. See "Toward Making LMIs Automatically".

It actually computes formulas similar to those used in the paper "Noncommutative Convexity Arises From Linear Matrix Inequalities" by J William Helton, Scott A. McCullough, and Victor Vinnikov. In particular, there are functions for calculating (symmetric) minimal descriptor realizations of nc (symmetric) rational functions, and determinantal representations of polynomials.

Members are:

-   Drivers:
    -   [NCDescriptorRealization](#NCDescriptorRealization)
    -   [NCMatrixDescriptorRealization](#NCMatrixDescriptorRealization)
    -   [NCMinimalDescriptorRealization](#NCMinimalDescriptorRealization)
    -   [NCDeterminantalRepresentationReciprocal](#NCDeterminantalRepresentationReciprocal)
    -   [NCSymmetrizeMinimalDescriptorRealization](#NCSymmetrizeMinimalDescriptorRealization)
    -   [NCSymmetricDescriptorRealization](#NCSymmetricDescriptorRealization)
    -   [NCSymmetricDeterminantalRepresentationDirect](#NCSymmetricDeterminantalRepresentationDirect)
    -   [NCSymmetricDeterminantalRepresentationReciprocal](#NCSymmetricDeterminantalRepresentationReciprocal)
    -   [NonCommutativeLift](#NonCommutativeLift)
-   Auxiliary:
    -   [PinnedQ](#PinnedQ)
    -   [PinningSpace](#PinningSpace)
    -   [TestDescriptorRealization](#TestDescriptorRealization)
    -   [SignatureOfAffineTerm](#SignatureOfAffineTerm)

NCDescriptorRealization
-----------------------

`NCDescriptorRealization[RationalExpression,UnknownVariables]` returns a list of 3 matrices `{C,G,B}` such that *C**G*<sup>−1</sup>*B* is the given `RationalExpression`. i.e. `MatMult[C,NCInverse[G],B] === RationalExpression`.

`C` and `B` do not contain any `UnknownsVariables` and `G` has linear entries in the `UnknownVariables`.

NCDeterminantalRepresentationReciprocal
---------------------------------------

`NCDeterminantalRepresentationReciprocal[Polynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[Polynomial]`. This uses the reciprocal algorithm: find a minimal descriptor realization of `inv[Polynomial]`, so `Polynomial` must be nonzero at the origin.

NCMatrixDescriptorRealization
-----------------------------

`NCMatrixDescriptorRealization[RationalMatrix,UnknownVariables]` is similar to `NCDescriptorRealization` except it takes a *Matrix* with rational function entries and returns a matrix of lists of the vectors/matrix `{C,G,B}`. A different `{C,G,B}` for each entry.

NCMinimalDescriptorRealization
------------------------------

`NCMinimalDescriptorRealization[RationalFunction,UnknownVariables]` returns `{C,G,B}` where `MatMult[C,NCInverse[G],B] == RationalFunction`, `G` is linear in the `UnknownVariables`, and the realization is minimal (may be pinned).

NCSymmetricDescriptorRealization
--------------------------------

`NCSymmetricDescriptorRealization[RationalSymmetricFunction, Unknowns]` combines two steps: `NCSymmetrizeMinimalDescriptorRealization[NCMinimalDescriptorRealization[RationalSymmetricFunction, Unknowns]]`.

NCSymmetricDeterminantalRepresentationDirect
--------------------------------------------

`NCSymmetricDeterminantalRepresentationDirect[SymmetricPolynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[SymmetricPolynomial]`. This uses the direct algorithm: Find a realization of 1 - NCSymmetricPolynomial,...

NCSymmetricDeterminantalRepresentationReciprocal
------------------------------------------------

`NCSymmetricDeterminantalRepresentationReciprocal[SymmetricPolynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[NCSymmetricPolynomial]`. This uses the reciprocal algorithm: find a symmetric minimal descriptor realization of `inv[NCSymmetricPolynomial]`, so NCSymmetricPolynomial must be nonzero at the origin.

NCSymmetrizeMinimalDescriptorRealization
----------------------------------------

`NCSymmetrizeMinimalDescriptorRealization[{C,G,B},Unknowns]` symmetrizes the minimal realization `{C,G,B}` (such as output from `NCMinimalRealization`) and outputs `{Ctilda,Gtilda}` corresponding to the realization `{Ctilda, Gtilda,Transpose[Ctilda]}`.

**WARNING:** May produces errors if the realization doesn't correspond to a symmetric rational function.

NonCommutativeLift
------------------

`NonCommutativeLift[Rational]` returns a noncommutative symmetric lift of `Rational`.

SignatureOfAffineTerm
---------------------

`SignatureOfAffineTerm[Pencil,Unknowns]` returns a list of the number of positive, negative and zero eigenvalues in the affine part of `Pencil`.

TestDescriptorRealization
-------------------------

`TestDescriptorRealization[Rat,{C,G,B},Unknowns]` checks if `Rat` equals *C**G*<sup>−1</sup>*B* by substituting random 2-by-2 matrices in for the unknowns. `TestDescriptorRealization[Rat,{C,G,B},Unknowns,NumberOfTests]` can be used to specify the `NumberOfTests`, the default being 5.

PinnedQ
-------

`PinnedQ[Pencil_,Unknowns_]` is True or False.

PinningSpace
------------

`PinningSpace[Pencil_,Unknowns_]` returns a matrix whose columns span the pinning space of `Pencil`. Generally, either an empty matrix or a d-by-1 matrix (vector).

NCUtil
======

**NCUtil** is a package with a collection of utilities used throughout NCAlgebra.

Members are:

-   [NCConsistentQ](#NCConsistentQ)
-   [NCGrabFunctions](#NCGrabFunctions)
-   [NCGrabSymbols](#NCGrabSymbols)
-   [NCGrabIndeterminants](#NCGrabIndeterminants)
-   [NCConsolidateList](#NCConsolidateList)
-   [NCLeafCount](#NCLeafCount)
-   [NCReplaceData](#NCReplaceData)
-   [NCToExpression](#NCToExpression)

NCConsistentQ
-------------

`NCConsistentQ[expr]` returns *True* is `expr` contains no commutative products or inverses involving noncommutative variables.

NCGrabFunctions
---------------

`NCGragFunctions[expr]` returns a list with all fragments of `expr` containing functions.

`NCGragFunctions[expr,f]` returns a list with all fragments of `expr` containing the function `f`.

For example:

    NCGrabFunctions[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]], inv]

returns

    {inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x]}

and

    NCGrabFunctions[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x], tp[x], tp[y]}

See also: [NCGrabSymbols](#NCGragSymbols).

NCGrabSymbols
-------------

`NCGragSymbols[expr]` returns a list with all *Symbols* appearing in `expr`.

`NCGragSymbols[expr,f]` returns a list with all *Symbols* appearing in `expr` as the single argument of function `f`.

For example:

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]]]

returns `{x,y}` and

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]], inv]

returns `{inv[x]}`.

See also: [NCGrabFunctions](#NCGragFunctions).

NCGrabIndeterminants
--------------------

`NCGragIndeterminants[expr]` returns a list with first level symbols and nc expressions involved in sums and nc products in `expr`.

For example:

    NCGrabIndeterminants[y - inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {y, inv[x], inv[1 + inv[1 + tp[x] ** y]], tp[y]}

See also: [NCGrabFunctions](#NCGragFunctions), [NCGrabSymbols](#NCGragSymbols).

NCConsolidateList
-----------------

`NCConsolidateList[list]` produces two lists:

-   The first list contains a version of `list` where repeated entries have been suppressed;
-   The second list contains the indices of the elements in the first list that recover the original `list`.

For example:

    {list,index} = NCConsolidateList[{z,t,s,f,d,f,z}];

results in:

    list = {z,t,s,f,d};
    index = {1,2,3,4,5,4,1};

See also: `Union`

NCLeafCount
-----------

`NCLeafCount[expr]` returns an number associated with the complexity of an expression:

-   If `PossibleZeroQ[expr] == True` then `NCLeafCount[expr]` is `-Infinity`;
-   If `NumberQ[expr]] == True` then `NCLeafCount[expr]` is `Abs[expr]`;
-   Otherwise `NCLeafCount[expr]` is `-LeafCount[expr]`;

`NCLeafCount` is `Listable`.

See also: `LeafCount`.

NCReplaceData
-------------

`NCReplaceData[expr, rules]` applies `rules` to `expr` and convert resulting expression to standard Mathematica, for example replacing `**` by `.`.

`NCReplaceData` does not attempt to resize entries in expressions involving matrices. Use `NCToExpression` for that.

See also: [NCToExpression](#NCToExpression).

NCToExpression
--------------

`NCToExpression[expr, rules]` applies `rules` to `expr` and convert resulting expression to standard Mathematica.

`NCToExpression` attempts to resize entries in expressions involving matrices.

See also: [NCReplaceData](#NCReplaceData).

NCSDP
=====

**NCSDP** is a package that allows the symbolic manipulation and numeric solution of semidefinite programs.

Members are:

-   [NCSDP](#NCSDP)
-   [NCSDPForm](#NCSDPForm)
-   [NCSDPDual](#NCSDPDual)
-   [NCSDPDualForm](#NCSDPDualForm)

NCSDP
-----

`NCSDP[inequalities,vars,obj,data]` converts the list of NC polynomials and NC matrices of polynomials `inequalities` that are linear in the unknowns listed in `vars` into the semidefinite program with linear objective `obj`. The semidefinite program (SDP) should be given in the following canonical form:

    max  <obj, vars>  s.t.  inequalities <= 0.

`NCSDP` uses the user supplied rules in `data` to set up the problem data.

`NCSDP[constraints,vars,data]` converts problem into a feasibility semidefinite program.

See also: [NCSDPForm](#NCSDPForm), [NCSDPDual](#NCSDPDual).

NCSDPForm
---------

`NCSDPForm[[inequalities,vars,obj]` prints out a pretty formatted version of the SDP expressed by the list of NC polynomials and NC matrices of polynomials `inequalities` that are linear in the unknowns listed in `vars`.

See also: [NCSDP](#NCSDP), [NCSDPDualForm](#NCSDPDualForm).

NCSDPDual
---------

`{dInequalities, dVars, dObj} = NCSDPDual[inequalities,vars,obj]` calculates the symbolic dual of the SDP expressed by the list of NC polynomials and NC matrices of polynomials `inequalities` that are linear in the unknowns listed in `vars` with linear objective `obj` into a dual semidefinite in the following canonical form:

    max <dObj, dVars>  s.t.  dInequalities == 0,   dVars >= 0.

See also: [NCSDPDualForm](#NCSDPDualForm), [NCSDP](#NCSDP).

NCSDPDualForm
-------------

`NCSDPForm[[dInequalities,dVars,dObj]` prints out a pretty formatted version of the dual SDP expressed by the list of NC polynomials and NC matrices of polynomials `dInequalities` that are linear in the unknowns listed in `dVars` with linear objective `dObj`.

See also: [NCSDPDual](#NCSDPDual), [NCSDPForm](#NCSDPForm).

SDP
===

**SDP** is a package that provides algorithms for the numeric solution of semidefinite programs.

Members are:

-   [SDPMatrices](#SDPMatrices)
-   [SDPSolve](#SDPSolve)
-   [SDPEval](#SDPEval)
-   [SDPInner](#SDPInner)

The following members are not supposed to be called directly by users:

-   [SDPCheckDimensions](#SDPCheckDimensions)
-   [SDPScale](#SDPScale)
-   [SDPFunctions](#SDPFunctions)
-   [SDPPrimalEval](#SDPPrimalEval)
-   [SDPDualEval](#SDPDualEval)
-   [SDPSylvesterEval](#SDPSylvesterEval)
-   [SDPSylvesterDiagonalEval](#SDPSylvesterDiagonalEval)

SDPMatrices
-----------

SDPSolve
--------

SDPEval
-------

SDPInner
--------

SDPCheckDimensions
------------------

SDPDualEval
-----------

SDPFunctions
------------

SDPPrimalEval
-------------

SDPScale
--------

SDPSylvesterDiagonalEval
------------------------

SDPSylvesterEval
----------------

NCGBX
=====

Members are:

-   [NCToNCPoly](#NCToNCPoly)
-   [NCPolyToNC](#NCPolyToNC)
-   [NCRuleToPoly](#NCRuleToPoly)
-   [SetMonomialOrder](#SetMonomialOrder)
-   [SetKnowns](#SetKnowns)
-   [SetUnknowns](#SetUnknowns)
-   [ClearMonomialOrder](#ClearMonomialOrder)
-   [GetMonomialOrder](#GetMonomialOrder)
-   [PrintMonomialOrder](#PrintMonomialOrder)
-   [NCMakeGB](#NCMakeGB)
-   [NCReduce](#NCReduce)

NCToNCPoly
----------

`NCToNCPoly[expr, var]` constructs a noncommutative polynomial object in variables `var` from the nc expression `expr`.

For example

    NCToNCPoly[x**y - 2 y**z, {x, y, z}] 

constructs an object associated with the noncommutative polynomial *x**y* − 2*y**z* in variables `x`, `y` and `z`. The internal representation is so that the terms are sorted according to a degree-lexicographic order in `vars`. In the above example, *x* &lt; *y* &lt; *z*.

NCPolyToNC
----------

`NCPolyToNC[poly, vars]` constructs an nc expression from the noncommutative polynomial object `poly` in variables `vars`. Monomials are specified in terms of the symbols in the list `var`.

For example

    poly = NCToNCPoly[x**y - 2 y**z, {x, y, z}];
    expr = NCPolyToNC[poly, {x, y, z}];

returns

    expr = x**y - 2 y**z

See also: [NCPolyToNC](#NCPolyToNC), [NCPoly](#NCPoly).

NCRuleToPoly
------------

SetMonomialOrder
----------------

`SetMonomialOrder[var1, var2, ...]` sets the current monomial order.

For example

    SetMonomialOrder[a,b,c]

sets the lex order *a* ≪ *b* ≪ *c*.

If one uses a list of variables rather than a single variable as one of the arguments, then multigraded lex order is used. For example

    SetMonomialOrder[{a,b,c}]

sets the graded lex order *a* &lt; *b* &lt; *c*.

Another example:

    SetMonomialOrder[{{a, b}, {c}}]

or

    SetMonomialOrder[{a, b}, c]

set the multigraded lex order *a* &lt; *b* ≪ *c*.

Finally

    SetMonomialOrder[{a,b}, {c}, {d}]

or

    SetMonomialOrder[{a,b}, c, d]

is equivalent to the following two commands

    SetKnowns[a,b] 
    SetUnknowns[c,d]

There is also an older syntax which is still supported:

    SetMonomialOrder[{a, b, c}, n]

sets the order of monomials to be *a* &lt; *b* &lt; *c* and assigns them grading level `n`.

    SetMonomialOrder[{a, b, c}, 1]

is equivalent to `SetMonomialOrder[{a, b, c}]`. When using this older syntax the user is responsible for calling [ClearMonomialOrder](#ClearMonomialOrder) to make sure that the current order is empty before starting.

See also: [ClearMonomialOrder](#ClearMonomialOrder), [GetMonomialOrder](#GetMonomialOrder), [PrintMonomialOrder](#PrintMonomialOrder), [SetKnowns](#SetKnowns), [SetUnknowns](#SetUnknowns).

SetKnowns
---------

`SetKnowns[var1, var2, ...]` records the variables `var1`, `var2`, ... to be corresponding to known quantities.

`SetUnknowns` and `Setknowns` prescribe a monomial order with the knowns at the the bottom and the unknowns at the top.

For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]

is equivalent to

    SetMonomialOrder[{a,b}, {c}, {d}]

which corresponds to the order *a* &lt; *b* ≪ *c* ≪ *d* and

    SetKnowns[a,b] 
    SetUnknowns[{c,d}]

is equivalent to

    SetMonomialOrder[{a,b}, {c, d}]

which corresponds to the order *a* &lt; *b* ≪ *c* &lt; *d*.

Note that `SetKnowns` flattens grading so that

    SetKnowns[a,b] 

and

    SetKnowns[{a},{b}] 

result both in the order *a* &lt; *b*.

Successive calls to `SetUnknowns` and `SetKnowns` overwrite the previous knowns and unknowns. For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]
    SetKnowns[c,d]
    SetUnknowns[a,b]

results in an ordering *c* &lt; *d* ≪ *a* ≪ *b*.

See also: [SetUnknowns](#SetUnknowns), [SetMonomialOrder](#SetMonomialOrder).

SetUnknowns
-----------

`SetUnknowns[var1, var2, ...]` records the variables `var1`, `var2`, ... to be corresponding to unknown quantities.

`SetUnknowns` and `SetKnowns` prescribe a monomial order with the knowns at the the bottom and the unknowns at the top.

For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]

is equivalent to

    SetMonomialOrder[{a,b}, {c}, {d}]

which corresponds to the order *a* &lt; *b* ≪ *c* ≪ *d* and

    SetKnowns[a,b] 
    SetUnknowns[{c,d}]

is equivalent to

    SetMonomialOrder[{a,b}, {c, d}]

which corresponds to the order *a* &lt; *b* ≪ *c* &lt; *d*.

Note that `SetKnowns` flattens grading so that

    SetKnowns[a,b] 

and

    SetKnowns[{a},{b}] 

result both in the order *a* &lt; *b*.

Successive calls to `SetUnknowns` and `SetKnowns` overwrite the previous knowns and unknowns. For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]
    SetKnowns[c,d]
    SetUnknowns[a,b]

results in an ordering *c* &lt; *d* ≪ *a* ≪ *b*.

See also: [SetKnowns](#SetKnowns), [SetMonomialOrder](#SetMonomialOrder).

ClearMonomialOrder
------------------

`ClearMonomialOrder[]` clear the current monomial ordering.

It is only necessary to use `ClearMonomialOrder` if using the indexed version of `SetMonomialOrder`.

See also: [SetKnowns](#SetKnowns), [SetUnknowns](#SetUnknowns), [SetMonomialOrder](#SetMonomialOrder), [ClearMonomialOrder](#ClearMonomialOrder), [PrintMonomialOrder](#PrintMonomialOrder).

GetMonomialOrder
----------------

`GetMonomialOrder[]` returns the current monomial ordering in the form of a list.

For example

    SetMonomialOrder[{a,b}, {c}, {d}]
    order = GetMonomialOrder[]

returns

    order = {{a,b},{c},{d}}

See also: [SetKnowns](#SetKnowns), [SetUnknowns](#SetUnknowns), [SetMonomialOrder](#SetMonomialOrder), [ClearMonomialOrder](#ClearMonomialOrder), [PrintMonomialOrder](#PrintMonomialOrder).

PrintMonomialOrder
------------------

`PrintMonomialOrder[]` prints the current monomial ordering.

For example

    SetMonomialOrder[{a,b}, {c}, {d}]
    PrintMonomialOrder[]

print *a* &lt; *b* ≪ *c* ≪ *d*.

See also: [SetKnowns](#SetKnowns), [SetUnknowns](#SetUnknowns), [SetMonomialOrder](#SetMonomialOrder), [ClearMonomialOrder](#ClearMonomialOrder), [PrintMonomialOrder](#PrintMonomialOrder).

NCMakeGB
--------

`NCMakeGB[{poly1, poly2, ...}, k]` attempts to produces a nc Gröbner Basis (GB) associated with the list of nc polynomials `{poly1, poly2, ...}`. The GB algorithm proceeds through *at most* `k` iterations until a Gröbner basis is found for the given list of polynomials with respect to the order imposed by [SetMonomialOrder](#SetMonomialOrder).

If `NCMakeGB` terminates before finding a GB the message `NCMakeGB::Interrupted` is issued.

The output of `NCMakeGB` is a list of rules with left side of the rule being the *leading* monomial of the polynomials in the GB.

For example:

    SetMonomialOrder[x];
    gb = NCMakeGB[{x^2 - 1, x^3 - 1}, 20]

returns

    gb = {x -> 1}

that corresponds to the polynomial *x* − 1, which is the nc Gröbner basis for the ideal generated by *x*<sup>2</sup> − 1 and *x*<sup>3</sup> − 1.

`NCMakeGB[{poly1, poly2, ...}, k, options]` uses `options`.

The following `options` can be given:

-   `SimplifyObstructions` (`True`): control whether obstructions are simplified before being added to the list of active obstructions;
-   `SortObstructions` (`False`): control whether obstructions are sorted before being processed;
-   `SortBasis` (`False`): control whether initial basis is sorted before initiating algorithm;
-   `VerboseLevel` (`1`): control level of verbosity from `0` (no messages) to `5` (very verbose);
-   `PrintBasis` (`False`): if `True` prints current basis at each major iteration;
-   `PrintObstructions` (`False`): if `True` prints current list of obstructions at each major iteration;
-   `PrintSPolynomials` (`False`): if `True` prints every S-polynomial formed at each minor iteration.

`NCMakeGB` makes use of the algorithm `NCPolyGroebner` implemented in [NCPolyGroeber](#NCPolyGroeber).

See also: [ClearMonomialOrder](#ClearMonomialOrder), [GetMonomialOrder](#GetMonomialOrder), [PrintMonomialOrder](#PrintMonomialOrder), [SetKnowns](#SetKnowns), [SetUnknowns](#SetUnknowns), [NCPolyGroebner](#NCPolyGroebner).

NCReduce
--------

`NCAutomaticOrder[ aMonomialOrder, aListOfPolynomials ]`

This command assists the user in specifying a monomial order. It inserts all of the indeterminants found in *a**L**i**s**t**O**f**P**o**l**y**n**o**m**i**a**l**s* into the monomial order. If x is an indeterminant found in *a**M**o**n**o**m**i**a**l**O**r**d**e**r* then any indeterminant whose symbolic representation is a function of x will appear next to x. For example, NCAutomaticOrder\[{{a},{b}},{ a**Inv\[a\]**tp\[a\] + tp\[b\]}\] would set the order to be *a* &lt; *t**p*\[*a*\]&lt;*I**n**v*\[*a*\]≪*b* &lt; *t**p*\[*b*\].} {A list of indeterminants which specifies the general order. A list of polynomials which will make up the input to the Gröbner basis command.} {If tp\[Inv\[a\]\] is found after Inv\[a\] NCAutomaticOrder\[ \] would generate the order *a* &lt; *t**p*\[*I**n**v*\[*a*\]\] &lt; *I**n**v*\[*a*\]. If the variable is self-adjoint (the input contains the relation $ tp\[Inv\[a\]\] == Inv\[a\]$) we would have the rule, *I**n**v*\[*a*\]→*t**p*\[*I**n**v*\[*a*\]\], when the user would probably prefer *t**p*\[*I**n**v*\[*a*\]\] → *I**n**v*\[*a*\].}

NCPoly
======

Members are:

-   Constructors
    -   [NCPoly](#NCPoly)
    -   [NCPolyMonomial](#NCPolyMonomial)
    -   [NCPolyConstant](#NCPolyConstant)
-   Access
    -   [NCPolyMonomialQ](#NCPolyMonomialQ)
    -   [NCPolyDegree](#NCPolyDegree)
    -   [NCPolyNumberOfVariables](#NCPolyNumberOfVariables)
    -   [NCPolyCoefficient](#NCPolyCoefficient)
    -   [NCPolyGetCoefficients](#NCPolyGetCoefficients)
    -   [NCPolyGetDigits](#NCPolyGetDigits)
    -   [NCPolyGetIntegers](#NCPolyGetIntegers)
    -   [NCPolyLeadingMonomial](#NCPolyLeadingMonomial)
    -   [NCPolyLeadingTerm](#NCPolyLeadingTerm)
    -   [NCPolyOrderType](#NCPolyOrderType)
    -   [NCPolyToRule](#NCPolyToRule)
-   Formatting
    -   [NCPolyDisplay](#NCPolyDisplay)
    -   [NCPolyDisplayOrder](#NCPolyDisplayOrder)
-   Arithmetic
    -   [NCPolyDivideDigits](#NCPolyDivideDigits)
    -   [NCPolyDivideLeading](#NCPolyDivideLeading)
    -   [NCPolyFullReduce](#NCPolyFullReduce)
    -   [NCPolyNormalize](#NCPolyNormalize)
    -   [NCPolyProduct](#NCPolyProduct)
    -   [NCPolyQuotientExpand](#NCPolyQuotientExpand)
    -   [NCPolyReduce](#NCPolyReduce)
    -   [NCPolySum](#NCPolySum)
-   Other
    -   [NCPolyHankelMatrix](#NCPolyHankelMatrix)
-   Auxiliary
    -   [NCFromDigits](#NCFromDigits)
    -   [NCIntegerDigits](#NCIntegerDigits)
    -   [NCDigitsToIndex](#NCDigitsToIndex)
    -   [NCPadAndMatch](#NCPadAndMatch)

NCPoly
------

`NCPoly[coeff, monomials, vars]` constructs a noncommutative polynomial object in variables `vars` where the monomials have coefficient `coeff`.

Monomials are specified in terms of the symbols in the list `vars` as in [NCPolyMonomial](#NCPolyMonomial).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];

constructs an object associated with the noncommutative polynomial 2*z* − *x**y**x* in variables `x`, `y` and `z`.

The internal representation varies with the implementation but it is so that the terms are sorted according to a degree-lexicographic order in `vars`. In the above example, `x < y < z`.

The construction:

    vars = {{x},{y,z}};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];

represents the same polyomial in a graded degree-lexicographic order in `vars`, in this example, `x << y < z`.

See also: [NCPolyMonomial](#NCPolyMonomial), [NCIntegerDigits](#NCIntegerDigits), [NCFromDigits](#NCFromDigits).

NCPolyMonomial
--------------

`NCPolyMonomial[monomial, vars]` constructs a noncommutative monomial object in variables `vars`.

Monic monomials are specified in terms of the symbols in the list `vars`, for example:

    vars = {x,y,z};
    mon = NCPolyMonomial[{x,y,x},vars];

returns an `NCPoly` object encoding the monomial *x**y**x* in noncommutative variables `x`,`y`, and `z`. The actual representation of `mon` varies with the implementation.

Monomials can also be specified implicitly using indices, for example:

    mon = NCPolyMonomial[{0,1,0}, 3];

also returns an `NCPoly` object encoding the monomial *x**y**x* in noncommutative variables `x`,`y`, and `z`.

If graded ordering is supported then

    vars = {{x},{y,z}};
    mon = NCPolyMonomial[{x,y,x},vars];

or

    mon = NCPolyMonomial[{0,1,0}, {1,2}];

construct the same monomial *x**y**x* in noncommutative variables `x`,`y`, and `z` this time using a graded order in which `x << y < z`.

There is also an alternative syntax for `NCPolyMonomial` that allows users to input the monomial along with a coefficient using rules and the output of [NCFromDigits](#NCFromDigits). For example:

    mon = NCPolyMonomial[{3, 3} -> -2, 3];

or

    mon = NCPolyMonomial[NCFromDigits[{0,1,0}, 3] -> -2, 3];

represent the monomial −2*x**y**x* with has coefficient `-2`.

See also: [NCPoly](#NCPoly), [NCIntegerDigits](#NCIntegerDigits), [NCFromDigits](#NCFromDigits).

NCPolyConstant
--------------

`NCPolyConstant[value, vars]` constructs a noncommutative monomial object in variables `vars` representing the constant `value`.

For example:

    NCPolyConstant[3, {x, y, z}]

constructs an object associated with the constant `3` in variables `x`, `y` and `z`.

See also: [NCPoly](#NCPoly), [NCPolyMonomial](#NCPolyMonomial).

NCPolyMonomialQ
---------------

`NCPolyMonomialQ[poly]` returns `True` if `poly` is a `NCPoly` monomial.

See also: [NCPoly](#NCPoly), [NCPolyMonomial](#NCPolyMonomial).

NCPolyDegree
------------

`NCPolyDegree[poly]` returns the degree of the nc polynomial `poly`.

NCPolyNumberOfVariables
-----------------------

`NCPolyNumberOfVariables[poly]` returns the number of variables of the nc polynomial `poly`.

NCPolyCoefficient
-----------------

`NCPolyCoefficient[poly, mon]` returns the coefficient of the monomial `mon` in the nc polynomial `poly`.

For example, in:

    coeff = {1, 2, 3, -1, -2, -3, 1/2};
    mon = {{}, {x}, {z}, {x, y}, {x, y, x, x}, {z, x}, {z, z, z, z}};
    vars = {x,y,z};
    poly = NCPoly[coeff, mon, vars];

    c = NCPolyCoefficient[poly, NCPolyMonomial[{x,y},vars]];

returns

    c = -1

See also: [NCPoly](#NCPoly), [NCPolyMonomial](#NCPolyMonomial).

NCPolyGetCoefficients
---------------------

`NCPolyGetCoefficients[poly]` returns a list with the coefficients of the monomials in the nc polynomial `poly`.

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    coeffs = NCPolyGetCoefficients[poly];

returns

    coeffs = {2,-1}

The coefficients are returned according to the current graded degree-lexicographic ordering, in this example `x < y < z`.

See also: [NCPolyGetDigits](#NCPolyGetDigits), [NCPolyCoefficient](#NCPolyCoefficient), [NCPoly](#NCPoly).

NCPolyGetDigits
---------------

`NCPolyGetDigits[poly]` returns a list with the digits that encode the monomials in the nc polynomial `poly` as produced by [NCIntegerDigits](#NCIntegerDigits).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    digits = NCPolyGetDigits[poly];

returns

    digits = {{2}, {0,1,0}}

The digits are returned according to the current ordering, in this example `x < y < z`.

See also: [NCPolyGetCoefficients](#NCPolyGetCoefficients), [NCPoly](#NCPoly).

NCPolyGetIntegers
-----------------

`NCPolyGetIntegers[poly]` returns a list with the digits that encode the monomials in the nc polynomial `poly` as produced by [NCFromDigits](#NCFromDigits).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    digits = NCPolyGetIntegers[poly];

returns

    digits = {{1,2}, {3,3}}

The digits are returned according to the current ordering, in this example `x < y < z`.

See also: [NCPolyGetCoefficients](#NCPolyGetCoefficients), [NCPoly](#NCPoly).

NCPolyLeadingMonomial
---------------------

`NCPolyLeadingMonomial[poly]` returns an `NCPoly` representing the leading term of the nc polynomial `poly`.

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    lead = NCPolyLeadingMonomial[poly];

returns an `NCPoly` representing the monomial *x**y**x*. The leading monomial is computed according to the current ordering, in this example `x < y < z`. The actual representation of `lead` varies with the implementation.

See also: [NCPolyLeadingTerm](#NCPolyLeadingTerm), [NCPolyMonomial](#NCPolyMonomial), [NCPoly](#NCPoly).

NCPolyLeadingTerm
-----------------

`NCPolyLeadingTerm[poly]` returns a rule associated with the leading term of the nc polynomial `poly` as understood by [NCPolyMonomial](#NCPolyMonomial).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    lead = NCPolyLeadingTerm[poly];

returns

    lead = {3,3} -> -1

representing the monomial −*x**y**x*. The leading monomial is computed according to the current ordering, in this example `x < y < z`.

See also: [NCPolyLeadingMonomial](#NCPolyLeadingMonomial), [NCPolyMonomial](#NCPolyMonomial), [NCPoly](#NCPoly).

NCPolyOrderType
---------------

`NCPolyOrderType[poly]` returns the type of monomial order in which the nc polynomial `poly` is stored. Order can be `NCPolyGradedDegLex` or `NCPolyDegLex`.

See also: [NCPoly](#NCPoly),

NCPolyToRule
------------

`NCPolyToRule[poly]` returns a `Rule` associated with polynomial `poly`. If `poly = lead + rest`, where `lead` is the leading term in the current order, then `NCPolyToRule[poly]` returns the rule `lead -> -rest` where the coefficient of the leading term has been normalized to `1`.

For example:

    vars = {x, y, z};
    poly = NCPoly[{-1, 2, 3}, {{x, y, x}, {z}, {x, y}}, vars];
    rule = NCPolyToRule[poly]

returns the rule `lead -> rest` where `lead` represents is the nc monomial *x**y**x* and `rest` is the nc polynomial 2*z* + 3*x**y*

See also: [NCPolyLeadingTerm](#NCPolyLeadingTerm), [NCPolyLeadingMonomial](#NCPolyLeadingMonomial), [NCPoly](#NCPoly).

NCPolyDisplayOrder
------------------

`NCPolyDisplayOrder[vars]` prints the order implied by the list of variables `vars`.

NCPolyDisplay
-------------

`NCPolyDisplay[poly]` prints the noncommutative polynomial `poly`.

`NCPolyDisplay[poly, vars]` uses the symbols in the list `vars`.

NCPolyDivideDigits
------------------

`NCPolyDivideDigits[F,G]` returns the result of the division of the leading digits lf and lg.

NCPolyDivideLeading
-------------------

`NCPolyDivideLeading[lF,lG,base]` returns the result of the division of the leading Rules lf and lg as returned by NCGetLeadingTerm.

NCPolyFullReduce
----------------

`NCPolyFullReduce[f,g]` applies NCPolyReduce successively until the remainder does not change. See also NCPolyReduce and NCPolyQuotientExpand.

NCPolyNormalize
---------------

`NCPolyNormalize[poly]` makes the coefficient of the leading term of `p` to unit. It also works when `poly` is a list.

NCPolyProduct
-------------

`NCPolyProduct[f,g]` returns a NCPoly that is the product of the NCPoly's f and g.

NCPolyQuotientExpand
--------------------

`NCPolyQuotientExpand[q,g]` returns a NCPoly that is the left-right product of the quotient as returned by NCPolyReduce by the NCPoly g. It also works when g is a list.

NCPolyReduce
------------

NCPolySum
---------

`NCPolySum[f,g]` returns a NCPoly that is the sum of the NCPoly's f and g.

NCPolyHankelMatrix
------------------

`NCPolyHankelMatrix[poly]` produces the nc *Hankel matrix* associated with the polynomial `poly` and also their shifts per variable.

For example:

    vars = {{x, y}};
    poly = NCPoly[{1, -1}, {{x, y}, {y, x}}, vars];
    {H, Hx, Hy} = NCPolyHankelMatrix[poly]

results in the matrices

    H =  {{  0,  0,  0,  1, -1 },
          {  0,  0,  1,  0,  0 },
          {  0, -1,  0,  0,  0 },
          {  1,  0,  0,  0,  0 },
          { -1,  0,  0,  0,  0 }}
    Hx = {{  0,  0,  1,  0,  0 },
          {  0,  0,  0,  0,  0 },
          { -1,  0,  0,  0,  0 },
          {  0,  0,  0,  0,  0 },
          {  0,  0,  0,  0,  0 }}
    Hy = {{  0, -1,  0,  0,  0 },
          {  1,  0,  0,  0,  0 },
          {  0,  0,  0,  0,  0 },
          {  0,  0,  0,  0,  0 },
          {  0,  0,  0,  0,  0 }}

which are the Hankel matrices associated with the commutator *x**y* − *y**x*.

See also: [NCPolyRealization](#NCPolyRealization), [NCIntegerToIndex](#NCIntegerToIndex).

NCPolyRealization
-----------------

`NCPolyRealization[poly]` calculate a minimal descriptor realization for the polynomial `poly`.

`NCPolyRealization` uses `NCPolyHankelMatrix` and the resulting realization is compatible with the format used by `NCRational`.

For example:

    vars = {{x, y}};
    poly = NCPoly[{1, -1}, {{x, y}, {y, x}}, vars];
    {{a0,ax,ay},b,c,d} = NCPolyRealization[poly]

produces a list of matrices `{a0,ax,ay}`, a column vector `b` and a row vector `c`, and a scalar `d` such that *c*.*i**n**v*\[*a*0 + *a**x* *x* + *a**y* *y*\].*b* + *d* = *x**y* − *y**x*.

See also: [NCPolyHankelMatrix](#NCPolyHankelMatrix), [NCRational](#NCRational).

NCFromDigits
------------

`NCFromDigits[list, b]` constructs a representation of a monomial in `b` encoded by the elements of `list` where the digits are in base `b`.

`NCFromDigits[{list1,list2}, b]` applies `NCFromDigits` to each `list1`, `list2`, ....

List of integers are used to codify monomials. For example the list `{0,1}` represents a monomial *x**y* and the list `{1,0}` represents the monomial *y**x*. The call

    NCFromDigits[{0,0,0,1}, 2]

returns

    {4,1}

in which `4` is the degree of the monomial *x**x**x**y* and `1` is `0001` in base `2`. Likewise

    NCFromDigits[{0,2,1,1}, 3]

returns

    {4,22}

in which `4` is the degree of the monomial *x**z**y**y* and `22` is `0211` in base `3`.

If `b` is a list, then degree is also a list with the partial degrees of each letters appearing in the monomial. For example:

    NCFromDigits[{0,2,1,1}, {1,2}]

returns

    {3, 1, 22}

in which `3` is the partial degree of the monomial *x**z**y**y* with respect to letters `y` and `z`, `1` is the partial degree with respect to letter `x` and `22` is `0211` in base `3 = 1 + 2`.

This construction is used to represent graded degree-lexicographic orderings.

See also: [NCIntergerDigits](#NCIntergerDigits).

NCIntegerDigits
---------------

`NCIntegerDigits[n,b]` is the inverse of the `NCFromDigits`.

`NCIntegerDigits[{list1,list2}, b]` applies `NCIntegerDigits` to each `list1`, `list2`, ....

For example:

    NCIntegerDigits[{4,1}, 2]

returns

    {0,0,0,1}

in which `4` is the degree of the monomial `x**x**x**y` and `1` is `0001` in base `2`. Likewise

    NCIntegerDigits[{4,22}, 3]

returns

    {0,2,1,1}

in which `4` is the degree of the monomial `x**z**y**y` and `22` is `0211` in base `3`.

If `b` is a list, then degree is also a list with the partial degrees of each letters appearing in the monomial. For example:

    NCIntegerDigits[{3, 1, 22}, {1,2}]

returns

    {0,2,1,1}

in which `3` is the partial degree of the monomial `x**z**y**y` with respect to letters `y` and `z`, `1` is the partial degree with respect to letter `x` and `22` is `0211` in base `3 = 1 + 2`.

See also: [NCFromDigits](#NCFromDigits).

NCDigitsToIndex
---------------

`NCDigitsToIndex[digits, b]` returns the index that the monomial represented by `digits` in the base `b` would occupy in the standard monomial basis.

`NCDigitsToIndex[{digit1,digits2}, b]` applies `NCDigitsToIndex` to each `digit1`, `digit2`, ....

`NCDigitsToIndex` returns the same index for graded or simple basis.

For example:

    digits = {0, 1};
    NCDigitsToIndex[digits, 2]
    NCDigitsToIndex[digits, {2}]
    NCDigitsToIndex[digits, {1, 1}]

all return

    5

which is the index of the monomial *x**y* in the standard monomial basis of polynomials in *x* and *y*. Likewise

    digits = {{}, {1}, {0, 1}, {0, 2, 1, 1}};
    NCDigitsToIndex[digits, 2]

returns

    {1,3, 5,27}

See also: [NCFromDigits](#NCFromDigits), [NCIntergerDigits](#NCIntergerDigits).

NCPadAndMatch
-------------

When list `a` is longer than list `b`, `NCPadAndMatch[a,b]` returns the minimum number of elements from list a that should be added to the left and right of list `b` so that `a = l b r`. When list `b` is longer than list `a`, return the opposite match.

`NCPadAndMatch` returns all possible matches with the minimum number of elements.

NCPolyGroebner
==============

Members are:

-   [NCPolyGroebner](#NCPolyGroebner)

NCPolyGroebner
--------------

`NCPolyGroebner[G]` computes the noncommutative Groebner basis of the list of `NCPoly` polynomials `G`.

`NCPolyGroebner[G, options]` uses `options`.

The following `options` can be given:

-   `SimplifyObstructions` (`True`) whether to simplify obstructions before constructions S-polynomials;
-   `SortObstructions` (`False`) whether to sort obstructions using Mora's SUGAR ranking;
-   `SortBasis` (`False`) whether to sort basis before starting algorithm;
-   `Labels` (`{}`) list of labels to use in verbose printing;
-   `VerboseLevel` (`1`): function used to decide if a pivot is zero;
-   `PrintBasis` (`False`): function used to divide a vector by an entry;
-   `PrintObstructions` (`False`);
-   `PrintSPolynomials` (`False`);

The algorithm is based on T. Mora, "An introduction to commuative and noncommutative Groebner Bases," *Theoretical Computer Science*, v. 134, pp. 131-173, 2000.

See also: [NCPoly](#NCPoly).

NCTeX
=====

Members are:

-   [NCTeX](#NCTeX)
-   [NCRunDVIPS](#NCRunDVIPS)
-   [NCRunLaTeX](#NCRunLaTeX)
-   [NCRunPDFLaTeX](#NCRunPDFLaTeX)
-   [NCRunPDFViewer](#NCRunPDFViewer)
-   [NCRunPS2PDF](#NCRunPS2PDF)

NCTeX
-----

`NCTeX[expr]` typesets the LaTeX version of `expr` produced with TeXForm or NCTeXForm using LaTeX.

NCRunDVIPS
----------

`NCRunDVIPS[file]` run dvips on `file`. Produces a ps output.

NCRunLaTeX
----------

`NCRunLaTeX[file]` typesets the LaTeX `file` with latex. Produces a dvi output.

NCRunPDFLaTeX
-------------

`NCRunLaTeX[file]` typesets the LaTeX `file` with pdflatex. Produces a pdf output.

NCRunPDFViewer
--------------

`NCRunPDFViewer[file]` display pdf `file`.

NCRunPS2PDF
-----------

`NCRunPS2PDF[file]` run pd2pdf on `file`. Produces a pdf output.

NCTeXForm
=========

Members are:

-   [NCTeXForm](#NCTeXForm)
-   [NCTeXFormSetStarStar](#NCTeXFormSetStarStar)

NCTeXForm
---------

`NCTeXForm[expr]` prints a LaTeX version of `expr`.

The format is compatible with AMS-LaTeX.

Should work better than the Mathematica `TeXForm` :)

NCTeXFormSetStarStar
--------------------

`NCTeXFormSetStarStar[string]` replaces the standard '\*\*' for `string` in noncommutative multiplications.

For example:

    NCTeXFormSetStarStar["."]

uses a dot (`.`) to replace `NonCommutativeMultiply`(`**`).

See also: [NCTeXFormSetStar](#NCTeXFormSetStar).

NCTeXFormSetStar
----------------

`NCTeXFormSetStar[string]` replaces the standard '\*' for `string` in noncommutative multiplications.

For example:

    NCTeXFormSetStar[" "]

uses a space (`` `) to replace ``Times`(`\*\`).

[NCTeXFormSetStarStar](#NCTeXFormSetStarStar).

NCRun
=====

Members are:

-   [NCRun](#NCRun)

NCRun
-----

NCTest
======

Members are:

-   [NCTest](#NCTest)
-   [NCTestRun](#NCTestRun)
-   [NCTestSummarize](#NCTestSummarize)

NCTest
------

`NCTest[expr,answer]` asserts whether `expr` is equal to `answer`. The result of the test is collected when `NCTest` is run from `NCTestRun`.

See also: [NCTestRun](#NCTestRun), [NCTestSummarize](#NCTestSummarize)

NCTestRun
---------

`NCTest[list]` runs the test files listed in `list` after appending the '.NCTest' suffix and return the results.

For example:

    results = NCTestRun[{"NCCollect", "NCSylvester"}]

will run the test files "NCCollec.NCTest" and "NCSylvester.NCTest" and return the results in `results`.

See also: [NCTest](#NCTest), [NCTestSummarize](#NCTestSummarize)

NCTestSummarize
---------------

`NCTestSummarize[results]` will print a summary of the results in `results` as produced by `NCTestRun`.

See also: [NCTestRun](#NCTestRun)
