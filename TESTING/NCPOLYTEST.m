SetOptions[$Output,PageWidth->1000];

Quiet[Get["NC`"], {NC`NC::Directory, Get::noopen}];
<< NCTest`
<< NCPoly`

Print["> BEGIN NCPOLYTEST\n" ];

prefix = "NCAlgebra/TESTING/NCPoly/";
tests = {
  "Digits",
  "Constructors",
  "Arithmetic",
  "Product",
  "Reduce",
  "CoeffArray",
  "GramMatrix",
  "Groebner",
  "Hankel",
  "NCPolyInterface",
  "NCGBX",
  "NCPolySOS"
};
results = NCTestRun[tests, prefix];
NCTestSummarize[results];

Print["\n> END NCPOLYTEST\n" ];

Print["> EVEN IF ALL THE TESTS SUCCEEDED YOU SHOULD QUIT THE KERNEL"]
Print["  IN YOUR MATHEMATICA SESSION AND START OVER." ];
