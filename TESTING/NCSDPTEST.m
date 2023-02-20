SetOptions[$Output,PageWidth->1000];

Quiet[Get["NC`"], {NC`NC::Directory, Get::noopen}];
<< NCTest`

Print["> BEGIN NCSDPTEST\n" ];

prefix = "NCAlgebra/TESTING/NCSDP/";
tests = {
  "SDPLinearCoefficientArrays",
  "SDPEval",
  "SDPSylvester1",
  "SDPSylvester2",
  "SDPSedumi",
  "NCSDP",
  "SDPSylvesterSolve"
};
results = NCTestRun[tests, prefix];
NCTestSummarize[results];

Print["\n> END NCSDPTEST\n" ];

Print["> EVEN IF ALL THE TESTS SUCCEEDED YOU SHOULD QUIT THE KERNEL"]
Print["  IN YOUR MATHEMATICA SESSION AND START OVER." ];
