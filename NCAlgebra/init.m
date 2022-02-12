BeginPackage["NCAlgebra`",
	     {"NC`",
	      "NonCommutativeMultiply`",
	      "NCTr`",
              "NCCollect`",
              "NCDiff`",
              "NCDot`",
              "NCReplace`",
              "NCMatrixDecompositions`",
              "NCSimplifyRational`",
              "NCDeprecated`",
              "NCPolyInterface`",
              "NCOutput`"}];

NCAlgebra::SmallCapSymbolsNonCommutative = "All lower cap single letter symbols (e.g. a,b,c,...) were set as noncommutative.";
NCAlgebra::NoSymbolsNonCommutative = "No symbols were set as noncommutative. Use SetNonCommutative to set noncommutative symbols.";

Begin["`Private`"];

  verbose = If[ValueQ[$NCAlgebra$Loaded], False, $NCAlgebra$Loaded=True];

  (* Print banner *)
  If [ verbose && ShowBanner /. Options[NC, ShowBanner], FilePrint[FindFile["banner.txt"]]];

  
  If[ SmallCapSymbolsNonCommutative /. Options[NC, SmallCapSymbolsNonCommutative]
     ,
      (* Sets all lower case letters to be NonCommutative *)
      SetNonCommutativeHold[Global`a, Global`b, Global`c, Global`d, Global`e,
  			    Global`f, Global`g, Global`h, Global`i, Global`j,
			    Global`k, Global`l, Global`m, Global`n, Global`o,
			    Global`p, Global`q, Global`r, Global`s, Global`t,
			    Global`u, Global`v, Global`w, Global`x, Global`y,
			    Global`z];
      Message[NCAlgebra::SmallCapSymbolsNonCommutative];
     ,
      Message[NCAlgebra::NoSymbolsNonCommutative];
  ];

End[];

EndPackage[];
