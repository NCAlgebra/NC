SetOptions[$Output,PageWidth->1000];

Quiet[Get["NC`"], {NC`NC::Directory, Get::noopen}];
<< NCOptions`
SetOptions[NCOptions,
           SmallCapSymbolsNonCommutative -> False,
	   ShowBanner -> False];
Quiet[Get["NCAlgebra`"], NCAlgebra`NCAlgebra::NoSymbolsNonCommutative];
<< NCGBX`
<< NCTest`

Print["> BEGIN NCPOLYTESTGB\n" ];

prefix = "NCAlgebra/TESTING/NCPoly/"
tests = {
  "NCMakeGB"
};
results = NCTestRun[tests, prefix];
NCTestSummarize[results];

Print["\n> END NCPOLYTESTGB\n" ];

Print["> EVEN IF ALL THE TESTS SUCCEEDED YOU SHOULD QUIT THE KERNEL"]
Print["  IN YOUR MATHEMATICA SESSION AND START OVER." ];
