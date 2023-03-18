SetOptions[$Output,PageWidth->1000];

Quiet[Get["NC`"], {NC`NC::Directory, Get::noopen}];
<< NCTest`

Print["> BEGIN NCSDPTESTMORE\n" ];

prefix = "NCAlgebra/TESTING/NCSDP/";
tests = {
  "SDPSolveMore"
};
results = NCTestRun[tests, prefix];
NCTestSummarize[results];

Print["\n> END NCSDPTESTMORE\n" ];

Print["> EVEN IF ALL THE TESTS SUCCEEDED YOU SHOULD QUIT THE KERNEL"]
Print["  IN YOUR MATHEMATICA SESSION AND START OVER." ];
