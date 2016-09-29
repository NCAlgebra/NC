-   [Changes in Version 5.0](#changes-in-version-5.0)
-   [Introduction](#UserGuideIntroduction)
    -   [Running NCAlgebra](#RunningNCAlgebra)
    -   [Now what?](#now-what)
    -   [Testing](#testing)
-   [Most Basic Commands](#MostBasicCommands)
    -   [To Commute Or Not To Commute?](#to-commute-or-not-to-commute)
    -   [Transposes and Adjoints](#transposes-and-adjoints)
    -   [Inverses](#inverses)
    -   [Expand and Collect](#expand-and-collect)
    -   [Replace](#replace)
    -   [Rationals and Simplification](#rationals-and-simplification)
    -   [Calculus](#calculus)
    -   [Matrices](#matrices)
-   [Things you can do with NCAlgebra and NCGB](#ThingsYouCanDo)
    -   [Noncommutative Inequalities](#noncommutative-inequalities)
    -   [Linear Systems and Control](#linear-systems-and-control)
    -   [Semidefinite Programming](#semidefinite-programming)
    -   [NonCommutative Groebner Bases](#noncommutative-groebner-bases)
    -   [Groups](#groups)
    -   [NCGBX](#ncgbx)
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
    -   [NCOutputFunction](#NCOutputFunction)
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
-   [NCConvexity](#PackageNCConvexity)
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
    -   [LUPartialPivoting](#LUPartialPivoting)
    -   [LUCompletePivoting](#LUCompletePivoting)
-   [NCUtil](#PackageNCUtil)
    -   [NCConsistentQ](#NCConsistentQ)
    -   [NCGrabFunctions](#NCGrabFunctions)
    -   [NCGrabSymbols](#NCGrabSymbols)
    -   [NCGrabIndeterminants](#NCGrabIndeterminants)
    -   [NCConsolidateList](#NCConsolidateList)
    -   [NCLeafCount](#NCLeafCount)
    -   [NCReplaceData](#NCReplaceData)
    -   [NCToExpression](#NCToExpression)
-   [NCTest](#PackageNCTest)
    -   [NCTest](#NCTest)
    -   [NCTestRun](#NCTestRun)
    -   [NCTestSummarize](#NCTestSummarize)
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

First you must load in NCAlgebra with the following command

    In[1]:= <<NC`
    In[2]:= <<NCAlgebra`

To Commute Or Not To Commute?
-----------------------------

In `NCAlgebra`, the operator `**` denotes *noncommutative multiplication*.

At present, single-letter lower case variables are non-commutative by default and all others are commutative by default.

We consider non-commutative lower case variables in the following examples:

    In[3]:= a**b-b**a
    Out[3]= a**b-b**a
    In[4]:= A**B-B**A
    Out[4]= 0
    In[5]:= A**b-b**A
    Out[5]= 0

`CommuteEverything` temporarily makes all noncommutative symbols appearing in a given expression to behave as if they were commutative and returns the resulting commutative expression:

    In[6]:= CommuteEverything[a**b-b**a]
    Out[6]= 0
    In[7]:= EndCommuteEverything[]
    In[8]:= a**b-b**a
    Out[8]= a**b-b**a

`EndCommuteEverything` restores the original noncommutative behavior.

`SetNonCommutative` makes symbols behave permanently as noncommutative:

    In[9]:= SetNonCommutative[A,B]
    In[10]:= A**B-B**A
    Out[10]= A**B-B**A
    In[11]:= SetNonCommutative[A]; SetCommutative[B];
    In[12]:= A**B-B**A
    Out[12]= 0

`SNC` is an alias for `SetNonCommutative`. So, `SNC` can be typed rather than the longer `SetNonCommutative`.

    In[13]:= SNC[A];
    In[14]:= A**a-a**A
    Out[14]= -a**A+A**a

`SetCommutative` makes symbols permanently behave as commutative:

    In[15]:= SetCommutative[v];
    In[16]:= v**b
    Out[16]= b v

Transposes and Adjoints
-----------------------

`tp[x]` denotes the transpose of symbol `x`

`aj[x]` denotes the adjoint of symbol `x`

The properties of transposes and adjoints that everyone uses constantly are built-in:

    In[17]:= tp[a**b]
    Out[17]= tp[b]**tp[a]
    In[18]:= tp[5]
    Out[18]= 5
    In[19]:= tp[2+3I]   (* I is the imaginary unit *)
    Out[19]= 2+3 I
    In[20]:= tp[a]
    Out[20]= tp[a]
    In[21]:= tp[a+b]
    Out[21]= tp[a]+tp[b]
    In[22]:= tp[6x]
    Out[22]= 6 tp[x]
    In[23]:= tp[tp[a]]
    Out[23]= a
    In[24]:= aj[5]
    Out[24]= 5
    In[25]:= aj[2+3I]
    Out[25]= 2-3 I
    In[26]:= aj[a]
    Out[26]= aj[a]
    In[27]:= aj[a+b]
    Out[27]= aj[a]+aj[b]
    In[28]:= aj[6x]
    Out[28]= 6 aj[x]
    In[29]:= aj[aj[a]]
    Out[29]= a

Inverses
--------

The multiplicative identity is denoted `Id` in the program. At the present time, `Id` is set to 1.

A symbol `a` may have an inverse, which will be denoted by `inv[a]`.

    In[30]:= Id
    Out[30]= 1
    In[31]:= inv[a**b]
    Out[31]= inv[a**b]
    In[32]:= inv[a]**a
    Out[32]= 1
    In[33]:= a**inv[a]
    Out[33]= 1
    In[34]:= a**b**inv[b]
    Out[34]= a

Expand and Collect
------------------

One can collect noncommutative terms involving same powers of a symbol using `NCCollect`. `NCExpand` expand noncommutative products.

    In[35]:= NCExpand[(a+b)**x]
    Out[35]= a**x+b**x
    In[36]:= NCCollect[a**x+b**x,x]
    Out[36]= (a+b)**x
    In[37]:= NCCollect[tp[x]**a**x+tp[x]**b**x+z,{x,tp[x]}]
    Out[37]= z+tp[x]**(a+b)**x

Replace
-------

The Mathematica substitute commands, e.g. `Replace`, `ReplaceAll` (`/.`) and `ReplaceRepeated` (`//.`), are not reliable in `NCAlgebra`, so you must use our `NC` versions of these commands:

    In[38]:= NCReplace[x**a**b,a**b->c]
    Out[38]= x**a**b
    In[39]:= NCReplaceAll[tp[b**a]+b**a,b**a->p]
    Out[39]= p+tp[a]**tp[b]

USe [NCMakeRuleSymmetric](#NCMakeRuleSymmetric) and [NCMakeRuleSelfAdjoint](#NCMakeRuleSelfAdjoint) to automatically create symmetric and self adjoint versions of your rules:

    In[40]:= NCReplaceAll[tp[a**b]+w+a**b,a**b->c]
    Out[40]= c+w+tp[b]**tp[a]
    In[41]:= NCReplaceAll[tp[a**b]+w+a**b,NCMakeRuleSymmetric[a**b->c]]
    Out[41]= c+w+tp[c]

Rationals and Simplification
----------------------------

`NCSimplifyRational` attempts to simplify noncommutative rationals.

    In[42]:= f1=1+inv[d]**c**inv[S-a]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b\
             -inv[d]**c**inv[S-a+b**inv[d]**c]**b**inv[d]**c**inv[S-a]**b
    Out[42]= 1+inv[d]**c**inv[-a+S]**b-inv[d]**c**inv[-a+S+b**inv[d]**c]**b\
             -inv[d]**c**inv[-a+S+b**inv[d]**c]**b**inv[d]**c**inv[-a+S]**b
    In[43]:= NCSimplifyRational[f1]
    Out[43]= 1
    In[44]:= f2=2inv[1+2a]**a;
    In[45]:= NCSimplifyRational[f2]
    Out[45]= 1-inv[1+2 a]

`NCSR` is the alias for `NCSimplifyRational`.

    In[46]:= f3=a**inv[1-a];
    In[47]:= NCSR[f3]
    Out[47]= -1+inv[1-a]
    In[48]:= f4=inv[1-b**a]**inv[a];
    In[49]:= NCSR[f4]
    Out[49]= inv[a]+b**inv[1-b**a]

Calculus
--------

One can calculate directional derivatives with `DirectionalD` and noncommutative gradients with `NCGrad`.

    In[50]:= DirectionalD[x**x,x,h]
    Out[50]= h**x+x**h
    In[51]:= NCGrad[tp[x]**x+tp[x]**A**x+m**x,x]
    Out[51]= m+tp[x]**A+tp[x]**tp[A]+2 tp[x]

Matrices
--------

`NCAlgebra` has many algorithms that handle matrices with noncommutative entries.

    In[52]:= m1={{a,b},{c,d}}
    Out[52]= {{a,b},{c,d}}
    In[53]:= m2={{d,2},{e,3}}
    Out[53]= {{d,2},{e,3}}
    In[54]:= MatMult[m1,m2]
    Out[54]= {{a**d+b**e,2 a+3 b},{c**d+d**e,2 c+3 d}}

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

Groups
------

You can compute a complete list of rewrite rules for Groups using `NCGB`. See demos at http://math.ucsd.edu/~ncalg.

NCGBX
-----

`NCGBX` is a 100% Mathematica version of our NC Groebner Basis Algorithm and does not require C/C++ code compilation.

Look for demos in the `NC/NCPoly/DEMOS` subdirectory of the most current distributions.

**IMPORTANT:** Do not load NCGB and NCGBX simultaneously.

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

| Original                  | Transformed                     |
|---------------------------|---------------------------------|
| inv\[a\] inv\[1 + K a b\] | inv\[a\] - K b inv\[1 + K a b\] |
| inv\[a\] inv\[1 + K a\]   | inv\[a\] - K inv\[1 + K a\]     |
| inv\[1 + K a b\] inv\[b\] | inv\[b\] - K inv\[1 + K a b\] a |
| inv\[1 + K a\] inv\[a\]   | inv\[a\] - K inv\[1 + K a\]     |
| inv\[1 + K a b\] a        | a inv\[1 + K b a\]              |

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

See also: [NCDiretionalD](#NCDirectionalD), [NCGrad](#NCGrad).

DirectionalD
------------

`DirectionalD[expr,var,h]` takes the directional derivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

**DEPRECATION NOTICE**: This syntax is limited to one variable and is being deprecated in favor of the more general syntax in [NCDirectionalD](#NCDirectionalD).

See also: [NCDirectionalD](#DirectionalD)

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

**NCOutput** is a package that can be used to beautify the display of noncommutative expressions. NCOutput does not alter the internal representation of NC expressions, just the way they are displayed on the screen.

Members are:

-   [NCSetOutput](#NCSetOutput)
-   [NCOutputFunction](#NCOutputFunction)

NCOutputFunction
----------------

`NCOutputFunction[exp]` returns a formatted version of the expression `expr` which will be displayed to the screen.

See also: [NCSetOutput](#NCSetOutput).

NCSetOutput
-----------

`NCSetOutput[options]` controls the display of expressions in a special format without affecting the internal representation of the expression.

The following `options` can be given:

-   `Dot`: If *True* `x**y` is displayed as `x.y`;
-   `tp`: If *True* `tp[x]` is displayed as `x` with a superscript 'T';
-   `inv`: If *True* `inv[x]` is displayed as `x` with a superscript '-1';
-   `aj`: If *True* `aj[x]` is displayed as `x` with a superscript '\*';
-   `rt`: If *True* `rt[x]` is displayed as `x` with a superscript '1/2';
-   `Array`: If *True* matrices are displayed using `MatrixForm`;
-   `All`: Set all available options to *True* or *False*.

See also: [NCOutputFunciton](#NCOutputFunction).

NCPolynomial
============

This package contains functionality to convert an nc polynomial expression into an expanded efficient representation for an nc polynomial which can have commutative or noncommutative coefficients.

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

    exp = a ** x ** b - 2 x ** y ** c ** x + a ** c + d ** x
    p = NCToNCPolynomial[exp, {x, y}]
    NCPCoefficients[p, {x}]

returns

    {{1, d, 1}, {1, a, b}}

and

    NCPCoefficients[p, {x ** y, x}]

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

See also: [NCQuadratic](#NCQuadratic), [NCQuadraticMakeSymmetric](#NCQuadraticMakeSymmetric).

NCQuadraticToNCPolynomial
-------------------------

`NCQuadraticToNCPolynomial[rep]` takes the list `rep` produced by `NCQuadratic` and converts it back to an `NCPolynomial`.

`NCQuadraticToNCPolynomial[rep,options]` uses options.

The following options can be given:

-   `Collect` (*True*): controls whether the coefficients of the resulting `NCPolynomial` are collected to produce the minimal possible number of terms.

See also: [NCQuadratic](#NCQuadratic), [NCPolynomial](#NCPolynomial).

NCConvexity
===========

**NCConvexity** is a package that provides functionality to determine whether a rational or polynomial noncommutative function is convex.

Members are:

-   [NCConvexityRegion](#NCConvexityRegion)

NCConvexityRegion
-----------------

`NCConvexityRegion` is a function which can be used to determine whether a noncommutative function is convex or not.

See also: [NCMatrixOfQuadratics](#NCMatrixOfQuadratics).

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

`NCGragFunctions[expr]` returns a list with all fragments containing function of `expr`.

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

`NCGragIndeterminants[expr]` returns a list with all *Symbols* and fragments of functions appearing in `expr`.

It is a combination of `NCGrabSymbols` and `NCGrabFunctions`.

For example:

    NCGrabIndeterminants[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {x, y, inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x], tp[x], tp[y]}

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

NCTest
======

Members are:

-   [NCTest](#NCTest)
-   [NCTestRun](#NCTestRun)
-   [NCTestSummarize](#NCTestSummarize)

NCTest
------

`NCTest[expr,answer]` asserts whether `expr` is equal to `answer`. The result of the test is collected when `NCTest` is run from `NCTestRun`.

See also: [\#NCTestRun](#NCTestRun), [\#NCTestSummarize](#NCTestSummarize)

NCTestRun
---------

`NCTest[list]` runs the test files listed in `list` after appending the '.NCTest' suffix and return the results.

For example:

    results = NCTestRun[{"NCCollect", "NCSylvester"}]

will run the test files "NCCollec.NCTest" and "NCSylvester.NCTest" and return the results in `results`.

See also: [\#NCTest](#NCTest), [\#NCTestSummarize](#NCTestSummarize)

NCTestSummarize
---------------

`NCTestSummarize[results]` will print a summary of the results in `results` as produced by `NCTestRun`.

See also: [\#NCTestRun](#NCTestRun)

NCSDP
=====

**NCSDP** is a package that allows the symbolic manipulation and numeric solution of semidefinite programs.

Problems consist of symbolic noncommutative expressions representing inequalities and a list of rules for data replacement. For example the semidefinite program:
$$
\\begin{aligned}
\\min\_Y \\quad & &lt;I,Y&gt; \\\\
\\text{s.t.} \\quad & A Y + Y A^T + I \\preceq 0 \\\\
            & Y \\succeq 0
\\end{aligned}
$$
 can be solved by defining the noncommutative expressions

    << NCSDP`
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

In order to obtaining a numerical solution to an instance of the above semidefinite program one must provide a list of rules for data substitution. For example:

    A = {{0, 1}, {-1, -2}};
    data = {a -> A};

Equipped with a list of rules one can invoke [`NCSDP`](#NCSDP) to produce an instance of [`SDPSylvester`](#SDPSylvester):

    << SDPSylvester`
    {abc, rules} = NCSDP[F, vars, obj, data];

It is the resulting `abc` and `rules` objects that are used for calculating the numerical solution using [`SDPSolve`](#SDPSolve):

    {Y, X, S, flags} = SDPSolve[abc, rules];

The variables `Y` and `S` are the *primal* solutions and `X` is the *dual* solution.

An explicit symbolic dual problem can be calculated easily using [`NCSDPDual`](#NCSDPDual):

    {dIneqs, dVars, dObj} = NCSDPDual[ineqs, vars, obj];

The corresponding dual program is expressed in the *canonical form*:
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
 Dual semidefinite programs can be visualized using [`NCSDPDualForm`](#NCSDPDualForm) as in:

    NCSDPDualForm[dIneqs, dVars, dObj]

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

The package **SDP** provides a crude and highly inefficient way to define and solve semidefinite programs in standard form, that is vectorized. You do not need to load `NCAlgebra` if you just want to use the semidefinite program solver. But you still need to load `NC` as in:

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
 where *S* is a symmetric positive semidefinite matrix.

For convenience, problems can be stated as:
$$
\\begin{aligned} 
  \\min\_y \\quad & \\operatorname{obj}(y), \\\\
  \\text{s.t.} \\quad & \\operatorname{ineqs}(y) &gt;= 0
\\end{aligned}
$$
 where *o**b**j*(*y*) and *i**n**e**q**s*(*y*) are affine functions of the vector variable *y*.

Here is a simple example:

    ineqs = {y0 - 2, {{y1, y0}, {y0, 1}}, {{y2, y1}, {y1, 1}}};
    obj = y2;
    y = {y0, y1, y2};

The list of constraints in `ineqs` are to be interpreted as:
$$
\\begin{aligned} 
  y\_0 - 2 \\geq 0, \\\\
  \\begin{bmatrix} y\_1 & y\_0 \\\\ y\_0 & 1 \\end{bmatrix} \\succeq 0, \\\\
  \\begin{bmatrix} y\_2 & y\_1 \\\\ y\_1 & 1 \\end{bmatrix} \\succeq 0.
\\end{aligned}
$$
 The function [`SDPMatrices`](#SDPMatrices) convert the above symbolic problem into numerical data that can be used to solve an SDP.

    abc = SDPMatrices[by, ineqs, y]

All required data, that is *A*, *b*, and *c*, is stored in the variable `abc` as Mathematica's sparse matrices. Their contents can be revealed using the Mathematica command `Normal`.

    Normal[abc]

The resulting SDP is solved using [`SDPSolve`](#SDPSolve):

    {Y, X, S, flags} = SDPSolve[abc];

The variables `Y` and `S` are the *primal* solutions and `X` is the *dual* solution. Detailed information on the computed solution is found in the variable `flags`.

The package **SDP** is built so as to be easily overloaded with more efficient or more structure functions. See for example [SDPFlat](#SDPFlat) and [SDPSylvester](#SDPSylvester).

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
