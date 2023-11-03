# The NCAlgebra Suite

*Version 6.0.3*

## Authors

- J. William Helton[^1]
- Mauricio C. de Oliveira[^2]

with earlier contributions by Bob Miller & Mark Stankus

The program was written by the authors and by:

David Hurst, Daniel Lamm, Orlando Merino, Robert Obar, Henry Pfister,
Mike Walker, John Wavrik, Lois Yu, J. Camino, J. Griffin, J. Ovall,
T. Shaheen, John Shopple. The beginnings of the program come from
eran@slac. Considerable recent help came from Igor Klep and Aidan
Epperly.

Current primary support is from the
NSF Division of Mathematical Sciences.

This program was written with support from
AFOSR, NSF, ONR, Lab for Math and Statistics at UCSD,
UCSD Faculty Mentor Program,
and US Department of Education.

For NCAlgebra updates see:

[www.github.com/NCAlgebra/NC](https://www.github.com/NCAlgebra/NC)

Other versions of this document:

- [online](https://NCAlgebra.github.io)
- [PDF](./NCDocument.pdf)

## Copyright

- Helton and de Oliveira 2023
- Helton and de Oliveira 2017
- Helton 2002
- Helton and Miller June 1991

All rights reserved.

# Table of Contents

- <a href="#license" id="toc-license">License</a>
- <a href="#acknowledgements" id="toc-acknowledgements">Acknowledgements</a>
- <a href="#changes-in-version-60" id="toc-Version6_0"><span class="toc-section-number">1</span> Changes in Version 6.0</a>
  - <a href="#version-603" id="toc-Version6_0_3"><span class="toc-section-number">1.1</span> Version 6.0.3</a>
  - <a href="#version-602" id="toc-Version6_0_2"><span class="toc-section-number">1.2</span> Version 6.0.2</a>
  - <a href="#version-601" id="toc-Version6_0_1"><span class="toc-section-number">1.3</span> Version 6.0.1</a>
  - <a href="#version-600" id="toc-Version6_0_0"><span class="toc-section-number">1.4</span> Version 6.0.0</a>
- <a href="#changes-in-version-50" id="toc-Version5_0"><span class="toc-section-number">2</span> Changes in Version 5.0</a>
  - <a href="#version-506" id="toc-Version5_0_6"><span class="toc-section-number">2.1</span> Version 5.0.6</a>
  - <a href="#version-505" id="toc-Version5_0_5"><span class="toc-section-number">2.2</span> Version 5.0.5</a>
  - <a href="#version-504" id="toc-Version5_0_4"><span class="toc-section-number">2.3</span> Version 5.0.4</a>
  - <a href="#version-503" id="toc-Version5_0_3"><span class="toc-section-number">2.4</span> Version 5.0.3</a>
  - <a href="#version-502" id="toc-Version5_0_2"><span class="toc-section-number">2.5</span> Version 5.0.2</a>
  - <a href="#version-501" id="toc-Version5_0_1"><span class="toc-section-number">2.6</span> Version 5.0.1</a>
  - <a href="#version-500" id="toc-Version5_0_0"><span class="toc-section-number">2.7</span> Version 5.0.0</a>
- <a href="#introduction" id="toc-UserGuideIntroduction"><span class="toc-section-number">3</span> Introduction</a>
  - <a href="#installing-ncalgebra" id="toc-InstallingNCAlgebra"><span class="toc-section-number">3.1</span> Installing NCAlgebra</a>
  - <a href="#running-ncalgebra" id="toc-RunningNCAlgebra"><span class="toc-section-number">3.2</span> Running NCAlgebra</a>
  - <a href="#now-what" id="toc-now-what"><span class="toc-section-number">3.3</span> Now what?</a>
  - <a href="#testing" id="toc-testing"><span class="toc-section-number">3.4</span> Testing</a>
  - <a href="#pre-2017-ncgb-c-version" id="toc-pre-2017-ncgb-c-version"><span class="toc-section-number">3.5</span> Pre-2017 NCGB C++ version</a>
- <a href="#most-basic-commands" id="toc-MostBasicCommands"><span class="toc-section-number">4</span> Most Basic Commands</a>
  - <a href="#to-commute-or-not-to-commute" id="toc-to-commute-or-not-to-commute"><span class="toc-section-number">4.1</span> To Commute Or Not To Commute?</a>
  - <a href="#inverses" id="toc-BasicInverses"><span class="toc-section-number">4.2</span> Inverses</a>
  - <a href="#transposes-and-adjoints" id="toc-transposes-and-adjoints"><span class="toc-section-number">4.3</span> Transposes and Adjoints</a>
  - <a href="#replace" id="toc-BasicReplace"><span class="toc-section-number">4.4</span> Replace</a>
  - <a href="#polynomials" id="toc-polynomials"><span class="toc-section-number">4.5</span> Polynomials</a>
  - <a href="#rationals-and-simplification" id="toc-rationals-and-simplification"><span class="toc-section-number">4.6</span> Rationals and Simplification</a>
  - <a href="#calculus" id="toc-calculus"><span class="toc-section-number">4.7</span> Calculus</a>
  - <a href="#matrices" id="toc-BasicMatrices"><span class="toc-section-number">4.8</span> Matrices</a>
    - <a href="#inverses-products-adjoints-etc" id="toc-BasicMatrices:Inverses"><span class="toc-section-number">4.8.1</span> Inverses, Products, Adjoints, etc</a>
    - <a href="#lu-decomposition" id="toc-BasicMatrices:LUDecomposition"><span class="toc-section-number">4.8.2</span> LU Decomposition</a>
    - <a href="#lu-decomposition-with-complete-pivoting" id="toc-BasicMatrices:LUDecompositionWithCompletePivoting"><span class="toc-section-number">4.8.3</span> LU Decomposition with Complete Pivoting</a>
    - <a href="#ldl-decomposition" id="toc-BasicMatrices:LDLDecomposition"><span class="toc-section-number">4.8.4</span> LDL Decomposition</a>
    - <a href="#replace-with-matrices" id="toc-ReplaceWithMatrices"><span class="toc-section-number">4.8.5</span> Replace with Matrices</a>
  - <a href="#quadratic-polynomials-second-directional-derivatives-and-convexity" id="toc-Quadratic"><span class="toc-section-number">4.9</span> Quadratic Polynomials, Second Directional Derivatives and Convexity</a>
- <a href="#more-advanced-commands" id="toc-MoreAdvancedCommands"><span class="toc-section-number">5</span> More Advanced Commands</a>
  - <a href="#advanced-rules-and-replacements" id="toc-AdvancedReplace"><span class="toc-section-number">5.1</span> Advanced Rules and Replacements</a>
    - <a href="#replaceall-and-replacerepeated-often-fail" id="toc-replaceall-.-and-replacerepeated-.-often-fail"><span class="toc-section-number">5.1.1</span> <code>ReplaceAll</code> (<code>/.</code>) and <code>ReplaceRepeated</code> (<code>//.</code>) often fail</a>
    - <a href="#the-fix-is-ncreplace" id="toc-the-fix-is-ncreplace"><span class="toc-section-number">5.1.2</span> The fix is <code>NCReplace</code></a>
    - <a href="#matching-monomials-with-powers" id="toc-matching-monomials-with-powers"><span class="toc-section-number">5.1.3</span> Matching monomials with powers</a>
    - <a href="#trouble-with-block-and-module" id="toc-trouble-with-block-and-module"><span class="toc-section-number">5.1.4</span> Trouble with <code>Block</code> and <code>Module</code></a>
  - <a href="#expanding-matrix-products" id="toc-AdvancedMatrices"><span class="toc-section-number">5.2</span> Expanding matrix products</a>
    - <a href="#trouble-with-plus-and-matrices" id="toc-trouble-with-plus-and-matrices"><span class="toc-section-number">5.2.1</span> Trouble with <code>Plus</code> (<code>+</code>) and matrices</a>
  - <a href="#polynomials-with-commutative-coefficients" id="toc-PolysWithCommutativeCoefficients"><span class="toc-section-number">5.3</span> Polynomials with commutative coefficients</a>
  - <a href="#polynomials-with-noncommutative-coefficients" id="toc-PolysWithNonCommutativeCoefficients"><span class="toc-section-number">5.4</span> Polynomials with noncommutative coefficients</a>
  - <a href="#linear-polynomials" id="toc-Linear"><span class="toc-section-number">5.5</span> Linear polynomials</a>
- <a href="#noncommutative-gröbner-basis" id="toc-NCGB"><span class="toc-section-number">6</span> Noncommutative Gröbner Basis</a>
  - <a href="#what-is-a-gröbner-basis" id="toc-what-is-a-gröbner-basis"><span class="toc-section-number">6.1</span> What is a Gröbner Basis?</a>
  - <a href="#solving-equations" id="toc-solving-equations"><span class="toc-section-number">6.2</span> Solving Equations</a>
  - <a href="#a-slightly-more-challenging-example" id="toc-a-slightly-more-challenging-example"><span class="toc-section-number">6.3</span> A Slightly more Challenging Example</a>
  - <a href="#simplifying-polynomial-expressions" id="toc-simplifying-polynomial-expressions"><span class="toc-section-number">6.4</span> Simplifying Polynomial Expressions</a>
  - <a href="#polynomials-and-rules" id="toc-PolynomialsAndRules"><span class="toc-section-number">6.5</span> Polynomials and Rules</a>
  - <a href="#minimal-versus-reduced-gröbner-basis" id="toc-minimal-versus-reduced-gröbner-basis"><span class="toc-section-number">6.6</span> Minimal versus Reduced Gröbner Basis</a>
  - <a href="#simplifying-rational-expressions" id="toc-SimplifyingRationalExpressions"><span class="toc-section-number">6.7</span> Simplifying Rational Expressions</a>
  - <a href="#simplification-with-ncgbsimplifyrational" id="toc-simplification-with-ncgbsimplifyrational"><span class="toc-section-number">6.8</span> Simplification with NCGBSimplifyRational</a>
  - <a href="#ordering-on-variables-and-monomials" id="toc-Orderings"><span class="toc-section-number">6.9</span> Ordering on Variables and Monomials</a>
    - <a href="#lex-order-the-simplest-elimination-order" id="toc-lex-order-the-simplest-elimination-order"><span class="toc-section-number">6.9.1</span> Lex Order: the simplest elimination order</a>
    - <a href="#graded-lex-ordering-a-non-elimination-order" id="toc-graded-lex-ordering-a-non-elimination-order"><span class="toc-section-number">6.9.2</span> Graded Lex Ordering: a non-elimination order</a>
    - <a href="#multigraded-lex-ordering-a-variety-of-elimination-orders" id="toc-multigraded-lex-ordering-a-variety-of-elimination-orders"><span class="toc-section-number">6.9.3</span> Multigraded Lex Ordering: a variety of elimination orders</a>
  - <a href="#a-complete-example-the-partially-prescribed-matrix-inverse-problem" id="toc-a-complete-example-the-partially-prescribed-matrix-inverse-problem"><span class="toc-section-number">6.10</span> A Complete Example: the partially prescribed matrix inverse problem</a>
  - <a href="#advanced-processing-of-rational-expressions" id="toc-AdvancedProcessingOfRationalExpressions"><span class="toc-section-number">6.11</span> Advanced Processing of Rational Expressions</a>
- <a href="#semidefinite-programming" id="toc-SemidefiniteProgramming"><span class="toc-section-number">7</span> Semidefinite Programming</a>
  - <a href="#semidefinite-programs-in-matrix-variables" id="toc-semidefinite-programs-in-matrix-variables"><span class="toc-section-number">7.1</span> Semidefinite Programs in Matrix Variables</a>
  - <a href="#semidefinite-programs-in-vector-variables" id="toc-semidefinite-programs-in-vector-variables"><span class="toc-section-number">7.2</span> Semidefinite Programs in Vector Variables</a>
- <a href="#pretty-output-with-notebooks-and" id="toc-TeX"><span class="toc-section-number">8</span> Pretty Output with Notebooks and TeX </a>
  - <a href="#pretty-output" id="toc-Pretty_Output"><span class="toc-section-number">8.1</span> Pretty Output</a>
  - <a href="#using-nctex" id="toc-Using_NCTeX"><span class="toc-section-number">8.2</span> Using NCTeX</a>
    - <a href="#nctex-options" id="toc-NCTeX_Options"><span class="toc-section-number">8.2.1</span> NCTeX Options</a>
  - <a href="#using-nctexform" id="toc-Using_NCTeXForm"><span class="toc-section-number">8.3</span> Using NCTeXForm</a>
- <a href="#reference-manual" id="toc-ReferenceIntroduction"><span class="toc-section-number">9</span> Reference Manual</a>
  - <a href="#manual-installation" id="toc-ManualInstallation"><span class="toc-section-number">9.1</span> Manual Installation</a>
    - <a href="#via-git-clone" id="toc-via-git-clone"><span class="toc-section-number">9.1.1</span> Via <code>git clone</code></a>
    - <a href="#from-the-github-download-button" id="toc-from-the-github-download-button"><span class="toc-section-number">9.1.2</span> From the github download button</a>
    - <a href="#from-one-of-our-releases" id="toc-from-one-of-our-releases"><span class="toc-section-number">9.1.3</span> From one of our releases</a>
    - <a href="#post-download-installation" id="toc-post-download-installation"><span class="toc-section-number">9.1.4</span> Post-download installation</a>
  - <a href="#nc" id="toc-PackageNC"><span class="toc-section-number">9.2</span> NC</a>
  - <a href="#ncalgebra" id="toc-PackageNCAlgebra"><span class="toc-section-number">9.3</span> NCAlgebra</a>
    - <a href="#messages" id="toc-NCAlgebraMessages"><span class="toc-section-number">9.3.1</span> Messages</a>
    - <a href="#ncoptions" id="toc-PackageNCOptions"><span class="toc-section-number">9.3.2</span> NCOptions</a>
- <a href="#packages-for-manipulating-nc-expressions" id="toc-ManipulatingNCExpressions"><span class="toc-section-number">10</span> Packages for manipulating NC expressions</a>
  - <a href="#noncommutativemultiply" id="toc-PackageNonCommutativeMultiply"><span class="toc-section-number">10.1</span> NonCommutativeMultiply</a>
    - <a href="#aj" id="toc-aj"><span class="toc-section-number">10.1.1</span> aj</a>
    - <a href="#co" id="toc-co"><span class="toc-section-number">10.1.2</span> co</a>
    - <a href="#id" id="toc-Id"><span class="toc-section-number">10.1.3</span> Id</a>
    - <a href="#inv" id="toc-inv"><span class="toc-section-number">10.1.4</span> inv</a>
    - <a href="#rt" id="toc-rt"><span class="toc-section-number">10.1.5</span> rt</a>
    - <a href="#tp" id="toc-tp"><span class="toc-section-number">10.1.6</span> tp</a>
    - <a href="#commutativeq" id="toc-CommutativeQ"><span class="toc-section-number">10.1.7</span> CommutativeQ</a>
    - <a href="#noncommutativeq" id="toc-NonCommutativeQ"><span class="toc-section-number">10.1.8</span> NonCommutativeQ</a>
    - <a href="#setcommutative" id="toc-SetCommutative"><span class="toc-section-number">10.1.9</span> SetCommutative</a>
    - <a href="#setcommutativehold" id="toc-SetCommutativeHold"><span class="toc-section-number">10.1.10</span> SetCommutativeHold</a>
    - <a href="#setnoncommutative" id="toc-SetNonCommutative"><span class="toc-section-number">10.1.11</span> SetNonCommutative</a>
    - <a href="#setnoncommutativehold" id="toc-SetNonCommutativeHold"><span class="toc-section-number">10.1.12</span> SetNonCommutativeHold</a>
    - <a href="#setcommutativefunction" id="toc-SetCommutativeFunction"><span class="toc-section-number">10.1.13</span> SetCommutativeFunction</a>
    - <a href="#setnoncommutativefunction" id="toc-SetNonCommutativeFunction"><span class="toc-section-number">10.1.14</span> SetNonCommutativeFunction</a>
    - <a href="#snc" id="toc-SNC"><span class="toc-section-number">10.1.15</span> SNC</a>
    - <a href="#setcommutingoperators" id="toc-SetCommutingOperators"><span class="toc-section-number">10.1.16</span> SetCommutingOperators</a>
    - <a href="#unsetcommutingoperators" id="toc-UnsetCommutingOperators"><span class="toc-section-number">10.1.17</span> UnsetCommutingOperators</a>
    - <a href="#commutingoperatorsq" id="toc-CommutingOperatorsQ"><span class="toc-section-number">10.1.18</span> CommutingOperatorsQ</a>
    - <a href="#ncnoncommutativesymbolorsubscriptq" id="toc-NCNonCommutativeSymbolOrSubscriptQ"><span class="toc-section-number">10.1.19</span> NCNonCommutativeSymbolOrSubscriptQ</a>
    - <a href="#ncnoncommutativesymbolorsubscriptextendedq" id="toc-NCNonCommutativeSymbolOrSubscriptExtendedQ"><span class="toc-section-number">10.1.20</span> NCNonCommutativeSymbolOrSubscriptExtendedQ</a>
    - <a href="#ncpowerq" id="toc-NCPowerQ"><span class="toc-section-number">10.1.21</span> NCPowerQ</a>
    - <a href="#commutative" id="toc-Commutative"><span class="toc-section-number">10.1.22</span> Commutative</a>
    - <a href="#commuteeverything" id="toc-CommuteEverything"><span class="toc-section-number">10.1.23</span> CommuteEverything</a>
    - <a href="#begincommuteeverything" id="toc-BeginCommuteEverything"><span class="toc-section-number">10.1.24</span> BeginCommuteEverything</a>
    - <a href="#endcommuteeverything" id="toc-EndCommuteEverything"><span class="toc-section-number">10.1.25</span> EndCommuteEverything</a>
    - <a href="#expandnoncommutativemultiply" id="toc-ExpandNonCommutativeMultiply"><span class="toc-section-number">10.1.26</span> ExpandNonCommutativeMultiply</a>
    - <a href="#ncexpand" id="toc-NCExpand"><span class="toc-section-number">10.1.27</span> NCExpand</a>
    - <a href="#nce" id="toc-NCE"><span class="toc-section-number">10.1.28</span> NCE</a>
    - <a href="#ncexpandexponents" id="toc-NCExpandExponents"><span class="toc-section-number">10.1.29</span> NCExpandExponents</a>
    - <a href="#nctolist" id="toc-NCToList"><span class="toc-section-number">10.1.30</span> NCToList</a>
  - <a href="#nctr" id="toc-PackageNCTr"><span class="toc-section-number">10.2</span> NCTr</a>
    - <a href="#tr" id="toc-tr"><span class="toc-section-number">10.2.1</span> tr</a>
    - <a href="#sortcyclicpermutation" id="toc-SortCyclicPermutation"><span class="toc-section-number">10.2.2</span> SortCyclicPermutation</a>
    - <a href="#sortedcyclicpermutationq" id="toc-SortedCyclicPermutationQ"><span class="toc-section-number">10.2.3</span> SortedCyclicPermutationQ</a>
  - <a href="#nccollect" id="toc-PackageNCCollect"><span class="toc-section-number">10.3</span> NCCollect</a>
    - <a href="#nccollect-1" id="toc-NCCollect"><span class="toc-section-number">10.3.1</span> NCCollect</a>
    - <a href="#nccollectexponents" id="toc-NCCollectExponents"><span class="toc-section-number">10.3.2</span> NCCollectExponents</a>
    - <a href="#nccollectselfadjoint" id="toc-NCCollectSelfAdjoint"><span class="toc-section-number">10.3.3</span> NCCollectSelfAdjoint</a>
    - <a href="#nccollectsymmetric" id="toc-NCCollectSymmetric"><span class="toc-section-number">10.3.4</span> NCCollectSymmetric</a>
    - <a href="#ncstrongcollect" id="toc-NCStrongCollect"><span class="toc-section-number">10.3.5</span> NCStrongCollect</a>
    - <a href="#ncstrongcollectselfadjoint" id="toc-NCStrongCollectSelfAdjoint"><span class="toc-section-number">10.3.6</span> NCStrongCollectSelfAdjoint</a>
    - <a href="#ncstrongcollectsymmetric" id="toc-NCStrongCollectSymmetric"><span class="toc-section-number">10.3.7</span> NCStrongCollectSymmetric</a>
    - <a href="#nccompose" id="toc-NCCompose"><span class="toc-section-number">10.3.8</span> NCCompose</a>
    - <a href="#ncdecompose" id="toc-NCDecompose"><span class="toc-section-number">10.3.9</span> NCDecompose</a>
    - <a href="#nctermsofdegree" id="toc-NCTermsOfDegree"><span class="toc-section-number">10.3.10</span> NCTermsOfDegree</a>
    - <a href="#nctermsoftotaldegree" id="toc-NCTermsOfTotalDegree"><span class="toc-section-number">10.3.11</span> NCTermsOfTotalDegree</a>
  - <a href="#ncreplace" id="toc-PackageNCReplace"><span class="toc-section-number">10.4</span> NCReplace</a>
    - <a href="#ncreplace-1" id="toc-NCReplace"><span class="toc-section-number">10.4.1</span> NCReplace</a>
    - <a href="#ncreplaceall" id="toc-NCReplaceAll"><span class="toc-section-number">10.4.2</span> NCReplaceAll</a>
    - <a href="#ncreplacelist" id="toc-NCReplaceList"><span class="toc-section-number">10.4.3</span> NCReplaceList</a>
    - <a href="#ncreplacerepeated" id="toc-NCReplaceRepeated"><span class="toc-section-number">10.4.4</span> NCReplaceRepeated</a>
    - <a href="#ncexpandreplacerepeated" id="toc-NCExpandReplaceRepeated"><span class="toc-section-number">10.4.5</span> NCExpandReplaceRepeated</a>
    - <a href="#ncr" id="toc-NCR"><span class="toc-section-number">10.4.6</span> NCR</a>
    - <a href="#ncra" id="toc-NCRA"><span class="toc-section-number">10.4.7</span> NCRA</a>
    - <a href="#ncrr" id="toc-NCRR"><span class="toc-section-number">10.4.8</span> NCRR</a>
    - <a href="#ncrl" id="toc-NCRL"><span class="toc-section-number">10.4.9</span> NCRL</a>
    - <a href="#ncmakerulesymmetric" id="toc-NCMakeRuleSymmetric"><span class="toc-section-number">10.4.10</span> NCMakeRuleSymmetric</a>
    - <a href="#ncmakeruleselfadjoint" id="toc-NCMakeRuleSelfAdjoint"><span class="toc-section-number">10.4.11</span> NCMakeRuleSelfAdjoint</a>
    - <a href="#ncreplacesymmetric" id="toc-NCReplaceSymmetric"><span class="toc-section-number">10.4.12</span> NCReplaceSymmetric</a>
    - <a href="#ncreplaceallsymmetric" id="toc-NCReplaceAllSymmetric"><span class="toc-section-number">10.4.13</span> NCReplaceAllSymmetric</a>
    - <a href="#ncreplacerepeatedsymmetric" id="toc-NCReplaceRepeatedSymmetric"><span class="toc-section-number">10.4.14</span> NCReplaceRepeatedSymmetric</a>
    - <a href="#ncexpandreplacerepeatedsymmetric" id="toc-NCExpandReplaceRepeatedSymmetric"><span class="toc-section-number">10.4.15</span> NCExpandReplaceRepeatedSymmetric</a>
    - <a href="#ncreplacelistsymmetric" id="toc-NCReplaceListSymmetric"><span class="toc-section-number">10.4.16</span> NCReplaceListSymmetric</a>
    - <a href="#ncrsym" id="toc-NCRSym"><span class="toc-section-number">10.4.17</span> NCRSym</a>
    - <a href="#ncrasym" id="toc-NCRASym"><span class="toc-section-number">10.4.18</span> NCRASym</a>
    - <a href="#ncrrsym" id="toc-NCRRSym"><span class="toc-section-number">10.4.19</span> NCRRSym</a>
    - <a href="#ncrlsym" id="toc-NCRLSym"><span class="toc-section-number">10.4.20</span> NCRLSym</a>
    - <a href="#ncreplaceselfadjoint" id="toc-NCReplaceSelfAdjoint"><span class="toc-section-number">10.4.21</span> NCReplaceSelfAdjoint</a>
    - <a href="#ncreplaceallselfadjoint" id="toc-NCReplaceAllSelfAdjoint"><span class="toc-section-number">10.4.22</span> NCReplaceAllSelfAdjoint</a>
    - <a href="#ncreplacerepeatedselfadjoint" id="toc-NCReplaceRepeatedSelfAdjoint"><span class="toc-section-number">10.4.23</span> NCReplaceRepeatedSelfAdjoint</a>
    - <a href="#ncexpandreplacerepeatedselfadjoint" id="toc-NCExpandReplaceRepeatedSelfAdjoint"><span class="toc-section-number">10.4.24</span> NCExpandReplaceRepeatedSelfAdjoint</a>
    - <a href="#ncreplacelistselfadjoint" id="toc-NCReplaceListSelfAdjoint"><span class="toc-section-number">10.4.25</span> NCReplaceListSelfAdjoint</a>
    - <a href="#ncrsa" id="toc-NCRSA"><span class="toc-section-number">10.4.26</span> NCRSA</a>
    - <a href="#ncrasa" id="toc-NCRASA"><span class="toc-section-number">10.4.27</span> NCRASA</a>
    - <a href="#ncrrsa" id="toc-NCRRSA"><span class="toc-section-number">10.4.28</span> NCRRSA</a>
    - <a href="#ncrlsa" id="toc-NCRLSA"><span class="toc-section-number">10.4.29</span> NCRLSA</a>
    - <a href="#ncmatrixexpand" id="toc-NCMatrixExpand"><span class="toc-section-number">10.4.30</span> NCMatrixExpand</a>
    - <a href="#ncmatrixreplaceall" id="toc-NCMatrixReplaceAll"><span class="toc-section-number">10.4.31</span> NCMatrixReplaceAll</a>
    - <a href="#ncmatrixreplacerepeated" id="toc-NCMatrixReplaceRepeated"><span class="toc-section-number">10.4.32</span> NCMatrixReplaceRepeated</a>
    - <a href="#ncreplacepowerrule" id="toc-NCReplacePowerRule"><span class="toc-section-number">10.4.33</span> NCReplacePowerRule</a>
  - <a href="#ncselfadjoint" id="toc-PackageNCSelfAdjoint"><span class="toc-section-number">10.5</span> NCSelfAdjoint</a>
    - <a href="#ncsymmetricq" id="toc-NCSymmetricQ"><span class="toc-section-number">10.5.1</span> NCSymmetricQ</a>
    - <a href="#ncsymmetrictest" id="toc-NCSymmetricTest"><span class="toc-section-number">10.5.2</span> NCSymmetricTest</a>
    - <a href="#ncsymmetricpart" id="toc-NCSymmetricPart"><span class="toc-section-number">10.5.3</span> NCSymmetricPart</a>
    - <a href="#ncselfadjointq" id="toc-NCSelfAdjointQ"><span class="toc-section-number">10.5.4</span> NCSelfAdjointQ</a>
    - <a href="#ncselfadjointtest" id="toc-NCSelfAdjointTest"><span class="toc-section-number">10.5.5</span> NCSelfAdjointTest</a>
  - <a href="#ncsimplifyrational" id="toc-PackageNCSimplifyRational"><span class="toc-section-number">10.6</span> NCSimplifyRational</a>
    - <a href="#ncnormalizeinverse" id="toc-NCNormalizeInverse"><span class="toc-section-number">10.6.1</span> NCNormalizeInverse</a>
    - <a href="#ncsimplifyrational-1" id="toc-NCSimplifyRational"><span class="toc-section-number">10.6.2</span> NCSimplifyRational</a>
    - <a href="#ncsr" id="toc-NCSR"><span class="toc-section-number">10.6.3</span> NCSR</a>
    - <a href="#ncsimplifyrationalsinglepass" id="toc-NCSimplifyRationalSinglePass"><span class="toc-section-number">10.6.4</span> NCSimplifyRationalSinglePass</a>
    - <a href="#ncpresimplifyrational" id="toc-NCPreSimplifyRational"><span class="toc-section-number">10.6.5</span> NCPreSimplifyRational</a>
    - <a href="#ncpresimplifyrationalsinglepass" id="toc-NCPreSimplifyRationalSinglePass"><span class="toc-section-number">10.6.6</span> NCPreSimplifyRationalSinglePass</a>
  - <a href="#ncdiff" id="toc-PackageNCDiff"><span class="toc-section-number">10.7</span> NCDiff</a>
    - <a href="#ncdirectionald" id="toc-NCDirectionalD"><span class="toc-section-number">10.7.1</span> NCDirectionalD</a>
    - <a href="#ncgrad" id="toc-NCGrad"><span class="toc-section-number">10.7.2</span> NCGrad</a>
    - <a href="#nchessian" id="toc-NCHessian"><span class="toc-section-number">10.7.3</span> NCHessian</a>
    - <a href="#directionald" id="toc-DirectionalD"><span class="toc-section-number">10.7.4</span> DirectionalD</a>
    - <a href="#ncintegrate" id="toc-NCIntegrate"><span class="toc-section-number">10.7.5</span> NCIntegrate</a>
  - <a href="#ncconvexity" id="toc-PackageNCConvexity"><span class="toc-section-number">10.8</span> NCConvexity</a>
    - <a href="#ncindependent" id="toc-NCIndependent"><span class="toc-section-number">10.8.1</span> NCIndependent</a>
    - <a href="#ncconvexityregion" id="toc-NCConvexityRegion"><span class="toc-section-number">10.8.2</span> NCConvexityRegion</a>
- <a href="#packages-for-manipulating-nc-block-matrices" id="toc-packages-for-manipulating-nc-block-matrices"><span class="toc-section-number">11</span> Packages for manipulating NC block matrices</a>
  - <a href="#ncdot" id="toc-PackageNCDot"><span class="toc-section-number">11.1</span> NCDot</a>
    - <a href="#tpmat" id="toc-tpMat"><span class="toc-section-number">11.1.1</span> tpMat</a>
    - <a href="#ajmat" id="toc-ajMat"><span class="toc-section-number">11.1.2</span> ajMat</a>
    - <a href="#comat" id="toc-coMat"><span class="toc-section-number">11.1.3</span> coMat</a>
    - <a href="#ncdot-1" id="toc-NCDot"><span class="toc-section-number">11.1.4</span> NCDot</a>
    - <a href="#ncinverse" id="toc-NCInverse"><span class="toc-section-number">11.1.5</span> NCInverse</a>
  - <a href="#ncmatrixdecompositions" id="toc-PackageNCMatrixDecompositions"><span class="toc-section-number">11.2</span> NCMatrixDecompositions</a>
    - <a href="#ncludecompositionwithpartialpivoting" id="toc-NCLUDecompositionWithPartialPivoting"><span class="toc-section-number">11.2.1</span> NCLUDecompositionWithPartialPivoting</a>
    - <a href="#ncludecompositionwithcompletepivoting" id="toc-NCLUDecompositionWithCompletePivoting"><span class="toc-section-number">11.2.2</span> NCLUDecompositionWithCompletePivoting</a>
    - <a href="#ncldldecomposition" id="toc-NCLDLDecomposition"><span class="toc-section-number">11.2.3</span> NCLDLDecomposition</a>
    - <a href="#ncuppertriangularsolve" id="toc-NCUpperTriangularSolve"><span class="toc-section-number">11.2.4</span> NCUpperTriangularSolve</a>
    - <a href="#nclowertriangularsolve" id="toc-NCLowerTriangularSolve"><span class="toc-section-number">11.2.5</span> NCLowerTriangularSolve</a>
    - <a href="#ncluinverse" id="toc-NCLUInverse"><span class="toc-section-number">11.2.6</span> NCLUInverse</a>
    - <a href="#nclupartialpivoting" id="toc-NCLUPartialPivoting"><span class="toc-section-number">11.2.7</span> NCLUPartialPivoting</a>
    - <a href="#nclucompletepivoting" id="toc-NCLUCompletePivoting"><span class="toc-section-number">11.2.8</span> NCLUCompletePivoting</a>
    - <a href="#ncleftdivide" id="toc-NCLeftDivide"><span class="toc-section-number">11.2.9</span> NCLeftDivide</a>
    - <a href="#ncrightdivide" id="toc-NCRightDivide"><span class="toc-section-number">11.2.10</span> NCRightDivide</a>
  - <a href="#matrixdecompositions-linear-algebra-templates" id="toc-PackageMatrixDecompositions"><span class="toc-section-number">11.3</span> MatrixDecompositions: linear algebra templates</a>
    - <a href="#ludecompositionwithpartialpivoting" id="toc-LUDecompositionWithPartialPivoting"><span class="toc-section-number">11.3.1</span> LUDecompositionWithPartialPivoting</a>
    - <a href="#ludecompositionwithcompletepivoting" id="toc-LUDecompositionWithCompletePivoting"><span class="toc-section-number">11.3.2</span> LUDecompositionWithCompletePivoting</a>
    - <a href="#ldldecomposition" id="toc-LDLDecomposition"><span class="toc-section-number">11.3.3</span> LDLDecomposition</a>
    - <a href="#uppertriangularsolve" id="toc-UpperTriangularSolve"><span class="toc-section-number">11.3.4</span> UpperTriangularSolve</a>
    - <a href="#lowertriangularsolve" id="toc-LowerTriangularSolve"><span class="toc-section-number">11.3.5</span> LowerTriangularSolve</a>
    - <a href="#luinverse" id="toc-LUInverse"><span class="toc-section-number">11.3.6</span> LUInverse</a>
    - <a href="#getlumatrices" id="toc-GetLUMatrices"><span class="toc-section-number">11.3.7</span> GetLUMatrices</a>
    - <a href="#getfulllumatrices" id="toc-GetFullLUMatrices"><span class="toc-section-number">11.3.8</span> GetFullLUMatrices</a>
    - <a href="#getldumatrices" id="toc-GetLDUMatrices"><span class="toc-section-number">11.3.9</span> GetLDUMatrices</a>
    - <a href="#getfullldumatrices" id="toc-GetFullLDUMatrices"><span class="toc-section-number">11.3.10</span> GetFullLDUMatrices</a>
    - <a href="#getdiagonal" id="toc-GetDiagonal"><span class="toc-section-number">11.3.11</span> GetDiagonal</a>
    - <a href="#lupartialpivoting" id="toc-LUPartialPivoting"><span class="toc-section-number">11.3.12</span> LUPartialPivoting</a>
    - <a href="#lucompletepivoting" id="toc-LUCompletePivoting"><span class="toc-section-number">11.3.13</span> LUCompletePivoting</a>
    - <a href="#lurowreduce" id="toc-LURowReduce"><span class="toc-section-number">11.3.14</span> LURowReduce</a>
    - <a href="#lurowreduceincremental" id="toc-LURowReduceIncremental"><span class="toc-section-number">11.3.15</span> LURowReduceIncremental</a>
- <a href="#packages-for-pretty-output-testing-and-utilities" id="toc-packages-for-pretty-output-testing-and-utilities"><span class="toc-section-number">12</span> Packages for pretty output, testing, and utilities</a>
  - <a href="#ncoutput" id="toc-PackageNCOutput"><span class="toc-section-number">12.1</span> NCOutput</a>
    - <a href="#ncsetoutput" id="toc-NCSetOutput"><span class="toc-section-number">12.1.1</span> NCSetOutput</a>
  - <a href="#nctex" id="toc-PackageNCTeX"><span class="toc-section-number">12.2</span> NCTeX</a>
    - <a href="#nctex-1" id="toc-NCTeX"><span class="toc-section-number">12.2.1</span> NCTeX</a>
    - <a href="#ncrundvips" id="toc-NCRunDVIPS"><span class="toc-section-number">12.2.2</span> NCRunDVIPS</a>
    - <a href="#ncrunlatex" id="toc-NCRunLaTeX"><span class="toc-section-number">12.2.3</span> NCRunLaTeX</a>
    - <a href="#ncrunpdflatex" id="toc-NCRunPDFLaTeX"><span class="toc-section-number">12.2.4</span> NCRunPDFLaTeX</a>
    - <a href="#ncrunpdfviewer" id="toc-NCRunPDFViewer"><span class="toc-section-number">12.2.5</span> NCRunPDFViewer</a>
    - <a href="#ncrunps2pdf" id="toc-NCRunPS2PDF"><span class="toc-section-number">12.2.6</span> NCRunPS2PDF</a>
  - <a href="#nctexform" id="toc-PackageNCTeXForm"><span class="toc-section-number">12.3</span> NCTeXForm</a>
    - <a href="#nctexform-1" id="toc-NCTeXForm"><span class="toc-section-number">12.3.1</span> NCTeXForm</a>
    - <a href="#nctexformsetstarstar" id="toc-NCTeXFormSetStarStar"><span class="toc-section-number">12.3.2</span> NCTeXFormSetStarStar</a>
    - <a href="#nctexformsetstar" id="toc-NCTeXFormSetStar"><span class="toc-section-number">12.3.3</span> NCTeXFormSetStar</a>
  - <a href="#ncrun" id="toc-PackageNCRun"><span class="toc-section-number">12.4</span> NCRun</a>
    - <a href="#ncrun-1" id="toc-NCRun"><span class="toc-section-number">12.4.1</span> NCRun</a>
  - <a href="#nctest" id="toc-PackageNCTest"><span class="toc-section-number">12.5</span> NCTest</a>
    - <a href="#nctest-1" id="toc-NCTest"><span class="toc-section-number">12.5.1</span> NCTest</a>
    - <a href="#nctestcheck" id="toc-NCTestCheck"><span class="toc-section-number">12.5.2</span> NCTestCheck</a>
    - <a href="#nctestrun" id="toc-NCTestRun"><span class="toc-section-number">12.5.3</span> NCTestRun</a>
    - <a href="#nctestsummarize" id="toc-NCTestSummarize"><span class="toc-section-number">12.5.4</span> NCTestSummarize</a>
  - <a href="#ncdebug" id="toc-PackageNCDebug"><span class="toc-section-number">12.6</span> NCDebug</a>
    - <a href="#ncdebug-1" id="toc-NCDebug"><span class="toc-section-number">12.6.1</span> NCDebug</a>
  - <a href="#ncutil" id="toc-PackageNCUtil"><span class="toc-section-number">12.7</span> NCUtil</a>
    - <a href="#ncgrabsymbols" id="toc-NCGrabSymbols"><span class="toc-section-number">12.7.1</span> NCGrabSymbols</a>
    - <a href="#ncgrabncsymbols" id="toc-NCGrabNCSymbols"><span class="toc-section-number">12.7.2</span> NCGrabNCSymbols</a>
    - <a href="#ncgrabfunctions" id="toc-NCGrabFunctions"><span class="toc-section-number">12.7.3</span> NCGrabFunctions</a>
    - <a href="#ncgrabindeterminants" id="toc-NCGrabIndeterminants"><span class="toc-section-number">12.7.4</span> NCGrabIndeterminants</a>
    - <a href="#ncvariables" id="toc-NCVariables"><span class="toc-section-number">12.7.5</span> NCVariables</a>
    - <a href="#ncconsolidatelist" id="toc-NCConsolidateList"><span class="toc-section-number">12.7.6</span> NCConsolidateList</a>
    - <a href="#ncconsistentq" id="toc-NCConsistentQ"><span class="toc-section-number">12.7.7</span> NCConsistentQ</a>
    - <a href="#ncsymbolorsubscriptq" id="toc-NCSymbolOrSubscriptQ"><span class="toc-section-number">12.7.8</span> NCSymbolOrSubscriptQ</a>
    - <a href="#ncsymbolorsubscriptextendedq" id="toc-NCSymbolOrSubscriptExtendedQ"><span class="toc-section-number">12.7.9</span> NCSymbolOrSubscriptExtendedQ</a>
    - <a href="#ncleafcount" id="toc-NCLeafCount"><span class="toc-section-number">12.7.10</span> NCLeafCount</a>
    - <a href="#ncreplacedata" id="toc-NCReplaceData"><span class="toc-section-number">12.7.11</span> NCReplaceData</a>
    - <a href="#nctoexpression" id="toc-NCToExpression"><span class="toc-section-number">12.7.12</span> NCToExpression</a>
    - <a href="#notmatrixq" id="toc-NotMatrixQ"><span class="toc-section-number">12.7.13</span> NotMatrixQ</a>
- <a href="#data-structures-for-fast-calculations" id="toc-data-structures-for-fast-calculations"><span class="toc-section-number">13</span> Data structures for fast calculations</a>
  - <a href="#ncpoly" id="toc-PackageNCPoly"><span class="toc-section-number">13.1</span> NCPoly</a>
    - <a href="#efficient-storage-of-nc-polynomials-with-rational-coefficients" id="toc-efficient-storage-of-nc-polynomials-with-rational-coefficients"><span class="toc-section-number">13.1.1</span> Efficient storage of NC polynomials with rational coefficients</a>
    - <a href="#ways-to-represent-nc-polynomials" id="toc-ways-to-represent-nc-polynomials"><span class="toc-section-number">13.1.2</span> Ways to represent NC polynomials</a>
    - <a href="#access-and-utlity-functions" id="toc-access-and-utlity-functions"><span class="toc-section-number">13.1.3</span> Access and utlity functions</a>
    - <a href="#formating-functions" id="toc-formating-functions"><span class="toc-section-number">13.1.4</span> Formating functions</a>
    - <a href="#arithmetic-functions" id="toc-arithmetic-functions"><span class="toc-section-number">13.1.5</span> Arithmetic functions</a>
    - <a href="#state-space-realization-functions" id="toc-state-space-realization-functions"><span class="toc-section-number">13.1.6</span> State space realization functions</a>
    - <a href="#auxiliary-functions" id="toc-auxiliary-functions"><span class="toc-section-number">13.1.7</span> Auxiliary functions</a>
  - <a href="#ncpolyinterface" id="toc-PackageNCPolyInterface"><span class="toc-section-number">13.2</span> NCPolyInterface</a>
    - <a href="#nctoncpoly" id="toc-NCToNCPoly"><span class="toc-section-number">13.2.1</span> NCToNCPoly</a>
    - <a href="#ncpolytonc" id="toc-NCPolyToNC"><span class="toc-section-number">13.2.2</span> NCPolyToNC</a>
    - <a href="#ncmonomialorderq" id="toc-NCMonomialOrderQ"><span class="toc-section-number">13.2.3</span> NCMonomialOrderQ</a>
    - <a href="#ncmonomialorder" id="toc-NCMonomialOrder"><span class="toc-section-number">13.2.4</span> NCMonomialOrder</a>
    - <a href="#ncrationaltoncpoly" id="toc-NCRationalToNCPoly"><span class="toc-section-number">13.2.5</span> NCRationalToNCPoly</a>
    - <a href="#ncruletopoly" id="toc-NCRuleToPoly"><span class="toc-section-number">13.2.6</span> NCRuleToPoly</a>
    - <a href="#nctorule" id="toc-NCToRule"><span class="toc-section-number">13.2.7</span> NCToRule</a>
    - <a href="#ncreduce" id="toc-NCReduce"><span class="toc-section-number">13.2.8</span> NCReduce</a>
    - <a href="#ncreducerepeated" id="toc-NCReduceRepeated"><span class="toc-section-number">13.2.9</span> NCReduceRepeated</a>
    - <a href="#ncmonomiallist" id="toc-NCMonomialList"><span class="toc-section-number">13.2.10</span> NCMonomialList</a>
    - <a href="#nccoefficientrules" id="toc-NCCoefficientRules"><span class="toc-section-number">13.2.11</span> NCCoefficientRules</a>
    - <a href="#nccoefficientlist" id="toc-NCCoefficientList"><span class="toc-section-number">13.2.12</span> NCCoefficientList</a>
    - <a href="#nccoefficientq" id="toc-NCCoefficientQ"><span class="toc-section-number">13.2.13</span> NCCoefficientQ</a>
    - <a href="#ncmonomialq" id="toc-NCMonomialQ"><span class="toc-section-number">13.2.14</span> NCMonomialQ</a>
    - <a href="#ncpolynomialq" id="toc-NCPolynomialQ"><span class="toc-section-number">13.2.15</span> NCPolynomialQ</a>
  - <a href="#ncpolynomial" id="toc-PackageNCPolynomial"><span class="toc-section-number">13.3</span> NCPolynomial</a>
    - <a href="#efficient-storage-of-nc-polynomials-with-nc-coefficients" id="toc-efficient-storage-of-nc-polynomials-with-nc-coefficients"><span class="toc-section-number">13.3.1</span> Efficient storage of NC polynomials with nc coefficients</a>
    - <a href="#ways-to-represent-nc-polynomials-1" id="toc-ways-to-represent-nc-polynomials-1"><span class="toc-section-number">13.3.2</span> Ways to represent NC polynomials</a>
    - <a href="#grouping-terms-by-degree" id="toc-grouping-terms-by-degree"><span class="toc-section-number">13.3.3</span> Grouping terms by degree</a>
    - <a href="#utilities" id="toc-utilities"><span class="toc-section-number">13.3.4</span> Utilities</a>
    - <a href="#operations-on-nc-polynomials" id="toc-operations-on-nc-polynomials"><span class="toc-section-number">13.3.5</span> Operations on NC polynomials</a>
  - <a href="#ncquadratic" id="toc-PackageNCQuadratic"><span class="toc-section-number">13.4</span> NCQuadratic</a>
    - <a href="#nctoncquadratic" id="toc-NCToNCQuadratic"><span class="toc-section-number">13.4.1</span> NCToNCQuadratic</a>
    - <a href="#ncptoncquadratic" id="toc-NCPToNCQuadratic"><span class="toc-section-number">13.4.2</span> NCPToNCQuadratic</a>
    - <a href="#ncquadratictonc" id="toc-NCQuadraticToNC"><span class="toc-section-number">13.4.3</span> NCQuadraticToNC</a>
    - <a href="#ncquadratictoncpolynomial" id="toc-NCQuadraticToNCPolynomial"><span class="toc-section-number">13.4.4</span> NCQuadraticToNCPolynomial</a>
    - <a href="#ncmatrixofquadratic" id="toc-NCMatrixOfQuadratic"><span class="toc-section-number">13.4.5</span> NCMatrixOfQuadratic</a>
    - <a href="#ncquadraticmakesymmetric" id="toc-NCQuadraticMakeSymmetric"><span class="toc-section-number">13.4.6</span> NCQuadraticMakeSymmetric</a>
  - <a href="#ncsylvester" id="toc-PackageNCSylvester"><span class="toc-section-number">13.5</span> NCSylvester</a>
    - <a href="#nctoncsylvester" id="toc-NCToNCSylvester"><span class="toc-section-number">13.5.1</span> NCToNCSylvester</a>
    - <a href="#ncptoncsylvester" id="toc-NCPToNCSylvester"><span class="toc-section-number">13.5.2</span> NCPToNCSylvester</a>
    - <a href="#ncsylvestertonc" id="toc-NCSylvesterToNC"><span class="toc-section-number">13.5.3</span> NCSylvesterToNC</a>
    - <a href="#ncsylvestertoncpolynomial" id="toc-NCSylvesterToNCPolynomial"><span class="toc-section-number">13.5.4</span> NCSylvesterToNCPolynomial</a>
- <a href="#noncommutative-gröbner-bases-algorithms" id="toc-NCGBChapter"><span class="toc-section-number">14</span> Noncommutative Gröbner Bases Algorithms</a>
  - <a href="#ncgbx" id="toc-PackageNCGBX"><span class="toc-section-number">14.1</span> NCGBX</a>
    - <a href="#setmonomialorder" id="toc-SetMonomialOrder"><span class="toc-section-number">14.1.1</span> SetMonomialOrder</a>
    - <a href="#setknowns" id="toc-SetKnowns"><span class="toc-section-number">14.1.2</span> SetKnowns</a>
    - <a href="#setunknowns" id="toc-SetUnknowns"><span class="toc-section-number">14.1.3</span> SetUnknowns</a>
    - <a href="#clearmonomialorder" id="toc-ClearMonomialOrder"><span class="toc-section-number">14.1.4</span> ClearMonomialOrder</a>
    - <a href="#getmonomialorder" id="toc-GetMonomialOrder"><span class="toc-section-number">14.1.5</span> GetMonomialOrder</a>
    - <a href="#printmonomialorder" id="toc-PrintMonomialOrder"><span class="toc-section-number">14.1.6</span> PrintMonomialOrder</a>
    - <a href="#ncmakegb" id="toc-NCMakeGB"><span class="toc-section-number">14.1.7</span> NCMakeGB</a>
    - <a href="#ncprocess" id="toc-NCProcess"><span class="toc-section-number">14.1.8</span> NCProcess</a>
    - <a href="#ncgbsimplifyrational" id="toc-NCGBSimplifyRational"><span class="toc-section-number">14.1.9</span> NCGBSimplifyRational</a>
  - <a href="#ncpolygroebner" id="toc-PackageNCPolyGroebner"><span class="toc-section-number">14.2</span> NCPolyGroebner</a>
    - <a href="#ncpolygroebner-1" id="toc-NCPolyGroebner"><span class="toc-section-number">14.2.1</span> NCPolyGroebner</a>
  - <a href="#ncgb" id="toc-PackageNCGB"><span class="toc-section-number">14.3</span> NCGB</a>
- <a href="#semidefinite-programming-algorithms" id="toc-SDPChapter"><span class="toc-section-number">15</span> Semidefinite Programming Algorithms</a>
  - <a href="#ncsdp" id="toc-PackageNCSDP"><span class="toc-section-number">15.1</span> NCSDP</a>
    - <a href="#ncsdp-1" id="toc-NCSDP"><span class="toc-section-number">15.1.1</span> NCSDP</a>
    - <a href="#ncsdpform" id="toc-NCSDPForm"><span class="toc-section-number">15.1.2</span> NCSDPForm</a>
    - <a href="#ncsdpdual" id="toc-NCSDPDual"><span class="toc-section-number">15.1.3</span> NCSDPDual</a>
    - <a href="#ncsdpdualform" id="toc-NCSDPDualForm"><span class="toc-section-number">15.1.4</span> NCSDPDualForm</a>
  - <a href="#sdp" id="toc-PackageSDP"><span class="toc-section-number">15.2</span> SDP</a>
    - <a href="#sdpmatrices" id="toc-SDPMatrices"><span class="toc-section-number">15.2.1</span> SDPMatrices</a>
    - <a href="#sdpsolve" id="toc-SDPSolve"><span class="toc-section-number">15.2.2</span> SDPSolve</a>
    - <a href="#sdpeval" id="toc-SDPEval"><span class="toc-section-number">15.2.3</span> SDPEval</a>
    - <a href="#sdpprimaleval" id="toc-SDPPrimalEval"><span class="toc-section-number">15.2.4</span> SDPPrimalEval</a>
    - <a href="#sdpdualeval" id="toc-SDPDualEval"><span class="toc-section-number">15.2.5</span> SDPDualEval</a>
    - <a href="#sdpsylvestereval" id="toc-SDPSylvesterEval"><span class="toc-section-number">15.2.6</span> SDPSylvesterEval</a>
  - <a href="#sdpflat" id="toc-PackageSDPFlat"><span class="toc-section-number">15.3</span> SDPFlat</a>
    - <a href="#sdpflatdata" id="toc-SDPFlatData"><span class="toc-section-number">15.3.1</span> SDPFlatData</a>
    - <a href="#sdpflatprimaleval" id="toc-SDPFlatPrimalEval"><span class="toc-section-number">15.3.2</span> SDPFlatPrimalEval</a>
    - <a href="#sdpflatdualeval" id="toc-SDPFlatDualEval"><span class="toc-section-number">15.3.3</span> SDPFlatDualEval</a>
    - <a href="#sdpflatsylvestereval" id="toc-SDPFlatSylvesterEval"><span class="toc-section-number">15.3.4</span> SDPFlatSylvesterEval</a>
  - <a href="#sdpsylvester" id="toc-PackageSDPSylvester"><span class="toc-section-number">15.4</span> SDPSylvester</a>
    - <a href="#sdpeval-1" id="toc-SDPSylvesterSDPEval"><span class="toc-section-number">15.4.1</span> SDPEval</a>
    - <a href="#sdpsylvesterprimaleval" id="toc-SDPSylvesterPrimalEval"><span class="toc-section-number">15.4.2</span> SDPSylvesterPrimalEval</a>
    - <a href="#sdpsylvesterdualeval" id="toc-SDPSylvesterDualEval"><span class="toc-section-number">15.4.3</span> SDPSylvesterDualEval</a>
    - <a href="#sdpsylvestersylvestereval" id="toc-SDPSylvesterSylvesterEval"><span class="toc-section-number">15.4.4</span> SDPSylvesterSylvesterEval</a>
  - <a href="#primaldual" id="toc-PackagePrimalDual"><span class="toc-section-number">15.5</span> PrimalDual</a>
    - <a href="#primaldual-1" id="toc-PrimalDual"><span class="toc-section-number">15.5.1</span> PrimalDual</a>
  - <a href="#ncpolysos" id="toc-PackageNCPolySOS"><span class="toc-section-number">15.6</span> NCPolySOS</a>
    - <a href="#ncpolysos-1" id="toc-NCPolySOS"><span class="toc-section-number">15.6.1</span> NCPolySOS</a>
    - <a href="#ncpolysostosdp" id="toc-NCPolySOSToSDP"><span class="toc-section-number">15.6.2</span> NCPolySOSToSDP</a>
- <a href="#work-in-progress" id="toc-WorkInProgress"><span class="toc-section-number">16</span> Work in Progress</a>
  - <a href="#ncrational" id="toc-PackageNCRational"><span class="toc-section-number">16.1</span> NCRational</a>
    - <a href="#state-space-realizations-for-nc-rationals" id="toc-state-space-realizations-for-nc-rationals"><span class="toc-section-number">16.1.1</span> State-space realizations for NC rationals</a>
    - <a href="#utilities-1" id="toc-utilities-1"><span class="toc-section-number">16.1.2</span> Utilities</a>
    - <a href="#operations-on-nc-rationals" id="toc-operations-on-nc-rationals"><span class="toc-section-number">16.1.3</span> Operations on NC rationals</a>
    - <a href="#minimal-realizations" id="toc-minimal-realizations"><span class="toc-section-number">16.1.4</span> Minimal realizations</a>
  - <a href="#ncrealization" id="toc-PackageNCRealization"><span class="toc-section-number">16.2</span> NCRealization</a>
    - <a href="#ncdescriptorrealization" id="toc-NCDescriptorRealization"><span class="toc-section-number">16.2.1</span> NCDescriptorRealization</a>
    - <a href="#ncdeterminantalrepresentationreciprocal" id="toc-NCDeterminantalRepresentationReciprocal"><span class="toc-section-number">16.2.2</span> NCDeterminantalRepresentationReciprocal</a>
    - <a href="#ncmatrixdescriptorrealization" id="toc-NCMatrixDescriptorRealization"><span class="toc-section-number">16.2.3</span> NCMatrixDescriptorRealization</a>
    - <a href="#ncminimaldescriptorrealization" id="toc-NCMinimalDescriptorRealization"><span class="toc-section-number">16.2.4</span> NCMinimalDescriptorRealization</a>
    - <a href="#ncsymmetricdescriptorrealization" id="toc-NCSymmetricDescriptorRealization"><span class="toc-section-number">16.2.5</span> NCSymmetricDescriptorRealization</a>
    - <a href="#ncsymmetricdeterminantalrepresentationdirect" id="toc-NCSymmetricDeterminantalRepresentationDirect"><span class="toc-section-number">16.2.6</span> NCSymmetricDeterminantalRepresentationDirect</a>
    - <a href="#ncsymmetricdeterminantalrepresentationreciprocal" id="toc-NCSymmetricDeterminantalRepresentationReciprocal"><span class="toc-section-number">16.2.7</span> NCSymmetricDeterminantalRepresentationReciprocal</a>
    - <a href="#ncsymmetrizeminimaldescriptorrealization" id="toc-NCSymmetrizeMinimalDescriptorRealization"><span class="toc-section-number">16.2.8</span> NCSymmetrizeMinimalDescriptorRealization</a>
    - <a href="#noncommutativelift" id="toc-NonCommutativeLift"><span class="toc-section-number">16.2.9</span> NonCommutativeLift</a>
    - <a href="#signatureofaffineterm" id="toc-SignatureOfAffineTerm"><span class="toc-section-number">16.2.10</span> SignatureOfAffineTerm</a>
    - <a href="#testdescriptorrealization" id="toc-TestDescriptorRealization"><span class="toc-section-number">16.2.11</span> TestDescriptorRealization</a>
    - <a href="#pinnedq" id="toc-PinnedQ"><span class="toc-section-number">16.2.12</span> PinnedQ</a>
    - <a href="#pinningspace" id="toc-PinningSpace"><span class="toc-section-number">16.2.13</span> PinningSpace</a>
- <a href="#references" id="toc-references">References</a>

# License

**NCAlgebra** is distributed under the terms of the BSD License:

    Copyright (c) 2023, J. William Helton and Mauricio C. de Oliveira
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name NCAlgebra nor the names of its contributors may be
          used to endorse or promote products derived from this software without
          specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Acknowledgements

This work was partially supported by the Division of Mathematical
Sciences of the National Science Foundation.

The program was written by the authors with major earlier contributions from:

- Mark Stankus, Math, Cal Poly San Luis Obispo
- Robert L. Miller, General Atomics Corp

Considerable recent help came from

- Igor Klep, University of Ljubljana
- Aidan Epperly

Other contributors include:

- David Hurst, Daniel Lamm, Orlando Merino, Robert Obar, Henry Pfister,
  Mike Walker, John Wavrik, Lois Yu, J. Camino, J. Griffin, J. Ovall,
  T. Shaheen, John Shopple.

The beginnings of the program come from eran@slac.

# Changes in Version 6.0

## Version 6.0.3

1.  Fixed `NCGrad` for `tr` functions.

## Version 6.0.2

1.  Fixed bug in `NCPolyMonomial` in lex order.

## Version 6.0.1

1.  Fixed SparseArray Mathematica bug affecting `NCFromDigits`.
2.  `NCGB` has been completely deprecated. Loading `NCGB` loads
    `NCAlgebra` and `NCGBX` instead.
3.  Fixed NCRationalToNCPoly bug with expression exponents.

## Version 6.0.0

1.  NCAlgebra is now distributed as a *paclet*!

2.  Changed cannonical representation of noncommutative expressions to
    allow for powers to be present in `NonCommutativeMultiply`.

    > **WARNING:** THIS IS A BREAKING CHANGE THAT CAN AFFECT EXISTING
    > PROGRAMS USING NCALGEBRA. THE MOST NOTABLE LIKELY CONSTRUCTION
    > THAT IS AFFECTED BY THIS CHANGE IS THE APPLICATION OF RULES BASED
    > ON PATTERN MATCHING, WHICH NOW NEED TO EXPLICITLY TAKE INTO
    > ACCOUNT THE PRESENCE OF EXPONENTS. SEE
    > [NOTES ON MANUAL](#replace) FOR DETAILS ON HOW TO MITIGATE
    > THE IMPACT OF THIS CHANGE. ALL NCALGEBRA COMMANDS HAVE BEEN
    > REWRITTEN TO ACCOMODATE FOR THIS CHANGE IN REPRESENTATION.

3.  `NCTEST` renamed `NCCORETEST`

4.  Tests must now be run as contexts: e.g. `` << NCCORETEST` `` instead
    of `<< NCCORETEST`

5.  `NonCommutativeMultiply`: new functions
    [NCExpandExponents](#ncexpandexponents) and [NCToList](#nctolist).

6.  `NCReplace`: new functions
    [NCReplacePowerRule](#ncreplacepowerrule),
    [NCExpandReplaceRepeated](#ncexpandreplacerepeated);
    [NCExpandReplaceRepeatedSymmetric](#ncexpandreplacerepeatedsymmetric);
    [NCExpandReplaceRepeatedSelfAdjoint](#ncexpandreplacerepeatedselfadjoint);
    new option `ApplyPowerRule`.

7.  `NCGBX`: [NCMakeGB](#ncmakegb) option `ReduceBasis` now defaults to
    `True`.

8.  `NCCollect`: new function [NCCollectExponents](#nccollectexponents).

9.  `MatrixDecompositions`: functions [GetLDUMatrices](#getldumatrices)
    and [GetFullLDUMatrices](#getfullldumatrices) now produces low rank
    matrices.

10. `NCPoly`: new function
    [NCPolyFromGramMatrixFactors](#ncpolyfromgrammatrixfactors).
    `NCPolyFullReduce`
    renamed [NCPolyReduceRepeated](#ncpolyreducerepeated).

11. `NCPolyInterface`: new functions [NCToRule](#nctorule),
    [NCReduce](#ncreduce), [NCReduceRepeated](#ncreducerepeated),
    [NCRationalToNCPoly](#ncrationaltoncpoly),
    [NCMonomialOrder](#ncmonomialorder), and
    [NCMonomialOrderQ](#ncmonomialorderq).

12. New utility functions
    [SetCommutativeFunction](#setcommutativefunction),
    [SetNonCommutativeFunction](#setnoncommutativefunction)
    [NCSymbolOrSubscriptExtendedQ](#ncsymbolorsubscriptextendedq), and
    [NCNonCommutativeSymbolOrSubscriptExtendedQ](#ncnoncommutativesymbolorsubscriptextendedq).

13. The old `C++` version of `NCGB` is no longer compatible with
    `NCAlgebra` *version 6*. Consider using [`NCGBX`](#ncgbx)
    instead.

14. No longer loads the package `Notation` by default. Controlled by
    the new option `UseNotation` in [`NCOptions`](#ncoptions).

15. Streamlined rules for [NCSimplifyRational](#ncsimplifyrational-1).

# Changes in Version 5.0

## Version 5.0.6

1.  `NC` and `NCAlgebra` are now Contexts
2.  NCMatrixExpand moved from NCDot to NCReplace
3.  Added [SetCommutativeFunction](#setcommutativefunction)
4.  Added [tr](#tr) operator
5.  Tests fixed to work even if a-z are not defined as NC globally
6.  More tests for CommutativeQ
7.  Compatibility with Mathematica 13.0.0

## Version 5.0.5

1.  Improved documentation
2.  Bug fixes. Thanks Igor Klep!

## Version 5.0.4

1.  First implementation of [NCPolyGramMatrix](#ncpolygrammatrix) and [NCPolyFromGramMatrix](#ncpolyfromgrammatrix).
2.  Improvements in NCReplace.
3.  Several bug fixes and improvements. Thanks Eric Evert!

## Version 5.0.3

1.  Restored functionality of [SetCommutingOperators](#setcommutingoperators).
2.  Improved implementation of [CommutativeQ](#commutativeq) for arrays.

## Version 5.0.2

1.  `NCCollect` and `NCStrongCollect` can handle commutative variables.
2.  Cleaned up initialization files.
3.  New function `SetNonCommutativeHold` with `HoldAll` attribute can be used to set Symbols that have been previously assigned values.

## Version 5.0.1

1.  Introducing `NCWebInstall` and `NCWebUpdate`.
2.  Bug fixes.

## Version 5.0.0

1.  Completely rewritten core handling of noncommutative expressions
    with significant speed gains.
2.  Completely rewritten noncommutative Gröbner basis algorithm without
    any dependence on compiled code. See chapter
    [Noncommutative Gröbner Basis](#noncommutative-gröbner-basis) in the user guide and the
    [NCGBX](#ncgbx) package. Some `NCGB` features are not fully
    supported yet, most notably [NCProcess](#ncprocess).
3.  New algorithms for representing and operating with noncommutative
    polynomials with commutative coefficients. These support the new
    package [NCGBX](#ncgbx). See this section in the chapter
    [More Advanced Commands](#polynomials-with-commutative-coefficients) and the
    packages [NCPolyInterface](#ncpolyinterface) and
    [NCPoly](#ncpoly).
4.  New algorithms for representing and operating with noncommutative
    polynomials with noncommutative coefficients
    ([NCPolynomial](#ncpolynomial)) with specialized facilities
    for noncommutative quadratic polynomials
    ([NCQuadratic](#ncquadratic)) and noncommutative linear
    polynomials ([NCSylvester](#ncsylvester)).
5.  Modified behavior of `CommuteEverything` (see important notes in
    [CommuteEverything](#commuteeverything)).
6.  Improvements and consolidation of noncommutative calculus in the
    package [NCDiff](#ncdiff).
7.  Added a complete set of linear algebra algorithms in the new
    package [MatrixDecompositions](#matrixdecompositions-linear-algebra-templates) and
    their noncommutative versions in the new package
    [NCMatrixDecompositions](#ncmatrixdecompositions).
8.  General improvements on the Semidefinite Programming package
    [NCSDP](#ncsdp).
9.  New algorithms for simplification of noncommutative rationals
    ([NCSimplifyRational](#ncsylvester)).
10. Commands `Transform`, `Substitute`, `SubstituteSymmetric`, etc,
    have been replaced by the much more reliable commands in the new
    package [NCReplace](#ncreplace).
11. Command `MatMult` has been replaced by [NCDot](#ncdot-1). Alias `MM`
    has been deprecated.
12. Noncommutative power is now supported, with `x^3` expanding to
    `x**x**x`, `x^-1` expanding to `inv[x]`.
13. `x^T` expands to `tp[x]` and `x^*` expands to `aj[x]`. Symbol `T`
    is now protected.
14. Support for subscripted variables in notebooks.

# Introduction

This *User Guide* attempts to document the many improvements
introduced in `NCAlgebra` **Version 6**. Please be patient, as we move
to incorporate the many recent changes into this document.

See [Reference Manual](#reference-manual) for a detailed
description of the available commands.

There are also notebooks in the `NC/DEMOS` directory that accompany
each of the chapters of this user guide.

## Installing NCAlgebra

Starting with **Version 6**, it is recommended that NCAlgebra be
installed using our paclet distribution. Just type:

    PacletInstall["https://github.com/NCAlgebra/NC/blob/master/NCAlgebra-6.0.3.paclet?raw=true"];

for the latest version.

In the near future we plan to submit paclets to the Wolfram paclet
repository for easier updates.

Alternatively, you can download and install NCAlgebra as outlined in
the section [Manual Installation](#manual-installation).

## Running NCAlgebra

In *Mathematica* (notebook or text interface), type

    << NCAlgebra`

to load `NCAlgebra`.

Advanced options for controlling the loading of `NC` and `NCAlgebra` can be found in [here](#NCOptions) and [here](#ncalgebra).

> If you performed a manual installation of NCAlgebra you will need to type
>
>     << NC`
>
> before loading NCAlgebra.
>
> If this step fails, your installation has problems (check out
> installation instructions in
> [Manual Installation](#manual-installation)). If your installation is
> succesful, you will see a message like:
>
>     NC::Directory: You are using the version of NCAlgebra which is
>     found in: "/your_home_directory/NC".
>
> In the paclet version, it is no longer necessary to load the context
> `NC` before running NCAlgebra.
>
> Loading the context `NC` in the paclet version is however still
> supported for backward compatibility. It does nothing more than
> posting the message:
>
>     NC::Directory: You are using a paclet version of NCAlgebra.

## Now what?

Extensive documentation is found at

<https://NCAlgebra.github.io>

and in the distribution directory

<https://github.com/NCAlgebra/NC/DOCUMENTATION>

which includes this document.

You may want to try some of the several demo files in the directory
`DEMOS` after installing `NCAlgebra`.

You can also run some tests to see if things are working fine.

## Testing

There are 3 test sets which you can use to troubleshoot parts of
NCAlgebra. The most comprehensive test set is run by typing:

    << NCCORETEST`

This will test the core functionality of NCAlgebra.

You can test functionality related to the package
[`NCPoly`](#ncpoly), including the new `NCGBX` package
[`NCGBX`](#ncgbx), by typing:

    << NCPOLYTEST`

Finally our Semidefinite Programming Solver [`NCSDP`](#ncsdp)
can be tested with

    << NCSDPTEST`

We recommend that you restart the kernel before and after running
tests. Each test takes a few minutes to run.

You can also call

    << NCPOLYTESTGB`

to perform extensive and long testing of `NCGBX`.

> If you performed a manual installation of NCAlgebra you will need to type
>
>     << NC`
>
> before before running any of the tests above.

## Pre-2017 NCGB C++ version

Starting with **Version 6**, the old `C++` version of our Groebner Basis
Algorithm is no longer included. Consider using [`NCGBX`](#ncgbx).

# Most Basic Commands

This chapter provides a gentle introduction to some of the commands
available in `NCAlgebra`.

If you want a living analog of this chapter just run the notebook
`NC/DEMOS/1_MostBasicCommands.nb`.

Before you can use `NCAlgebra` you first load it with the following
commands:

    << NC`
    << NCAlgebra`

> If you installed the paclet version of NCAlgebra it is not necessary
> to load the context `NC` before loading other `NCAlgebra`
> packages. A dummy package `NC` is provided in case you would like to
> keep your NCAlgebra work compatible with previous versions.

## To Commute Or Not To Commute?

In `NCAlgebra`, the operator `**` denotes *noncommutative
multiplication*. At present, single-letter lower case variables are
noncommutative by default and all others are commutative by
default. For example:

    a**b-b**a

results in

``` output
a**b-b**a
```

while

    A**B-B**A
    A**b-b**A

both result in `0`.

One of Bill’s favorite commands is `CommuteEverything`, which
temporarily makes all noncommutative symbols appearing in a given
expression to behave as if they were commutative and returns the
resulting commutative expression. For example:

    CommuteEverything[a**b-b**a]

results in `0`. The command

    EndCommuteEverything[]

restores the original noncommutative behavior.

One can make any symbol behave as noncommutative
using `SetNonCommutative`. For example:

    SetNonCommutative[A,B]
    A**B-B**A

results in:

``` output
A**B-B**A
```

Likewise, symbols can be made commutative using `SetCommutative`. For example:

    SetNonCommutative[A] 
    SetCommutative[B]
    A**B-B**A

results in `0`. `SNC` is an alias for `SetNonCommutative`. So, `SNC`
can be typed rather than the longer `SetNonCommutative`:

    SNC[A];
    A**a-a**A

results in:

``` output
-a**A+A**a
```

One can check whether a given symbol is commutative or not using
`CommutativeQ` or `NonCommutativeQ`. For example:

    CommutativeQ[B]
    NonCommutativeQ[a]

both return `True`.

> **WARNING:** Prior to **Version 6**, noncommutative monomials would be
> stored in expanded form, without exponents. For example, the monomial
>
>     a**b**a^2**b
>
> would be stored as
>
> ``` output
> NonCommutativeMultiply[a, b, a, a, b]
> ```
>
> The automatic expansion of powers of noncommutative symbols required
> overloading the behavior of the built in `Power` operator, which was
> interfering and causing much trouble when commutative polynomial
> operations were performed inside an `NCAlgebra` session.
>
> Starting with **Version 6**, noncommutative monomials are represented
> with exponents. For instance, the same monomial above is now
> represented as
>
> ``` output
> NonCommutativeMultiply[a, b, Power[a, 2], b]
> ```
>
> Even if you type `a**b**a**a**b`, the repeated symbols get compressed
> to the compact representation with exponents. Exponents are now also
> used to represent the noncommutative inverse. See the notes in the
> next section.

## Inverses

The multiplicative identity is denoted `Id` in the program. At the
present time, `Id` is set to 1.

A symbol `a` may have an inverse, which will be denoted by
`inv[a]`. `inv` operates as expected in most cases.

For example:

    inv[a]**a
    inv[a**b]**a**b

both lead to `Id = 1` and

    a**b**inv[b]

results in `a`.

> **WARNING:** Starting with **Version 6**, the `inv` operator acts
> mostly as a wrapper for `Power`. For example, `inv[a]` internally
> evaluates to `Power[a, -1]`. However, `inv` is still available and
> used to display the noncommutative inverse of noncommutative
> expressions outside of a notebook environment. Beware that
> `inv[a**a]` now evaluates to `Power[a, -2]`, hence certain patterns
> may no longer work. For example:
>
>     NCReplace[inv[a**a], a**a -> b]
>
> would produce `inv[b]` in previous versions of `NCAlgebra` but will
> fail in **Version 6**.

> **WARNING:** Since **Version 5**, `inv` no longer automatically
> distributes over noncommutative products. If this more aggressive
> behavior is desired use `SetOptions[inv, Distribute -> True]`. For
> example
>
>     SetOptions[inv, Distribute -> True]
>     inv[a**b]
>
> returns `inv[b]**inv[a]`. Conversely
>
>     SetOptions[inv, Distribute -> False]
>     inv[a**b]
>
> returns `inv[a**b]`.

## Transposes and Adjoints

`tp[x]` denotes the transpose of symbol `x` and `aj[x]` denotes the
adjoint of symbol `x`. Like `inv`, the properties of transposes and
adjoints that everyone uses constantly are built-in. For example:

    tp[a**b]

leads to

``` output
tp[b]**tp[a]
```

and

    tp[a+b]

returns

``` output
tp[a]+tp[b]
```

Likewise, `tp[tp[a]] == a` and `tp` for anything for which
`CommutativeQ` returns `True` is simply the identity. For example
`tp[5] == 5`, `tp[2 + 3I] == 2 + 3 I`, and `tp[B] == B`.

Similar properties hold to `aj`. Moreover

    aj[tp[a]]
    tp[aj[a]]

return `co[a]` where `co` stands for complex-conjugate.

> **WARNING:** Since **Version 5** transposes (`tp`), adjoints (`aj`),
> complex conjugates (`co`), and inverses (`inv`) in a notebook
> environment render as ![x^T](https://render.githubusercontent.com/render/math?math=x%5ET&mode=inline), ![x^\*](https://render.githubusercontent.com/render/math?math=x%5E%2A&mode=inline), ![\bar{x}](https://render.githubusercontent.com/render/math?math=%5Cbar%7Bx%7D&mode=inline), and ![x^{-1}](https://render.githubusercontent.com/render/math?math=x%5E%7B-1%7D&mode=inline). `tp`
> and `aj` can also be input directly as `x^T` and `x^*`. For this
> reason the symbol `T` is now protected in `NCAlgebra`.

A trace like operator, `tr`, was introduced in **v5.0.6**. It is a
commutative operator keeps its list of arguments cyclicly sorted so
that `tr[b**a]` evaluates to `tr[a**b]` and that automatically
distribute over sums so that an expression like

    tr[a**b - b**a]

always simplifies to zero. Also `b**a**tr[b**a]` simplifies to

``` output
tr[a**b] a**b
```

because `tr` is a commutative function. See
[SetCommutativeFunction](#setcommutativefunction).

A more interesting example is

    expr = (a**b - b**a)^3

for which

    NCExpand[tr[expr]]

evaluates to

``` output
3 tr[a^2**b^2**a**b] - 3 tr[a^2**b**a**b^2]
```

Use [NCMatrixExpand](#ncmatrixexpand) to expand `tr` over matrices
with noncommutative entries. For example,

    NCMatrixExpand[tr[{{a,b},{c,d}}]]

evaluates to

``` output
tr[a] + tr[d]
```

## Replace

A key feature of symbolic computation is the ability to perform
substitutions. The Mathematica substitute commands, e.g. `ReplaceAll`
(`/.`) and `ReplaceRepeated` (`//.`), are not reliable in `NCAlgebra`,
so you must use our `NC` versions of these commands. For example:

    NCReplaceAll[x**a**b,a**b->c]

results in

``` output
x**c
```

and

    NCReplaceAll[tp[b**a]+b**a,b**a->c]

results in

``` output
c+tp[a]**tp[b]
```

Use [NCMakeRuleSymmetric](#ncmakerulesymmetric) and
[NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint) to automatically
create symmetric and self adjoint versions of your rules:

    NCReplaceAll[tp[b**a]+b**a, NCMakeRuleSymmetric[b**a -> c]]

returns

``` output
c + tp[c]
```

> **WARNING:** The change in internal representation introduced in
> **Version 6**, in which repeated letters in monomials are represented
> as powers, presents a new challenge to pattern matching for
> `NCAlgebra` expressions. For example, the seemingly innocent
> substitution
>
>     NCReplaceAll[a**b**b, a**b -> c, ApplyPowerRule -> False]
>
> which in previous versions returned `c**b` will fail in
> **Version 6**. The reason for the failure is that `a**b**b` is now
> internally represented as `a**Power[b, 2]`, which does not match
> `a**b`. In order to make rules with exponents work in **Version 6**,
> they to be first modified by the new command
> [NCReplacePowerRule](#ncreplacepowerrule) as in
>
>     NCReplaceAll[a**b**b, NCReplacePowerRule[a**b -> c], ApplyPowerRule -> False]
>
> For convenience, when the option `ApplyPowerRule` is set to `True`,
> `NCReplacePowerRule` gets automatically applied by all `NCReplace`
> family of functions. In this way,
>
>     NCReplaceAll[a**b**b, a**b -> c]
>     NCReplaceAll[a**b**b, a**b -> c, ApplyPowerRule -> True]
>     NCReplaceAll[a**b**b, NCReplacePowerRule[a**b -> c], ApplyPowerRule -> False]
>
> all return the more familiar result
>
> ``` output
> c**b
> ```
>
> in **Version 6**.

> **WARNING:** [NCReplacePowerRule](#ncreplacepowerrule) and the
> option `ApplyPowerRule` may not work with the most exoteric
> replacements. See, for example, the note in section
> [Inverses](#inverses).

The difference between `NCReplaceAll` and `NCReplaceRepeated` can be
understood in the example:

    NCReplaceAll[a**b^2, a**b -> a]

that results in

``` output
a**b
```

and

    NCReplaceRepeated[a**b^2, a**b -> a]

that results in

``` output
a
```

Beside `NCReplaceAll` and `NCReplaceRepeated` we offer `NCReplace` and
`NCReplaceList`, which are analogous to the standard `ReplaceAll`
(`/.`), `ReplaceRepeated` (`//.`), `Replace` and `ReplaceList`. Note
that one rarely uses `NCReplace` and `NCReplaceList`.

With **Version 6** we introduced
[`NCExpandReplaceRepeated`](#ncexpandreplacerepeated),
[`NCExpandReplaceRepeatedSymmetric`](#ncexpandreplacerepeatedsymmetric),
and
[`NCExpandReplaceRepeatedSelfAdjoint`](#ncexpandreplacerepeatedselfadjoint),
which automate the tedious process of successive substitutions and
expansions that may be required to fully simplify expressions. For
example, consider the expression

    expr = a**b^2-b^2**a

and the rule

    rule = a**b -> a - b

for which

    NCReplaceRepeated[expr, rule]

results in the expression

``` output
(a - b)**b - b^2**a
```

Note the presence of *parenthesized* terms resulting from the rule
substitution. It is clear that after expanding

    NCExpand[NCReplaceRepeated[expr, rule]]

to produce

``` output
a**b - b^2 - b^2**a
```

there are still terms that could be affected by the original
replacement rule, that, if replaced again,

    NCExpand[NCReplaceRepeated[expr, rule]]
    NCExpand[NCReplaceRepeated[%, rule]]

would ultimately lead to a simpler expression

``` output
a - b - b^2 - b^2**a
```

This successive expansion and substitution process is automated in

    NCExpandReplaceRepeated[expr, rule]

which produces the final expression

``` output
a - b - b^2 - b^2**a
```

in one shot.

See also the Sections [Polynomials and Rules](#polynomials-and-rules)
and [Advanced Rules and Replacement](#advanced-rules-and-replacements) for a deeper
discussion on some issues involved with rules and replacements in
`NCAlgebra`.

> **WARNING:** The commands `Substitute` and `Transform` have been
> deprecated in **Version 5** in favor of the above nc versions of
> `Replace`.

## Polynomials

The command `NCExpand` expands noncommutative products. For example:

    NCExpand[(a+b)**x]

returns

``` output
a**x+b**x
```

Conversely, one can collect noncommutative terms involving same powers
of a symbol using `NCCollect`. For example:

    NCCollect[a**x+b**x,x]

recovers

``` output
(a+b)**x
```

`NCCollect` groups terms by degree before collecting and accepts more
than one variable. For example:

    expr = a**x+b**x+y**c+y**d+a**x**y+b**x**y
    NCCollect[expr, {x}]

returns

``` output
y**c+y**d+(a+b)**x**(1+y)
```

and

    NCCollect[expr, {x, y}]

returns

``` output
(a+b)**x+y**(c+d)+(a+b)**x**y
```

Note that the last term has degree 2 in `x` and `y` and therefore does
not get collected with the first order terms.

The list of variables accepts `tp`, `aj` and
`inv`, and

    NCCollect[tp[x]**a**x+tp[x]**b**x+z,{x,tp[x]}]

returns

``` output
z+tp[x]**(a+b)**x
```

Alternatively one could use

    NCCollectSymmetric[tp[x]**a**x+tp[x]**b**x+z,{x}]

to obtain the same result. A similar command,
[NCCollectSelfAdjoint](#nccollectselfadjoint), works with self-adjoint
variables.

There is also a stronger version of collect called `NCStrongCollect`.
`NCStrongCollect` does not group terms by degree. For instance:

    NCStrongCollect[expr, {x, y}]

produces

``` output
y**(c+d)+(a+b)**x**(1+y)
```

Keep in mind that `NCStrongCollect` often collects *more* than one
would normally expect.

> **WARNING:** In **Version 6** the commands
> [NCExpandExponents](#ncexpandexponents) and
> [NCCollectExponents](#nccollectexponents) expands and collects
> exponents of expressions in noncommutative monomials. For example
>
>     NCExpandExponents[a**(b**a)^2**b]
>
> produces
>
> ``` output
> a**b**a**b**a**b
> ```
>
> and
>
>     NCCollectExponents[a**b**a**b**a**b]
>
> produces
>
> ``` output
> (a**b)^3
> ```

`NCAlgebra` provides some commands for noncommutative polynomial
manipulation that are similar to the native Mathematica (commutative)
polynomial commands. Some of the next commands required the loading of
the package

    << NCPolyInterface`

which provides an interface between `NCAlgebra` and the low-level
package [NCPoly](#ncpoly).

For example:

    SetCommutative[A, B]
    expr = B + A y**x**y - 2 x
    vars = NCVariables[expr]

returns

``` output
{x,y}
```

and

    NCCoefficientList[expr, vars]
    NCMonomialList[expr, vars]
    NCCoefficientRules[expr, vars]

returns

``` output
{B, -2, A}
{1, x, y**x**y}
{1 -> B, x -> -2, y**x**y -> A}
```

Also for testing

    NCMonomialQ[expr]

will return `False` and

    NCPolynomialQ[expr]

will return `True`.

Another useful command is `NCTermsOfDegree`, which will returns an
expression with terms of a certain degree. For instance:

    NCTermsOfDegree[x**y**x - x^2**y + x**w + z**w, {x,y}, {2,1}]

returns `x**y**x - x^2**y`,

    NCTermsOfDegree[x**y**x - x^2**y + x**w + z**w, {x,y}, {0,0}]

returns `z**w`, and

    NCTermsOfDegree[x**y**x - x^2**y + x**w + z**w, {x,y}, {0,1}]

returns `0`.

A similar command is `NCTermsOfTotalDegree`, which works just like
`NCTermsOfDegree` but considers the total degree in all variables. For
example:

For example,

    NCTermsOfTotalDegree[x**y**x - x^2**y + x**w + z**w, {x,y}, 3]

returns `x**y**x - x^2**y`, and

    NCTermsOfTotalDegree[x**y**x - x^2**y + x**w + z**w, {x,y}, 2]

returns `0`.

The above commands are based on special packages for efficiently
storing and calculating with nc polynomials. Those packages are

- [`NCPolynomial`](#ncpolynomial): which handles polynomials with
  noncommutative coefficients, and
- [`NCPoly`](#ncpoly): which handles polynomials with real coefficients.

For example:

    1 + y**x**y - A x

is a polynomial with commutative coefficients in ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), whereas

    a**y**b**x**c**y - A x**d

is a polynomial with nc coefficients in ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), where the letters
![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline), and ![d](https://render.githubusercontent.com/render/math?math=d&mode=inline), are the *nc coefficients*. Of course

    1 + y**x**y - A x

is a polynomial with nc coefficients if one considers only ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) as the
variable of interest.

In order to take full advantage of [`NCPoly`](#ncpoly) and
[`NCPolynomial`](#ncpolynomial) one would need to *convert* an
expression into those special formats. See the sections on
[polynomials with commutative
coefficients](#polynomials-with-commutative-coefficients) and [polynomials with
noncommutative coefficients](#polynomials-with-noncommutative-coefficients) in
the [mode advanced commands](#more-advanced-commands) chapter and the
chapter on [Gröebner basis](#noncommutative-gröbner-basis) for more information. Details can
be found in the package documentaions
[NCPolyInterface](#ncpolyinterface), [NCPoly](#ncpoly),
and [NCPolynomial](#ncpolynomial).

## Rationals and Simplification

One of the great challenges of noncommutative symbolic algebra is the
simplification of rational nc expressions. `NCAlgebra` provides
various algorithms that can be used for simplification and general
manipulation of nc rationals.

One such function is `NCSimplifyRational`, which attempts to simplify
noncommutative rationals using a predefined set of rules. For example:

    expr = 1+inv[d]**c**inv[S-a]**b-inv[d]**c**inv[S-a+b**inv[d]**c]**b \
           -inv[d]**c**inv[S-a+b**inv[d]**c]**b**inv[d]**c**inv[S-a]**b
    NCSimplifyRational[expr]

leads to `1`. Of course the great challenge here is to reveal well
known identities that can lead to simplification. For example, the two
expressions:

    expr1 = a**inv[1+b**a]
    expr2 = inv[1+a**b]**a

and one can use `NCSimplifyRational` to test such equivalence by
evaluating

    NCSimplifyRational[expr1 - expr2]

which results in `0` or

    NCSimplifyRational[expr1**inv[expr2]]

which results in `1`. `NCSimplifyRational` works by transforming nc
rationals. For example, one can verify that

    NCSimplifyRational[expr2] == expr1

`NCAlgebra` has a number of packages that can be used to manipulate
rational nc expressions. The packages:

- [`NCGBX`](#ncgbx) perform calculations with nc rationals
  using Gröbner basis, and
- [`NCRational`](#ncrational) creates state-space
  representations of nc rationals. This package is still experimental.

## Calculus

The package [`NCDiff`](#ncdiff) provide functions for
calculating derivatives and integrals of nc polynomials and nc
rationals.

    << NCDiff`

The main command is [`NCDirectionalD`](#ncdirectionald) which
calculates directional derivatives in one or many variables. For
example, if:

    expr = a**inv[1+x]**b + x**c**x

then

    NCDirectionalD[expr, {x,h}]

returns

``` output
h**c**x + x**c**h - a**inv[1+x]**h**inv[1+x]**b
```

In the case of more than one variables
`NCDirectionalD[expr, {x,h}, {y,k}]` takes the directional derivative
of `expr` with respect to `x` in the direction `h` and with respect to
`y` in the direction `k`. For example, if:

    expr = x**q**x - y**x

then

    NCDirectionalD[expr, {x,h}, {y,k}]

returns

``` output
h**q**x + x**q*h - y**h - k**x
```

A further example, if:

    expr = x**a**x**b + x**c**x**d

then its directional derivative in the direction `h` is

    NCDirectionalD[expr, {x,h}]

which returns

``` output
h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d
```

The command `NCGrad` calculates nc *gradients*[^3].

For example:

    NCGrad[expr, x]

returns the nc gradient

``` output
a**x**b + b**x**a + c**x**d + d**x**c
```

A further example, if:

    expr = x**a**x**b + x**c**y**d

is a function on variables `x` and `y` then

    NCGrad[expr, x, y]

returns the nc gradient list

``` output
{a**x**b + b**x**a + c**y**d, d**x**c}
```

**Version 5** introduced experimental support for integration of nc
polynomials. See [`NCIntegrate`](#ncintegrate).

## Matrices

`NCAlgebra` has many commands for manipulating matrices with
noncommutative entries. Think block-matrices. Matrices are
represented in Mathematica using *lists of lists*. For example

    m = {{a, b}, {c, d}}

is a representation for the matrix

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cleft%5B%5Cbegin%7Barray%7D%7Bcc%7D%20%0Aa%20%26%20b%20%5C%5C%20%0Ac%20%26%20d%20%0A%5Cend%7Barray%7D%5Cright%5D)

The Mathematica command `MatrixForm` output pretty
matrices. `MatrixForm[m]` prints `m` in a form similar to the above
matrix. Beware when copying and pasting parts of an expression rendered by`MatrixForm` because it may not execute correctly. If in doubt, use `FullForm` to reveal the contents of the expression.

The experienced matrix analyst should always remember that the
Mathematica convention for handling vectors is tricky.

- `{{1, 2, 4}}` is a 1x3 *matrix* or a *row vector*;
- `{{1}, {2}, {4}}` is a 3x1 *matrix* or a *column vector*;
- `{1, 2, 4}` is a *vector* but **not** a *matrix*. Indeed whether it
  is a row or column vector depends on the context. We advise not to
  use *vectors*.

### Inverses, Products, Adjoints, etc

A useful command is [`NCInverse`](#ncinverse), which is akin to
Mathematica’s `Inverse` command and produces a block-matrix inverse
formula[^4] for an nc matrix. For example

    NCInverse[m]

returns

``` output
{{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
{-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}
```

or, using `MatrixForm`,

    NCInverse[m] // MatrixForm

returns

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20%0Aa%5E%7B-1%7D%20%281%20%2B%20b%20%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20c%20a%5E%7B-1%7D%29%20%26%20-a%5E%7B-1%7D%20b%20%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20%5C%5C%0A-%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20c%20a%5E%7B-1%7D%20%26%20%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20%0A%5Cend%7Bbmatrix%7D)

Note that `a` and `d - c**inv[a]**b` were assumed invertible during the
calculation.

Similarly, one can multiply matrices using [`NCDot`](#ncdot-1),
which is similar to Mathematica’s `Dot`. For example

    m1 = {{a, b}, {c, d}}
    m2 = {{d, 2}, {e, 3}}
    NCDot[m1, m2]

result in

``` output
{{a**d + b**e, 2 a + 3 b}, {c**d + d**e, 2 c + 3 d}}
```

Note that products of nc symbols appearing in the
matrices are multiplied using `**`. Compare that with the standard
`Dot` (`.`) operator.

> **WARNING:** `NCDot` replaces `MatMult`, which is still available for
> backward compatibility but will be deprecated in future releases.

There are many new improvements with **Version 5**. For instance,
operators `tp`, `aj`, and `co` now operate directly over
matrices. That is

    aj[{{a,tp[b]},{co[c],aj[d]}}]

returns

``` output
{{aj[a],tp[c]},{co[b],d}}
```

In previous versions one had to use the special commands `tpMat`,
`ajMat`, and `coMat`. Those are still supported for backward
compatibility.

See [advanced matrix commands](#expanding-matrix-products) for other useful matrix manipulation routines, such as [`NCMatrixExpand`](#ncmatrixexpand), [`NCMatrixReplaceAll`](#ncmatrixreplaceall), [`NCMatrixReplaceRepeated`](#ncmatrixreplacerepeated), etc, that allow one to work with matrices with symbolic noncommutative entries.

### LU Decomposition

Behind `NCInverse` there are a host of linear algebra algorithms which
are available in the package:

- [`NCMatrixDecompositions`](#ncmatrixdecompositions):
  implements versions of the ![LU](https://render.githubusercontent.com/render/math?math=LU&mode=inline) Decomposition with partial and
  complete pivoting, as well as ![LDL](https://render.githubusercontent.com/render/math?math=LDL&mode=inline) Decomposition which are suitable
  for calculations with nc matrices. Those functions are based on the
  templated algorithms from the package
  [`MatrixDecompositions`](#matrixdecompositions-linear-algebra-templates).

For instance the function
[`NCLUDecompositionWithPartialPivoting`](#ncludecompositionwithpartialpivoting)
can be used as

    m = {{a, b}, {c, d}}
    {lu, p} = NCLUDecompositionWithPartialPivoting[m]

which returns

``` output
lu = {{a, b}, {c**inv[a], d - c**inv[a]**b}}
p = {1, 2}
```

Using `MatrixForm`:

    MatrixForm[lu]

results in

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20%0Aa%20%26%20b%20%5C%5C%20%0Ac%20a%5E%7B-1%7D%20%26%20d%20-%20c%20a%5E%7B-1%7D%20b%20%0A%5Cend%7Bbmatrix%7D)

The list `p` encodes the sequence of permutations calculated during
the execution of the algorithm. The matrix `lu` contains the factors
![L](https://render.githubusercontent.com/render/math?math=L&mode=inline) and ![U](https://render.githubusercontent.com/render/math?math=U&mode=inline) in the way most common to numerical analysts. These factors can be recovered using

    {ll, uu} = GetFullLUMatrices[lu]

resulting in this case in

``` output
ll = {{1, 0}, {c**inv[a], 1}}
uu = {{a, b}, {0, d - c**inv[a]**b}}
```

Using `MatrixForm`:

    MatrixForm[ll]
    MatrixForm[uu]

results in

![inline equation](https://render.githubusercontent.com/render/math?math=L%20%3D%20%5Cbegin%7Bbmatrix%7D%20%0A1%20%26%200%20%5C%5C%20%0Ac%20a%5E%7B-1%7D%20%26%201%20%0A%5Cend%7Bbmatrix%7D%2C%20%5Cqquad%0AU%20%3D%20%5Cbegin%7Bbmatrix%7D%20%0Aa%20%26%20b%20%5C%5C%20%0A0%20%26%20d%20-%20c%20a%5E%7B-1%7D%20b%20%0A%5Cend%7Bbmatrix%7D)

To verify that ![M = L U](https://render.githubusercontent.com/render/math?math=M%20%3D%20L%20U&mode=inline), input

    m - NCDot[ll, uu]

which should return a zero matrix.

**Note:** if you are looking for efficiency, the function [`GetLUMatrices`](#getlumatrices) (also [`GetLDUMatrices`](#getldumatrices)) returns the factors `l` and `u` as `SparseArrays`.

The default pivoting strategy prioritizes pivoting on simpler expressions. For
instance,

    m = {{a, b}, {1, d}}
    {lu, p} = NCLUDecompositionWithPartialPivoting[m]
    {ll, uu} = GetFullLUMatrices[lu]

result in the factors

``` output
ll = {{1, 0}, {a, 1}}
uu = {{1, d}, {0, b - a**d}}
```

and a permutation list

``` output
p = {2, 1}
```

which indicates that the number `1`, appearing in the second row, was
used as the pivot rather than the symbol `a` appearing on the first
row. Because of the permutation, to verify that ![P M = L U](https://render.githubusercontent.com/render/math?math=P%20M%20%3D%20L%20U&mode=inline), input

    m[[p]] - NCDot[ll, uu]

which should return a zero matrix. Note that in the above example the
permutation matrix ![P](https://render.githubusercontent.com/render/math?math=P&mode=inline) is never constructed. Instead, the rows of ![M](https://render.githubusercontent.com/render/math?math=M&mode=inline)
are directly permuted using Mathematica’s `Part` (`[[]]`) command. Of
course, if one prefers to work with permutation matrices, they can be
easily obtained by permuting the rows of the identity matrix as in the
following example

    p = {2, 1, 3}
    IdentityMatrix[3][[p]] // MatrixForm

to produce

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20%0A0%20%26%201%20%26%200%20%5C%5C%20%0A1%20%26%200%20%26%200%20%5C%5C%20%0A0%20%26%200%20%26%201%20%0A%5Cend%7Bbmatrix%7D)

Likewise

    m = {{a + b, b}, {c, d}}
    {lu, p} = NCLUDecompositionWithPartialPivoting[m]
    {ll, uu} = GetFullLUMatrices[lu]

returns

``` output
p = {2, 1}
ll = {{1, 0}, {(a + b)**inv[c], 1}} 
uu = {{c, d}, {0, b - (a + b)**inv[c]**d}}
```

showing that the *simpler* expression `c` was taken as a pivot instead
of `a + b`.

The function `NCLUDecompositionWithPartialPivoting` is the one that is
used by `NCInverse`.

### LU Decomposition with Complete Pivoting

Another factorization algorithm is
[`NCLUDecompositionWithCompletePivoting`](#ncludecompositionwithcompletepivoting),
which can be used to calculate the symbolic rank of nc matrices. For
example

    m = {{2 a, 2 b}, {a, b}}
    {lu, p, q, rank} = NCLUDecompositionWithCompletePivoting[m]

returns the *left* and *right* permutation lists

``` output
p = {2, 1}
q = {1, 2}
```

and `rank` equal to `1`. Note that `p = {2, 1}` and `q = {1,2}` tell us that the element that was pivoted on was the symbol `a`, which is the first entry of the second row, rather then `2 a`, which is the first entry of the first row, because `a` is *simpler* than `2 a` . The ![L](https://render.githubusercontent.com/render/math?math=L&mode=inline) and ![U](https://render.githubusercontent.com/render/math?math=U&mode=inline) factors can be obtained as
before using

    {ll, uu} = GetFullLUMatrices[lu]

to get

``` output
ll = {{1, 0}, {2, 1}}
uu = {{a, b}, {0, 0}}
```

Using `MatrixForm`:

    MatrixForm[ll]
    MatrixForm[uu]

results in

![inline equation](https://render.githubusercontent.com/render/math?math=L%20%3D%20%5Cbegin%7Bbmatrix%7D%20%0A1%20%26%200%20%5C%5C%20%0A2%20%26%201%20%0A%5Cend%7Bbmatrix%7D%2C%20%5Cqquad%0AU%20%3D%20%5Cbegin%7Bbmatrix%7D%20%0Aa%20%26%20b%20%5C%5C%20%0A0%20%26%200%20%0A%5Cend%7Bbmatrix%7D)

In this case, to verify that ![P M Q = L U](https://render.githubusercontent.com/render/math?math=P%20M%20Q%20%3D%20L%20U&mode=inline) input

    NCDot[ll, uu] - m[[p, q]]

which should return a zero matrix. As with partial pivoting, the
permutation matrices ![P](https://render.githubusercontent.com/render/math?math=P&mode=inline) and ![Q](https://render.githubusercontent.com/render/math?math=Q&mode=inline) are never constructed. Instead we
used `Part` (`[[]]`) to permute both rows and columns.

### LDL Decomposition

Finally [`NCLDLDecomposition`](#ncldldecomposition) computes the
![LDL^T](https://render.githubusercontent.com/render/math?math=LDL%5ET&mode=inline) decomposition of symmetric symbolic nc matrices. For example

    m = {{a, b}, {b, c}}
    {ldl, p, s, rank} = NCLDLDecomposition[m]

returns `ldl`, which contain the factors, and

``` output
p = {1, 2}
s = {1, 1}
rank = 2
```

The list `p` encodes left and right permutations, `s` is a list
specifying the size of the diagonal blocks (entries can be either 1 or
2). The factors can be obtained using
[`GetLDUMatrices`](#getldumatrices) as in

    {ll, dd, uu} = GetFullLDUMatrices[ldl, s]

which in this case returns

``` output
ll = {{1, 0}, {b**inv[a], 1}}
dd = {{a, 0}, {0, c - b**inv[a]**b}}
uu = {{1, inv[a]**b}, {0, 1}}}
```

Because ![P M P^T = L D L^T](https://render.githubusercontent.com/render/math?math=P%20M%20P%5ET%20%3D%20L%20D%20L%5ET&mode=inline),

    NCDot[ll, dd, uu] - m[[p, p]]

is the zero matrix and ![U = L^T](https://render.githubusercontent.com/render/math?math=U%20%3D%20L%5ET&mode=inline).

`NCLDLDecomposition` works only on symmetric matrices and, whenever
possible, will make invertibility and symmetry assumptions on
variables so that it can run successfully. If not possible it will
warn the users.

> **WARNING:** Prior versions contained the command `NCLDUDecomposition`
> which was deprecated in **Version 5** as its functionality is now
> provided by [`NCLDLDecomposition`](#ncldldecomposition), with a
> slightly different syntax.

### Replace with Matrices

[`NCMatrixReplaceAll`](#ncmatrixreplaceall) and
[`NCMatrixReplaceRepeated`](#ncmatrixreplacerepeated) are special
versions of [`NCReplaceAll`](#ncreplaceall) and
[`NCReplaceRepeated`](#ncreplacerepeated) that take extra steps to
preserve matrix consistency when replacing expressions with nc
matrices. For example, with

    m1 = {{a, b}, {c, d}}
    m2 = {{d, 2}, {e, 3}}

and

    M = {{a11,a12}}

the call

    MM = NCMatrixReplaceRepeated[M, {a11 -> m1, a12 -> m2}]

produces as a result the matrix

``` output
{{a, b, d, 2}, {c, d, e, 3}}
```

or, using `MatrixForm`:

    MatrixForm[MM]

to obtain

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20%0Aa%20%26%20b%20%26%20d%20%26%202%20%5C%5C%20%0Ac%20%26%20d%20%26%20e%20%26%203%20%0A%5Cend%7Bbmatrix%7D)

Note how the symbols were treated as block-matrices during the substitution. As a second example, with

    M = {{a11, 0}, {0, a22}}

the command

    MM = NCMatrixReplaceRepeated[M, {a11 -> m1, a22 -> m2}]

produces the matrix

``` output
{{a, b, 0, 0}, {c, d, 0, 0}, {0, 0, d, 2}, {0, 0, e, 3}}
```

or, using `MatrixForm`:

    MatrixForm[MM]

to obtain

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20%0Aa%20%26%20b%20%26%200%20%26%200%20%5C%5C%20%0Ac%20%26%20d%20%26%200%20%26%200%20%5C%5C%20%0A0%20%26%200%20%26%20d%20%26%202%20%5C%5C%20%0A0%20%26%200%20%26%20e%20%26%203%20%0A%5Cend%7Bbmatrix%7D)

in which the `0` blocks were automatically expanded to fit the adjacent block matrices.

Another feature of `NCMatrixReplace` and its variants is its ability
to withhold evaluation until all matrix substitutions have taken
place. For example,

    NCMatrixReplaceAll[x**y + y, {x -> m1, y -> m2}]

produces

``` output
{{d + a**d + b**e, 2 + 2 a + 3 b}, 
 {e + c**d + d**e, 3 + 2 c + 3 d}}
```

Finally, `NCMatrixReplace` substitutes `NCInverse` for `inv` so that, for instance, the result of

    rule = {x -> m1, y -> m2, id -> IdentityMatrix[2], z -> {{id,x},{x,id}}}
    NCMatrixReplaceRepeated[inv[z], rule]

coincides with

    NCInverse[ArrayFlatten[{{IdentityMatrix[2], m1}, {m1, IdentityMatrix[2]}}]]

## Quadratic Polynomials, Second Directional Derivatives and Convexity

The closest related demo to the material in this section is
`NC/DEMOS/NCConvexity.nb`.

When working with nc quadratics it is useful to be able to “factor” the
quadratic into the following form

![inline equation](https://render.githubusercontent.com/render/math?math=q%28x%29%20%3D%20c%20%2B%20s%28x%29%20%2B%20l%28x%29%20M%20r%28x%29)

where ![s](https://render.githubusercontent.com/render/math?math=s&mode=inline) is linear ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![l](https://render.githubusercontent.com/render/math?math=l&mode=inline) and ![r](https://render.githubusercontent.com/render/math?math=r&mode=inline) are vectors and ![M](https://render.githubusercontent.com/render/math?math=M&mode=inline) is a
matrix. Load the package

    << NCQuadratic`

and use the command
[`NCToNCQuadratic`](#nctoncquadratic) to factor an nc polynomial into the the above form:

    vars = {x, y};
    expr = tp[x]**a**x**d + tp[x]**b**y + tp[y]**c**y + tp[y]**tp[b]**x**d;
    {const, lin, left, middle, right} = NCToNCQuadratic[expr, vars];

which returns

``` output
left = {tp[x],tp[y]}
right = {y, x**d}
middle = {{a,b}, {tp[b],c}}
```

and zero `const` and `lin`. The format for the linear part `lin` will
be discussed later in Section [Linear](#linear-polynomials). Note that
coefficients of an nc quadratic may also appear on the left and right
vectors, as `d` did in the above example. Conversely,
[`NCQuadraticToNC`](#ncquadratictonc) converts a list with factors
back to an nc expression as in:

    NCQuadraticToNC[{const, lin, left, middle, right}]

which results in

``` output
(tp[x]**b + tp[y]**c)**y + (tp[x]**a + tp[y]**tp[b])**x**d
```

An interesting application is the verification of the domain in which
an nc rational function is *convex*. This uses the second directional
derivative, called the Hessian. Take for example the quartic

    expr = x^4;

and calculate its noncommutative directional *Hessian*

    hes = NCHessian[expr, {x, h}]

This command returns

``` output
2 h^2**x^2 + 2 h**x**h**x + 2 h**x^2**h + 2 x**h^2**x + 2 x**h**x**h + 2 x^2**h^2
```

which is quadratic in the direction `h`. The decomposition of the
nc Hessian using `NCToNCQuadratic`

    {const, lin, left, middle, right} = NCToNCQuadratic[hes, {h}];

produces

``` output
left = {h, x**h, x^2**h}
right = {h**x^2, h**x, h}
middle = {{2, 2 x, 2 x^2},{0, 2, 2 x},{0, 0, 2}}
```

Note that the middle matrix

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%0A2%20%26%202%20x%20%26%202%20x%5E2%20%5C%5C%0A0%20%26%202%20%26%202%20x%20%5C%5C%0A0%20%26%200%20%26%202%0A%5Cend%7Bbmatrix%7D)

is not *symmetric*, as one might have expected. The command
[`NCQuadraticMakeSymmetric`](#ncquadraticmakesymmetric) can fix that
and produce a symmetric decomposition. For the above example

    {const, lin, sleft, smiddle, sright} = 
      NCQuadraticMakeSymmetric[{const, lin, left, middle, right}, 
                               SymmetricVariables -> {x, h}]

results in

``` output
sleft = {x^2**h, x**h, h}
sright = {h**x^2, h**x, h}
middle = {{0, 0, 2}, {0, 2, 2 x}, {2, 2 x, 2 x^2}}
```

in which `middle` is the symmetric matrix

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%0A0%20%26%200%20%26%202%20%5C%5C%0A0%20%26%202%20%26%202%20x%20%5C%5C%0A2%20%26%202%20x%20%26%202%20x%5E2%0A%5Cend%7Bbmatrix%7D)

Note the argument `SymmetricVariables -> {x,h}` which tells
`NCQuadraticMakeSymmetric` to consider `x` and `y` as symmetric
variables. Because the `middle` matrix is never positive semidefinite
for any possible value of ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) the conclusion[^5] is that the nc quartic
![x^4](https://render.githubusercontent.com/render/math?math=x%5E4&mode=inline) is *not convex*.

The production of such symmetric quadratic decompositions is automated
by the convenience command
[`NCMatrixOfQuadratic`](#ncmatrixofquadratic). Verify that

    {sleft, smiddle, sright} = NCMatrixOfQuadratic[hes, {h}]

automatically assumes that both `x` and `h` are symmetric variables
and produces suitable left and right vectors as well as a symmetric
middle matrix. Now we illustrate the application of such command to
checking the convexity region of a noncommutative rational function.

If one is interested in checking convexity of nc rationals the package
[`NCConvexity`](#ncconvexity) has functions that automate the
whole process, including the calculation of the Hessian and the middle
matrix, followed by the diagonalization of the middle matrix as
produced by [`NCLDLDecomposition`](#ncldldecomposition).

For example, the commands evaluate the nc Hessian and calculates its
quadratic decomposition

    expr = (x + b**y)**inv[1 - a**x**a + b**y + y**b]**(x + y**b);
    {left, middle, right} = NCMatrixOfQuadratic[NCHessian[expr, {x, h}], {h}];

The resulting middle matrix can be factored using

    {ldl, p, s, rank} = NCLDLDecomposition[middle];
    {ll, dd, uu} = GetLDUMatrices[ldl, s];

which produces the diagonal factors

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%0A%20%202%20%281%20%2B%20b%20y%20%2B%20y%20b%20-%20a%20x%20a%29%5E%7B-1%7D%20%26%200%20%26%200%20%5C%5C%0A%20%200%20%26%200%20%26%200%20%5C%5C%0A%20%200%20%26%200%20%26%200%0A%5Cend%7Bbmatrix%7D)

which indicates the the original nc rational is convex whenever

![inline equation](https://render.githubusercontent.com/render/math?math=%281%20%2B%20b%20y%20%2B%20y%20b%20-%20a%20x%20a%29%5E%7B-1%7D%20%5Csucceq%200)

or, equivalently, whenever

![inline equation](https://render.githubusercontent.com/render/math?math=1%20%2B%20b%20y%20%2B%20y%20b%20-%20a%20x%20a%20%5Csucceq%200)

The above sequence of calculations is automated by the command
[`NCConvexityRegion`](#ncconvexityregion) as in

    << NCConvexity`
    NCConvexityRegion[expr, {x}]

which results in

``` output
{2 inv[1 + b**y + y**b - a**x**a], 0}
```

which correspond to the diagonal entries of the LDL decomposition of
the middle matrix of the nc Hessian.

# More Advanced Commands

In this chapter we describe some more advance features and
commands.

If you want a living version of this chapter just run the notebook
`NC/DEMOS/2_MoreAdvancedCommands.nb`.

    << NC`
    << NCAlgebra`

## Advanced Rules and Replacements

Substitution is a key feature of Symbolic computation. We will now
discuss some issues related to Mathematica’s implementation of rules
and replacements that can affect the behavior of `NCAlgebra`
expressions.

### `ReplaceAll` (`/.`) and `ReplaceRepeated` (`//.`) often fail

The first issue is related to how Mathematica performs substitutions,
which is through
[pattern matching](http://reference.wolfram.com/language/guide/RulesAndPatterns.html). For
a rule to be effective if has to match the *structural*
representation of an expression. That representation might be
different than one would normally think based on the usual properties
of mathematical operators. For example, one would expect the rule:

``` output
rule = 1 + x_ -> x
```

to match all the expressions bellow:

``` output
1 + a
1 + 2 a
1 + a + b
1 + 2 a * b
```

so that

``` output
expr /. rule
```

with `expr` taking the above expressions would result in:

``` output
a
2 a
a + b
2 a * b
```

Indeed, Mathematica’s attribute `Flat` does precisely that. Note that
this is still *structural matching*, not *mathematical matching*, since
the pattern `1 + x_` would not match an integer `2`, even though one
could write `2 = 1 + 1`!

Unfortunately, `**`, which is the `NonCommutativeMultiply` operator,
*is not* `Flat`[^6]. This is the reason why substitution based
on a simple rule such as:

    rule = a**b -> c

so that

``` output
expr /. rule
```

will work for some `expr` like

    1 + 2 a**b /. rule

resulting in

``` output
1 + 2 c
```

but will fail to produce the *expected* result in cases like:

    a**b**c /. rule

or

    c**a**b /. rule
    c**a**b**d /. rule
    1 + 2 a**b**c /. rule

That’s what the `NCAlgebra` family of replacement functions discussed
in the next section are made for.

### The fix is `NCReplace`

Continuing with the example in the previous section, the calls

    NCReplaceAll[a**b**c, rule]
    NCReplaceAll[ c**a**b, rule ]
    NCReplaceAll[c**a**b**d, rule]
    NCReplaceAll[1 + 2 a**b**c, rule ]

produce the results one would expect:

``` output
c^2
c^2
c^2**d
1 + 2 c^2
```

For this reason, when substituting in `NCAlgebra` it is always safer
to use functions from the [`NCReplace` package](#ncreplace)
rather than the corresponding Mathematica `Replace` family of
functions. Unfortunately, this comes at a the expense of sacrificing
the standard operators `/.` (`ReplaceAll`) and `//.`
(`ReplaceRepeated`), which cannot be safely overloaded, forcing one to
use the full names `NCReplaceAll` and `NCReplaceRepeated`.

On the same vein, the following substitution rule

    NCReplaceAll[2 a**b + c, 2 a -> b]

will return `2 a**b + c` intact since

    FullForm[2 a**b]

is actually

``` output
Times[2, NonCommutativeMuliply[a, b]]
```

which is not structurally related to

    FullForm[2 a]

which is

``` output
Times[2, a]
```

Of course, in this case a simple solution is to use the
alternative rule:

    NCReplaceAll[2 a**b + c, a -> b / 2]

which results in `b^2 + c`, as one might expect.

### Matching monomials with powers

Starting with **Version 6**, `NCAlgebra` stores repeated symbols in
noncommutative monomials using powers. This means that

    expr = a**a**a**b**a**a**b**a**b
    FullForm[expr]

is internally stored as

``` output
NonCommutativeMultiply[a^3, b, a^2, b, a, b]
```

so that a replacement such as

    NCReplaceAll[expr, a**b -> c, ApplyPowerRule -> False]

will result in

``` output
a^3**b**a^2**b**c
```

Note how the rule fails to match the `a**b` in the terms `a**b^2` and
`a**b^3`. This situation might be familiar to an experienced
Mathematica user who is a aware of the difference between structural
pattern matching and mathematical matching[^7].

As a convenience for `NCAlgebra` users, **Version 6** provides the
function [NCReplacePowerRule](#ncreplacepowerrule) that modifies a
user’s rule in order to accomplish matching of symbols in `NCAlgebra`
expressions including powers. For example, for the same `expr` above,
the following replacement

    NCReplaceAll[expr, NCReplacePowerRule[a**b -> c], ApplyPowerRule -> False]

will produce the more familiar

``` output
a^2**c**a^2**b**a**b
```

after matching `a**b` in the term `a^3**b`, and

    NCReplaceRepeated[expr, NCReplacePowerRule[a**b -> c], ApplyPowerRule -> False]

will produce

``` output
a^2**c**a**c^2
```

after matching `a**b` in `a^3**b`, `a^2**b`, and `a**b`.

The command `NCReplacePowerRule` works by modifying noncommutative
patterns with symbols appearing at the edges of monomials to account
for the potential presence of `Power` in a noncommutative
monomial. For example,

    NCReplacePowerRule[a**c**b -> d]

produces the modified rule[^8]

``` output
a^n_.**c**b^m_. -> a^(n-1)**d**b^(m-1)
```

which can successfully match powers of the symbols `a` and `b`
appearing in the monomial `a**c**b`.

The application of `NCReplacePowerRule` can also be done by invoking
the option `ApplyPowerRule`, which is available in all functions of
the package [NCReplace](#ncreplace). Currently,
`ApplyPowerRule` is set to `True` by default so that the commands

    NCReplaceRepeated[expr, a**b -> c]
    NCReplaceRepeated[expr, a**b -> c, ApplyPowerRule -> True]

do the same thing as

    NCReplaceRepeated[expr, NCReplacePowerRule[a**b -> c], ApplyPowerRule -> False]

This option can also be turned off globally for all calls to the
`NCReplace` family of functions in a `NCAlgebra` session by calling

    SetOptions[NCReplace, ApplyPowerRule -> False];

After that, all calls to `NCReplace`, `NCReplaceAll`,
`NCReplaceRepeated`, and related function, will be done with the option
`ApplyPowerRule -> False` automatically.

To revert to the default behavior just set

    SetOptions[NCReplace, ApplyPowerRule -> True];

### Trouble with `Block` and `Module`

A second more esoteric issue related to substitution in `NCAlgebra`
does not have a clean solution. It is also one that usually lurks in
hidden pieces of code and can be very difficult to spot. We have been
victim of such “bugs” many times. Luckily it only affect advanced users
that are using `NCAlgebra` inside their own functions using
Mathematica’s `Block` and `Module` constructions. It is also not a
real bug, since it follows from some often not well understood issues
with the usage of
[`Block` versus `Module`](http://reference.wolfram.com/language/tutorial/BlocksComparedWithModules.html). Our
goal here is therefore not to *fix* the issue but simply to alert
advanced users of its existence. Start by first revisiting the
following example from the
[Mathematica documentation](http://reference.wolfram.com/language/tutorial/BlocksComparedWithModules.html). Let

    m = i^2

and run

    Block[{i = a}, i + m]

which returns the “expected”

``` output
a + a^2
```

versus

    Module[{i = a}, i + m]

which returns the “surprising”

``` output
a + i**i
```

The reason for this behavior is that `Block` effectively evaluates `i`
as a *local variable* and evaluates `m` using whatever values are available
at the time of evaluation, whereas `Module` only evaluates the symbol
`i` which appears *explicitly* in `i + m` and not `m` using the local
value of `i = a`. This can lead to many surprises when using
rules and substitution inside a `Module`. For example:

    Block[{i = a}, i_ -> i]

will return

``` output
i_ -> a
```

whereas

    Module[{i = a}, i_ -> i]

will return

``` output
i_ -> i
```

More devastating for `NCAlgebra` is the fact that `Module` will hide
local definitions from rules, which will often lead to disaster if
local variables need to be declared noncommutative. Consider for
example the trivial definitions for `F` and `G` below:

    F[exp_] := Module[
      {rule, aa, bb},
      SetNonCommutative[aa, bb];
      rule = aa_**bb_ -> bb**aa;
      NCReplaceAll[exp, rule]
    ]

    G[exp_] := Block[
      {rule, aa, bb},
      SetNonCommutative[aa, bb];
      rule = aa_**bb_ -> bb**aa;
      NCReplaceAll[exp, rule]
    ]

Their only difference is that one is defined using a `Block` and the
other is defined using a `Module`. The task is to apply a rule that
*flips* the noncommutative product of their arguments, say, `x**y`,
into `y**x`. The problem is that only one of those definitions work
“as expected.” Indeed, verify that

    G[x**y]

returns the “expected”

``` output
y**x
```

whereas

    F[x**y]

returns

``` output
x y
```

which completely destroys the noncommutative product. The reason for
the catastrophic failure of the definition of `F`, which is inside a
`Module`, is that the letters `aa` and `bb` appearing in `rule` are
*not treated as the local symbols `aa` and `bb`*[^9]. For this
reason, the right-hand side of the rule `rule` involves the global
symbols `aa` and `bb`, which are, in the absence of a declaration to
the contrary, commutative. On the other hand, the definition of `G`
inside a `Block` makes sure that `aa` and `bb` are evaluated with
whatever value they might have locally at the time of execution.

The above subtlety often manifests itself partially, sometimes causing
what might be perceived as some kind of *erratic behavior*. Indeed, if
one had used symbols that were already declared globally noncommutative
by `NCAlgebra`, such as single small cap roman letters as in the
definition:

    H[exp_] := Module[
      {rule, a, b},
      SetNonCommutative[a, b];
      rule = a_**b_ -> b**a;
      NCReplaceAll[exp, rule]
    ]

then calling

    H[x**y]

works “as expected,” even if for the wrong reasons!

Another possible “fix” is to use a delayed rule, as in:

    H[exp_] := Module[
      {rule, aa, bb},
      SetNonCommutative[aa, bb];
      rule = aa_**bb_ :> bb**aa;
      NCReplaceAll[exp, rule]
    ]

with which

    H[x**y]

would also work because the evaluation of the right-hand side of the
rule is delayed until the time of its application.

## Expanding matrix products

Starting at **Version 5** the operators `**` and `inv` apply also to
matrices. However, in order for `**` and `inv` to continue to work as
full fledged operators, the result of multiplications or inverses of
matrices is held unevaluated until the user calls
[`NCMatrixExpand`](#ncmatrixexpand). This is in the the same spirit as
good old fashion commutative operations in Mathematica.

For example, with

    m1 = {{a, b}, {c, d}}
    m2 = {{d, 2}, {e, 3}}

the call

    m1**m2

results in

``` output
{{a, b}, {c, d}}**{{d, 2}, {e, 3}}
```

Upon calling

    m1**m2 // NCMatrixExpand

the matrix product evaluation takes place returning

``` output
{{a**d + b**e, 2a + 3b}, {c**d + d**e, 2c + 3d}}
```

which is what would have arisen from calling `NCDot[m1,m2]`[^10]. Likewise

    inv[m1]

results in

``` output
inv[{{a, b}, {c, d}}]
```

and

    inv[m1] // NCMatrixExpand

returns the evaluated result

``` output
{{inv[a]**(1 + b**inv[d - c**inv[a]**b]**c**inv[a]), -inv[a]**b**inv[d - c**inv[a]**b]}, 
 {-inv[d - c**inv[a]**b]**c**inv[a], inv[d - c**inv[a]**b]}}
```

or, using `MatrixForm`:

    inv[m1] // NCMatrixExpand // MatrixForm

returns

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20a%5E%7B-1%7D%20%281%20%2B%20b%20%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20c%20a%5E%7B-1%7D%29%20%26%20-a%5E%7B-1%7D%20b%20%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20%5C%5C%20-%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20c%20a%5E%7B-1%7D%20%26%20%28d%20-%20c%20a%5E%7B-1%7D%20b%29%5E%7B-1%7D%20%5Cend%7Bbmatrix%7D)

A less trivial example is

    m3 = m1**inv[IdentityMatrix[2] + m1] - inv[IdentityMatrix[2] + m1]**m1

that returns

``` output
-inv[{{1 + a, b}, {c, 1 + d}}]**{{a, b}, {c, d}} + 
     {{a, b}, {c, d}}**inv[{{1 + a, b}, {c, 1 + d}}]
```

Expanding

    NCMatrixExpand[m3]

results in

``` output
{{b**inv[b - (1 + a)**inv[c]**(1 + d)] - inv[c]**(1 + (1 + d)**inv[b - 
    (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c])**c - a**inv[c]**(1 + d)**inv[b - 
    (1 + a)**inv[c]**(1 + d)] + inv[c]**(1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**a, 
  a**inv[c]**(1 + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c]) - 
    inv[c]**(1 + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c])**d - 
    b**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c] + inv[c]**(1 + d)**inv[b - 
    (1 + a)**inv[c]**(1 + d)]** b}, 
 {d**inv[b - (1 + a)**inv[c]**(1 + d)] - (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)] - 
    inv[b - (1 + a)**inv[c]**(1 + d)]**a + inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a), 
  1 - inv[b - (1 + a)**inv[c]**(1 + d)]**b - d**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + 
    a)**inv[c] + (1 + d)**inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c] + 
    inv[b - (1 + a)**inv[c]**(1 + d)]**(1 + a)**inv[c]**d}}
```

and, finally,

    NCMatrixExpand[m3] // NCSimplifyRational    

returns

``` output
{{0, 0}, {0, 0}}
```

as expected.

### Trouble with `Plus` (`+`) and matrices

Mathematica’s choice of treating lists and matrix indistinctively can
cause much trouble when mixing `**` with `Plus` (`+`) operator. The
reason for that is that `Plus` is `Listable`, and an expression like

    z + m1

where `m1` is an array and `z` is not, is automatically expanded into

``` output
{{a + z, b + z}, {c + z, d + z}}
```

or, using `MatrixForm`:

    z + m1 // MatrixForm

resulting in

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20a%20%2B%20z%20%26%20b%20%2B%20z%20%5C%5C%20c%20%2B%20z%20%26%20d%20%2B%20z%20%5Cend%7Bbmatrix%7D)

Because of this “feature”, the expression

    m1**m2 + m2 // NCMatrixExpand

evaluates to the “wrong” result

``` output
{{{{d + a**d + b**e, 2 a + 3 b + d}, {d + c**d + d**e, 2 c + 4 d}},
 {{2 + a**d + b**e, 2 + 2 a + 3 b}, {2 + c**d + d**e, 2 + 2 c + 3 d}}}, 
 {{{e + a**d + b**e, 2 a + 3 b + e}, {e + c**d + d**e, 2 c + 3 d + e}}, 
 {{3 + a**d + b**e, 3 + 2 a + 3 b}, {3 + c**d + d**e, 3 + 2 c + 3 d}}}}
```

which is different than the “correct” result

``` output
{{d + a**d + b**e, 2 + 2 a + 3 b}, 
 {e + c**d + d**e, 3 + 2 c + 3 d}}
```

which is returned by either

    NCMatrixExpand[m1**m2] + m2

or

    NCDot[m1, m2] + m2

The reason for the behavior is that `m1**m2` is essentially treated
as a *scalar* (it does not have *head* `List`) and therefore gets
added entrywise to `m2` *before* `NCMatrixExpand` has a chance to
evaluate the `**` product.

There are no easy fixes for this problem, which affects not only
`NCAlgebra` but any similar type of matrix product evaluation in
Mathematica. With `NCAlgebra`, a better option is to use
[`NCMatrixReplaceAll`](#ncmatrixreplaceall) or
[`NCMatrixReplaceRepeated`](#ncmatrixreplacerepeated). As seen in the
section [Replace with matrices](#replace-with-matrices), the command

    NCMatrixReplaceAll[x**y + y, {x -> m1, y -> m2}]

produces the expected result:

``` output
{{d + a**d + b**e, 2 + 2 a + 3 b}, 
 {e + c**d + d**e, 3 + 2 c + 3 d}}
```

Note that the above behavior might be erratic, since in an expression like

    m1**m2 + m2**m1

in which `**` is kept unevaluated as in

``` output
{{a, b}, {c, d}}**{{d, 2}, {e, 3}} + {{d, 2}, {e, 3}}**{{a, b}, {c, d}}
```

the command

    m1**m2 + m2**m1 // NCMatrixExpand

expands to the expected result

``` output
{{2 c + a**d + b**e + d**a, 2 a + 3 b + 2 d + d**b}, 
 {3 c + c**d + d**e + e**a, 2 c + 6 d + e**b}}
```

## Polynomials with commutative coefficients

The package [`NCPoly`](#ncpoly) provides an efficient structure
for storing and operating with noncommutative polynomials with
commutative coefficients. There are two main goals:

1.  *Ordering*: to be able to sort polynomials based on an *ordering*
    specified by the user. See the chapter
    [Noncommutative Gröbner Basis](#noncommutative-gröbner-basis) for more details.
2.  *Efficiency*: to efficiently perform polynomial algebra with as
    little overhead as possible.

Those two properties allow for an efficient implementation of
`NCAlgebra`’s noncommutative Gröbner basis algorithm, new in **Version
5**, without the use of auxiliary accelerating `C` code, as in
`NCGB`. See [Noncommutative Gröbner Basis](#noncommutative-gröbner-basis).

Before getting into details, to see how much more efficient `NCPoly`
is when compared with standard `NCAlgebra` objects try

    Table[Timing[NCExpand[(1 + x)^i]][[1]], {i, 0, 15, 5}]

which would typically return something like

``` output
{0.000088, 0.001074, 0.017322, 0.240704, 3.61492}
```

whereas the equivalent

    << NCPoly`
    Table[Timing[(1 + NCPolyMonomial[{x}, {x}])^i][[1]], {i, 0, 15, 5}]

would return

``` output
{0.00097, 0.001653, 0.002208, 0.003908, 0.004306}
```

The best way to work with `NCPoly` in `NCAlgebra` is by loading the
package [`NCPolyInterface`](#ncpolyinterface):

    << NCPolyInterface`

which provides the commands [`NCToNCPoly`](#nctoncpoly) and
[`NCPolyToNC`](#ncpolytonc) to convert nc expressions back and forth
between `NCAlgebra` and `NCPoly`.

For example

    vars = {x, y, z};
    p = NCToNCPoly[1 + x**x - 2 x**y**z, vars]

converts the polynomial `1 + x**x - 2 x**y**z` from the standard
`NCAlgebra` format into an `NCPoly` object. The result in this case is the
`NCPoly` object

``` output
NCPoly[{1, 1, 1}, <|{0, 0, 0, 0} -> 1, {0, 0, 2, 0} -> 1, {1, 1, 1, 5} -> -2|>]
```

Conversely the command [`NCPolyToNC`](#ncpolytonc) converts an
`NCPoly` back into `NCAlgebra` format. For example

    NCPolyToNC[p, vars]

returns

``` output
1 + x^2 - 2 x**y**z
```

as expected. Note that an `NCPoly` object does not store symbols, but
rather a representation of the polynomial based on specially encoded
monomials. This is the reason why one should provide `vars` as an
argument to `NCPolyToNC`.

Alternatively, one could construct the same `NCPoly` object by calling
`NCPoly` directly as in

    NCPoly[{1, 1, -2}, {{}, {x, x}, {x, y, z}}, vars]

In this syntax the first argument is a list of *coefficients*, the
second argument is a list of *monomials*, and the third is the list of
*variables*. *Monomials* are given as lists, with `{}` being
equivalent to a constant `1`.

The particular coefficients in the `NCPoly` object depend not only on
the polynomial being represented but also on the *ordering* implied by
the sequence of symbols in the list of variables `vars`. For example:

    vars = {{x}, {y, z}};
    p = NCToNCPoly[1 + x**x - 2 x**y**z, vars]

produces:

``` output
NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {0, 2, 0} -> 1, {2, 1, 5} -> -2|>
```

The sequence of braces in the list of *variables* encodes the
*ordering* to be used for sorting `NCPoly`s. Orderings specify how
monomials should be ordered, and is discussed in detail in
[Noncommutative Gröbner Basis](#noncommutative-gröbner-basis).

We provide the convenience commands
[`NCMonomialOrder`](#ncmonomialorder),
[`NCMonomialOrderQ`](#ncmonomialorderq) and
[`NCPolyDisplayOrder`](#ncpolydisplayorder) to help building and
visualizing orderings.

[`NCPolyDisplayOrder`](#ncpolydisplayorder) prints the polynomial
ordering implied by a list of symbols. For example

    NCPolyDisplayOrder[{x,y,z}]

prints out

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%5Cll%20z)

and

    NCPolyDisplayOrder[{{x},{y,z}}]

prints out

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%3C%20z)

from where you can see that grouping variables inside braces induces a
graded type ordering, as discussed in [Noncommutative Gröbner
Basis](#noncommutative-gröbner-basis).

With [`NCMonomialOrder`](#ncmonomialorder) you
can basically dispense with the “outer” braces. For example

    NCMonomialOrder[{x},{y,z}]

returns

``` output
{{x},{y,z}}
```

It also validates the resulting ordering using
[`NCMonomialOrderQ`](#ncmonomialorderq) so that

    NCMonomialOrder[{x},{y,{z}}]

will fail and print an error message. Note that

    NCMonomialOrder[x,y,z]

returns

``` output
{{x},{y},{z}}
```

which corresponds to

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%5Cll%20z)

and

    NCMonomialOrder[{x, y, z}]

returns

``` output
{{x,y,z}}
```

which corresponds to

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%3C%20y%20%3C%20z)

There is also a special constructor for monomials. For example

    vars = NCMonomialOrder[{x}, {y,z}];
    NCPolyMonomial[{y,x}, vars]
    NCPolyMonomial[{x,y}, vars]

return the monomials corresponding to ![y x](https://render.githubusercontent.com/render/math?math=y%20x&mode=inline) and ![x y](https://render.githubusercontent.com/render/math?math=x%20y&mode=inline) using the
ordering ![x \ll y \< z](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%3C%20z&mode=inline).

Operations on `NCPoly` objects result in another `NCPoly` object that
is always expanded. For example:

    vars = {{x}, {y, z}};
    1 + NCPolyMonomial[{x, y}, vars] - 2 NCPolyMonomial[{y, x}, vars]

returns

``` output
NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {1, 1, 1} -> 1, {1, 1, 3} -> -2|>]
```

and

    p = (1 + NCPolyMonomial[{x}, vars]**NCPolyMonomial[{y}, vars])^2

returns

``` output
NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {1, 1, 1} -> 2, {2, 2, 10} -> 1|>]
```

> **WARNING:** `NCPoly`s constructed from different orderings cannot
> be combined or otherwise operated.

Another convenience function is `NCPolyDisplay` which returns a list
with the monomials appearing in an `NCPoly` object. For example:

    NCPolyDisplay[p, vars]

returns

``` output
{x.y.x.y, 2 x.y, 1}
```

The reason for displaying an `NCPoly` object as a list is so that the
monomials can appear in the same order as they are stored. Using
`Plus` would revert to Mathematica’s default ordering. For example

    p = NCToNCPoly[1 + x**y**x - 2 x**x + z, vars]
    NCPolyDisplay[p, vars]

returns

``` output
{x.y.x, z, -2 x.x, 1}
```

whereas

    NCPolyToNC[p, vars]

would return

``` output
1 - 2 x^2 + z + x**y**x
```

in which the sorting of the monomials has been destroyed by `Plus`.

The monomials appear sorted in decreasing order from left to right,
with `z` being the *leading term* in the above example.

With `NCPoly` the Mathematica command `Sort` is modified to sort lists
of polynomials. For example

    polys = NCToNCPoly[{x**x**x, 2 y**x - z, z, y**x - x**x}, vars];
    ColumnForm[NCPolyDisplay[Sort[polys], vars]]

returns

``` output
{x.x.x}
{z}
{y.x, -x.x}
{2 y.x, -z}
```

`Sort` produces a list of polynomials sorted in *ascending* order
based on their *leading terms*.

## Polynomials with noncommutative coefficients

A larger class of polynomials in noncommutative variables is that of
polynomials with noncommutative coefficients. Think of a polynomial
with commutative coefficients in which certain variables are
considered to be unknown, i.e. *variables*, where others are
considered to be known, i.e. *coefficients*. For example, in many
problems in systems and control the following expression

![inline equation](https://render.githubusercontent.com/render/math?math=p%28x%29%20%3D%20a%20x%20%2B%20x%20a%5ET%20-%20x%20b%20x%20%2B%20c)

is often seen as a polynomial in the noncommutative unknown `x` with
known noncommutative coefficients `a`, `b`, and `c`. A typical problem
is the determination of a solution to the equation ![p(x) = 0](https://render.githubusercontent.com/render/math?math=p%28x%29%20%3D%200&mode=inline) or the
inequality ![p(x) \succeq 0](https://render.githubusercontent.com/render/math?math=p%28x%29%20%5Csucceq%200&mode=inline).

The package [`NCPolynomial`](#ncpolynomial) handles such
polynomials with noncommutative coefficients. As with
[`NCPoly`](#ncpoly), the package provides the commands
[`NCToNCPolynomial`](#nctoncpolynomial) and
[`NCPolynomialToNC`](#ncpolynomialtonc) to convert nc expressions back
and forth between `NCAlgebra` and `NCPolynomial`. For example

    vars = {x}
    p = NCToNCPolynomial[a**x + x**tp[a] - x**b**x + c, vars]

converts the polynomial `a**x + x**tp[a] - x**b**x + c` from
the standard `NCAlgebra` format into an `NCPolynomial` object. The
result in this case is the `NCPolynomial` object

``` output
NCPolynomial[c, <|{x} -> {{1, a, 1}, {1, 1, tp[a]}}, {x, x} -> {{-1, 1, b, 1}}|>, {x}]
```

Conversely the command [`NCPolynomialToNC`](#ncpolynomialtonc)
converts an `NCPolynomial` back into `NCAlgebra` format. For example

    NCPolynomialToNC[p]

returns

``` output
c + a**x + x**tp[a] - x**b**x
```

An `NCPolynomial` does store information about the polynomial symbols
and a list of variables is required only at the time of creation of
the `NCPolynomial` object.

As with `NCPoly`, operations on `NCPolynomial` objects result on
another `NCPolynomial` object that is always expanded. For example:

    vars = {x,y}
    1 + NCToNCPolynomial[x**y, vars] - 2 NCToNCPolynomial[y**x, vars]

returns

``` output
NCPolynomial[1, <|{y**x} -> {{-2, 1, 1}}, {x**y} -> {{1, 1, 1}}|>, {x, y}]
```

and

    (1 + NCToNCPolynomial[x, vars]**NCToNCPolynomial[y, vars])^2

returns

``` output
NCPolynomial[1, <|{x**y**x**y} -> {{1, 1, 1}}, {x**y} -> {{2, 1, 1}}|>, {x, y}]
```

To see how much more efficient `NCPolynomial` is when compared with standard
`NCAlgebra` objects try

    Table[Timing[(NCToNCPolynomial[x, vars])^i][[1]], {i, 0, 15, 5}]

would return

``` output
{0.000493, 0.003345, 0.005974, 0.013479, 0.018575}
```

As you can see, `NCPolynomial`s are not as efficient as `NCPoly`s but
still much more efficient than `NCAlgebra` polynomials.

`NCPolynomials` do not support *orderings* but we do provide the
`NCPSort` command that produces a list of terms sorted by degree. For
example

    NCPSort[p]

returns

``` output
{c, a**x, x**tp[a], -x**b**x}
```

A useful feature of `NCPolynomial` is the capability of handling
polynomial matrices. For example

    mat1 = {{a**x + x**tp[a] + c**y + tp[y]**tp[c] - x**q**x, b**x}, 
            {x**tp[b], 1}};
    p1 = NCToNCPolynomial[mat1, {x, y}];

    mat2 = {{1, x**tp[c]}, {c**x, 1}};
    p2 = NCToNCPolynomial[mat2, {x, y}];

constructs `NCPolynomial` objects representing the polynomial matrices
`mat1` and `mat2`. Verify that

    NCPolynomialToNC[p1**p2] - NCDot[mat1, mat2] // NCExpand

is zero as expected. Internally `NCPolynomial` represents a polynomial
matrix by constructing matrix factors. For example the representation
of the matrix `mat1` correspond to the factors

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%5Cbegin%7Bbmatrix%7D%0A%20%20%20%20a%20x%20%2B%20x%20a%5ET%20%2B%20c%20y%20%2B%20y%5ET%20c%5ET%20-%20x%20q%20x%20%26%20b%20x%20%5C%5C%20%0A%20%20%20%20x%20b%5ET%20%26%201%0A%5Cend%7Bbmatrix%7D%20%0A%26%3D%0A%5Cbegin%7Bbmatrix%7D%200%20%26%200%20%5C%5C%200%20%26%201%20%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%20a%20%5C%5C%200%20%5Cend%7Bbmatrix%7D%0Ax%0A%5Cbegin%7Bbmatrix%7D%201%20%26%200%20%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%201%20%5C%5C%200%20%5Cend%7Bbmatrix%7D%0Ax%0A%5Cbegin%7Bbmatrix%7D%20a%5ET%20%26%200%20%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%20-1%20%5C%5C%200%20%5Cend%7Bbmatrix%7D%0Ax%20q%20x%0A%5Cbegin%7Bbmatrix%7D%201%20%26%200%20%5Cend%7Bbmatrix%7D%0A%2B%20%5C%5C%20%26%20%5Cqquad%20%5Cquad%0A%5Cbegin%7Bbmatrix%7D%20b%20%5C%5C%200%20%5Cend%7Bbmatrix%7D%0Ax%0A%5Cbegin%7Bbmatrix%7D%200%20%26%201%20%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%200%20%5C%5C%201%20%5Cend%7Bbmatrix%7D%0Ax%0A%5Cbegin%7Bbmatrix%7D%20b%5ET%20%26%200%20%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%20c%20%5C%5C%200%20%5Cend%7Bbmatrix%7D%0Ay%0A%5Cbegin%7Bbmatrix%7D%201%20%26%200%20%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%201%20%5C%5C%200%20%5Cend%7Bbmatrix%7D%0Ay%5ET%0A%5Cbegin%7Bbmatrix%7D%20c%5ET%20%26%200%20%5Cend%7Bbmatrix%7D%0A%5Cend%7Baligned%7D)

</div>

See section [linear polynomials](#linear-polynomials) for more features on
linear polynomial matrices.

## Linear polynomials

Another interesting class of nc polynomials is that of linear
polynomials, which can be factored in the form:

![inline equation](https://render.githubusercontent.com/render/math?math=s%28x%29%20%3D%20l%20%28F%20%5Cotimes%20x%29%20r)

where ![l](https://render.githubusercontent.com/render/math?math=l&mode=inline) and ![r](https://render.githubusercontent.com/render/math?math=r&mode=inline) are vectors with symbolic expressions and ![F](https://render.githubusercontent.com/render/math?math=F&mode=inline) is a
numeric matrix. This functionality is in the package

    << NCSylvester`

Use the command [`NCToNCSylvester`](#nctoncsylvester) to factor a
linear nc polynomial into the the above form. For example:

    vars = {x, y};
    expr = 1 + a**x + x**tp[a] - x + b**y**d + tp[d]**tp[y]**tp[b];
    {const, lin} = NCToNCSylvester[expr, vars];

which returns

``` output
const = 1
```

and an `Association` `lin` containing the factorization. For example

    lin[x]

returns a list with the left and right vectors `l`
and `r` and the coefficient array `F`.

``` output
{{1, a}, {1, a^T}, SparseArray[< 2 >, {2, 2}]}
```

which in this case is the matrix:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%0A%20%20%20%20-1%20%26%201%5C%5C%0A%20%20%20%201%20%26%200%0A%5Cend%7Bbmatrix%7D)

and

    lin[tp[y]]

returns

``` output
{{d^T}, {b^T}, SparseArray[< 1 >, {1, 1}]}
```

Note that transposes and adjoints are treated as independent
variables.

Perhaps the most useful consequence of the above factorization is the
possibility of producing a linear polynomial which has the smallest
possible number of terms, as explaining in detail in
(Oliveira 2012). This is done automatically by
[`NCSylvesterToNC`](#ncsylvestertonc). For example

    vars = {x, y};
    expr = a**x**c - a**x**d - a**y**c + a**y**d + b**x**c - b**x**d - b**y**c + b**y**d;
    {const, lin} = NCToNCSylvester[expr, vars];
    NCSylvesterToNC[{const, lin}]

produces:

``` output
(a + b)**x**(c - d) + (a + b)**y**(-c + d)
```

This factorization even works with linear matrix polynomials, and is
used by the our semidefinite programming algorithm (see Chapter
[Semidefinite Programming](#semidefinite-programming)) to factor linear
matrix inequalities in the least possible number of terms. For example:

    vars = {x};
    expr = {{a**x + x**tp[a], b**x, tp[c]},
            {x**tp[b], -1, tp[d]},
            {c, d, -1}};
    {const, lin} = NCToNCSylvester[expr, vars]

result in:

``` output
const = SparseArray[< 6 >, {3, 3}]
lin = <|x -> {{1, a, b}, {1, tp[a], tp[b]}, SparseArray[< 4 >, {9, 9}]}|>
```

See (Oliveira 2012) for details on the structure of the constant
array ![F](https://render.githubusercontent.com/render/math?math=F&mode=inline) in this case.

# Noncommutative Gröbner Basis

Gröbner Basis are useful in the study of algebraic relations. The
package `NCGBX` provides an implementation of a noncommutative Gröbner
Basis algorithm.

> Starting with **Version 6**, the old `C++` version of our Groebner
> Basis Algorithm is no longer included.

If you want a living version of this chapter just run the notebook
`NC/DEMOS/3_NCGroebnerBasis.nb`.

In order to load `NCGBX` one types:

    << NC`
    << NCAlgebra`
    << NCGBX`

or simply

    << NCGBX`

if `NC` and `NCAlgebra` have already been loaded.

## What is a Gröbner Basis?

Most commutative algebra packages contain commands based on Gröbner
Basis and uses of Gröbner Basis. For example, in Mathematica, the
`Solve` command puts collections of equations in a *canonical form*
which, for simple collections, readily yields a solution. Likewise,
the Mathematica `Eliminate` command tries to convert a collection of
![m](https://render.githubusercontent.com/render/math?math=m&mode=inline) polynomial equations (often called relations)

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%20%20p_1%28x_1%2C%5Cldots%2Cx_n%29%20%26%3D%200%20%5C%5C%0A%20%20%20%20p_2%28x_1%2C%5Cldots%2Cx_n%29%20%26%3D%200%20%5C%5C%0A%20%20%20%20%5Cvdots%20%5Cquad%20%26%20%5Cquad%20%5C%2C%20%5C%2C%20%5Cvdots%20%5C%5C%0A%20%20%20%20p_m%28x_1%2C%5Cldots%2Cx_n%29%20%26%3D%200%0A%5Cend%7Baligned%7D)

in variables ![x_1,x_2, \ldots x_n](https://render.githubusercontent.com/render/math?math=x_1%2Cx_2%2C%20%5Cldots%20x_n&mode=inline) to a *triangular* form, that is a
new collection of equations like

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%20%20q_1%28x_1%29%20%26%3D%200%20%5C%5C%0A%20%20%20%20q_2%28x_1%2Cx_2%29%20%26%3D%200%20%5C%5C%0A%20%20%20%20q_3%28x_1%2Cx_2%29%20%26%3D%200%20%5C%5C%0A%20%20%20%20q_4%28x_1%2Cx_2%2Cx_3%29%26%3D0%20%5C%5C%0A%20%20%20%20%5Cvdots%20%5Cquad%20%26%20%5Cquad%20%5C%2C%20%5C%2C%20%5Cvdots%20%5C%5C%0A%20%20%20%20q_%7Br%7D%28x_1%2C%5Cldots%2Cx_n%29%20%26%3D%200.%0A%5Cend%7Baligned%7D)

Here the polynomials ![\\q_j: 1\le j\le k_2\\](https://render.githubusercontent.com/render/math?math=%5C%7Bq_j%3A%201%5Cle%20j%5Cle%20k_2%5C%7D&mode=inline) generate the same
*ideal* that the polynomials ![\\p_j : 1\le j \le k_1\\](https://render.githubusercontent.com/render/math?math=%5C%7Bp_j%20%3A%201%5Cle%20j%20%5Cle%20k_1%5C%7D&mode=inline)
generate. Therefore, the set of solutions to the collection of
polynomial equations ![\\p_j=0: 1\le j\le k_1\\](https://render.githubusercontent.com/render/math?math=%5C%7Bp_j%3D0%3A%201%5Cle%20j%5Cle%20k_1%5C%7D&mode=inline) equals the set of
solutions to the collection of polynomial equations ![\\q_j=0: 1\le j\le k_2\\](https://render.githubusercontent.com/render/math?math=%5C%7Bq_j%3D0%3A%201%5Cle%20j%5Cle%20k_2%5C%7D&mode=inline). This canonical form greatly simplifies the task of
solving collections of polynomial equations by facilitating
backsolving for ![x_j](https://render.githubusercontent.com/render/math?math=x_j&mode=inline) in terms of ![x_1,\ldots,x\_{j-1}](https://render.githubusercontent.com/render/math?math=x_1%2C%5Cldots%2Cx_%7Bj-1%7D&mode=inline).

Readers who would like to know more about Gröbner Basis may want to
read \[CLS\]. The noncommutatative version of the algorithm implemented
by `NCGB` is loosely based on \[Mora\].

## Solving Equations

Before calculating a Gröbner Basis, one must declare which variables
will be used during the computation and must declare a *monomial
order* which can be done using `SetMonomialOrder` as in:

    SetMonomialOrder[{a, b, c}, x];

The monomial ordering imposes a relationship between the variables
which are used to *sort* the monomials in a polynomial. The ordering
implied by the above command can be visualized using:

    PrintMonomialOrder[]

which in this case prints:

![inline equation](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%3C%20c%20%5Cll%20x.)

A user does not need to know theoretical background related to
monomials orders. Indeed, as we shall see soon, in many engineering
problems, it suffices to know which variables correspond to quantities
which are *known* and which variables correspond to quantities which
are *unknown*. If one is solving for a variable or desires to prove
that a certain quantity is zero, then one would want to view that
variable as *unknown*. In the above example, the symbol ‘![\ll](https://render.githubusercontent.com/render/math?math=%5Cll&mode=inline)’
separate the *knowns*, ![a, b, c](https://render.githubusercontent.com/render/math?math=a%2C%20b%2C%20c&mode=inline), from the *unknown*, ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline). For more
details on orderings see Section [Orderings](#ordering-on-variables-and-monomials).

Our goal is to calculate the Gröbner basis associated with the
following relations (i.e. a list of polynomials):

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%20%20a%20%5C%2C%20x%20%5C%2C%20a%20%26%3D%20c%2C%20%26%0A%20%20%20%20a%20%5C%2C%20b%20%26%3D%201%2C%20%26%0A%20%20%20%20b%20%5C%2C%20a%20%26%3D%201.%0A%5Cend%7Baligned%7D)

We shall use the word *relation* to mean a polynomial in noncommuting
indeterminates. For example, if an analyst saw the equation ![A B = 1](https://render.githubusercontent.com/render/math?math=A%20B%20%3D%201&mode=inline)
for matrices ![A](https://render.githubusercontent.com/render/math?math=A&mode=inline) and ![B](https://render.githubusercontent.com/render/math?math=B&mode=inline), then he might say that ![A](https://render.githubusercontent.com/render/math?math=A&mode=inline) and ![B](https://render.githubusercontent.com/render/math?math=B&mode=inline) satisfy
the polynomial equation ![a\\ b - 1 = 0](https://render.githubusercontent.com/render/math?math=a%5C%2C%20b%20-%201%20%3D%200&mode=inline). An algebraist would say that
![a\\ b - 1](https://render.githubusercontent.com/render/math?math=a%5C%2C%20b%20-%201&mode=inline) is a relation.

To calculate a Gröbner basis one defines a list of relations:

    rels = {a**x**a - c, a**b - 1, b**a - 1}

and issues the command:

    gb = NCMakeGB[rels, 10]

which should produce an output similar to:

``` output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: a < b < c << x
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 4 polys in the basis, 2 obstructions
> MAJOR Iteration 2, 5 polys in the basis, 2 obstructions
* Cleaning up...
* Found Groebner basis with 3 polynomials
* * * * * * * * * * * * * * * *
```

The number `10` in the call to `NCMakeGB` is very important because a
finite GB may not exist. It instructs `NCMakeGB` to abort after `10`
iterations if a GB has not been found at that point.

The result of the above calculation is the list of relations in the
form of a list of rules:

``` output
{x -> b**c**b, a**b -> 1, b**a -> 1}
```

> **Version 5:** For efficiency, `NCMakeGB` returns a list of rules
> instead of a list of polynomials. The left-hand side of the rule is
> the leading monomial in the current order. This is incompatible with
> early versions, which returned a list of polynomials. You can
> recover the old behavior setting the option `ReturnRules -> False`. This can be done in the `NCMakeGB` command or globally
> through `SetOptions[ReturnRules -> False]`.

Our favorite format for displaying lists of relations is `ColumnForm`.

    ColumnForm[gb]

which results in

``` output
x -> b**c**b
a**b -> 1
b**a -> 1
```

The *rules* in the output represent the relations in the GB with the
left-hand side of the rule being the leading monomial. Replacing
`Rule` by `Subtract` recovers the relations but one would then loose
the leading monomial as Mathematica alphabetizes the resulting sum.

Someone not familiar with GB’s might find it instructive to note this
output GB effectively *solves* the input equation

![inline equation](https://render.githubusercontent.com/render/math?math=a%20%5C%2C%20x%20%5C%2C%20a%20-%20c%20%3D%200)

under the assumptions that

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%20%20b%20%5C%2C%20a%20-%201%20%26%3D%200%2C%20%26%0A%20%20%20%20a%20%5C%2C%20b%20-%201%20%26%20%3D0%2C%0A%5Cend%7Baligned%7D)

that is ![a = b^{-1}](https://render.githubusercontent.com/render/math?math=a%20%3D%20b%5E%7B-1%7D&mode=inline) and produces the expected result in the form of
the relation:

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%3D%20b%20%5C%2C%20c%20%5C%2C%20b.)

## A Slightly more Challenging Example

For a slightly more challenging example consider the same monomial
order as before:

    SetMonomialOrder[{a, b, c}, x];

that is

![a \< b \< c \ll x](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%3C%20c%20%5Cll%20x&mode=inline)

and the relations:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20a%20%5C%2C%20x%20-%20c%20%26%3D%200%2C%20%5C%5C%0A%20%20a%20%5C%2C%20b%20%5C%2C%20a%20-%20a%20%26%3D%200%2C%20%5C%5C%0A%20%20b%20%5C%2C%20a%20%5C%2C%20b%20-%20b%20%26%3D%200%2C%0A%5Cend%7Baligned%7D)

from which one can recognize the problem of solving the linear
equation ![a \\ x = c](https://render.githubusercontent.com/render/math?math=a%20%5C%2C%20x%20%3D%20c&mode=inline) in terms of the *pseudo-inverse* ![b = a^\dagger](https://render.githubusercontent.com/render/math?math=b%20%3D%20a%5E%5Cdagger&mode=inline). The calculation:

    gb = NCMakeGB[{a**x - c, a**b**a - a, b**a**b - b}, 10];
    ColumnForm[gb]

finds the Gröbner basis:

``` output
a**x -> c
a**b**c -> c
a**b**a -> a 
b**a**b -> b
```

In this case the Gröbner basis cannot quite *solve* the equations but
it remarkably produces the necessary condition for existence of
solutions:

![inline equation](https://render.githubusercontent.com/render/math?math=0%20%3D%20a%20%5C%2C%20b%20%5C%2C%20c%20-%20c%20%3D%20a%20%5C%2C%20a%5E%5Cdagger%20c%20-%20c)

that can be interpreted as ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline) being in the range-space of ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline).

## Simplifying Polynomial Expressions

Our goal now is to verify if it is possible to *simplify* the following
expression:

    expr = b^2**a^2 - a^2**b^2 + a**b**a

knowing that

![inline equation](https://render.githubusercontent.com/render/math?math=a%20%5C%2C%20b%20%5C%2C%20a%20%3D%20b)

using Gröbner basis. With that in mind we set the ordering:

    SetMonomialOrder[a,b];

and calculate the GB associated with the constraint:

    rels = {a**b**a - b};
    rules = NCMakeGB[rels, 10];
    ColumnForm[rules]

which produces the output

``` output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: a << b
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 2 polys in the basis, 1 obstructions
* Cleaning up...
* Found Groebner basis with 2 polynomials
* * * * * * * * * * * * * * * *
```

and the associated GB

``` output
a**b**a -> b
b^2**a -> a**b^2
```

The GB revealed another relationship that must hold true if ![a \\ b \\ a = b](https://render.githubusercontent.com/render/math?math=a%20%5C%2C%20b%20%5C%2C%20a%20%3D%20b&mode=inline). One can use these relationships to simplify the original
expression using `NCReplaceRepeated` as in

    NCReplaceRepeated[expr, rules]

which simplifies `expr` into `b`.

An alternative, since we are working with polynomials, is to use
[`NCReduce`](#ncreduce) as in

    vars = GetMonomialOrder[];
    NCReduce[expr, NCRuleToPoly[rules], vars]

Note that `NCReduce` needs a list of variables to be used as the
desired ordering, which we obtain from the current ordering using
[`GetMonomialOrder`](#getmonomialorder), and that the rules in `rules`
need to be converted to polynomials, which we do using
[`NCRuleToPoly`](NCRuleToPoly).

## Polynomials and Rules

Having seen how polynomial relations can be interpreted as rules,
consider the expression

    expr = b^2**a^2 + a^2**b^3 + a**b**a

and the polynomial relations

    rels = {a**b**a - b , b^2 - a + b}

With respect to the monomial ordering

    SetMonomialOrder[a, b];

we can interpret these relations as the rules

    vars = GetMonomialOrder[];
    (rules = NCToRule[rels, vars]) // ColumnForm

that is

``` output
a**b**a -> b
b^2 -> a - b
```

Note how we used [`GetMonomialOrder`](#getmonomialorder) to obtain the
list of variables `vars` corresponding to the ordering

![inline equation](https://render.githubusercontent.com/render/math?math=a%20%5Cll%20b)

and [`NCToRule`](#nctorule) to convert the polynomial relations into
rules.

We can then apply these rules by using one of the `NCReplace`
functions, for example

    NCExpandReplaceRepeated[expr, rules]

which produces

``` output
b + a^2**b + a^3**b - b**a^2
```

Note that we have made use of the new function
[`NCExpandReplaceRepeated`](#ncexpandreplacerepeated), to automate
the tedious cycles of expansion and substitution.

Alternatively, one can use [`NCReduce`](#ncreduce) to perform the same
substitution. `NCReduce` takes in polynomial, instead of rules, and a
list of variables. For example,

    NCReduce[expr, rels, vars]

produces

``` output
a^2**b + a^3**b - b**a^2 + a**b**a
```

which is the result of applying the rules only to the leading monomial
of `expr`. If you want substitutions to be applied to all monomials
then set the option `Complete` to `True`, as in

    NCReduce[expr, rels, vars, Complete -> True]

This produces

``` output
b + a^2**b + a^3**b - b**a^2
```

which is the same result as above.

But, of course, by now one should wonder whether the above polynomial
relations could imply other simplifications, which we seek to find out
by running our Gröbner basis algorithm:

    rules = NCMakeGB[rels, 4];
    ColumnForm[rules]

that discovers the following additional relations

``` output
b^2 -> a - b
b**a -> a**b
a^2**b -> b
a^3 -> a
```

When used for simplification,

    NCExpandReplaceRepeated[expr, rules]

reduces the original expression to the even simpler form

``` output
b + a**b
```

As before, rule substitution could also be performed by
[`NCReduce`](#ncreduce) as in

    NCReduce[expr, NCRuleToPoly[rules], vars]

that, in this case, leads to the same result as above without the need
to recourse to the `Complete` flag.

## Minimal versus Reduced Gröbner Basis

The algorithm implemented by `NCGB` always produces a Gröbner Basis
with the *minimal* possible number of polynomials at a given
iteration. However, such polynomials are not necessarily the
“simplest” possible polynomials; called the *reduced* Gröbner
Basis. The *reduced* Gröbner Basis is unique given the relations and
the monomial ordering. Consider for example the following monomial
ordering

    SetMonomialOrder[x, y]

and the relations

    rels = {x^3 - 2 x**y, x^2**y - 2 y^2 + x}

for which

    NCMakeGB[rels, ReduceBasis -> False] // ColumnForm

produces the *minimal* Gröbner Basis

``` output
x^2->0
x**y->x^3/2
y**x->x**y
y^2->x/2+x^2**y/2
```

but

    NCMakeGB[rels, ReduceBasis -> True] // ColumnForm

returns the *reduced* Gröbner Basis

``` output
x^2->0
x**y->0
y**x->0
y^2->x/2
```

in which not only the leading monomials but also all lower-order
monomials have been reduced by the basis’ leading monomials.
The option `ReduceBasis` is set to `True` by default.

## Simplifying Rational Expressions

It is often desirable to simplify expressions involving inverses of
noncommutative expressions. One challenge is to recognize identities
implied by the existence of certain inverses. For example, that the
expression

    expr = x**inv[1 - x] - inv[1 - x]**x

is equivalent to ![0](https://render.githubusercontent.com/render/math?math=0&mode=inline). One can use a nc Gröbner basis for that task.
Consider for instance the ordering

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20%281-x%29%5E%7B-1%7D)

implied by the command:

    SetMonomialOrder[x, inv[1-x]]

This ordering encodes the following precise idea of what we mean by
*simple* versus *complicated*: it formally corresponds to specifying
that ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) is simpler than ![(1-x)^{-1}](https://render.githubusercontent.com/render/math?math=%281-x%29%5E%7B-1%7D&mode=inline), which might sits well with
one’s intuition.

Now consider the following command:

    (rules = NCMakeGB[{}, 3]) // ColumnForm

which produces the output

``` output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: x <<  inv[x] << inv[1 - x]
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 6 polys in the basis, 6 obstructions
* Cleaning up...
* Found Groebner basis with 6 polynomials
* * * * * * * * * * * * * * * *
```

and results in the rules:

``` output
x**inv[1 - x] -> -1 + inv[1 - x],
inv[1-x]**x -> -1 + inv[1-x],
```

As in the previous example, the GB revealed new relationships that
must hold true if ![1- x](https://render.githubusercontent.com/render/math?math=1-%20x&mode=inline) is invertible, and one can use this
relationship to *simplify* the original expression using
`NCReplaceRepeated` as in:

    NCReplaceRepeated[expr, rules]

The above command results in `0`, as one would hope.

For a more challenging example consider the identity:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cleft%20%281%20-%20x%20-%20y%20%281%20-%20x%29%5E%7B-1%7D%20y%20%5Cright%20%29%5E%7B-1%7D%20%3D%20%5Cfrac%7B1%7D%7B2%7D%20%281%20-%20x%20-%20y%29%5E%7B-1%7D%20%2B%20%5Cfrac%7B1%7D%7B2%7D%20%281%20-%20x%20%2B%20y%29%5E%7B-1%7D)

One can verify that the rule based command
[NCSimplifyRational](#ncsimplifyrational-1) fails to simplify the
expression:

    expr = inv[1 - x - y**inv[1 - x]**y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
    NCSimplifyRational[expr]

We set the monomial ordering and calculate the Gröbner basis

    SetMonomialOrder[x, y, inv[1-x], inv[1-x+y], inv[1-x-y], inv[1-x-y**inv[1-x]**y]];
    (rules = NCMakeGB[{}, 3]) // ColumnForm

based on the rational involved in the original expression. The result
is the nc GB:

``` output
inv[1-x-y**inv[1-x]**y] -> (1/2)inv[1-x-y]+(1/2)inv[1-x+y]
x**inv[1-x] -> -1+inv[1-x]
y**inv[1-x+y] -> 1-inv[1-x+y]+x**inv[1-x+y]
y**inv[1-x-y] -> -1+inv[1-x-y]-x**inv[1-x-y]
inv[1-x]**x -> -1+inv[1-x]
inv[1-x+y]**y -> 1-inv[1-x+y]+inv[1-x+y]**x
inv[1-x-y]**y -> -1+inv[1-x-y]-inv[1-x-y]**x
inv[1-x+y]**x**inv[1-x-y] -> -(1/2)inv[1-x-y]-(1/2)inv[1-x+y]+inv[1-x+y]**inv[1-x-y]
inv[1-x-y]**x**inv[1-x+y] -> -(1/2)inv[1-x-y]-(1/2)inv[1-x+y]+inv[1-x-y]**inv[1-x+y]
```

which successfully simplifies the original expression using:

    NCExpandReplaceRepeated[expr, rules]

resulting in `0`.

See also [Advanced Processing of Rational
Expressions](#advanced-processing-of-rational-expressions) for more
details on the lower level handling of rational expressions.

## Simplification with NCGBSimplifyRational

The simplification process described above is automated in the
function [NCGBSimplifyRational](#ncgbsimplifyrational).

For example, calls to

    expr = x**inv[1 - x] - inv[1 - x]**x
    NCGBSimplifyRational[expr]

or

    expr = inv[1 - x - y**inv[1 - x]**y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
    NCGBSimplifyRational[expr]

both result in `0`.

## Ordering on Variables and Monomials

As seen above, one needs to declare a *monomial order* before making a
Gröbner Basis. There are various monomial orders which can be used
when computing Gröbner Basis. The most common are *lexicographic* and
*graded lexicographic* orders. We consider also *multi-graded
lexicographic* orders.

Lexicographic and multi-graded lexicographic orders are examples of
elimination orderings. An elimination ordering is an ordering which is
used for solving for some of the variables in terms of others.

We now discuss each of these types of orders.

### Lex Order: the simplest elimination order

To impose lexicographic order, say ![a\ll b\ll x\ll y](https://render.githubusercontent.com/render/math?math=a%5Cll%20b%5Cll%20x%5Cll%20y&mode=inline) on ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline)
and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), one types

    SetMonomialOrder[a,b,x,y];

or, equivalently

    SetMonomialOrder[{a},{b},{x},{y}];

This order is useful for attempting to solve for ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) in terms of ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline),
![b](https://render.githubusercontent.com/render/math?math=b&mode=inline) and ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), since the highest priority of the GB algorithm is to
produce polynomials which do not contain ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline). If producing high order
polynomials is a consequence of this fanaticism so be it. Unlike
graded orders, lex orders pay little attention to the degree of terms.
Likewise its second highest priority is to eliminate ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline).

Once this order is set, one can use all of the commands in the
preceding section in exactly the same form.

We now give a simple example how one can solve for
![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) given that ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline),![b](https://render.githubusercontent.com/render/math?math=b&mode=inline),![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline)
satisfy the equations:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A-b%5C%2C%20x%20%2B%20x%5C%2C%20y%20%20%5C%2C%20a%20%2B%20x%5C%2C%20b%20%5C%2C%20a%20%5C%2C%20%20a%20%26%3D%200%20%5C%5C%0Ax%20%5C%2C%20a-1%26%3D0%20%5C%5C%0Aa%5C%2C%20x-1%26%3D0%0A%5Cend%7Baligned%7D)

The command

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4] // ColumnForm

produces the Gröbner basis:

``` output
y -> -b**a + a**b**x^2
a**x -> 1 
x**a -> 1
```

after one iteration.

Now, we change the ordering to

    SetMonomialOrder[y,x,b,a];

and run the same `NCMakeGB` as above:

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4] // ColumnForm

which, this time, results in

``` output
b**x^3 -> x**b+x**y**x
x**a -> 1
a**x -> 1
x**b**a -> b**x^2 - x**y
a**b**x^2 -> y+b**a
x**b^2**a -> -x**b**y+b**x^2**b**x^2 - 
    x**y**b**x^2
b**a^2 -> -y**a+a**b**x
b**a**b**a -> -y^2 - b**a**y - y**b**a+
    a**b**x**b**x^2
b**a**b^2**a -> -y**b**y - y**b^2**a - 
    y^2**b**x^2 - b**a**b**y - b**a**y**b**x^2+
    a**b**x**b**x^2**b**x^2
```

which is not a Gröbner basis since the algorithm was interrupted at 4
iterations. Note the presence of the rule

``` output
a**b**x**x -> y+b**a
```

which shows that the ordering is not set up to solve for ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) in terms of
the other variables in the sense that ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) is not on the left hand side
of this rule (but a human could easily solve for ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) using this rule).
Also the algorithm created a number of other relations which involved
![y](https://render.githubusercontent.com/render/math?math=y&mode=inline).

### Graded Lex Ordering: a non-elimination order

To impose graded lexicographic order, say ![a\< b\< x\< y](https://render.githubusercontent.com/render/math?math=a%3C%20b%3C%20x%3C%20y&mode=inline) on ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline),
![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), one types

    SetMonomialOrder[{a,b,x,y}];

This ordering puts high degree monomials high in the ordering. Thus it
tries to decrease the total degree of expressions. A call to

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4,ReduceBasis->True] // ColumnForm

now produces

``` output
a**x -> 1,
x**a -> 1,
b**a^2 -> -y**a+a**b**x,
x**b**a -> b**x^2 - x**y,
a**b**x^2 -> y+b**a,
b**x^3 -> x**b+x**y**x,
a**b**x**b**x^2 -> y^2+b**a**y+y**b**a+b**a**b**a,
b**x^2**b**x^2 -> x**b**y+x**b^2**a+x**y**b**x^2,
a**b**x**b**x**b**x^2 -> y^3+b**a**y^2+y^2**b**a+y**b**a**y+
                         b**a**b**a**y+b**a**y**b**a+
                         y**b**a**b**a+b**a**b**a**b**a,
b**x^2**b**x**b**x^2 -> x**b**y^2+x**b^2**a**y+x**b**y**b**a+
                        x**b^2**a**b**a+x**y**b**x**b**x^2
```

which again fails to be a Gröbner basis and does not eliminate
![y](https://render.githubusercontent.com/render/math?math=y&mode=inline). Instead, it tries to decrease the total degree of expressions
involving ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline).

### Multigraded Lex Ordering: a variety of elimination orders

There are other useful monomial orders which one can use other than
graded lex and lex. Another type of order is what we call multigraded
lex and is a mixture of graded lex and lex order. To impose
multi-graded lexicographic order, say ![a\< b\< x\ll y](https://render.githubusercontent.com/render/math?math=a%3C%20b%3C%20x%5Cll%20y&mode=inline) on ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline)
and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), one types

    SetMonomialOrder[{a,b,x},y];

which separates ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) from the remaining variables. This time, a call to

    NCMakeGB[{-b**x+x**y**a+x**b**a**a, x**a-1, a**x-1},4,ReduceBasis->True] // ColumnForm

yields once again

``` output
y -> -b**a+a**b**x^2
a**x -> 1
x**a -> 1
```

which not only eliminates ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) but is also Gröbner basis, calculated
after one iteration.

For an intuitive idea of why multigraded lex is helpful, we think of
![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), and ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) as corresponding to variables in some engineering
problem which represent quantities which are *known* and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) to be
*unknown*. The fact that ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline) and ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) are in the top level
indicates that we are very interested in solving for ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) in terms of
![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), and ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), but are not willing to solve for, say ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), in terms
of expressions involving ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline).

This situation is so common that we provide the commands `SetKnowns`
and `SetUnknowns`. The above ordering would be obtained after setting

    SetKnowns[a,b,x];
    SetUnknowns[y];

## A Complete Example: the partially prescribed matrix inverse problem

This is a type of problem known as a *matrix completion problem*. This
particular one was suggested by Hugo Woerdeman. We are grateful to
him for discussions.

**Problem:** *Given matrices ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline), and ![d](https://render.githubusercontent.com/render/math?math=d&mode=inline), we wish to
determine under what conditions there exists matrices x, y, z, and w
such that the block matrices*

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20a%20%26%20x%20%5C%5C%20y%20%26%20b%20%5Cend%7Bbmatrix%7D%0A%20%20%5Cqquad%20%0A%20%20%5Cbegin%7Bbmatrix%7D%20w%20%26%20c%20%5C%5C%20d%20%26%20z%20%5Cend%7Bbmatrix%7D)

*are inverses of each other. Also, we wish to find formulas for ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline),
![z](https://render.githubusercontent.com/render/math?math=z&mode=inline), and ![w](https://render.githubusercontent.com/render/math?math=w&mode=inline).*

This problem was solved in a paper by W.W. Barrett, C.R. Johnson,
M. E. Lundquist and H. Woerderman \[BJLW\] where they showed it splits
into several cases depending upon which of ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline) and ![d](https://render.githubusercontent.com/render/math?math=d&mode=inline) are
invertible. In our example, we assume that ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline) and ![d](https://render.githubusercontent.com/render/math?math=d&mode=inline) are
invertible and discover the result which they obtain in this case.

First we set the matrices ![a](https://render.githubusercontent.com/render/math?math=a&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline), and ![d](https://render.githubusercontent.com/render/math?math=d&mode=inline) and their inverses as
*knowns* and ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), ![w](https://render.githubusercontent.com/render/math?math=w&mode=inline), and ![z](https://render.githubusercontent.com/render/math?math=z&mode=inline) as unknowns:

    SetKnowns[a, inv[a], b, inv[b], c, inv[c], d, inv[d]];
    SetUnknowns[{z}, {x, y, w}];

Note that the graded ordering of the unknowns means that we care more
about solving for ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) and ![w](https://render.githubusercontent.com/render/math?math=w&mode=inline) than for ![z](https://render.githubusercontent.com/render/math?math=z&mode=inline).

Then we define the relations we are interested in, which are obtained
after multiplying the two block matrices on both sides and equating to
identity

    A = {{a, x}, {y, b}}
    B = {{w, c}, {d, z}}

    rels = {
      NCDot[A, B] - IdentityMatrix[2],
      NCDot[B, A] - IdentityMatrix[2]
    } // Flatten

We use `Flatten` to reduce the matrix relations to a simple list of
relations. The resulting relations in this case are:

``` output
rels = {-1+a**w+x**d, a**c+x**z, b**d+y**w, -1+b**z+y**c,
        -1+c**y+w**a, c**b+w**x, d**a+z**y, -1+d**x+z**b}
```

After running

    NCMakeGB[rels, 8] // ColumnForm

we obtain the Gröbner basis:

``` output
x -> inv[d]-inv[d]**z**b
y -> inv[c]-b**z**inv[c]
w -> inv[a]**inv[d]**z**b**d
z**b**z -> z+d**a**c
c**b**z**inv[c]**inv[a] -> inv[a]**inv[d]**z**b**d
inv[c]**inv[a]**inv[d]**z**b -> b**z**inv[c]**inv[a]**inv[d]
inv[d]**z**b**d**a -> a**c**b**z**inv[c]
z**b**d**a**c -> d**a**c**b**z
z**inv[c]**inv[a]**inv[d]**inv[b] -> inv[b]**inv[c]**inv[a]**inv[d]**z
z**inv[c]**inv[a]**inv[d]**z -> inv[b]+inv[b]**inv[c]**inv[a]**inv[d]**z
d**a**c**b**z**inv[c] -> z**b**d**a
```

after seven iterations. The first four relations

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%20%20x%20%26%3D%20d%5E%7B-1%7D-d%5E%7B-1%7D%20%5C%2C%20z%20%5C%2C%20b%20%5C%5C%0A%20%20%20%20y%20%26%3D%20c%5E%7B-1%7D-b%20%5C%2C%20z%20%5C%2C%20c%5E%7B-1%7D%20%5C%5C%0A%20%20%20%20w%20%26%3D%20a%5E%7B-1%7D%20%5C%2C%20d%5E%7B-1%7D%20%20%5C%2C%20z%20%5C%2C%20b%20%5C%2C%20d%20%5C%5C%0A%20%20%20%20z%20%5C%2C%20b%20%5C%2C%20z%20%26%3D%20z%20%2B%20d%20%5C%2C%20a%20%5C%2C%20c%0A%5Cend%7Baligned%7D)

are the solutions we are looking for, which states that one can find
![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline), ![z](https://render.githubusercontent.com/render/math?math=z&mode=inline), and ![w](https://render.githubusercontent.com/render/math?math=w&mode=inline) such that the matrices above are inverses of
each other if and only if ![z \\ b \\ z = z + d \\ a \\ c](https://render.githubusercontent.com/render/math?math=z%20%5C%2C%20b%20%5C%2C%20z%20%3D%20z%20%2B%20d%20%5C%2C%20a%20%5C%2C%20c&mode=inline). The first
three relations gives formulas for ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline), ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) and ![w](https://render.githubusercontent.com/render/math?math=w&mode=inline) in terms of ![z](https://render.githubusercontent.com/render/math?math=z&mode=inline).

A variety of scenarios can be quickly investigated under different
assumptions. For example, say that ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline) is not invertible. Is it still
possible to solve the problem? One solution is obtained with the
ordering implied by

    SetKnowns[a, inv[a], b, inv[b], c, d, inv[d]];
    SetUnknowns[{y}, {z, w, x}];

In this case

    NCMakeGB[rels, 8] // ColumnForm

produces the Gröbner basis:

``` output
z -> inv[b]-inv[b]**y**c
w -> inv[a]-c**y**inv[a]
x -> a**c**y**inv[a]**inv[d]
y**c**y -> y+b**d**a
c**y**inv[a]**inv[d]**inv[b] -> inv[a]**inv[d]**inv[b]**y**c
d**a**c**y**inv[a] -> inv[b]**y**c**b**d
inv[d]**inv[b]**y**c**b -> a**c**y**inv[a]**inv[d]
y**c**b**d**a -> b**d**a**c**y
y**inv[a]**inv[d]**inv[b]**y**c -> 1+y**inv[a]**inv[d]**inv[b]
```

after five iterations. Once again, the first four relations

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%20%20z%20%26%3D%20b%5E%7B-1%7D-b%5E%7B-1%7D%20%5C%2C%20y%20%5C%2C%20c%20%5C%5C%0A%20%20%20%20w%20%26%3D%20a%5E%7B-1%7D-c%20%5C%2C%20y%20%5C%2C%20a%5E%7B-1%7D%20%5C%5C%0A%20%20%20%20x%20%26%3D%20a%20%5C%2C%20c%20%5C%2C%20y%20%5C%2C%20a%5E%7B-1%7D%20%5C%2C%20d%5E%7B-1%7D%20%5C%5C%0A%20%20%20%20y%20%5C%2C%20c%20%5C%2C%20y%20%26%3D%20y%2Bb%20%5C%2C%20d%20%5C%2C%20a%0A%5Cend%7Baligned%7D)

provide formulas, this time for ![z](https://render.githubusercontent.com/render/math?math=z&mode=inline), ![w](https://render.githubusercontent.com/render/math?math=w&mode=inline), and ![z](https://render.githubusercontent.com/render/math?math=z&mode=inline) in terms of ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline)
satisfying ![y \\ c \\ y = y+b \\ d \\ a](https://render.githubusercontent.com/render/math?math=y%20%5C%2C%20c%20%5C%2C%20y%20%3D%20y%2Bb%20%5C%2C%20d%20%5C%2C%20a&mode=inline). Note that these formulas do
not involve ![c^{-1}](https://render.githubusercontent.com/render/math?math=c%5E%7B-1%7D&mode=inline) since ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline) is no longer assumed invertible.

## Advanced Processing of Rational Expressions

Consider once again the task of simplifying the nc rational expression

    expr = inv[1-x-y**inv[1-x]**y] - 1/2 (inv[1-x+y]+inv[1-x-y])

considered before in [Simplifying Rational
Expressions](#simplifying-rational-expressions). We will use this
expression to illustrate how nc rational expressions can be
manipulated at a lower level, giving advanced users more control of
the conversion process to and from the internal [NCPoly](#ncpoly-1)
representation.

The key functionality is provided by the functions
[NCMonomialOrder](#ncmonomialorder) and
[NCRationalToNCPoly](#ncrationaltoncpoly). [NCMonomialOrder](#ncmonomialorder)
provides the same functionality as
[SetMonomialOrder](#setmonomialorder), but instead of setting the
ordering globally, it returns an array representing the ordering. For
example,

    order = NCMonomialOrder[x, y]

produces the array

    {{x},{y}}

which represents the ordering ![x \ll y](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y&mode=inline).

With a (preliminary) ordering in hand one can invoke
[NCRationalToNCPoly](#ncrationaltoncpoly) as in

    {rels, vars, rules, labels} = NCRationalToNCPoly[expr, order];

This function produces four lists as outputs:

The first, `rels`, is a list of `NCPoly` objects representing the
original expression and some additional relations that were
automatically generated. We will inspect `rels` later.

The second, `vars`, is a list of variables that represent the ordering
used in the construction of the polynomials in `rel`. In this example,

``` output
vars = {{x}, {y}, {rat135, rat136, rat137, rat138}} 
```

which corresponds to the ordering

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%5Cll%20rat135%20%3C%20rat136%20%3C%20rat137%20%3C%20rat138)

In this case, the variables `rat135`, `rat136`, `rat137`, `rat138`
were automatically created and assigned an ordering by
`NCRationalToNCPoly`.

> It is unlikely that your variables will be assigned the same
> suffixes `135` through `138`. Those suffixes were chosen by
> Mathematica to make these variables unique in the global context,
> and hence depend on a multitude of factors that can only be
> determined at the time of execution.

As with [SetMonomialOrder](#setmonomialorder) and
[NCMakeGB](#ncmakegb), rational terms can be explicitly added to the
ordering for finer control. For example, calling `NCRationalToNCPoly`
with

``` output
order = NCMonomialOrder[x,y,inv[1-x],{inv[1-x+y],inv[1-x-y]}];
```

would have produced

``` output
vars = {{x}, {y}, {rat135}, {rat136, rat137}, {rat138}} 
```

which corresponds to the ordering

![inline equation](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%5Cll%20rat135%20%5Cll%20rat136%20%3C%20rat137%20%5Cll%20rat138)

The third is a list of rules relating the new variables with
rational terms appearing in the original expression `expr`. In this
example

``` output
rules = {rat135 -> inv[1-x], rat136 -> inv[1-x-y],
         rat137 -> inv[1-x+y], rat138 -> inv[1-x-y**rat135**y]}
```

Finally, the fourth is a list of labels that is used for printing or
displaying

``` output
labels = {{x}, {y}, {inv[1-x], inv[1-x-y], inv[1-x+y],
inv[1-x-y**inv[1-x]**y]}} 
```

as used by `NCMakeGB` and `NCPolyDisplay`.

The relations in `rels` can be visualized by using `NCPolyToNC`. For
example,

    NCPolyToNC[#, vars] & /@ rels // ColumnForm

produces

``` output
rat138-rat136/2-rat137/2 
rat135-rat135**x-1
rat135-x**rat135-1
rat136-rat136**x-rat136**y-1
rat136-x**rat136-y**rat136-1
rat137-rat137**x+rat137**y-1
rat137-x**rat137+y**rat137-1
rat138-rat138**x-rat138**y**rat135**y-1
rat138-x**rat138-y**rat135**y**rat138-1
```

The first entry is simply the original `expr` in which every rational
expression has been substituted by a new variable. The same could be
obtained by applying reverse `rules` and applying it repeatedly

    NCReplaceRepeated[expr, Reverse /@ rules]

The remaining entries are polynomials encoding the rational
expressions that have been substituted by new variables. For example,
the first two additional relations,

``` output
rat135-rat135**x-1
rat135-x**rat135-1
```

correspond to the assertion that `rat153 == inv[1-x]`, and so on.

Equipped with a set of polynomial relations encoding the rational
expression `expr` one can calculated a Gröebner basis by calling the
low-level implementation [NCPolyGroebner](#ncpolygroebner-1). In this
example, calling

    {basis, tree} = NCPolyGroebner[Rest[rels], 4, Labels -> labels];

produces the output

``` output
* * * * * * * * * * * * * * * *
* * *   NCPolyGroebner    * * *
* * * * * * * * * * * * * * * *
* Monomial order: x<<y<<inv[1-x]<inv[1-x-y]<inv[1-x+y]<inv[1-x-y**inv[1-x]**y]
* Reduce and normalize initial set
> Initial set could not be reduced
* Computing initial set of obstructions
> MAJOR Iteration 1, 10 polys in the basis, 12 obstructions
> MAJOR Iteration 2, 10 polys in the basis, 6 obstructions
>  Found Groebner basis with 9 polynomials
* * * * * * * * * * * * * * * * 
```

Note the use of `labels` to pretty print the monomial ordering. The
resulting basis can be visualized once again using the `labels`

    NCPolyToNC[#, labels] & /@ basis // ColumnForm

which produces

``` output
1-inv[1-x]+inv[1-x]**x
1-inv[1-x]+x**inv[1-x]
1-inv[1-x-y]+inv[1-x-y]**x+inv[1-x-y]**y
1-inv[1-x-y]+x**inv[1-x-y]+y**inv[1-x-y]
-1+inv[1-x+y]-inv[1-x+y]**x+inv[1-x+y]**y
-1+inv[1-x+y]-x**inv[1-x+y]+y**inv[1-x+y]
1/2 inv[1-x-y]+1/2 inv[1-x+y]-inv[1-x+y]**inv[1-x-y]+inv[1-x+y]**x**inv[1-x-y]
1/2 inv[1-x-y]+1/2 inv[1-x+y]-inv[1-x-y]**inv[1-x+y]+inv[1-x-y]**x**inv[1-x+y]}
-1/2 inv[1-x-y]-1/2 inv[1-x+y]+inv[1-x-y**inv[1-x]**y]
```

The original expression `expr` can then be *reduced* by the above
basis by calling

    NCPolyReduce[rels[[1]], basis]

which produces `0`, as expected.

The above process is conveniently automated by [NCMakeGB](#ncmakegb),
but advanced users might still want to take advantage of the increased
speed of directly processing `NCPoly`s by manually performing the
conversion from a rational statement to a polynomial statement. See
the detailed documentation of the package [NCPoly](#ncpoly-1) for more
details.

# Semidefinite Programming

If you want a living version of this chapter just run the notebook
`NC/DEMOS/4_SemidefiniteProgramming.nb`.

There are two different packages for solving semidefinite programs:

- [`SDP`](#sdp) provides a template algorithm that can be
  customized to solve semidefinite programs with special
  structure. Users can provide their own functions to evaluate the
  primal and dual constraints and the associated Newton system. A
  built in solver along conventional lines, working on vector
  variables, is provided by default. It does not require NCAlgebra to
  run.

- [`NCSDP`](#ncsdp) coordinates with NCAlgebra to handle matrix
  variables, allowing constraints, etc, to be entered directly as
  noncommutative expressions.

## Semidefinite Programs in Matrix Variables

The package [NCSDP](#ncsdp) allows the symbolic manipulation
and numeric solution of semidefinite programs.

After loading NCAlgebra, the package NCSDP must be loaded using:

    << NCSDP`

Semidefinite programs consist of symbolic noncommutative expressions
representing inequalities and a list of rules for data
replacement. For example the semidefinite program:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%5Cmin_Y%20%5Cquad%20%26%20%3CI%2CY%3E%20%5C%5C%0A%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20Y%20%2B%20Y%20A%5ET%20%2B%20I%20%5Cpreceq%200%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%26%20Y%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

can be solved by defining the noncommutative expressions

    SNC[a, y];
    obj = {-1};
    ineqs = {a ** y + y ** tp[a] + 1, -y};

The inequalities are stored in the list `ineqs` in the form of
noncommutative linear polyonomials in the variable `y` and the
objective function constains the symbolic coefficients of the inner
product, in this case `-1`. The reason for the negative signs in the
objective as well as in the second inequality is that semidefinite
programs are expected to be cast in the following *canonical form*:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%20%0A%20%20%5Cmax_y%20%5Cquad%20%26%20%3Cb%2Cy%3E%20%5C%5C%20%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20f%28y%29%20%5Cpreceq%200%20%0A%5Cend%7Baligned%7D)

</div>

or, equivalently:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%20%0A%20%20%5Cmax_y%20%5Cquad%20%26%20%3Cb%2Cy%3E%20%5C%5C%20%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20f%28y%29%20%2B%20s%20%3D%200%2C%20%5Cquad%20s%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

Semidefinite programs can be visualized using
[`NCSDPForm`](#ncsdpform) as in:

    vars = {y};
    NCSDPForm[ineqs, vars, obj]

The above commands produce a formatted output similar to the ones
shown above.

In order to obtaining a numerical solution for an instance of the
above semidefinite program one must provide a list of rules for data
substitution. For example:

    A = {{0, 1}, {-1, -2}};
    data = {a -> A};

Equipped with the above list of rules representing a problem instance
one can load [`SDPSylvester`](#sdpsylvester) and use `NCSDP` to create
a problem instance as follows:

    {abc, rules} = NCSDP[ineqs, vars, obj, data];

The resulting `abc` and `rules` objects are used for calculating the
numerical solution using [`SDPSolve`](#sdpsolve). The command:

    << SDPSylvester`
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

The output variables `Y` and `S` are the *primal* solutions and `X` is
the *dual* solution.

A symbolic dual problem can be calculated easily using
[`NCSDPDual`](#ncsdpdual):

    {dIneqs, dVars, dObj} = NCSDPDual[ineqs, vars, obj];

The dual program for the example problem above is:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%20%0A%20%20%5Cmax_x%20%5Cquad%20%26%20%3Cc%2Cx%3E%20%5C%5C%20%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20f%5E%2A%28x%29%20%2B%20b%20%3D%200%2C%20%5Cquad%20x%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

In the case of the above problem the dual program is

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%5Cmax_%7BX_1%2C%20X_2%7D%20%5Cquad%20%26%20%3CI%2CX_1%3E%20%5C%5C%0A%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%5ET%20X_1%20%2B%20X_1%20A%20-X_2%20-%20I%20%3D%200%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%26%20X_1%20%5Csucceq%200%2C%20%5C%5C%0A%20%20%20%20%20%20%20%20%26%20X_2%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

which can be visualized using [`NCSDPDualForm`](#ncsdpdualform) using:

    NCSDPDualForm[dIneqs, dVars, dObj]

## Semidefinite Programs in Vector Variables

The package [SDP](#sdp) provides a crude and not very efficient
way to define and solve semidefinite programs in standard form, that
is vectorized. You do not need to load `NCAlgebra` if you just want to
use the semidefinite program solver. But you still need to load `NC`
as in:

    << NC`
    << SDP`

Semidefinite programs are optimization problems of the form:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20b%5ET%20y%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20y%20%2B%20S%20%3D%20c%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

where ![S](https://render.githubusercontent.com/render/math?math=S&mode=inline) is a symmetric positive semidefinite matrix and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) is a
vector of decision variables.

A user can input the problem data, the triplet ![(A, b, c)](https://render.githubusercontent.com/render/math?math=%28A%2C%20b%2C%20c%29&mode=inline), or use the
following convenient methods for producing data in the proper format.

For example, problems can be stated as:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%20%0A%20%20%5Cmin_y%20%5Cquad%20%26%20f%28y%29%2C%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20G%28y%29%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

where ![f(y)](https://render.githubusercontent.com/render/math?math=f%28y%29&mode=inline) and ![G(y)](https://render.githubusercontent.com/render/math?math=G%28y%29&mode=inline) are affine functions of the vector
of variables ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline).

Here is a simple example:

    y = {y0, y1, y2};
    f = y2;
    G = {y0 - 2, {{y1, y0}, {y0, 1}}, {{y2, y1}, {y1, 1}}};

The list of constraints in `G` is to be interpreted as:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%20%0A%20%20y_0%20-%202%20%5Cgeq%200%2C%20%5C%5C%0A%20%20%5Cbegin%7Bbmatrix%7D%20y_1%20%26%20y_0%20%5C%5C%20y_0%20%26%201%20%5Cend%7Bbmatrix%7D%20%5Csucceq%200%2C%20%5C%5C%0A%20%20%5Cbegin%7Bbmatrix%7D%20y_2%20%26%20y_1%20%5C%5C%20y_1%20%26%201%20%5Cend%7Bbmatrix%7D%20%5Csucceq%200.%0A%5Cend%7Baligned%7D)

</div>

The function [`SDPMatrices`](#sdpmatrices) convert the above symbolic
problem into numerical data that can be used to solve an SDP.

    abc = SDPMatrices[f, G, y]

All required data, that is ![A](https://render.githubusercontent.com/render/math?math=A&mode=inline), ![b](https://render.githubusercontent.com/render/math?math=b&mode=inline), and ![c](https://render.githubusercontent.com/render/math?math=c&mode=inline), is stored in the
variable `abc` as Mathematica’s sparse matrices. Their contents can be
revealed using the Mathematica command `Normal`.

    Normal[abc]

The resulting SDP is solved using [`SDPSolve`](#sdpsolve):

    {Y, X, S, flags} = SDPSolve[abc];

The variables `Y` and `S` are the *primal* solutions and `X` is the
*dual* solution. Detailed information on the computed solution is
found in the variable `flags`.

The package `SDP` is built so as to be easily overloaded with more
efficient or more structure functions. See for example
[SDPFlat](#sdpflat) and [SDPSylvester](#sdpsylvester).

# Pretty Output with Notebooks and TeX 

If you want a living version of this chapter just run the notebook
`NC/DEMOS/5_PrettyOutput.nb`.

`NCAlgebra` comes with several utilities for beautifying expressions
which are output. [`NCTeXForm`](#nctexform) converts NC expressions
into LaTeX. [`NCTeX`](#nctex) goes a step further and
compiles the results expression in LaTeX and produces a PDF that can
be embedded in notebooks of used on its own.

## Pretty Output

In a Mathematica notebook session the package [NCOutput](#ncoutput)
can be used to control how nc expressions are displayed. `NCOutput`
does not alter the internal representation of nc expressions, just the
way they are displayed on the screen.

The function [NCSetOutput](#ncsetoutput) can be used to set the
display options. For example:

    NCSetOutput[tp -> False, inv -> True];

makes the expression

    expr = inv[tp[a] + b]

be displayed as

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%28%5Cmathrm%7Btp%5Ba%5D%7D%20%2B%20%5Cmathrm%7Bb%7D%29%5E%7B-1%7D)

</div>

Conversely

    NCSetOutput[tp -> True, inv -> False];

makes `expr` be displayed as

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Binv%7D%5Cmathrm%7B%5B%7D%5Cmathrm%7Ba%7D%5ET%20%2B%20%5Cmathrm%7Bb%7D%5Cmathrm%7B%5D%7D)

</div>

The default settings are

    NCSetOutput[tp -> True, inv -> True];

which makes `expr` be displayed as

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%28%5Cmathrm%7Ba%7D%5E%5Cmathrm%7BT%7D%20%2B%20%5Cmathrm%7Bb%7D%29%5E%7B-1%7D)

</div>

The complete set of options and their default values are:

- `NonCommutativeMultiply` (`False`): If `True` `x**y` is displayed as ‘![\mathrm{x} \bullet \mathrm{y}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%20%5Cbullet%20%5Cmathrm%7By%7D&mode=inline)’;
- `tp` (`True`): If `True` `tp[x]` is displayed as ‘![\mathrm{x}^\mathrm{T}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%5Cmathrm%7BT%7D&mode=inline)’;
- `inv` (`True`): If `True` `inv[x]` is displayed as ‘![\mathrm{x}^{-1}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%7B-1%7D&mode=inline)’;
- `aj` (`True`): If `True` `aj[x]` is displayed as ‘![\mathrm{x}^\*](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%2A&mode=inline)’;
- `co` (`True`): If `True` `co[x]` is displayed as ‘![\bar{\mathrm{x}}](https://render.githubusercontent.com/render/math?math=%5Cbar%7B%5Cmathrm%7Bx%7D%7D&mode=inline)’;
- `rt` (`True`): If `True` `rt[x]` is displayed as ‘![\mathrm{x}^{1/2}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%7B1/2%7D&mode=inline)’.

The special symbol `All` can be used to set all options to `True` or
`False`, as in

    NCSetOutput[All -> True];

## Using NCTeX

You can load NCTeX using the following command

    << NC` 
    << NCTeX`

`NCTeX` does not need `NCAlgebra` to work. You may want to use it even
when not using NCAlgebra. It uses [`NCRun`](#ncrun), which is a
replacement for Mathematica’s Run command to run `pdflatex`, `latex`,
`divps`, etc.

**WARNING:** Mathematica does not come with LaTeX, dvips, etc. The
package `NCTeX` does not install these programs but rather assumes
that they have been previously installed and are available at the
user’s standard shell. Use the `Verbose` [option](#nctex-options) to
troubleshoot installation problems.

With `NCTeX` loaded you simply type `NCTeX[expr]` and your expression
will be converted to a PDF image which, by default, appears in your
notebook after being processed by `LaTeX`. See
[options](#nctex-options) for information on how to change this
behavior to display the PDF on a separate window.

For example:

    expr = 1 + Sin[x + (y - z)/Sqrt[2]];
    NCTeX[expr]

produces

![1 + \sin \left ( x + \frac{y - z}{\sqrt{2}} \right )](https://render.githubusercontent.com/render/math?math=1%20%2B%20%5Csin%20%5Cleft%20%28%20x%20%2B%20%5Cfrac%7By%20-%20z%7D%7B%5Csqrt%7B2%7D%7D%20%5Cright%20%29&mode=inline)

If `NCAlgebra` is not loaded then `NCTeX` uses the built in
`TeXForm` to produce the LaTeX expressions. If `NCAlgebra` is loaded,
`NCTeXForm` is used. See [NCTeXForm](#nctexform-1) for details.

Here is another example:

    expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}};
    NCTeX[expr]

that produces

![\left( \begin{array}{cc} \sin \left(x+\frac{y-z}{\sqrt{2}}\right)+1 & \frac{x}{y} \\ z & \sqrt{5} n \\ \end{array} \right)](https://render.githubusercontent.com/render/math?math=%5Cleft%28%20%5Cbegin%7Barray%7D%7Bcc%7D%20%5Csin%20%5Cleft%28x%2B%5Cfrac%7By-z%7D%7B%5Csqrt%7B2%7D%7D%5Cright%29%2B1%20%26%20%5Cfrac%7Bx%7D%7By%7D%20%5C%5C%20z%20%26%20%5Csqrt%7B5%7D%20n%20%5C%5C%20%5Cend%7Barray%7D%20%5Cright%29&mode=inline)

In some cases Mathematica will have difficulty displaying certain PDF
files. When this happens `NCTeX` will span a PDF viewer so that you
can look at the formula. If your PDF viewer does not pop up
automatically you can force it by passing the following option to
`NCTeX`:

    expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}};
    NCTeX[exp, DisplayPDF -> True]

Here is another example were the current version of Mathematica fails
to import the PDF:

    expr = Table[x^i y^(-j) , {i, 0, 10}, {j, 0, 30}];
    NCTeX[expr, DisplayPDF -> True]

You can also suppress Mathematica from importing the PDF altogether as
well. This and other options are covered in detail in the next
section.

### NCTeX Options

The following command:

    expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}};
    NCTeX[exp, DisplayPDF -> True, ImportPDF -> False]

uses `DisplayPDF -> True` to ensure that the PDF viewer is called and
`ImportPDF -> False` to prevent Mathematica from displaying the
formula inline. In other words, it displays the formula in the PDF
viewer without trying to import the PDF into Mathematica. The default
values for these options when using the Mathematica notebook interface
are:

1.  `DisplayPDF` (`False`)
2.  `ImportPDF` (`True`)

When `NCTeX` is invoked using the command line interpreter version of
Mathematica the defaults are:

1.  `DisplayPDF` (`False`)
2.  `ImportPDF` (`True`)

Other useful options and their default options are:

1.  `Verbose` (`False`),
2.  `BreakEquations` (`True`)
3.  `TeXProcessor` (`NCTeXForm`)

Set `BreakEquations -> True` to use the LaTeX package `beqn` to
produce nice displays of long equations. Try the following
example:

    expr = Series[Exp[x], {x, 0, 20}]
    NCTeX[expr]

Use `TexProcessor` to select your own `TeX` converter. If `NCAlgebra`
is loaded then `NCTeXForm` is the default. Otherwise Mathematica’s
`TeXForm` is used.

If `Verbose -> True` you can see a detailed display of what is going
on behing the scenes. This is very useful for debugging. For example,
try:

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

Locate the files with extension .err as indicated by the verbose run
of NCTeX to diagnose errors.

The remaining options:

1.  `PDFViewer` (`"open"`),
2.  `LaTeXCommand` (`"latex"`)
3.  `PDFLaTeXCommand` (`Null`)
4.  `DVIPSCommand` (`"dvips"`)
5.  `PS2PDFCommand` (`"epstopdf"`)

let you specify the names and, when appropriate, the path, of the
corresponding programs to be used by `NCTeX`. Alternatively, you can
also directly implement custom versions of

    NCRunDVIPS
    NCRunLaTeX
    NCRunPDFLaTeX
    NCRunPDFViewer
    NCRunPS2PDF

Those commands are invoked using `NCRun`. Look at the documentation
for the package [NCRun](#ncrun-1) for more details.

## Using NCTeXForm

[`NCTeXForm`](#nctexform) is a replacement for Mathematica’s
`TeXForm` which adds definitions allowing it to handle noncommutative
expressions. It works just as `TeXForm`. `NCTeXForm` is automatically
loaded with `NCAlgebra` and is the default TeX processor for
`NCTeX`.

Here is an example:

    SetNonCommutative[a, b, c, x, y];
    exp = a ** x ** tp[b] - inv[c ** inv[a + b ** c] ** tp[y] + d]
    NCTeXForm[exp]

produces

    a.x.{b}^T-{\left(d+c.{\left(a+b.c\right)}^{-1}.{y}^T\right)}^{-1}

Note that the LaTeX output contains special code so that the
expression looks neat on the screen. You can see the result using
`NCTeX` to convert the expression to PDF. Try

    SetOptions[NCTeX, TeXProcessor -> NCTeXForm];
    NCTeX[exp]

to produce

![a.x.{b}^T-{\left(d+c.{\left (a+b.c\right)}^{-1}.{y}^T\right )}^{-1}](https://render.githubusercontent.com/render/math?math=a.x.%7Bb%7D%5ET-%7B%5Cleft%28d%2Bc.%7B%5Cleft%20%28a%2Bb.c%5Cright%29%7D%5E%7B-1%7D.%7By%7D%5ET%5Cright%20%29%7D%5E%7B-1%7D&mode=inline)

`NCTeX` represents noncommutative products with a dot (`.`) in order
to distinguish it from its commutative cousin. We can see the
difference in an expression that has both commutative and
noncommutative products:

    exp = 2 a ** b - 3 c ** d
    NCTeX[exp]

produces

![2 \left(a.b\right) - 3 (c.d)](https://render.githubusercontent.com/render/math?math=2%20%5Cleft%28a.b%5Cright%29%20-%203%20%28c.d%29&mode=inline)

NCTeXForm handles lists and matrices as well. Here is a list:

    exp = {x, tp[x], x + y, x + tp[y], x + inv[y], x ** x}
    NCTeX[exp]

and its output:

![\\ x, {x}^T, x+y, x+{y}^T, x+{y}^{-1}, x.x \\](https://render.githubusercontent.com/render/math?math=%5C%7B%20x%2C%20%7Bx%7D%5ET%2C%20x%2By%2C%20x%2B%7By%7D%5ET%2C%20x%2B%7By%7D%5E%7B-1%7D%2C%20x.x%20%5C%7D&mode=inline)

and here is a matrix example:

    exp = {{x, y}, {y, z}}
    NCTeX[exp]

and its output:

![\begin{bmatrix} x & y \\ y & z \end{bmatrix}](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%20x%20%26%20y%20%5C%5C%20y%20%26%20z%20%5Cend%7Bbmatrix%7D&mode=inline)

Here are some more examples:

    exp = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}}
    NCTeX[exp]

produces

![\begin{bmatrix} 1+\operatorname{sin}{\left (x+\frac{1}{\sqrt{2}} \left (y-z\right )\right )} & x {y}^{-1} \\ z & \sqrt{5} n \end{bmatrix}](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Bbmatrix%7D%201%2B%5Coperatorname%7Bsin%7D%7B%5Cleft%20%28x%2B%5Cfrac%7B1%7D%7B%5Csqrt%7B2%7D%7D%20%5Cleft%20%28y-z%5Cright%20%29%5Cright%20%29%7D%20%26%20x%20%7By%7D%5E%7B-1%7D%20%5C%5C%20z%20%26%20%5Csqrt%7B5%7D%20n%20%5Cend%7Bbmatrix%7D&mode=inline)

    exp = {inv[x + y], inv[x + inv[y]]}
    NCTeX[exp]

produces:

![\\ {\left (x+y\right )}^{-1}, {\left (x+{y}^{-1}\right )}^{-1} \\](https://render.githubusercontent.com/render/math?math=%5C%7B%20%7B%5Cleft%20%28x%2By%5Cright%20%29%7D%5E%7B-1%7D%2C%20%7B%5Cleft%20%28x%2B%7By%7D%5E%7B-1%7D%5Cright%20%29%7D%5E%7B-1%7D%20%5C%7D&mode=inline)

    exp = {Sin[x], x y, Sin[x] y, Sin[x + y], Cos[gamma], 
           Sin[alpha] tp[x] ** (y - tp[y]), (x + tp[x]) (y ** z), -tp[y], 1/2, 
           Sqrt[2] x ** y}
    NCTeX[exp]

produces:

![\\ \operatorname{sin}{x}, x y, y \operatorname{sin}{x}, \operatorname{sin}{\left (x+y\right )}, \operatorname{cos}{\gamma}, \left({x}^T.\left (y-{y}^T\right )\right ) \operatorname{sin}{\alpha}, y z \left (x+{x}^T\right ), -{y}^T, \frac{1}{2}, \sqrt{2} \left(x.y\right ) \\](https://render.githubusercontent.com/render/math?math=%5C%7B%20%5Coperatorname%7Bsin%7D%7Bx%7D%2C%20x%20y%2C%20y%20%5Coperatorname%7Bsin%7D%7Bx%7D%2C%20%5Coperatorname%7Bsin%7D%7B%5Cleft%20%28x%2By%5Cright%20%29%7D%2C%20%5Coperatorname%7Bcos%7D%7B%5Cgamma%7D%2C%20%5Cleft%28%7Bx%7D%5ET.%5Cleft%20%28y-%7By%7D%5ET%5Cright%20%29%5Cright%20%29%20%5Coperatorname%7Bsin%7D%7B%5Calpha%7D%2C%20y%20z%20%5Cleft%20%28x%2B%7Bx%7D%5ET%5Cright%20%29%2C%20-%7By%7D%5ET%2C%20%5Cfrac%7B1%7D%7B2%7D%2C%20%5Csqrt%7B2%7D%20%5Cleft%28x.y%5Cright%20%29%20%5C%7D&mode=inline)

    exp = inv[x + tp[inv[y]]]
    NCTeX[exp]

produces:

![{\left (x+{{y}^T}^{-1}\right )}^{-1}](https://render.githubusercontent.com/render/math?math=%7B%5Cleft%20%28x%2B%7B%7By%7D%5ET%7D%5E%7B-1%7D%5Cright%20%29%7D%5E%7B-1%7D&mode=inline)

`NCTeXForm` does not know as many functions as `TeXForm`. In some
cases `TeXForm` will produce better results. Compare:

    exp = BesselJ[2, x]
    NCTeX[exp, TeXProcessor -> NCTeXForm]

output:

![\operatorname{BesselJ}\left (2, x\right )](https://render.githubusercontent.com/render/math?math=%5Coperatorname%7BBesselJ%7D%5Cleft%20%282%2C%20x%5Cright%20%29&mode=inline)

with

    NCTeX[exp, TeXProcessor -> TeXForm]

output:

![J_2(x)](https://render.githubusercontent.com/render/math?math=J_2%28x%29&mode=inline)

It should be easy to customize `NCTeXForm` though. Just overload
`NCTeXForm`. In this example:

    NCTeXForm[BesselJ[x_, y_]] := Format[BesselJ[x, y], TeXForm]

makes

    NCTeX[exp, TeXProcessor -> NCTeXForm]

produce

![J_2(x)](https://render.githubusercontent.com/render/math?math=J_2%28x%29&mode=inline)

# Reference Manual

The following chapters and sections describes packages inside
`NCAlgebra`. Detailed instructions for manual installation are also
provided in the section [Manual Installation](#manual-installation).

Packages are automatically loaded unless otherwise noted.

## Manual Installation

Manual installation is no longer necessary nor advisable. As an
alternative to manual installation, consider installing NCAlgebra via
our paclet distribution, as discussed in section [Installing
NCAlgebra](#installing-ncalgebra).

For those who do not use paclets, you can download NCAlgebra in one of
the following ways.

### Via `git clone`

You can clone the repository using git:

    git clone https://github.com/NCAlgebra/NC

This will create a directory `NC` which contains all files neeeded to
run NCAlgebra in any platform.

Cloning allows you to easily upgrade and switch between the various
available releases. If you want to try the latest *experimental*
version switch to branch *devel* using:

    git checkout devel

If you’re happy with the latest stable release you do not need to
do anything.

### From the github download button

After you downloaded a zip file from github use your favorite zip
utility to unpack the file `NC-master.zip` or `NC-devel.zip` on your
favorite location.

**IMPORTANT:** Rename the top directory `NC`!

### From one of our releases

Releases are stable snapshots that you can find at

https://github.com/NCAlgebra/NC/releases

**IMPORTANT:** Rename the top directory `NC`!

Earlier releases can be downloaded from:

www.math.ucsd.edu/~ncalg

Releases in github are also tagged so you can easily switch from
version to version using git.

### Post-download installation

All that is needed for NCAlgebra to run is that its top directory, the
`NC` directory, be on Mathematica’s search path.

If you are on a unix
flavored machine (Solaris, Linux, Mac OSX) then unpacking or cloning
in your home directory (`~`) is all you need to do.

Otherwise, you may need to add the installation directory to
Mathematica’s search path.

**If you are experienced with Mathematica:**

Edit the main *Mathematica* `init.m` file (not the one inside the `NC` directory) to add the name of the directory which contains the `NC` folder to the Mathematica variable `$Path`, as in:

    AppendTo[$Path,"**YOUR_INSTALLATION_DIRECTORY**"];

You can locate your user `init.m` file by typing:

    FileNameJoin[{$UserBaseDirectory, "Kernel", "init.m"}]

in Mathematica.

## NC

**NC** is a meta package that enables the functionality of the
*NCAlgebra suite* of non-commutative algebra packages for Mathematica.

> If you installed the paclet version of NCAlgebra it is not necessary
> to load the context `NC` before loading other `NCAlgebra`
> packages.
>
> Loading the context `NC` in the paclet version is however still
> supported for backward compatibility. It does nothing more than
> posting the message:
>
>     NC::Directory: You are using a paclet version of NCAlgebra.

The package can be loaded using `Get`, as in

    << NC`

or `Needs`, as in

    Needs["NC`"]

Once `NC` is loaded you will see a message like

    NC::Directory: You are using the version of NCAlgebra which is found in: "/your_home_directory/NC".

or

    NC::Directory: You are using a paclet version of NCAlgebra.

if you installed from our paclet distribution.

You can then proceed to load any other package from the *NCAlgebra suite*.

For example you can load the package `NCAlgebra` using

    << NCAlgebra`

See section [NCAlgebra](#ncalgebra) and
[NCOptions](#ncoptions) for more options and details available
while loading `NCAlgebra`.

The `NC::Directory` message can be suppressed by using standard Mathematica message control functions. For example,

    Off[NC`NC::Directory]
    << NC`

or

    Quiet[<< NC`, NC`NC::Directory]

will load `NC` quietly. Note that you have to refer to the message by
its fully qualified name `` NC`NC::Directory `` because the context
`NC` is only available after loading the package.

## NCAlgebra

**NCAlgebra** is the main package of the *NCAlgebra suite* of
non-commutative algebra packages for Mathematica.

The package can be loaded using `Get`, as in

    << NCAlgebra`

or `Needs`, as in

    Needs["NCAlgebra`"]

If the option `SmallCapSymbolsNonCommutative` is `True` then
`NCAlgebra` will set all global single letter small cap symbols as
noncommutative. If that is not desired, simply set
`SmallCapSymbolsNonCommutative` to `False` before loading `NCAlgebra`,
as in

    << NCOptions`
    SetOptions[NCOptions, SmallCapSymbolsNonCommutative -> False];
    << NCAlgebra`

See [NCOptions](#ncoptions) for details.

When loading `NCAlgebra`, a message will be issued warning users
whether any letters have been set as noncommutative upon
loading. Those messages are documented
[here](#messages). Users can use Mathematica’s `Quiet` and
`Off` if they do not want these messages to display. For example,

    Off[NCAlgebra`NCAlgebra::SmallCapSymbolsNonCommutative]
    << NCAlgebra`

or

    << NCOptions`
    SetOptions[NCOptions, SmallCapSymbolsNonCommutative -> False];
    Off[NCAlgebra`NCAlgebra::NoSymbolsNonCommutative]
    << NCAlgebra`

will load `NCAlgebra` without issuing a symbol assignment message.

Upon loading `NCAlgebra` for the first time, a large banner will be
shown. If you do not want this banner to be displayed set the
option [`ShowBanner`](#ncoptions) to `False` before loading, as in

    << NCOptions`
    SetOptions[NCOptions, ShowBanner -> False];
    << NCAlgebra`

For example, the following commands will perform a completly quiet
loading of `NC` *and* `NCAlgebra`:

    Quiet[<< NC`, NC`NC::Directory];
    << NCOptions`
    SetOptions[NCOptions, ShowBanner -> False];
    Quiet[<< NCAlgebra`, NCAlgebra`NCAlgebra::SmallCapSymbolsNonCommutative];

### Messages

One of the following messages will be displayed after loading.

- `NCAlgebra::SmallCapSymbolsNonCommutative`, if small cap single letter symbols have
  been set as noncomutative;
- `NCAlgebra::NoSymbolsNonCommutative`, if no symbols have been set as noncomutative by
  `NCAlgebra`.

### NCOptions

The following `options` can be set using `SetOptions` before loading other packages:

- `SmallCapSymbolsNonCommutative` (`True`): If `True`, loading
  `NCAlgebra` will set all global single letter small cap symbols as
  noncommutative;
- `ShowBanner` (`True`): If `True`, a banner, when available, will be shown
  during the first loading of a package.
- `UseNotation` (`False`): If `True` use Mathematica’s package
  `Notation` when setting pretty output in
  [`NCSetOutput`](#ncsetoutput).

For example,

    << NC`
    << NCOptions`
    SetOptions[NCOptions, ShowBanner -> False];
    << NCAlgebra`

suppress the NCAlgebra banner that is printed the first time NCAlgebra
is loaded.

# Packages for manipulating NC expressions

## NonCommutativeMultiply

`NonCommutativeMultiply` is the main package that provides noncommutative functionality to Mathematica’s native `NonCommutativeMultiply` bound to the operator `**`.

Members are:

- [aj](#aj)
- [co](#co)
- [Id](#id)
- [inv](#inv)
- [tp](#tp)
- [rt](#rt)
- [CommutativeQ](#commutativeq)
- [NonCommutativeQ](#noncommutativeq)
- [SetCommutative](#setcommutative)
- [SetCommutativeHold](#setcommutativehold)
- [SetNonCommutative](#setnoncommutative)
- [SetNonCommutativeHold](#setnoncommutativehold)
- [SetCommutativeFunction](#setcommutativefunction)
- [SetNonCommutativeFunction](#setnoncommutativefunction)
- [SetCommutingOperators](#setcommutingoperators)
- [UnsetCommutingOperators](#unsetcommutingoperators)
- [CommutingOperatorsQ](#commutingoperatorsq)
- [NCNonCommutativeSymbolOrSubscriptQ](#ncnoncommutativesymbolorsubscriptq)
- [NCNonCommutativeSymbolOrSubscriptExtendedQ](#ncnoncommutativesymbolorsubscriptextendedq)
- [NCPowerQ](#ncpowerq)
- [Commutative](#commutative)
- [CommuteEverything](#commuteeverything)
- [BeginCommuteEverything](#begincommuteeverything)
- [EndCommuteEverything](#endcommuteeverything)
- [ExpandNonCommutativeMultiply](#expandnoncommutativemultiply)
- [NCExpandExponents](#ncexpandexponents)
- [NCToList](#nctolist)

Aliases are:

- [SNC](#snc) for [SetNonCommutative](#setnoncommutative)
- [NCExpand](#ncexpand) for [ExpandNonCommutativeMultiply](#expandnoncommutativemultiply)
- [NCE](#nce) for [ExpandNonCommutativeMultiply](#expandnoncommutativemultiply)

### aj

`aj[expr]` is the adjoint of expression `expr`. It is a conjugate linear involution.

See also:
[tp](#tp), [co](#co).

### co

`co[expr]` is the conjugate of expression `expr`. It is a linear involution.

See also:
[aj](#aj).

### Id

`Id` is noncommutative multiplicative identity. Actually Id is now set equal `1`.

### inv

`inv[expr]` is the 2-sided inverse of expression `expr`.

If `Options[inv, Distrubute]` is `False` (the default) then

    inv[a**b]

returns `inv[a**a]`. Conversely, if `Options[inv, Distrubute]` is `True` then it returns `inv[b]**inv[a]`.

### rt

`rt[expr]` is the root of expression `expr`.

### tp

`tp[expr]` is the tranpose of expression `expr`. It is a linear involution.

See also:
[aj](#tp), [co](#co).

### CommutativeQ

`CommutativeQ[expr]` is `True` if expression `expr` is commutative (the default), and `False` if `expr` is noncommutative.

See also:
[SetCommutative](#setcommutative), [SetNonCommutative](#setnoncommutative).

### NonCommutativeQ

`NonCommutativeQ[expr]` is equal to `Not[CommutativeQ[expr]]`.

See also:
[CommutativeQ](#commutativeq).

### SetCommutative

`SetCommutative[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, … to be commutative.

See also:
[SetNonCommutative](#setnoncommutative), [CommutativeQ](#commutativeq), [NonCommutativeQ](#noncommutativeq).

### SetCommutativeHold

`SetCommutativeHold[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, … to be commutative.

`SetCommutativeHold` has attribute `HoldAll` and can be used to set Symbols which have already been assigned a value.

See also:
[SetNonCommutativeHold](#setnoncommutativehold), [SetCommutative](#setcommutative), [SetNonCommutative](#setnoncommutative), [CommutativeQ](#commutativeq), [NonCommutativeQ](#noncommutativeq).

### SetNonCommutative

`SetNonCommutative[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, … to be noncommutative.

See also:
[SetCommutative](#setcommutative), [CommutativeQ](#commutativeq), [NonCommutativeQ](#noncommutativeq).

### SetNonCommutativeHold

`SetNonCommutativeHold[a,b,c,...]` sets all the `Symbols` `a`, `b`, `c`, … to be noncommutative.

`SetNonCommutativeHold` has attribute `HoldAll` and can be used to set Symbols which have already been assigned a value.

See also:
[SetCommutativeHold](#setcommutativehold), [SetCommutative](#setcommutative), [CommutativeQ](#commutativeq), [NonCommutativeQ](#noncommutativeq).

### SetCommutativeFunction

`SetCommutativeFunction[f]` sets expressions with `Head` `f`, i.e. functions, to be commutative.

By default, expressions in which the `Head` or any of its arguments is noncommutative will be considered noncommutative. For example,

    SetCommutative[trace];
    a ** b ** trace[a ** b]

evaluates to `a ** b ** trace[a ** b]` while

    SetCommutativeFunction[trace];
    a ** b ** trace[a ** b]

evaluates to `trace[a ** b] * a ** b`.

See also:
[SetCommutative](#setcommutative), [SetNonCommutative](#setnoncommutative), [CommutativeQ](#commutativeq), [NonCommutativeQ](#noncommutativeq), [tr](#tr).

### SetNonCommutativeFunction

`SetNonCommutativeFunction[f]` sets expressions with `Head` `f`, i.e. functions, to be non commutative. This is only necessary if it has been previously set commutative by [SetCommutativeFunction](#setcommutativefunction).

See also:
[SetCommutativeFunction](#setcommutativefunction), [SetCommutative](#setcommutative), [SetNonCommutative](#setnoncommutative), [CommutativeQ](#commutativeq), [NonCommutativeQ](#noncommutativeq), [tr](#tr).

### SNC

`SNC` is an alias for `SetNonCommutative`.

See also:
[SetNonCommutative](#setnoncommutative).

### SetCommutingOperators

`SetCommutingOperators[a,b]` will define a rule that substitute any
noncommutative product `b ** a` by `a ** b`, effectively making the
pair `a` and `b` commutative. If you want to create a rule to replace
`a ** b` by `b ** a` use `SetCommutingOperators[b,a]` instead.

See also:
[UnsetCommutingOperators](#unsetcommutingoperators),
[CommutingOperatorsQ](#commutingoperatorsq)

### UnsetCommutingOperators

`UnsetCommutingOperators[a,b]` remove any rules previously created by
`SetCommutingOperators[a,b]` or `SetCommutingOperators[b,a]`.

See also:
[SetCommutingOperators](#setcommutingoperators),
[CommutingOperatorsQ](#commutingoperatorsq)

### CommutingOperatorsQ

`CommutingOperatorsQ[a,b]` returns `True` if `a` and `b` are commuting operators.

See also:
[SetCommutingOperators](#setcommutingoperators),
[UnsetCommutingOperators](#unsetcommutingoperators)

### NCNonCommutativeSymbolOrSubscriptQ

`NCNonCommutativeSymbolOrSubscriptQ[expr]` returns *True* if `expr` is an noncommutative symbol or a noncommutative symbol subscript.

See also:
[NCNonCommutativeSymbolOrSubscriptExtendedQ](#ncnoncommutativesymbolorsubscriptextendedq),
[NCSymbolOrSubscriptQ](#ncsymbolorsubscriptq),
[NCSymbolOrSubscriptExtendedQ](#ncsymbolorsubscriptextendedq),
[NCPowerQ](#ncpowerq).

### NCNonCommutativeSymbolOrSubscriptExtendedQ

`NCNonCommutativeSymbolOrSubscriptExtendedQ[expr]` returns *True* if
`expr` is an noncommutative symbol, a noncommutative symbol subscript,
or the transpose (`tp`) or adjoint (`aj`) of a noncommutative symbol
or noncommutative symbol subscript.

See also:
[NCNonCommutativeSymbolOrSubscriptQ](#ncnoncommutativesymbolorsubscriptq),
[NCSymbolOrSubscriptQ](#ncsymbolorsubscriptq),
[NCSymbolOrSubscriptExtendedQ](#ncsymbolorsubscriptextendedq),
[NCPowerQ](#ncpowerq).

### NCPowerQ

`NCPowerQ[expr]` returns *True* if `expr` is an noncommutative symbol or symbol subscript or a positive power of a noncommutative symbol or symbol subscript.

See also:
[NCNonCommutativeSymbolOrSubscriptQ](#ncnoncommutativesymbolorsubscriptq),
[NCSymbolOrSubscriptQ](#ncsymbolorsubscriptq).

### Commutative

`Commutative[symbol]` is commutative even if `symbol` is noncommutative.

See also:
[CommuteEverything](#commuteeverything), [CommutativeQ](#commutativeq), [SetCommutative](#setcommutative), [SetNonCommutative](#setnoncommutative).

### CommuteEverything

`CommuteEverything[expr]` is an alias for [BeginCommuteEverything](#begincommuteeverything).

See also:
[BeginCommuteEverything](#begincommuteeverything), [Commutative](#commutative).

### BeginCommuteEverything

`BeginCommuteEverything[expr]` sets all symbols appearing in `expr` as commutative so that the resulting expression contains only commutative products or inverses. It issues messages warning about which symbols have been affected.

`EndCommuteEverything[]` restores the symbols noncommutative behaviour.

`BeginCommuteEverything` answers the question *what does it sound like?*

See also:
[EndCommuteEverything](#endcommuteeverything), [Commutative](#commutative).

### EndCommuteEverything

`EndCommuteEverything[expr]` restores noncommutative behaviour to symbols affected by `BeginCommuteEverything`.

See also:
[BeginCommuteEverything](#begincommuteeverything), [Commutative](#commutative).

### ExpandNonCommutativeMultiply

`ExpandNonCommutativeMultiply[expr]` expands out `**`s in `expr`.

For example

    ExpandNonCommutativeMultiply[a**(b+c)]

returns

    a**b + a**c.

See also:
[NCExpand](#ncexpand), [NCE](#nce).

### NCExpand

`NCExpand` is an alias for `ExpandNonCommutativeMultiply`.

See also:
[ExpandNonCommutativeMultiply](#expandnoncommutativemultiply),
[NCE](#nce).

### NCE

`NCE` is an alias for `ExpandNonCommutativeMultiply`.

See also:
[ExpandNonCommutativeMultiply](#expandnoncommutativemultiply),
[NCExpand](#ncexpand).

### NCExpandExponents

`NCExpandExponents[expr]` expands out powers of the monomials appearing in `expr`.

For example

    NCExpandExponents[a**(b**c)^2**(c+d)]

returns

    a**b**c**b**c**(c+d).

`NCExpandExponents` only expands powers of monomials. Powers of
symbols or other expressions are not expanded using
`NCExpandExponents`.

See also:
[NCToList](#nctolist)
[ExpandNonCommutativeMultiply](#expandnoncommutativemultiply),
[NCExpand](#ncexpand), [NCE](#nce).

### NCToList

`NCToList[expr]` produces a list with the symbols appearing in
monomial `expr`. If `expr` is not a monomial it remains
unevaluated. Powers of symbols are expanded before the list is
produced.

For example

    NCToList[a**b**a^2]

returns

    {a,b,a,a}

See also:
[NCExpandExponents](#ncexpandexponents),
[ExpandNonCommutativeMultiply](#expandnoncommutativemultiply),
[NCExpand](#ncexpand), [NCE](#nce).

## NCTr

`NCTr` provides the commutative operator `tr` that behaves as the
standard mathematical trace operator.

Members are:

- [tr](#tr)
- [SortCyclicPermutation](#sortcyclicpermutation)
- [SortedCyclicPermutationQ](#sortedcyclicpermutationq)

### tr

`tr[expr]` is an linear operator with the following properties:

- `tr` automatically distributes over sums;
- when `expr` is a noncommutative product, then product is sorted;
  for example `tr[b ** a]` evaluates into `tr[a ** b]`;
- `tr[aj[expr]]` gets normalized as `Conjugate[tr[expr]]`.

See also:
[SortCyclicPermutation](#sortcyclicpermutation),
[SortedCyclicPermutationQ](#sortedcyclicpermutationq).

### SortCyclicPermutation

`SortedCyclicPermutation[list]` returns a cyclic permutation of list sorted in
ascending order.

See also:
[SortedCyclicPermutationQ](#sortedcyclicpermutationq).

### SortedCyclicPermutationQ

`SortCyclicPermutationQ[list]` returns `True` if `list` is a sorted cyclic permutation.

See also:
[SortCyclicPermutation](#sortcyclicpermutation).

## NCCollect

Members are:

- [NCCollect](#nccollect-1)
- [NCCollectExponents](#nccollectexponents)
- [NCCollectSelfAdjoint](#nccollectselfadjoint)
- [NCCollectSymmetric](#nccollectsymmetric)
- [NCStrongCollect](#ncstrongcollect)
- [NCStrongCollectSelfAdjoint](#ncstrongcollectselfadjoint)
- [NCStrongCollectSymmetric](#ncstrongcollectsymmetric)
- [NCCompose](#nccompose)
- [NCDecompose](#ncdecompose)
- [NCTermsOfDegree](#nctermsofdegree)

### NCCollect

`NCCollect[expr,vars]` collects terms of nc expression `expr` according to the elements of `vars` and attempts to combine them. It is weaker than NCStrongCollect in that only same order terms are collected togther. It basically is `NCCompose[NCStrongCollect[NCDecompose]]]`.

If `expr` is a rational nc expression then degree correspond to the degree of the polynomial obtained using [NCRationalToNCPolynomial](#ncrationaltoncpolynomial).

`NCCollect` also works with nc expressions instead of *Symbols* in vars. In this case nc expressions are replaced by new variables and `NCCollect` is called using the resulting expression and the newly created *Symbols*.

This command internally converts nc expressions into the special `NCPolynomial` format.

`NCCollect[expr,vars,options]` uses options.

The following option is available:

- `ByTotalDegree` (`False`): whether to collect by total or partial degree.

**Notes:**

While `NCCollect[expr, vars]` always returns mathematically correct
expressions, it may not collect `vars` from as many terms as one might
think it should.

See also:
[NCStrongCollect](#ncstrongcollect), [NCCollectSymmetric](#nccollectsymmetric), [NCCollectSelfAdjoint](#nccollectselfadjoint), [NCStrongCollectSymmetric](#ncstrongcollectsymmetric), [NCStrongCollectSelfAdjoint](#ncstrongcollectselfadjoint), [NCRationalToNCPolynomial](#ncrationaltoncpolynomial).

### NCCollectExponents

`NCCollectExponents[expr]` collects exponents in noncommutative monomials.

For example

    NCCollectExponents[a**b**a**b**c-a**b**a**b]

returns

    (a**b)^2**c-(a**b)^2

See also:
[NCCollect](#nccollect-1),
[NCStrongCollect](#ncstrongcollect).

### NCCollectSelfAdjoint

`NCCollectSelfAdjoint[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their adjoints without writing out the adjoints.

This command internally converts nc expressions into the special `NCPolynomial` format.

`NCCollectSelfAdjoint[expr,vars,options]` uses options.

The following option is available:

- `ByTotalDegree` (`False`): whether to collect by total or partial degree.

See also:
[NCCollect](#nccollect-1), [NCStrongCollect](#ncstrongcollect), [NCCollectSymmetric](#nccollectsymmetric), [NCStrongCollectSymmetric](#ncstrongcollectsymmetric), [NCStrongCollectSelfAdjoint](#ncstrongcollectselfadjoint).

### NCCollectSymmetric

`NCCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

`NCCollectSymmetric[expr,vars,options]` uses options.

The following option is available:

- `ByTotalDegree` (`False`): whether to collect by total or partial degree.

See also:
[NCCollect](#nccollect-1), [NCStrongCollect](#ncstrongcollect), [NCCollectSelfAdjoint](#nccollectselfadjoint), [NCStrongCollectSymmetric](#ncstrongcollectsymmetric), [NCStrongCollectSelfAdjoint](#ncstrongcollectselfadjoint).

### NCStrongCollect

`NCStrongCollect[expr,vars]` collects terms of expression `expr` according to the elements of `vars` and attempts to combine by association.

In the noncommutative case the Taylor expansion and so the collect function is not uniquely specified. The function `NCStrongCollect` often collects too much and while correct it may be stronger than you want.

For example, a symbol `x` will factor out of terms where it appears both linearly and quadratically thus mixing orders.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCCollect](#nccollect-1), [NCCollectSymmetric](#nccollectsymmetric), [NCCollectSelfAdjoint](#nccollectselfadjoint), [NCStrongCollectSymmetric](#ncstrongcollectsymmetric), [NCStrongCollectSelfAdjoint](#ncstrongcollectselfadjoint).

### NCStrongCollectSelfAdjoint

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCCollect](#nccollect-1), [NCStrongCollect](#ncstrongcollect), [NCCollectSymmetric](#nccollectsymmetric), [NCCollectSelfAdjoint](#nccollectselfadjoint), [NCStrongCollectSymmetric](#ncstrongcollectsymmetric).

### NCStrongCollectSymmetric

`NCStrongCollectSymmetric[expr,vars]` allows one to collect terms of nc expression `expr` on the variables `vars` and their transposes without writing out the transposes.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCCollect](#nccollect-1), [NCStrongCollect](#ncstrongcollect), [NCCollectSymmetric](#nccollectsymmetric), [NCCollectSelfAdjoint](#nccollectselfadjoint), [NCStrongCollectSelfAdjoint](#ncstrongcollectselfadjoint).

### NCCompose

`NCCompose[dec]` will reassemble the terms in `dec` which were decomposed by [`NCDecompose`](#ncdecompose).

`NCCompose[dec, degree]` will reassemble only the terms of degree `degree`.

The expression `NCCompose[NCDecompose[p,vars]]` will reproduce the polynomial `p`.

The expression `NCCompose[NCDecompose[p,vars], degree]` will reproduce only the terms of degree `degree`.

This command internally converts nc expressions into the special `NCPolynomial` format.

See also:
[NCDecompose](#ncdecompose), [NCPDecompose](#ncpdecompose).

### NCDecompose

`NCDecompose[p,vars]` gives an association of elements of the nc polynomial `p` in variables `vars` in which elements of the same order are collected together.

`NCDecompose[p]` treats all nc letters in `p` as variables.

This command internally converts nc expressions into the special `NCPolynomial` format.

Internally `NCDecompose` uses [`NCPDecompose`](#ncpdecompose).

See also:
[NCCompose](#nccompose), [NCPDecompose](#ncpdecompose).

### NCTermsOfDegree

`NCTermsOfDegree[expr,vars,degrees]` returns an expression such that
each term has degree `degrees` in variables `vars`.

For example,

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {2,1}]

returns `x**y**x - x**x**y`,

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {1,0}]

returns `x**w`,

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {0,0}]

returns `z**w`, and

    NCTermsOfDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, {0,1}]

returns `0`.

This command internally converts nc expressions into the special
`NCPolynomial` format.

See also:
[NCTermsOfTotalDegree](#nctermsoftotaldegree),
[NCDecompose](#ncdecompose), [NCPDecompose](#ncpdecompose).

### NCTermsOfTotalDegree

`NCTermsOfTotalDegree[expr,vars,degree]` returns an expression such that
each term has total degree `degree` in variables `vars`.

For example,

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 3]

returns `x**y**x - x**x**y`,

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 1]

returns `x**w`,

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 0]

returns `z**w`, and

    NCTermsOfTotalDegree[x**y**x - x**x**y + x**w + z**w, {x,y}, 2]

returns `0`.

This command internally converts nc expressions into the special
`NCPolynomial` format.

See also:
[NCTermsOfDegree](#nctermsofdegree),
[NCDecompose](#ncdecompose), [NCPDecompose](#ncpdecompose).

## NCReplace

**NCReplace** is a package containing several functions that are
useful in making replacements in noncommutative expressions. It offers
replacements to Mathematica’s `Replace`, `ReplaceAll`,
`ReplaceRepeated`, and `ReplaceList` functions.

> Commands in this package replace the old `Substitute` and
> `Transform` family of command which are been deprecated. The new
> commands are much more reliable and work faster than the old
> commands. From the beginning, substitution was always problematic
> and certain patterns would be missed. We reassure that the call
> expression that are returned are mathematically correct but some
> opportunities for substitution may have been missed.

Members are:

- [NCReplace](#ncreplace-1)
- [NCReplaceAll](#ncreplaceall)
- [NCReplaceList](#ncreplacelist)
- [NCReplaceRepeated](#ncreplacerepeated)
- [NCExpandReplaceRepeated](#ncexpandreplacerepeated)
- [NCMakeRuleSymmetric](#ncmakerulesymmetric)
- [NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint)
- [NCReplaceSymmetric](#ncreplacesymmetric)
- [NCReplaceAllSymmetric](#ncreplaceallsymmetric)
- [NCReplaceListSymmetric](#ncreplacelistsymmetric)
- [NCReplaceRepeatedSymmetric](#ncreplacerepeatedsymmetric)
- [NCExpandReplaceRepeatedSymmetric](#ncexpandreplacerepeatedsymmetric)
- [NCReplaceSelfAdjoint](#ncreplaceselfadjoint)
- [NCReplaceAllSelfAdjoint](#ncreplaceallselfadjoint)
- [NCReplaceListSelfAdjoint](#ncreplacelistselfadjoint)
- [NCReplaceRepeatedSelfAdjoint](#ncreplacerepeatedselfadjoint)
- [NCExpandReplaceRepeatedSelfAdjoint](#ncexpandreplacerepeatedselfadjoint)
- [NCMatrixExpand](#ncmatrixexpand)
- [NCMatrixReplaceAll](#ncmatrixreplaceall)
- [NCMatrixReplaceRepeated](#ncmatrixreplacerepeated)
- [NCReplacePowerRule](#ncreplacepowerrule)

Aliases:

- [NCR](#ncr) for [NCReplace](#ncreplace-1)
- [NCRA](#ncra) for [NCReplaceAll](#ncreplaceall)
- [NCRL](#ncrl) for [NCReplaceList](#ncreplacelist)
- [NCRR](#ncrr) for [NCReplaceRepeated](#ncreplacerepeated)
- [NCRSym](#ncrsym) for [NCReplaceSymmetric](#ncreplacesymmetric)
- [NCRASym](#ncrasym) for [NCReplaceAllSymmetric](#ncreplaceallsymmetric)
- [NCRLSym](#ncrlsym) for [NCReplaceListSymmetric](#ncreplacelistsymmetric)
- [NCRRSym](#ncrrsym) for [NCReplaceRepeatedSymmetric](#ncreplacerepeatedsymmetric)
- [NCRSA](#ncrsa) for [NCReplaceSelfAdjoint](#ncreplaceselfadjoint)
- [NCRASA](#ncrasa) for [NCReplaceAllSelfAdjoint](#ncreplaceallselfadjoint)
- [NCRLSA](#ncrlsa) for [NCReplaceListSelfAdjoint](#ncreplacelistselfadjoint)
- [NCRRSA](#ncrrsa) for [NCReplaceRepeatedSelfAdjoint](#ncreplacerepeatedselfadjoint)

Options:

- `ApplyPowerRule` (`True`): If `True`, `NCReplacePowerRule` is
  automatically applied to all rules in `NCReplace`, `NCReplaceAll`,
  `NCReplaceRepeated`, and `NCReplaceList`.

### NCReplace

`NCReplace[expr,rules]` applies a rule or list of rules
`rules` in an attempt to transform the entire nc expression `expr`.

`NCReplace[expr,rules,levelspec]` applies `rules` to parts of `expr`
specified by `levelspec`.

`NCReplace[expr,rules,options]` and `NCReplace[expr,rules,levelspec]`
use `options`.

See also:
[NCReplaceAll](#ncreplaceall), [NCReplaceList](#ncreplacelist), [NCReplaceRepeated](#ncreplacerepeated).

### NCReplaceAll

`NCReplaceAll[expr,rules]` applies a rule or list of rules `rules` in an attempt to transform each part of the nc expression `expr`.

`NCReplaceAll[expr,rules,options]` uses `options`.

See also:
[NCReplace](#ncreplace-1), [NCReplaceList](#ncreplacelist), [NCReplaceRepeated](#ncreplacerepeated).

### NCReplaceList

`NCReplace[expr,rules]` attempts to transform the entire nc expression `expr` by applying a rule or list of rules `rules` in all possible ways, and returns a list of the results obtained.

`ReplaceList[expr,rules,n]` gives a list of at most `n` results.

`NCReplaceList[expr,rules,options]` and
`NCReplaceList[expr,rules,n,options]` use `options`.

See also:
[NCReplace](#ncreplace-1), [NCReplaceAll](#ncreplaceall), [NCReplaceRepeated](#ncreplacerepeated).

### NCReplaceRepeated

`NCReplaceRepeated[expr,rules]` repeatedly performs replacements using rule or list of rules `rules` until `expr` no longer changes.

`NCReplaceRepeated[expr,rules,options]` uses `options`.

See also:
[NCReplace](#ncreplace-1), [NCReplaceAll](#ncreplaceall),
[NCReplaceList](#ncreplacelist),
[NCExpandReplaceRepeated](#ncexpandreplacerepeated).

### NCExpandReplaceRepeated

`NCExpandReplaceRepeated[expr,rules]` repeatedly applies
`NCReplaceRepeated` and `NCExpand` until the results does not change.

`NCExpandReplaceRepeated[expr,rules,options]` uses `options`.

See also:
[NCReplaceRepeated](#ncreplacerepeated),
[NCExpandReplaceRepeatedSymmetric](#ncexpandreplacerepeatedsymmetric),
[NCExpandReplaceRepeatedSelfAdjoint](#ncexpandreplacerepeatedselfadjoint).

### NCR

`NCR` is an alias for `NCReplace`.

See also:
[NCReplace](#ncreplace-1).

### NCRA

`NCRA` is an alias for `NCReplaceAll`.

See also:
[NCReplaceAll](#ncreplaceall).

### NCRR

`NCRR` is an alias for `NCReplaceRepeated`.

See also:
[NCReplaceRepeated](#ncreplacerepeated).

### NCRL

`NCRL` is an alias for `NCReplaceList`.

See also:
[NCReplaceList](#ncreplacelist).

### NCMakeRuleSymmetric

`NCMakeRuleSymmetric[rules]` add rules to transform the transpose of the left-hand side of `rules` into the transpose of the right-hand side of `rules`.

See also:
[NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint),
[NCReplace](#ncreplace-1), [NCReplaceAll](#ncreplaceall),
[NCReplaceList](#ncreplacelist),
[NCReplaceRepeated](#ncreplacerepeated).

### NCMakeRuleSelfAdjoint

`NCMakeRuleSelfAdjoint[rules]` add rules to transform the adjoint of the left-hand side of `rules` into the adjoint of the right-hand side of `rules`.

See also:
[NCMakeRuleSymmetric](#ncmakerulesymmetric), [NCReplace](#ncreplace-1),
[NCReplaceAll](#ncreplaceall), [NCReplaceList](#ncreplacelist),
[NCReplaceRepeated](#ncreplacerepeated).

### NCReplaceSymmetric

`NCReplaceSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to
`rules` before calling `NCReplace`.

`NCReplaceSymmetric[expr,rules,options]` uses `options`.

See also:
[NCReplace](#ncreplace-1), [NCMakeRuleSymmetric](#ncmakerulesymmetric).

### NCReplaceAllSymmetric

`NCReplaceAllSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to
`rules` before calling `NCReplaceAll`.

`NCReplaceAllSymmetric[expr,rules,options]` uses `options`.

See also:
[NCReplaceAll](#ncreplaceall),
[NCMakeRuleSymmetric](#ncmakerulesymmetric).

### NCReplaceRepeatedSymmetric

`NCReplaceRepeatedSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to `rules` before calling `NCReplaceRepeated`.

`NCReplaceRepeatedSymmetric[expr,rules,options]` uses `options`.

See also:
[NCReplaceRepeated](#ncreplacerepeated),
[NCMakeRuleSymmetric](#ncmakerulesymmetric).

### NCExpandReplaceRepeatedSymmetric

`NCExpandReplaceRepeatedSymmetric[expr,rules]` repeatedly applies
`NCReplaceRepeatedSymmetric` and `NCExpand` until the results does not
change.

`NCExpandReplaceRepeatedSymmetric[expr,rules,options]` uses `options`.

See also:
[NCReplaceRepeatedSymmetric](#ncreplacerepeatedsymmetric),
[NCExpandReplaceRepeated](#ncexpandreplacerepeated),
[NCExpandReplaceRepeatedSelfAdjoint](#ncexpandreplacerepeatedselfadjoint).

### NCReplaceListSymmetric

`NCReplaceListSymmetric[expr, rules]` applies `NCMakeRuleSymmetric` to
`rules` before calling `NCReplaceList`.

`NCReplaceListSymmetric[expr,rules,options]` uses `options`.

See also:
[NCReplaceList](#ncreplacelist),
[NCMakeRuleSymmetric](#ncmakerulesymmetric).

### NCRSym

`NCRSym` is an alias for `NCReplaceSymmetric`.

See also:
[NCReplaceSymmetric](#ncreplacesymmetric).

### NCRASym

`NCRASym` is an alias for `NCReplaceAllSymmetric`.

See also:
[NCReplaceAllSymmetric](#ncreplaceallsymmetric).

### NCRRSym

`NCRRSym` is an alias for `NCReplaceRepeatedSymmetric`.

See also:
[NCReplaceRepeatedSymmetric](#ncreplacerepeatedsymmetric).

### NCRLSym

`NCRLSym` is an alias for `NCReplaceListSymmetric`.

See also:
[NCReplaceListSymmetric](#ncreplacelistsymmetric).

### NCReplaceSelfAdjoint

`NCReplaceSelfAdjoint[expr, rules]` applies `NCMakeRuleSelfAdjoint` to
`rules` before calling `NCReplace`.

`NCReplaceSelfAdjoint[expr,rules,options]` uses `options`.

See also:
[NCReplace](#ncreplace-1),
[NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint).

### NCReplaceAllSelfAdjoint

`NCReplaceAllSelfAdjoint[expr, rules]` applies `NCMakeRuleSelfAdjoint`
to `rules` before calling `NCReplaceAll`.

`NCReplaceAllSelfAdjoint[expr,rules,options]` uses `options`.

See also:
[NCReplaceAll](#ncreplaceall),
[NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint).

### NCReplaceRepeatedSelfAdjoint

`NCReplaceRepeatedSelfAdjoint[expr, rules]` applies
`NCMakeRuleSelfAdjoint` to `rules` before calling `NCReplaceRepeated`.

`NCReplaceRepeatedSelfAdjoint[expr,rules,options]` uses `options`.

See also:
[NCReplaceRepeated](#ncreplacerepeated),
[NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint).

### NCExpandReplaceRepeatedSelfAdjoint

`NCExpandReplaceRepeatedSelfAdjoint[expr,rules]` repeatedly applies
`NCReplaceRepeatedSelfAdjoint` and `NCExpand` until the results does not
change.

`NCExpandedReplaceRepeatedSelfAdjoint[expr,rules,options]` uses
`options`.

See also:
[NCReplaceRepeatedSelfAdjoint](#ncreplacerepeatedselfadjoint),
[NCExpandReplaceRepeated](#ncexpandreplacerepeated),
[NCExpandReplaceRepeatedSymmetric](#ncexpandreplacerepeatedsymmetric).

### NCReplaceListSelfAdjoint

`NCReplaceListSelfAdjoint[expr, rules]` applies
`NCMakeRuleSelfAdjoint` to `rules` before calling `NCReplaceList`.

`NCReplaceListSelfAdjoint[expr,rules,options]` uses `options`.

See also:
[NCReplaceList](#ncreplacelist),
[NCMakeRuleSelfAdjoint](#ncmakeruleselfadjoint).

### NCRSA

`NCRSA` is an alias for `NCReplaceSymmetric`.

See also:
[NCReplaceSymmetric](#ncreplacesymmetric).

### NCRASA

`NCRASA` is an alias for `NCReplaceAllSymmetric`.

See also:
[NCReplaceAllSymmetric](#ncreplaceallsymmetric).

### NCRRSA

`NCRRSA` is an alias for `NCReplaceRepeatedSymmetric`.

See also:
[NCReplaceRepeatedSymmetric](#ncreplacerepeatedsymmetric).

### NCRLSA

`NCRLSA` is an alias for `NCReplaceListSymmetric`.

See also:
[NCReplaceListSymmetric](#ncreplacelistsymmetric).

### NCMatrixExpand

`NCMatrixExpand[expr]` expands `inv` and `**` of matrices appearing in
nc expression `expr`. It effectively substitutes `inv` for `NCInverse`
and `**` by `NCDot`.

See also:
[NCInverse](#ncinverse), [NCDot](#ncdot-1).

### NCMatrixReplaceAll

`NCMatrixReplaceAll[expr,rules]` applies a rule or list of rules
`rules` in an attempt to transform each part of the nc expression
`expr`.

`NCMatrixReplaceAll` works as `NCReplaceAll` but takes extra steps to
make sure substitutions work with matrices.

See also:
[NCReplaceAll](#ncreplaceall),
[NCMatrixReplaceRepeated](#ncmatrixreplacerepeated).

### NCMatrixReplaceRepeated

`NCMatrixReplaceRepeated[expr,rules]` repeatedly performs replacements
using rule or list of rules `rules` until `expr` no longer changes.

`NCMatrixReplaceRepeated` works as `NCReplaceRepeated` but takes extra
steps to make sure substitutions work with matrices.

See also:
[NCReplaceRepeated](#ncreplacerepeated),
[NCMatrixReplaceAll](#ncmatrixreplaceall).

### NCReplacePowerRule

`NCReplacePowerRule[rule]` transforms rules that consist of a
noncommutative monomial so that symbols appearing on the left and on
right of the monomial also match positive powers of that symbol.

See also:
[NCReplace](#ncreplace-1),
[NCReplaceAll](#ncreplaceall),
[NCReplaceList](#ncreplacelist),
[NCReplaceRepeated](#ncreplacerepeated).

## NCSelfAdjoint

Members are:

- [NCSymmetricQ](#ncsymmetricq)
- [NCSymmetricTest](#ncsymmetrictest)
- [NCSymmetricPart](#ncsymmetricpart)
- [NCSelfAdjointQ](#ncselfadjointq)
- [NCSelfAdjointTest](#ncselfadjointtest)

### NCSymmetricQ

`NCSymmetricQ[expr]` returns *True* if `expr` is symmetric, i.e. if `tp[exp] == exp`.

`NCSymmetricQ` attempts to detect symmetric variables using `NCSymmetricTest`.

See also:
[NCSelfAdjointQ](#ncselfadjointq), [NCSymmetricTest](#ncsymmetrictest).

### NCSymmetricTest

`NCSymmetricTest[expr]` attempts to establish symmetry of `expr` by assuming symmetry of its variables.

`NCSymmetricTest[exp,options]` uses `options`.

`NCSymmetricTest` returns a list of two elements:

- the first element is *True* or *False* if it succeeded to prove `expr` symmetric.
- the second element is a list of the variables that were made symmetric.

The following options can be given:

- `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
- `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables;
- `Strict`: treats as non-symmetric any variable that appears inside `tp`.

See also:
[NCSymmetricQ](#ncsymmetricq), [NCNCSelfAdjointTest](#ncselfadjointtest).

### NCSymmetricPart

`NCSymmetricPart[expr]` returns the *symmetric part* of `expr`.

`NCSymmetricPart[exp,options]` uses `options`.

`NCSymmetricPart[expr]` returns a list of two elements:

- the first element is the *symmetric part* of `expr`;
- the second element is a list of the variables that were made symmetric.

`NCSymmetricPart[expr]` returns `{$Failed, {}}` if `expr` is not symmetric.

For example:

    {answer, symVars} = NCSymmetricPart[a ** x + x ** tp[a] + 1];

returns

    answer = 2 a ** x + 1
    symVars = {x}

The following options can be given:

- `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
- `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.
- `Strict`: treats as non-symmetric any variable that appears inside `tp`.

See also:
[NCSymmetricTest](#ncsymmetrictest).

### NCSelfAdjointQ

`NCSelfAdjointQ[expr]` returns true if `expr` is self-adjoint, i.e. if `aj[exp] == exp`.

See also:
[NCSymmetricQ](#ncsymmetricq), [NCSelfAdjointTest](#ncselfadjointtest).

### NCSelfAdjointTest

`NCSelfAdjointTest[expr]` attempts to establish whether `expr` is self-adjoint by assuming that some of its variables are self-adjoint or symmetric.
`NCSelfAdjointTest[expr,options]` uses `options`.

`NCSelfAdjointTest` returns a list of three elements:

- the first element is *True* or *False* if it succeded to prove `expr` self-adjoint.
- the second element is a list of variables that were made self-adjoint.
- the third element is a list of variables that were made symmetric.

The following options can be given:

- `SelfAdjointVariables`: list of variables that should be considered self-adjoint; use `All` to make all variables self-adjoint;
- `SymmetricVariables`: list of variables that should be considered symmetric; use `All` to make all variables symmetric;
- `ExcludeVariables`: list of variables that should not be considered symmetric; use `All` to exclude all variables.
- `Strict`: treats as non-self-adjoint any variable that appears inside `aj`.

See also:
[NCSelfAdjointQ](#ncselfadjointq).

## NCSimplifyRational

**NCSimplifyRational** is a package with function that simplifies noncommutative expressions and certain functions of their inverses.

`NCSimplifyRational` simplifies rational noncommutative expressions by repeatedly applying a set of reduction rules to the expression. `NCSimplifyRationalSinglePass` does only a single pass.

Rational expressions of the form

    inv[A + terms]

are first normalized to

inv\[1 + terms/A\]/A

using `NCNormalizeInverse`. Here `A` is commutative.

For each `inv` found in expression, a custom set of rules is constructed based on its associated NC Groebner basis.

For example, if

    inv[mon1 + ... + K lead]

where `lead` is the leading monomial with the highest degree then the following rules are generated:

| Original                      | Transformed                                 |
|:------------------------------|:--------------------------------------------|
| inv\[mon1 + … + K lead\] lead | (1 - inv\[mon1 + … + K lead\] (mon1 + …))/K |
| lead inv\[mon1 + … + K lead\] | (1 - (mon1 + …) inv\[mon1 + … + K lead\])/K |

Finally the following pattern based rules are applied:

| Original                         | Transformed                     |
|:---------------------------------|:--------------------------------|
| inv\[a\] inv\[1 + K a b\]        | inv\[a\] - K b inv\[1 + K a b\] |
| inv\[a\] inv\[1 + K a\]          | inv\[a\] - K inv\[1 + K a\]     |
| inv\[1 + K a b\] inv\[b\]        | inv\[b\] - K inv\[1 + K a b\] a |
| inv\[1 + K a\] inv\[a\]          | inv\[a\] - K inv\[1 + K a\]     |
| inv\[1 + K a b\] a               | a inv\[1 + K b a\]              |
| inv\[A inv\[a\] + B b\] inv\[a\] | (1/A) inv\[1 + (B/A) a b\]      |
| inv\[a\] inv\[A inv\[a\] + K b\] | (1/A) inv\[1 + (B/A) b a\]      |
| inv\[1 + K a b\] a b             | (1 - inv\[1 + K a b\])/K        |
| inv\[1 + K a\] a                 | (1 - inv\[1 + K a\])/K          |
| a b inv\[1 + K a b\]             | (1 - inv\[1 + K a b\])/K        |
| a inv\[1 + K a\]                 | (1 - inv\[1 + K a\])/K          |

`NCPreSimplifyRational` only applies pattern based rules from the table above once.

Rules in `NCSimplifyRational` and `NCPreSimplifyRational` are applied repeatedly.

Rules in `NCSimplifyRationalSinglePass` and `NCPreSimplifyRationalSinglePass` are applied only once.

The particular ordering of monomials used by `NCSimplifyRational` is the one implied by the `NCPolynomial` format. This ordering is a variant of the deg-lex ordering where the lexical ordering is Mathematica’s natural ordering.

`NCSimplifyRational` is limited by its rule list and what rules are
best is unknown and might depend on additional assumptions. For example:

    NCSimplifyRational[y ** inv[y + x ** y]]

returns `y ** inv[y + x ** y]` not `inv[1 + x]`, which is what one
would expect if `y` were to be invertible. Indeed,

    NCSimplifyRational[inv[y] ** inv[inv[y] + x ** inv[y]]]

does return `inv[1 + x]`, since in this case the appearing of `inv[y]`
trigger rules that implicitely assume `y` is invertible.

Members are:

- [NCNormalizeInverse](#ncnormalizeinverse)
- [NCSimplifyRational](#ncsimplifyrational-1)
- [NCSimplifyRationalSinglePass](#ncsimplifyrationalsinglepass)
- [NCPreSimplifyRational](#ncpresimplifyrational)
- [NCPreSimplifyRationalSinglePass](#ncpresimplifyrationalsinglepass)

Aliases:

- [NCSR](#ncsr) for [NCSimplifyRational](#ncsimplifyrational-1)

### NCNormalizeInverse

`NCNormalizeInverse[expr]` transforms all rational NC expressions of the form `inv[K + b]` into `inv[1 + (1/K) b]/K` if `A` is commutative.

See also:
[NCSimplifyRational](#ncsimplifyrational-1), [NCSimplifyRationalSinglePass](#ncsimplifyrationalsinglepass).

### NCSimplifyRational

`NCSimplifyRational[expr]` repeatedly applies `NCSimplifyRationalSinglePass` in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#ncnormalizeinverse),
[NCSimplifyRationalSinglePass](#ncsimplifyrationalsinglepass).

### NCSR

`NCSR` is an alias for `NCSimplifyRational`.

See also:
[NCSimplifyRational](#ncsimplifyrational-1).

### NCSimplifyRationalSinglePass

`NCSimplifyRationalSinglePass[expr]` applies a series of custom rules only once in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#ncnormalizeinverse),
[NCSimplifyRational](#ncsimplifyrational-1).

### NCPreSimplifyRational

`NCPreSimplifyRational[expr]` repeatedly applies `NCPreSimplifyRationalSinglePass` in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#ncnormalizeinverse),
[NCPreSimplifyRationalSinglePass](#ncpresimplifyrationalsinglepass).

### NCPreSimplifyRationalSinglePass

`NCPreSimplifyRationalSinglePass[expr]` applies a series of custom rules only once in an attempt to simplify the rational NC expression `expr`.

See also:
[NCNormalizeInverse](#ncnormalizeinverse),
[NCPreSimplifyRational](#ncpresimplifyrational).

## NCDiff

**NCDiff** is a package containing several functions that are used in noncommutative differention of functions and polynomials.

Members are:

- [NCDirectionalD](#ncdirectionald)
- [NCGrad](#ncgrad)
- [NCHessian](#nchessian)
- [NCIntegrate](#ncintegrate)

Members being deprecated:

- [DirectionalD](#directionald)

### NCDirectionalD

`NCDirectionalD[expr, {var1, h1}, ...]` takes the directional derivative of expression `expr` with respect to variables `var1`, `var2`, … successively in the directions `h1`, `h2`, ….

For example, if:

    expr = a**inv[1+x]**b + x**c**x

then

    NCDirectionalD[expr, {x,h}]

returns

    h**c**x + x**c**h - a**inv[1+x]**h**inv[1+x]**b

In the case of more than one variables
`NCDirectionalD[expr, {x,h}, {y,k}]` takes the directional derivative
of `expr` with respect to `x` in the direction `h` and with respect to
`y` in the direction `k`. For example, if:

    expr = x**q**x - y**x

then

    NCDirectionalD[expr, {x,h}, {y,k}]

returns

    h**q**x + x**q*h - y**h - k**x

See also:
[NCGrad](#ncgrad),
[NCHessian](#nchessian).

### NCGrad

`NCGrad[expr, var1, ...]` gives the nc gradient of the expression `expr` with respect to variables `var1`, `var2`, …. If there is more than one variable then `NCGrad` returns the gradient in a list.

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

See also:
[NCDirectionalD](#ncdirectionald).

### NCHessian

`NCHessian[expr, {var1, h1}, ...]` takes the second directional derivative of nc expression `expr` with respect to variables `var1`, `var2`, … successively in the directions `h1`, `h2`, ….

For example, if:

    expr = y**inv[x]**y + x**a**x

then

    NCHessian[expr, {x,h}, {y,s}]

returns

    2 h**a**h + 2 s**inv[x]**s - 2 s**inv[x]**h**inv[x]**y -
    2 y**inv[x]**h**inv[x]**s + 2 y**inv[x]**h**inv[x]**h**inv[x]**y

In the case of more than one variables `NCHessian[expr, {x,h}, {y,k}]`
takes the second directional derivative of `expr` with respect to `x`
in the direction `h` and with respect to `y` in the direction `k`.

See also:
[NCDiretionalD](#ncdirectionald), [NCGrad](#ncgrad).

### DirectionalD

`DirectionalD[expr,var,h]` takes the directional derivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

**DEPRECATION NOTICE**: This syntax is limited to one variable and is being deprecated in favor of the more general syntax in [NCDirectionalD](#ncdirectionald).

See also:
[NCDirectionalD](#directionald).

### NCIntegrate

`NCIntegrate[expr,{var1,h1},...]` attempts to calculate the nc antiderivative of nc expression `expr` with respect to the single variable `var` in direction `h`.

For example:

    NCIntegrate[x**h+h**x, {x,h}]

returns

    x**x

See also:
[NCDirectionalD](#directionald).

## NCConvexity

**NCConvexity** is a package that provides functionality to determine whether a rational or polynomial noncommutative function is convex.

Members are:

- [NCIndependent](#ncindependent)
- [NCConvexityRegion](#ncconvexityregion)

### NCIndependent

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

See also:
[NCConvexityRegion](#ncconvexityregion).

### NCConvexityRegion

`NCConvexityRegion[expr,vars]` is a function which can be used to determine whether the nc rational `expr` is convex in `vars` or not.

For example:

    d = NCConvexityRegion[x**x**x, {x}];

returns

    d = {2 x, -2 inv[x]}

from which we conclude that `x**x**x` is not convex in `x` because ![x \succ 0](https://render.githubusercontent.com/render/math?math=x%20%5Csucc%200&mode=inline) and ![-{x}^{-1} \succ 0](https://render.githubusercontent.com/render/math?math=-%7Bx%7D%5E%7B-1%7D%20%5Csucc%200&mode=inline) cannot simultaneously hold.

`NCConvexityRegion` works by factoring the `NCHessian`, essentially calling:

    hes = NCHessian[expr, {x, h}];

then

    {lt, mq, rt} = NCMatrixOfQuadratic[hes, {h}]

to decompose the Hessian into a product of a left row vector, `lt`, times a middle matrix, `mq`, times a right column vector, `rt`. The middle matrix, `mq`, is factored using the `NCLDLDecomposition`:

    {ldl, p, s, rank} = NCLDLDecomposition[mq];
    {lf, d, rt} = GetLDUMatrices[ldl, s];

from which the output of NCConvexityRegion is the a list with the block-diagonal entries of the matrix `d`.

See also:
[NCHessian](#nchessian), [NCMatrixOfQuadratic](#ncmatrixofquadratic), [NCLDLDecomposition](#ncldldecomposition).

# Packages for manipulating NC block matrices

## NCDot

Members are:

- [tpMat](#tpmat)
- [ajMat](#ajmat)
- [coMat](#comat)
- [NCDot](#ncdot-1)
- [NCInverse](#ncinverse)

### tpMat

`tpMat[mat]` gives the transpose of matrix `mat` using `tp`.

See also:
[ajMat](#tpmat), [coMat](#comat), [NCDot](#ncdot-1).

### ajMat

`ajMat[mat]` gives the adjoint transpose of matrix `mat` using `aj` instead of `ConjugateTranspose`.

See also:
[tpMat](#tpmat), [coMat](#comat), [NCDot](#ncdot-1).

### coMat

`coMat[mat]` gives the conjugate of matrix `mat` using `co` instead of `Conjugate`.

See also:
[tpMat](#tpmat), [ajMat](#comat), [NCDot](#ncdot-1).

### NCDot

`NCDot[mat1, mat2, ...]` gives the matrix multiplication of `mat1`, `mat2`, … using `NonCommutativeMultiply` rather than `Times`.

**Notes:**

The experienced matrix analyst should always remember that the Mathematica convention for handling vectors is tricky.

- `{{1,2,4}}` is a 1x3 *matrix* or a *row vector*;
- `{{1},{2},{4}}` is a 3x1 *matrix* or a *column vector*;
- `{1,2,4}` is a *vector* but **not** a *matrix*. Indeed whether it is a row or column vector depends on the context. We advise not to use *vectors*.

See also:
[tpMat](#tpmat), [ajMat](#comat), [coMat](#comat).

### NCInverse

`NCInverse[mat]` gives the nc inverse of the square matrix `mat`. `NCInverse` uses partial pivoting to find a nonzero pivot.

`NCInverse` is primarily used symbolically. Usually the elements of the inverse matrix are huge expressions.
We recommend using `NCSimplifyRational` to improve the results.

See also:
[tpMat](#tpmat), [ajMat](#comat), [coMat](#comat).

## NCMatrixDecompositions

`NCMatrixDecompositions` provide noncommutative versions of the linear algebra algorithms in the package [MatrixDecompositions](#matrixdecompositions-linear-algebra-templates).

See the documentation for the package
[MatrixDecompositions](#matrixdecompositions-linear-algebra-templates) for details on
the algorithms and options.

Members are:

- Decompositions
  - [NCLUDecompositionWithPartialPivoting](#ncludecompositionwithpartialpivoting)
  - [NCLUDecompositionWithCompletePivoting](#ncludecompositionwithcompletepivoting)
  - [NCLDLDecomposition](#ncldldecomposition)
- Solvers
  - [NCLowerTriangularSolve](#nclowertriangularsolve)
  - [NCUpperTriangularSolve](#ncuppertriangularsolve)
  - [NCLUInverse](#ncluinverse)
- Utilities
  - [NCLUCompletePivoting](#nclucompletepivoting)
  - [NCLUPartialPivoting](#nclupartialpivoting)
  - [NCLeftDivide](#ncleftdivide)
  - [NCRightDivide](#ncrightdivide)

### NCLUDecompositionWithPartialPivoting

`NCLUDecompositionWithPartialPivoting` is a noncommutative version of
[NCLUDecompositionWithPartialPivoting](#ncludecompositionwithpartialpivoting).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` ([NCRightDivide](#ncrightdivide)): function used to divide a vector by an entry;
- `Dot` ([NCDot](#ncdot-1)): function used to multiply vectors and matrices;
- `Pivoting` ([NCLUPartialPivoting](#nclupartialpivoting)): function used to sort rows for pivoting;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting).

### NCLUDecompositionWithCompletePivoting

`NCLUDecompositionWithCompletePivoting` is a noncommutative version of
[NCLUDecompositionWithCompletePivoting](#ncludecompositionwithcompletepivoting).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` ([NCRightDivide](#ncrightdivide)): function used to divide a vector by an entry;
- `Dot` ([NCDot](#ncdot-1)): function used to multiply vectors and matrices;
- `Pivoting` ([NCLUCompletePivoting](#nclucompletepivoting)): function used to sort rows for pivoting;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting).

### NCLDLDecomposition

`NCLDLDecomposition` is a noncommutative version of [LDLDecomposition](#ldldecomposition).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` ([NCRightDivide](#ncrightdivide)): function used to divide a vector by an entry on the right;
- `LeftDivide` ([NCLeftDivide](#ncleftdivide)): function used to divide a vector by an entry on the left;
- `Dot` (`NCDot`): function used to multiply vectors and matrices;
- `CompletePivoting` ([NCLUCompletePivoting](#nclucompletepivoting)): function used to sort rows for complete pivoting;
- `PartialPivoting` ([NCLUPartialPivoting](#nclupartialpivoting)): function used to sort matrices for complete pivoting;
- `Inverse` ([NCLUInverse](#ncluinverse)): function used to invert 2x2 diagonal blocks;
- `SelfAdjointMatrixQ` ([NCSelfAdjointQ](#ncselfadjointq)): function to test if matrix is self-adjoint;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also: [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting).

### NCUpperTriangularSolve

`NCUpperTriangularSolve` is a noncommutative version of [UpperTriangularSolve](#uppertriangularsolve).

See also: [UpperTriangularSolve](#uppertriangularsolve).

### NCLowerTriangularSolve

`NCLowerTriangularSolve` is a noncommutative version of [LowerTriangularSolve](#lowertriangularsolve).

See also: [LowerTriangularSolve](#lowertriangularsolve).

### NCLUInverse

`NCLUInverse` is a noncommutative version of [LUInverse](#luinverse).

See also: [LUInverse](#luinverse).

### NCLUPartialPivoting

`NCLUPartialPivoting` is a noncommutative version of [LUPartialPivoting](#lupartialpivoting).

See also: [LUPartialPivoting](#lupartialpivoting).

### NCLUCompletePivoting

`NCLUCompletePivoting` is a noncommutative version of [LUCompletePivoting](#lucompletepivoting).

See also: [LUCompletePivoting](#lucompletepivoting).

### NCLeftDivide

`NCLeftDivide[x,y]` divides each entry of the list `y` by `x` on the left.

For example:

    NCLeftDivide[x, {a,b,c}]

returns

    {inv[x]**a, inv[x]**b, inv[x]**c}

See also: [NCRightDivide](#ncrightdivide).

### NCRightDivide

`NCRightDivide[x,y]` divides each entry of the list `x` by `y` on the right.

For example:

    NCRightDivide[{a,b,c}, y]

returns

    {a**inv[y], b**inv[y], c**inv[y]}

See also: [NCLeftDivide](#ncleftdivide).

## MatrixDecompositions: linear algebra templates

`MatrixDecompositions` is a package that implements various linear
algebra algorithms, such as *LU Decomposition* with *partial* and
*complete pivoting*, and *LDL Decomposition*. The algorithms have been
written with correctness and ease of customization rather than
efficiency as the main goals. They were originally developed to serve
as the core of the noncommutative linear algebra algorithms for
[NCAlgebra](http://math.ucsd.edu/~ncalg).

See the package
[NCMatrixDecompositions](#ncmatrixdecompositions) for
noncommutative versions of these algorithms.

Members are:

- Decompositions
  - [LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting)
  - [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting)
  - [LDLDecomposition](#ldldecomposition)
  - [LURowReduce](#lurowreduce)
  - [LURowReduceIncremental](#lurowreduceincremental)
- Solvers
  - [LowerTriangularSolve](#lowertriangularsolve)
  - [UpperTriangularSolve](#uppertriangularsolve)
  - [LUInverse](#luinverse)
- Utilities
  - [GetLUMatrices](#getlumatrices)
  - [GetFullLUMatrices](#getfulllumatrices)
  - [GetLDUMatrices](#getldumatrices)
  - [GetFullLDUMatrices](#getfullldumatrices)
  - [GetDiagonal](#getdiagonal)
  - [LUPartialPivoting](#lupartialpivoting)
  - [LUCompletePivoting](#lucompletepivoting)

### LUDecompositionWithPartialPivoting

`LUDecompositionWithPartialPivoting[m]` generates a representation of the LU decomposition of the rectangular matrix `m`.

`LUDecompositionWithPartialPivoting[m, options]` uses `options`.

`LUDecompositionWithPartialPivoting` returns a list of two elements:

- the first element is a combination of upper- and lower-triangular matrices;
- the second element is a vector specifying rows used for pivoting.

`LUDecompositionWithPartialPivoting` is similar in functionality with the built-in `LUDecomposition`. It implements a *partial pivoting* strategy in which the sorting can be configured using the options listed below. It also applies to general rectangular matrices as well as square matrices.

The triangular factors are recovered using [GetLUMatrices](#getlumatrices) or [GetFullLUMatrices](#getfulllumatrices).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` (`Divide`): function used to divide a vector by an entry;
- `Dot` (`Dot`): function used to multiply vectors and matrices;
- `Pivoting` ([LUPartialPivoting](#lupartialpivoting)): function used to sort rows for pivoting;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting), [GetLUMatrices](#getlumatrices), [GetFullLUMatrices](#getfulllumatrices), [LUPartialPivoting](#lupartialpivoting).

### LUDecompositionWithCompletePivoting

`LUDecompositionWithCompletePivoting[m]` generates a representation of the LU decomposition of the rectangular matrix `m`.

`LUDecompositionWithCompletePivoting[m, options]` uses `options`.

`LUDecompositionWithCompletePivoting` returns a list of four elements:

- the first element is a combination of upper- and lower-triangular matrices;
- the second element is a vector specifying rows used for pivoting;
- the third element is a vector specifying columns used for pivoting;
- the fourth element is the rank of the matrix.

`LUDecompositionWithCompletePivoting` implements a *complete pivoting* strategy in which the sorting can be configured using the options listed below. It also applies to general rectangular matrices as well as square matrices.

The triangular factors are recovered using [GetLUMatrices](#getlumatrices) or [GetFullLUMatrices](#getfulllumatrices).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `Divide` (`Divide`): function used to divide a vector by an entry;
- `Dot` (`Dot`): function used to multiply vectors and matrices;
- `Pivoting` ([LUCompletePivoting](#lucompletepivoting)): function used to sort rows for pivoting;

See also:
LUDecomposition, [GetLUMatrices](#getlumatrices), [GetFullLUMatrices](#getfulllumatrices), [LUCompletePivoting](#lucompletepivoting), [LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting).

### LDLDecomposition

`LDLDecomposition[m]` generates a representation of the LDL decomposition of the symmetric or self-adjoint matrix `m`.

`LDLDecomposition[m, options]` uses `options`.

`LDLDecomposition` returns a list of four elements:

- the first element is a combination of upper- and lower-triangular matrices;
- the second element is a vector specifying rows and columns used for pivoting;
- the third element is a vector specifying the size of the diagonal blocks (entries can be either 1 or 2);
- the fourth element is the rank of the matrix.

`LUDecompositionWithCompletePivoting` implements a *Bunch-Parlett pivoting* strategy in which the sorting can be configured using the options listed below. It applies only to square symmetric or self-adjoint matrices.

The triangular factors are recovered using [GetLDUMatrices](#getldumatrices) or [GetFullLDUMatrices](#getfullldumatrices).

The following `options` can be given:

- `ZeroTest` (`PossibleZeroQ`): function used to decide if a pivot is zero;
- `RightDivide` (`Divide`): function used to divide a vector by an entry on the right;
- `LeftDivide` (`Divide`): function used to divide a vector by an entry on the left;
- `Dot` (`Dot`): function used to multiply vectors and matrices;
- `CompletePivoting` ([LUCompletePivoting](#lucompletepivoting)): function used to sort rows for complete pivoting;
- `PartialPivoting` ([LUPartialPivoting](#lupartialpivoting)): function used to sort matrices for complete pivoting;
- `Inverse` (`Inverse`): function used to invert 2x2 diagonal blocks;
- `SelfAdjointMatrixQ` (HermitianQ): function to test if matrix is self-adjoint;
- `SuppressPivoting` (`False`): whether to perform pivoting or not.

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting), [GetLUMatrices](#getlumatrices), [GetFullLDUMatrices](#getfullldumatrices), [LUCompletePivoting](#lucompletepivoting), [LUPartialPivoting](#lupartialpivoting).

### UpperTriangularSolve

`UpperTriangularSolve[u, b]` solves the upper-triangular system of
equations ![u x = b](https://render.githubusercontent.com/render/math?math=u%20x%20%3D%20b&mode=inline) using back-substitution.

For example:

    x = UpperTriangularSolve[u, b];

returns the solution `x`.

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting), [LDLDecomposition](#ldldecomposition).

### LowerTriangularSolve

`LowerTriangularSolve[l, b]` solves the lower-triangular system of
equations ![l x = b](https://render.githubusercontent.com/render/math?math=l%20x%20%3D%20b&mode=inline) using forward-substitution.

For example:

    x = LowerTriangularSolve[l, b];

returns the solution `x`.

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting), [LDLDecomposition](#ldldecomposition).

### LUInverse

`LUInverse[a]` calculates the inverse of matrix `a`.

`LUInverse` uses the [LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting) and the triangular solvers [LowerTriangularSolve](#lowertriangularsolve) and [UpperTriangularSolve](#uppertriangularsolve).

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting).

### GetLUMatrices

`GetLUMatrices[lu]` extracts lower- and upper-triangular blocks produced by `LDUDecompositionWithPartialPivoting` and `LDUDecompositionWithCompletePivoting`.

`GetLUMatrices[lu, p, q, rank]` extracts compact lower- and upper-triangular blocks produced by `LDUDecompositionWithPartialPivoting` and `LDUDecompositionWithCompletePivoting` taking into account permutations and the matrix rank.

For example:

    {lu, p} = LUDecompositionWithPartialPivoting[mat];
    {l, u} = GetLUMatrices[lu];

and

    {lu, p, q, rank} = LUDecompositionWithCompletePivoting[mat];
    {l, u} = GetLUMatrices[lu, p, q, rank];

returns the lower-triangular factor `l` and upper-triangular factor `u` as `SparseArray`s.

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting), [GetFullLUMatrices](#getfulllumatrices).

### GetFullLUMatrices

`GetFullLUMatrices[m]` extracts lower- and upper-triangular blocks produced by `LDUDecompositionWithPartialPivoting` and `LDUDecompositionWithCompletePivoting`.

`GetFullLUMatrices[lu, p, q, rank]` extracts compact lower- and upper-triangular blocks produced by `LDUDecompositionWithPartialPivoting` and `LDUDecompositionWithCompletePivoting` taking into account permutations and the matrix rank.

`GetFullLUMatrices` is equivalent to `Normal @@ GetLUMatrices`

See also:
[GetLUMatrices](#getlumatrices),
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting).

### GetLDUMatrices

`GetLDUMatrices[ldu, s]` extracts lower-, upper-triangular and diagonal blocks produced by `LDLDecomposition`.

`GetLDUMatrices[ldu, p, s, rank]` extracts compact lower- and upper-triangular blocks produced by `LDLDecomposition` taking into account permutations and the matrix rank.

For example:

    {ldl, p, s, rank} = LDLDecomposition[mat];
    {l,d,u} = GetLDUMatrices[ldl,s];

and

    {l, d, u} = GetLDUMatrices[ldl, p, s, rank];

returns the lower-triangular factor `l`, the upper-triangular factor `u`, and the block-diagonal factor `d` as `SparseArray`s.

See also:
[LDLDecomposition](#ldldecomposition), [GetFullLDUMatrices](#getfullldumatrices).

### GetFullLDUMatrices

`GetLDUMatrices[ldl, s]` extracts lower-, upper-triangular and diagonal blocks produced by `LDLDecomposition`.

`GetLDUMatrices[ldu, p, s, rank]` extracts compact lower- and upper-triangular blocks produced by `LDLDecomposition` taking into account permutations and the matrix rank.

`GetFullLDUMatrices` is equivalent to `Normal @@ GetLDUMatrices`

See also:
[LDLDecomposition](#ldldecomposition), [GetLDUMatrices](#getldumatrices).

### GetDiagonal

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

See also:
[LDLDecomposition](#ldldecomposition).

### LUPartialPivoting

`LUPartialPivoting[v]` returns the index of the element with largest absolute value in the vector `v`. If `v` is a matrix, it returns the index of the element with largest absolute value in the first column.

`LUPartialPivoting[v, f]` sorts with respect to the function `f` instead of the absolute value.

See also:
[LUDecompositionWithPartialPivoting](#ludecompositionwithpartialpivoting), [LUCompletePivoting](#lucompletepivoting).

### LUCompletePivoting

`LUCompletePivoting[m]` returns the row and column index of the element with largest absolute value in the matrix `m`.

`LUCompletePivoting[v, f]` sorts with respect to the function `f` instead of the absolute value.

See also:
[LUDecompositionWithCompletePivoting](#ludecompositionwithcompletepivoting), [LUPartialPivoting](#lupartialpivoting).

### LURowReduce

### LURowReduceIncremental

# Packages for pretty output, testing, and utilities

## NCOutput

**NCOutput** is a package that can be used to beautify the display of
noncommutative expressions. NCOutput does not alter the internal
representation of nc expressions, just the way they are displayed on
the screen.

Members are:

- [NCSetOutput](#ncsetoutput)

### NCSetOutput

`NCSetOutput[options]` controls the display of expressions in a special format without affecting the internal representation of the expression.

The following `options` can be given:

- `NonCommutativeMultiply` (`False`): If `True` `x**y` is displayed as ‘![\mathrm{x} \bullet \mathrm{y}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%20%5Cbullet%20%5Cmathrm%7By%7D&mode=inline)’;
- `tp` (`True`): If `True` `tp[x]` is displayed as ‘![\mathrm{x}^\mathrm{T}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%5Cmathrm%7BT%7D&mode=inline)’;
- `inv` (`True`): If `True` `inv[x]` is displayed as ‘![\mathrm{x}^{-1}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%7B-1%7D&mode=inline)’;
- `aj` (`True`): If `True` `aj[x]` is displayed as ‘![\mathrm{x}^\*](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%2A&mode=inline)’;
- `co` (`True`): If `True` `co[x]` is displayed as ‘![\bar{\mathrm{x}}](https://render.githubusercontent.com/render/math?math=%5Cbar%7B%5Cmathrm%7Bx%7D%7D&mode=inline)’;
- `rt` (`True`): If `True` `rt[x]` is displayed as ‘![\mathrm{x}^{1/2}](https://render.githubusercontent.com/render/math?math=%5Cmathrm%7Bx%7D%5E%7B1/2%7D&mode=inline)’.
- `All`: Set all available options to `True` or `False`.

See also:
[NCTex](#nctex-1),
[NCTexForm](#nctexform-1).

## NCTeX

Members are:

- [NCTeX](#nctex-1)
- [NCRunDVIPS](#ncrundvips)
- [NCRunLaTeX](#ncrunlatex)
- [NCRunPDFLaTeX](#ncrunpdflatex)
- [NCRunPDFViewer](#ncrunpdfviewer)
- [NCRunPS2PDF](#ncrunps2pdf)

### NCTeX

`NCTeX[expr]` typesets the LaTeX version of `expr` produced with TeXForm or NCTeXForm using LaTeX.

### NCRunDVIPS

`NCRunDVIPS[file]` run dvips on `file`. Produces a ps output.

### NCRunLaTeX

`NCRunLaTeX[file]` typesets the LaTeX `file` with latex. Produces a dvi output.

### NCRunPDFLaTeX

`NCRunLaTeX[file]` typesets the LaTeX `file` with pdflatex. Produces a pdf output.

### NCRunPDFViewer

`NCRunPDFViewer[file]` display pdf `file`.

### NCRunPS2PDF

`NCRunPS2PDF[file]` run pd2pdf on `file`. Produces a pdf output.

## NCTeXForm

Members are:

- [NCTeXForm](#nctexform-1)
- [NCTeXFormSetStarStar](#nctexformsetstarstar)

### NCTeXForm

`NCTeXForm[expr]` prints a LaTeX version of `expr`.

The format is compatible with AMS-LaTeX.

Should work better than the Mathematica `TeXForm` :)

### NCTeXFormSetStarStar

`NCTeXFormSetStarStar[string]` replaces the standard ‘\*\*’ for `string`
in noncommutative multiplications.

For example:

    NCTeXFormSetStarStar["."]

uses a dot (`.`) to replace `NonCommutativeMultiply`(`**`).

See also:
[NCTeXFormSetStar](#nctexformsetstar).

### NCTeXFormSetStar

`NCTeXFormSetStar[string]` replaces the standard ‘\*’ for `string`
in noncommutative multiplications.

For example:

    NCTeXFormSetStar[" "]

uses a space (\``) to replace`Times`(`\*\`).

[NCTeXFormSetStarStar](#nctexformsetstarstar).

## NCRun

Members are:

- [NCRun](#ncrun-1)

### NCRun

`NCRun[command]` is a replacement for the built-in `Run` command that gives a
bit more control over the execution process.

`NCRun[command, options]` uses `options`.

The following `options` can be given:

- `Verbose` (`True`): print information on command being run;
- `CommandPrefix` (`""`): prefix to `command`;

See also: `Run`.

## NCTest

These are commands for automatically testing if our algorithms produce
the correct answer. Problems and answers are stored under the
directory `NC/TESTING`.

Members are:

- [NCTest](#nctest-1)
- [NCTestCheck](#nctestcheck)
- [NCTestRun](#nctestrun)
- [NCTestSummarize](#nctestsummarize)

### NCTest

`NCTest[expr,answer]` asserts whether `expr` is equal to `answer`. The result of the test is collected when `NCTest` is run from `NCTestRun`.

See also:
[NCTestCheck](#nctestcheck),
[NCTestRun](#nctestrun),
[NCTestSummarize](#nctestsummarize).

### NCTestCheck

`NCTestCheck[expr,messages]` evaluates `expr` and asserts that the messages in `messages` have been issued. The result of the test is collected when `NCTest` is run from `NCTestRun`.

`NCTestCheck[expr,answer,messages]` also asserts whether `expr` is equal to `answer`.

`NCTestCheck[expr,answer,messages,quiet]` quiets messages in `quiet`.

See also:
[NCTest](#nctest-1),
[NCTestRun](#nctestrun),
[NCTestSummarize](#nctestsummarize).

### NCTestRun

`NCTest[list]` runs the test files listed in `list` after appending
the ‘.NCTest’ suffix and return the results.

For example:

    results = NCTestRun[{"NCCollect", "NCSylvester"}]

will run the test files “NCCollect.NCTest” and “NCSylvester.NCTest” and return the results in `results`.

See also:
[NCTest](#nctest-1),
[NCTestCheck](#nctestcheck),
[NCTestSummarize](#nctestsummarize).

### NCTestSummarize

`NCTestSummarize[results]` will print a summary of the results in `results` as produced by `NCTestRun`.

See also:
[NCTestRun](#nctestrun).

## NCDebug

Members are:

- [NCDebug](#ncdebug-1)

### NCDebug

`NCDebug[level, message]` prints the objects `message` if level is higher than the current `DebugLevel` option.

Use `SetOptions[NCDebug, DebugLevel -> level]` to set up the current
debug level.

Available options are:

- `DebugLevel` (0): current debug level;
- `DebugLogFile` (`$Ouput`): current file to which messages are printed.

## NCUtil

**NCUtil** is a package with a collection of utilities used throughout NCAlgebra.

Members are:

- [NCGrabSymbols](#ncgrabsymbols)
- [NCGrabNCSymbols](#ncgrabncsymbols)
- [NCGrabFunctions](#ncgrabfunctions)
- [NCGrabIndeterminants](#ncgrabindeterminants)
- [NCVariables](#ncvariables)
- [NCConsolidateList](#ncconsolidatelist)
- [NCConsistentQ](#ncconsistentq)
- [NCSymbolOrSubscriptQ](#ncsymbolorsubscriptq)
- [NCSymbolOrSubscriptExtendedQ](#ncsymbolorsubscriptextendedq)
- [NCLeafCount](#ncleafcount)
- [NCReplaceData](#ncreplacedata)
- [NCToExpression](#nctoexpression)
- [NotMatrixQ](#notmatrixq)

### NCGrabSymbols

`NCGrabSymbols[expr]` returns a list with all *Symbols* appearing in
`expr`.

`NCGrabSymbols[expr,f]` returns a list with all *Symbols* appearing in
`expr` as the single argument of function `f`.

For example:

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]]]

returns `{x,y}` and

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]], inv]

returns `{inv[x]}`.

See also:
[NCGrabFunctions](#ncgrabfunctions),
[NCGrabNCSymbols](#ncgrabncsymbols).

### NCGrabNCSymbols

`NCGrabSymbols[expr]` returns a list with all NC *Symbols* appearing
in `expr`.

`NCGrabSymbols[expr,f]` returns a list with all NC *Symbols* appearing
in `expr` as the single argument of function `f`.

See also:
[NCGrabSymbols](#ncgrabsymbols),
[NCGrabFunctions](#ncgrabfunctions).

### NCGrabFunctions

`NCGrabFunctions[expr]` returns a list with all fragments of `expr`
containing functions.

`NCGrabFunctions[expr,f]` returns a list with all fragments of `expr`
containing the function `f`.

For example:

    NCGrabFunctions[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]], inv]

returns

    {inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x]}

and

    NCGrabFunctions[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x], tp[x], tp[y]}

See also:
[NCGrabSymbols](#ncgrabsymbols).

### NCGrabIndeterminants

`NCGrabIndeterminants[expr]` returns a list with first level symbols
and nc expressions involved in sums and nc products in `expr`.

For example:

    NCGrabIndeterminants[y - inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {y, inv[x], inv[1 + inv[1 + tp[x] ** y]], tp[y]}

See also:
[NCGrabFunctions](#ncgrabfunctions), [NCGrabSymbols](#ncgrabsymbols).

### NCVariables

`NCVariables[expr]` gives a list of all independent nc variables in the
expression `expr`.

For example:

    NCVariables[B + A y ** x ** y - 2 x]

returns

    {x,y}

See also:
[NCGrabSymbols](#ncgrabsymbols).

### NCConsolidateList

`NCConsolidateList[list]` produces two lists:

- The first list contains a version of `list` where repeated entries
  have been suppressed;
- The second list contains the indices of the elements in the first
  list that recover the original `list`.

For example:

    {list,index} = NCConsolidateList[{z,t,s,f,d,f,z}];

results in:

    list = {z,t,s,f,d};
    index = {1,2,3,4,5,4,1};

See also:
`Union`

### NCConsistentQ

`NCConsistentQ[expr]` returns *True* is `expr` contains no commutative
products or inverses involving noncommutative variables.

### NCSymbolOrSubscriptQ

`NCSymbolOrSubscriptQ[expr]` returns *True* if `expr` is a symbol or a
symbol subscript.

See also:
[NCSymbolOrSubscriptExtendedQ](#ncsymbolorsubscriptextendedq),
[NCNonCommutativeSymbolOrSubscriptQ](#ncnoncommutativesymbolorsubscriptq),
[NCNonCommutativeSymbolOrSubscriptExtendedQ](#ncnoncommutativesymbolorsubscriptextendedq),
[NCPowerQ](#ncpowerq).

### NCSymbolOrSubscriptExtendedQ

`NCSymbolOrSubscriptExtendedQ[expr]` returns *True* if `expr` is a
symbol, a symbol subscript, or the transpose (`tp`) or adjoint (`aj`)
of a symbol or symbol subscript.

See also:
[NCSymbolOrSubscriptQ](#ncsymbolorsubscriptq),
[NCNonCommutativeSymbolOrSubscriptQ](#ncnoncommutativesymbolorsubscriptq),
[NCNonCommutativeSymbolOrSubscriptExtendedQ](#ncnoncommutativesymbolorsubscriptextendedq),
[NCPowerQ](#ncpowerq).

### NCLeafCount

`NCLeafCount[expr]` returns an number associated with the complexity
of an expression:

- If `PossibleZeroQ[expr] == True` then `NCLeafCount[expr]` is `-Infinity`;
- If `NumberQ[expr]] == True` then `NCLeafCount[expr]` is `Abs[expr]`;
- Otherwise `NCLeafCount[expr]` is `-LeafCount[expr]`;

`NCLeafCount` is `Listable`.

See also:
`LeafCount`.

### NCReplaceData

`NCReplaceData[expr, rules]` applies `rules` to `expr` and convert
resulting expression to standard Mathematica, for example replacing
`**` by `.`.

`NCReplaceData` does not attempt to resize entries in expressions
involving matrices. Use `NCToExpression` for that.

See also:
[NCToExpression](#nctoexpression).

### NCToExpression

`NCToExpression[expr, rules]` applies `rules` to `expr` and convert
resulting expression to standard Mathematica.

`NCToExpression` attempts to resize entries in expressions involving
matrices.

See also:
[NCReplaceData](#ncreplacedata).

### NotMatrixQ

`NotMatrixQ[expr]` is equivalent to `Not[MatrixQ[expr]]`.

See also:
`MatrixQ`.

# Data structures for fast calculations

This chapter describes packages that handle special data structures
that enable fast calculations in Mathematica.

## NCPoly

### Efficient storage of NC polynomials with rational coefficients

Members are:

- Constructors
  - [NCPoly](#ncpoly-1)
  - [NCPolyMonomial](#ncpolymonomial)
  - [NCPolyConstant](#ncpolyconstant)
  - [NCPolyConvert](#ncpolyconvert)
  - [NCPolyFromCoefficientArray](#ncpolyfromcoefficientarray)
  - [NCPolyFromGramMatrix](#ncpolyfromgrammatrix)
  - [NCPolyFromGramMatrixFactors](#ncpolyfromgrammatrixfactors)
- Access and utilities
  - [NCPolyMonomialQ](#ncpolymonomialq)
  - [NCPolyDegree](#ncpolydegree)
  - [NCPolyPartialDegree](#ncpolypartialdegree)
  - [NCPolyMonomialDegree](#ncpolymonomialdegree)
  - [NCPolyNumberOfVariables](#ncpolynumberofvariables)
  - [NCPolyNumberOfTerms](#ncpolynumberofterms)
  - [NCPolyCoefficient](#ncpolycoefficient)
  - [NCPolyCoefficientArray](#ncpolycoefficientarray)
  - [NCPolyGramMatrix](#ncpolygrammatrix)
  - [NCPolyGetCoefficients](#ncpolygetcoefficients)
  - [NCPolyGetDigits](#ncpolygetdigits)
  - [NCPolyGetIntegers](#ncpolygetintegers)
  - [NCPolyLeadingMonomial](#ncpolyleadingmonomial)
  - [NCPolyLeadingTerm](#ncpolyleadingterm)
  - [NCPolyOrderType](#ncpolyordertype)
  - [NCPolyToRule](#ncpolytorule)
  - [NCPolyTermsOfDegree](#ncpolytermsofdegree)
  - [NCPolyTermsOfTotalDegree](#ncpolytermsoftotaldegree)
  - [NCPolyQuadraticTerms](#ncpolyquadraticterms)
  - [NCPolyQuadraticChipset](#ncpolyquadraticchipset)
  - [NCPolyReverseMonomials](#ncpolyreversemonomials)
  - [NCPolyGetOptions](#ncpolygetoptions)
- Formatting
  - [NCPolyDisplay](#ncpolydisplay)
  - [NCPolyDisplayOrder](#ncpolydisplayorder)
- Arithmetic
  - [NCPolyDivideDigits](#ncpolydividedigits)
  - [NCPolyDivideLeading](#ncpolydivideleading)
  - [NCPolyReduceRepeated](#ncpolyreducerepeated)
  - [NCPolyNormalize](#ncpolynormalize)
  - [NCPolyProduct](#ncpolyproduct)
  - [NCPolyQuotientExpand](#ncpolyquotientexpand)
  - [NCPolyReduce](#ncpolyreduce)
  - [NCPolySum](#ncpolysum)
- State space realization
  - [NCPolyHankelMatrix](#ncpolyhankelmatrix)
  - [NCPolyRealization](#ncpolyrealization) (#NCPolyRealization)
- Auxiliary functions
  - [NCPolyVarsToIntegers](#ncpolyvarstointegers)
  - [NCFromDigits](#ncfromdigits)
  - [NCIntegerDigits](#ncintegerdigits)
  - [NCIntegerReverse](#ncintegerreverse)
  - [NCDigitsToIndex](#ncdigitstoindex)
  - [NCPadAndMatch](#ncpadandmatch)

### Ways to represent NC polynomials

#### NCPoly

`NCPoly[coeff, monomials, vars]` constructs a noncommutative
polynomial object in variables `vars` where the monomials have
coefficient `coeff`.

Monomials are specified in terms of the symbols in the list `vars` as
in [NCPolyMonomial](#ncpolymonomial).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];

constructs an object associated with the noncommutative polynomial
![2 z - x y x](https://render.githubusercontent.com/render/math?math=2%20z%20-%20x%20y%20x&mode=inline) in variables `x`, `y` and `z`.

The internal representation varies with the implementation but it is
so that the terms are sorted according to a degree-lexicographic order
in `vars`. In the above example, `x < y < z`.

The construction:

    vars = {{x},{y,z}};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];

represents the same polyomial in a graded degree-lexicographic order
in `vars`, in this example, `x << y < z`.

See also:
[NCPolyMonomial](#ncpolymonomial),
[NCIntegerDigits](#ncintegerdigits),
[NCFromDigits](#ncfromdigits).

#### NCPolyMonomial

`NCPolyMonomial[monomial, vars]` constructs a noncommutative monomial
object in variables `vars`.

Monic monomials are specified in terms of the symbols in the list
`vars`, for example:

    vars = {x,y,z};
    mon = NCPolyMonomial[{x,y,x},vars];

returns an `NCPoly` object encoding the monomial ![xyx](https://render.githubusercontent.com/render/math?math=xyx&mode=inline) in
noncommutative variables `x`,`y`, and `z`. The actual representation
of `mon` varies with the implementation.

Monomials can also be specified implicitly using indices, for
example:

    mon = NCPolyMonomial[{0,1,0}, 3];

also returns an `NCPoly` object encoding the monomial ![xyx](https://render.githubusercontent.com/render/math?math=xyx&mode=inline) in
noncommutative variables `x`,`y`, and `z`.

If graded ordering is supported then

    vars = {{x},{y,z}};
    mon = NCPolyMonomial[{x,y,x},vars];

or

    mon = NCPolyMonomial[{0,1,0}, {1,2}];

construct the same monomial ![xyx](https://render.githubusercontent.com/render/math?math=xyx&mode=inline) in noncommutative variables
`x`,`y`, and `z` this time using a graded order in which `x << y < z`.

There is also an alternative syntax for `NCPolyMonomial` that allows
users to input the monomial along with a coefficient using rules and
the output of [NCFromDigits](#ncfromdigits). For example:

    mon = NCPolyMonomial[{3, 3} -> -2, 3];

or

    mon = NCPolyMonomial[NCFromDigits[{0,1,0}, 3] -> -2, 3];

represent the monomial ![-2 xyx](https://render.githubusercontent.com/render/math?math=-2%20xyx&mode=inline) that has coefficient `-2`.

See also:
[NCPoly](#ncpoly-1),
[NCIntegerDigits](#ncintegerdigits),
[NCFromDigits](#ncfromdigits).

#### NCPolyConstant

`NCPolyConstant[value, vars]` constructs a noncommutative monomial
object in variables `vars` representing the constant `value`.

For example:

    NCPolyConstant[3, {x, y, z}]

constructs an object associated with the constant `3` in variables
`x`, `y` and `z`.

See also:
[NCPoly](#ncpoly-1),
[NCPolyMonomial](#ncpolymonomial).

#### NCPolyConvert

`NCPolyConvert[poly, vars]` convert NCPoly `poly` to the ordering implied by `vars`.

For example, if

    vars1 = {{x, y, z}};
    coeff = {1, 2, 3, -1, -2, -3, 1/2};
    mon = {{}, {x}, {z}, {x, y}, {x, y, x, x}, {z, x}, {z, z, z, z}};
    poly1 = NCPoly[coeff, mon, vars1];

with respect to the ordering

![x \ll y \ll z](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%5Cll%20z&mode=inline)

then

    vars2 = {{x},{y,z}};
    poly2 = NCPolyConvert[poly, vars];

is the same polynomial as `poly1` but in the ordering

![x \ll y \< z](https://render.githubusercontent.com/render/math?math=x%20%5Cll%20y%20%3C%20z&mode=inline)

See also:
[NCPoly](#ncpoly-1),
[NCPolyCoefficient](#ncpolycoefficient).

#### NCPolyFromCoefficientArray

`NCPolyFromCoefficientArray[mat, vars]` returns an `NCPoly` constructed from the coefficient array `mat` in variables `vars`.

For example, for `mat` equal to the `SparseArray` corresponding to the rules:

    {{1} -> 1, {2} -> 2, {6} -> -1, {50} -> -2, {4} -> 3, {11} -> -3, {121} -> 1/2}

the commands

    vars = {{x},{y,z}};
    NCPolyFromCoefficientArray[mat, vars]

return

    NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {0, 1, 0} -> 2, {1, 0, 2} -> 3, {1, 1, 1} -> -1,
           {1, 1, 6} -> -3, {1, 3, 9} -> -2, {4, 0, 80} -> 1/2|>]

See also:
[NCPolyCoefficientArray](#ncpolycoefficientarray),
[NCPolyCoefficient](#ncpolycoefficient).

#### NCPolyFromGramMatrix

`NCPolyFromGramMatrix[mat, vars]` returns an `NCPoly` constructed from the Gram matrix `mat` in variables `vars`.

For example, for `mat` equal to the `SparseArray` corresponding to the rules:

    {{1, 1} -> 1, {2, 1} -> 2, {2, 3} -> -1, {4, 1} -> 3, {4, 2} -> -3, {6, 5} -> -2, {13, 13} -> 1/2}

the commands

    vars = {{x},{y,z}};
    NCPolyFromGramMatrix[mat, vars]

return

    NCPoly[{1, 2}, <|{0, 0, 0} -> 1, {0, 1, 0} -> 2, {1, 0, 2} -> 3, {1, 1, 1} -> -1,
           {1, 1, 6} -> -3, {1, 3, 9} -> -2, {4, 0, 80} -> 1/2|>]

See also:
[NCPolyGramMatrix](#ncpolygrammatrix),
[NCPolyFromGramMatrixFactors](#ncpolyfromgrammatrixfactors).

#### NCPolyFromGramMatrixFactors

`NCPolyFromGramMatrixFactors[lmat, rmat, vars]` returns two lists of `NCPoly`s constructed from the factors of the Gram matrix `lmat` and `rmat` in variables `vars`.

For example, for `mat = lmat . rmat` in which the factors `lmat` and `rmat` are `SparseArray`s corresponding to the rules:

    {{1, 3} -> 1/2, {1, 5} -> 1, {2, 3} -> 1, {4, 1} -> 1, {6, 2} -> 1, {13, 4} -> 1}
    {{1, 2} -> -3, {1, 1} -> 3, {2, 5} -> -2, {3, 1} -> 2, {3, 3} -> -1, {4, 13} -> 1/2, {5, 3} -> 1/2}

and commands

    vars = {{x},{y,z}};
    {lpoly, rpoly} = NCPolyFromGramMatrixFactors[lmat, rmat, vars]

return `lpoly` equal to the list of polynomials

    {NCPoly[{1, 2}, <|{1, 0, 1} -> 1|>], NCPoly[{1, 2}, <|{1, 1, 6} -> 1|>], NCPoly[{1, 2}, <|{0, 0, 0} -> 1/2, {1, 0, 2} -> 1|>], NCPoly[{1, 2}, <|{2, 0, 4} -> 1|>], NCPoly[{1, 2}, <|{0, 0, 0} -> 1|>]},

and `rpoly` equal to

    {NCPoly[{1, 2}, <|{0, 0, 0} -> 3, {1, 0, 2} -> -3|>], NCPoly[{1, 2}, <|{2, 0, 7} -> -2|>], NCPoly[{1, 2}, <|{0, 0, 0} -> 2, {0, 1, 0} -> -1|>], NCPoly[{1, 2}, <|{2, 0, 4} -> 1/2|>], NCPoly[{1, 2}, <|{0, 1, 0} -> 1/2|>]}}

See also:
[NCPolyFromGramMatrix](#ncpolyfromgrammatrix),
[NCPolyGramMatrix](#ncpolygrammatrix).

### Access and utlity functions

#### NCPolyMonomialQ

`NCPolyMonomialQ[poly]` returns `True` if `poly` is a `NCPoly` monomial.

See also:
[NCPoly](#ncpoly-1),
[NCPolyMonomial](#ncpolymonomial).

#### NCPolyDegree

`NCPolyDegree[poly]` returns the degree of the nc polynomial `poly`.

See also:
[NCPolyPartialDegree](#ncpolypartialdegree)

#### NCPolyPartialDegree

`NCPolyPartialDegree[poly]` returns the maximum degree appearing in the monomials of the nc polynomial `poly`.

See also:
[NCPolyDegree](#ncpolydegree)

#### NCPolyMonomialDegree

`NCPolyMonomialDegree[poly]` returns the partial degree of each symbol appearing in the monomials of the nc polynomial `poly`.

See also:
[NCPolyDegree](#ncpolydegree)

#### NCPolyNumberOfVariables

`NCPolyNumberOfVariables[poly]` returns the number of variables of the
nc polynomial `poly`.

#### NCPolyNumberOfTerms

`NCPolyNumberOfTerms[poly]` returns the number of terms of the
nc polynomial `poly`.

#### NCPolyCoefficient

`NCPolyCoefficient[poly, mon]` returns the coefficient of the monomial
`mon` in the nc polynomial `poly`.

For example, in:

    coeff = {1, 2, 3, -1, -2, -3, 1/2};
    mon = {{}, {x}, {z}, {x, y}, {x, y, x, x}, {z, x}, {z, z, z, z}};
    vars = {x,y,z};
    poly = NCPoly[coeff, mon, vars];

    c = NCPolyCoefficient[poly, NCPolyMonomial[{x,y},vars]];

returns

    c = -1

See also:
[NCPoly](#ncpoly-1),
[NCPolyMonomial](#ncpolymonomial).

#### NCPolyCoefficientArray

`NCPolyCoefficientArray[poly]` returns a coefficient array corresponding to the monomials in the nc polynomial `poly`.

For example:

    coeff = {1, 2, 3, -1, -2, -3, 1/2};
    mon = {{}, {x}, {z}, {x, y}, {x, y, x, x}, {z, x}, {z, z, z, z}};
    vars = {x,y,z};
    poly = NCPoly[coeff, mon, vars];

    mat = NCPolyCoefficient[poly];

returns `mat` as a `SparseArray` corresponding to the rules:

    {{1} -> 1, {2} -> 2, {6} -> -1, {50} -> -2, {4} -> 3, {11} -> -3, {121} -> 1/2}

See also:
[NCPolyFromCoefficientArray](#ncpolyfromcoefficientarray),
[NCPolyCoefficient](#ncpolycoefficient).

#### NCPolyGramMatrix

`NCPolyGramMatrix[poly]` returns a Gram matrix corresponding to the monomials in the nc polynomial `poly`.

For example:

    coeff = {1, 2, 3, -1, -2, -3, 1/2};
    mon = {{}, {x}, {z}, {x, y}, {x, y, x, x}, {z, x}, {z, z, z, z}};
    vars = {x,y,z};
    poly = NCPoly[coeff, mon, vars];

    mat = NCPolyGramMatrix[poly];

returns `mat` as a `SparseArray` corresponding to the rules:

    {{1, 1} -> 1, {2, 1} -> 2, {2, 3} -> -1, {4, 1} -> 3, {4, 2} -> -3, {6, 5} -> -2, {13, 13} -> 1/2}

See also:
[NCPolyFromGramMatrix](#ncpolyfromgrammatrix).

#### NCPolyGetCoefficients

`NCPolyGetCoefficients[poly]` returns a list with the coefficients of
the monomials in the nc polynomial `poly`.

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    coeffs = NCPolyGetCoefficients[poly];

returns

    coeffs = {2,-1}

The coefficients are returned according to the current graded
degree-lexicographic ordering, in this example `x < y < z`.

See also:
[NCPolyGetDigits](#ncpolygetdigits),
[NCPolyCoefficient](#ncpolycoefficient),
[NCPoly](#ncpoly-1).

#### NCPolyGetDigits

`NCPolyGetDigits[poly]` returns a list with the digits that encode the
monomials in the nc polynomial `poly` as produced by
[NCIntegerDigits](#ncintegerdigits).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    digits = NCPolyGetDigits[poly];

returns

    digits = {{2}, {0,1,0}}

The digits are returned according to the current ordering, in
this example `x < y < z`.

See also:
[NCPolyGetCoefficients](#ncpolygetcoefficients),
[NCPoly](#ncpoly-1).

#### NCPolyGetIntegers

`NCPolyGetIntegers[poly]` returns a list with the digits that encode
the monomials in the nc polynomial `poly` as produced by
[NCFromDigits](#ncfromdigits).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    digits = NCPolyGetIntegers[poly];

returns

    digits = {{1,2}, {3,3}}

The digits are returned according to the current ordering, in
this example `x < y < z`.

See also:
[NCPolyGetCoefficients](#ncpolygetcoefficients),
[NCPoly](#ncpoly-1).

#### NCPolyLeadingMonomial

`NCPolyLeadingMonomial[poly]` returns an `NCPoly` representing the
leading term of the nc polynomial `poly`.

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    lead = NCPolyLeadingMonomial[poly];

returns an `NCPoly` representing the monomial ![x y x](https://render.githubusercontent.com/render/math?math=x%20y%20x&mode=inline). The leading
monomial is computed according to the current ordering, in this
example `x < y < z`. The actual representation of `lead` varies with
the implementation.

See also:
[NCPolyLeadingTerm](#ncpolyleadingterm),
[NCPolyMonomial](#ncpolymonomial),
[NCPoly](#ncpoly-1).

#### NCPolyLeadingTerm

`NCPolyLeadingTerm[poly]` returns a rule associated with the leading
term of the nc polynomial `poly` as understood by
[NCPolyMonomial](#ncpolymonomial).

For example:

    vars = {x,y,z};
    poly = NCPoly[{-1, 2}, {{x,y,x}, {z}}, vars];
    lead = NCPolyLeadingTerm[poly];

returns

    lead = {3,3} -> -1

representing the monomial ![- x y x](https://render.githubusercontent.com/render/math?math=-%20x%20y%20x&mode=inline). The leading monomial is computed
according to the current ordering, in this example `x < y < z`.

See also:
[NCPolyLeadingMonomial](#ncpolyleadingmonomial),
[NCPolyMonomial](#ncpolymonomial),
[NCPoly](#ncpoly-1).

#### NCPolyOrderType

`NCPolyOrderType[poly]` returns the type of monomial order in which
the nc polynomial `poly` is stored. Order can be `NCPolyGradedDegLex`
or `NCPolyDegLex`.

See also:
[NCPoly](#ncpoly-1),

#### NCPolyToRule

`NCPolyToRule[poly]` returns a `Rule` associated with polynomial
`poly`. If `poly = lead + rest`, where `lead` is the leading term in
the current order, then `NCPolyToRule[poly]` returns the rule `lead -> -rest` where the coefficient of the leading term has been normalized
to `1`.

For example:

    vars = {x, y, z};
    poly = NCPoly[{-1, 2, 3}, {{x, y, x}, {z}, {x, y}}, vars];
    rule = NCPolyToRule[poly]

returns the rule `lead -> rest` where `lead` represents is the nc
monomial ![x y x](https://render.githubusercontent.com/render/math?math=x%20y%20x&mode=inline) and `rest` is the nc polynomial ![2 z + 3 x y](https://render.githubusercontent.com/render/math?math=2%20z%20%2B%203%20x%20y&mode=inline)

See also:
[NCPolyLeadingTerm](#ncpolyleadingterm),
[NCPolyLeadingMonomial](#ncpolyleadingmonomial),
[NCPoly](#ncpoly-1).

#### NCPolyTermsOfDegree

`NCPolyTermsOfDegree[p, d]` returns a polynomial `p` in which only the monomials with degree `d` are present. The degree `d` is a list with the partial degrees on each variable.

For example:

    vars = {x, y};
    poly = NCPoly[{1, 2, 3, 4}, {{x}, {x, y}, {y, x}, {x, x}}, vars];

corresponds to the polynomial ![x + 2 x y + 3 y x + 4 x^2](https://render.githubusercontent.com/render/math?math=x%20%2B%202%20x%20y%20%2B%203%20y%20x%20%2B%204%20x%5E2&mode=inline) and

    NCPolyTermsOfTotalDegree[p, {1,1}]

returns

    NCPoly[{1, 1}, {1, 1, 1} -> 2, {1, 1, 2} -> 3|>]

which corresponds to the polyomial ![2 x y + 3 y x](https://render.githubusercontent.com/render/math?math=2%20x%20y%20%2B%203%20y%20x&mode=inline). Likewise

    NCPolyTermsOfTotalDegree[p, {2,0}]

returns

    NCPoly[{1, 1}, {0, 2, 0} -> 4|>]

which corresponds to the polyomial ![4 x^2](https://render.githubusercontent.com/render/math?math=4%20x%5E2&mode=inline).

See also:
[NCPolyTermsOfTotalDegree](#ncpolytermsoftotaldegree).

#### NCPolyTermsOfTotalDegree

`NCPolyTermsOfTotalDegree[p, d]` returns a polynomial `p` in which only the monomials with total degree `d` are present. The degree `d` is an integer.

For example:

    vars = {x, y};
    poly = NCPoly[{1, 2, 3, 4}, {{x}, {x, y}, {y, x}, {x, x}}, vars];

corresponds to the polynomial ![x + 2 x y + 3 y x + 4 x^2](https://render.githubusercontent.com/render/math?math=x%20%2B%202%20x%20y%20%2B%203%20y%20x%20%2B%204%20x%5E2&mode=inline) and

    NCPolyTermsOfTotalDegree[p, 2]

returns

    NCPoly[{1, 1}, <|{0, 2, 0} -> 4, {1, 1, 1} -> 2, {1, 1, 2} -> 3|>]

which corresponds to the polyomial ![2 x y + 3 y x + 4 x^2](https://render.githubusercontent.com/render/math?math=2%20x%20y%20%2B%203%20y%20x%20%2B%204%20x%5E2&mode=inline).

See also:
[NCPolyTermsOfDegree](#ncpolytermsofdegree).

#### NCPolyQuadraticTerms

`NCPolyQuadraticTerms[p]` returns a polynomial with only the
“square” quadratic terms of `p`.

For example:

    vars = {{x, y, z}}
    coeff = {1, 1, 4, 3, 2, -1}
    digits = {{}, {x}, {y, x}, {z, x}, {z, y}, {x, z, z, y}}
    p = NCPoly[coeff, digits, vars, TransposePairs -> {{x, y}}]

corresponds to the polynomial ![p(x,y,z) = -x.z.z.y + 2 z.y + 3 z.x + 4 y.x + x + 1](https://render.githubusercontent.com/render/math?math=p%28x%2Cy%2Cz%29%20%3D%20-x.z.z.y%20%2B%202%20z.y%20%2B%203%20z.x%20%2B%204%20y.x%20%2B%20x%20%2B%201&mode=inline) in which ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) are transposes of each other, that is ![y = x^T](https://render.githubusercontent.com/render/math?math=y%20%3D%20x%5ET&mode=inline). Its `NCPoly` object is

    NCPoly[{3}, <|{0, 0} -> 1, {1, 0} -> 1, {2, 3} -> 4, {2, 6} -> 3, {2, 7} -> 2, {4, 25} -> -1|>, TransposePairs -> {{0, 1}}]

A call to

    NCPolyQuadraticTerms[p]

results in

    NCPoly[{3}, <|{0, 0} -> 1, {2, 3} -> 4, {4, 25} -> -1|>, TransposePairs -> {{0, 1}}]

corresponding to the polynomial ![-x.z.z.y + 4 y.x + 1](https://render.githubusercontent.com/render/math?math=-x.z.z.y%20%2B%204%20y.x%20%2B%201&mode=inline) which contains
only “square” quadratic terms of ![p(x,y,z)](https://render.githubusercontent.com/render/math?math=p%28x%2Cy%2Cz%29&mode=inline).

See also:
`NCPolyQuadraticChipset`(#NCPolyQuadraticChipset).

#### NCPolyQuadraticChipset

`NCPolyQuadraticChipset[p]` returns a polynomial with only the “half”
terms of `p` that can be in an NC SOS decomposition of `p`.

For example:

    vars = {{x, y, z}}
    coeff = {1, 1, 4, 3, 2, -1}
    digits = {{}, {x}, {y, x}, {z, x}, {z, y}, {x, z, z, y}}
    p = NCPoly[coeff, digits, vars, TransposePairs -> {{x, y}}]

corresponds to the polynomial ![p(x,y,z) = -x.z.z.y + 2 z.y + 3 z.x + 4 y.x + x + 1](https://render.githubusercontent.com/render/math?math=p%28x%2Cy%2Cz%29%20%3D%20-x.z.z.y%20%2B%202%20z.y%20%2B%203%20z.x%20%2B%204%20y.x%20%2B%20x%20%2B%201&mode=inline) in which ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) are transposes of each other, that is ![y = x^T](https://render.githubusercontent.com/render/math?math=y%20%3D%20x%5ET&mode=inline). Its `NCPoly` object is

    NCPoly[{3}, <|{0, 0} -> 1, {1, 0} -> 1, {2, 3} -> 4, {2, 6} -> 3, {2, 7} -> 2, {4, 25} -> -1|>, TransposePairs -> {{0, 1}}]

A call to

    NCPolyQuadraticChipset[p]

results in

    NCPoly[{3}, <|{0, 0} -> 1, {1, 0} -> 1, {1, 1} -> 1, {2, 2} -> 1|>, TransposePairs -> {{0, 1}}]

corresponding to the polynomial ![x.z + y + x + 1](https://render.githubusercontent.com/render/math?math=x.z%20%2B%20y%20%2B%20x%20%2B%201&mode=inline) that contains only
terms which contain monomials with the “left half” of the monomials of
![p(x,y,z)](https://render.githubusercontent.com/render/math?math=p%28x%2Cy%2Cz%29&mode=inline) which can appear in an NC SOS decomposition of `p`.

See also:
`NCPolyQuadraticTerms`(#NCPolyQuadraticTerms).

#### NCPolyReverseMonomials

`NCPolyReverseMonomials[p]` reverses the order of the symbols appearing in each monomial of the polynomial `p`.

For example:

    vars = {x, y};
    poly = NCPoly[{1, 2, 3, 4}, {{x}, {x, y}, {y, x}, {x, x}}, vars];

corresponds to the polynomial ![x + 2 x y + 3 y x + 4 x^2](https://render.githubusercontent.com/render/math?math=x%20%2B%202%20x%20y%20%2B%203%20y%20x%20%2B%204%20x%5E2&mode=inline) and

    NCPolyReverseMonomials[p]

returns

    NCPoly[{1, 1}, <|{0, 1, 0} -> 1, {0, 2, 0} -> 4, {1, 1, 2} -> 2, {1, 1, 1} -> 3|>]

which correspond to the polynomial ![x + 2 y x + 3 x y + 4 x^2](https://render.githubusercontent.com/render/math?math=x%20%2B%202%20y%20x%20%2B%203%20x%20y%20%2B%204%20x%5E2&mode=inline).

See also:
[NCIntegerReverse](#ncintegerreverse).

#### NCPolyGetOptions

`NCPolyGetOptions[p]` returns the options embedded in the polynomial `p`.

Available options are:

- `TransposePairs`: list with pairs of variables to be treated as
  transposes of each other;
- `SelfAdjointPairs`: list with pairs of variables to be treated as
  adjoints of each other.

### Formating functions

#### NCPolyDisplay

`NCPolyDisplay[poly]` prints the noncommutative polynomial `poly`.

`NCPolyDisplay[poly, vars]` uses the symbols in the list `vars`.

#### NCPolyDisplayOrder

`NCPolyDisplayOrder[vars]` prints the order implied by the list of
variables `vars`.

### Arithmetic functions

#### NCPolyDivideDigits

`NCPolyDivideDigits[F,G]` returns the result of the division of the
leading digits lf and lg.

#### NCPolyDivideLeading

`NCPolyDivideLeading[lF,lG,base]` returns the result of the division
of the leading Rules lf and lg as returned by NCGetLeadingTerm.

#### NCPolyNormalize

`NCPolyNormalize[poly]` makes the coefficient of the leading term of
`p` to unit. It also works when `poly` is a list.

#### NCPolySum

`NCPolySum[f,g]` returns a NCPoly that is the sum of the NCPoly’s f
and g.

#### NCPolyProduct

`NCPolyProduct[f,g]` returns a NCPoly that is the product of the
NCPoly’s f and g.

#### NCPolyQuotientExpand

`NCPolyQuotientExpand[q,g]` returns a NCPoly that is the left-right
product of the quotient as returned by `NCPolyReduceWithQuotient` by the NCPoly
`g`. It also works when `g` is a list.

#### NCPolyReduce

`NCPolyReduce[polys, rules]` reduces the list of `NCPoly`s `polys`
with respect to the list of `NCPoly`s `rules`. The substitutions
implied by `rules` are applied repeatedly to the polynomials in the
`polys` until no further reduction occurs.

`NCPolyReduce[polys]` reduces each polynomial in the list of `NCPoly`s
`polys` with respect to the remaining elements of the list of
polyomials `polys`. It traverses the list of polys just once. Use
[NCPolyReduceRepeated](#ncpolyreducerepeated) to continue applying
`NCPolyReduce` until no further reduction occurs.

By default, `NCPolyReduce` only reduces the leading monomial in the
current order. Use the optional boolean flag `Complete` to completely
reduce all monomials. For example,

    NCPolyReduce[polys, rules, Complete -> True]
    NCPolyReduce[polys, Complete -> True]

Other available options are:
- `MaxIterationsFactor` (default = 10): limits the maximum number of
iterations in reducing each polynomial by `MaxIterationsFactor`
times the number of terms in the polynomial.
- `MaxDepth` (default = 1): control how many monomials are reduced by
`NCPolyReduce`; by default `MaxDepth` is set to one so that just the
leading monomial is reduced. Setting `Complete -> True` effectively
sets `MaxDepth` to `Infinity`.
- `ZeroTest` (default = `NCPolyPossibleZeroQ`): which test to use when
assessing that a monomial is zero. This option is useful when the
coefficients are floating points, in which case one might substitute
`ZeroTest` for an approximate zero test.

See also:
[NCPolyGroebner](#ncpolygroebner-1),
[NCPolyReduceRepeated](#ncpolyreducerepeated),
[NCPolyReduceWithQuotient](#ncpolyreducewithquotient).

#### NCPolyReduceRepeated

`NCPolyReduceRepeated[polys]` applies NCPolyReduce successively to the
list of polynomials `polys` until the remainder does not change.

See also:
[NCPolyReduce](#ncpolyreduce),
[NCPolyReduceWithQuotient](#ncpolyreducewithquotient).

#### NCPolyReduceWithQuotient

`NCPolyReduceWithQuotient[f, g]` works as
[NCPolyReduce](#ncpolyreduce) but also returns a list with the
quotient that can be expanded usinn
[NCPolyQuotientExpand](#ncpolyquotientexpand).

For example

    {qf, r} = NCPolyReduceWithQuotient[f, g];
    q = NCPolyQuotientExpand[qf, g];

returns the list `qf` which is then expanded into the quotient `q`.

The same options in [NCPolyReduce](#ncpolyreduce) can be used with
`NCPolyReduceWithQuotient`.

See also:
[NCPolyReduce](#ncpolyreduce),
[NCPolyQuotientExpand](#ncpolyquotientexpand).

### State space realization functions

#### NCPolyHankelMatrix

`NCPolyHankelMatrix[poly]` produces the nc *Hankel matrix* associated
with the polynomial `poly` and also their shifts per variable.

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

which are the Hankel matrices associated with the commutator ![x y - y x](https://render.githubusercontent.com/render/math?math=x%20y%20-%20y%20x&mode=inline).

See also:
[NCPolyRealization](#ncpolyrealization),
[NCDigitsToIndex](#ncdigitstoindex).

#### NCPolyRealization

`NCPolyRealization[poly]` calculate a minimal descriptor realization
for the polynomial `poly`.

`NCPolyRealization` uses `NCPolyHankelMatrix` and the resulting
realization is compatible with the format used by `NCRational`.

For example:

    vars = {{x, y}};
    poly = NCPoly[{1, -1}, {{x, y}, {y, x}}, vars];
    {{a0,ax,ay},b,c,d} = NCPolyRealization[poly]

produces a list of matrices `{a0,ax,ay}`, a column vector `b` and a
row vector `c`, and a scalar `d` such that

![inline equation](https://render.githubusercontent.com/render/math?math=c%20.%20%28a0%20%2B%20ax%20%5C%2C%20x%20%2B%20ay%20%5C%2C%20y%29%5E%7B-1%7D%20.%20b%20%2B%20d%20%3D%20x%20y%20-%20y%20x)

See also:
[NCPolyHankelMatrix](#ncpolyhankelmatrix),
[NCRational](#ncrational-1).

### Auxiliary functions

#### NCPolyVarsToIntegers

`NCPolyVarsToIntegers[vars]` converts the list of symbols `vars` into
a list of integers corresponding to the graded ordering implied by
`vars`.

For example:

    NCPolyVarsToIntegers[{{x},{y,z}}]

returns `{1,2}`, indicating that there are a total of three variables
with the last two ranking higher than the first.

`NCPolyVarsToIntegers` raises `NCPoly::InvalidList` in case it cannot
correctly parse the list of variables.

If `vars` is a list of integers, `NCPolyVarsToIntegers` returns this
list intact.

See also:
[NCPoly](#ncpoly-1).

#### NCFromDigits

`NCFromDigits[list, b]` constructs a representation of a monomial in
`b` encoded by the elements of `list` where the digits are in base
`b`.

`NCFromDigits[{list1,list2}, b]` applies `NCFromDigits` to each
`list1`, `list2`, ….

List of integers are used to codify monomials. For example the list
`{0,1}` represents a monomial ![xy](https://render.githubusercontent.com/render/math?math=xy&mode=inline) and the list `{1,0}` represents
the monomial ![yx](https://render.githubusercontent.com/render/math?math=yx&mode=inline). The call

    NCFromDigits[{0,0,0,1}, 2]

returns

    {4,1}

in which `4` is the degree of the monomial ![xxxy](https://render.githubusercontent.com/render/math?math=xxxy&mode=inline) and `1` is
`0001` in base `2`. Likewise

    NCFromDigits[{0,2,1,1}, 3]

returns

    {4,22}

in which `4` is the degree of the monomial ![xzyy](https://render.githubusercontent.com/render/math?math=xzyy&mode=inline) and `22` is
`0211` in base `3`.

If `b` is a list, then degree is also a list with the partial degrees
of each letters appearing in the monomial. For example:

    NCFromDigits[{0,2,1,1}, {1,2}]

returns

    {3, 1, 22}

in which `3` is the partial degree of the monomial ![xzyy](https://render.githubusercontent.com/render/math?math=xzyy&mode=inline) with
respect to letters `y` and `z`, `1` is the partial degree with respect
to letter `x` and `22` is `0211` in base `3 = 1 + 2`.

This construction is used to represent graded degree-lexicographic
orderings.

See also:
[NCIntegerDigits](#ncintegerdigits).

#### NCIntegerDigits

`NCIntegerDigits[n,b]` is the inverse of the `NCFromDigits`.

`NCIntegerDigits[{list1,list2}, b]` applies `NCIntegerDigits` to each
`list1`, `list2`, ….

For example:

    NCIntegerDigits[{4,1}, 2]

returns

    {0,0,0,1}

in which `4` is the degree of the monomial `x**x**x**y` and `1` is
`0001` in base `2`. Likewise

    NCIntegerDigits[{4,22}, 3]

returns

    {0,2,1,1}

in which `4` is the degree of the monomial `x**z**y**y` and `22` is
`0211` in base `3`.

If `b` is a list, then degree is also a list with the partial degrees
of each letters appearing in the monomial. For example:

    NCIntegerDigits[{3, 1, 22}, {1,2}]

returns

    {0,2,1,1}

in which `3` is the partial degree of the monomial `x**z**y**y` with
respect to letters `y` and `z`, `1` is the partial degree with respect
to letter `x` and `22` is `0211` in base `3 = 1 + 2`.

See also:
[NCFromDigits](#ncfromdigits).

#### NCIntegerReverse

`NCIntegerReverse[n,b]` reverses the integer `n` on the base `b` as returned by `NCFromDigits`.

`NCIntegerReverse[{list1,list2}, b]` applies `NCIntegerReverse` to each
`list1`, `list2`, ….

For example:

    NCIntegerReverse[{4,1}, 2]

in which `{4,1}` correspond to the digits `{1,0,0,0}` returns

    {4, 8}

which correspond to the digits `{1,0,0,0}`.

See also:
[NCIntegerDigits](#ncintegerdigits).

#### NCDigitsToIndex

`NCDigitsToIndex[digits, b]` returns the index that the monomial
represented by `digits` in the base `b` would occupy in the standard
monomial basis.

`NCDigitsToIndex[{digit1,digits2}, b]` applies `NCDigitsToIndex` to each
`digit1`, `digit2`, ….

`NCDigitsToIndex[digits, b, Reverse -> True]` returns the index as
occupied by the permuted digits.

`NCDigitsToIndex` returns the same index for graded or simple basis.

For example:

    digits = {0, 1};
    NCDigitsToIndex[digits, 2]
    NCDigitsToIndex[digits, {2}]
    NCDigitsToIndex[digits, {1, 1}]

all return

    5

which is the index of the monomial ![x y](https://render.githubusercontent.com/render/math?math=x%20y&mode=inline) in the standard monomial
basis of polynomials in ![x](https://render.githubusercontent.com/render/math?math=x&mode=inline) and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline). Likewise

    digits = {{}, {1}, {0, 1}, {0, 2, 1, 1}};
    NCDigitsToIndex[digits, 2]

returns

    {1,3,5,27}

Finally

    NCDigitsToIndex[{0, 1}, 2, Reverse -> True]

returns `6` instead of `5`.

See also:
[NCFromDigits](#ncfromdigits),
[NCIntegerDigits](#ncintegerdigits).

#### NCPadAndMatch

When list `a` is longer than list `b`, `NCPadAndMatch[a,b]` returns
the minimum number of elements from list a that should be added to the
left and right of list `b` so that `a = l b r`. When list `b` is longer
than list `a`, return the opposite match.

`NCPadAndMatch` returns all possible matches with the minimum number
of elements.

## NCPolyInterface

The package `NCPolyInterface` provides a basic interface between
[`NCPoly`](#ncpoly) and `NCAlgebra`.

> Note that to take full advantage of the speed-up possible with
> `NCPoly` one should not use these functions. It is always faster to
> convert to and manipulate `NCPoly` expressions directly!

Members are:

- [NCToNCPoly](#nctoncpoly)
- [NCPolyToNC](#ncpolytonc)
- [NCMonomialOrderQ](#ncmonomialorderq)
- [NCMonomialOrder](#ncmonomialorder)
- [NCRationalToNCPoly](#ncrationaltoncpoly)
- [NCRuleToPoly](#ncruletopoly)
- [NCToRule](#nctorule)
- [NCReduce](#ncreduce)
- [NCReduceRepeated](#ncreducerepeated)
- [NCMonomialList](#ncmonomiallist)
- [NCCoefficientRules](#nccoefficientrules)
- [NCCoefficientList](#nccoefficientlist)
- [NCCoefficientQ](#nccoefficientq)
- [NCMonomialQ](#ncmonomialq)
- [NCPolynomialQ](#ncpolynomialq)

### NCToNCPoly

`NCToNCPoly[expr, var]` constructs a noncommutative polynomial object in
variables `var` from the nc expression `expr`.

For example

    NCToNCPoly[x**y - 2 y**z, {x, y, z}] 

constructs an object associated with the noncommutative polynomial ![x y - 2 y z](https://render.githubusercontent.com/render/math?math=x%20y%20-%202%20y%20z&mode=inline) in variables `x`, `y` and `z`. The internal representation is so
that the terms are sorted according to a degree-lexicographic order in
`vars`. In the above example, ![x \< y \< z](https://render.githubusercontent.com/render/math?math=x%20%3C%20y%20%3C%20z&mode=inline).

### NCPolyToNC

`NCPolyToNC[poly, vars]` constructs an nc expression from the
noncommutative polynomial object `poly` in variables `vars`. Monomials are
specified in terms of the symbols in the list `var`.

For example

    poly = NCToNCPoly[x**y - 2 y**z, {x, y, z}];
    expr = NCPolyToNC[poly, {x, y, z}];

returns

    expr = x**y - 2 y**z

See also:
[NCPolyToNC](#ncpolytonc),
[NCPoly](#ncpoly-1).

### NCMonomialOrderQ

`NCMonomialOrderQ[list]` returns `True` if the expressions in `list`
represents a valid monomial ordering.

`NCMonomialOrderQ` is used by [NCMonomialOrder](#ncmonomialorder) to
decided whether a proposed ordering is valid or not. However,
`NCMonomialOrder` is much more forgiving when it comes to the format
of the order.

See also:
[NCMonomialOrder](#ncmonomialorder),
[NCRationalToNCPoly](#ncrationaltoncpoly).

### NCMonomialOrder

`NCMonomialOrder[var1, var2, ...]` returns an array representing a
monomial order.

For example

    NCMonomialOrder[a,b,c]

returns

``` output
{{a},{b},{c}}
```

corresponding to the lex order ![a \ll b \ll c](https://render.githubusercontent.com/render/math?math=a%20%5Cll%20b%20%5Cll%20c&mode=inline).

If one uses a list of variables rather than a single variable as one
of the arguments, then multigraded lex order is used. For example

    NCMonomialOrder[{a,b,c}]

returns

``` output
{{a,b,c}}
```

corresponding to the graded lex order ![a \< b \< c](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%3C%20c&mode=inline).

Another example:

    NCMonomialOrder[{{a, b}, {c}}]

or

    NCMonomialOrder[{a, b}, c]

both return

``` output
{{a,b},{c}}
```

corresponding to the multigraded lex order ![a \< b \ll c](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c&mode=inline).

See also:
[NCMonomialOrderQ](#ncmonomialorderq),
[NCRationalToNCPoly](#ncrationaltoncpoly),
[SetMonomialOrder](#setmonomialorder).

### NCRationalToNCPoly

`NCRationalToNCPoly[expr, vars]` generates a representation of the
noncommutative rational expression or list of rational expressions
`expr` in `vars` which has commutative coefficients.

`NCRationalToNCPoly[expr, vars]` generates one or more `NCPoly`s in
which `vars` is used to set a monomial ordering as per
[NCMonomialOrder](#ncmonomialorder).

`NCRationalToNCPolynomial` creates one variable for each `inv`
expression in `vars` appearing in the rational expression `expr`. It
also created additional relations to encode the inverse. It also
creates additional variables to represent `tp` and `aj`.

It returns a list of four elements:

- the first element is the original expression and any additional
  expressions as `NCPoly`s;
- the second element is the list of variables representing the current
  ordering, including any additional variables created to replace
  `inv`s, `tp`s, and `aj`s;
- the third element is a list of rules that can be used to recover the
  original rational expression;
- the fourth element is a list of labels corresponding to the
  variables in the second element.

For example:

    exp = a+tp[a]-inv[a];
    order = NCMonomialOrder[a,b];
    {rels,vars,rules,labels} = NCRationalToNCPoly[exp, order]

returns

    rels = {
      NCPoly[{2,1,1},<|{0,0,1,0} -> 1,{0,0,1,1} -> 1,{1,0,0,3} -> -1|>],
      NCPoly[{2,1,1},<|{0,0,0,0} -> -1,{1,0,1,12} -> 1|>],
      NCPoly[{2,1,1},<|{0,0,0,0} -> -1,{1,0,1,3} -> 1|>]
    }
    vars = {{a,tp51},{b},{rat50}},
    rules = {rat50 -> inv[a],tp51 -> tp[a]},
    labels = {{a,tp[a]},{b},{inv[a]}}

The variable `tp51` was created to represent `tp[a]` and `rat50` was
created to represent `inv[a]`. The additional relations in `rels`
correspond to `a**rat50 - 1` and `rat50**a - 1`, which encode the
rational relation `rat50 - inv[a]`.

`NCRationalToPoly` also handles rational expressions, not only
rational variables. For example:

    expr = a ** inv[1 - a] ** a;
    order = NCMonomialOrder[a, inv[1 - a]];
    {rels, vars, rules, labels} = NCRationalToNCPoly[expr, order]

returns

    rels = {
      NCPoly[{1,1},<|{1,2,2} -> 1|>],
      NCPoly[{1,1},<|{0,0,0} -> -1,{1,0,1} -> 1,{1,1,2} -> -1|>],
      NCPoly[{1,1},<|{0,0,0} -> -1,{1,0,1} -> 1,{1,1,1} -> -1|>]
    }
    vars = {{a},{rat54}} 
    rules = {rat54 -> inv[1 - a]},
    labels = {{a},{inv[1 - a]}}

Note how `rat54` encodes the rational expression `inv[1-a]`.

See also:
[NCMonomialOrder](#ncmonomialorder),
[NCMonomialOrderQ](#ncmonomialorderq),
[NCPolyToNC](#ncpolytonc),
[NCPoly](#ncpoly-1),
[NCRationalToNCPolynomial](#ncrationaltoncpolynomial).

### NCRuleToPoly

`NCRuleToPoly[a -> b]` converts the rule `a -> b` into the relation `a - b`.

For instance:

    NCRuleToPoly[x**y**y -> x**y - 1]

returns

    x**y**y - x**y + 1

### NCToRule

`NCToRule[exp, vars]` converts the NC polynomial `exp` into a rule `a -> b` in which `a` is the leading monomial according to the ordering
implied by `vars`.

For instance:

    NCToRule[x**y**y - x**y + 1, {x,y}]

returns

    x**y**y -> x**y - 1

NOTE: This command is not efficient. If you need to sort polynomials
you should consider using NCPoly directly.

See also:
[NCToNCPoly](#nctoncpoly)

### NCReduce

`NCReduce[polys, rules, vars, options]` reduces the list of
polynomials in `polys` by the list of polynomials in `rules` in the
variables `vars`. The substitutions implied by `rules` are applied
repeatedly to the polynomials in the `polys` until no further
reduction occurs.

Note that the exact meaning of rules depends on the polynomial
ordering implied by the `vars`. For example, if

    polys = x^3 + x ** y
    rules = x^2 - x ** y

then

    NCReduce[polys, rules, {y, x}]

produces

``` output
x ** y + x ** y ** x
```

because `x^2 - x ** y` is interpreted as `x^2 -> x ** y`, while

    NCReduce[polys, rules, {x, y}]

produces

``` output
x^2 + x^3
```

because `x^2 - x ** y` is interpreted as `x ** y -> x^2`.

By default, `NCReduce` only reduces the leading monomial in the
current order. Use the optional boolean flag `Complete` to completely
reduce all monomials. For example,

    NCReduce[polys, rules, Complete -> True]
    NCReduce[polys, Complete -> True]

See [NCPolyReduce](#ncpolyreduce) for a complete list of `options`.

`NCReduce[polys, vars, options]` reduces each polynomial in the list
of `NCPoly`s `polys` with respect to the remaining elements of the
list of polyomials `polys`. It traverses the list of polys just
once. Use [NCReduceRepeated](#ncreducerepeated) to continue applying
`NCReduce` until no further reduction occurs.

`NCReduce` converts `polys` and `rules` to NCPoly polynomials and
apply [NCPolyReduce](#ncpolyreduce).

See also:
[NCReduceRepeated](#ncreducerepeated), [NCPolyReduce](#ncpolyreduce).

### NCReduceRepeated

`NCReduceRepeated[polys, vars]` applies `NCReduce` successively to the
list of `polys` in variables `vars` until the remainder does not
change.

See also:
[NCReduce](#ncreduce),
[NCPolyReduceRepeated](#ncpolyreducerepeated).

### NCMonomialList

`NCMonomialList[poly, vars]` gives the list of all monomials in the
polynomial `poly` in variables `vars`.

For example:

    vars = {x, y}
    expr = B + A y ** x ** y - 2 x
    NCMonomialList[expr, vars]

returns

    {1, x, y ** x ** y}

See also:
[NCCoefficientRules](#nccoefficientrules),
[NCCoefficientList](#nccoefficientlist),
[NCVariables](#ncvariables).

### NCCoefficientRules

`NCCoefficientRules[poly, vars]` gives a list of rules between all the
monomials polynomial `poly` in variables `vars`.

For example:

    vars = {x, y}
    expr = B + A y ** x ** y - 2 x
    NCCoefficientRules[expr, vars]

returns

    {1 -> B, x -> -2, y ** x ** y -> A}

See also:
[NCMonomialList](#ncmonomiallist),
[NCCoefficientRules](#nccoefficientrules),
[NCVariables](#ncvariables).

### NCCoefficientList

`NCCoefficientList[poly, vars]` gives the list of all coefficients in
the polynomial `poly` in variables `vars`.

For example:

    vars = {x, y}
    expr = B + A y ** x ** y - 2 x
    NCCoefficientList[expr, vars]

returns

    {B, -2, A}

See also:
[NCMonomialList](#ncmonomiallist),
[NCCoefficientRules](#nccoefficientrules),
[NCVariables](#ncvariables).

### NCCoefficientQ

`NCCoefficientQ[expr]` returns True if `expr` is a valid polynomial
coefficient.

For example:

    SetCommutative[A]
    NCCoefficientQ[1]
    NCCoefficientQ[A]
    NCCoefficientQ[2 A]

all return `True` and

    SetNonCommutative[x]
    NCCoefficientQ[x]
    NCCoefficientQ[x**x]
    NCCoefficientQ[Exp[x]]

all return `False`.

**IMPORTANT**: `NCCoefficientQ[expr]` does not expand `expr`. This
means that `NCCoefficientQ[2 (A + 1)]` will return `False`.

See also:
[NCMonomialQ](#ncmonomialq),
[NCPolynomialQ](#ncpolynomialq)

### NCMonomialQ

`NCCoefficientQ[expr]` returns True if `expr` is an nc monomial.

For example:

    SetCommutative[A]
    NCMonomialQ[1]
    NCMonomialQ[x]
    NCMonomialQ[A x ** y]
    NCMonomialQ[2 A x ** y ** x]

all return `True` and

    NCMonomialQ[x + x ** y]

returns `False`.

**IMPORTANT**: `NCMonomialQ[expr]` does not expand `expr`. This
means that `NCMonomialQ[2 (A + 1) x**x]` will return `False`.

See also:
[NCCoefficientQ](#nccoefficientq),
[NCPolynomialQ](#ncpolynomialq)

### NCPolynomialQ

`NCPolynomialQ[expr]` returns True if `expr` is an nc polynomial with
commutative coefficients.

For example:

    NCPolynomialQ[A x ** y]

all return `True` and

    NCMonomialQ[x + x ** y]

returns `False`.

**IMPORTANT**: `NCPolynomialQ[expr]` does expand `expr`. This
means that `NCPolynomialQ[(x + y)^3]` will return `True`.

See also:
[NCCoefficientQ](#nccoefficientq),
[NCMonomialQ](#ncmonomialq)

## NCPolynomial

### Efficient storage of NC polynomials with nc coefficients

This package contains functionality to convert an nc polynomial expression into an expanded efficient representation that can have commutative or noncommutative coefficients.

For example the polynomial

    exp = a**x**b - 2 x**y**c**x + a**c

in variables `x` and `y` can be converted into an NCPolynomial using

    p = NCToNCPolynomial[exp, {x,y}]

which returns

    p = NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

Members are:

- Constructors
  - [NCPolynomial](#ncpolynomial-1)
  - [NCToNCPolynomial](#nctoncpolynomial)
  - [NCPolynomialToNC](#ncpolynomialtonc)
  - [NCRationalToNCPolynomial](#ncrationaltoncpolynomial)
- Access and utilities
  - [NCPCoefficients](#ncpcoefficients)
  - [NCPTermsOfDegree](#ncptermsofdegree)
  - [NCPTermsOfTotalDegree](#ncptermsoftotaldegree)
  - [NCPTermsToNC](#ncptermstonc)
  - [NCPDecompose](#ncpdecompose)
  - [NCPDegree](#ncpdegree)
  - [NCPMonomialDegree](#ncpmonomialdegree)
  - [NCPCompatibleQ](#ncpcompatibleq)
  - [NCPSameVariablesQ](#ncpsamevariablesq)
  - [NCPMatrixQ](#ncpmatrixq)
  - [NCPLinearQ](#ncplinearq)
  - [NCPQuadraticQ](#ncpquadraticq)
  - [NCPNormalize](#ncpnormalize)
- Arithmetic
  - [NCPTimes](#ncptimes)
  - [NCPDot](#ncpdot)
  - [NCPPlus](#ncpplus)
  - [NCPSort](#ncpsort)

### Ways to represent NC polynomials

#### NCPolynomial

`NCPolynomial[indep,rules,vars]` is an expanded efficient representation for an nc polynomial in `vars` which can have commutative or noncommutative coefficients.

The nc expression `indep` collects all terms that are independent of the letters in `vars`.

The *Association* `rules` stores terms in the following format:

    {mon1, ..., monN} -> {scalar, term1, ..., termN+1}

where:

- `mon1, ..., monN`: are nc monomials in vars;
- `scalar`: contains all commutative coefficients; and
- `term1, ..., termN+1`: are nc expressions on letters other than
  the ones in vars which are typically the noncommutative
  coefficients of the polynomial.

`vars` is a list of *Symbols*.

For example the polynomial

    a**x**b - 2 x**y**c**x + a**c

in variables `x` and `y` is stored as:

    NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

NCPolynomial specific functions are prefixed with NCP, e.g. NCPDegree.

See also:
[`NCToNCPolynomial`](#nctoncpolynomial), [`NCPolynomialToNC`](#ncpolynomialtonc), [`NCPTermsToNC`](#ncptermstonc).

#### NCToNCPolynomial

`NCToNCPolynomial[p, vars]` generates a representation of the noncommutative polynomial `p` in `vars` which can have commutative or noncommutative coefficients.

`NCToNCPolynomial[p]` generates an `NCPolynomial` in all nc variables appearing in `p`.

Example:

    exp = a**x**b - 2 x**y**c**x + a**c
    p = NCToNCPolynomial[exp, {x,y}]

returns

    NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

See also:
[`NCPolynomial`](#ncpolynomial-1), [`NCPolynomialToNC`](#ncpolynomialtonc).

#### NCPolynomialToNC

`NCPolynomialToNC[p]` converts the NCPolynomial `p` back into a regular nc polynomial.

See also:
[`NCPolynomial`](#ncpolynomial-1), [`NCToNCPolynomial`](#nctoncpolynomial).

#### NCRationalToNCPolynomial

`NCRationalToNCPolynomial[r, vars]` generates a representation of the noncommutative rational expression `r` in `vars` which can have commutative or noncommutative coefficients.

`NCRationalToNCPolynomial[r]` generates an `NCPolynomial` in all nc variables appearing in `r`.

`NCRationalToNCPolynomial` creates one variable for each `inv` expression in `vars` appearing in the rational expression `r`. It returns a list of three elements:

- the first element is the `NCPolynomial`;
- the second element is the list of new variables created to replace `inv`s;
- the third element is a list of rules that can be used to recover the original rational expression.

For example:

    exp = a**inv[x]**y**b - 2 x**y**c**x + a**c
    {p,rvars,rules} = NCRationalToNCPolynomial[exp, {x,y}]

returns

    p = NCPolynomial[a**c, <|{rat1**y}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y,rat1}]
    rvars = {rat1}
    rules = {rat1->inv[x]}

See also:
[`NCToNCPolynomial`](#ncpolynomial-1), [`NCPolynomialToNC`](#ncpolynomialtonc).

### Grouping terms by degree

#### NCPTermsOfDegree

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

See also:
[`NCPTermsOfTotalDegree`](#ncptermsoftotaldegree),[`NCPTermsToNC`](#ncptermstonc).

#### NCPTermsOfTotalDegree

`NCPTermsOfDegree[p,deg]` gives all terms of the NCPolynomial `p` of total degree `deg`.

The degree `deg` is the total degree.

For example:

    p = NCPolynomial[0, <|{x,y}->{{2,a,b,c}},
                          {x,x}->{{1,a,b,c}},
                          {x**x}->{{-1,a,b}}|>, {x,y}]
    NCPTermsOfDegree[p, 2]

returns

    <|{x,y}->{{2,a,b,c}},{x,x}->{{1,a,b,c}},{x**x}->{{-1,a,b}}|>

See also:
[`NCPTermsOfDegree`](#ncptermsofdegree),[`NCPTermsToNC`](#ncptermstonc).

#### NCPTermsToNC

`NCPTermsToNC` gives a nc expression corresponding to terms produced by `NCPTermsOfDegree` or `NCPTermsOfTotalDegree`.

For example:

    terms = <|{x,x}->{{1,a,b,c}}, {x**x}->{{-1,a,b}}|>
    NCPTermsToNC[terms]

returns

    a**x**b**c-a**x**b

See also:
[`NCPTermsOfDegree`](#ncptermsofdegree),[`NCPTermsOfTotalDegree`](#ncptermsoftotaldegree).

### Utilities

#### NCPDegree

`NCPDegree[p]` gives the degree of the NCPolynomial `p`.

See also:
[`NCPMonomialDegree`](#ncpmonomialdegree).

#### NCPMonomialDegree

`NCPMonomialDegree[p]` gives the degree of each monomial in the NCPolynomial `p`.

See also:
[`NCDegree`](#ncpmonomialdegree).

#### NCPCoefficients

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

See also:
[`NCPTermsToNC`](#ncptermstonc).

#### NCPLinearQ

`NCPLinearQ[p]` gives True if the NCPolynomial `p` is linear.

See also:
[`NCPQuadraticQ`](#ncpquadraticq).

#### NCPQuadraticQ

`NCPQuadraticQ[p]` gives True if the NCPolynomial `p` is quadratic.

See also:
[`NCPLinearQ`](#ncplinearq).

#### NCPCompatibleQ

`NCPCompatibleQ[p1,p2,...]` returns *True* if the polynomials `p1`,`p2`,… have the same variables and dimensions.

See also:
[NCPSameVariablesQ](#ncpsamevariablesq), [NCPMatrixQ](#ncpmatrixq).

#### NCPSameVariablesQ

`NCPSameVariablesQ[p1,p2,...]` returns *True* if the polynomials `p1`,`p2`,… have the same variables.

See also:
[NCPCompatibleQ](#ncpcompatibleq), [NCPMatrixQ](#ncpmatrixq).

#### NCPMatrixQ

`NCMatrixQ[p]` returns *True* if the polynomial `p` is a matrix polynomial.

See also:
[NCPCompatibleQ](#ncpcompatibleq).

#### NCPNormalize

`NCPNormalizes[p]` gives a normalized version of NCPolynomial p
where all factors that have free commutative products are
collectd in the scalar.

This function is intended to be used mostly by developers.

See also:
[`NCPolynomial`](#ncpolynomial-1)

### Operations on NC polynomials

#### NCPPlus

`NCPPlus[p1,p2,...]` gives the sum of the nc polynomials `p1`,`p2`,… .

#### NCPTimes

`NCPTimes[s,p]` gives the product of a commutative `s` times the
nc polynomial `p`.

#### NCPDot

`NCPDot[p1,p2,...]` gives the product of the nc polynomials `p1`,`p2`,… .

#### NCPSort

`NCPSort[p]` gives a list of elements of the NCPolynomial `p` in which monomials are sorted first according to their degree then by Mathematica’s implicit ordering.

For example

    NCPSort[NCToNCPolynomial[c + x**x - 2 y, {x,y}]]

will produce the list

    {c, -2 y, x**x}

See also:
[NCPDecompose](#ncpdecompose), [NCDecompose](#ncdecompose), [NCCompose](#nccompose).

#### NCPDecompose

`NCPDecompose[p]` gives an association of elements of the NCPolynomial `p` in which elements of the same order are collected together.

For example

    NCPDecompose[NCToNCPolynomial[a**x**b+c+d**x**e+a**x**e**x**b+a**x**y, {x,y}]]

will produce the Association

    <|{1,0}->a**x**b + d**x**e, {1,1}->a**x**y, {2,0}->a**x**e**x**b, {0,0}->c|>

See also:
[NCPSort](#ncpsort), [NCDecompose](#ncdecompose), [NCCompose](#nccompose).

## NCQuadratic

**NCQuadratic** is a package that provides functionality to handle quadratic polynomials in NC variables.

Members are:

- [NCToNCQuadratic](#nctoncquadratic)
- [NCPToNCQuadratic](#ncptoncquadratic)
- [NCQuadraticToNC](#ncquadratictonc)
- [NCQuadraticToNCPolynomial](#ncquadratictoncpolynomial)
- [NCMatrixOfQuadratic](#ncmatrixofquadratic)
- [NCQuadraticMakeSymmetric](#ncquadraticmakesymmetric)

### NCToNCQuadratic

`NCToNCQuadratic[p, vars]` is shorthand for

    NCPToNCQuadratic[NCToNCPolynomial[p, vars]]

See also:
[NCToNCQuadratic](#nctoncquadratic),[NCToNCPolynomial](#nctoncpolynomial).

### NCPToNCQuadratic

`NCPToNCQuadratic[p]` gives an expanded representation for the quadratic `NCPolynomial` `p`.

`NCPToNCQuadratic` returns a list with four elements:

- the first element is the independent term;
- the second represents the linear part as in [`NCSylvester`](#ncsylvester);
- the third element is a list of left NC symbols;
- the fourth element is a numeric `SparseArray`;
- the fifth element is a list of right NC symbols.

Example:

    exp = d + x + x**x + x**a**x + x**e**x + x**b**y**d + d**y**c**y**d;
    vars = {x,y};
    p = NCToNCPolynomial[exp, vars];
    {p0,sylv,left,middle,right} = NCPToNCQuadratic[p];

produces

    p0 = d
    sylv = <|x->{{1},{1},SparseArray[{{1}}]}, y->{{},{},{}}|>
    left =  {x,d**y}
    middle = SparseArray[{{1+a+e,b},{0,c}}]
    right = {x,y**d}

See also:
[NCSylvester](#ncsylvester),[NCQuadraticToNCPolynomial](#ncquadratictoncpolynomial),[NCPolynomial](#ncpolynomial-1).

### NCQuadraticToNC

`NCQuadraticToNC[{const, lin, left, middle, right}]` is shorthand for

    NCPolynomialToNC[NCQuadraticToNCPolynomial[{const, lin, left, middle, right}]]

See also:
[NCQuadraticToNCPolynomial](#ncquadratictonc),[NCPolynomialToNC](#ncpolynomialtonc).

### NCQuadraticToNCPolynomial

`NCQuadraticToNCPolynomial[rep]` takes the list `rep` produced by `NCPToNCQuadratic` and converts it back to an `NCPolynomial`.

`NCQuadraticToNCPolynomial[rep,options]` uses options.

The following options can be given:

- `Collect` (*True*): controls whether the coefficients of the resulting `NCPolynomial` are collected to produce the minimal possible number of terms.

See also:
[NCPToNCQuadratic](#ncptoncquadratic), [NCPolynomial](#ncpolynomial-1).

### NCMatrixOfQuadratic

`NCMatrixOfQuadratic[p, vars]` gives a factorization of the symmetric quadratic function `p` in noncommutative variables `vars` and their transposes.

`NCMatrixOfQuadratic` checks for symmetry and automatically sets variables to be symmetric if possible.

Internally it uses [NCPToNCQuadratic](#ncptoncquadratic) and [NCQuadraticMakeSymmetric](#ncquadraticmakesymmetric).

It returns a list of three elements:

- the first is the left border row vector;
- the second is the middle matrix;
- the third is the right border column vector.

For example:

    expr = x**y**x + z**x**x**z;
    {left,middle,right}=NCMatrixOfQuadratics[expr, {x}];

returns:

    left={x, z**x}
    middle=SparseArray[{{y,0},{0,1}}]
    right={x,x**z}

The answer from `NCMatrixOfQuadratics` always satisfies `p = NCDot[left,middle,right]`.

See also:
[NCPToNCQuadratic](#ncptoncquadratic), [NCQuadraticMakeSymmetric](#ncquadraticmakesymmetric).

### NCQuadraticMakeSymmetric

`NCQuadraticMakeSymmetric[{p0, sylv, left, middle, right}]` takes the output of [`NCPToNCQuadratic`](#ncptoncquadratic) and produces, if possible, an equivalent symmetric representation in which `Map[tp, left] = right` and `middle` is a symmetric matrix.

See also:
[NCPToNCQuadratic](#ncptoncquadratic).

## NCSylvester

**NCSylvester** is a package that provides functionality to handle linear polynomials in NC variables.

Members are:

- [NCToNCSylvester](#nctoncsylvester)
- [NCPToNCSylvester](#ncptoncsylvester)
- [NCSylvesterToNC](#ncsylvestertonc)
- [NCSylvesterToNCPolynomial](#ncsylvestertoncpolynomial)

### NCToNCSylvester

`NCToNCSylvester[p, vars]` is shorthand for

    NCPToNCSylvester[NCToNCPolynomial[p, vars]]

See also:
[NCToNCSylvester](#nctoncsylvester),
[NCToNCPolynomial](#nctoncpolynomial).

### NCPToNCSylvester

`NCPToNCSylvester[p]` gives an expanded representation for the linear `NCPolynomial` `p`.

`NCPToNCSylvester` returns a list with two elements:

- the first is a the independent term;

- the second is an association where each key is one of the variables and each value is a list with three elements:

  - the first element is a list of left NC symbols;
  - the second element is a list of right NC symbols;
  - the third element is a numeric `SparseArray`.

Example:

    p = NCToNCPolynomial[2 + a**x**b + c**x**d + y, {x,y}];
    {p0,sylv} = NCPolynomialToNCSylvester[p]

produces

    p0 = 2
    sylv = <|x->{{a,c},{b,d},SparseArray[{{1,0},{0,1}}]}, 
             y->{{1},{1},SparseArray[{{1}}]}|>

See also:
[NCSylvesterToNCPolynomial](#ncsylvestertoncpolynomial),
[NCSylvesterToNC](#ncsylvestertoncpolynomial),
[NCToNCSylvester](#nctoncsylvester),
[NCPolynomial](#ncpolynomial-1).

### NCSylvesterToNC

`NCSylvesterToNC[{const, lin}]` is shorthand for

    NCPolynomialToNC[NCSylvesterToNCPolynomial[{const, lin}]]

See also:
[NCSylvesterToNCPolynomial](#ncsylvestertonc),
[NCPolynomialToNC](#ncpolynomialtonc).

### NCSylvesterToNCPolynomial

`NCSylvesterToNCPolynomial[rep]` takes the list `rep` produced by `NCPToNCSylvester` and converts it back to an `NCPolynomial`.

`NCSylvesterToNCPolynomial[rep,options]` uses `options`.

The following `options` can be given:
\* `Collect` (*True*): controls whether the coefficients of the resulting NCPolynomial are collected to produce the minimal possible number of terms.

See also:
[NCPToNCSylvester](#ncptoncsylvester),
[NCToNCSylvester](#nctoncsylvester),
[NCPolynomial](#ncpolynomial-1).

# Noncommutative Gröbner Bases Algorithms

## NCGBX

This is an interface to a Gröebner Bases code that runs purely under
Mathematica. The actual algorithm is implemented in the package
[NCPolyGroebner](#ncpolygroebner). Its function names, inputs
and outputs are very similar (but not always exactly the same) to the
ones provided in the legacy package [NCGB](#ncgb), which
requires both Mathematica and auxiliary executables compiled from C++
to run. [NCGBX](#ncgbx) may run slower on some medium size
problems but will succeed on large size problems which might fail
under [NCGB](#ncgb).

Members are:

- [SetMonomialOrder](#setmonomialorder)
- [SetKnowns](#setknowns)
- [SetUnknowns](#setunknowns)
- [ClearMonomialOrder](#clearmonomialorder)
- [GetMonomialOrder](#getmonomialorder)
- [PrintMonomialOrder](#printmonomialorder)
- [NCMakeGB](#ncmakegb)
- [NCProcess](#ncprocess)
- [NCGBSimplifyRational](#ncgbsimplifyrational)
- [NCReduce](#ncreduce)

### SetMonomialOrder

`SetMonomialOrder[var1, var2, ...]` sets the current monomial order.

For example

    SetMonomialOrder[a,b,c]

sets the lex order ![a \ll b \ll c](https://render.githubusercontent.com/render/math?math=a%20%5Cll%20b%20%5Cll%20c&mode=inline).

If one uses a list of variables rather than a single variable as one
of the arguments, then multigraded lex order is used. For example

    SetMonomialOrder[{a,b,c}]

sets the graded lex order ![a \< b \< c](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%3C%20c&mode=inline).

Another example:

    SetMonomialOrder[{{a, b}, {c}}]

or

    SetMonomialOrder[{a, b}, c]

set the multigraded lex order ![a \< b \ll c](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c&mode=inline).

Finally

    SetMonomialOrder[{a,b}, {c}, {d}]

or

    SetMonomialOrder[{a,b}, c, d]

is equivalent to the following two commands

    SetKnowns[a,b] 
    SetUnknowns[c,d]

There is also an older syntax which is still supported:

    SetMonomialOrder[{a, b, c}, n]

sets the order of monomials to be ![a \< b \< c](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%3C%20c&mode=inline) and assigns them grading
level `n`.

    SetMonomialOrder[{a, b, c}, 1]

is equivalent to `SetMonomialOrder[{a, b, c}]`. When using this older
syntax the user is responsible for calling
[ClearMonomialOrder](#clearmonomialorder) to make sure that the
current order is empty before starting.

In Version 6, `SetMonomialOrder` uses
[NCMonomialOrder](#ncmonomialorder), and
[NCMonomialOrderQ](#ncmonomialorderq).

See also:
[ClearMonomialOrder](#clearmonomialorder),
[GetMonomialOrder](#getmonomialorder),
[PrintMonomialOrder](#printmonomialorder),
[SetKnowns](#setknowns),
[SetUnknowns](#setunknowns),
[NCMonomialOrder](#ncmonomialorder),
[NCMonomialOrderQ](#ncmonomialorderq).

### SetKnowns

`SetKnowns[var1, var2, ...]` records the variables `var1`, `var2`,
… to be corresponding to known quantities.

`SetUnknowns` and `Setknowns` prescribe a monomial order with the
knowns at the the bottom and the unknowns at the top.

For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]

is equivalent to

    SetMonomialOrder[{a,b}, {c}, {d}]

which corresponds to the order ![a \< b \ll c \ll d](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c%20%5Cll%20d&mode=inline) and

    SetKnowns[a,b] 
    SetUnknowns[{c,d}]

is equivalent to

    SetMonomialOrder[{a,b}, {c, d}]

which corresponds to the order ![a \< b \ll c \< d](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c%20%3C%20d&mode=inline).

Note that `SetKnowns` flattens grading so that

    SetKnowns[a,b] 

and

    SetKnowns[{a},{b}] 

result both in the order ![a \< b](https://render.githubusercontent.com/render/math?math=a%20%3C%20b&mode=inline).

Successive calls to `SetUnknowns` and `SetKnowns` overwrite the
previous knowns and unknowns. For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]
    SetKnowns[c,d]
    SetUnknowns[a,b]

results in an ordering ![c \< d \ll a \ll b](https://render.githubusercontent.com/render/math?math=c%20%3C%20d%20%5Cll%20a%20%5Cll%20b&mode=inline).

See also:
[SetUnknowns](#setunknowns),
[SetMonomialOrder](#setmonomialorder).

### SetUnknowns

`SetUnknowns[var1, var2, ...]` records the variables `var1`, `var2`,
… to be corresponding to unknown quantities.

`SetUnknowns` and `SetKnowns` prescribe a monomial order with the
knowns at the the bottom and the unknowns at the top.

For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]

is equivalent to

    SetMonomialOrder[{a,b}, {c}, {d}]

which corresponds to the order ![a \< b \ll c \ll d](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c%20%5Cll%20d&mode=inline) and

    SetKnowns[a,b] 
    SetUnknowns[{c,d}]

is equivalent to

    SetMonomialOrder[{a,b}, {c, d}]

which corresponds to the order ![a \< b \ll c \< d](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c%20%3C%20d&mode=inline).

Note that `SetKnowns` flattens grading so that

    SetKnowns[a,b] 

and

    SetKnowns[{a},{b}] 

result both in the order ![a \< b](https://render.githubusercontent.com/render/math?math=a%20%3C%20b&mode=inline).

Successive calls to `SetUnknowns` and `SetKnowns` overwrite the
previous knowns and unknowns. For example

    SetKnowns[a,b] 
    SetUnknowns[c,d]
    SetKnowns[c,d]
    SetUnknowns[a,b]

results in an ordering ![c \< d \ll a \ll b](https://render.githubusercontent.com/render/math?math=c%20%3C%20d%20%5Cll%20a%20%5Cll%20b&mode=inline).

See also:
[SetKnowns](#setknowns),
[SetMonomialOrder](#setmonomialorder).

### ClearMonomialOrder

`ClearMonomialOrder[]` clear the current monomial ordering.

It is only necessary to use `ClearMonomialOrder` if using the indexed
version of `SetMonomialOrder`.

See also:
[SetKnowns](#setknowns),
[SetUnknowns](#setunknowns),
[SetMonomialOrder](#setmonomialorder),
[ClearMonomialOrder](#clearmonomialorder),
[PrintMonomialOrder](#printmonomialorder).

### GetMonomialOrder

`GetMonomialOrder[]` returns the current monomial ordering in the form
of a list.

For example

    SetMonomialOrder[{a,b}, {c}, {d}]
    order = GetMonomialOrder[]

returns

    order = {{a,b},{c},{d}}

See also:
[SetKnowns](#setknowns),
[SetUnknowns](#setunknowns),
[SetMonomialOrder](#setmonomialorder),
[ClearMonomialOrder](#clearmonomialorder),
[PrintMonomialOrder](#printmonomialorder).

### PrintMonomialOrder

`PrintMonomialOrder[]` prints the current monomial ordering.

For example

    SetMonomialOrder[{a,b}, {c}, {d}]
    PrintMonomialOrder[]

print ![a \< b \ll c \ll d](https://render.githubusercontent.com/render/math?math=a%20%3C%20b%20%5Cll%20c%20%5Cll%20d&mode=inline).

See also:
[SetKnowns](#setknowns),
[SetUnknowns](#setunknowns),
[SetMonomialOrder](#setmonomialorder),
[ClearMonomialOrder](#clearmonomialorder),
[PrintMonomialOrder](#printmonomialorder).

### NCMakeGB

`NCMakeGB[{poly1, poly2, ...}, k]` attempts to produces a nc Gröbner
Basis (GB) associated with the list of nc polynomials `{poly1, poly2, ...}`. The GB algorithm proceeds through *at most* `k` iterations
until a Gröbner basis is found for the given list of polynomials with
respect to the order imposed by [SetMonomialOrder](#setmonomialorder).

If `NCMakeGB` terminates before finding a GB the message
`NCMakeGB::Interrupted` is issued.

The output of `NCMakeGB` is a list of rules with left side of the rule
being the *leading* monomial of the polynomials in the GB.

For example:

    SetMonomialOrder[x];
    gb = NCMakeGB[{x^2 - 1, x^3 - 1}, 20]

returns

    gb = {x -> 1}

that corresponds to the polynomial ![x - 1](https://render.githubusercontent.com/render/math?math=x%20-%201&mode=inline), which is the nc Gröbner
basis for the ideal generated by ![x^2-1](https://render.githubusercontent.com/render/math?math=x%5E2-1&mode=inline) and ![x^3-1](https://render.githubusercontent.com/render/math?math=x%5E3-1&mode=inline).

`NCMakeGB[{poly1, poly2, ...}, k, options]` uses `options`.

For example

    gb = NCMakeGB[{x^2 - 1, x^3 - 1}, 20, RedudeBasis -> True]

runs the Gröbner basis algortihm and completely reduces the output
set of polynomials.

The following `options` can be given:

- `ReduceBasis` (`True`): control whether the resulting basis output
  by the command is a reduced Gröbner basis at the completion of the
  algorithm. This corresponds to running `NCReduce` with the
  Boolean flag `True` to completely reduce the output basis. Can be set
  globally as `SetOptions[NCMakeGB, ReturnBasis -> True]`.
- `SimplifyObstructions` (`True`): control whether whether to remove
  obstructions before constructing more S-polynomials;
- `SortObstructions` (`False`): control whether obstructions are
  sorted before being processed;
- `SortBasis` (`False`): control whether initial basis is sorted
  before initiating algorithm;
- `VerboseLevel` (`1`): control level of verbosity from `0` (no
  messages) to `5` (very verbose);
- `PrintBasis` (`False`): if `True` prints current basis at each major
  iteration;
- `PrintObstructions` (`False`): if `True` prints current list of
  obstructions at each major iteration;
- `PrintSPolynomials` (`False`): if `True` prints every S-polynomial
  formed at each minor iteration.
- `ReturnRules` (`True`): if `True` rules representing relations in
  which the left-hand side is the leading monomial are returned
  instead of polynomials. Use `False` for backward compatibility. Can
  be set globally as `SetOptions[NCMakeGB, ReturnRules -> False]`.

`NCMakeGB` makes use of the algorithm `NCPolyGroebner` implemented in
[NCPolyGroebner](#ncpolygroebner-1).

In Version 6, `NCMakeGB` uses
[NCRationalToNCPoly](#ncrationaltoncpoly) to add additional relations
involving rational variables and rational terms.

See also:
[NCRationalToNCPoly](#ncrationaltoncpoly),
[NCReduce](#ncreduce),
[ClearMonomialOrder](#clearmonomialorder),
[GetMonomialOrder](#getmonomialorder),
[PrintMonomialOrder](#printmonomialorder),
[SetKnowns](#setknowns),
[SetUnknowns](#setunknowns),
[NCPolyGroebner](#ncpolygroebner-1).

### NCProcess

`NCProcess[{poly1, poly2, ...}, k]` finds a new generating set for the
ideal generated by `{poly1, poly2, ...}` using [NCMakeGB](#ncmakegb)
then produces an summary report on the findings.

Not all features of `NCProcess` in the old `NCGB` C++ version are
supported yet.

See also:
[NCMakeGB](#ncmakegb).

### NCGBSimplifyRational

`NCGBSimplifyRational[expr]` creates a set of relations for each
rational expression and sub-expression found in `expr` which are used
to produce simplification rules using [NCMakeGB](#ncmakegb) then
replaced using [NCReduce](#ncreduce).

For example:

    expr = x ** inv[1 - x] - inv[1 - x] ** x
    NCGBSimplifyRational[expr]

or

    expr = inv[1 - x - y ** inv[1 - x] ** y] - 1/2 (inv[1 - x + y] + inv[1 - x - y])
    NCGBSimplifyRational[expr]

both result in `0`.

See also:
[NCMakeGB](#ncmakegb),
[NCReduce](#ncreduce).

<!-- ### NCReduce {#NCReduce} -->
<!-- `NCReduce[polys, rules]` reduces the list of polynomials `polys` with -->
<!-- respect to the list of polyomials `rules`. The substitutions implied -->
<!-- by `rules` are applied repeatedly to the polynomials in the `polys` -->
<!-- until no further reduction occurs. -->
<!-- `NCReduce[polys]` reduces each polynomial in the list of polynomials -->
<!-- `polys` with respect to the remaining elements of the list of -->
<!-- polyomials `polys` until no further reduction occurs. -->
<!-- By default, `NCReduce` only reduces the leading monomial in the -->
<!-- current order. Use the optional boolean flag `complete` to completely -->
<!-- reduce all monomials. For example, `NCReduce[polys, rules, True]` and -->
<!-- `NCReduce[polys, True]`. -->
<!-- See also: -->
<!-- [NCMakeGB](#NCMakeGB), -->
<!-- [NCGBSimplifyRational](#NCGBSimplifyRational). -->

## NCPolyGroebner

This packages implements a Gröebner Bases algorithm that runs purely
under Mathematica. This algorithm is the one called by the
user-friendly functions in the package [NCGBX](#ncgbx).

Members are:

- [NCPolyGroebner](#ncpolygroebner-1)

### NCPolyGroebner

`NCPolyGroebner[G, iter]` computes the noncommutative Groebner basis
of the list of `NCPoly` polynomials `G`. The algorithm either
converges before or is interrupted when the number of iterations reach
`iter`.

`NCPolyGroebner[G, iter, options]` uses `options`.

The following `options` can be given:

- `SimplifyObstructions` (`True`) whether to remove obstructions
  before constructing more S-polynomials;
- `SortObstructions` (`False`) whether to sort obstructions using
  Mora’s SUGAR ranking;
- `SortBasis` (`False`) whether to sort basis before starting
  algorithm;
- `Labels` (`{}`) list of labels to use in verbose printing;
- `VerboseLevel` (`1`): function used to decide if a pivot is zero;
- `PrintBasis` (`False`): function used to divide a vector by an entry;
- `PrintObstructions` (`False`);
- `PrintSPolynomials` (`False`);

The algorithm is based on (Mora 1994) and uses the terminology there.

See also:
[NCPoly](#ncpoly-1).

## NCGB

Starting with version 6.0.0 our legacy Gröebner Bases algorithm that
requires both Mathematica and auxiliary executables compiled from C++
to run has been completely replaced by [NCGBX](#ncgbx).

See older versions of the NC documentation for a complete description
of the legacy C++ code functionality.

# Semidefinite Programming Algorithms

## NCSDP

**NCSDP** is a package that allows the symbolic manipulation and numeric
solution of semidefinite programs.

Members are:

- [NCSDP](#ncsdp-1)
- [NCSDPForm](#ncsdpform)
- [NCSDPDual](#ncsdpdual)
- [NCSDPDualForm](#ncsdpdualform)

### NCSDP

`NCSDP[inequalities,vars,obj,data]` converts the list of NC polynomials
and NC matrices of polynomials `inequalities` that are linear in the
unknowns listed in `vars` into the semidefinite program with linear
objective `obj`. The semidefinite program (SDP) should be given in the
following canonical form:

    max  <obj, vars>  s.t.  inequalities <= 0.

It returns a list with two entries:

- The first is a list with the an instance of [SDPSylvester](#sdpsylvester);
- The second is a list of rules with properties of certain variables.

Both entries should be supplied to [SDPSolve](#sdpsolve) in order to
numerically solve the semidefinite program. For example:

    {abc, rules} = NCSDP[inequalities, vars, obj, data];

generates an instance of [SDPSylvester](#sdpsylvester) that can be
solved using:

    << SDPSylvester`
    {Y, X, S, flags} = SDPSolve[abc, rules];

`NCSDP` uses the user supplied rules in `data` to set up the problem
data.

`NCSDP[inequalities,vars,data]` converts problem into a feasibility
semidefinite program.

`NCSDP[inequalities,vars,obj,data,options]` uses `options`.

The following `options` can be given:

- `DebugLevel` (`0`): control printing of debugging information.

See also:
[NCSDPForm](#ncsdpform), [NCSDPDual](#ncsdpdual), [SDPSolve](#sdpsolve).

### NCSDPForm

`NCSDPForm[[inequalities,vars,obj]` prints out a pretty formatted
version of the SDP expressed by the list of NC
polynomials and NC matrices of polynomials `inequalities` that are
linear in the unknowns listed in `vars`.

See also:
[NCSDP](#ncsdp-1), [NCSDPDualForm](#ncsdpdualform).

### NCSDPDual

`{dInequalities, dVars, dObj} = NCSDPDual[inequalities,vars,obj]`
calculates the symbolic dual of the SDP expressed by the list of NC
polynomials and NC matrices of polynomials `inequalities` that are
linear in the unknowns listed in `vars` with linear objective `obj`
into a dual semidefinite in the following canonical form:

    max <dObj, dVars>  s.t.  dInequalities == 0,   dVars >= 0.

`{dInequalities, dVars, dObj} = NCSDPDual[inequalities,vars,obj,dualVars]`
uses the symbols in `dualVars` as `dVars`.

`NCSDPDual[inequalities,vars,...,options]` uses `options`.

The following `options` can be given:

- `DualSymbol` (`"w"`): letter to be used as symbol for dual variable;
- `DebugLevel` (`0`): control printing of debugging information.

See also:
[NCSDPDualForm](#ncsdpdualform), [NCSDP](#ncsdp-1).

### NCSDPDualForm

`NCSDPForm[[dInequalities,dVars,dObj]` prints out a pretty formatted
version of the dual SDP expressed by the list of NC polynomials and NC
matrices of polynomials `dInequalities` that are linear in the
unknowns listed in `dVars` with linear objective `dObj`.

See also:
[NCSDPDual](#ncsdpdual), [NCSDPForm](#ncsdpform).

## SDP

`SDP` is a package that provides data structures for the numeric solution
of semidefinite programs of the form:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20b%5ET%20y%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20y%20%2B%20S%20%3D%20c%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

where ![S](https://render.githubusercontent.com/render/math?math=S&mode=inline) is a symmetric positive semidefinite matrix and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) is a
vector of decision variables.

See the package [SDP](#sdp) for a potentially more efficient
alternative to the basic implementation provided by this package.

Members are:

- [SDPMatrices](#sdpmatrices)
- [SDPSolve](#sdpsolve)
- [SDPEval](#sdpeval)
- [SDPPrimalEval](#sdpprimaleval)
- [SDPDualEval](#sdpdualeval)
- [SDPSylvesterEval](#sdpsylvestereval)

### SDPMatrices

`SDPMatrices[f, G, y]` converts the symbolic linear functions `f`,
`G` in the variables `y` associated to the semidefinite program:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%20%0A%20%20%5Cmin_y%20%5Cquad%20%26%20f%28y%29%2C%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20G%28y%29%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

into numerical data that can be used to solve an SDP in the form:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20b%5ET%20y%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20y%20%2B%20S%20%3D%20c%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

`SDPMatrices` returns a list with three entries:

- The first is the coefficient array `A`;
- The second is the coefficient array `b`;
- The third is the coefficient array `c`.

For example:

    f = -x
    G = {{1, x}, {x, 1}}
    vars = {x}
    {A,b,c} = SDPMatrices[f, G, vars]

results in

    A = {{{{0, -1}, {-1, 0}}}}
    b = {{{1}}}
    c = {{{1, 0}, {0, 1}}}

All data is stored as `SparseArray`s.

See also:
[SDPSolve](#sdpsolve).

### SDPSolve

`SDPSolve[{A,b,c}]` solves an SDP in the form:

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20b%5ET%20y%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20y%20%2B%20S%20%3D%20c%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

`SDPSolve` returns a list with four entries:

- The first is the primal solution ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline);
- The second is the dual solution ![X](https://render.githubusercontent.com/render/math?math=X&mode=inline);
- The third is the primal slack variable ![S](https://render.githubusercontent.com/render/math?math=S&mode=inline);
- The fourth is a list of flags:
  - `PrimalFeasible`: `True` if primal problem is feasible;
  - `FeasibilityRadius`: less than one if primal problem is feasible;
  - `PrimalFeasibilityMargin`: close to zero if primal problem is feasible;
  - `DualFeasible`: `True` if dual problem is feasible;
  - `DualFeasibilityRadius`: close to zero if dual problem is feasible.

For example:

    {Y, X, S, flags} = SDPSolve[abc]

solves the SDP `abc`.

`SDPSolve[{A,b,c}, options]` uses `options`.

`options` are those of [PrimalDual](#primaldual-1).

See also:
[SDPMatrices](#sdpmatrices).

### SDPEval

`SDPEval[A, y]` evaluates the linear function ![A y](https://render.githubusercontent.com/render/math?math=A%20y&mode=inline) in an `SDP`.

This is a convenient replacement for [SDPPrimalEval](#sdpprimaleval) in which the list `y` can be used directly.

See also:
[SDPPrimalEval](#sdpprimaleval),
[SDPDualEval](#sdpdualeval),
[SDPSolve](#sdpsolve),
[SDPMatrices](#sdpmatrices).

### SDPPrimalEval

`SDPPrimalEval[A, {{y}}]` evaluates the linear function ![A y](https://render.githubusercontent.com/render/math?math=A%20y&mode=inline) in an `SDP`.

See [SDPEval](#sdpeval) for a convenient replacement for `SDPPrimalEval` in which the list `y` can be used directly.

See also:
[SDPEval](#sdpeval),
[SDPDualEval](#sdpdualeval),
[SDPSolve](#sdpsolve),
[SDPMatrices](#sdpmatrices).

### SDPDualEval

`SDPDualEval[A, X]` evaluates the linear function ![A^\* X](https://render.githubusercontent.com/render/math?math=A%5E%2A%20X&mode=inline) in an `SDP`.

See also:
[SDPPrimalEval](#sdpprimaleval),
[SDPSolve](#sdpsolve),
[SDPMatrices](#sdpmatrices).

### SDPSylvesterEval

`SDPSylvesterEval[a, W]` returns a matrix
representation of the Sylvester mapping ![A^\* (W A (\Delta_y) W)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W%20A%20%28%5CDelta_y%29%20W%29&mode=inline)
when applied to the scaling `W`.

`SDPSylvesterEval[a, Wl, Wr]` returns a matrix
representation of the Sylvester mapping ![A^\* (W_l A (\Delta_y) W_r)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W_l%20A%20%28%5CDelta_y%29%20W_r%29&mode=inline)
when applied to the left- and right-scalings `Wl` and `Wr`.

See also:
[SDPPrimalEval](#sdpprimaleval),
[SDPDualEval](#sdpdualeval).

## SDPFlat

`SDPFlat` is a package that provides data structures for the numeric solution
of semidefinite programs of the form:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20b%5ET%20y%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20y%20%2B%20S%20%3D%20c%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

where ![S](https://render.githubusercontent.com/render/math?math=S&mode=inline) is a symmetric positive semidefinite matrix and ![y](https://render.githubusercontent.com/render/math?math=y&mode=inline) is a
vector of decision variables.

It is a potentially more efficient alternative to the basic
implementation provided by the package [SDP](#sdp).

Members are:

- [SDPFlatData](#sdpflatdata)
- [SDPFlatPrimalEval](#sdpflatprimaleval)
- [SDPFlatDualEval](#sdpflatdualeval)
- [SDPFlatSylvesterEval](#sdpflatsylvestereval)

### SDPFlatData

`SDPFlatData[{a,b,c}]` converts the triplet `{a,b,c}` from the format
of the package [SDP](#sdp) to the `SDPFlat` format.

It returns a list with four entries:

- The first is the input array `a`;
- The second is its flattened version `AFlat`;
- The third is the flattened version of `c`, `cFlat`;
- The fourth is an array with the flattened dimensions.

See also:
[SDP](#sdp).

### SDPFlatPrimalEval

`SDPFlatPrimalEval[aFlat, y]` evaluates the linear function ![A y](https://render.githubusercontent.com/render/math?math=A%20y&mode=inline) in an `SDPFlat`.

See also:
[SDPFlatDualEval](#sdpflatdualeval),
[SDPFlatSylvesterEval](#sdpflatsylvestereval).

### SDPFlatDualEval

`SDPFlatDualEval[aFlat, X]` evaluates the linear function ![A^\* X](https://render.githubusercontent.com/render/math?math=A%5E%2A%20X&mode=inline) in an `SDPFlat`.

See also:
[SDPFlatPrimalEval](#sdpflatprimaleval),
[SDPFlatSylvesterEval](#sdpflatsylvestereval).

### SDPFlatSylvesterEval

`SDPFlatSylvesterEval[a, aFlat, W]` returns a matrix
representation of the Sylvester mapping ![A^\* (W A (\Delta_y) W)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W%20A%20%28%5CDelta_y%29%20W%29&mode=inline)
when applied to the scaling `W`.

`SDPFlatSylvesterEval[a, aFlat, Wl, Wr]` returns a matrix
representation of the Sylvester mapping ![A^\* (W_l A (\Delta_y) W_r)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W_l%20A%20%28%5CDelta_y%29%20W_r%29&mode=inline)
when applied to the left- and right-scalings `Wl` and `Wr`.

See also:
[SDPFlatPrimalEval](#sdpflatprimaleval),
[SDPFlatDualEval](#sdpflatdualeval).

## SDPSylvester

`SDPSylvester` is a package that provides data structures for the
numeric solution of semidefinite programs of the form:

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20%5Csum_i%20%5Coperatorname%7Btrace%7D%28b_i%5ET%20y_i%29%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%20y%20%2B%20S%20%3D%20%5Cfrac%7B1%7D%7B2%7D%20%5Csum_i%20a_i%20y_i%20b_i%20%2B%20%28a_i%20y_i%20b_i%29%5ET%20%2B%20S%20%3D%20C%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

where ![S](https://render.githubusercontent.com/render/math?math=S&mode=inline) is a symmetric positive semidefinite matrix and ![y = \\ y_1, \ldots, y_n \\](https://render.githubusercontent.com/render/math?math=y%20%3D%20%5C%7B%20y_1%2C%20%5Cldots%2C%20y_n%20%5C%7D&mode=inline) is a list of matrix decision variables.

Members are:

- [SDPEval](#sdpeval-1)
- [SDPSylvesterPrimalEval](#sdpsylvesterprimaleval)
- [SDPSylvesterDualEval](#sdpsylvesterdualeval)
- [SDPSylvesterSylvesterEval](#sdpsylvestersylvestereval)

### SDPEval

`SDPEval[A, y]` evaluates the linear function ![A y = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T](https://render.githubusercontent.com/render/math?math=A%20y%20%3D%20%5Cfrac%7B1%7D%7B2%7D%20%5Csum_i%20a_i%20y_i%20b_i%20%2B%20%28a_i%20y_i%20b_i%29%5ET&mode=inline) in an `SDPSylvester`.

This is a convenient replacement for [SDPSylvesterPrimalEval](#sdpsylvesterprimaleval) in which the list `y` can be used directly.

See also:
[SDPSylvesterPrimalEval](#sdpsylvesterprimaleval),
[SDPSylvesterDualEval](#sdpsylvesterdualeval).

### SDPSylvesterPrimalEval

`SDPSylvesterPrimalEval[a, y]` evaluates the linear function ![A y = \frac{1}{2} \sum_i a_i y_i b_i + (a_i y_i b_i)^T](https://render.githubusercontent.com/render/math?math=A%20y%20%3D%20%5Cfrac%7B1%7D%7B2%7D%20%5Csum_i%20a_i%20y_i%20b_i%20%2B%20%28a_i%20y_i%20b_i%29%5ET&mode=inline) in an `SDPSylvester`.

See [SDPSylvesterEval](#sdpsylvestereval) for a convenient replacement for `SDPPrimalEval` in which the list `y` can be used directly.

See also:
[SDPSylvesterDualEval](#sdpsylvesterdualeval),
[SDPSylvesterSylvesterEval](#sdpsylvestersylvestereval).

### SDPSylvesterDualEval

`SDPSylvesterDualEval[A, X]` evaluates the linear function ![A^\* X = \\ b_1 X a_1, \cdots, b_n X a_n \\](https://render.githubusercontent.com/render/math?math=A%5E%2A%20X%20%3D%20%5C%7B%20b_1%20X%20a_1%2C%20%5Ccdots%2C%20b_n%20X%20a_n%20%5C%7D&mode=inline) in an `SDPSylvester`.

For example

See also:
[SDPSylvesterPrimalEval](#sdpsylvesterprimaleval),
[SDPSylvesterSylvesterEval](#sdpsylvestersylvestereval).

### SDPSylvesterSylvesterEval

`SDPSylvesterEval[a, W]` returns a matrix
representation of the Sylvester mapping ![A^\* (W A (\Delta_y) W)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W%20A%20%28%5CDelta_y%29%20W%29&mode=inline)
when applied to the scaling `W`.

`SDPSylvesterEval[a, Wl, Wr]` returns a matrix
representation of the Sylvester mapping ![A^\* (W_l A (\Delta_y) W_r)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W_l%20A%20%28%5CDelta_y%29%20W_r%29&mode=inline)
when applied to the left- and right-scalings `Wl` and `Wr`.

See also:
[SDPSylvesterPrimalEval](#sdpsylvesterprimaleval),
[SDPSylvesterDualEval](#sdpsylvesterdualeval).

## PrimalDual

`PrimalDual` provides an algorithm for solving a pair of primal-dual
semidefinite programs in the form

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Ctag%7BPrimal%7D%0A%5Cbegin%7Baligned%7D%0A%20%20%5Cmin_%7BX%7D%20%5Cquad%20%26%20%5Coperatorname%7Btrace%7D%28c%20X%29%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%5E%2A%28X%29%20%3D%20b%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20X%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=%5Ctag%7BDual%7D%0A%5Cbegin%7Baligned%7D%0A%20%20%5Cmax_%7By%2C%20S%7D%20%5Cquad%20%26%20b%5ET%20y%20%5C%5C%0A%20%20%5Ctext%7Bs.t.%7D%20%5Cquad%20%26%20A%28y%29%20%2B%20S%20%3D%20c%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20S%20%5Csucceq%200%0A%5Cend%7Baligned%7D)

</div>

where ![X](https://render.githubusercontent.com/render/math?math=X&mode=inline) is the primal variable and ![(y,S)](https://render.githubusercontent.com/render/math?math=%28y%2CS%29&mode=inline) are the dual variables.

The algorithm is parametrized and users should provide their own means
of evaluating the mappings ![A](https://render.githubusercontent.com/render/math?math=A&mode=inline), ![A^\*](https://render.githubusercontent.com/render/math?math=A%5E%2A&mode=inline) and also the Sylvester mapping

<div style="display:block;">

![inline equation](https://render.githubusercontent.com/render/math?math=A%5E%2A%28W_l%20A%28%5CDelta_y%29%20W_r%29)

</div>

used to solve the least-square subproblem.

Users can develop custom algorithms that can take advantage of special
structure, as done for instance in [NCSDP](#ncsdp).

The algorithm constructs a feasible solution using the Self-Dual
Embedding of \[\].

Members are:

- [PrimalDual](#primaldual-1)

### PrimalDual

`PrimalDual[PrimalEval,DualEval,SylvesterEval,b,c]`
solves the semidefinite program using a primal dual method.

`PrimalEval` should return the primal mapping ![A^\*(X)](https://render.githubusercontent.com/render/math?math=A%5E%2A%28X%29&mode=inline) when applied to
the current primal variable `X` as in `PrimalEval @@ X`.

`DualEval` should return the dual mapping ![A(y)](https://render.githubusercontent.com/render/math?math=A%28y%29&mode=inline) when applied to the
current dual variable `y` as in `DualEval @@ y`.

`SylvesterVecEval` should return a matrix representation of the
Sylvester mapping ![A^\* (W_l A (\Delta_y) W_r)](https://render.githubusercontent.com/render/math?math=A%5E%2A%20%28W_l%20A%20%28%5CDelta_y%29%20W_r%29&mode=inline) when applied to the left- and
right-scalings `Wl` and `Wr` as in `SylvesterVecEval @@ {Wl, Wr}`.

`PrimalDual[PrimalEval,DualEval,SylvesterEval,b,c,options]` uses `options`.

The following `options` can be given:

- `Method` (`PredictorCorrector`): choice of method for updating
  duality gap; possible options are `ShortStep`, `LongStep` and
  `PredictorCorrector`;

- `SearchDirection` (`NT`): choice of search direction to use;
  possible options are `NT` for Nesterov-Todd, `KSH` for HRVM/KSH/M,
  `KSHDual` for dual HRVM/KSH/M;

- `FeasibilityTol` (10^-3): tolerance used to assess feasibility;

- `GapTol` (10^-9): tolerance used to assess optimality;

- `MaxIter` (250): maximum number of iterations allowed;

- `SparseWeights` (`True`): whether weights should be converted to a
  `SparseArray`;

- `RationalizeIterates` (`False`): whether to rationalize iterates in an attempt to construct a rational solution;

- `SymmetricVariables` (`{}`): list of index of dual variables to be
  considered symmetric.

- `ScaleHessian` (`True`): whether to scale the least-squares subproblem
  coefficient matrix;

- `PrintSummary` (`True`): whether to print summary information;

- `PrintIterations` (`True`): whether to print progrees at each iteration;

- `DebugLevel` (0): whether to print debug information;

- `Profiling` (`False`): whether to print messages with detailed timing of steps.

## NCPolySOS

Members are:

- [NCPolySOS](#ncpolysos-1)
- [NCPolySOSToSDP](#ncpolysostosdp)

### NCPolySOS

`NCPolySOS[degree, var]` returns an `NCPoly` with symbolic
coefficients on the variable `var` corresponding to a possible Gram
representation of an noncommutative SOS polynomial of degree `degree`
and its corresponding Gram matrix.

`NCPolySOS[poly, var]` uses
[NCPolyQuadraticChipset](#ncpolyquadraticchipset) to generate a sparse
Gram representation of the noncommutative polynomial `poly`.

`NCPolySOS[degree]` and `NCPolySOS[p]` returns the answer in terms of
a newly created unique symbol.

For example,

    {q,Q,x} = NCPolySOS[4];

returns the symbolic SOS `NCPoly` `q` and its Gram matrix `Q`
expressed in terms of the variable `x`, and

    {q,Q,x,chipset} = NCPolySOS[poly];

returns the symbolic NCPoly `q` and its Gram matrix `Q` corresponding
to terms in the quadratic `chipset` expressed in terms of the variable
`x`.

See also:
[NCPolySOSToSDP](#ncpolysostosdp),
[NCPolyQuadraticChipset](#ncpolyquadraticchipset)

### NCPolySOSToSDP

`{sdp, vars, sol, solQ} = NCPolySOSToSDP[ps, Qs, var]` returns a
semidefinite constraint `sdp` in the variables `vars` and the rules
`sol` and `solQ` that can be used to solve for variables in the list
of SOS NCPoly `ps` and the list of Gram matrices `Qs`.

For example,

{q, Q, \$, chipset} = NCPolySOS\[poly, q\];
{sdp, vars, sol, solQ} = NCPolySOSToSDP\[{poly - q}, {Q}, z\];

generate the semidefinite constraints `spd` in the variables `vars`
which are feasible if and only if the `NCPoly` `poly` is SOS.

See also:
[NCPolySOS](#ncpolysos-1).

# Work in Progress

Sections in this chapter describe experimental packages which are
still under development.

## NCRational

This package contains functionality to convert an nc rational expression into a descriptor representation.

For example the rational

    exp = 1 + inv[1 + x]

in variables `x` and `y` can be converted into an NCPolynomial using

    p = NCToNCPolynomial[exp, {x,y}]

which returns

    p = NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

Members are:

- [NCRational](#ncrational-1)

- [NCToNCRational](#nctoncrational)

- [NCRationalToNC](#ncrationaltonc)

- [NCRationalToCanonical](#ncrationaltocanonical)

- [CanonicalToNCRational](#canonicaltoncrational)

- [NCROrder](#ncrorder)

- [NCRLinearQ](#ncrlinearq)

- [NCRStrictlyProperQ](#ncrstrictlyproperq)

- [NCRPlus](#ncrplus)

- [NCRTimes](#ncrtimes)

- [NCRTranspose](#ncrtranspose)

- [NCRInverse](#ncrinverse)

- [NCRControllableSubspace](#ncrcontrollablesubspace)

- [NCRControllableRealization](#ncrcontrollablerealization)

- [NCRObservableRealization](#ncrobservablerealization)

- [NCRMinimalRealization](#ncrminimalrealization)

### State-space realizations for NC rationals

#### NCRational

NCRational::usage

#### NCToNCRational

NCToNCRational::usage

#### NCRationalToNC

NCRationalToNC::usage

#### NCRationalToCanonical

NCRationalToCanonical::usage

#### CanonicalToNCRational

CanonicalToNCRational::usage

### Utilities

#### NCROrder

NCROrder::usage

#### NCRLinearQ

NCRLinearQ::usage

#### NCRStrictlyProperQ

NCRStrictlyProperQ::usage

### Operations on NC rationals

#### NCRPlus

NCRPlus::usage

#### NCRTimes

NCRTimes::usage

#### NCRTranspose

NCRTranspose::usage

#### NCRInverse

NCRInverse::usage

### Minimal realizations

#### NCRControllableRealization

NCRControllableRealization::usage

#### NCRControllableSubspace

NCRControllableSubspace::usage

#### NCRObservableRealization

NCRObservableRealization::usage

#### NCRMinimalRealization

NCRMinimalRealization::usage

## NCRealization

**WARNING: OBSOLETE PACKAGE WILL BE REPLACED BY NCRational**

The package **NCRealization** implements an algorithm due to N. Slinglend for producing minimal
realizations of nc rational functions in many nc variables. See “Toward Making LMIs Automatically”.

It actually computes formulas similar to those used in the paper “Noncommutative Convexity Arises From Linear Matrix Inequalities” by J William Helton, Scott A. McCullough, and Victor Vinnikov. In particular, there are functions for calculating (symmetric) minimal descriptor realizations of nc (symmetric) rational functions, and determinantal representations of polynomials.

Members are:

- Drivers:
  - [NCDescriptorRealization](#ncdescriptorrealization)
  - [NCMatrixDescriptorRealization](#ncmatrixdescriptorrealization)
  - [NCMinimalDescriptorRealization](#ncminimaldescriptorrealization)
  - [NCDeterminantalRepresentationReciprocal](#ncdeterminantalrepresentationreciprocal)
  - [NCSymmetrizeMinimalDescriptorRealization](#ncsymmetrizeminimaldescriptorrealization)
  - [NCSymmetricDescriptorRealization](#ncsymmetricdescriptorrealization)
  - [NCSymmetricDeterminantalRepresentationDirect](#ncsymmetricdeterminantalrepresentationdirect)
  - [NCSymmetricDeterminantalRepresentationReciprocal](#ncsymmetricdeterminantalrepresentationreciprocal)
  - [NonCommutativeLift](#noncommutativelift)
- Auxiliary:
  - [PinnedQ](#pinnedq)
  - [PinningSpace](#pinningspace)
  - [TestDescriptorRealization](#testdescriptorrealization)
  - [SignatureOfAffineTerm](#signatureofaffineterm)

### NCDescriptorRealization

`NCDescriptorRealization[RationalExpression,UnknownVariables]` returns a list of 3 matrices `{C,G,B}` such that ![C G^{-1} B](https://render.githubusercontent.com/render/math?math=C%20G%5E%7B-1%7D%20B&mode=inline) is the given `RationalExpression`. i.e. `NCDot[C,NCInverse[G],B] === RationalExpression`.

`C` and `B` do not contain any `UnknownsVariables` and `G` has linear entries
in the `UnknownVariables`.

### NCDeterminantalRepresentationReciprocal

`NCDeterminantalRepresentationReciprocal[Polynomial,Unknowns]` returns a linear pencil matrix whose determinant
equals `Constant * CommuteEverything[Polynomial]`. This uses the reciprocal algorithm: find a minimal descriptor realization of `inv[Polynomial]`, so `Polynomial` must be nonzero at the origin.

### NCMatrixDescriptorRealization

`NCMatrixDescriptorRealization[RationalMatrix,UnknownVariables]` is similar to `NCDescriptorRealization` except it takes a *Matrix* with rational function entries and returns a matrix of lists of the vectors/matrix `{C,G,B}`. A different `{C,G,B}` for each entry.

### NCMinimalDescriptorRealization

`NCMinimalDescriptorRealization[RationalFunction,UnknownVariables]` returns `{C,G,B}` where `NCDot[C,NCInverse[G],B] == RationalFunction`, `G` is linear in the `UnknownVariables`, and the realization is minimal (may be pinned).

### NCSymmetricDescriptorRealization

`NCSymmetricDescriptorRealization[RationalSymmetricFunction, Unknowns]` combines two steps: `NCSymmetrizeMinimalDescriptorRealization[NCMinimalDescriptorRealization[RationalSymmetricFunction, Unknowns]]`.

### NCSymmetricDeterminantalRepresentationDirect

`NCSymmetricDeterminantalRepresentationDirect[SymmetricPolynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[SymmetricPolynomial]`. This uses the direct algorithm: Find a realization of 1 - NCSymmetricPolynomial,…

### NCSymmetricDeterminantalRepresentationReciprocal

`NCSymmetricDeterminantalRepresentationReciprocal[SymmetricPolynomial,Unknowns]` returns a linear pencil matrix whose determinant equals `Constant * CommuteEverything[NCSymmetricPolynomial]`. This uses the reciprocal algorithm: find a symmetric minimal descriptor realization of `inv[NCSymmetricPolynomial]`, so NCSymmetricPolynomial must be nonzero at the origin.

### NCSymmetrizeMinimalDescriptorRealization

`NCSymmetrizeMinimalDescriptorRealization[{C,G,B},Unknowns]` symmetrizes the minimal realization `{C,G,B}` (such as output from `NCMinimalRealization`) and outputs `{Ctilda,Gtilda}` corresponding to the realization `{Ctilda, Gtilda,Transpose[Ctilda]}`.

**WARNING:** May produces errors if the realization doesn’t correspond to a symmetric rational function.

### NonCommutativeLift

`NonCommutativeLift[Rational]` returns a noncommutative symmetric lift of `Rational`.

### SignatureOfAffineTerm

`SignatureOfAffineTerm[Pencil,Unknowns]` returns a list of the number of positive, negative and zero eigenvalues in the affine part of `Pencil`.

### TestDescriptorRealization

`TestDescriptorRealization[Rat,{C,G,B},Unknowns]` checks if `Rat` equals ![C G^{-1} B](https://render.githubusercontent.com/render/math?math=C%20G%5E%7B-1%7D%20B&mode=inline) by substituting random 2-by-2 matrices in for the unknowns. `TestDescriptorRealization[Rat,{C,G,B},Unknowns,NumberOfTests]` can be used to specify the `NumberOfTests`, the default being 5.

### PinnedQ

`PinnedQ[Pencil_,Unknowns_]` is True or False.

### PinningSpace

`PinningSpace[Pencil_,Unknowns_]` returns a matrix whose columns span the pinning space of `Pencil`. Generally, either an empty matrix or a d-by-1 matrix (vector).

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-camino:MIS:2003" class="csl-entry">

Camino, Juan F., John William Helton, Robert E. Skelton, and Jieping Ye. 2003. “<span class="nocase">Matrix Inequalities: a Symbolic Procedure to Determine Convexity Automatically</span>.” *Integral Equation and Operator Theory* 46 (4): 399–454.

</div>

<div id="ref-mora:ICN:1994" class="csl-entry">

Mora, Teo. 1994. “An Introduction to Commutative and Noncommutative Groebner Bases.” *Theoretical Computer Science* 134: 131–73.

</div>

<div id="ref-oliveira:SSP:2012" class="csl-entry">

Oliveira, Mauricio C. de. 2012. “<span class="nocase">Simplification of symbolic polynomials on non-commutative variables</span>.” *Linear Algebra and Its Applications* 437 (7): 1734–48. <https://doi.org/10.1016/j.laa.2012.05.015>.

</div>

</div>

[^1]: Math, UCSD, La Jolla, CA

[^2]: MAE, UCSD, La Jolla, CA

[^3]: The transpose of the gradient of the nc expression `expr` is the derivative with respect to the direction `h` of the trace of the directional derivative of `expr` in the direction `h`.

[^4]: Contrary to what happens with symbolic inversion of matrices
    with commutative entries, there exist multiple formulas for the
    symbolic inverse of a matrix with noncommutative entries. Furthermore,
    it may be possible that none of such formulas is “correct”. Indeed, it
    is easy to construct a matrix `m` with block structure as shown that
    is invertible but for which none of the blocks `a`, `b`, `c`, and `d`
    are invertible. In this case no *correct* formula exists for the
    calculation of the inverse of `m`.

[^5]: This is in contrast with the commutative ![x^4](https://render.githubusercontent.com/render/math?math=x%5E4&mode=inline) which is
    convex everywhere. See (Camino et al. 2003) for details.

[^6]: The reason is that making an operator `Flat` is a
    convenience that comes with a price: lack of control over execution
    and evaluation. Since `NCAlgebra` has to operate at a very low level
    this lack of control over evaluation is fatal. Indeed, making
    `NonCommutativeMultiply` have an attribute `Flat` will throw
    Mathematica into infinite loops in seemingly trivial noncommutative
    expressions. Hey, email us if you find a way around that :)

[^7]: One might have encountered this difficulty when trying to
    match a product of commutative variables in a commutative monomial
    such as `x y^2 /. x y -> z` which fails to match `x y^2` even though
    `x y^2` is equal to `(x y) y`.

[^8]: The actual rule in this case is the more complicated
    `a^n:_Integer?Positive:1**c**b^m:_Integer?Positive:1 -> a^(n-1)**d**b^(m-1)`
    with additional checks that prevent the rule from working with
    negative powers.

[^9]: By the way, I find that behavior of Mathematica’s `Module`
    questionable, since something like

        F[exp_] := Module[{aa, bb},
          SetNonCommutative[aa, bb];
          aa**bb
        ]

    would not fail to treat `aa` and `bb` locally. It is their
    appearance in a rule that triggers the mostly odd behavior.

[^10]: Formerly `MatMult[m1,m2]`.
