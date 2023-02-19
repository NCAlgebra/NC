SetOptions[$Output,PageWidth->1000];

Quiet[Get["NC`"], {NC`NC::Directory, Get::noopen}];
Get["NCOptions`"];
SetOptions[NCOptions,
           SmallCapSymbolsNonCommutative -> False,
	   ShowBanner -> False];
Quiet[Get["NCAlgebra`"], NCAlgebra`NCAlgebra::NoSymbolsNonCommutative];
<< NCTest`

Print["> BEGIN NCTEST\n" ];

prefix = "NCAlgebra/TESTING/NCAlgebra/"
tests = {
  "CommutativeQ",
  "NCMultiplication",
  "NCUtil",
  "NCDeprecated",
  "NCSymmetric",
  "NCSelfAdjoint",
  "NCReplace",
  "NCPolynomial",
  "NCSimplifyRational",
  "NCSylvester",
  "NCDiff",
  "NCQuadratic",
  "MatrixDecompositions",
  "NCMatrixDecompositions",
  "NCCollect",
  "NCInverse",
  "NCDot",
  "NCRoots",
  "NCConjugate",
  "NCTr",
  "Matrix", 
  "NCOutput",
  "NCConvexity"
  (*,
  "NCRational",
  "NCRealization",
  "NCSystem"
  "NCSolve" 
  *)
};
results = NCTestRun[tests, prefix];
NCTestSummarize[results];

Print["\n> END NCTEST\n" ];

Print["> EVEN IF ALL THE TESTS SUCCEEDED YOU SHOULD QUIT THE KERNEL"]
Print["  IN YOUR MATHEMATICA SESSION AND START OVER." ];
